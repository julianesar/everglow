import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/models/daily_journey_models.dart';

part 'daily_journey_repository.g.dart';

/// Abstract repository contract for daily journey content.
///
/// This interface defines the contract for retrieving daily journey data,
/// following the Repository pattern from Clean Architecture.
abstract class DailyJourneyRepository {
  /// Retrieves the daily journey content for a specific day.
  ///
  /// [dayNumber] The day number to retrieve (e.g., 1 for Day 1)
  ///
  /// Returns a [DailyJourney] object containing all content for the day.
  /// Throws [UnimplementedError] if content for the specified day is not available.
  Future<DailyJourney> getJourneyForDay(int dayNumber);
}

/// Static implementation of [DailyJourneyRepository].
///
/// This class provides hardcoded daily journey content for each day.
/// Content is stored as static data within the repository implementation.
class StaticDailyJourneyRepository implements DailyJourneyRepository {
  /// Creates an instance of [StaticDailyJourneyRepository].
  const StaticDailyJourneyRepository();

  @override
  Future<DailyJourney> getJourneyForDay(int dayNumber) async {
    // Simulate async operation
    await Future.delayed(const Duration(milliseconds: 50));

    switch (dayNumber) {
      case 1:
        return const DailyJourney(
          dayNumber: 1,
          title: 'DAY ONE — RELEASE',
          mantra: 'You cannot step into your future while clinging to your past.',
          itinerary: [
            GuidedPractice(
              time: 'Morning',
              title: 'Morning Intention Ceremony',
              audioUrl: 'placeholder_audio_url_1.mp3',
            ),
            MedicalEvent(
              time: 'AM',
              title: 'Plasmapheresis detox',
              description: 'Your body and mind begin to let go of stored weight — physical, emotional, and energetic.',
              location: 'Medical Wing',
            ),
            MedicalEvent(
              time: 'AM',
              title: 'IV nutrient infusions',
              description: 'Replenishing your system at a cellular level.',
              location: 'Medical Wing',
            ),
            MedicalEvent(
              time: 'AM',
              title: 'Heavy-metal elimination',
              description: 'Clearing space for what\'s next.',
              location: 'Medical Wing',
            ),
            JournalingSection(
              time: 'Afternoon',
              title: 'Journaling: Releasing Attachments',
              prompts: [
                JournalingPrompt(
                  id: 'd1q1',
                  promptText: 'What am I finally ready to release?',
                ),
                JournalingPrompt(
                  id: 'd1q2',
                  promptText: 'Who or what no longer has permission to occupy space in my energy?',
                ),
                JournalingPrompt(
                  id: 'd1q3',
                  promptText: 'What old identities or patterns am I saying goodbye to?',
                ),
                JournalingPrompt(
                  id: 'd1q4',
                  promptText: 'Today I choose to release _____ so I can create space for _____.',
                ),
                JournalingPrompt(
                  id: 'd1q5',
                  promptText: 'If I were free of this weight, how would I feel tomorrow?',
                ),
              ],
            ),
            GuidedPractice(
              time: 'Afternoon',
              title: 'Breath + Sound Reset',
              audioUrl: 'placeholder_audio_url_2.mp3',
            ),
            GuidedPractice(
              time: 'Evening',
              title: 'Evening Release Ritual',
              audioUrl: 'placeholder_audio_url_3.mp3',
            ),
          ],
        );
      default:
        throw UnimplementedError('Journey content for day $dayNumber has not been implemented yet.');
    }
  }
}

/// Provides an instance of [DailyJourneyRepository].
///
/// This provider creates and manages the [StaticDailyJourneyRepository] instance,
/// which provides static daily journey content.
@riverpod
DailyJourneyRepository dailyJourneyRepository(DailyJourneyRepositoryRef ref) {
  return const StaticDailyJourneyRepository();
}
