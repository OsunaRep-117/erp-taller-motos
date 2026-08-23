// supabase/functions/cleanup-empleados-pendientes/index.ts
//
// Se ejecuta con un Scheduled Trigger (cron) cada hora.
// Borra los registros de empleados_pendientes_verificacion cuyo
// expira_en ya pasó, y también borra la cuenta huérfana en auth.users
// que Supabase creó al enviar el magic link, para permitir reintentar
// limpio con el mismo correo.

import { createClient } from "npm:@supabase/supabase-js@2";

// Supabase migró de JWT largos a "sb_secret_..." cortos, expuestos como
// JSON en SUPABASE_SECRET_KEYS (clave "default"). Se mantiene el
// fallback al nombre viejo por compatibilidad.
function obtenerServiceRoleKey(): string {
  const secretKeysRaw = Deno.env.get("SUPABASE_SECRET_KEYS");
  if (secretKeysRaw) {
    try {
      const parsed = JSON.parse(secretKeysRaw);
      if (typeof parsed.default === "string" && parsed.default.length > 0) {
        return parsed.default;
      }
    } catch (_e) {
      // sigue al fallback
    }
  }
  return Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";
}

Deno.serve(async (req: Request) => {
  const serviceRoleKey = obtenerServiceRoleKey();

  // Solo aceptar invocaciones del scheduler (o llamadas manuales con la
  // service role key en el header, útil para pruebas).
  const authHeader = req.headers.get("Authorization") ?? "";
  const expected = `Bearer ${serviceRoleKey}`;
  if (!serviceRoleKey || authHeader !== expected) {
    return new Response(JSON.stringify({ error: "No autorizado" }), {
      status: 401,
      headers: { "Content-Type": "application/json" },
    });
  }

  const supabaseAdmin = createClient(
    Deno.env.get("SUPABASE_URL")!,
    serviceRoleKey,
  );

  // 1. Encontrar pendientes vencidos
  const { data: vencidos, error: errSelect } = await supabaseAdmin
    .from("empleados_pendientes_verificacion")
    .select("id, email")
    .lt("expira_en", new Date().toISOString());

  if (errSelect) {
    return new Response(JSON.stringify({ error: errSelect.message }), {
      status: 500,
      headers: { "Content-Type": "application/json" },
    });
  }

  if (!vencidos || vencidos.length === 0) {
    return new Response(
      JSON.stringify({ eliminados: 0, mensaje: "Sin pendientes vencidos." }),
      { status: 200, headers: { "Content-Type": "application/json" } },
    );
  }

  const resultados: { email: string; authBorrado: boolean }[] = [];

  for (const pendiente of vencidos) {
    // 2. Buscar y borrar la cuenta huérfana en auth.users por email
    //    (creada por signInWithOtp cuando se envió el magic link).
    let authBorrado = false;
    try {
      const { data: usuarios } = await supabaseAdmin.auth.admin.listUsers();
      const usuarioHuerfano = usuarios.users.find(
        (u) => u.email === pendiente.email && !u.email_confirmed_at,
      );
      if (usuarioHuerfano) {
        const { error: errDeleteAuth } =
          await supabaseAdmin.auth.admin.deleteUser(usuarioHuerfano.id);
        authBorrado = !errDeleteAuth;
      }
    } catch (_e) {
      // Si falla el borrado de auth, seguimos limpiando la tabla igual;
      // el pendiente no debe quedar bloqueando un reintento.
    }

    resultados.push({ email: pendiente.email, authBorrado });
  }

  // 3. Borrar los pendientes vencidos de la tabla
  const { error: errDelete } = await supabaseAdmin
    .from("empleados_pendientes_verificacion")
    .delete()
    .lt("expira_en", new Date().toISOString());

  if (errDelete) {
    return new Response(JSON.stringify({ error: errDelete.message }), {
      status: 500,
      headers: { "Content-Type": "application/json" },
    });
  }

  return new Response(
    JSON.stringify({ eliminados: vencidos.length, detalle: resultados }),
    { status: 200, headers: { "Content-Type": "application/json" } },
  );
});
