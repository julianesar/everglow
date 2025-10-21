import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/daily_journey_models.dart';
import '../controllers/daily_journey_controller.dart';
import '../widgets/guided_practice_widget.dart';
import '../widgets/journal_prompt_dialog.dart';
import '../widgets/timeline_navigator.dart';
import '../../../../core/widgets/confetti_celebration.dart';
import '../../../../core/widgets/completion_chip.dart';

/// Screen displaying the daily itinerary for a specific day
///
/// This screen shows the complete daily journey including:
/// - Daily title and mantra
/// - Single priority input section
/// - Itinerary items (medical events, guided practices, journaling)
/// - Footer button for day progression (driven by isPrioritySet state)
///
/// This screen supports two navigation modes:
/// 1. Callback-based (for in-tab navigation): Provide [onNavigateToDay]
/// 2. Router-based (for standalone navigation): Uses GoRouter when callback is null
class DayScreen extends ConsumerWidget {
  const DayScreen({super.key, required this.dayId, this.onNavigateToDay});

  /// The ID of the day to display (as a string from the router)
  final String dayId;

  /// Optional callback for navigating to a specific day.
  /// When provided, this callback is used instead of GoRouter navigation.
  /// This allows navigation to stay within a tab context.
  final void Function(int day)? onNavigateToDay;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Parse dayId to int for the controller
    final dayNumber = int.tryParse(dayId) ?? 1;

    // Validate day number - only days 1-3 are valid
    // If invalid, redirect to hub immediately
    if (dayNumber < 1 || dayNumber > 3) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          context.go('/hub');
        }
      });
      // Show a temporary loading state while redirecting
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  'Redirecting to Hub...',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Watch the daily journey controller
    final dailyJourneyAsync = ref.watch(
      dailyJourneyControllerProvider(dayNumber),
    );

    return Scaffold(
      body: SafeArea(
        child: dailyJourneyAsync.when(
          // Loading state - show spinner
          loading: () => const Center(child: CircularProgressIndicator()),

          // Error state - show error message
          error: (error, stackTrace) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error Loading Day',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
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
                      // Retry by invalidating the provider
                      ref.invalidate(dailyJourneyControllerProvider(dayNumber));
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),

          // Data state - show the content with footer button
          data: (dailyJourney) {
            // Calculate progress: count completed tasks
            final totalTasks = dailyJourney.itinerary.length;
            final completedTasks = dailyJourney.itinerary
                .where((item) => item.isCompleted)
                .length;
            final progress = totalTasks > 0 ? completedTasks / totalTasks : 0.0;
            final isAllComplete =
                totalTasks > 0 && completedTasks == totalTasks;

            return _DayContentWithCelebration(
              dayNumber: dayNumber,
              isAllComplete: isAllComplete,
              onNavigateToDay: onNavigateToDay,
              progress: progress,
              completedTasks: completedTasks,
              totalTasks: totalTasks,
              dailyJourney: dailyJourney,
              buildItineraryItem: _buildItineraryItem,
            );
          },
        ),
      ),
    );
  }

  /// Builds the appropriate widget for each itinerary item type
  Widget _buildItineraryItem(ItineraryItem item, int dayNumber, WidgetRef ref) {
    return switch (item) {
      MedicalEvent() => _MedicalEventCard(event: item, dayNumber: dayNumber),
      GuidedPractice() => GuidedPracticeWidget(
        practice: item,
        dayNumber: dayNumber,
      ),
      JournalingSection() => _JournalingCard(
        section: item,
        dayNumber: dayNumber,
      ),
      _ => const SizedBox.shrink(),
    };
  }
}

/// Wrapper widget that displays day content with optional full-day completion celebration
class _DayContentWithCelebration extends ConsumerStatefulWidget {
  const _DayContentWithCelebration({
    required this.dayNumber,
    required this.isAllComplete,
    required this.onNavigateToDay,
    required this.progress,
    required this.completedTasks,
    required this.totalTasks,
    required this.dailyJourney,
    required this.buildItineraryItem,
  });

  final int dayNumber;
  final bool isAllComplete;
  final void Function(int day)? onNavigateToDay;
  final double progress;
  final int completedTasks;
  final int totalTasks;
  final DailyJourney dailyJourney;
  final Widget Function(ItineraryItem, int, WidgetRef) buildItineraryItem;

  @override
  ConsumerState<_DayContentWithCelebration> createState() =>
      _DayContentWithCelebrationState();
}

class _DayContentWithCelebrationState
    extends ConsumerState<_DayContentWithCelebration>
    with ConfettiCelebrationMixin {
  bool _hasShownCelebration = false;

  @override
  void initState() {
    super.initState();
    initConfetti();
  }

  @override
  void dispose() {
    disposeConfetti();
    super.dispose();
  }

  @override
  void didUpdateWidget(_DayContentWithCelebration oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if we just completed all tasks
    if (widget.isAllComplete &&
        !oldWidget.isAllComplete &&
        !_hasShownCelebration) {
      _hasShownCelebration = true;
      // Trigger celebration with a slight delay for better UX
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          celebrate();
          _showCompletionDialog();
        }
      });
    }
  }

  /// Shows a celebration dialog when all tasks are complete
  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.celebration_rounded,
                size: 48,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 16),
            // Title
            Text(
              'Day ${widget.dayNumber} Complete!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            // Message
            Text(
              'You\'ve completed all tasks for today. Your responses will help create your personalized transformation report.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // Close button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main content
        Column(
          children: [
            // Timeline Navigator - fixed at top
            TimelineNavigator(
              currentDay: widget.dayNumber,
              onNavigateToDay: widget.onNavigateToDay,
            ),

            // Progress bar showing task completion
            _ProgressBar(
              progress: widget.progress,
              completedTasks: widget.completedTasks,
              totalTasks: widget.totalTasks,
            ),

            // Main scrollable content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  // Header with title and mantra
                  _DayHeader(
                    title: widget.dailyJourney.title,
                    mantra: widget.dailyJourney.mantra,
                  ),
                  const SizedBox(height: 24),

                  // Single Priority section - read-only display
                  _SinglePrioritySection(
                    priority: widget.dailyJourney.singlePriority ?? '',
                  ),
                  const SizedBox(height: 32),

                  // Section title for itinerary
                  Text(
                    'Your Journey Today',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),

                  // Itinerary items
                  ...widget.dailyJourney.itinerary.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: widget.buildItineraryItem(
                        item,
                        widget.dayNumber,
                        ref,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        // Full-screen confetti overlay for day completion
        if (widget.isAllComplete)
          Positioned.fill(
            child: IgnorePointer(
              child: Align(
                alignment: Alignment.topCenter,
                child: ConfettiCelebration(
                  controller: confettiController,
                  numberOfParticles: 50,
                  minBlastForce: 15,
                  maxBlastForce: 30,
                  blastDirectionality: BlastDirectionality.explosive,
                  festiveColors: true,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Progress bar widget showing task completion percentage with encouragement messages
class _ProgressBar extends StatelessWidget {
  const _ProgressBar({
    required this.progress,
    required this.completedTasks,
    required this.totalTasks,
  });

  final double progress;
  final int completedTasks;
  final int totalTasks;

  /// Generates contextual encouragement message based on progress
  String _getEncouragementMessage() {
    final remaining = totalTasks - completedTasks;

    if (completedTasks == 0) {
      return 'Ready to begin your journey today?';
    } else if (completedTasks == totalTasks) {
      return 'Amazing! All tasks complete!';
    } else if (remaining == 1) {
      return 'Almost there! Just 1 task left';
    } else if (remaining == 2) {
      return 'Great progress! 2 tasks to go';
    } else if (progress >= 0.5) {
      return 'You\'re doing great! $remaining tasks remaining';
    } else {
      return 'Keep going! $remaining tasks to complete';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isComplete = completedTasks == totalTasks && totalTasks > 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: isComplete
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
            : Theme.of(context).colorScheme.surface,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Progress',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isComplete
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getEncouragementMessage(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isComplete
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.7),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isComplete
                      ? Colors.green.withValues(alpha: 0.2)
                      : Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isComplete) ...[
                      const Icon(
                        Icons.check_circle,
                        size: 16,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 4),
                    ],
                    Text(
                      '$completedTasks / $totalTasks',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isComplete
                            ? Colors.green
                            : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
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
                isComplete
                    ? Colors.green
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Header widget displaying the day's title and mantra
class _DayHeader extends StatelessWidget {
  const _DayHeader({required this.title, required this.mantra});

  final String title;
  final String mantra;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
            Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.format_quote,
                color: Theme.of(context).colorScheme.secondary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  mantra,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontStyle: FontStyle.italic,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Single Priority section widget - read-only display
///
/// This widget displays the pre-established single priority for the day
/// without any editing functionality.
class _SinglePrioritySection extends StatelessWidget {
  const _SinglePrioritySection({required this.priority});

  final String priority;

  @override
  Widget build(BuildContext context) {
    // Split priority text to separate main text from subtitle (text in parentheses)
    String mainText = priority;
    String? subtitleText;

    // Check if there's a parenthesis in the priority text
    final openParenIndex = priority.indexOf('(');
    final closeParenIndex = priority.indexOf(')');

    if (openParenIndex != -1 &&
        closeParenIndex != -1 &&
        closeParenIndex > openParenIndex) {
      // Extract main text (before the opening parenthesis, trimmed)
      mainText = priority.substring(0, openParenIndex).trim();
      // Extract subtitle (text inside parentheses)
      subtitleText = priority
          .substring(openParenIndex + 1, closeParenIndex)
          .trim();
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
            Theme.of(context).colorScheme.secondary.withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            // Star icon in a circular container
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.star_rounded,
                color: Theme.of(context).colorScheme.primary,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            // Priority text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today\'s Priority',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    mainText,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                  ),
                  // Show subtitle if it exists
                  if (subtitleText != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitleText,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Card widget for displaying medical events with completion checkbox
class _MedicalEventCard extends ConsumerStatefulWidget {
  const _MedicalEventCard({required this.event, required this.dayNumber});

  final MedicalEvent event;
  final int dayNumber;

  @override
  ConsumerState<_MedicalEventCard> createState() => _MedicalEventCardState();
}

class _MedicalEventCardState extends ConsumerState<_MedicalEventCard>
    with ConfettiCelebrationMixin {
  @override
  void initState() {
    super.initState();
    initConfetti();
  }

  @override
  void dispose() {
    disposeConfetti();
    super.dispose();
  }

  Future<void> _handleCompletion() async {
    if (!widget.event.isCompleted) {
      // Trigger celebration animation
      celebrate();

      // Mark task as completed
      final wasCompleted = await ref
          .read(dailyJourneyControllerProvider(widget.dayNumber).notifier)
          .completeTask(widget.event.id);

      if (wasCompleted && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task completed!'),
            duration: Duration(seconds: 1),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          elevation: 2,
          clipBehavior: Clip.antiAlias,
          color: widget.event.isCompleted
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.05)
              : null,
          child: Theme(
            // Override the expansion tile theme for better control
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              // Disable default top/bottom borders
              tilePadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              childrenPadding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                bottom: 16.0,
              ),
              // Custom expansion icon colors
              iconColor: Theme.of(context).colorScheme.error,
              collapsedIconColor: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.6),
              // Leading icon with background
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.error.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.medical_services_rounded,
                  color: Theme.of(context).colorScheme.error,
                  size: 24,
                ),
              ),
              // Title with event name and strike-through if completed
              title: Text(
                widget.event.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  decoration: widget.event.isCompleted
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
              // Subtitle with time
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.event.time,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              // Expandable content - event details
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.description_outlined,
                          size: 16,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.event.description,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.event.location,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Completion chip centered
                    Align(
                      alignment: Alignment.center,
                      child: CompletionChip(
                        isCompleted: widget.event.isCompleted,
                        onPressed: widget.event.isCompleted
                            ? null
                            : _handleCompletion,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // Full-screen confetti overlay (top-centered)
        if (widget.event.isCompleted)
          Positioned.fill(
            child: IgnorePointer(
              child: Align(
                alignment: Alignment.topCenter,
                child: ConfettiCelebration(
                  controller: confettiController,
                  numberOfParticles: 30,
                  minBlastForce: 10,
                  maxBlastForce: 20,
                  blastDirectionality: BlastDirectionality.explosive,
                  festiveColors: true,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Card widget for displaying journaling sections as an expandable accordion
///
/// This widget uses an ExpansionTile to reduce cognitive load by allowing
/// users to expand only the journaling sections they want to work on.
/// It includes a checkbox that can be manually checked, or automatically
/// checks when all prompts have been answered.
class _JournalingCard extends ConsumerStatefulWidget {
  const _JournalingCard({required this.section, required this.dayNumber});

  final JournalingSection section;
  final int dayNumber;

  @override
  ConsumerState<_JournalingCard> createState() => _JournalingCardState();
}

class _JournalingCardState extends ConsumerState<_JournalingCard>
    with ConfettiCelebrationMixin {
  @override
  void initState() {
    super.initState();
    initConfetti();
  }

  @override
  void dispose() {
    disposeConfetti();
    super.dispose();
  }

  Future<void> _handleCompletion() async {
    if (!widget.section.isCompleted) {
      // Trigger celebration animation
      celebrate();

      // Mark task as completed
      final wasCompleted = await ref
          .read(dailyJourneyControllerProvider(widget.dayNumber).notifier)
          .completeTask(widget.section.id);

      if (wasCompleted && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Journaling completed!'),
            duration: Duration(seconds: 1),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  /// Handles editing a single journal prompt response
  Future<void> _handleEditPrompt(
    BuildContext context,
    WidgetRef ref,
    JournalingPrompt prompt,
    String? existingResponse,
  ) async {
    if (!context.mounted) return;

    final response = await JournalPromptDialog.show(
      context,
      prompt,
      initialResponse: existingResponse,
    );

    // If user canceled or provided empty response, return
    if (response == null || response.trim().isEmpty) {
      return;
    }

    // Save the journal entry
    await ref
        .read(dailyJourneyControllerProvider(widget.dayNumber).notifier)
        .updateJournalEntry(prompt.id, response);

    // Show success message
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            existingResponse == null
                ? 'Response saved successfully'
                : 'Response updated successfully',
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch the daily journey to get journal responses
    final dailyJourneyAsync = ref.watch(
      dailyJourneyControllerProvider(widget.dayNumber),
    );

    return Stack(
      children: [
        Card(
          elevation: 2,
          clipBehavior: Clip.antiAlias,
          color: widget.section.isCompleted
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.05)
              : null,
          child: Theme(
            // Override the expansion tile theme for better control
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              // Disable default top/bottom borders
              tilePadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              childrenPadding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                bottom: 16.0,
              ),
              // Custom expansion icon colors
              iconColor: Theme.of(context).colorScheme.primary,
              collapsedIconColor: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.6),
              // Leading icon with background
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.edit_note_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
              ),
              // Title with section name and strike-through if completed
              title: Text(
                widget.section.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  decoration: widget.section.isCompleted
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
              // Subtitle with time
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.section.time,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              // trailing is automatically added by ExpansionTile
              // Expandable content - the journaling prompts
              children: [
                dailyJourneyAsync.when(
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  error: (error, _) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Error loading responses',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  ),
                  data: (dailyJourney) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Section title for prompts
                        Text(
                          'Reflection Prompts:',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 12),

                        // Display prompts with their responses or write button
                        ...widget.section.prompts.asMap().entries.map((entry) {
                          final index = entry.key;
                          final prompt = entry.value;
                          final response =
                              dailyJourney.journalResponses[prompt.id];
                          final hasResponse =
                              response != null && response.isNotEmpty;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: hasResponse
                                    ? Theme.of(context).colorScheme.primary
                                          .withValues(alpha: 0.05)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: hasResponse
                                      ? Theme.of(context).colorScheme.primary
                                            .withValues(alpha: 0.2)
                                      : Theme.of(context).colorScheme.onSurface
                                            .withValues(alpha: 0.1),
                                  width: 1,
                                ),
                              ),
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Prompt question with number
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withValues(alpha: 0.2),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${index + 1}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall
                                                ?.copyWith(
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.primary,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          prompt.promptText,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),

                                  // Response section or write button
                                  if (hasResponse) ...[
                                    // Show saved response with edit button
                                    Container(
                                      padding: const EdgeInsets.all(12.0),
                                      decoration: BoxDecoration(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.surface,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.check_circle,
                                                size: 16,
                                                color: Colors.green,
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                'Your Response',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelMedium
                                                    ?.copyWith(
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            response,
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodyMedium,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    // Edit button
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton.icon(
                                        onPressed: () => _handleEditPrompt(
                                          context,
                                          ref,
                                          prompt,
                                          response,
                                        ),
                                        icon: const Icon(Icons.edit, size: 16),
                                        label: const Text('Edit Response'),
                                        style: TextButton.styleFrom(
                                          foregroundColor: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                      ),
                                    ),
                                  ] else ...[
                                    // Show write reflection button
                                    SizedBox(
                                      width: double.infinity,
                                      child: OutlinedButton.icon(
                                        onPressed: () => _handleEditPrompt(
                                          context,
                                          ref,
                                          prompt,
                                          null,
                                        ),
                                        icon: const Icon(Icons.create),
                                        label: const Text('Write Reflection'),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        }),
                        const SizedBox(height: 16),
                        // Completion chip centered
                        Align(
                          alignment: Alignment.center,
                          child: CompletionChip(
                            isCompleted: widget.section.isCompleted,
                            onPressed: widget.section.isCompleted
                                ? null
                                : _handleCompletion,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        // Full-screen confetti overlay (top-centered)
        if (widget.section.isCompleted)
          Positioned.fill(
            child: IgnorePointer(
              child: Align(
                alignment: Alignment.topCenter,
                child: ConfettiCelebration(
                  controller: confettiController,
                  numberOfParticles: 30,
                  minBlastForce: 10,
                  maxBlastForce: 20,
                  blastDirectionality: BlastDirectionality.explosive,
                  festiveColors: true,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
