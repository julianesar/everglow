import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/repositories/onboarding_repository_provider.dart';
import '../../../domain/models/onboarding_question.dart';

/// Modern onboarding screen with step-by-step PageView experience
///
/// This screen presents onboarding questions one at a time in a focused
/// PageView format with progress tracking and dynamic input widgets.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  final Map<String, dynamic> _answers = {};
  int _currentPage = 0;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Navigate to the next page or submit if on the last page
  void _handleNext(int totalQuestions) {
    if (_currentPage < totalQuestions - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Navigate to the previous page
  void _handleBack() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Submit the onboarding answers and navigate to day 1
  Future<void> _submitOnboarding() async {
    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final repository = await ref.read(onboardingRepositoryProvider.future);
      await repository.submitOnboardingAnswers(_answers);

      if (mounted) {
        context.go('/day/1');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error submitting onboarding: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  /// Check if the current question has been answered
  bool _isCurrentQuestionAnswered(OnboardingQuestion question) {
    if (!question.isRequired) return true;

    final answer = _answers[question.id];
    if (answer == null) return false;

    // Check for non-empty answers based on type
    if (answer is String) return answer.trim().isNotEmpty;
    if (answer is List) return answer.isNotEmpty;

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final repositoryAsync = ref.watch(onboardingRepositoryProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: repositoryAsync.when(
        data: (repository) => FutureBuilder<List<OnboardingQuestion>>(
          future: repository.getOnboardingQuestions(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading questions',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      snapshot.error.toString(),
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => setState(() {}),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            final questions = snapshot.data ?? [];
            if (questions.isEmpty) {
              return const Center(
                child: Text('No onboarding questions available'),
              );
            }

            return SafeArea(
              child: Column(
                children: [
                  // Progress indicator at the top
                  _buildProgressIndicator(questions.length),

                  // PageView with questions
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      onPageChanged: (page) {
                        setState(() {
                          _currentPage = page;
                        });
                      },
                      itemCount: questions.length,
                      itemBuilder: (context, index) {
                        return _buildQuestionPage(
                          questions[index],
                          index,
                          questions.length,
                        );
                      },
                    ),
                  ),

                  // Navigation buttons
                  _buildNavigationButtons(questions),
                ],
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error loading repository',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  ref.invalidate(onboardingRepositoryProvider);
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build the progress indicator showing current step
  Widget _buildProgressIndicator(int totalQuestions) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Step ${_currentPage + 1} of $totalQuestions',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Text(
                '${((_currentPage + 1) / totalQuestions * 100).toInt()}%',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: (_currentPage + 1) / totalQuestions,
              minHeight: 8,
              backgroundColor: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build a single question page
  Widget _buildQuestionPage(OnboardingQuestion question, int index, int total) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Category badge
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getCategoryColor(question.category).withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                question.category.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: _getCategoryColor(question.category),
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Question text
          Text(
            question.questionText,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),

          // Required indicator
          if (question.isRequired)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.star,
                    size: 12,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Required',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 32),

          // Dynamic input widget based on question type
          _buildInputWidget(question),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  /// Build the appropriate input widget based on question type
  Widget _buildInputWidget(OnboardingQuestion question) {
    switch (question.questionType) {
      case QuestionType.text:
        return _buildTextInput(question);
      case QuestionType.multipleChoice:
        return _buildMultipleChoice(question);
      case QuestionType.yesNo:
        return _buildYesNo(question);
      case QuestionType.multipleSelection:
        return _buildMultipleSelection(question);
    }
  }

  /// Build text input field
  Widget _buildTextInput(OnboardingQuestion question) {
    final controller = TextEditingController(
      text: _answers[question.id]?.toString() ?? '',
    );

    return TextFormField(
      controller: controller,
      onChanged: (value) {
        setState(() {
          _answers[question.id] = value;
        });
      },
      decoration: InputDecoration(
        hintText: question.placeholder ?? 'Enter your answer...',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      maxLines: 3,
      minLines: 1,
    );
  }

  /// Build multiple choice (single selection) widget
  Widget _buildMultipleChoice(OnboardingQuestion question) {
    final options = question.options ?? [];
    final selectedOption = _answers[question.id] as String?;

    return Column(
      children: options.map((option) {
        final isSelected = selectedOption == option;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  _answers[question.id] = option;
                });
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isSelected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        option,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: isSelected
                              ? Theme.of(context).colorScheme.onPrimaryContainer
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  /// Build yes/no widget
  Widget _buildYesNo(OnboardingQuestion question) {
    final selectedValue = _answers[question.id] as bool?;

    return Row(
      children: [
        Expanded(
          child: _buildYesNoOption(
            question.id,
            'Yes',
            true,
            selectedValue,
            Icons.check_circle,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildYesNoOption(
            question.id,
            'No',
            false,
            selectedValue,
            Icons.cancel,
          ),
        ),
      ],
    );
  }

  /// Build a single yes/no option
  Widget _buildYesNoOption(
    String questionId,
    String label,
    bool value,
    bool? selectedValue,
    IconData icon,
  ) {
    final isSelected = selectedValue == value;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _answers[questionId] = value;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.primaryContainer
                : Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 32,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected
                      ? Theme.of(context).colorScheme.onPrimaryContainer
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build multiple selection (multi-select) widget
  Widget _buildMultipleSelection(OnboardingQuestion question) {
    final options = question.options ?? [];
    final selectedOptions = (_answers[question.id] as List<String>?) ?? [];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((option) {
        final isSelected = selectedOptions.contains(option);

        return FilterChip(
          label: Text(option),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              final currentSelections = List<String>.from(selectedOptions);
              if (selected) {
                currentSelections.add(option);
              } else {
                currentSelections.remove(option);
              }
              _answers[question.id] = currentSelections;
            });
          },
          checkmarkColor: Theme.of(context).colorScheme.onPrimary,
          selectedColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest,
          labelStyle: TextStyle(
            color: isSelected
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        );
      }).toList(),
    );
  }

  /// Build navigation buttons
  Widget _buildNavigationButtons(List<OnboardingQuestion> questions) {
    final isLastPage = _currentPage == questions.length - 1;
    final currentQuestion = questions[_currentPage];
    final canProceed = _isCurrentQuestionAnswered(currentQuestion);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Back button
          if (_currentPage > 0)
            OutlinedButton.icon(
              onPressed: _isSubmitting ? null : _handleBack,
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),

          const Spacer(),

          // Next or Complete button
          if (isLastPage)
            ElevatedButton.icon(
              onPressed: (canProceed && !_isSubmitting)
                  ? _submitOnboarding
                  : null,
              icon: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.check_circle),
              label: Text(
                _isSubmitting ? 'Submitting...' : 'Complete Onboarding',
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            )
          else
            ElevatedButton.icon(
              onPressed: canProceed
                  ? () => _handleNext(questions.length)
                  : null,
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Next'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Get color based on question category
  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'medical':
        return Colors.red;
      case 'concierge':
        return Colors.purple;
      case 'lifestyle':
        return Colors.green;
      case 'preferences':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
