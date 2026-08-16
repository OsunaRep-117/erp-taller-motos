-- Fase 3: Citas (§6.6), morosidad flotilla (§5.4), SLA 150% (§5.2)
-- Ejecutar después de 007_fase2_flujos.sql

-- Vínculo cita → OT al completar
ALTER TABLE public.citas
  ADD COLUMN IF NOT EXISTS id_moto TEXT REFERENCES public.motocicletas(vin) ON DELETE SET NULL,
  ADD COLUMN IF NOT EXISTS id_orden UUID REFERENCES public.ordenes_trabajo(id) ON DELETE SET NULL;

-- Horas estándar para auditoría SLA
ALTER TABLE public.ordenes_trabajo
  ADD COLUMN IF NOT EXISTS horas_estimadas DOUBLE PRECISION NOT NULL DEFAULT 2.0;

-- Config sobrecupo (citas activas por slot de 1 hora)
CREATE TABLE IF NOT EXISTS public.config_taller (
  clave   TEXT PRIMARY KEY,
  valor   TEXT NOT NULL
);

INSERT INTO public.config_taller (clave, valor)
VALUES ('max_citas_por_hora', '3')
ON CONFLICT (clave) DO NOTHING;

CREATE OR REPLACE FUNCTION public.max_citas_por_hora()
RETURNS INT
LANGUAGE sql
STABLE
AS $$
  SELECT COALESCE(
    (SELECT valor::INT FROM public.config_taller WHERE clave = 'max_citas_por_hora'),
    3
  );
$$;

CREATE OR REPLACE FUNCTION public.contar_citas_en_slot(p_fecha TIMESTAMPTZ)
RETURNS INT
LANGUAGE sql
STABLE
AS $$
  SELECT COUNT(*)::INT
  FROM public.citas
  WHERE estado IN ('agendada', 'confirmada')
    AND date_trunc('hour', fecha_cita) = date_trunc('hour', p_fecha);
$$;

-- Morosidad B2B: OT con saldo > 0 y antigüedad > 30 días
CREATE OR REPLACE FUNCTION public.cliente_flotilla_moroso(p_id_cliente UUID)
RETURNS BOOLEAN
LANGUAGE plpgsql
STABLE
AS $$
DECLARE
  v_es_flotilla BOOLEAN;
BEGIN
  SELECT es_flotilla INTO v_es_flotilla
  FROM public.clientes WHERE id = p_id_cliente;

  IF NOT COALESCE(v_es_flotilla, FALSE) THEN
    RETURN FALSE;
  END IF;

  RETURN EXISTS (
    SELECT 1
    FROM public.ordenes_trabajo ot
    JOIN public.motocicletas m ON m.vin = ot.id_moto
    WHERE m.id_cliente = p_id_cliente
      AND ot.saldo_pendiente > 0
      AND ot.estado NOT IN ('cancelada', 'entregado')
      AND ot.fecha_creacion < NOW() - INTERVAL '30 days'
  );
END;
$$;

CREATE OR REPLACE FUNCTION public.evaluar_sla_orden(p_id_orden UUID)
RETURNS BOOLEAN
LANGUAGE plpgsql
STABLE
AS $$
DECLARE
  v_inicio TIMESTAMPTZ;
  v_fin TIMESTAMPTZ;
  v_estimadas DOUBLE PRECISION;
  v_horas_reales DOUBLE PRECISION;
BEGIN
  SELECT fecha_inicio_reparacion, fecha_terminado, horas_estimadas
  INTO v_inicio, v_fin, v_estimadas
  FROM public.ordenes_trabajo
  WHERE id = p_id_orden;

  IF v_inicio IS NULL OR v_fin IS NULL OR v_estimadas <= 0 THEN
    RETURN FALSE;
  END IF;

  v_horas_reales := EXTRACT(EPOCH FROM (v_fin - v_inicio)) / 3600.0;
  RETURN v_horas_reales > (v_estimadas * 1.5);
END;
$$;

CREATE OR REPLACE FUNCTION public.agendar_cita(
  p_id_cliente UUID,
  p_fecha_cita TIMESTAMPTZ,
  p_motivo TEXT,
  p_id_moto TEXT DEFAULT NULL
)
RETURNS public.citas
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_cita public.citas;
BEGIN
  IF p_motivo IS NULL OR trim(p_motivo) = '' THEN
    RAISE EXCEPTION 'El motivo de la cita es obligatorio.';
  END IF;

  IF public.contar_citas_en_slot(p_fecha_cita) >= public.max_citas_por_hora() THEN
    RAISE EXCEPTION 'Horario saturado: no se permiten más citas en ese slot.';
  END IF;

  INSERT INTO public.citas (id_cliente, fecha_cita, motivo, id_moto, estado)
  VALUES (p_id_cliente, p_fecha_cita, p_motivo, p_id_moto, 'agendada')
  RETURNING * INTO v_cita;

  RETURN v_cita;
END;
$$;

CREATE OR REPLACE FUNCTION public.confirmar_cita(p_id_cita UUID)
RETURNS public.citas
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_cita public.citas;
BEGIN
  UPDATE public.citas
  SET estado = 'confirmada'
  WHERE id = p_id_cita AND estado = 'agendada'
  RETURNING * INTO v_cita;

  IF v_cita.id IS NULL THEN
    RAISE EXCEPTION 'Cita no encontrada o no está agendada.';
  END IF;

  RETURN v_cita;
END;
$$;

CREATE OR REPLACE FUNCTION public.cancelar_cita(p_id_cita UUID)
RETURNS public.citas
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_cita public.citas;
BEGIN
  UPDATE public.citas
  SET estado = 'cancelada'
  WHERE id = p_id_cita AND estado IN ('agendada', 'confirmada')
  RETURNING * INTO v_cita;

  IF v_cita.id IS NULL THEN
    RAISE EXCEPTION 'Cita no encontrada o ya fue completada/cancelada.';
  END IF;

  RETURN v_cita;
END;
$$;

CREATE OR REPLACE FUNCTION public.completar_cita(
  p_id_cita UUID,
  p_id_moto TEXT,
  p_id_orden UUID
)
RETURNS public.citas
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_cita public.citas;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.ordenes_trabajo WHERE id = p_id_orden) THEN
    RAISE EXCEPTION 'La orden de trabajo indicada no existe.';
  END IF;

  UPDATE public.citas
  SET estado = 'completada',
      id_moto = p_id_moto,
      id_orden = p_id_orden
  WHERE id = p_id_cita AND estado IN ('agendada', 'confirmada')
  RETURNING * INTO v_cita;

  IF v_cita.id IS NULL THEN
    RAISE EXCEPTION 'Cita no encontrada o no puede completarse.';
  END IF;

  RETURN v_cita;
END;
$$;

GRANT EXECUTE ON FUNCTION public.agendar_cita TO authenticated;
GRANT EXECUTE ON FUNCTION public.confirmar_cita TO authenticated;
GRANT EXECUTE ON FUNCTION public.cancelar_cita TO authenticated;
GRANT EXECUTE ON FUNCTION public.completar_cita TO authenticated;
GRANT EXECUTE ON FUNCTION public.cliente_flotilla_moroso TO authenticated;
GRANT EXECUTE ON FUNCTION public.evaluar_sla_orden TO authenticated;
