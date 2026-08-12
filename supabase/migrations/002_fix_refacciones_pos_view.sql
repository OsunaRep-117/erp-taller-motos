-- Parche: vista POS con permisos del usuario que consulta (recomendado por Supabase)
CREATE OR REPLACE VIEW public.refacciones_pos
WITH (security_invoker = true)
AS
SELECT sku, nombre, precio_venta, stock_actual, stock_reservado, inactivo
FROM public.refacciones;

GRANT SELECT ON public.refacciones_pos TO authenticated;
