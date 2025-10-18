import 'onboarding_question.dart';

/// Entity representing a section in the onboarding flow
///
/// This is a domain entity that groups related questions together
/// into logical sections (e.g., Medical Intake, Lifestyle Preferences).
/// Each section contains a title and a list of questions to be presented
/// to the user during the onboarding process.
class OnboardingSection {
  /// The title of this section (e.g., "Medical Intake", "Lifestyle Preferences")
  final String title;

  /// The list of questions belonging to this section
  final List<OnboardingQuestion> questions;

  const OnboardingSection({
    required this.title,
    required this.questions,
  });

  /// Creates a copy of this section with the given fields replaced
  OnboardingSection copyWith({
    String? title,
    List<OnboardingQuestion>? questions,
  }) {
    return OnboardingSection(
      title: title ?? this.title,
      questions: questions ?? this.questions,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OnboardingSection &&
        other.title == title &&
        _listEquals(other.questions, questions);
  }

  @override
  int get hashCode => title.hashCode ^ questions.hashCode;

  @override
  String toString() {
    return 'OnboardingSection(title: $title, questions: ${questions.length} questions)';
  }

  /// Helper method to compare two lists for equality
  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
