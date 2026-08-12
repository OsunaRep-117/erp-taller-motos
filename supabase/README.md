# Supabase — ERP Taller de Motocicletas

## 1. Crear proyecto nuevo

1. Ve a [supabase.com](https://supabase.com) y crea un **proyecto nuevo** (recomendado: no reutilizar el proyecto viejo `vzlfpftxfihbobkisbxm`).
2. Anota en **Project Settings → API**:
   - **Project URL** → `SUPABASE_URL`
   - **anon public key** → `SUPABASE_ANON_KEY`

## 2. Ejecutar SQL (en orden)

En **SQL Editor** del dashboard:

| Orden | Archivo | Cuándo |
|-------|---------|--------|
| 1 | `migrations/000_reset.sql` | Solo si ya tenías tablas de prueba y quieres borrarlas |
| 2 | `migrations/001_initial_schema.sql` | Siempre (tablas, RPCs, RLS, bucket) |
| 3 | `seed.sql` | Opcional (datos demo de clientes/refacciones) |

## 3. Authentication

### Email + contraseña

1. **Authentication → Providers → Email** → activo.
2. Para pruebas rápidas: desactiva **Confirm email**.
3. Crea usuarios en **Authentication → Users → Add user**.

### Google

**En Supabase (obligatorio para web):**
1. **Authentication → Providers → Google** → activar
2. **Client ID:** el Web Client ID (`674051757213-...htq4p.apps.googleusercontent.com`)
3. **Client Secret:** cópialo de Google Cloud → Credentials → OAuth 2.0 Web client
4. **Authentication → URL Configuration → Redirect URLs:** agrega:
   - `http://localhost:8080` (si usas `--web-port=8080`)
   - El origen exacto que muestre el navegador (ej. `http://localhost:17841`)

**En Google Cloud Console:**
- **Authorized JavaScript origins:** `http://localhost:8080`, `http://127.0.0.1:8080` (y el puerto que uses)
- Opcional: activar [People API](https://console.developers.google.com/apis/api/people.googleapis.com/overview?project=674051757213) si usas login nativo en Android

**Invitaciones:** el ERP guarda el Gmail en `empleados_invitados`; **no manda email**. 
El invitado solo debe pulsar «Continuar con Google» con ese mismo correo.

Ejecuta también `migrations/003_empleados_invitados.sql` y `004_enable_realtime.sql` si no lo hiciste.

## 4. Vincular empleados

Cada usuario de Auth necesita una fila en `empleados` con **el mismo UUID**:

```sql
INSERT INTO public.empleados (id, nombre, email, rol)
VALUES (
  '<UUID-del-usuario-en-Auth>',
  'Ana Administradora',
  'admin@taller.com',
  'admin'
);
```

Roles válidos: `admin`, `recepcionista`, `mecanico`, `supervisor`.

## 5. Correr la app con Supabase

Copia `.env.example` a `.env` (no se sube a git) y rellena los valores.

### VS Code / Cursor

Usa la configuración **"ERP (Supabase)"** en `.vscode/launch.json`.

### Línea de comandos

```powershell
flutter run `
  --dart-define=USE_MOCK=false `
  --dart-define=SUPABASE_URL=https://TU_PROYECTO.supabase.co `
  --dart-define=SUPABASE_ANON_KEY=TU_ANON_KEY `
  --dart-define=GOOGLE_WEB_CLIENT_ID=TU_WEB_CLIENT_ID.apps.googleusercontent.com
```

### Modo demo local (sin Supabase)

```powershell
flutter run
```

Por defecto `USE_MOCK=true` — no necesitas credenciales.

## 6. Checklist rápido

- [ ] SQL `001_initial_schema.sql` ejecutado sin errores
- [ ] Bucket `evidencias-ot` visible en Storage
- [ ] Usuario admin creado en Auth + fila en `empleados`
- [ ] Google OAuth configurado (si usas login con Google)
- [ ] App corre con `--dart-define=USE_MOCK=false`
