# Ejemplos de Uso de Seguridad en Flutter

Esta guía muestra cómo usar las funciones de seguridad de Supabase desde tu aplicación Flutter.

## 📦 Configuración Inicial

```dart
// lib/main.dart
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://tu-proyecto.supabase.co',
    anonKey: 'tu-anon-key', // ⚠️ Solo anon key, NUNCA service role key
  );

  runApp(const MyApp());
}

// Acceso global al cliente Supabase
final supabase = Supabase.instance.client;
```

## 🔐 1. Autenticación de Usuarios

### Registro de Nuevo Usuario

```dart
// lib/features/auth/data/repositories/auth_repository_impl.dart

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient _supabase;

  AuthRepositoryImpl(this._supabase);

  /// Registra un nuevo usuario
  @override
  Future<User> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName, // Metadata del usuario
        },
        emailRedirectTo: 'everglow://login-callback/', // Deep link
      );

      if (response.user == null) {
        throw Exception('No se pudo crear el usuario');
      }

      return response.user!;
    } on AuthException catch (e) {
      throw Exception('Error de autenticación: ${e.message}');
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  /// Inicia sesión
  @override
  Future<User> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Credenciales inválidas');
      }

      return response.user!;
    } on AuthException catch (e) {
      throw Exception('Error de autenticación: ${e.message}');
    }
  }

  /// Cierra sesión
  @override
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  /// Usuario actual
  @override
  User? get currentUser => _supabase.auth.currentUser;

  /// Stream del estado de autenticación
  @override
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;
}
```

## 👤 2. Gestión de Perfiles de Usuario

### Crear Perfil de Usuario (Primera vez)

```dart
// lib/features/user_profile/data/repositories/user_profile_repository_impl.dart

class UserProfileRepositoryImpl implements UserProfileRepository {
  final SupabaseClient _supabase;

  UserProfileRepositoryImpl(this._supabase);

  /// Crea el perfil del usuario actual
  /// RLS garantiza que user_id = auth.uid()
  @override
  Future<UserProfile> createProfile({
    required List<String> allergies,
    required List<String> medicalConditions,
    required List<String> medications,
    required List<String> dietaryRestrictions,
    String? coffeeOrTea,
    String? roomTemperature,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Usuario no autenticado');
      }

      final response = await _supabase
          .from('user_profiles')
          .insert({
            'user_id': userId,
            'allergies': allergies,
            'medical_conditions': medicalConditions,
            'medications': medications,
            'dietary_restrictions': dietaryRestrictions,
            'coffee_or_tea': coffeeOrTea,
            'room_temperature': roomTemperature,
            'has_signed_medical_consent': true,
          })
          .select()
          .single();

      return UserProfile.fromJson(response);
    } on PostgrestException catch (e) {
      if (e.code == '23505') {
        // Unique violation - perfil ya existe
        throw Exception('El perfil ya existe. Usa updateProfile en su lugar.');
      }
      throw Exception('Error de base de datos: ${e.message}');
    } catch (e) {
      throw Exception('Error al crear perfil: $e');
    }
  }

  /// Obtiene el perfil del usuario actual
  @override
  Future<UserProfile?> getProfile() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return null;

      // RLS automáticamente filtra por user_id = auth.uid()
      final response = await _supabase
          .from('user_profiles')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) return null;

      return UserProfile.fromJson(response);
    } catch (e) {
      throw Exception('Error al obtener perfil: $e');
    }
  }

  /// Actualiza el perfil del usuario actual
  @override
  Future<UserProfile> updateProfile({
    List<String>? allergies,
    List<String>? medicalConditions,
    List<String>? medications,
    List<String>? dietaryRestrictions,
    String? coffeeOrTea,
    String? roomTemperature,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Usuario no autenticado');
      }

      final updates = <String, dynamic>{};
      if (allergies != null) updates['allergies'] = allergies;
      if (medicalConditions != null) updates['medical_conditions'] = medicalConditions;
      if (medications != null) updates['medications'] = medications;
      if (dietaryRestrictions != null) updates['dietary_restrictions'] = dietaryRestrictions;
      if (coffeeOrTea != null) updates['coffee_or_tea'] = coffeeOrTea;
      if (roomTemperature != null) updates['room_temperature'] = roomTemperature;

      final response = await _supabase
          .from('user_profiles')
          .update(updates)
          .eq('user_id', userId)
          .select()
          .single();

      return UserProfile.fromJson(response);
    } catch (e) {
      throw Exception('Error al actualizar perfil: $e');
    }
  }

  /// Elimina el perfil (GDPR - Right to Erasure)
  @override
  Future<void> deleteProfile() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Usuario no autenticado');
      }

      await _supabase
          .from('user_profiles')
          .delete()
          .eq('user_id', userId);
    } catch (e) {
      throw Exception('Error al eliminar perfil: $e');
    }
  }
}
```

## 📝 3. Respuestas de Onboarding

### Guardar Respuestas de Onboarding

```dart
// lib/features/onboarding/data/repositories/onboarding_repository_impl.dart

class OnboardingRepositoryImpl implements OnboardingRepository {
  final SupabaseClient _supabase;

  OnboardingRepositoryImpl(this._supabase);

  /// Guarda una respuesta de onboarding
  @override
  Future<void> saveResponse({
    required String questionId,
    String? responseText,
    List<String>? responseOptions,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Usuario no autenticado');
      }

      // RLS garantiza que solo se puede insertar con user_id = auth.uid()
      await _supabase.from('user_onboarding_responses').upsert({
        'user_id': userId,
        'question_id': questionId,
        'response_text': responseText,
        'response_options': responseOptions,
      });
    } catch (e) {
      throw Exception('Error al guardar respuesta: $e');
    }
  }

  /// Obtiene todas las respuestas del usuario actual
  @override
  Future<Map<String, OnboardingResponse>> getResponses() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return {};

      final response = await _supabase
          .from('user_onboarding_responses')
          .select()
          .eq('user_id', userId);

      final Map<String, OnboardingResponse> responses = {};
      for (final item in response) {
        final questionId = item['question_id'] as String;
        responses[questionId] = OnboardingResponse.fromJson(item);
      }

      return responses;
    } catch (e) {
      throw Exception('Error al obtener respuestas: $e');
    }
  }
}
```

## 📔 4. Entradas de Diario

### Guardar Respuestas de Diario

```dart
// lib/features/journal/data/repositories/journal_repository_impl.dart

class JournalRepositoryImpl implements JournalRepository {
  final SupabaseClient _supabase;

  JournalRepositoryImpl(this._supabase);

  /// Guarda una respuesta de diario
  @override
  Future<void> saveJournalResponse({
    required String promptId,
    required int dayNumber,
    required String responseText,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Usuario no autenticado');
      }

      // Validación de longitud (también hay constraint en BD)
      if (responseText.length > 10000) {
        throw Exception('La respuesta excede el límite de 10,000 caracteres');
      }

      await _supabase.from('user_journal_responses').upsert({
        'user_id': userId,
        'prompt_id': promptId,
        'day_number': dayNumber,
        'response_text': responseText,
      });
    } catch (e) {
      throw Exception('Error al guardar respuesta de diario: $e');
    }
  }

  /// Obtiene todas las respuestas de diario de un día específico
  @override
  Future<List<JournalResponse>> getResponsesByDay(int dayNumber) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return [];

      final response = await _supabase
          .from('user_journal_responses')
          .select()
          .eq('user_id', userId)
          .eq('day_number', dayNumber)
          .order('created_at', ascending: true);

      return response.map((item) => JournalResponse.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Error al obtener respuestas de diario: $e');
    }
  }

  /// Actualiza una respuesta de diario
  @override
  Future<void> updateJournalResponse({
    required String promptId,
    required String responseText,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Usuario no autenticado');
      }

      if (responseText.length > 10000) {
        throw Exception('La respuesta excede el límite de 10,000 caracteres');
      }

      await _supabase
          .from('user_journal_responses')
          .update({'response_text': responseText})
          .eq('user_id', userId)
          .eq('prompt_id', promptId);
    } catch (e) {
      throw Exception('Error al actualizar respuesta de diario: $e');
    }
  }
}
```

## 🎯 5. Completar Tareas

### Marcar Tareas como Completadas

```dart
// lib/features/daily_journey/data/repositories/daily_journey_repository_impl.dart

class DailyJourneyRepositoryImpl implements DailyJourneyRepository {
  final SupabaseClient _supabase;

  DailyJourneyRepositoryImpl(this._supabase);

  /// Marca una tarea como completada
  @override
  Future<void> completeTask({
    required String itineraryItemId,
    required int dayNumber,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Usuario no autenticado');
      }

      await _supabase.from('user_task_completions').insert({
        'user_id': userId,
        'itinerary_item_id': itineraryItemId,
        'day_number': dayNumber,
      });
    } catch (e) {
      throw Exception('Error al completar tarea: $e');
    }
  }

  /// Desmarca una tarea (elimina completación)
  @override
  Future<void> uncompleteTask({
    required String itineraryItemId,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Usuario no autenticado');
      }

      await _supabase
          .from('user_task_completions')
          .delete()
          .eq('user_id', userId)
          .eq('itinerary_item_id', itineraryItemId);
    } catch (e) {
      throw Exception('Error al desmarcar tarea: $e');
    }
  }

  /// Obtiene todas las tareas completadas de un día
  @override
  Future<Set<String>> getCompletedTasks(int dayNumber) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return {};

      final response = await _supabase
          .from('user_task_completions')
          .select('itinerary_item_id')
          .eq('user_id', userId)
          .eq('day_number', dayNumber);

      return response
          .map((item) => item['itinerary_item_id'] as String)
          .toSet();
    } catch (e) {
      throw Exception('Error al obtener tareas completadas: $e');
    }
  }
}
```

## 🗑️ 6. GDPR - Anonimizar Datos del Usuario

### Función para Anonimizar Datos (Right to Erasure)

```dart
// lib/features/user/data/repositories/user_repository_impl.dart

class UserRepositoryImpl implements UserRepository {
  final SupabaseClient _supabase;

  UserRepositoryImpl(this._supabase);

  /// Anonimiza todos los datos del usuario actual (GDPR)
  /// Esto NO elimina la cuenta, solo anonimiza los datos personales
  @override
  Future<void> anonymizeUserData() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Usuario no autenticado');
      }

      // Llamar a la función PostgreSQL que anonimiza los datos
      await _supabase.rpc('anonymize_user_data', params: {
        'target_user_id': userId,
      });
    } catch (e) {
      throw Exception('Error al anonimizar datos: $e');
    }
  }

  /// Elimina completamente la cuenta del usuario
  /// Esto elimina el usuario de auth.users y cascadea a todas las tablas relacionadas
  @override
  Future<void> deleteAccount() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Usuario no autenticado');
      }

      // Primero anonimizar datos (opcional, para audit trail)
      await anonymizeUserData();

      // Luego eliminar cuenta de auth (esto cascadea a todas las tablas)
      // Nota: Esta operación requiere un Edge Function o backend
      // No se puede hacer directamente desde el cliente por seguridad

      throw UnimplementedError(
        'La eliminación de cuenta debe hacerse via backend/Edge Function'
      );
    } catch (e) {
      throw Exception('Error al eliminar cuenta: $e');
    }
  }
}
```

## 🔍 7. Verificar Rol de Admin

### Verificar si el Usuario es Admin

```dart
// lib/features/admin/data/repositories/admin_repository_impl.dart

class AdminRepositoryImpl implements AdminRepository {
  final SupabaseClient _supabase;

  AdminRepositoryImpl(this._supabase);

  /// Verifica si el usuario actual es admin
  @override
  Future<bool> isAdmin() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return false;

      // Llamar a la función PostgreSQL
      final response = await _supabase.rpc('is_admin', params: {
        'user_uuid': userId,
      }) as bool;

      return response;
    } catch (e) {
      return false;
    }
  }

  /// Obtiene el rol del usuario actual
  @override
  Future<String?> getUserRole() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return null;

      final response = await _supabase
          .from('admin_roles')
          .select('role')
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) return null;

      return response['role'] as String;
    } catch (e) {
      return null;
    }
  }
}
```

## 🛡️ 8. Manejo de Errores de Seguridad

### Errores Comunes y Cómo Manejarlos

```dart
// lib/core/error/supabase_error_handler.dart

class SupabaseErrorHandler {
  static String getErrorMessage(dynamic error) {
    if (error is AuthException) {
      return _handleAuthException(error);
    } else if (error is PostgrestException) {
      return _handlePostgrestException(error);
    } else {
      return 'Error inesperado: ${error.toString()}';
    }
  }

  static String _handleAuthException(AuthException error) {
    switch (error.statusCode) {
      case '400':
        return 'Credenciales inválidas';
      case '422':
        return 'Email ya registrado';
      case '429':
        return 'Demasiados intentos. Intenta más tarde.';
      default:
        return error.message;
    }
  }

  static String _handlePostgrestException(PostgrestException error) {
    // Errores de RLS (Row Level Security)
    if (error.code == '42501') {
      return 'No tienes permisos para realizar esta acción';
    }

    // Violación de constraint único
    if (error.code == '23505') {
      return 'Este registro ya existe';
    }

    // Foreign key violation
    if (error.code == '23503') {
      return 'Referencia inválida';
    }

    // Check constraint violation
    if (error.code == '23514') {
      return 'Datos inválidos: ${error.message}';
    }

    return error.message;
  }
}
```

## 📱 9. Ejemplo Completo en un Widget

### Pantalla de Perfil de Usuario con Seguridad

```dart
// lib/features/user_profile/presentation/pages/profile_screen.dart

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _allergiesController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);

    try {
      final repository = ref.read(userProfileRepositoryProvider);
      final profile = await repository.getProfile();

      if (profile != null && mounted) {
        _allergiesController.text = profile.allergies.join(', ');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(SupabaseErrorHandler.getErrorMessage(e))),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _saveProfile() async {
    setState(() => _isLoading = true);

    try {
      final repository = ref.read(userProfileRepositoryProvider);
      final allergies = _allergiesController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      await repository.updateProfile(allergies: allergies);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil actualizado')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(SupabaseErrorHandler.getErrorMessage(e))),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _anonymizeData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Anonimizar Datos'),
        content: const Text(
          '¿Estás seguro de que quieres anonimizar tus datos? '
          'Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Anonimizar'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isLoading = true);

    try {
      final repository = ref.read(userRepositoryProvider);
      await repository.anonymizeUserData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Datos anonimizados exitosamente')),
        );
        Navigator.pop(context); // Regresar a pantalla anterior
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(SupabaseErrorHandler.getErrorMessage(e))),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _anonymizeData,
            tooltip: 'Anonimizar mis datos',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _allergiesController,
                    decoration: const InputDecoration(
                      labelText: 'Alergias (separadas por coma)',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: _saveProfile,
                    child: const Text('Guardar'),
                  ),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    _allergiesController.dispose();
    super.dispose();
  }
}
```

## 🎓 Mejores Prácticas

### ✅ DO (Hacer)

1. **Siempre verificar autenticación antes de operaciones**
   ```dart
   final userId = _supabase.auth.currentUser?.id;
   if (userId == null) {
     throw Exception('Usuario no autenticado');
   }
   ```

2. **Confiar en RLS para protección de datos**
   ```dart
   // RLS automáticamente filtra por user_id
   final response = await _supabase
       .from('user_profiles')
       .select()
       .eq('user_id', userId); // Redundante pero explícito
   ```

3. **Validar inputs en cliente Y servidor**
   ```dart
   if (responseText.length > 10000) {
     throw Exception('Texto demasiado largo');
   }
   // También hay constraint en la base de datos
   ```

4. **Manejar errores apropiadamente**
   ```dart
   try {
     // operación
   } on AuthException catch (e) {
     // manejar error de auth
   } on PostgrestException catch (e) {
     // manejar error de BD
   }
   ```

### ❌ DON'T (No Hacer)

1. **NO usar service role key en la app**
   ```dart
   // ❌ NUNCA HACER ESTO
   final supabase = SupabaseClient(
     'url',
     'service-role-key', // ¡PELIGRO!
   );
   ```

2. **NO asumir que tienes acceso a datos de otros usuarios**
   ```dart
   // ❌ Esto fallará con RLS
   final allProfiles = await _supabase
       .from('user_profiles')
       .select(); // Solo retorna tu perfil
   ```

3. **NO ignorar errores de seguridad**
   ```dart
   // ❌ MALO
   try {
     await operation();
   } catch (e) {
     // Ignorar silenciosamente
   }

   // ✅ BUENO
   try {
     await operation();
   } catch (e) {
     logger.error('Error en operación', e);
     rethrow; // O manejar apropiadamente
   }
   ```

---

**Última actualización:** 2025-01-04
