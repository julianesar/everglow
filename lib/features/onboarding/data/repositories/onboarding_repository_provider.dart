import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/repositories/onboarding_repository.dart';

// Use the Supabase implementation provider
import 'onboarding_repository_impl_supabase.dart' as supabase_impl;

part 'onboarding_repository_provider.g.dart';

/// Provider for [OnboardingRepository]
///
/// Now using the Supabase implementation to save data in the cloud.
@riverpod
Future<OnboardingRepository> onboardingRepository(
  OnboardingRepositoryRef ref,
) async {
  // Delegate to the Supabase implementation provider
  return ref.watch(supabase_impl.onboardingRepositoryProvider.future);
}
