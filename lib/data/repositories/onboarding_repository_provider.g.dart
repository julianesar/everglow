// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$onboardingRepositoryHash() =>
    r'c9f6dd3a21379f14987a0c43c2f9c7d2124b8024';

/// Provider for [OnboardingRepository]
///
/// Returns a static implementation for now. When switching to Supabase,
/// simply update the return statement to use SupabaseOnboardingRepository.
///
/// Copied from [onboardingRepository].
@ProviderFor(onboardingRepository)
final onboardingRepositoryProvider =
    AutoDisposeFutureProvider<OnboardingRepository>.internal(
      onboardingRepository,
      name: r'onboardingRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$onboardingRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef OnboardingRepositoryRef =
    AutoDisposeFutureProviderRef<OnboardingRepository>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
