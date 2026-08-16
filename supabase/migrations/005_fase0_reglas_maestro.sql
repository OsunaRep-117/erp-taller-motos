-- Fase 0: reglas Documento Maestro (§5.1, §5.3, §5.4, §5.5)
-- Aditiva: reemplaza funciones RPC sin eliminar tablas existentes.

-- Porcentaje comisión por mecánico (§5.5, §6.4)
ALTER TABLE public.empleados
  ADD COLUMN IF NOT EXISTS porcentaje_comision NUMERIC(5,4) NOT NULL DEFAULT 0.08;

-- Exposición crédito B2B: saldo pendiente en OT activas del cliente (§5.4)
CREATE OR REPLACE FUNCTION public.calcular_exposicion_credito(p_id_cliente uuid)
RETURNS numeric
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT COALESCE((
    SELECT SUM(o.saldo_pendiente)
    FROM public.ordenes_trabajo o
    INNER JOIN public.motocicletas m ON m.vin = o.id_moto
    WHERE m.id_cliente = p_id_cliente
      AND o.estado NOT IN ('entregado', 'cancelada')
      AND o.saldo_pendiente > 0
  ), 0);
$$;

-- Terminar OT: solo mecánico asignado (§5.1)
CREATE OR REPLACE FUNCTION public.terminar_orden_calculando_saldo(p_id_orden uuid)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_horas numeric;
  v_costo_ref numeric;
  v_saldo numeric;
  v_mecanico uuid;
  v_tarifa constant numeric := 350;
BEGIN
  SELECT horas_facturables, id_mecanico INTO v_horas, v_mecanico
  FROM public.ordenes_trabajo
  WHERE id = p_id_orden
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Orden no encontrada';
  END IF;

  IF v_mecanico IS NULL THEN
    RAISE EXCEPTION 'La orden no tiene mecánico asignado';
  END IF;

  IF v_mecanico <> auth.uid() AND NOT public.is_admin() THEN
    RAISE EXCEPTION 'Solo el mecánico asignado puede marcar la orden como terminada';
  END IF;

  SELECT COALESCE(SUM(cantidad * precio_unitario), 0) INTO v_costo_ref
  FROM public.reservas_refaccion_ot
  WHERE id_orden = p_id_orden;

  v_saldo := v_costo_ref + (COALESCE(v_horas, 0) * v_tarifa);

  PERFORM public.confirmar_salida_inventario_por_orden(p_id_orden, auth.uid());

  UPDATE public.ordenes_trabajo
  SET estado = 'terminado',
      saldo_pendiente = v_saldo,
      fecha_terminado = NOW()
  WHERE id = p_id_orden;
END;
$$;

-- Pago: comisión solo sobre mano de obra al estado Pagado (§5.5)
CREATE OR REPLACE FUNCTION public.registrar_pago(
  p_id_orden uuid,
  p_monto numeric,
  p_metodo_pago text
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_orden record;
  v_pagado numeric;
  v_nuevo_saldo numeric;
  v_mano_obra numeric;
  v_porcentaje numeric;
  v_tarifa constant numeric := 350;
BEGIN
  IF p_monto <= 0 THEN
    RAISE EXCEPTION 'Monto inválido';
  END IF;

  SELECT * INTO v_orden FROM public.ordenes_trabajo WHERE id = p_id_orden FOR UPDATE;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Orden no encontrada';
  END IF;

  SELECT COALESCE(SUM(monto), 0) INTO v_pagado
  FROM public.pagos
  WHERE id_orden = p_id_orden AND id_pago_revertido IS NULL AND monto > 0;

  IF v_pagado + p_monto > v_orden.saldo_pendiente + 0.01 THEN
    RAISE EXCEPTION 'El pago excede el saldo pendiente';
  END IF;

  INSERT INTO public.pagos (id_orden, monto, metodo_pago)
  VALUES (p_id_orden, p_monto, p_metodo_pago);

  v_nuevo_saldo := GREATEST(v_orden.saldo_pendiente - p_monto, 0);

  IF v_nuevo_saldo <= 0.01 AND v_orden.id_mecanico IS NOT NULL THEN
    v_mano_obra := COALESCE(v_orden.horas_facturables, 0) * v_tarifa;

    SELECT COALESCE(e.porcentaje_comision, 0.08) INTO v_porcentaje
    FROM public.empleados e
    WHERE e.id = v_orden.id_mecanico;

    INSERT INTO public.comisiones (id_orden, id_mecanico, monto, porcentaje_aplicado)
    VALUES (
      p_id_orden,
      v_orden.id_mecanico,
      v_mano_obra * v_porcentaje,
      v_porcentaje
    );
  END IF;

  UPDATE public.ordenes_trabajo
  SET saldo_pendiente = v_nuevo_saldo,
      estado = CASE WHEN v_nuevo_saldo <= 0.01 THEN 'pagado' ELSE estado END
  WHERE id = p_id_orden;
END;
$$;

-- POS: no vender bajo costo (§5.3)
CREATE OR REPLACE FUNCTION public.registrar_venta_mostrador(
  p_items jsonb,
  p_id_usuario uuid,
  p_metodo_pago text DEFAULT 'efectivo'
)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_item jsonb;
  v_sku text;
  v_cantidad integer;
  v_precio numeric;
  v_costo numeric;
  v_disponible integer;
  v_id_venta uuid := gen_random_uuid();
BEGIN
  IF jsonb_array_length(p_items) = 0 THEN
    RAISE EXCEPTION 'Carrito vacío';
  END IF;

  FOR v_item IN SELECT * FROM jsonb_array_elements(p_items)
  LOOP
    v_sku := v_item ->> 'sku';
    v_cantidad := (v_item ->> 'cantidad')::integer;
    v_precio := (v_item ->> 'precio_unitario')::numeric;

    SELECT precio_costo, (stock_actual - stock_reservado)
    INTO v_costo, v_disponible
    FROM public.refacciones
    WHERE sku = v_sku AND inactivo = false
    FOR UPDATE;

    IF NOT FOUND THEN
      RAISE EXCEPTION 'Refacción no encontrada: %', v_sku;
    END IF;

    IF v_disponible < v_cantidad THEN
      RAISE EXCEPTION 'Stock insuficiente para %', v_sku;
    END IF;

    IF v_precio < v_costo THEN
      RAISE EXCEPTION 'El precio de venta (%) no puede ser menor al costo (%) para %', v_precio, v_costo, v_sku;
    END IF;

    UPDATE public.refacciones
    SET stock_actual = stock_actual - v_cantidad
    WHERE sku = v_sku;
  END LOOP;

  INSERT INTO public.ventas_pos (id, id_usuario, metodo_pago)
  VALUES (v_id_venta, p_id_usuario, COALESCE(p_metodo_pago, 'efectivo'));

  FOR v_item IN SELECT * FROM jsonb_array_elements(p_items)
  LOOP
    INSERT INTO public.ventas_pos_items (id_venta, sku, cantidad, precio_unitario)
    VALUES (
      v_id_venta,
      v_item ->> 'sku',
      (v_item ->> 'cantidad')::integer,
      (v_item ->> 'precio_unitario')::numeric
    );
  END LOOP;

  RETURN v_id_venta;
END;
$$;
