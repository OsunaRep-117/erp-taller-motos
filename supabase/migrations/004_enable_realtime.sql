-- Habilita Supabase Realtime para la lista de órdenes (.stream() en Flutter).
BEGIN;

DO $$
BEGIN
  ALTER PUBLICATION supabase_realtime ADD TABLE public.ordenes_trabajo;
EXCEPTION
  WHEN duplicate_object THEN NULL;
END $$;

COMMIT;
