-- Invitaciones Google + resolución de acceso al primer login
BEGIN;

CREATE TABLE IF NOT EXISTS public.empleados_invitados (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email        TEXT NOT NULL UNIQUE,
  nombre       TEXT NOT NULL,
  rol          TEXT NOT NULL CHECK (rol IN ('admin', 'recepcionista', 'mecanico', 'supervisor')),
  invitado_por UUID REFERENCES public.empleados(id) ON DELETE SET NULL,
  activado     BOOLEAN NOT NULL DEFAULT false,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE public.empleados_invitados ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS empleados_invitados_admin ON public.empleados_invitados;
CREATE POLICY empleados_invitados_admin ON public.empleados_invitados
  FOR ALL TO authenticated
  USING (public.is_admin())
  WITH CHECK (public.is_admin());

-- Vincula Auth ↔ empleados: primer usuario = admin; resto por invitación.
CREATE OR REPLACE FUNCTION public.resolver_acceso_empleado(
  p_user_id uuid,
  p_email text,
  p_nombre text DEFAULT NULL
)
RETURNS public.empleados
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_empleado public.empleados%ROWTYPE;
  v_invitacion public.empleados_invitados%ROWTYPE;
  v_nombre text := COALESCE(NULLIF(trim(p_nombre), ''), split_part(p_email, '@', 1));
  v_total integer;
BEGIN
  SELECT * INTO v_empleado FROM public.empleados WHERE id = p_user_id;
  IF FOUND THEN
    IF NOT v_empleado.activo THEN
      RAISE EXCEPTION 'Tu cuenta de empleado está desactivada.';
    END IF;
    RETURN v_empleado;
  END IF;

  SELECT * INTO v_invitacion
  FROM public.empleados_invitados
  WHERE lower(email) = lower(p_email) AND activado = false
  LIMIT 1;

  IF FOUND THEN
    INSERT INTO public.empleados (id, nombre, email, rol)
    VALUES (p_user_id, COALESCE(v_invitacion.nombre, v_nombre), lower(p_email), v_invitacion.rol)
    RETURNING * INTO v_empleado;

    UPDATE public.empleados_invitados SET activado = true WHERE id = v_invitacion.id;
    RETURN v_empleado;
  END IF;

  SELECT count(*) INTO v_total FROM public.empleados;
  IF v_total = 0 THEN
    INSERT INTO public.empleados (id, nombre, email, rol)
    VALUES (p_user_id, v_nombre, lower(p_email), 'admin')
    RETURNING * INTO v_empleado;
    RETURN v_empleado;
  END IF;

  RAISE EXCEPTION 'No tienes acceso al ERP. Pide a un administrador que te invite desde Gestión de Personal.';
END;
$$;

GRANT EXECUTE ON FUNCTION public.resolver_acceso_empleado(uuid, text, text) TO authenticated;

COMMIT;
