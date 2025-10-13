import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/models/daily_journey_models.dart';
import '../../features/daily_journey/daily_journey_controller.dart';

/// Screen displaying the daily itinerary for a specific day
///
/// This screen shows the complete daily journey including:
/// - Daily title and mantra
/// - Single priority input section
/// - Itinerary items (medical events, guided practices, journaling)
class DayScreen extends ConsumerWidget {
  const DayScreen({
    super.key,
    required this.dayId,
  });

  /// The ID of the day to display (as a string from the router)
  final String dayId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Parse dayId to int for the controller
    final dayNumber = int.tryParse(dayId) ?? 1;

    // Watch the daily journey controller
    final dailyJourneyAsync = ref.watch(dailyJourneyControllerProvider(dayNumber));

    return Scaffold(
      appBar: AppBar(
        title: Text('Day $dayId'),
      ),
      body: dailyJourneyAsync.when(
        // Loading state - show spinner
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),

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

        // Data state - show the content
        data: (dailyJourney) => ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Header with title and mantra
            _DayHeader(
              title: dailyJourney.title,
              mantra: dailyJourney.mantra,
            ),
            const SizedBox(height: 24),

            // Single Priority section
            const _SinglePrioritySection(),
            const SizedBox(height: 32),

            // Section title for itinerary
            Text(
              'Your Journey Today',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),

            // Itinerary items
            ...dailyJourney.itinerary.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: _buildItineraryItem(item),
                )),
          ],
        ),
      ),
    );
  }

  /// Builds the appropriate widget for each itinerary item type
  Widget _buildItineraryItem(ItineraryItem item) {
    return switch (item) {
      MedicalEvent() => _MedicalEventCard(event: item),
      GuidedPractice() => _GuidedPracticeCard(practice: item),
      JournalingSection() => _JournalingCard(section: item),
      _ => const SizedBox.shrink(),
    };
  }
}

/// Header widget displaying the day's title and mantra
class _DayHeader extends StatelessWidget {
  const _DayHeader({
    required this.title,
    required this.mantra,
  });

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

/// Single Priority section widget
class _SinglePrioritySection extends StatefulWidget {
  const _SinglePrioritySection();

  @override
  State<_SinglePrioritySection> createState() => _SinglePrioritySectionState();
}

class _SinglePrioritySectionState extends State<_SinglePrioritySection> {
  final _controller = TextEditingController();
  bool _isSaved = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _savePriority() {
    if (_controller.text.trim().isNotEmpty) {
      setState(() {
        _isSaved = true;
      });
      // TODO: Persist the priority using the controller
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Priority saved successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.7),
                ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _controller,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Enter your single priority for today...',
              suffixIcon: _isSaved
                  ? Icon(
                      Icons.check_circle,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  : null,
            ),
            onChanged: (_) {
              if (_isSaved) {
                setState(() {
                  _isSaved = false;
                });
              }
            },
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _savePriority,
              icon: Icon(_isSaved ? Icons.check : Icons.save),
              label: Text(_isSaved ? 'Saved' : 'Save Priority'),
            ),
          ),
        ],
      ),
    );
  }
}

/// Card widget for displaying medical events
class _MedicalEventCard extends StatelessWidget {
  const _MedicalEventCard({
    required this.event,
  });

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
                    color: Theme.of(context).colorScheme.error.withValues(alpha: 0.2),
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
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.6),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            event.time,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
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
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.1),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.description_outlined,
                  size: 16,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6),
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
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6),
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

/// Card widget for displaying guided practices
class _GuidedPracticeCard extends StatelessWidget {
  const _GuidedPracticeCard({
    required this.practice,
  });

  final GuidedPractice practice;

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
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.self_improvement_rounded,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        practice.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.6),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            practice.time,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
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
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  // TODO: Play audio
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Playing: ${practice.title}'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Begin Practice'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Card widget for displaying journaling sections
class _JournalingCard extends StatelessWidget {
  const _JournalingCard({
    required this.section,
  });

  final JournalingSection section;

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
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.2),
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
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.6),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            section.time,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
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
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
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
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
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
                onPressed: () {
                  // TODO: Navigate to journaling screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Opening journaling section...'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
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
