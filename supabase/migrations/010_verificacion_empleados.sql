-- 010_verificacion_empleados.sql
-- Flujo de registro manual de empleados con verificación de email vía
-- magic link (OTP). El empleado no aparece en `empleados` hasta que
-- confirma su correo y establece contraseña. Los pendientes vencidos
-- (24h) se limpian por una Edge Function programada.

-- =========================================================
-- 1. Tabla de pendientes de verificación
-- =========================================================
CREATE TABLE IF NOT EXISTS public.empleados_pendientes_verificacion (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  auth_user_id UUID, -- se llena tras el signInWithOtp inicial (ver nota abajo)
  nombre TEXT NOT NULL,
  email TEXT NOT NULL UNIQUE,
  rol TEXT NOT NULL,
  creado_por UUID REFERENCES public.empleados(id),
  creado_en TIMESTAMPTZ NOT NULL DEFAULT now(),
  expira_en TIMESTAMPTZ NOT NULL DEFAULT (now() + INTERVAL '24 hours')
);

ALTER TABLE public.empleados_pendientes_verificacion ENABLE ROW LEVEL SECURITY;

-- Solo admin puede ver, crear y borrar pendientes
CREATE POLICY "admin_select_pendientes"
  ON public.empleados_pendientes_verificacion FOR SELECT
  USING (public.is_admin());

CREATE POLICY "admin_insert_pendientes"
  ON public.empleados_pendientes_verificacion FOR INSERT
  WITH CHECK (public.is_admin());

CREATE POLICY "admin_delete_pendientes"
  ON public.empleados_pendientes_verificacion FOR DELETE
  USING (public.is_admin());

-- Habilitar Realtime para esta tabla (se refleja en vivo en la UI)
ALTER PUBLICATION supabase_realtime ADD TABLE public.empleados_pendientes_verificacion;

-- =========================================================
-- 2. Función: crear pendiente + disparar el magic link
-- =========================================================
-- NOTA IMPORTANTE: Supabase no permite enviar el signInWithOtp desde SQL
-- directamente (requiere el cliente de Auth). Esta función SOLO crea el
-- registro de pendiente; el cliente Flutter llama a
-- `supabase.auth.signInWithOtp(email: ..., shouldCreateUser: true)`
-- INMEDIATAMENTE DESPUÉS de que esta función retorna con éxito.
CREATE OR REPLACE FUNCTION public.crear_empleado_pendiente(
  p_nombre TEXT,
  p_email TEXT,
  p_rol TEXT
)
RETURNS public.empleados_pendientes_verificacion
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_pendiente public.empleados_pendientes_verificacion;
BEGIN
  IF NOT public.is_admin() THEN
    RAISE EXCEPTION 'Solo un administrador puede crear empleados.';
  END IF;

  IF EXISTS (SELECT 1 FROM public.empleados WHERE email = p_email) THEN
    RAISE EXCEPTION 'Ya existe un empleado activo con ese correo.';
  END IF;

  INSERT INTO public.empleados_pendientes_verificacion (nombre, email, rol, creado_por)
  VALUES (p_nombre, p_email, p_rol, auth.uid())
  ON CONFLICT (email) DO UPDATE
    SET nombre = EXCLUDED.nombre,
        rol = EXCLUDED.rol,
        creado_en = now(),
        expira_en = now() + INTERVAL '24 hours'
  RETURNING * INTO v_pendiente;

  RETURN v_pendiente;
END;
$$;

GRANT EXECUTE ON FUNCTION public.crear_empleado_pendiente TO authenticated;

-- =========================================================
-- 3. Función: promover pendiente -> empleado real
-- =========================================================
-- Se llama automáticamente cuando el propio usuario recién-verificado
-- confirma su email y establece contraseña (llamada desde el cliente,
-- ya autenticado con su propia sesión — SECURITY DEFINER para poder
-- tocar `empleados`, pero validamos que el email del pendiente
-- coincide con el email de quien llama).
CREATE OR REPLACE FUNCTION public.verificar_empleado_pendiente()
RETURNS public.empleados
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_pendiente public.empleados_pendientes_verificacion;
  v_empleado public.empleados;
  v_email TEXT;
BEGIN
  SELECT email INTO v_email FROM auth.users WHERE id = auth.uid();

  IF v_email IS NULL THEN
    RAISE EXCEPTION 'Debes iniciar sesión para verificar tu cuenta.';
  END IF;

  SELECT * INTO v_pendiente
  FROM public.empleados_pendientes_verificacion
  WHERE email = v_email
  LIMIT 1;

  IF v_pendiente IS NULL THEN
    RAISE EXCEPTION 'No hay una invitación pendiente para este correo.';
  END IF;

  IF v_pendiente.expira_en < now() THEN
    DELETE FROM public.empleados_pendientes_verificacion WHERE id = v_pendiente.id;
    RAISE EXCEPTION 'La invitación expiró. Pide al administrador que la genere de nuevo.';
  END IF;

  INSERT INTO public.empleados (id, nombre, email, rol, fecha_contratacion)
  VALUES (auth.uid(), v_pendiente.nombre, v_pendiente.email, v_pendiente.rol, now())
  RETURNING * INTO v_empleado;

  DELETE FROM public.empleados_pendientes_verificacion WHERE id = v_pendiente.id;

  RETURN v_empleado;
END;
$$;

GRANT EXECUTE ON FUNCTION public.verificar_empleado_pendiente TO authenticated;
