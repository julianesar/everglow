import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/repositories/user_repository.dart';

part 'onboarding_controller.g.dart';

/// Immutable state class for the Onboarding screen.
///
/// Manages the user input state and button enablement logic.
class OnboardingState {
  /// Creates an [OnboardingState] instance.
  const OnboardingState({
    required this.name,
    required this.statement,
    required this.isButtonEnabled,
  });

  /// Creates the initial state with empty values.
  const OnboardingState.initial()
      : name = '',
        statement = '',
        isButtonEnabled = false;

  /// The user's name input.
  final String name;

  /// The user's integration statement input.
  final String statement;

  /// Whether the submit button should be enabled.
  ///
  /// The button is enabled when both [name] and [statement] are not empty.
  final bool isButtonEnabled;

  /// Creates a copy of this state with the given fields replaced.
  OnboardingState copyWith({
    String? name,
    String? statement,
    bool? isButtonEnabled,
  }) {
    return OnboardingState(
      name: name ?? this.name,
      statement: statement ?? this.statement,
      isButtonEnabled: isButtonEnabled ?? this.isButtonEnabled,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OnboardingState &&
        other.name == name &&
        other.statement == statement &&
        other.isButtonEnabled == isButtonEnabled;
  }

  @override
  int get hashCode => name.hashCode ^ statement.hashCode ^ isButtonEnabled.hashCode;
}

/// Controller for managing onboarding screen state and logic.
///
/// This controller handles user input validation and data persistence
/// through the [UserRepository].
@riverpod
class OnboardingController extends _$OnboardingController {
  @override
  OnboardingState build() {
    return const OnboardingState.initial();
  }

  /// Updates the user's name in the state.
  ///
  /// Also recalculates whether the submit button should be enabled.
  void updateName(String name) {
    state = state.copyWith(
      name: name,
      isButtonEnabled: _shouldEnableButton(name, state.statement),
    );
  }

  /// Updates the user's integration statement in the state.
  ///
  /// Also recalculates whether the submit button should be enabled.
  void updateStatement(String statement) {
    state = state.copyWith(
      statement: statement,
      isButtonEnabled: _shouldEnableButton(state.name, statement),
    );
  }

  /// Submits the onboarding data to the repository.
  ///
  /// Validates that both name and statement are not empty before saving.
  /// Throws an [ArgumentError] if validation fails.
  Future<void> submitOnboarding() async {
    if (state.name.isEmpty || state.statement.isEmpty) {
      throw ArgumentError('Name and statement cannot be empty');
    }

    final repository = await ref.read(userRepositoryProvider.future);
    await repository.saveUser(
      name: state.name,
      integrationStatement: state.statement,
    );
  }

  /// Determines if the submit button should be enabled.
  ///
  /// The button is enabled when both [name] and [statement] are not empty
  /// after trimming whitespace.
  bool _shouldEnableButton(String name, String statement) {
    return name.trim().isNotEmpty && statement.trim().isNotEmpty;
  }
}
