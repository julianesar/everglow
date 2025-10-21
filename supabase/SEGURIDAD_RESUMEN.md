# Resumen de Seguridad de Base de Datos - EverGlow

## 🎯 Objetivo

Proteger datos médicos sensibles y personales de los usuarios cumpliendo con estándares de seguridad como HIPAA (salud) y GDPR (privacidad europea).

## 🔒 Niveles de Protección Implementados

### 1. Aislamiento de Datos por Usuario (RLS - Row Level Security)

**¿Qué es?** Cada usuario solo puede ver y modificar sus propios datos.

**Tablas protegidas con RLS:**

| Tabla | Política de Acceso |
|-------|-------------------|
| `bookings` | Solo el usuario dueño o admin |
| `user_profiles` | Solo el usuario dueño o admin |
| `user_onboarding_responses` | Solo el usuario dueño o admin |
| `user_journal_responses` | Solo el usuario dueño o admin |
| `user_task_completions` | Solo el usuario dueño o admin |
| `user_commitments` | Solo el usuario dueño o admin |

**Tablas públicas (solo lectura):**

| Tabla | Acceso |
|-------|--------|
| `onboarding_questions` | Todos pueden leer, solo service role puede escribir |
| `daily_journey_content` | Todos pueden leer, solo service role puede escribir |
| `itinerary_items` | Todos pueden leer, solo service role puede escribir |
| `journaling_prompts` | Todos pueden leer, solo service role puede escribir |
| `aftercare_content` | Todos pueden leer, solo service role puede escribir |

### 2. Registro de Auditoría (Audit Logging)

**¿Para qué?** Cumplimiento normativo y detección de actividad sospechosa.

**Tabla:** `audit_logs`

Se registran automáticamente todas las operaciones (INSERT, UPDATE, DELETE) en:
- ✅ Perfiles médicos (`user_profiles`)
- ✅ Respuestas de onboarding médico (`user_onboarding_responses`)
- ✅ Entradas de diario (`user_journal_responses`)
- ✅ Reservas (`bookings`)

**Información registrada:**
- Usuario que realizó la acción
- Tabla afectada
- Tipo de operación
- Datos antiguos y nuevos (para actualizaciones)
- Timestamp
- IP y user agent (si está disponible)

### 3. Control de Acceso por Roles (RBAC)

**Tabla:** `admin_roles`

**Roles disponibles:**

| Rol | Permisos |
|-----|----------|
| `admin` | Acceso completo a todos los datos |
| `medical_staff` | Acceso a perfiles médicos vía vistas seguras |
| `concierge_staff` | Acceso a preferencias de concierge (futuro) |

**Vista segura para personal médico:**
- `medical_profiles_view`: Muestra datos médicos con identificadores enmascarados
- Solo admins ven el UUID completo del usuario
- Staff médico ve identificador tipo "PATIENT-abc123def"

### 4. Validación de Datos

#### Restricciones de Reservas
```sql
✅ Fecha inicio < Fecha fin
✅ Duración máxima: 30 días
✅ Reservas futuras: máximo 1 año adelante
✅ No retrodatar más de 30 días
```

#### Límites de Texto
```sql
✅ Respuestas de diario: máximo 10,000 caracteres
✅ Respuestas de onboarding: máximo 5,000 caracteres
✅ Compromisos: máximo 500 caracteres
✅ Opciones múltiples: máximo 10 items
```

#### Validaciones de Integridad
```sql
✅ No se puede cambiar user_id después de creación
✅ No se pueden duplicar respuestas (UNIQUE constraints)
✅ Validación de foreign keys
✅ Enums/CHECK constraints para datos categóricos
```

### 5. Cumplimiento GDPR (Derecho al Olvido)

**Función:** `anonymize_user_data(user_id)`

**¿Qué hace?**
1. Borra alergias, condiciones médicas, medicamentos
2. Elimina respuestas de onboarding
3. Redacta entradas de diario (las convierte en "[REDACTED]")
4. Elimina compromisos
5. Registra la anonimización en audit logs

**Uso:**
```sql
-- Usuario anonimiza sus propios datos
SELECT public.anonymize_user_data(auth.uid());

-- Admin anonimiza datos de un usuario
SELECT public.anonymize_user_data('uuid-del-usuario');
```

### 6. Protección de Datos Médicos (HIPAA)

#### Encriptación
- ✅ **En reposo:** AES-256 (automático en Supabase)
- ✅ **En tránsito:** HTTPS/TLS 1.2+ (automático)

#### Auditoría
- ✅ Registro de todos los accesos a datos médicos
- ✅ Trazabilidad completa de modificaciones

#### Control de Acceso
- ✅ Solo usuarios autorizados (propietario + admin + medical_staff)
- ✅ Vistas seguras para personal médico

## 🚀 Configuración Paso a Paso

### Paso 1: Aplicar Migraciones de Seguridad

**Opción A: Usar Supabase CLI (recomendado)**
```bash
npx supabase db push
```

**Opción B: Usar script Node.js**
```bash
# Configurar variables de entorno
export SUPABASE_URL=https://tu-proyecto.supabase.co
export SUPABASE_SERVICE_ROLE_KEY=tu-service-role-key

# Ejecutar script
node apply_security_migration.js
```

**Opción C: Manual via Supabase Dashboard**
1. Ve a tu proyecto en Supabase → SQL Editor
2. Copia el contenido de `supabase/migrations/20250104000000_security_enhancements.sql`
3. Pega y ejecuta el SQL

### Paso 2: Deshabilitar Realtime para Tablas Sensibles

**¿Por qué?** Las suscripciones en tiempo real pueden exponer datos sensibles.

**Via Dashboard:**
1. Database → Replication
2. Desactivar replicación para:
   - `user_profiles`
   - `user_onboarding_responses`
   - `user_journal_responses`
   - `bookings`
   - `user_commitments`
   - `audit_logs`

**Via SQL:**
```sql
ALTER PUBLICATION supabase_realtime DROP TABLE public.user_profiles;
ALTER PUBLICATION supabase_realtime DROP TABLE public.user_onboarding_responses;
ALTER PUBLICATION supabase_realtime DROP TABLE public.user_journal_responses;
ALTER PUBLICATION supabase_realtime DROP TABLE public.bookings;
ALTER PUBLICATION supabase_realtime DROP TABLE public.user_commitments;
ALTER PUBLICATION supabase_realtime DROP TABLE public.audit_logs;
```

### Paso 3: Configurar Autenticación

**En Supabase Dashboard → Authentication → Settings:**

1. ✅ Activar "Confirm email" para nuevos registros
2. ✅ Configurar plantillas de email
3. ✅ Habilitar MFA (Multi-Factor Authentication)
4. ✅ Configurar política de contraseñas fuertes

**Configuración recomendada:**
```
Mínimo 8 caracteres
Requiere mayúsculas, minúsculas, números
Requiere caracteres especiales
```

### Paso 4: Configurar Rate Limiting

**En Supabase Dashboard → Settings → API:**

**Límites recomendados:**
- Peticiones anónimas: 100 por hora
- Peticiones autenticadas: 1000 por hora

### Paso 5: Activar Backups

**En Supabase Dashboard → Settings → Database:**

1. ✅ Activar backups automáticos diarios
2. ✅ Configurar retención: 7-30 días
3. ✅ Probar restauración periódicamente

### Paso 6: Crear Usuarios Admin

**Via SQL Editor:**
```sql
-- Reemplazar 'uuid-del-usuario' con UUID real de auth.users
INSERT INTO public.admin_roles (user_id, role, granted_by)
VALUES ('uuid-del-usuario', 'admin', auth.uid())
ON CONFLICT (user_id) DO UPDATE SET role = 'admin';
```

**Via Backend (Node.js/TypeScript):**
```typescript
import { createClient } from '@supabase/supabase-js'

const supabase = createClient(
  process.env.SUPABASE_URL!,
  process.env.SUPABASE_SERVICE_ROLE_KEY! // Solo en backend
)

async function makeUserAdmin(userId: string) {
  const { error } = await supabase
    .from('admin_roles')
    .insert({ user_id: userId, role: 'admin' })

  if (error) throw error
}
```

## 🛡️ Mejores Prácticas de Seguridad

### 1. Variables de Entorno

**NUNCA** commitear a git:

```bash
# .env.local
SUPABASE_URL=https://tu-proyecto.supabase.co
SUPABASE_ANON_KEY=tu-anon-key
SUPABASE_SERVICE_ROLE_KEY=tu-service-role-key  # ⚠️ Solo backend
```

**IMPORTANTE:**
- ✅ `SUPABASE_ANON_KEY` → Usar en Flutter app
- ❌ `SUPABASE_SERVICE_ROLE_KEY` → **NUNCA** en Flutter app
- ✅ `SUPABASE_SERVICE_ROLE_KEY` → Solo en backend/funciones

### 2. API Keys de IA

Para Google AI y otros servicios:
- ✅ Guardar en Supabase Edge Functions (no en app)
- ✅ Usar variables de entorno en Edge Functions
- ❌ NUNCA hardcodear en Flutter

### 3. Queries Seguros en Flutter

```dart
// ✅ CORRECTO: RLS protege automáticamente
final response = await supabase
    .from('user_profiles')
    .select()
    .eq('user_id', supabase.auth.currentUser!.id);

// ❌ INCORRECTO: Intentar acceder a datos de otros usuarios
// (será bloqueado por RLS, solo retorna datos del usuario actual)
final response = await supabase
    .from('user_profiles')
    .select(); // Solo retorna perfil del usuario actual
```

### 4. Monitoreo y Alertas

**Revisar regularmente:**
- ✅ Audit logs (tabla `audit_logs`)
- ✅ Logs de Supabase (Settings → Logs)
- ✅ Patrones de acceso inusuales
- ✅ Intentos de acceso no autorizados

### 5. Backups y Recuperación

- ✅ Backups automáticos activados
- ✅ Probar restauración periódicamente
- ✅ Mantener backups off-site (exportar via pg_dump)
- ✅ Documentar procedimientos de recuperación

## 🧪 Probar la Seguridad

### Test 1: RLS Funciona

```sql
-- Como usuario anónimo (debería fallar)
SET request.jwt.claims = '{}';
SELECT * FROM user_profiles; -- Retorna 0 filas

-- Como usuario autenticado (solo ve sus datos)
SET request.jwt.claims = '{"sub": "uuid-usuario"}';
SELECT * FROM user_profiles; -- Retorna solo perfil de ese usuario
```

### Test 2: Audit Logging Funciona

```sql
-- Hacer una operación
UPDATE user_profiles
SET allergies = ARRAY['peanuts']
WHERE user_id = auth.uid();

-- Verificar audit log
SELECT * FROM audit_logs
WHERE table_name = 'user_profiles'
ORDER BY created_at DESC
LIMIT 1;
-- Debería mostrar el registro de la operación
```

### Test 3: Anonimización Funciona

```sql
-- Crear datos de prueba
INSERT INTO user_profiles (user_id, allergies, medical_conditions)
VALUES (auth.uid(), ARRAY['test'], ARRAY['test']);

-- Anonimizar
SELECT anonymize_user_data(auth.uid());

-- Verificar
SELECT * FROM user_profiles WHERE user_id = auth.uid();
-- Debería mostrar arrays vacíos
```

## ✅ Checklist de Seguridad Pre-Producción

Antes de lanzar a producción, verificar:

- [ ] ✅ Todas las políticas RLS probadas
- [ ] ✅ Audit logging activado y probado
- [ ] ✅ Roles de admin configurados
- [ ] ✅ Realtime deshabilitado para tablas sensibles
- [ ] ✅ Rate limiting configurado
- [ ] ✅ Verificación de email activada
- [ ] ✅ MFA activado para usuarios admin
- [ ] ✅ Backups activados y probados
- [ ] ✅ Variables de entorno aseguradas
- [ ] ✅ Service role key NO expuesta en app
- [ ] ✅ Política de privacidad y términos creados
- [ ] ✅ Cumplimiento GDPR verificado (si aplica)
- [ ] ✅ Cumplimiento HIPAA verificado (si aplica)
- [ ] ✅ Monitoreo de seguridad configurado
- [ ] ✅ Plan de respuesta a incidentes documentado

## 📊 Arquitectura de Seguridad - Diagrama

```
┌─────────────────────────────────────────────────────────────┐
│                     FLUTTER APP (Cliente)                    │
│                                                              │
│  ✅ Solo usa SUPABASE_ANON_KEY                              │
│  ✅ Todas las queries pasan por RLS                         │
│  ✅ Usuario solo ve sus propios datos                       │
└─────────────────────┬───────────────────────────────────────┘
                      │ HTTPS/TLS
                      ▼
┌─────────────────────────────────────────────────────────────┐
│                   SUPABASE (Backend)                         │
│                                                              │
│  ┌────────────────────────────────────────────────────────┐ │
│  │ Row Level Security (RLS)                               │ │
│  │ • Verifica auth.uid() en cada query                    │ │
│  │ • Bloquea acceso a datos de otros usuarios            │ │
│  │ • Permite acceso a admins                              │ │
│  └────────────────────────────────────────────────────────┘ │
│                                                              │
│  ┌────────────────────────────────────────────────────────┐ │
│  │ Audit Logging                                          │ │
│  │ • Registra INSERT/UPDATE/DELETE                        │ │
│  │ • Guarda en tabla audit_logs                           │ │
│  └────────────────────────────────────────────────────────┘ │
│                                                              │
│  ┌────────────────────────────────────────────────────────┐ │
│  │ PostgreSQL Database                                    │ │
│  │ • Encriptación AES-256 en reposo                       │ │
│  │ • Constraints de validación                            │ │
│  │ • Foreign keys                                         │ │
│  └────────────────────────────────────────────────────────┘ │
│                                                              │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                BACKEND SERVICES (Opcional)                   │
│                                                              │
│  ✅ Usa SUPABASE_SERVICE_ROLE_KEY                           │
│  ✅ Puede bypasear RLS (usar con cuidado)                  │
│  ✅ Para operaciones admin y edge functions                │
└─────────────────────────────────────────────────────────────┘
```

## 🆘 Contacto y Soporte

**Documentación:**
- Supabase Security: https://supabase.com/docs/guides/platform/security
- Supabase RLS: https://supabase.com/docs/guides/auth/row-level-security

**Soporte:**
- Supabase Support: support@supabase.io
- Supabase Discord: https://discord.supabase.com

**Cumplimiento:**
- Consultar con abogado especializado
- Revisar documentación de cumplimiento de Supabase: https://supabase.com/security

---

**Última actualización:** 2025-01-04
**Versión de migración:** 20250104000000
