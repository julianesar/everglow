import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:everglow_app/domain/models/daily_journey_models.dart';
import 'package:everglow_app/presentation/core/services/audio_player_service.dart';
import 'package:everglow_app/presentation/features/daily_journey/daily_journey_controller.dart';
import 'package:everglow_app/presentation/core/widgets/confetti_celebration.dart';

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

  Future<void> _handleCheckboxChange(bool? newValue) async {
    if (newValue == true && !widget.practice.isCompleted) {
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
          color: widget.practice.isCompleted
              ? theme.colorScheme.primary.withValues(alpha: 0.05)
              : null,
          child: ListTile(
            // Display the time
            leading: Text(
              widget.practice.time,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),

            // Display the title with strike-through if completed
            title: Text(
              widget.practice.title,
              style: theme.textTheme.bodyLarge?.copyWith(
                decoration: widget.practice.isCompleted
                    ? TextDecoration.lineThrough
                    : null,
              ),
            ),

            // Display the play/pause control and checkbox
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: _buildIcon(
                    isPlaying: isThisPracticePlaying,
                    isPaused: isThisPracticePaused,
                    isLoading: isThisPracticeLoading,
                  ),
                  color: primaryColor,
                  iconSize: 32,
                  onPressed: () => _handlePlayPause(
                    audioNotifier: audioNotifier,
                    isPlaying: isThisPracticePlaying,
                    isPaused: isThisPracticePaused,
                  ),
                ),
                Checkbox(
                  value: widget.practice.isCompleted,
                  onChanged: widget.practice.isCompleted
                      ? null
                      : _handleCheckboxChange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
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
