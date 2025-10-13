import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:everglow_app/domain/models/daily_journey_models.dart';
import 'package:everglow_app/presentation/core/services/audio_player_service.dart';

/// Widget for displaying a single "Guided Practice" itinerary item.
///
/// This widget renders a guided practice session with audio playback controls.
/// It displays the practice's time and title, and provides play/pause controls
/// based on the current audio player state.
class GuidedPracticeWidget extends ConsumerWidget {
  /// The guided practice model object to display
  final GuidedPractice practice;

  /// Creates a [GuidedPracticeWidget]
  const GuidedPracticeWidget({
    required this.practice,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the audio player state to react to playback changes
    final audioState = ref.watch(audioPlayerServiceProvider);

    // Get a reference to the notifier for calling methods
    final audioNotifier = ref.read(audioPlayerServiceProvider.notifier);

    // Determine if this practice is currently playing
    final isThisPracticePlaying = audioState.currentUrl == practice.audioUrl &&
                                  audioState.isPlaying;

    // Determine if this practice is currently paused (loaded but not playing)
    final isThisPracticePaused = audioState.currentUrl == practice.audioUrl &&
                                 !audioState.isPlaying &&
                                 !audioState.isLoading;

    // Determine if this practice is currently loading
    final isThisPracticeLoading = audioState.currentUrl == practice.audioUrl &&
                                  audioState.isLoading;

    // Get the theme for consistent styling
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return ListTile(
      // Display the time
      leading: Text(
        practice.time,
        style: theme.textTheme.titleMedium?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
        ),
      ),

      // Display the title
      title: Text(
        practice.title,
        style: theme.textTheme.bodyLarge,
      ),

      // Display the play/pause control
      trailing: IconButton(
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
      audioNotifier.play(practice.audioUrl, practice.title);
    }
  }
}
