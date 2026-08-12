-- =========================================================
-- ERP Taller de Motocicletas — esquema inicial Supabase
-- Ejecutar en: Supabase Dashboard → SQL Editor
-- =========================================================

BEGIN;

CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ---------------------------------------------------------
-- Tablas
-- ---------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.empleados (
  id                  UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  nombre              TEXT NOT NULL,
  email               TEXT NOT NULL UNIQUE,
  rol                 TEXT NOT NULL CHECK (rol IN ('admin', 'recepcionista', 'mecanico', 'supervisor')),
  activo              BOOLEAN NOT NULL DEFAULT true,
  fecha_contratacion  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.clientes (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nombre_completo TEXT NOT NULL,
  telefono        TEXT NOT NULL DEFAULT '',
  rfc             TEXT,
  limite_credito  NUMERIC(12,2) NOT NULL DEFAULT 0,
  es_flotilla     BOOLEAN NOT NULL DEFAULT false,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.motocicletas (
  vin         TEXT PRIMARY KEY,
  placa       TEXT NOT NULL,
  marca       TEXT NOT NULL,
  modelo      TEXT NOT NULL,
  anio        INTEGER NOT NULL CHECK (anio BETWEEN 1980 AND 2100),
  id_cliente  UUID NOT NULL REFERENCES public.clientes(id) ON DELETE RESTRICT,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.refacciones (
  sku             TEXT PRIMARY KEY,
  nombre          TEXT NOT NULL,
  precio_costo    NUMERIC(12,2) NOT NULL DEFAULT 0 CHECK (precio_costo >= 0),
  precio_venta    NUMERIC(12,2) NOT NULL DEFAULT 0 CHECK (precio_venta >= 0),
  stock_actual    INTEGER NOT NULL DEFAULT 0 CHECK (stock_actual >= 0),
  stock_reservado INTEGER NOT NULL DEFAULT 0 CHECK (stock_reservado >= 0),
  stock_minimo    INTEGER NOT NULL DEFAULT 0 CHECK (stock_minimo >= 0),
  inactivo        BOOLEAN NOT NULL DEFAULT false,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.ordenes_trabajo (
  id                       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  id_moto                  TEXT NOT NULL REFERENCES public.motocicletas(vin) ON DELETE RESTRICT,
  id_mecanico              UUID REFERENCES public.empleados(id) ON DELETE SET NULL,
  estado                   TEXT NOT NULL DEFAULT 'pendiente' CHECK (estado IN (
    'pendiente', 'en_proceso', 'esperando_aprobacion', 'esperando_piezas',
    'terminado', 'pagado', 'entregado', 'cancelada'
  )),
  falla_reportada          TEXT NOT NULL DEFAULT '',
  horas_facturables        NUMERIC(8,2) NOT NULL DEFAULT 0 CHECK (horas_facturables >= 0),
  saldo_pendiente          NUMERIC(12,2) NOT NULL DEFAULT 0 CHECK (saldo_pendiente >= 0),
  fecha_creacion           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  fecha_inicio_reparacion  TIMESTAMPTZ,
  fecha_terminado          TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS public.historial_estados_ot (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  id_orden         UUID NOT NULL REFERENCES public.ordenes_trabajo(id) ON DELETE CASCADE,
  estado_anterior  TEXT,
  estado_nuevo     TEXT NOT NULL,
  fecha_cambio     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  id_usuario       UUID NOT NULL REFERENCES public.empleados(id) ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS public.reservas_refaccion_ot (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  id_orden         UUID NOT NULL REFERENCES public.ordenes_trabajo(id) ON DELETE CASCADE,
  sku              TEXT NOT NULL REFERENCES public.refacciones(sku) ON DELETE RESTRICT,
  cantidad         INTEGER NOT NULL CHECK (cantidad > 0),
  precio_unitario  NUMERIC(12,2) NOT NULL CHECK (precio_unitario >= 0),
  created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (id_orden, sku)
);

CREATE TABLE IF NOT EXISTS public.evidencias_ot (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  id_orden      UUID NOT NULL REFERENCES public.ordenes_trabajo(id) ON DELETE CASCADE,
  storage_path  TEXT NOT NULL,
  etapa         TEXT NOT NULL,
  subida_por    UUID NOT NULL REFERENCES public.empleados(id) ON DELETE RESTRICT,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.proveedores (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nombre     TEXT NOT NULL,
  contacto   TEXT NOT NULL DEFAULT '',
  rfc        TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.entradas_inventario (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  sku             TEXT NOT NULL REFERENCES public.refacciones(sku) ON DELETE RESTRICT,
  cantidad        INTEGER NOT NULL CHECK (cantidad > 0),
  costo_unitario  NUMERIC(12,2) NOT NULL CHECK (costo_unitario >= 0),
  id_proveedor    UUID NOT NULL REFERENCES public.proveedores(id) ON DELETE RESTRICT,
  fecha           TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.ajustes_inventario (
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  sku            TEXT NOT NULL REFERENCES public.refacciones(sku) ON DELETE RESTRICT,
  cantidad       INTEGER NOT NULL,
  justificacion  TEXT NOT NULL,
  id_usuario     UUID NOT NULL REFERENCES public.empleados(id) ON DELETE RESTRICT,
  fecha          TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.pagos (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  id_orden          UUID NOT NULL REFERENCES public.ordenes_trabajo(id) ON DELETE RESTRICT,
  monto             NUMERIC(12,2) NOT NULL,
  metodo_pago       TEXT NOT NULL CHECK (metodo_pago IN ('efectivo', 'tarjeta', 'transferencia', 'creditoB2B')),
  id_pago_revertido UUID REFERENCES public.pagos(id) ON DELETE SET NULL,
  fecha_pago        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.facturas (
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  id_orden       UUID NOT NULL REFERENCES public.ordenes_trabajo(id) ON DELETE RESTRICT,
  folio_fiscal   TEXT NOT NULL,
  rfc_receptor   TEXT NOT NULL,
  estado         TEXT NOT NULL DEFAULT 'vigente' CHECK (estado IN ('vigente', 'cancelada')),
  fecha_emision  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.notas_credito (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  id_factura  UUID NOT NULL REFERENCES public.facturas(id) ON DELETE RESTRICT,
  motivo      TEXT NOT NULL,
  monto       NUMERIC(12,2) NOT NULL CHECK (monto >= 0),
  fecha       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.comisiones (
  id                   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  id_orden             UUID NOT NULL REFERENCES public.ordenes_trabajo(id) ON DELETE RESTRICT,
  id_mecanico          UUID NOT NULL REFERENCES public.empleados(id) ON DELETE RESTRICT,
  monto                NUMERIC(12,2) NOT NULL CHECK (monto >= 0),
  porcentaje_aplicado  NUMERIC(5,4) NOT NULL DEFAULT 0.08,
  fecha_generada       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.ventas_pos (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  id_usuario   UUID NOT NULL REFERENCES public.empleados(id) ON DELETE RESTRICT,
  metodo_pago  TEXT NOT NULL DEFAULT 'efectivo',
  fecha        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.ventas_pos_items (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  id_venta         UUID NOT NULL REFERENCES public.ventas_pos(id) ON DELETE CASCADE,
  sku              TEXT NOT NULL REFERENCES public.refacciones(sku) ON DELETE RESTRICT,
  cantidad         INTEGER NOT NULL CHECK (cantidad > 0),
  precio_unitario  NUMERIC(12,2) NOT NULL CHECK (precio_unitario >= 0)
);

-- ---------------------------------------------------------
-- Helpers de rol (RLS) — después de crear empleados
-- ---------------------------------------------------------
CREATE OR REPLACE FUNCTION public.current_empleado_rol()
RETURNS text
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT rol FROM public.empleados
  WHERE id = auth.uid() AND activo = true;
$$;

CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT public.current_empleado_rol() = 'admin';
$$;

CREATE OR REPLACE FUNCTION public.is_supervisor_or_admin()
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT public.current_empleado_rol() IN ('admin', 'supervisor');
$$;

CREATE OR REPLACE FUNCTION public.is_empleado_activo()
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.empleados
    WHERE id = auth.uid() AND activo = true
  );
$$;

CREATE OR REPLACE VIEW public.refacciones_pos
WITH (security_invoker = true)
AS
SELECT sku, nombre, precio_venta, stock_actual, stock_reservado, inactivo
FROM public.refacciones;

-- ---------------------------------------------------------
-- Trigger historial de estados OT
-- ---------------------------------------------------------
CREATE OR REPLACE FUNCTION public.registrar_historial_estado_ot()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    INSERT INTO public.historial_estados_ot (id_orden, estado_anterior, estado_nuevo, id_usuario)
    VALUES (NEW.id, NULL, NEW.estado, auth.uid());
  ELSIF TG_OP = 'UPDATE' AND NEW.estado IS DISTINCT FROM OLD.estado THEN
    INSERT INTO public.historial_estados_ot (id_orden, estado_anterior, estado_nuevo, id_usuario)
    VALUES (NEW.id, OLD.estado, NEW.estado, auth.uid());
  END IF;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_historial_estado_ot ON public.ordenes_trabajo;
CREATE TRIGGER trg_historial_estado_ot
AFTER INSERT OR UPDATE OF estado ON public.ordenes_trabajo
FOR EACH ROW EXECUTE FUNCTION public.registrar_historial_estado_ot();

-- ---------------------------------------------------------
-- RPCs
-- ---------------------------------------------------------
CREATE OR REPLACE FUNCTION public.incrementar_stock(p_sku text, p_cantidad integer)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF p_cantidad <= 0 THEN
    RAISE EXCEPTION 'Cantidad inválida';
  END IF;

  UPDATE public.refacciones
  SET stock_actual = stock_actual + p_cantidad
  WHERE sku = p_sku AND inactivo = false;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Refacción no encontrada';
  END IF;
END;
$$;

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
BEGIN
  IF p_cantidad <= 0 THEN
    RAISE EXCEPTION 'Cantidad inválida';
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

CREATE OR REPLACE FUNCTION public.confirmar_salida_inventario_por_orden(
  p_id_orden uuid,
  p_id_usuario uuid
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  r record;
BEGIN
  FOR r IN
    SELECT sku, cantidad FROM public.reservas_refaccion_ot WHERE id_orden = p_id_orden
  LOOP
    UPDATE public.refacciones
    SET stock_actual = stock_actual - r.cantidad,
        stock_reservado = stock_reservado - r.cantidad
    WHERE sku = r.sku;

    IF (SELECT stock_actual FROM public.refacciones WHERE sku = r.sku) < 0 THEN
      RAISE EXCEPTION 'Stock negativo al confirmar salida para %', r.sku;
    END IF;
  END LOOP;

  DELETE FROM public.reservas_refaccion_ot WHERE id_orden = p_id_orden;
END;
$$;

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
  v_tarifa constant numeric := 350;
BEGIN
  SELECT COALESCE(SUM(cantidad * precio_unitario), 0) INTO v_costo_ref
  FROM public.reservas_refaccion_ot
  WHERE id_orden = p_id_orden;

  SELECT horas_facturables INTO v_horas
  FROM public.ordenes_trabajo
  WHERE id = p_id_orden
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Orden no encontrada';
  END IF;

  v_saldo := v_costo_ref + (COALESCE(v_horas, 0) * v_tarifa);

  PERFORM public.confirmar_salida_inventario_por_orden(p_id_orden, auth.uid());

  UPDATE public.ordenes_trabajo
  SET estado = 'terminado',
      saldo_pendiente = v_saldo,
      fecha_terminado = NOW()
  WHERE id = p_id_orden;
END;
$$;

CREATE OR REPLACE FUNCTION public.ajustar_inventario_manual(
  p_sku text,
  p_cantidad_ajuste integer,
  p_justificacion text,
  p_id_usuario uuid
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_nuevo integer;
BEGIN
  IF public.current_empleado_rol() <> 'admin' THEN
    RAISE EXCEPTION 'Solo admin puede ajustar inventario';
  END IF;

  IF length(trim(p_justificacion)) = 0 THEN
    RAISE EXCEPTION 'Se requiere justificación';
  END IF;

  SELECT stock_actual + p_cantidad_ajuste INTO v_nuevo
  FROM public.refacciones
  WHERE sku = p_sku AND inactivo = false
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Refacción no encontrada';
  END IF;

  IF v_nuevo < 0 THEN
    RAISE EXCEPTION 'El ajuste dejaría stock negativo';
  END IF;

  UPDATE public.refacciones SET stock_actual = v_nuevo WHERE sku = p_sku;

  INSERT INTO public.ajustes_inventario (sku, cantidad, justificacion, id_usuario)
  VALUES (p_sku, p_cantidad_ajuste, p_justificacion, p_id_usuario);
END;
$$;

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
  v_porcentaje constant numeric := 0.08;
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
    INSERT INTO public.comisiones (id_orden, id_mecanico, monto, porcentaje_aplicado)
    VALUES (p_id_orden, v_orden.id_mecanico, v_orden.saldo_pendiente * v_porcentaje, v_porcentaje);
  END IF;

  UPDATE public.ordenes_trabajo
  SET saldo_pendiente = v_nuevo_saldo,
      estado = CASE WHEN v_nuevo_saldo <= 0.01 THEN 'pagado' ELSE estado END
  WHERE id = p_id_orden;
END;
$$;

CREATE OR REPLACE FUNCTION public.revertir_pago(p_id_pago uuid)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_pago record;
BEGIN
  SELECT * INTO v_pago FROM public.pagos WHERE id = p_id_pago FOR UPDATE;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Pago no encontrado';
  END IF;

  INSERT INTO public.pagos (id_orden, monto, metodo_pago, id_pago_revertido)
  VALUES (v_pago.id_orden, -v_pago.monto, v_pago.metodo_pago, p_id_pago);

  UPDATE public.ordenes_trabajo
  SET saldo_pendiente = saldo_pendiente + v_pago.monto
  WHERE id = v_pago.id_orden;
END;
$$;

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

    SELECT (stock_actual - stock_reservado) INTO v_disponible
    FROM public.refacciones
    WHERE sku = v_sku AND inactivo = false
    FOR UPDATE;

    IF NOT FOUND OR v_disponible < v_cantidad THEN
      RAISE EXCEPTION 'Stock insuficiente para %', v_sku;
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

-- ---------------------------------------------------------
-- RLS
-- ---------------------------------------------------------
ALTER TABLE public.empleados ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.clientes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.motocicletas ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.refacciones ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ordenes_trabajo ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.historial_estados_ot ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reservas_refaccion_ot ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.evidencias_ot ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.proveedores ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.entradas_inventario ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ajustes_inventario ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.pagos ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.facturas ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notas_credito ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.comisiones ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ventas_pos ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ventas_pos_items ENABLE ROW LEVEL SECURITY;

-- empleados: propio perfil o admin ve todos
DROP POLICY IF EXISTS empleados_select ON public.empleados;
CREATE POLICY empleados_select ON public.empleados
  FOR SELECT TO authenticated
  USING (id = auth.uid() OR public.is_admin());

DROP POLICY IF EXISTS empleados_insert ON public.empleados;
CREATE POLICY empleados_insert ON public.empleados
  FOR INSERT TO authenticated
  WITH CHECK (public.is_admin());

DROP POLICY IF EXISTS empleados_update ON public.empleados;
CREATE POLICY empleados_update ON public.empleados
  FOR UPDATE TO authenticated
  USING (public.is_admin());

-- política genérica lectura para empleados activos
DO $$
DECLARE
  t text;
BEGIN
  FOREACH t IN ARRAY ARRAY[
    'clientes', 'motocicletas', 'refacciones', 'ordenes_trabajo',
    'historial_estados_ot', 'reservas_refaccion_ot', 'evidencias_ot',
    'proveedores', 'entradas_inventario', 'ajustes_inventario',
    'pagos', 'facturas', 'notas_credito', 'comisiones',
    'ventas_pos', 'ventas_pos_items'
  ]
  LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I_select ON public.%I', t, t);
    EXECUTE format(
      'CREATE POLICY %I_select ON public.%I FOR SELECT TO authenticated USING (public.is_empleado_activo())',
      t, t
    );
    EXECUTE format('DROP POLICY IF EXISTS %I_write ON public.%I', t, t);
    EXECUTE format(
      'CREATE POLICY %I_write ON public.%I FOR ALL TO authenticated USING (public.is_empleado_activo()) WITH CHECK (public.is_empleado_activo())',
      t, t
    );
  END LOOP;
END $$;

-- Vista POS
GRANT SELECT ON public.refacciones_pos TO authenticated;

-- ---------------------------------------------------------
-- Storage: evidencias OT
-- ---------------------------------------------------------
INSERT INTO storage.buckets (id, name, public)
VALUES ('evidencias-ot', 'evidencias-ot', false)
ON CONFLICT (id) DO NOTHING;

DROP POLICY IF EXISTS evidencias_ot_storage_select ON storage.objects;
CREATE POLICY evidencias_ot_storage_select ON storage.objects
  FOR SELECT TO authenticated
  USING (bucket_id = 'evidencias-ot' AND public.is_empleado_activo());

DROP POLICY IF EXISTS evidencias_ot_storage_insert ON storage.objects;
CREATE POLICY evidencias_ot_storage_insert ON storage.objects
  FOR INSERT TO authenticated
  WITH CHECK (bucket_id = 'evidencias-ot' AND public.is_empleado_activo());

COMMIT;
