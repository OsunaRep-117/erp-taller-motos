-- Datos demo (después de crear usuarios en Auth y vincular empleados).
-- Reemplaza los UUID de empleados con los de tus usuarios reales de Supabase Auth.

BEGIN;

-- Clientes demo
INSERT INTO public.clientes (id, nombre_completo, telefono, es_flotilla)
VALUES ('11111111-1111-1111-1111-111111111101', 'Juan Pérez', '5551234567', false)
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.clientes (id, nombre_completo, telefono, rfc, limite_credito, es_flotilla)
VALUES (
  '11111111-1111-1111-1111-111111111102',
  'Transportes Rápidos SA',
  '5559876543',
  'TRA850101ABC',
  15000,
  true
)
ON CONFLICT (id) DO NOTHING;

-- Motocicletas demo
INSERT INTO public.motocicletas (vin, placa, marca, modelo, anio, id_cliente)
VALUES
  ('1HGBH41JXMN109186', 'ABC-123', 'Honda', 'CBR600', 2022, '11111111-1111-1111-1111-111111111101'),
  ('JH2RC4670MK200001', 'FLO-001', 'Kawasaki', 'Ninja 400', 2023, '11111111-1111-1111-1111-111111111102')
ON CONFLICT (vin) DO NOTHING;

-- Refacciones demo
INSERT INTO public.refacciones (sku, nombre, precio_costo, precio_venta, stock_actual, stock_minimo)
VALUES
  ('ACE-001', 'Aceite 10W40', 85, 150, 24, 5),
  ('PAST-001', 'Pastillas de freno', 220, 380, 8, 4),
  ('CAD-001', 'Cadena de transmisión', 450, 720, 3, 2)
ON CONFLICT (sku) DO NOTHING;

-- Proveedores demo
INSERT INTO public.proveedores (id, nombre, contacto, rfc)
VALUES
  ('22222222-2222-2222-2222-222222222201', 'Refacciones del Norte', 'ventas@rdn.com', NULL),
  ('22222222-2222-2222-2222-222222222202', 'MotoPartes MX', '5551112233', 'MPM900101XYZ')
ON CONFLICT (id) DO NOTHING;

COMMIT;

-- Vincular empleados (ejemplo — sustituye UUIDs):
-- 1. Crea usuario en Authentication → Users → Add user
-- 2. Copia su UUID y ejecuta:
--
-- INSERT INTO public.empleados (id, nombre, email, rol)
-- VALUES ('<UUID-AUTH>', 'Ana Administradora', 'admin@taller.com', 'admin');
