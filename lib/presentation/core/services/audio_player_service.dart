import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

/// Immutable state class for audio player
class AudioPlayerState {
  /// Creates an audio player state
  const AudioPlayerState({
    required this.isPlaying,
    required this.isLoading,
    this.currentUrl,
  });

  /// Initial state for the audio player
  const AudioPlayerState.initial()
      : isPlaying = false,
        isLoading = false,
        currentUrl = null;

  /// Whether audio is currently playing
  final bool isPlaying;

  /// Whether audio is currently loading
  final bool isLoading;

  /// URL of the currently loaded audio track
  final String? currentUrl;

  /// Creates a copy of this state with the given fields replaced
  AudioPlayerState copyWith({
    bool? isPlaying,
    bool? isLoading,
    String? currentUrl,
  }) {
    return AudioPlayerState(
      isPlaying: isPlaying ?? this.isPlaying,
      isLoading: isLoading ?? this.isLoading,
      currentUrl: currentUrl ?? this.currentUrl,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AudioPlayerState &&
        other.isPlaying == isPlaying &&
        other.isLoading == isLoading &&
        other.currentUrl == currentUrl;
  }

  @override
  int get hashCode =>
      isPlaying.hashCode ^ isLoading.hashCode ^ currentUrl.hashCode;

  @override
  String toString() =>
      'AudioPlayerState(isPlaying: $isPlaying, isLoading: $isLoading, currentUrl: $currentUrl)';
}

/// Service that manages audio playback throughout the app
class AudioPlayerService extends Notifier<AudioPlayerState> {
  late final AudioPlayer _audioPlayer;

  @override
  AudioPlayerState build() {
    _audioPlayer = AudioPlayer();
    _setupPlayerStateListener();

    // Dispose audio player when provider is disposed
    ref.onDispose(() {
      _audioPlayer.dispose();
    });

    return const AudioPlayerState.initial();
  }

  /// Sets up listener for audio player state changes
  void _setupPlayerStateListener() {
    _audioPlayer.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final isLoading = playerState.processingState == ProcessingState.loading ||
          playerState.processingState == ProcessingState.buffering;

      state = state.copyWith(
        isPlaying: isPlaying,
        isLoading: isLoading,
      );
    });
  }

  /// Plays audio from the given URL
  ///
  /// If another track is currently playing, it will be stopped first.
  /// The method sets the state to loading, then attempts to load and play the audio.
  Future<void> play(String url) async {
    try {
      // Stop current track if playing
      if (state.isPlaying || state.currentUrl != null) {
        await stop();
      }

      // Set loading state
      state = state.copyWith(
        isLoading: true,
        currentUrl: url,
      );

      // Load and play the audio
      await _audioPlayer.setUrl(url);
      await _audioPlayer.play();
    } catch (e) {
      // Reset state on error
      state = state.copyWith(
        isLoading: false,
        isPlaying: false,
      );
      rethrow;
    }
  }

  /// Pauses the current track
  Future<void> pause() async {
    if (state.isPlaying) {
      await _audioPlayer.pause();
    }
  }

  /// Resumes playback of the current track
  Future<void> resume() async {
    if (!state.isPlaying && state.currentUrl != null) {
      await _audioPlayer.play();
    }
  }

  /// Stops the current track and resets the player
  Future<void> stop() async {
    await _audioPlayer.stop();
    state = state.copyWith(
      isPlaying: false,
      isLoading: false,
      currentUrl: null,
    );
  }

  /// Seeks to a specific position in the current track
  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  /// Sets the volume (0.0 to 1.0)
  Future<void> setVolume(double volume) async {
    await _audioPlayer.setVolume(volume.clamp(0.0, 1.0));
  }

  /// Gets the current position of the track
  Duration? get position => _audioPlayer.position;

  /// Gets the duration of the current track
  Duration? get duration => _audioPlayer.duration;

  /// Stream of position updates
  Stream<Duration> get positionStream => _audioPlayer.positionStream;

  /// Stream of duration updates
  Stream<Duration?> get durationStream => _audioPlayer.durationStream;
}

/// Provider for the audio player service
final audioPlayerServiceProvider =
    NotifierProvider<AudioPlayerService, AudioPlayerState>(
  AudioPlayerService.new,
);
