import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:everglow_app/domain/models/daily_journey_models.dart';
import 'package:everglow_app/presentation/core/services/audio_player_service.dart';
import 'package:everglow_app/presentation/features/daily_journey/daily_journey_controller.dart';
import 'package:everglow_app/presentation/core/widgets/confetti_celebration.dart';
import 'package:everglow_app/presentation/core/widgets/completion_chip.dart';

/// Widget for displaying a single "Guided Practice" itinerary item.
///
/// This widget renders a guided practice session with audio playback controls.
/// It displays the practice's time and title, and provides play/pause controls
/// based on the current audio player state. It includes a checkbox for manual
/// completion and automatically marks as complete when audio finishes playing.
class GuidedPracticeWidget extends ConsumerStatefulWidget {
  /// The guided practice model object to display
  final GuidedPractice practice;

  /// The day number for this practice (needed for completion tracking)
  final int dayNumber;

  /// Creates a [GuidedPracticeWidget]
  const GuidedPracticeWidget({
    required this.practice,
    required this.dayNumber,
    super.key,
  });

  @override
  ConsumerState<GuidedPracticeWidget> createState() =>
      _GuidedPracticeWidgetState();
}

class _GuidedPracticeWidgetState extends ConsumerState<GuidedPracticeWidget>
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
    if (!widget.practice.isCompleted) {
      // Trigger celebration animation
      celebrate();

      // Mark task as completed
      final wasCompleted = await ref
          .read(dailyJourneyControllerProvider(widget.dayNumber).notifier)
          .completeTask(widget.practice.id);

      if (wasCompleted && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Practice completed!'),
            duration: Duration(seconds: 1),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch the audio player state to react to playback changes
    final audioState = ref.watch(audioPlayerServiceProvider);

    // Get a reference to the notifier for calling methods
    final audioNotifier = ref.read(audioPlayerServiceProvider.notifier);

    // Determine if this practice is currently playing
    final isThisPracticePlaying =
        audioState.currentUrl == widget.practice.audioUrl &&
        audioState.isPlaying;

    // Determine if this practice is currently paused (loaded but not playing)
    final isThisPracticePaused =
        audioState.currentUrl == widget.practice.audioUrl &&
        !audioState.isPlaying &&
        !audioState.isLoading;

    // Determine if this practice is currently loading
    final isThisPracticeLoading =
        audioState.currentUrl == widget.practice.audioUrl &&
        audioState.isLoading;

    // Check if audio just finished playing (for auto-completion)
    final isThisPracticeFinished =
        audioState.currentUrl == widget.practice.audioUrl &&
        audioState.hasCompleted &&
        !widget.practice.isCompleted;

    // Auto-complete when audio finishes
    if (isThisPracticeFinished) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (mounted && !widget.practice.isCompleted) {
          celebrate();
          await ref
              .read(dailyJourneyControllerProvider(widget.dayNumber).notifier)
              .completeTask(widget.practice.id);
        }
      });
    }

    // Get the theme for consistent styling
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Stack(
      children: [
        Card(
          elevation: 2,
          clipBehavior: Clip.antiAlias,
          color: widget.practice.isCompleted
              ? theme.colorScheme.primary.withValues(alpha: 0.05)
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
              iconColor: theme.colorScheme.primary,
              collapsedIconColor: theme.colorScheme.onSurface.withValues(
                alpha: 0.6,
              ),
              // Leading icon with background
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.headphones_rounded,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
              ),
              // Title with practice name and strike-through if completed
              title: Text(
                widget.practice.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  decoration: widget.practice.isCompleted
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
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.practice.time,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Expandable content - audio controls and completion
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Audio control button centered
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            IconButton(
                              icon: _buildIcon(
                                isPlaying: isThisPracticePlaying,
                                isPaused: isThisPracticePaused,
                                isLoading: isThisPracticeLoading,
                              ),
                              color: primaryColor,
                              iconSize: 48,
                              onPressed: () => _handlePlayPause(
                                audioNotifier: audioNotifier,
                                isPlaying: isThisPracticePlaying,
                                isPaused: isThisPracticePaused,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Audio progress indicator - always reserves the same space
                            SizedBox(
                              height: 24, // Fixed height to maintain consistent size
                              child: isThisPracticePlaying ||
                                      isThisPracticePaused
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          isThisPracticePlaying
                                              ? Icons.play_arrow
                                              : Icons.pause,
                                          size: 16,
                                          color: primaryColor,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          isThisPracticePlaying
                                              ? 'Playing...'
                                              : 'Paused',
                                          style: theme.textTheme.bodyMedium?.copyWith(
                                            color: primaryColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Center(
                                      child: Text(
                                        'Tap to start guided practice',
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: theme.colorScheme.onSurface.withValues(
                                            alpha: 0.7,
                                          ),
                                        ),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Completion chip centered
                    Align(
                      alignment: Alignment.center,
                      child: CompletionChip(
                        isCompleted: widget.practice.isCompleted,
                        onPressed: widget.practice.isCompleted
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
        // Confetti overlay
        Positioned.fill(
          child: IgnorePointer(
            child: ConfettiCelebration(
              controller: confettiController,
              numberOfParticles: 20,
              minBlastForce: 5,
              maxBlastForce: 15,
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the appropriate icon based on the current state
  Widget _buildIcon({
    required bool isPlaying,
    required bool isPaused,
    required bool isLoading,
  }) {
    if (isLoading) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    } else if (isPlaying) {
      return const Icon(Icons.pause_circle_filled);
    } else if (isPaused) {
      return const Icon(Icons.play_circle_filled);
    } else {
      return const Icon(Icons.play_circle_outline);
    }
  }

  /// Handles the play/pause button press
  void _handlePlayPause({
    required AudioPlayerService audioNotifier,
    required bool isPlaying,
    required bool isPaused,
  }) {
    if (isPlaying) {
      // Currently playing this practice - pause it
      audioNotifier.pause();
    } else if (isPaused) {
      // Currently paused - resume playback
      audioNotifier.resume();
    } else {
      // Not loaded or a different track is playing - start playing
      audioNotifier.play(widget.practice.audioUrl, widget.practice.title);
    }
  }
}
