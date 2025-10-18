import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../../../../core/database/isar_provider.dart';
import 'onboarding_repository_impl.dart';

part 'onboarding_repository_provider.g.dart';

/// Provider for [OnboardingRepository]
///
/// Returns a static implementation for now. When switching to Supabase,
/// simply update the return statement to use SupabaseOnboardingRepository.
@riverpod
Future<OnboardingRepository> onboardingRepository(
  OnboardingRepositoryRef ref,
) async {
  final isar = await ref.watch(isarProvider.future);

  // Return static implementation for now
  return StaticOnboardingRepository(isar);

  // When switching to Supabase, just change this line:
  // return SupabaseOnboardingRepository(
  //   supabaseClient: ref.watch(supabaseClientProvider),
  // );
}
