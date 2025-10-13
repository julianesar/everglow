import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/models/daily_journey_models.dart';
import '../../features/daily_journey/daily_journey_controller.dart';
import '../../features/daily_journey/widgets/guided_practice_widget.dart';
import '../../features/daily_journey/widgets/journal_prompt_dialog.dart';

/// Screen displaying the daily itinerary for a specific day
///
/// This screen shows the complete daily journey including:
/// - Daily title and mantra
/// - Single priority input section
/// - Itinerary items (medical events, guided practices, journaling)
/// - Footer button for day progression (driven by isPrioritySet state)
class DayScreen extends ConsumerWidget {
  const DayScreen({super.key, required this.dayId});

  /// The ID of the day to display (as a string from the router)
  final String dayId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Parse dayId to int for the controller
    final dayNumber = int.tryParse(dayId) ?? 1;

    // Watch the daily journey controller
    final dailyJourneyAsync = ref.watch(
      dailyJourneyControllerProvider(dayNumber),
    );

    return Scaffold(
      appBar: AppBar(title: Text('Day $dayId')),
      body: dailyJourneyAsync.when(
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
        data: (dailyJourney) => Column(
          children: [
            // Main scrollable content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  // Header with title and mantra
                  _DayHeader(
                    title: dailyJourney.title,
                    mantra: dailyJourney.mantra,
                  ),
                  const SizedBox(height: 24),

                  // Single Priority section - now stateless
                  _SinglePrioritySection(
                    dayNumber: dayNumber,
                    initialPriority: dailyJourney.singlePriority ?? '',
                    isPrioritySet: dailyJourney.isPrioritySet,
                  ),
                  const SizedBox(height: 32),

                  // Section title for itinerary
                  Text(
                    'Your Journey Today',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),

                  // Itinerary items
                  ...dailyJourney.itinerary.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: _buildItineraryItem(item, dayNumber),
                    ),
                  ),

                  // Add bottom padding to avoid button overlap
                  const SizedBox(height: 80),
                ],
              ),
            ),

            // Footer button - driven by isPrioritySet state
            _FooterButton(
              dayNumber: dayNumber,
              isPrioritySet: dailyJourney.isPrioritySet,
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the appropriate widget for each itinerary item type
  Widget _buildItineraryItem(ItineraryItem item, int dayNumber) {
    return switch (item) {
      MedicalEvent() => _MedicalEventCard(event: item),
      GuidedPractice() => GuidedPracticeWidget(practice: item),
      JournalingSection() => _JournalingCard(
        section: item,
        dayNumber: dayNumber,
      ),
      _ => const SizedBox.shrink(),
    };
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

/// Single Priority section widget (now stateless)
///
/// This widget displays the single priority input field and save button.
/// The saved state is now driven entirely by the controller's isPrioritySet flag.
class _SinglePrioritySection extends ConsumerStatefulWidget {
  const _SinglePrioritySection({
    required this.dayNumber,
    required this.initialPriority,
    required this.isPrioritySet,
  });

  final int dayNumber;
  final String initialPriority;
  final bool isPrioritySet;

  @override
  ConsumerState<_SinglePrioritySection> createState() =>
      _SinglePrioritySectionState();
}

class _SinglePrioritySectionState
    extends ConsumerState<_SinglePrioritySection> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialPriority);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Checks if the text has been modified from the saved priority
  bool get _hasUnsavedChanges {
    return _controller.text.trim() != widget.initialPriority.trim();
  }

  Future<void> _savePriority() async {
    if (_controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a priority before saving'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Call the controller to save the priority
    await ref
        .read(dailyJourneyControllerProvider(widget.dayNumber).notifier)
        .updateSinglePriority(_controller.text.trim());

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Priority saved successfully'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine the button state based on controller's isPrioritySet
    final bool isSaved = widget.isPrioritySet && !_hasUnsavedChanges;

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.star_rounded,
                color: Theme.of(context).colorScheme.primary,
                size: 28,
              ),
              const SizedBox(width: 8),
              Text(
                'Single Priority',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'What is the one thing that matters most today?',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _controller,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Enter your single priority for today...',
              suffixIcon: isSaved
                  ? Icon(
                      Icons.check_circle,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  : null,
            ),
            onChanged: (_) {
              // Trigger rebuild to update button state
              setState(() {});
            },
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _savePriority,
              icon: Icon(isSaved ? Icons.check : Icons.save),
              label: Text(isSaved ? 'Saved' : 'Save Priority'),
            ),
          ),
        ],
      ),
    );
  }
}

/// Card widget for displaying medical events
class _MedicalEventCard extends StatelessWidget {
  const _MedicalEventCard({required this.event});

  final MedicalEvent event;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
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
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Row(
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
                            event.time,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Divider(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.1),
            ),
            const SizedBox(height: 12),
            Row(
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
                    event.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
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
                    event.location,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Card widget for displaying journaling sections
class _JournalingCard extends ConsumerWidget {
  const _JournalingCard({required this.section, required this.dayNumber});

  final JournalingSection section;
  final int dayNumber;

  /// Handles the journaling flow by showing dialogs for each prompt
  Future<void> _handleJournaling(BuildContext context, WidgetRef ref) async {
    // Show a dialog for each prompt in sequence
    for (final prompt in section.prompts) {
      // Check if context is still valid before showing dialog
      if (!context.mounted) return;

      final response = await JournalPromptDialog.show(context, prompt);

      // If user canceled or provided empty response, skip this prompt
      if (response == null || response.trim().isEmpty) {
        continue;
      }

      // Save the journal entry
      await ref
          .read(dailyJourneyControllerProvider(dayNumber).notifier)
          .updateJournalEntry(prompt.id, response);
    }

    // Show completion message
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Journal entries saved successfully'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
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
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        section.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Row(
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
                            section.time,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Reflection Prompts:',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            ...section.prompts.asMap().entries.map((entry) {
              final index = entry.key;
              final prompt = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        prompt.promptText,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _handleJournaling(context, ref),
                icon: const Icon(Icons.create_rounded),
                label: const Text('Start Journaling'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Footer button widget for day progression
///
/// This widget displays a dynamic button that:
/// - Is disabled when the priority hasn't been set (isPrioritySet = false)
/// - Shows 'Complete Today's Priority to Proceed' when disabled
/// - For dayId < 3 (days 1-2): Shows 'Proceed to Day X' and navigates to next day
/// - For dayId >= 3 (day 3 onwards): Shows 'Forge my Rebirth Report' and navigates to /report
/// - Uses Liquid Gold color (#FFD700) when enabled
class _FooterButton extends StatelessWidget {
  const _FooterButton({required this.dayNumber, required this.isPrioritySet});

  final int dayNumber;
  final bool isPrioritySet;

  @override
  Widget build(BuildContext context) {
    // Determine button text and navigation based on priority state and day number
    final String buttonText;
    final String navigationPath;

    if (!isPrioritySet) {
      // Priority not set - button disabled
      buttonText = 'Complete Today\'s Priority to Proceed';
      navigationPath = ''; // Not used when disabled
    } else if (dayNumber < 3) {
      // Days 1-2: Proceed to next day
      buttonText = 'Proceed to Day ${dayNumber + 1}';
      navigationPath = '/day/${dayNumber + 1}';
    } else {
      // Day 3 onwards: Go to report
      buttonText = 'Forge my Rebirth Report';
      navigationPath = '/report';
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isPrioritySet
                ? () {
                    // Navigate to next day or report screen
                    context.go(navigationPath);
                  }
                : null, // Button is disabled when priority is not set
            style: ElevatedButton.styleFrom(
              backgroundColor: isPrioritySet
                  ? const Color(0xFFFFD700) // Liquid Gold
                  : Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.3),
              foregroundColor: isPrioritySet
                  ? Colors.black87 // Dark text on gold background
                  : Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.5),
              disabledBackgroundColor: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.1),
              disabledForegroundColor: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.4),
              padding: const EdgeInsets.symmetric(vertical: 16),
              elevation: isPrioritySet ? 4 : 0,
            ),
            child: Text(
              buttonText,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
                color: isPrioritySet
                    ? Colors.black87
                    : Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
