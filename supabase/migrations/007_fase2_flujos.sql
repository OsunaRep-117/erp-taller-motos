-- Fase 2: flujos de negocio sobre esquema Fase 1 (§5.1, §5.6, §6.8, §6.12)
-- Aditivo: RPCs nuevos; no elimina flujos existentes.

-- ---------------------------------------------------------
-- Aprobar presupuesto (§5.1): habilita soft allocation
-- ---------------------------------------------------------
CREATE OR REPLACE FUNCTION public.aprobar_presupuesto(p_id_orden uuid)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  UPDATE public.ordenes_trabajo
  SET fecha_aprobacion_presupuesto = NOW(),
      estado = 'en_proceso'
  WHERE id = p_id_orden
    AND estado IN ('esperando_aprobacion', 'en_proceso', 'esperando_piezas');

  IF NOT FOUND THEN
    RAISE EXCEPTION 'La orden no está en estado válido para aprobar presupuesto';
  END IF;
END;
$$;

-- ---------------------------------------------------------
-- Reapertura admin (§5.1): terminado → en_proceso
-- ---------------------------------------------------------
CREATE OR REPLACE FUNCTION public.reabrir_orden(p_id_orden uuid)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF NOT public.is_admin() THEN
    RAISE EXCEPTION 'Solo un administrador puede reabrir la orden';
  END IF;

  UPDATE public.ordenes_trabajo
  SET estado = 'en_proceso',
      fecha_terminado = NULL
  WHERE id = p_id_orden
    AND estado = 'terminado';

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Solo se puede reabrir una orden en estado terminado';
  END IF;
END;
$$;

-- ---------------------------------------------------------
-- Extensión de cotización post-aprobación (§5.1 / §6.13)
-- ---------------------------------------------------------
CREATE OR REPLACE FUNCTION public.solicitar_extension_cotizacion(
  p_id_orden uuid,
  p_descripcion text,
  p_monto_adicional numeric
)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_id uuid := gen_random_uuid();
BEGIN
  IF p_monto_adicional <= 0 THEN
    RAISE EXCEPTION 'El monto adicional debe ser mayor a cero';
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM public.ordenes_trabajo
    WHERE id = p_id_orden AND fecha_aprobacion_presupuesto IS NOT NULL
      AND estado NOT IN ('terminado', 'pagado', 'entregado', 'cancelada')
  ) THEN
    RAISE EXCEPTION 'La orden debe tener presupuesto aprobado y estar activa';
  END IF;

  INSERT INTO public.extension_cotizacion (id, id_orden, descripcion, monto_adicional)
  VALUES (v_id, p_id_orden, p_descripcion, p_monto_adicional);

  RETURN v_id;
END;
$$;

CREATE OR REPLACE FUNCTION public.aprobar_extension_cotizacion(p_id_extension uuid)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF NOT public.is_supervisor_or_admin() THEN
    RAISE EXCEPTION 'Solo supervisor o admin puede aprobar extensiones';
  END IF;

  UPDATE public.extension_cotizacion
  SET estado = 'aprobada'
  WHERE id = p_id_extension AND estado = 'pendiente';

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Extensión no encontrada o ya procesada';
  END IF;
END;
$$;

-- Gate reserva refacción: presupuesto aprobado (+ extensión si ya hay reservas)
ALTER TABLE public.extension_cotizacion
  ADD COLUMN IF NOT EXISTS utilizada BOOLEAN NOT NULL DEFAULT false;

CREATE OR REPLACE FUNCTION public.reservar_refaccion_para_orden(
  p_id_orden uuid,
  p_sku text,
  p_cantidad integer,
  p_precio_unitario numeric,
  p_id_usuario uuid
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_disponible integer;
  v_extension uuid;
BEGIN
  IF p_cantidad <= 0 THEN
    RAISE EXCEPTION 'Cantidad inválida';
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM public.ordenes_trabajo
    WHERE id = p_id_orden AND fecha_aprobacion_presupuesto IS NOT NULL
  ) THEN
    RAISE EXCEPTION 'Debe aprobar el presupuesto antes de reservar refacciones';
  END IF;

  IF EXISTS (SELECT 1 FROM public.reservas_refaccion_ot WHERE id_orden = p_id_orden) THEN
    SELECT id INTO v_extension
    FROM public.extension_cotizacion
    WHERE id_orden = p_id_orden
      AND estado = 'aprobada'
      AND utilizada = false
    ORDER BY fecha_solicitud
    LIMIT 1;

    IF v_extension IS NULL THEN
      RAISE EXCEPTION 'Se requiere una extensión de cotización aprobada para agregar refacciones';
    END IF;

    UPDATE public.extension_cotizacion SET utilizada = true WHERE id = v_extension;
  END IF;

  SELECT (stock_actual - stock_reservado) INTO v_disponible
  FROM public.refacciones
  WHERE sku = p_sku AND inactivo = false
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Refacción no encontrada o inactiva';
  END IF;

  IF v_disponible < p_cantidad THEN
    RAISE EXCEPTION 'Stock insuficiente para %', p_sku;
  END IF;

  UPDATE public.refacciones
  SET stock_reservado = stock_reservado + p_cantidad
  WHERE sku = p_sku;

  INSERT INTO public.reservas_refaccion_ot (id_orden, sku, cantidad, precio_unitario)
  VALUES (p_id_orden, p_sku, p_cantidad, p_precio_unitario)
  ON CONFLICT (id_orden, sku) DO UPDATE
  SET cantidad = public.reservas_refaccion_ot.cantidad + EXCLUDED.cantidad,
      precio_unitario = EXCLUDED.precio_unitario;
END;
$$;

-- ---------------------------------------------------------
-- Órdenes de compra (§6.8) — flujo borrador → aprobada → recibida
-- ---------------------------------------------------------
CREATE OR REPLACE FUNCTION public.crear_orden_compra(
  p_id_proveedor uuid,
  p_items jsonb
)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_id uuid := gen_random_uuid();
  v_item jsonb;
BEGIN
  IF NOT public.is_supervisor_or_admin() THEN
    RAISE EXCEPTION 'Sin permisos para crear órdenes de compra';
  END IF;

  INSERT INTO public.ordenes_compra (id, id_proveedor, estado)
  VALUES (v_id, p_id_proveedor, 'borrador');

  FOR v_item IN SELECT * FROM jsonb_array_elements(p_items)
  LOOP
    INSERT INTO public.compra_detalle (id_compra, sku_refaccion, cantidad, precio_compra)
    VALUES (
      v_id,
      v_item ->> 'sku',
      (v_item ->> 'cantidad')::integer,
      (v_item ->> 'precio_compra')::numeric
    );
  END LOOP;

  RETURN v_id;
END;
$$;

CREATE OR REPLACE FUNCTION public.aprobar_orden_compra(p_id_compra uuid)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF NOT public.is_supervisor_or_admin() THEN
    RAISE EXCEPTION 'Sin permisos para aprobar órdenes de compra';
  END IF;

  UPDATE public.ordenes_compra
  SET estado = 'aprobada'
  WHERE id = p_id_compra AND estado = 'borrador';

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Orden de compra no encontrada o no está en borrador';
  END IF;
END;
$$;

CREATE OR REPLACE FUNCTION public.recibir_orden_compra(p_id_compra uuid)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_proveedor uuid;
  v_det record;
BEGIN
  IF NOT public.is_supervisor_or_admin() THEN
    RAISE EXCEPTION 'Sin permisos para recibir órdenes de compra';
  END IF;

  SELECT id_proveedor INTO v_proveedor
  FROM public.ordenes_compra
  WHERE id = p_id_compra AND estado = 'aprobada'
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'La orden de compra debe estar aprobada para recibirse';
  END IF;

  FOR v_det IN
    SELECT sku_refaccion, cantidad, precio_compra
    FROM public.compra_detalle
    WHERE id_compra = p_id_compra
  LOOP
    PERFORM public.incrementar_stock(v_det.sku_refaccion, v_det.cantidad);
    INSERT INTO public.entradas_inventario (sku, cantidad, costo_unitario, id_proveedor)
    VALUES (v_det.sku_refaccion, v_det.cantidad, v_det.precio_compra, v_proveedor);
  END LOOP;

  UPDATE public.ordenes_compra
  SET estado = 'recibida'
  WHERE id = p_id_compra;
END;
$$;

-- ---------------------------------------------------------
-- OPEX (§6.12)
-- ---------------------------------------------------------
CREATE OR REPLACE FUNCTION public.registrar_gasto_operativo(
  p_concepto text,
  p_monto numeric,
  p_categoria text DEFAULT NULL
)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_id uuid := gen_random_uuid();
BEGIN
  IF NOT public.is_supervisor_or_admin() THEN
    RAISE EXCEPTION 'Sin permisos para registrar gastos operativos';
  END IF;

  IF p_monto <= 0 THEN
    RAISE EXCEPTION 'Monto inválido';
  END IF;

  INSERT INTO public.gastos_operativos (id, concepto, categoria, monto)
  VALUES (v_id, p_concepto, p_categoria, p_monto);

  RETURN v_id;
END;
$$;
