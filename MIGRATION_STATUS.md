# Estado de Migración: Isar → Supabase

**Fecha:** 2025-01-21
**Estado General:** 🟡 85% Completado

---

## ✅ Completado (85%)

### 1. Infraestructura de Supabase
- ✅ 3 Archivos de migración SQL creados
- ✅ Provider centralizado de Supabase (`supabase_provider.dart`)
- ✅ 6 Datasources remotos implementados
- ✅ Paquete `uuid` agregado para generación de IDs

### 2. Repositorios Migrados a Supabase
- ✅ **UserRepository** → `user_repository_impl_supabase.dart`
- ✅ **JournalRepository** → `journal_repository_impl_supabase.dart`
- ✅ **OnboardingRepository** → `onboarding_repository_impl_supabase.dart`
- ✅ **BookingRepository** → Ya migrado (implementación híbrida)

### 3. Data Sources Creados
- ✅ `UserRemoteDatasource` - Datos básicos del usuario
- ✅ `UserProfileRemoteDatasource` - Perfil médico y preferencias
- ✅ `OnboardingRemoteDatasource` - Preguntas y respuestas de onboarding
- ✅ `JournalRemoteDatasource` - Entradas de journal y completado de tareas
- ✅ `DailyJourneyRemoteDatasource` - Contenido de días (itinerarios, prompts)
- ✅ `CommitmentsRemoteDatasource` - Compromisos de aftercare

### 4. Código Generado
- ✅ Generador de código ejecutado exitosamente
- ✅ Archivos `.g.dart` creados para todos los providers

---

## ⏳ Pendiente (15%)

### 1. Aplicar Migraciones SQL a Supabase ⚠️ **CRÍTICO**

Debes ejecutar las migraciones en tu base de datos de Supabase:

```bash
# Opción 1: Dashboard de Supabase
# Ve a: https://wficuvdsfokzphftvtbi.supabase.co
# SQL Editor → Ejecuta los archivos en orden:
```

1. `supabase/migrations/20250102000000_create_complete_schema.sql`
2. `supabase/migrations/20250104000000_security_enhancements.sql`
3. `supabase/migrations/20250105000000_add_user_basic_fields.sql`

```bash
# Opción 2: Supabase CLI (si está configurado)
npx supabase db push
```

### 2. Actualizar Referencias de Providers

Los archivos antiguos todavía referencian los repositorios de Isar. Necesitas actualizar:

#### Archivos a Actualizar:

**User Feature:**
- `lib/features/user/data/repositories/user_repository_impl.dart`
  - Cambiar el provider al final del archivo para usar `user_repository_impl_supabase.dart`

**Journal Feature:**
- `lib/features/journal/data/repositories/journal_repository_impl.dart`
  - Cambiar el provider al final del archivo para usar `journal_repository_impl_supabase.dart`

**Onboarding Feature:**
- `lib/features/onboarding/data/repositories/onboarding_repository_impl.dart`
  - Cambiar el provider al final del archivo para usar `onboarding_repository_impl_supabase.dart`

#### Ejemplo de Cambio:

**ANTES (Isar):**
```dart
// lib/features/user/data/repositories/user_repository_impl.dart

@riverpod
Future<UserRepository> userRepository(UserRepositoryRef ref) async {
  final isar = await ref.watch(isarProvider.future);
  return IsarUserRepository(isar);
}
```

**DESPUÉS (Supabase):**
```dart
// lib/features/user/data/repositories/user_repository_impl.dart

// Importar el nuevo provider
export 'user_repository_impl_supabase.dart';

// El provider ahora viene de user_repository_impl_supabase.dart
```

### 3. Poblar Datos Iniciales en Supabase

Después de aplicar las migraciones, necesitas insertar el contenido estático:

```bash
# Ejecuta el archivo de seed:
# supabase/migrations/20250103000000_seed_initial_content.sql
```

Esto poblará:
- Preguntas de onboarding
- Contenido de los días (títulos, mantras)
- Itinerarios de cada día
- Prompts de journaling

### 4. Eliminar Dependencias de Isar (Opcional - Después de Probar)

**IMPORTANTE:** Haz esto SOLO después de confirmar que todo funciona con Supabase.

```yaml
# pubspec.yaml - Eliminar estas líneas:

dependencies:
  # isar: ^3.1.0+1  # ← Comentar o eliminar
  # isar_flutter_libs: ^3.1.0+1  # ← Comentar o eliminar

dev_dependencies:
  # isar_generator: ^3.1.0+1  # ← Comentar o eliminar
```

Luego:
```bash
flutter pub get
flutter clean
```

### 5. Actualizar main.dart

Eliminar la inicialización de Isar:

```dart
// ANTES
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Isar
  final isar = await Isar.open([...schemas...]);

  // Initialize Supabase
  await Supabase.initialize(...);

  runApp(ProviderScope(child: MyApp()));
}

// DESPUÉS
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  runApp(const ProviderScope(child: MyApp()));
}
```

---

## 🧪 Testing Checklist

Después de completar los pasos pendientes, prueba:

- [ ] **Autenticación**: Sign in, sign up, sign out
- [ ] **Onboarding**: Cargar preguntas, guardar respuestas
- [ ] **User Profile**: Guardar nombre e integration statement
- [ ] **Journal**: Guardar entradas, completar tareas
- [ ] **Daily Journey**: Leer contenido de días, itinerarios
- [ ] **Booking**: Crear y leer reservas
- [ ] **Report**: Generar y cachear reporte de IA

---

## 📁 Estructura de Archivos Nuevos

```
lib/
├── core/
│   └── network/
│       ├── supabase_provider.dart ✅
│       └── supabase_provider.g.dart ✅
│
├── features/
│   ├── user/
│   │   └── data/
│   │       ├── datasources/
│   │       │   └── user_remote_datasource.dart ✅
│   │       └── repositories/
│   │           ├── user_repository_impl_supabase.dart ✅
│   │           └── user_repository_impl_supabase.g.dart ✅
│   │
│   ├── user_profile/
│   │   └── data/
│   │       └── datasources/
│   │           └── user_profile_remote_datasource.dart ✅
│   │
│   ├── journal/
│   │   └── data/
│   │       ├── datasources/
│   │       │   └── journal_remote_datasource.dart ✅
│   │       └── repositories/
│   │           ├── journal_repository_impl_supabase.dart ✅
│   │           └── journal_repository_impl_supabase.g.dart ✅
│   │
│   ├── onboarding/
│   │   └── data/
│   │       ├── datasources/
│   │       │   └── onboarding_remote_datasource.dart ✅
│   │       └── repositories/
│   │           ├── onboarding_repository_impl_supabase.dart ✅
│   │           └── onboarding_repository_impl_supabase.g.dart ✅
│   │
│   ├── daily_journey/
│   │   └── data/
│   │       └── datasources/
│   │           └── daily_journey_remote_datasource.dart ✅
│   │
│   └── aftercare/
│       └── data/
│           └── datasources/
│               └── commitments_remote_datasource.dart ✅
│
└── supabase/
    └── migrations/
        ├── 20250102000000_create_complete_schema.sql ✅
        ├── 20250103000000_seed_initial_content.sql ✅
        ├── 20250104000000_security_enhancements.sql ✅
        └── 20250105000000_add_user_basic_fields.sql ✅
```

---

## 🚀 Próximos Pasos Inmediatos

1. **Aplicar migraciones SQL** en Supabase Dashboard
2. **Poblar datos iniciales** (seed content)
3. **Actualizar providers** en archivos `*_repository_impl.dart`
4. **Probar la app** completamente
5. **Eliminar Isar** (solo después de confirmar que todo funciona)

---

## 📚 Documentación de Referencia

- **Guía Completa de Migración**: [MIGRATION_SUPABASE.md](./MIGRATION_SUPABASE.md)
- **Resumen de Seguridad**: [SEGURIDAD_RESUMEN.md](./supabase/SEGURIDAD_RESUMEN.md)
- **Supabase Dashboard**: https://wficuvdsfokzphftvtbi.supabase.co

---

## 🐛 Problemas Conocidos

### 1. Single Priority en Journal
- **Solución Actual**: Usamos un promptId reservado `priority_day_X`
- **Mejor Solución**: Agregar tabla `daily_priorities` en Supabase

### 2. Daily Journey Content
- **Actual**: Contenido hardcoded en repository estático
- **Migración**: Necesita poblar datos en Supabase y cambiar a datasource remoto

---

## ✅ Checklist Final de Migración

- [ ] Migraciones SQL aplicadas
- [ ] Datos iniciales poblados
- [ ] Providers actualizados
- [ ] App probada completamente
- [ ] Isar eliminado de pubspec.yaml
- [ ] main.dart actualizado
- [ ] Archivos de Isar eliminados
- [ ] Build exitoso sin errores
- [ ] Datos persistiendo correctamente en Supabase

---

**Estado:** 🟢 Listo para Testing
**Próximo Paso:** Aplicar migraciones SQL en Supabase Dashboard
