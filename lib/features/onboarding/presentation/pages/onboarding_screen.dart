import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/onboarding_question.dart';
import '../../domain/entities/onboarding_section.dart';
import '../../data/repositories/onboarding_repository_provider.dart';
import '../../../booking/data/repositories/booking_repository_impl.dart';
import '../../../auth/data/repositories/auth_repository_impl.dart';

/// Section-based onboarding screen with transition pages
///
/// This screen presents onboarding questions organized into sections,
/// with elegant transition pages between sections to provide visual
/// separation and completion feedback.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  /// Controller for the PageView
  final PageController _pageController = PageController();

  /// Loading state
  bool _isLoading = true;

  /// Error message if loading fails
  String? _errorMessage;


  /// Flattened list of pages (questions + transition pages)
  List<Widget> _pages = [];

  /// Current page index
  int _currentPageIndex = 0;

  /// User's answers keyed by question ID
  final Map<String, dynamic> _answers = {};

  /// Whether we're submitting the final answers
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadOnboardingData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Loads onboarding sections from the repository
  Future<void> _loadOnboardingData() async {
    try {
      final repository = await ref.read(onboardingRepositoryProvider.future);
      final sections = await repository.getOnboardingQuestions();

      setState(() {
        _pages = _flattenSectionsIntoPages(sections);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load onboarding questions: $e';
        _isLoading = false;
      });
    }
  }

  /// Flattens sections into a list of pages
  ///
  /// Creates question pages for each question and inserts transition pages
  /// between sections (if there are multiple sections).
  /// Adds a final completion page after all sections.
  List<Widget> _flattenSectionsIntoPages(List<OnboardingSection> sections) {
    final List<Widget> pages = [];

    for (int sectionIndex = 0; sectionIndex < sections.length; sectionIndex++) {
      final section = sections[sectionIndex];
      final isLastSection = sectionIndex == sections.length - 1;

      // Add all question pages for this section
      for (
        int questionIndex = 0;
        questionIndex < section.questions.length;
        questionIndex++
      ) {
        final question = section.questions[questionIndex];
        final isLastQuestionInSection =
            questionIndex == section.questions.length - 1;

        pages.add(
          QuestionPage(
            question: question,
            sectionTitle: section.title,
            questionNumber: questionIndex + 1,
            totalQuestionsInSection: section.questions.length,
            initialAnswer: _answers[question.id],
            onAnswerChanged: (value) {
              setState(() {
                _answers[question.id] = value;
              });
            },
          ),
        );

        // Insert transition page after last question of section
        // (but not after the very last section)
        if (isLastQuestionInSection && !isLastSection) {
          final nextSection = sections[sectionIndex + 1];
          pages.add(
            TransitionPage(
              completedSectionTitle: section.title,
              nextSectionTitle: nextSection.title,
            ),
          );
        }
      }
    }

    // Add final completion page after all sections
    if (sections.isNotEmpty) {
      pages.add(const CompletionPage());
    }

    return pages;
  }

  /// Navigates to the next page
  void _nextPage() {
    if (_currentPageIndex < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Last page - submit answers
      _submitAnswers();
    }
  }

  /// Navigates to the previous page
  void _previousPage() {
    if (_currentPageIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Submits the onboarding answers
  Future<void> _submitAnswers() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      // Submit onboarding answers
      final repository = await ref.read(onboardingRepositoryProvider.future);
      await repository.submitOnboardingAnswers(_answers);

      // Get the authenticated user's ID
      final authRepository = ref.read(authRepositoryProvider);
      final currentUser = authRepository.currentUser;

      if (currentUser == null) {
        throw Exception('No authenticated user found');
      }

      // Create the booking using the saved date from the booking screen
      // This ensures the user has an active booking before accessing logistics hub
      final bookingRepository = await ref.read(bookingRepositoryProvider.future);
      final selectedDate = ref.read(selectedBookingDateProvider);

      if (selectedDate != null) {
        // Create booking with the selected date and current user's ID
        await bookingRepository.createBooking(
          startDate: selectedDate,
          userId: currentUser.id,
        );
      } else {
        // Fallback: Create booking with default date (30 days from now)
        // This handles the case where user skipped booking screen
        final defaultDate = DateTime.now().add(const Duration(days: 30));
        await bookingRepository.createBooking(
          startDate: defaultDate,
          userId: currentUser.id,
        );
      }

      if (mounted) {
        // Navigate to main tabs after onboarding completion
        // This will show the Logistics Hub as the first tab
        context.go('/tabs');
      }
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error submitting answers: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Loading state
    if (_isLoading) {
      return Scaffold(
        backgroundColor: colorScheme.surface,
        body: Center(
          child: CircularProgressIndicator(color: colorScheme.primary),
        ),
      );
    }

    // Error state
    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: colorScheme.surface,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: colorScheme.error),
                const SizedBox(height: 24),
                Text(
                  'Oops!',
                  style: theme.textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  _errorMessage!,
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isLoading = true;
                      _errorMessage = null;
                    });
                    _loadOnboardingData();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Main onboarding flow
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          // Progress bar at top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: _OnboardingProgressBar(
                currentPage: _currentPageIndex,
                totalPages: _pages.length,
              ),
            ),
          ),

          // PageView with all pages
          Padding(
            padding: const EdgeInsets.only(top: 80),
            child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (index) {
              setState(() {
                _currentPageIndex = index;
              });
            },
            children: _pages,
            ),
          ),

          // Navigation buttons at bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                border: Border(
                  top: BorderSide(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    // Back button (if not on first page)
                    if (_currentPageIndex > 0)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _previousPage,
                          child: const Text('Back'),
                        ),
                      ),
                    if (_currentPageIndex > 0) const SizedBox(width: 16),

                    // Next/Submit button
                    Expanded(
                      flex: _currentPageIndex > 0 ? 1 : 2,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _nextPage,
                        child: _isSubmitting
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: colorScheme.onPrimary,
                                ),
                              )
                            : Text(
                                _currentPageIndex == _pages.length - 1
                                    ? 'Complete'
                                    : 'Continue',
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Transition page displayed between sections
///
/// Shows completion feedback for the previous section and introduces
/// the next section.
class TransitionPage extends StatelessWidget {
  final String completedSectionTitle;
  final String nextSectionTitle;

  const TransitionPage({
    super.key,
    required this.completedSectionTitle,
    required this.nextSectionTitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Success icon
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: colorScheme.primary,
                    size: 64,
                  ),
                ),

                const SizedBox(height: 32),

                // Completion message
                Text(
                  '$completedSectionTitle Complete',
                  style: theme.textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                // Next section introduction
                Text(
                  'Great! Now, let\'s continue with $nextSectionTitle.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 48),

                // Visual separator
                Container(
                  height: 2,
                  width: 80,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Question page displaying a single onboarding question
///
/// Handles different question types (text, multiple choice, yes/no, etc.)
/// and collects user input.
class QuestionPage extends StatefulWidget {
  final OnboardingQuestion question;
  final String sectionTitle;
  final int questionNumber;
  final int totalQuestionsInSection;
  final dynamic initialAnswer;
  final ValueChanged<dynamic> onAnswerChanged;

  const QuestionPage({
    super.key,
    required this.question,
    required this.sectionTitle,
    required this.questionNumber,
    required this.totalQuestionsInSection,
    this.initialAnswer,
    required this.onAnswerChanged,
  });

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  late TextEditingController _textController;
  late dynamic _currentAnswer;

  @override
  void initState() {
    super.initState();
    _currentAnswer = widget.initialAnswer;
    _textController = TextEditingController(
      text: widget.initialAnswer?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _updateAnswer(dynamic value) {
    setState(() {
      _currentAnswer = value;
    });
    widget.onAnswerChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Section title and progress
              Text(
                widget.sectionTitle.toUpperCase(),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.primary,
                  letterSpacing: 1.5,
                ),
              ),

              const SizedBox(height: 8),

              // Question number indicator
              Text(
                'Question ${widget.questionNumber} of ${widget.totalQuestionsInSection}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),

              const SizedBox(height: 32),

              // Question text
              Text(
                widget.question.questionText,
                style: theme.textTheme.headlineSmall,
              ),

              const SizedBox(height: 8),

              // Required indicator
              if (widget.question.isRequired)
                Text(
                  'Required',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.primary.withValues(alpha: 0.7),
                  ),
                ),

              const SizedBox(height: 32),

              // Question input based on type
              _buildQuestionInput(theme, colorScheme),

              const SizedBox(height: 100), // Space for bottom navigation
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionInput(ThemeData theme, ColorScheme colorScheme) {
    switch (widget.question.questionType) {
      case QuestionType.text:
        return _buildTextInput(theme);

      case QuestionType.multipleChoice:
        return _buildMultipleChoice(theme, colorScheme);

      case QuestionType.yesNo:
        return _buildYesNo(theme, colorScheme);

      case QuestionType.multipleSelection:
        return _buildMultipleSelection(theme, colorScheme);
    }
  }

  Widget _buildTextInput(ThemeData theme) {
    return TextField(
      controller: _textController,
      onChanged: _updateAnswer,
      decoration: InputDecoration(
        hintText: widget.question.placeholder ?? 'Type your answer here...',
      ),
      maxLines: 4,
      textInputAction: TextInputAction.done,
    );
  }

  Widget _buildMultipleChoice(ThemeData theme, ColorScheme colorScheme) {
    final options = widget.question.options ?? [];

    return Column(
      children: options.map((option) {
        final isSelected = _currentAnswer == option;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: InkWell(
            onTap: () => _updateAnswer(option),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected
                    ? colorScheme.primary.withValues(alpha: 0.1)
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurface.withValues(alpha: 0.2),
                  width: isSelected ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    isSelected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      option,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.onSurface,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildYesNo(ThemeData theme, ColorScheme colorScheme) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () => _updateAnswer(true),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: _currentAnswer == true
                    ? colorScheme.primary.withValues(alpha: 0.1)
                    : Colors.transparent,
                border: Border.all(
                  color: _currentAnswer == true
                      ? colorScheme.primary
                      : colorScheme.onSurface.withValues(alpha: 0.2),
                  width: _currentAnswer == true ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Yes',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: _currentAnswer == true
                      ? colorScheme.primary
                      : colorScheme.onSurface,
                  fontWeight: _currentAnswer == true
                      ? FontWeight.w600
                      : FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: InkWell(
            onTap: () => _updateAnswer(false),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: _currentAnswer == false
                    ? colorScheme.primary.withValues(alpha: 0.1)
                    : Colors.transparent,
                border: Border.all(
                  color: _currentAnswer == false
                      ? colorScheme.primary
                      : colorScheme.onSurface.withValues(alpha: 0.2),
                  width: _currentAnswer == false ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'No',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: _currentAnswer == false
                      ? colorScheme.primary
                      : colorScheme.onSurface,
                  fontWeight: _currentAnswer == false
                      ? FontWeight.w600
                      : FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMultipleSelection(ThemeData theme, ColorScheme colorScheme) {
    final options = widget.question.options ?? [];
    final selectedOptions = (_currentAnswer as List<String>?) ?? [];

    return Column(
      children: options.map((option) {
        final isSelected = selectedOptions.contains(option);

        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: InkWell(
            onTap: () {
              final updatedSelections = List<String>.from(selectedOptions);
              if (isSelected) {
                updatedSelections.remove(option);
              } else {
                updatedSelections.add(option);
              }
              _updateAnswer(updatedSelections);
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected
                    ? colorScheme.primary.withValues(alpha: 0.1)
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurface.withValues(alpha: 0.2),
                  width: isSelected ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    isSelected
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      option,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.onSurface,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Progress bar widget showing onboarding completion percentage
///
/// Displays visual progress through the onboarding flow with page count
class _OnboardingProgressBar extends StatelessWidget {
  const _OnboardingProgressBar({
    required this.currentPage,
    required this.totalPages,
  });

  final int currentPage;
  final int totalPages;

  @override
  Widget build(BuildContext context) {
    final progress = totalPages > 0 ? (currentPage + 1) / totalPages : 0.0;

    return Container(
      padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '${currentPage + 1} / $totalPages',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Completion page displayed after all onboarding questions are finished
///
/// Shows a congratulatory message and indicates that the user is ready
/// to start their experience.
class CompletionPage extends StatelessWidget {
  const CompletionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Success icon
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.celebration,
                    color: colorScheme.primary,
                    size: 72,
                  ),
                ),

                const SizedBox(height: 40),

                // Completion message
                Text(
                  'All Set!',
                  style: theme.textTheme.headlineLarge,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                // Encouragement message
                Text(
                  'Thank you for completing the onboarding. Your personalized experience is ready.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 48),

                // Visual separator
                Container(
                  height: 2,
                  width: 80,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),

                const SizedBox(height: 16),

                // Next step indication
                Text(
                  'Press "Complete" to begin your journey',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
