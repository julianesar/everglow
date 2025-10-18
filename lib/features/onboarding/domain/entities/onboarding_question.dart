/// Enum representing the type of question in the onboarding flow
enum QuestionType {
  /// Free text input question
  text,

  /// Multiple choice question with predefined options
  multipleChoice,

  /// Yes/No binary question
  yesNo,

  /// Multiple selection question (can select multiple options)
  multipleSelection,
}

/// Entity representing an onboarding question
///
/// This is a domain entity that represents a question asked during
/// the user onboarding process. It supports various question types
/// and optional choices for multiple choice questions.
class OnboardingQuestion {
  /// Unique identifier for the question
  final String id;

  /// The question text displayed to the user
  final String questionText;

  /// The type of question (text, multiple choice, yes/no, etc.)
  final QuestionType questionType;

  /// Optional list of choices for multiple choice or multiple selection questions
  final List<String>? options;

  /// Optional placeholder text for text input questions
  final String? placeholder;

  /// Whether this question is required
  final bool isRequired;

  /// Category of the question (e.g., 'medical', 'concierge', 'lifestyle')
  final String category;

  const OnboardingQuestion({
    required this.id,
    required this.questionText,
    required this.questionType,
    this.options,
    this.placeholder,
    this.isRequired = true,
    required this.category,
  });

  /// Creates a copy of this question with the given fields replaced
  OnboardingQuestion copyWith({
    String? id,
    String? questionText,
    QuestionType? questionType,
    List<String>? options,
    String? placeholder,
    bool? isRequired,
    String? category,
  }) {
    return OnboardingQuestion(
      id: id ?? this.id,
      questionText: questionText ?? this.questionText,
      questionType: questionType ?? this.questionType,
      options: options ?? this.options,
      placeholder: placeholder ?? this.placeholder,
      isRequired: isRequired ?? this.isRequired,
      category: category ?? this.category,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OnboardingQuestion &&
        other.id == id &&
        other.questionText == questionText &&
        other.questionType == questionType &&
        other.placeholder == placeholder &&
        other.isRequired == isRequired &&
        other.category == category;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        questionText.hashCode ^
        questionType.hashCode ^
        placeholder.hashCode ^
        isRequired.hashCode ^
        category.hashCode;
  }

  @override
  String toString() {
    return 'OnboardingQuestion(id: $id, questionText: $questionText, questionType: $questionType, category: $category)';
  }
}
