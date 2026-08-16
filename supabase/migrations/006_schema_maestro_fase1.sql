-- Fase 1: esquema maestro pendiente (§7) — aditivo, sin romper flujos actuales.
-- Tablas nuevas: citas, ordenes_compra, compra_detalle, extension_cotizacion,
-- gastos_operativos, movimientos_inventario (kardex).
-- Columnas nuevas: empleados.costo_hora, refacciones.id_proveedor,
-- ordenes_trabajo.fecha_aprobacion_presupuesto.

-- ---------------------------------------------------------
-- Columnas faltantes en tablas existentes
-- ---------------------------------------------------------
ALTER TABLE public.empleados
  ADD COLUMN IF NOT EXISTS costo_hora NUMERIC(10,2) NOT NULL DEFAULT 350;

ALTER TABLE public.refacciones
  ADD COLUMN IF NOT EXISTS id_proveedor UUID REFERENCES public.proveedores(id) ON DELETE SET NULL;

ALTER TABLE public.ordenes_trabajo
  ADD COLUMN IF NOT EXISTS fecha_aprobacion_presupuesto TIMESTAMPTZ;

-- ---------------------------------------------------------
-- Citas (§6.6 / §7.1)
-- ---------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.citas (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  id_cliente   UUID NOT NULL REFERENCES public.clientes(id) ON DELETE RESTRICT,
  fecha_cita   TIMESTAMPTZ NOT NULL,
  motivo       TEXT NOT NULL,
  estado       TEXT NOT NULL DEFAULT 'agendada' CHECK (estado IN (
    'agendada', 'confirmada', 'cancelada', 'completada'
  )),
  created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_citas_cliente ON public.citas(id_cliente);
CREATE INDEX IF NOT EXISTS idx_citas_fecha ON public.citas(fecha_cita);

-- ---------------------------------------------------------
-- Órdenes de compra + detalle (§6.8 / §7.2)
-- ---------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.ordenes_compra (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  id_proveedor    UUID NOT NULL REFERENCES public.proveedores(id) ON DELETE RESTRICT,
  fecha_creacion  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  estado          TEXT NOT NULL DEFAULT 'borrador' CHECK (estado IN (
    'borrador', 'aprobada', 'recibida', 'cancelada'
  )),
  total           NUMERIC(12,2) NOT NULL DEFAULT 0 CHECK (total >= 0)
);

CREATE TABLE IF NOT EXISTS public.compra_detalle (
  id_compra       UUID NOT NULL REFERENCES public.ordenes_compra(id) ON DELETE CASCADE,
  sku_refaccion   TEXT NOT NULL REFERENCES public.refacciones(sku) ON DELETE RESTRICT,
  cantidad        INTEGER NOT NULL CHECK (cantidad > 0),
  precio_compra   NUMERIC(12,2) NOT NULL CHECK (precio_compra >= 0),
  PRIMARY KEY (id_compra, sku_refaccion)
);

CREATE OR REPLACE FUNCTION public.recalcular_total_orden_compra(p_id_compra uuid)
RETURNS void
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
AS $$
  UPDATE public.ordenes_compra oc
  SET total = COALESCE((
    SELECT SUM(d.cantidad * d.precio_compra)
    FROM public.compra_detalle d
    WHERE d.id_compra = p_id_compra
  ), 0)
  WHERE oc.id = p_id_compra;
$$;

CREATE OR REPLACE FUNCTION public.compra_detalle_recalcular_total()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  PERFORM public.recalcular_total_orden_compra(
    COALESCE(NEW.id_compra, OLD.id_compra)
  );
  RETURN COALESCE(NEW, OLD);
END;
$$;

DROP TRIGGER IF EXISTS trg_compra_detalle_total ON public.compra_detalle;
CREATE TRIGGER trg_compra_detalle_total
  AFTER INSERT OR UPDATE OR DELETE ON public.compra_detalle
  FOR EACH ROW EXECUTE FUNCTION public.compra_detalle_recalcular_total();

-- ---------------------------------------------------------
-- Extensión de cotización (§6.13 / §7.3)
-- ---------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.extension_cotizacion (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  id_orden         UUID NOT NULL REFERENCES public.ordenes_trabajo(id) ON DELETE CASCADE,
  descripcion      TEXT NOT NULL,
  monto_adicional  NUMERIC(12,2) NOT NULL CHECK (monto_adicional > 0),
  estado           TEXT NOT NULL DEFAULT 'pendiente' CHECK (estado IN (
    'pendiente', 'aprobada', 'rechazada'
  )),
  fecha_solicitud  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_extension_cotizacion_orden ON public.extension_cotizacion(id_orden);

-- ---------------------------------------------------------
-- Gastos operativos / OPEX (§6.12 / §7.4)
-- ---------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.gastos_operativos (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  concepto     TEXT NOT NULL,
  categoria    TEXT,
  monto        NUMERIC(12,2) NOT NULL CHECK (monto > 0),
  fecha_gasto  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_gastos_operativos_fecha ON public.gastos_operativos(fecha_gasto);

-- ---------------------------------------------------------
-- Kardex / movimientos de inventario (§5.2 auditoría)
-- ---------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.movimientos_inventario (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  sku              TEXT NOT NULL REFERENCES public.refacciones(sku) ON DELETE RESTRICT,
  tipo             TEXT NOT NULL CHECK (tipo IN (
    'entrada_compra', 'salida_venta_pos', 'salida_ot', 'ajuste', 'reserva', 'liberacion_reserva'
  )),
  cantidad         INTEGER NOT NULL,
  costo_unitario   NUMERIC(12,2),
  referencia_tipo  TEXT NOT NULL,
  referencia_id    UUID NOT NULL,
  id_usuario       UUID REFERENCES public.empleados(id) ON DELETE SET NULL,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_movimientos_inventario_sku ON public.movimientos_inventario(sku);
CREATE INDEX IF NOT EXISTS idx_movimientos_inventario_fecha ON public.movimientos_inventario(created_at);

CREATE OR REPLACE FUNCTION public.registrar_movimiento_kardex(
  p_sku text,
  p_tipo text,
  p_cantidad integer,
  p_costo_unitario numeric,
  p_referencia_tipo text,
  p_referencia_id uuid,
  p_id_usuario uuid DEFAULT NULL
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  INSERT INTO public.movimientos_inventario (
    sku, tipo, cantidad, costo_unitario, referencia_tipo, referencia_id, id_usuario
  ) VALUES (
    p_sku, p_tipo, p_cantidad, p_costo_unitario, p_referencia_tipo, p_referencia_id, p_id_usuario
  );
END;
$$;

CREATE OR REPLACE FUNCTION public.kardex_on_entrada_inventario()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  PERFORM public.registrar_movimiento_kardex(
    NEW.sku,
    'entrada_compra',
    NEW.cantidad,
    NEW.costo_unitario,
    'entrada_inventario',
    NEW.id,
    NULL
  );
  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION public.kardex_on_ajuste_inventario()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  PERFORM public.registrar_movimiento_kardex(
    NEW.sku,
    'ajuste',
    NEW.cantidad,
    NULL,
    'ajuste_inventario',
    NEW.id,
    NEW.id_usuario
  );
  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION public.kardex_on_venta_pos_item()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_costo numeric;
BEGIN
  SELECT precio_costo INTO v_costo FROM public.refacciones WHERE sku = NEW.sku;
  PERFORM public.registrar_movimiento_kardex(
    NEW.sku,
    'salida_venta_pos',
    -NEW.cantidad,
    v_costo,
    'venta_pos_item',
    NEW.id,
    (SELECT id_usuario FROM public.ventas_pos WHERE id = NEW.id_venta)
  );
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_kardex_entrada ON public.entradas_inventario;
CREATE TRIGGER trg_kardex_entrada
  AFTER INSERT ON public.entradas_inventario
  FOR EACH ROW EXECUTE FUNCTION public.kardex_on_entrada_inventario();

DROP TRIGGER IF EXISTS trg_kardex_ajuste ON public.ajustes_inventario;
CREATE TRIGGER trg_kardex_ajuste
  AFTER INSERT ON public.ajustes_inventario
  FOR EACH ROW EXECUTE FUNCTION public.kardex_on_ajuste_inventario();

DROP TRIGGER IF EXISTS trg_kardex_venta_pos_item ON public.ventas_pos_items;
CREATE TRIGGER trg_kardex_venta_pos_item
  AFTER INSERT ON public.ventas_pos_items
  FOR EACH ROW EXECUTE FUNCTION public.kardex_on_venta_pos_item();

-- ---------------------------------------------------------
-- RLS en tablas nuevas (mismo patrón que 001)
-- ---------------------------------------------------------
ALTER TABLE public.citas ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ordenes_compra ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.compra_detalle ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.extension_cotizacion ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.gastos_operativos ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.movimientos_inventario ENABLE ROW LEVEL SECURITY;

DO $$
DECLARE
  t text;
BEGIN
  FOREACH t IN ARRAY ARRAY[
    'citas', 'ordenes_compra', 'compra_detalle', 'extension_cotizacion',
    'gastos_operativos', 'movimientos_inventario'
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
