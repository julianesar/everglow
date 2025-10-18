import 'package:audio_session/audio_session.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

/// Immutable state class for audio player
class AudioPlayerState {
  /// Creates an audio player state
  const AudioPlayerState({
    required this.isPlaying,
    required this.isLoading,
    required this.hasCompleted,
    this.currentUrl,
    this.currentTitle,
  });

  /// Initial state for the audio player
  const AudioPlayerState.initial()
    : isPlaying = false,
      isLoading = false,
      hasCompleted = false,
      currentUrl = null,
      currentTitle = null;

  /// Whether audio is currently playing
  final bool isPlaying;

  /// Whether audio is currently loading
  final bool isLoading;

  /// Whether the current audio track has completed playback
  final bool hasCompleted;

  /// URL of the currently loaded audio track
  final String? currentUrl;

  /// Title of the currently loaded audio track
  final String? currentTitle;

  /// Creates a copy of this state with the given fields replaced
  AudioPlayerState copyWith({
    bool? isPlaying,
    bool? isLoading,
    bool? hasCompleted,
    String? currentUrl,
    String? currentTitle,
  }) {
    return AudioPlayerState(
      isPlaying: isPlaying ?? this.isPlaying,
      isLoading: isLoading ?? this.isLoading,
      hasCompleted: hasCompleted ?? this.hasCompleted,
      currentUrl: currentUrl ?? this.currentUrl,
      currentTitle: currentTitle ?? this.currentTitle,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AudioPlayerState &&
        other.isPlaying == isPlaying &&
        other.isLoading == isLoading &&
        other.hasCompleted == hasCompleted &&
        other.currentUrl == currentUrl &&
        other.currentTitle == currentTitle;
  }

  @override
  int get hashCode =>
      isPlaying.hashCode ^
      isLoading.hashCode ^
      hasCompleted.hashCode ^
      currentUrl.hashCode ^
      currentTitle.hashCode;

  @override
  String toString() =>
      'AudioPlayerState(isPlaying: $isPlaying, isLoading: $isLoading, hasCompleted: $hasCompleted, currentUrl: $currentUrl, currentTitle: $currentTitle)';
}

/// Service that manages audio playback throughout the app with proper audio session handling
///
/// This service integrates with the device's audio session to:
/// - Handle audio focus properly
/// - Display media notifications with playback controls
/// - Respect system audio interruptions (calls, alarms, etc.)
/// - Provide a clean interface for audio playback across the app
class AudioPlayerService extends Notifier<AudioPlayerState> {
  late final AudioPlayer _audioPlayer;
  late final AudioSession _audioSession;
  bool _sessionInitialized = false;

  @override
  AudioPlayerState build() {
    _audioPlayer = AudioPlayer();
    _setupPlayerStateListener();
    _initAudioSession();

    // Dispose audio player when provider is disposed
    ref.onDispose(() {
      _audioPlayer.dispose();
    });

    return const AudioPlayerState.initial();
  }

  /// Initializes and configures the audio session for playback
  ///
  /// This method sets up the audio session with proper configuration for media playback.
  /// It should be called once during service initialization.
  Future<void> _initAudioSession() async {
    try {
      _audioSession = await AudioSession.instance;
      await _audioSession.configure(const AudioSessionConfiguration.music());
      _sessionInitialized = true;
    } catch (e) {
      // Log error but don't prevent audio playback
      // In production, you might want to use a logging service here
      _sessionInitialized = false;
      // Rethrow to allow caller to handle if needed
      // In this case, we'll continue without session management
    }
  }

  /// Sets up listener for audio player state changes
  ///
  /// This listener updates the service state based on player state changes,
  /// allowing the UI to react to playback events.
  void _setupPlayerStateListener() {
    _audioPlayer.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final isLoading =
          playerState.processingState == ProcessingState.loading ||
          playerState.processingState == ProcessingState.buffering;
      final hasCompleted =
          playerState.processingState == ProcessingState.completed;

      state = state.copyWith(
        isPlaying: isPlaying,
        isLoading: isLoading,
        hasCompleted: hasCompleted,
      );
    });
  }

  /// Plays audio from the given URL with the specified title
  ///
  /// This method:
  /// 1. Stops any currently playing track
  /// 2. Sets up media metadata for notifications
  /// 3. Loads and plays the audio
  /// 4. Activates the audio session
  ///
  /// [url] The URL of the audio file to play
  /// [title] The title to display in media notifications and UI
  ///
  /// Throws an exception if the audio fails to load or play.
  Future<void> play(String url, String title) async {
    try {
      // Stop current track if playing
      if (state.isPlaying || state.currentUrl != null) {
        await stop();
      }

      // Set loading state
      state = state.copyWith(
        isLoading: true,
        hasCompleted: false,
        currentUrl: url,
        currentTitle: title,
      );

      // Activate audio session for playback
      if (_sessionInitialized) {
        await _audioSession.setActive(true);
      }

      // Create audio source with media metadata for notifications
      final audioSource = AudioSource.uri(
        Uri.parse(url),
        tag: {
          'id': url,
          'title': title,
          'album': 'Everglow',
          // You can add more metadata here as needed:
          // 'artist': 'Artist Name',
          // 'artUri': 'https://example.com/albumart.jpg',
        },
      );

      // Load and play the audio
      await _audioPlayer.setAudioSource(audioSource);
      await _audioPlayer.play();
    } catch (e) {
      // Reset state on error
      state = state.copyWith(isLoading: false, isPlaying: false);
      rethrow;
    }
  }

  /// Pauses the current track
  ///
  /// The audio session remains active, and playback can be resumed with [resume].
  Future<void> pause() async {
    if (state.isPlaying) {
      await _audioPlayer.pause();
    }
  }

  /// Resumes playback of the current track
  ///
  /// Only works if there is a track loaded and it's currently paused.
  Future<void> resume() async {
    if (!state.isPlaying && state.currentUrl != null) {
      await _audioPlayer.play();
    }
  }

  /// Stops the current track and resets the player
  ///
  /// This method:
  /// 1. Stops audio playback
  /// 2. Deactivates the audio session
  /// 3. Resets the service state
  Future<void> stop() async {
    await _audioPlayer.stop();

    // Deactivate audio session when stopped
    if (_sessionInitialized) {
      await _audioSession.setActive(false);
    }

    state = state.copyWith(
      isPlaying: false,
      isLoading: false,
      hasCompleted: false,
      currentUrl: null,
      currentTitle: null,
    );
  }

  /// Seeks to a specific position in the current track
  ///
  /// [position] The position to seek to
  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  /// Sets the volume (0.0 to 1.0)
  ///
  /// [volume] The volume level, clamped between 0.0 (silent) and 1.0 (full volume)
  Future<void> setVolume(double volume) async {
    await _audioPlayer.setVolume(volume.clamp(0.0, 1.0));
  }

  /// Gets the current playback position
  Duration? get position => _audioPlayer.position;

  /// Gets the duration of the current track
  Duration? get duration => _audioPlayer.duration;

  /// Stream of position updates
  ///
  /// Emits the current playback position at regular intervals
  Stream<Duration> get positionStream => _audioPlayer.positionStream;

  /// Stream of duration updates
  ///
  /// Emits when the duration of the current track becomes available
  Stream<Duration?> get durationStream => _audioPlayer.durationStream;

  /// Stream of buffered position updates
  ///
  /// Useful for showing buffering progress in the UI
  Stream<Duration> get bufferedPositionStream =>
      _audioPlayer.bufferedPositionStream;

  /// Gets the audio session instance
  ///
  /// Useful for advanced audio session management if needed
  AudioSession get audioSession => _audioSession;

  /// Whether the audio session has been successfully initialized
  bool get isSessionInitialized => _sessionInitialized;
}

/// Provider for the audio player service
///
/// Use this provider to access audio playback functionality throughout the app:
///
/// ```dart
/// final audioService = ref.read(audioPlayerServiceProvider.notifier);
/// await audioService.play('https://example.com/audio.mp3', 'Track Title');
/// ```
///
/// To watch state changes:
///
/// ```dart
/// final audioState = ref.watch(audioPlayerServiceProvider);
/// if (audioState.isPlaying) {
///   // Show pause button
/// }
/// ```
final audioPlayerServiceProvider =
    NotifierProvider<AudioPlayerService, AudioPlayerState>(
      AudioPlayerService.new,
    );
