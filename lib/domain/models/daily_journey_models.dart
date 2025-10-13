/// Data models for the Daily Journey feature
///
/// This file contains the domain models representing a daily journey
/// with various types of itinerary items including medical events,
/// guided practices, and journaling sections.

/// Abstract base class for all itinerary items
///
/// All itinerary items must have a time and title.
abstract class ItineraryItem {
  /// The scheduled time for this itinerary item (e.g., "9:00 AM")
  final String time;

  /// The title of this itinerary item
  final String title;

  const ItineraryItem({
    required this.time,
    required this.title,
  });
}

/// Represents a medical event in the daily journey
///
/// Medical events include appointments, procedures, or checkups
/// with a specific location and description.
class MedicalEvent extends ItineraryItem {
  /// Detailed description of the medical event
  final String description;

  /// Physical location of the medical event
  final String location;

  const MedicalEvent({
    required super.time,
    required super.title,
    required this.description,
    required this.location,
  });
}

/// Represents a guided practice session in the daily journey
///
/// Guided practices are audio-based meditation, breathing exercises,
/// or other therapeutic practices.
class GuidedPractice extends ItineraryItem {
  /// URL to the audio file for this guided practice
  final String audioUrl;

  const GuidedPractice({
    required super.time,
    required super.title,
    required this.audioUrl,
  });
}

/// Represents a journaling section in the daily journey
///
/// Journaling sections contain multiple prompts for the user to reflect on.
class JournalingSection extends ItineraryItem {
  /// List of journaling prompts for this section
  final List<JournalingPrompt> prompts;

  const JournalingSection({
    required super.time,
    required super.title,
    required this.prompts,
  });
}

/// Represents a single journaling prompt
///
/// Each prompt has a unique identifier and text to guide the user's reflection.
class JournalingPrompt {
  /// Unique identifier for this prompt
  final String id;

  /// The text of the journaling prompt
  final String promptText;

  const JournalingPrompt({
    required this.id,
    required this.promptText,
  });
}

/// Represents a complete daily journey
///
/// A daily journey contains all scheduled activities, practices,
/// and reflections for a single day in the user's healing journey.
class DailyJourney {
  /// The day number in the overall journey (e.g., Day 1, Day 2)
  final int dayNumber;

  /// The title or theme for this day
  final String title;

  /// The daily mantra or affirmation
  final String mantra;

  /// List of all itinerary items scheduled for this day
  final List<ItineraryItem> itinerary;

  /// The user's single priority for this day
  final String? singlePriority;

  const DailyJourney({
    required this.dayNumber,
    required this.title,
    required this.mantra,
    required this.itinerary,
    this.singlePriority,
  });

  /// Creates a copy of this DailyJourney with the given fields replaced
  DailyJourney copyWith({
    int? dayNumber,
    String? title,
    String? mantra,
    List<ItineraryItem>? itinerary,
    String? singlePriority,
  }) {
    return DailyJourney(
      dayNumber: dayNumber ?? this.dayNumber,
      title: title ?? this.title,
      mantra: mantra ?? this.mantra,
      itinerary: itinerary ?? this.itinerary,
      singlePriority: singlePriority ?? this.singlePriority,
    );
  }
}
