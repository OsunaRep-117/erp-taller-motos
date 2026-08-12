-- =========================================================
-- ERP Taller — borrar esquema previo (proyecto de prueba)
-- Ejecutar SOLO si quieres empezar de cero en Supabase.
-- =========================================================

BEGIN;

DROP VIEW IF EXISTS public.refacciones_pos CASCADE;

DROP TABLE IF EXISTS public.ventas_pos_items CASCADE;
DROP TABLE IF EXISTS public.ventas_pos CASCADE;
DROP TABLE IF EXISTS public.comisiones CASCADE;
DROP TABLE IF EXISTS public.notas_credito CASCADE;
DROP TABLE IF EXISTS public.facturas CASCADE;
DROP TABLE IF EXISTS public.pagos CASCADE;
DROP TABLE IF EXISTS public.ajustes_inventario CASCADE;
DROP TABLE IF EXISTS public.entradas_inventario CASCADE;
DROP TABLE IF EXISTS public.proveedores CASCADE;
DROP TABLE IF EXISTS public.evidencias_ot CASCADE;
DROP TABLE IF EXISTS public.reservas_refaccion_ot CASCADE;
DROP TABLE IF EXISTS public.historial_estados_ot CASCADE;
DROP TABLE IF EXISTS public.ordenes_trabajo CASCADE;
DROP TABLE IF EXISTS public.refacciones CASCADE;
DROP TABLE IF EXISTS public.motocicletas CASCADE;
DROP TABLE IF EXISTS public.clientes CASCADE;
DROP TABLE IF EXISTS public.empleados CASCADE;

DROP FUNCTION IF EXISTS public.registrar_venta_mostrador(jsonb, uuid, text);
DROP FUNCTION IF EXISTS public.revertir_pago(uuid);
DROP FUNCTION IF EXISTS public.registrar_pago(uuid, numeric, text);
DROP FUNCTION IF EXISTS public.ajustar_inventario_manual(text, integer, text, uuid);
DROP FUNCTION IF EXISTS public.terminar_orden_calculando_saldo(uuid);
DROP FUNCTION IF EXISTS public.confirmar_salida_inventario_por_orden(uuid, uuid);
DROP FUNCTION IF EXISTS public.reservar_refaccion_para_orden(uuid, text, integer, numeric, uuid);
DROP FUNCTION IF EXISTS public.incrementar_stock(text, integer);
DROP FUNCTION IF EXISTS public.registrar_historial_estado_ot();
DROP FUNCTION IF EXISTS public.is_empleado_activo();
DROP FUNCTION IF EXISTS public.is_supervisor_or_admin();
DROP FUNCTION IF EXISTS public.is_admin();
DROP FUNCTION IF EXISTS public.current_empleado_rol();

COMMIT;
