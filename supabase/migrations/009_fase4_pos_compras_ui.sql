-- Fase 4: Cierre ciego caja (§5.3), devoluciones POS (§5.3), soporte OC en app
-- Ejecutar después de 008_fase3_crm_ops.sql

ALTER TABLE public.ventas_pos
  ADD COLUMN IF NOT EXISTS devuelta BOOLEAN NOT NULL DEFAULT FALSE;

CREATE TABLE IF NOT EXISTS public.cierres_caja (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  id_usuario        UUID NOT NULL REFERENCES public.empleados(id) ON DELETE RESTRICT,
  efectivo_contado  NUMERIC(12,2) NOT NULL CHECK (efectivo_contado >= 0),
  efectivo_esperado NUMERIC(12,2) NOT NULL,
  diferencia        NUMERIC(12,2) NOT NULL,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE OR REPLACE FUNCTION public.calcular_efectivo_esperado_turno(p_id_usuario uuid DEFAULT NULL)
RETURNS NUMERIC
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT COALESCE(SUM(
    (SELECT SUM(vpi.cantidad * vpi.precio_unitario)
     FROM public.ventas_pos_items vpi
     WHERE vpi.id_venta = v.id)
  ), 0)
  FROM public.ventas_pos v
  WHERE v.devuelta = FALSE
    AND v.metodo_pago = 'efectivo'
    AND v.fecha::date = CURRENT_DATE
    AND (p_id_usuario IS NULL OR v.id_usuario = p_id_usuario);
$$;

CREATE OR REPLACE FUNCTION public.registrar_cierre_caja_ciego(
  p_efectivo_contado NUMERIC,
  p_id_usuario UUID DEFAULT auth.uid()
)
RETURNS public.cierres_caja
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_esperado NUMERIC;
  v_cierre public.cierres_caja;
BEGIN
  IF p_efectivo_contado IS NULL OR p_efectivo_contado < 0 THEN
    RAISE EXCEPTION 'El efectivo contado debe ser un monto válido.';
  END IF;

  v_esperado := public.calcular_efectivo_esperado_turno(p_id_usuario);

  INSERT INTO public.cierres_caja (id_usuario, efectivo_contado, efectivo_esperado, diferencia)
  VALUES (p_id_usuario, p_efectivo_contado, v_esperado, p_efectivo_contado - v_esperado)
  RETURNING * INTO v_cierre;

  RETURN v_cierre;
END;
$$;

CREATE OR REPLACE FUNCTION public.devolver_venta_pos(
  p_id_venta UUID,
  p_pin_autorizacion TEXT
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_venta public.ventas_pos%ROWTYPE;
  v_item record;
BEGIN
  IF NOT public.is_supervisor_or_admin()
     AND COALESCE(p_pin_autorizacion, '') <> '8765' THEN
    RAISE EXCEPTION 'Se requiere PIN de supervisor o rol admin/supervisor.';
  END IF;

  SELECT * INTO v_venta FROM public.ventas_pos WHERE id = p_id_venta FOR UPDATE;
  IF v_venta.id IS NULL THEN
    RAISE EXCEPTION 'Venta no encontrada.';
  END IF;
  IF v_venta.devuelta THEN
    RAISE EXCEPTION 'Esta venta ya fue devuelta.';
  END IF;

  FOR v_item IN
    SELECT sku, cantidad FROM public.ventas_pos_items WHERE id_venta = p_id_venta
  LOOP
    UPDATE public.refacciones
    SET stock_actual = stock_actual + v_item.cantidad
    WHERE sku = v_item.sku;

    INSERT INTO public.movimientos_inventario (
      sku, tipo, cantidad, referencia_tipo, referencia_id, id_usuario
    ) VALUES (
      v_item.sku,
      'ajuste',
      v_item.cantidad,
      'devolucion_pos',
      p_id_venta::text,
      auth.uid()
    );
  END LOOP;

  UPDATE public.ventas_pos SET devuelta = TRUE WHERE id = p_id_venta;
END;
$$;

GRANT EXECUTE ON FUNCTION public.registrar_cierre_caja_ciego TO authenticated;
GRANT EXECUTE ON FUNCTION public.devolver_venta_pos TO authenticated;
GRANT EXECUTE ON FUNCTION public.calcular_efectivo_esperado_turno TO authenticated;
