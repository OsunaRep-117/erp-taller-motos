# ERP para Taller de Motocicletas

Aplicación desarrollada con **Flutter y Dart** para administrar clientes, motocicletas, reparaciones, refacciones, compras, ventas y finanzas de un taller.

El sistema conecta la recepción de una motocicleta con la asignación del mecánico, el uso de inventario, el cobro y la entrega. Incluye un backend con **Supabase** y un **modo demo en memoria** para explorar sus funciones sin configurar servicios externos.

## Funcionalidades

| Módulo | Funciones |
| --- | --- |
| Autenticación | Inicio de sesión con correo y contraseña o Google; acceso según el rol. |
| CRM | Clientes particulares y flotillas, motocicletas, historial y citas. |
| Taller | Órdenes de trabajo, asignación de mecánicos, tablero Kanban, presupuestos, evidencias fotográficas y seguimiento de tiempos. |
| Inventario | Catálogo de refacciones, existencias, reservas para órdenes, movimientos y ajustes manuales. |
| Compras | Proveedores, órdenes de compra y recepción de mercancía. |
| Punto de venta | Venta de refacciones, devoluciones y cierre de caja. |
| Finanzas | Pagos, facturas internas, notas de crédito, gastos y reportes ejecutivos. |
| Recursos humanos | Empleados, invitaciones, verificación de acceso y comisiones. |
| Reportes | Indicadores operativos y exportación de información en CSV. |

La interfaz utiliza un tema visual inspirado en ventanas de escritorio clásicas.

## Tecnologías

- **Flutter / Dart:** interfaz y lógica de la aplicación.
- **Riverpod:** gestión de estado e inyección de dependencias.
- **GoRouter:** navegación y redirecciones de acceso.
- **Supabase:** autenticación, PostgreSQL, funciones RPC, políticas RLS, Realtime y almacenamiento de evidencias.
- **Freezed / JSON Serializable:** modelos inmutables y serialización.
- **Dartz:** resultados mediante `Either<Failure, T>`.
- **Flutter Test / Mocktail:** pruebas y dobles de prueba.

## Requisitos

- Flutter con una versión de Dart compatible con **`^3.12.2`**, según [pubspec.yaml](pubspec.yaml).
- Git para clonar el repositorio.
- Chrome para ejecutar la versión web, o el entorno de desarrollo de la plataforma elegida.
- Un proyecto Supabase para utilizar el backend real.

El repositorio incluye directorios para Android, iOS, web, Windows, macOS y Linux. La compilación y las integraciones nativas deben validarse en cada plataforma.

## Inicio rápido: modo demo

1. Clona este repositorio y abre una terminal en su carpeta raíz.
2. Copia `.env.example` a `.env`. En PowerShell:

   ```powershell
   Copy-Item .env.example .env
   ```

   En Linux o macOS:

   ```bash
   cp .env.example .env
   ```

3. Instala las dependencias y ejecuta la aplicación:

   ```bash
   flutter pub get
   flutter run -d chrome --dart-define=USE_MOCK=true
   ```

El archivo `.env` debe existir porque está declarado como asset en `pubspec.yaml`. La opción `--dart-define=USE_MOCK=true` activa la demo aunque el archivo de ejemplo contenga `USE_MOCK=false`.

### Cuentas de demostración

Estas credenciales están definidas en el backend mock y corresponden únicamente a la demo local:

| Rol | Correo | Contraseña |
| --- | --- | --- |
| Administrador | `admin@taller.com` | `admin123` |
| Recepcionista | `recep@taller.com` | `recep123` |
| Mecánico | `mec@taller.com` | `mec123` |
| Supervisor | `super@taller.com` | `super123` |

Los cambios de la demo se almacenan en memoria y se pierden al reiniciar la aplicación. El acceso con Google en este modo es simulado.

## Configuración con Supabase

### 1. Base de datos

Crea un proyecto Supabase y ejecuta los archivos de [supabase/migrations](supabase/migrations) en orden numérico, desde **`001_initial_schema.sql` hasta `010_verificacion_empleados.sql`**.

`000_reset.sql` es un script destructivo para reiniciar datos de prueba; no forma parte de la instalación de una base nueva. Si la base ya existe, aplica únicamente las migraciones pendientes.

Comprueba que exista el bucket **`evidencias-ot`**. Puedes cargar [supabase/seed.sql](supabase/seed.sql) para disponer de datos de ejemplo, revisando primero sus comentarios y referencias a empleados.

### 2. Variables de configuración

Completa `.env` con los valores de tu proyecto:

```dotenv
SUPABASE_URL=https://TU_PROYECTO.supabase.co
SUPABASE_ANON_KEY=TU_CLAVE_PUBLICA_ANON
USE_MOCK=false
```

| Variable | Uso |
| --- | --- |
| `SUPABASE_URL` | URL del proyecto Supabase. |
| `SUPABASE_ANON_KEY` | Clave pública utilizada por el cliente. |
| `USE_MOCK` | `true` para datos en memoria; `false` para Supabase. |

La prioridad de configuración es **`--dart-define` → `.env` → valores predeterminados**. Si no se especifica `USE_MOCK`, la aplicación selecciona Supabase cuando la URL y la clave no están vacías; en caso contrario utiliza el mock.

`.env` está excluido de Git, pero se empaqueta en la aplicación. Debe contener únicamente configuración apta para el cliente; las claves administrativas y los secretos de OAuth pertenecen al servidor.

### 3. Primer administrador

Crea un usuario de correo y contraseña en Supabase Auth y vincúlalo con un empleado utilizando el mismo UUID:

```sql
INSERT INTO public.empleados (id, nombre, email, rol)
VALUES (
  '<UUID_DEL_USUARIO_EN_AUTH>',
  'Administrador',
  'admin@tu-dominio.com',
  'admin'
);
```

Los roles disponibles son `admin`, `recepcionista`, `mecanico` y `supervisor`. Las cuentas mock no se crean automáticamente en Supabase.

### 4. Google y verificación de empleados

Para utilizar Google, configura el proveedor OAuth en Supabase y las credenciales correspondientes en Google Cloud. Registra el origen web que uses y, para el flujo móvil, el callback definido en la aplicación:

```text
com.upfim.erpflutter://login-callback
```

**Detalle de la implementación actual:** aunque `.env.example` incluye `GOOGLE_WEB_CLIENT_ID`, el getter `googleWebClientId` de [app_config.dart](lib/core/config/app_config.dart) tiene un valor fijo. Para adaptar el acceso nativo a tu proyecto debes actualizar ese getter; cambiar únicamente `.env` no modifica ese valor.

El repositorio incluye la función [cleanup-empleados-pendientes](supabase/functions/cleanup-empleados-pendientes/index.ts). Si utilizas la limpieza automática de registros de verificación vencidos, debes desplegarla y programar su ejecución en el servidor; las migraciones SQL no despliegan esta función.

### 5. Ejecutar

```bash
flutter run -d chrome --web-port=8080 --dart-define=USE_MOCK=false
```

Para OAuth web, registra `http://localhost:8080` entre las URLs de redirección permitidas en Supabase y los orígenes autorizados en Google Cloud. Para elegir otro dispositivo:

```bash
flutter devices
flutter run -d <ID_DEL_DISPOSITIVO> --dart-define=USE_MOCK=false
```

## Arquitectura

El código está organizado por funcionalidades, con separación en capas de presentación, dominio y datos:

```text
lib/
├── main.dart                 # Inicialización y selección del backend
├── core/
│   ├── auth/                 # Permisos por rol
│   ├── config/               # Configuración y lectura de .env
│   ├── data/mock/            # Datos y operaciones en memoria
│   ├── errors/               # Manejo de errores
│   ├── network/              # Cliente Supabase
│   ├── router/               # Rutas de la aplicación
│   ├── services/             # Servicios compartidos
│   ├── theme/                # Tema visual
│   └── widgets/              # Componentes reutilizables
└── features/
    ├── auth/
    ├── compras/
    ├── crm/
    ├── finanzas/
    ├── inventario/
    ├── pos/
    ├── rrhh/
    └── taller/

supabase/
├── migrations/               # Esquema y reglas de la base de datos
├── functions/                # Funciones de servidor
└── seed.sql                  # Datos de demostración

test/                         # Pruebas unitarias, de permisos y de integración
```

Dentro de cada módulo, `presentation` contiene pantallas y providers; `domain`, entidades, contratos y casos de uso; y `data`, implementaciones de repositorios y fuentes de datos.

## Roles y permisos

| Rol | Alcance general |
| --- | --- |
| Administrador | Gestión de personal, ajustes de inventario y acceso a módulos administrativos y operativos. |
| Supervisor | Supervisión operativa, compras, finanzas y reportes. |
| Recepcionista | Atención de clientes, motocicletas, citas y punto de venta. |
| Mecánico | Trabajo sobre órdenes asignadas y consulta de información operativa. |

Las restricciones de rutas y acciones están centralizadas en [app_permissions.dart](lib/core/auth/app_permissions.dart); los casos de uso y las funciones de base de datos agregan reglas de negocio.

## Flujo de trabajo

1. Registrar al cliente y su motocicleta.
2. Crear una orden con la falla reportada.
3. Asignar un mecánico y gestionar el presupuesto.
4. Reservar refacciones y registrar el avance de la reparación.
5. Terminar el trabajo y registrar el cobro.
6. Entregar la motocicleta conforme a las reglas de saldo y crédito.

Las órdenes contemplan estados de pendiente, en proceso, esperando aprobación, esperando piezas, terminado, pagado, entregado y cancelada. Los clientes particulares requieren liquidar el saldo para retirar el vehículo; las flotillas están sujetas a su límite de crédito.

## Desarrollo y pruebas

Cuando cambies modelos o providers que usan generación de código:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Comandos de validación:

```bash
flutter analyze
flutter test test/features
flutter test test/integration
flutter test test/security_test.dart
```

Las pruebas de integración incluidas utilizan un entorno mock para verificar flujos entre módulos. No sustituyen las pruebas contra un proyecto Supabase real.

**Pendiente conocido:** `test/widget_test.dart` conserva la prueba inicial del contador y referencia `MyApp`, mientras la aplicación define `ErpTallerApp`. Es necesario actualizar esa prueba antes de ejecutar la suite completa con `flutter test`; también puede generar un error en el análisis estático.

## Alcance actual

El proyecto incluye funcionalidades de administración y demostración que requieren configurar y validar el backend antes de su uso operativo. Las facturas del módulo financiero son registros internos; este repositorio no documenta una integración de timbrado fiscal. El PIN de autorización de devoluciones del POS está definido como un valor demo en `AppConfig`.
