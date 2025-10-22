import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/onboarding_question.dart';
import '../../domain/entities/onboarding_section.dart';
import '../../data/repositories/onboarding_repository_provider.dart';
import '../../../booking/data/repositories/booking_repository_impl.dart';
import '../../../auth/data/repositories/auth_repository_impl.dart';

/// Page type enum for different page types in the onboarding flow
enum _PageType {
  question,
  transition,
  completion,
}

/// Metadata for a page in the onboarding flow
class _PageInfo {
  final _PageType type;
  final OnboardingQuestion? question;
  final String? sectionTitle;
  final int? questionNumber;
  final int? totalQuestionsInSection;
  final String? completedSectionTitle;
  final String? nextSectionTitle;

  const _PageInfo({
    required this.type,
    this.question,
    this.sectionTitle,
    this.questionNumber,
    this.totalQuestionsInSection,
    this.completedSectionTitle,
    this.nextSectionTitle,
  });
}

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


  /// Sections loaded from the repository
  List<OnboardingSection> _sections = [];

  /// Page metadata (for building pages dynamically)
  List<_PageInfo> _pageInfos = [];

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
      print('═══════════════════════════════════════════════════');
      print('📋 [ONBOARDING_SCREEN] Loading onboarding data...');

      final repository = await ref.read(onboardingRepositoryProvider.future);
      final sections = await repository.getOnboardingQuestions();

      print('📊 [ONBOARDING_SCREEN] Loaded ${sections.length} sections:');
      for (final section in sections) {
        print('   - ${section.title}: ${section.questions.length} questions');
      }

      setState(() {
        _sections = sections;
        _pageInfos = _buildPageInfos(sections);
        print('📄 [ONBOARDING_SCREEN] Created ${_pageInfos.length} total pages');
        _isLoading = false;
      });

      print('✅ [ONBOARDING_SCREEN] Onboarding data loaded successfully');
      print('═══════════════════════════════════════════════════');
    } catch (e) {
      print('❌ [ONBOARDING_SCREEN] Error loading onboarding data: $e');
      print('═══════════════════════════════════════════════════');
      setState(() {
        _errorMessage = 'Failed to load onboarding questions: $e';
        _isLoading = false;
      });
    }
  }

  /// Builds metadata for all pages in the onboarding flow
  ///
  /// Creates page info for each question and inserts transition pages
  /// between sections (if there are multiple sections).
  /// Adds a final completion page after all sections.
  /// Skips empty sections (sections with no questions).
  List<_PageInfo> _buildPageInfos(List<OnboardingSection> sections) {
    print('🔧 [ONBOARDING_SCREEN] _buildPageInfos called with ${sections.length} sections');
    final List<_PageInfo> pageInfos = [];

    // Filter out empty sections
    final nonEmptySections = sections
        .where((section) => section.questions.isNotEmpty)
        .toList();

    print('🔧 [ONBOARDING_SCREEN] After filtering: ${nonEmptySections.length} non-empty sections');

    for (int sectionIndex = 0; sectionIndex < nonEmptySections.length; sectionIndex++) {
      final section = nonEmptySections[sectionIndex];
      final isLastSection = sectionIndex == nonEmptySections.length - 1;

      print('🔧 [ONBOARDING_SCREEN] Processing section "${"${section.title}"}" with ${section.questions.length} questions');

      // Add all question pages for this section
      for (
        int questionIndex = 0;
        questionIndex < section.questions.length;
        questionIndex++
      ) {
        final question = section.questions[questionIndex];
        final isLastQuestionInSection =
            questionIndex == section.questions.length - 1;

        print('   ➕ Adding QuestionPage info: "${question.questionText.substring(0, question.questionText.length > 50 ? 50 : question.questionText.length)}..."');

        pageInfos.add(
          _PageInfo(
            type: _PageType.question,
            question: question,
            sectionTitle: section.title,
            questionNumber: questionIndex + 1,
            totalQuestionsInSection: section.questions.length,
          ),
        );

        // Insert transition page after last question of section
        // (but not after the very last section)
        if (isLastQuestionInSection && !isLastSection) {
          final nextSection = nonEmptySections[sectionIndex + 1];
          print('   ➕ Adding TransitionPage info: "${section.title}" → "${nextSection.title}"');
          pageInfos.add(
            _PageInfo(
              type: _PageType.transition,
              completedSectionTitle: section.title,
              nextSectionTitle: nextSection.title,
            ),
          );
        }
      }
    }

    // Add final completion page after all sections (only if we have questions)
    if (pageInfos.isNotEmpty) {
      print('🔧 [ONBOARDING_SCREEN] Adding CompletionPage info');
      pageInfos.add(const _PageInfo(type: _PageType.completion));
    } else {
      print('⚠️ [ONBOARDING_SCREEN] WARNING: No pages created! All sections were empty.');
    }

    print('🔧 [ONBOARDING_SCREEN] Total page infos created: ${pageInfos.length}');
    return pageInfos;
  }

  /// Builds a page widget based on page info
  Widget _buildPage(_PageInfo pageInfo) {
    switch (pageInfo.type) {
      case _PageType.question:
        return QuestionPage(
          question: pageInfo.question!,
          sectionTitle: pageInfo.sectionTitle!,
          questionNumber: pageInfo.questionNumber!,
          totalQuestionsInSection: pageInfo.totalQuestionsInSection!,
          initialAnswer: _answers[pageInfo.question!.id],
          onAnswerChanged: (value) {
            setState(() {
              _answers[pageInfo.question!.id] = value;
            });
          },
        );
      case _PageType.transition:
        return TransitionPage(
          completedSectionTitle: pageInfo.completedSectionTitle!,
          nextSectionTitle: pageInfo.nextSectionTitle!,
        );
      case _PageType.completion:
        return const CompletionPage();
    }
  }

  /// Checks if the current page can be navigated away from
  bool _canProceed() {
    final currentPageInfo = _pageInfos[_currentPageIndex];

    // Always allow navigation from transition and completion pages
    if (currentPageInfo.type != _PageType.question) {
      return true;
    }

    // For question pages, check if answer is provided (if required)
    final question = currentPageInfo.question!;
    if (!question.isRequired) {
      return true; // Optional questions can be skipped
    }

    // Check if there's an answer for this required question
    final answer = _answers[question.id];

    // Validate based on question type
    switch (question.questionType) {
      case QuestionType.text:
        // Text must not be empty or just whitespace
        return answer != null && answer.toString().trim().isNotEmpty;

      case QuestionType.multipleChoice:
      case QuestionType.yesNo:
        // Must have a selected value
        return answer != null;

      case QuestionType.multipleSelection:
        // Must have at least one selection
        return answer != null && (answer as List).isNotEmpty;
    }
  }

  /// Navigates to the next page
  void _nextPage() {
    // Hide keyboard when navigating
    FocusScope.of(context).unfocus();

    if (_currentPageIndex < _pageInfos.length - 1) {
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
    print('═══════════════════════════════════════════════════');
    print('🚀 [ONBOARDING_SCREEN] _submitAnswers called');
    print('📝 [ONBOARDING_SCREEN] Answers collected: ${_answers.length}');
    print('📋 [ONBOARDING_SCREEN] Answers data: $_answers');

    setState(() {
      _isSubmitting = true;
    });

    try {
      print('📥 [ONBOARDING_SCREEN] Getting repository...');
      final repository = await ref.read(onboardingRepositoryProvider.future);
      print('✅ [ONBOARDING_SCREEN] Repository obtained, calling submitOnboardingAnswers...');

      await repository.submitOnboardingAnswers(_answers);

      print('✅ [ONBOARDING_SCREEN] submitOnboardingAnswers completed!');

      // Get the authenticated user's ID
      print('👤 [ONBOARDING_SCREEN] Getting authenticated user...');
      final authRepository = ref.read(authRepositoryProvider);
      final currentUser = authRepository.currentUser;
      print('✅ [ONBOARDING_SCREEN] Current user: ${currentUser?.id}');

      if (currentUser == null) {
        print('❌ [ONBOARDING_SCREEN] No authenticated user found!');
        throw Exception('No authenticated user found');
      }

      // Create the booking using the saved date from the booking screen
      print('📅 [ONBOARDING_SCREEN] Creating booking...');
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
    } catch (e, stackTrace) {
      print('❌ [ONBOARDING_SCREEN] ERROR in _submitAnswers!');
      print('❌ [ONBOARDING_SCREEN] Error: $e');
      print('❌ [ONBOARDING_SCREEN] Stack trace:');
      print(stackTrace);
      print('═══════════════════════════════════════════════════');

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
                totalPages: _pageInfos.length,
              ),
            ),
          ),

          // PageView with all pages (built dynamically)
          Padding(
            padding: const EdgeInsets.only(top: 80),
            child: PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _pageInfos.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPageIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return _buildPage(_pageInfos[index]);
              },
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
                        onPressed: (_isSubmitting || !_canProceed()) ? null : _nextPage,
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
                                _currentPageIndex == _pageInfos.length - 1
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
  void didUpdateWidget(QuestionPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update state when initialAnswer changes (e.g., when navigating back)
    if (widget.initialAnswer != oldWidget.initialAnswer) {
      setState(() {
        _currentAnswer = widget.initialAnswer;
      });
      // Update text controller for text input questions
      if (widget.question.questionType == QuestionType.text) {
        _textController.text = widget.initialAnswer?.toString() ?? '';
      }
    }
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
      onSubmitted: (_) {
        // Hide keyboard when user presses done/submit
        FocusScope.of(context).unfocus();
      },
      style: theme.textTheme.titleMedium,
      decoration: InputDecoration(
        hintText: widget.question.placeholder ?? 'Type your answer here...',
        hintStyle: theme.textTheme.titleMedium?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
        ),
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
