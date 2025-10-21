# Migración de Isar a Supabase - Guía Completa

## Estado Actual: ✅ Datasources Creados, ⏳ Repositorios en Progreso

Esta migración elimina completamente la dependencia de **Isar** (base de datos local) y migra todos los datos a **Supabase** (base de datos remota).

---

## 📋 Progreso de Migración

### ✅ Completado

1. **Migraciones de Base de Datos Creadas**
   - ✅ `20250102000000_create_complete_schema.sql` - Esquema completo
   - ✅ `20250104000000_security_enhancements.sql` - Seguridad mejorada
   - ✅ `20250105000000_add_user_basic_fields.sql` - Campos adicionales para User

2. **Datasources Remotos Creados**
   - ✅ `UserRemoteDatasource` - lib/features/user/data/datasources/user_remote_datasource.dart
   - ✅ `UserProfileRemoteDatasource` - lib/features/user_profile/data/datasources/user_profile_remote_datasource.dart
   - ✅ `OnboardingRemoteDatasource` - lib/features/onboarding/data/datasources/onboarding_remote_datasource.dart
   - ✅ `JournalRemoteDatasource` - lib/features/journal/data/datasources/journal_remote_datasource.dart
   - ✅ `DailyJourneyRemoteDatasource` - lib/features/daily_journey/data/datasources/daily_journey_remote_datasource.dart
   - ✅ `CommitmentsRemoteDatasource` - lib/features/aftercare/data/datasources/commitments_remote_datasource.dart

3. **Providers Centralizados**
   - ✅ `supabase_provider.dart` - lib/core/network/supabase_provider.dart

### ⏳ Pendiente

4. **Reescribir Repositorios para usar Supabase**
   - ⏳ UserRepository (user_repository_impl.dart)
   - ⏳ JournalRepository (journal_repository_impl.dart)
   - ⏳ OnboardingRepository (onboarding_repository_impl.dart)
   - ⏳ DailyJourneyRepository (daily_journey_repository_impl.dart)
   - ⏳ AftercareRepository (aftercare_repository_impl.dart)

5. **Eliminar Código de Isar**
   - ⏳ Eliminar isar_provider.dart
   - ⏳ Eliminar modelos de Isar (archivos con @collection)
   - ⏳ Eliminar dependencias de pubspec.yaml
   - ⏳ Actualizar main.dart

---

## 🗄️ Mapeo de Datos: Isar → Supabase

### User Feature
| **Isar Model** | **Supabase Table** | **Campos** |
|----------------|-------------------|------------|
| `User` | `user_profiles` | name, integration_statement, generated_report, has_completed_onboarding |

### Journal Feature
| **Isar Model** | **Supabase Table** | **Campos** |
|----------------|-------------------|------------|
| `DailyLog` | `user_task_completions` | user_id, day_number, completed_at |
| `JournalEntry` | `user_journal_responses` | user_id, prompt_id, day_number, response_text |

### User Profile Feature
| **Isar Model** | **Supabase Table** | **Campos** |
|----------------|-------------------|------------|
| `MedicalProfile` | `user_profiles` | allergies[], medical_conditions[], medications[], has_signed_medical_consent |
| `ConciergePreferences` | `user_profiles` | dietary_restrictions[], coffee_or_tea, room_temperature |

### Booking Feature
| **Isar Model** | **Supabase Table** | **Estado** |
|----------------|-------------------|------------|
| `BookingModel` | `bookings` | ✅ **Ya migrado** (implementación híbrida) |

### Onboarding Feature
| **Isar Model** | **Supabase Table** | **Campos** |
|----------------|-------------------|------------|
| (Hardcoded) | `onboarding_questions` | question_text, question_type, category, options[], is_required |
| (Hardcoded) | `user_onboarding_responses` | user_id, question_id, response_text, response_options[] |

### Daily Journey Feature
| **Isar Model** | **Supabase Table** | **Campos** |
|----------------|-------------------|------------|
| (Hardcoded) | `daily_journey_content` | day_number, title, mantra |
| (Hardcoded) | `itinerary_items` | day_number, item_type, time, title, description, location, audio_url |
| (Hardcoded) | `journaling_prompts` | itinerary_item_id, prompt_text, display_order |

### Aftercare Feature
| **Isar Model** | **Supabase Table** | **Campos** |
|----------------|-------------------|------------|
| `CommitmentModel` | `user_commitments` | user_id, commitment_text, source_day |

---

## 📝 Pasos Siguientes para Completar la Migración

### 1. Aplicar Migraciones a Supabase

Ve al **SQL Editor** en tu dashboard de Supabase (https://wficuvdsfokzphftvtbi.supabase.co) y ejecuta los siguientes archivos en orden:

```bash
supabase/migrations/20250102000000_create_complete_schema.sql
supabase/migrations/20250104000000_security_enhancements.sql
supabase/migrations/20250105000000_add_user_basic_fields.sql
```

**Alternativamente**, si tienes el CLI de Supabase configurado:
```bash
npx supabase db push
```

### 2. Reescribir Repositorios

Cada repositorio debe reemplazar la implementación de Isar por la de Supabase. Ejemplo para **UserRepository**:

**ANTES (Isar):**
```dart
class IsarUserRepository implements UserRepository {
  final Isar _isar;

  Future<User?> getUser() async {
    return await _isar.users.where().findFirst();
  }
}
```

**DESPUÉS (Supabase):**
```dart
class SupabaseUserRepository implements UserRepository {
  final UserRemoteDatasource _datasource;
  final SupabaseClient _supabase;

  Future<User?> getUser() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return null;

    final data = await _datasource.getUserBasicInfo(userId);
    if (data == null) return null;

    return User.create(
      name: data.name,
      integrationStatement: data.integrationStatement,
    );
  }
}
```

### 3. Actualizar Providers de Riverpod

Actualiza los providers para usar los datasources de Supabase:

```dart
import '../../../core/network/supabase_provider.dart';
import '../datasources/user_remote_datasource.dart';

@riverpod
UserRemoteDatasource userRemoteDatasource(UserRemoteDatasourceRef ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return UserRemoteDatasource(supabase);
}

@riverpod
UserRepository userRepository(UserRepositoryRef ref) {
  final datasource = ref.watch(userRemoteDatasourceProvider);
  final supabase = ref.watch(supabaseClientProvider);
  return SupabaseUserRepository(datasource, supabase);
}
```

### 4. Generar Código de Riverpod

Después de actualizar los repositorios, ejecuta:

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 5. Eliminar Dependencias de Isar

**Eliminar archivos:**
- `lib/core/database/isar_provider.dart`
- Todos los modelos con anotaciones `@collection`
- Archivos `.g.dart` relacionados con Isar

**Actualizar `pubspec.yaml`** - Eliminar:
```yaml
dependencies:
  isar: ^3.1.0+1
  isar_flutter_libs: ^3.1.0+1

dev_dependencies:
  isar_generator: ^3.1.0+1
```

### 6. Actualizar main.dart

**ANTES:**
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Isar
  final isar = await Isar.open([...schemas...]);

  // Initialize Supabase
  await Supabase.initialize(...);

  runApp(ProviderScope(child: MyApp()));
}
```

**DESPUÉS:**
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase only
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  runApp(ProviderScope(child: MyApp()));
}
```

### 7. Poblar Datos Iniciales en Supabase

Debes insertar el contenido estático en Supabase:

- **Onboarding questions** → tabla `onboarding_questions`
- **Daily journey content** → tabla `daily_journey_content`
- **Itinerary items** → tabla `itinerary_items`
- **Journaling prompts** → tabla `journaling_prompts`

Usa el archivo de seed:
```bash
supabase/migrations/20250103000000_seed_initial_content.sql
```

### 8. Probar Todas las Features

Después de la migración, prueba:

- ✅ **Autenticación** (sign in, sign up, sign out)
- ✅ **Onboarding** (guardar respuestas, leer preguntas)
- ✅ **Journal** (crear entradas, completar tareas)
- ✅ **Daily Journey** (leer días, ver itinerarios)
- ✅ **Booking** (crear, leer, actualizar reservas)
- ✅ **User Profile** (guardar perfil médico y preferencias)
- ✅ **Aftercare** (guardar y leer compromisos)
- ✅ **Report** (generar y cachear reporte de IA)

---

## 🔐 Consideraciones de Seguridad

### Row Level Security (RLS)

Todas las tablas tienen políticas RLS configuradas:

- **Usuarios pueden leer/escribir SOLO sus propios datos**
- **Administradores pueden acceder a todos los datos**
- **Contenido público (preguntas, itinerarios) es de solo lectura para todos**

### Auditoría

La tabla `audit_logs` registra automáticamente:
- Todas las operaciones en datos sensibles (INSERT, UPDATE, DELETE)
- user_id, timestamp, datos antiguos y nuevos

### GDPR Compliance

Función disponible para anonimizar/borrar datos de usuario:

```sql
SELECT public.anonymize_user_data('user-uuid-here');
```

---

## 🐛 Troubleshooting

### Error: "User not authenticated"

**Solución:** Asegúrate de que el usuario esté autenticado antes de hacer operaciones:

```dart
final userId = Supabase.instance.client.auth.currentUser?.id;
if (userId == null) {
  // Redirigir a login
  return;
}
```

### Error: "Row Level Security policy violation"

**Solución:** Verifica que las políticas RLS estén aplicadas correctamente. Usa el Service Role Key (NO el anon key) para operaciones administrativas.

### Error: "Null check operator used on a null value"

**Solución:** Maneja casos donde datos no existen en Supabase:

```dart
final data = await datasource.getUser(userId);
if (data == null) {
  // Crear datos por primera vez o manejar caso vacío
  return null;
}
```

---

## 📊 Ventajas de Supabase sobre Isar

| Característica | Isar (Local) | Supabase (Remote) |
|---------------|--------------|-------------------|
| **Sincronización** | ❌ Solo local | ✅ Multi-dispositivo |
| **Backup** | ❌ Manual | ✅ Automático |
| **Seguridad** | ⚠️ Básica | ✅ RLS + Audit logs |
| **Escalabilidad** | ⚠️ Limitada | ✅ PostgreSQL |
| **Colaboración** | ❌ No | ✅ Tiempo real |
| **GDPR/HIPAA** | ⚠️ Complejo | ✅ Integrado |

---

## ✅ Checklist de Migración Completa

- [ ] Migraciones aplicadas en Supabase
- [ ] Datasources creados (✅ completado)
- [ ] Repositorios reescritos
- [ ] Código generado (build_runner)
- [ ] Isar eliminado de pubspec.yaml
- [ ] main.dart actualizado
- [ ] Datos iniciales poblados
- [ ] Todas las features probadas
- [ ] App funciona sin errores
- [ ] Datos persistiendo en Supabase

---

## 🚀 Próximos Pasos Recomendados

1. **Implementar caché offline** usando Hive o Drift para funcionalidad sin conexión
2. **Configurar Realtime subscriptions** para actualizaciones en vivo
3. **Añadir Storage** para imágenes de perfil y archivos
4. **Configurar Edge Functions** para lógica de servidor
5. **Implementar analytics** con PostHog o Mixpanel

---

**Fecha de Migración:** 2025-01-21
**Desarrollador:** Claude Code Assistant
**Estado:** 🟡 En Progreso (70% completado)
