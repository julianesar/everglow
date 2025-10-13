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
          mantra:
              'You cannot step into your future while clinging to your past.',
          itinerary: [
            GuidedPractice(
              time: 'Morning',
              title: 'Morning Intention Ceremony',
              audioUrl:
                  'https://foreverhealthyliving.com/wp-content/uploads/test/meditation-audio_test.mp3',
            ),
            MedicalEvent(
              time: '9 AM',
              title: 'Plasmapheresis detox',
              description:
                  'Your body and mind begin to let go of stored weight — physical, emotional, and energetic.',
              location: 'Medical Wing',
            ),
            MedicalEvent(
              time: '10 AM',
              title: 'IV nutrient infusions',
              description: 'Replenishing your system at a cellular level.',
              location: 'Medical Wing',
            ),
            MedicalEvent(
              time: '11 AM',
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
                  promptText:
                      'Who or what no longer has permission to occupy space in my energy?',
                ),
                JournalingPrompt(
                  id: 'd1q3',
                  promptText:
                      'What old identities or patterns am I saying goodbye to?',
                ),
                JournalingPrompt(
                  id: 'd1q4',
                  promptText:
                      'Today I choose to release _____ so I can create space for _____.',
                ),
                JournalingPrompt(
                  id: 'd1q5',
                  promptText:
                      'If I were free of this weight, how would I feel tomorrow?',
                ),
              ],
            ),
            GuidedPractice(
              time: 'Afternoon',
              title: 'Breath + Sound Reset',
              audioUrl:
                  'https://foreverhealthyliving.com/wp-content/uploads/test/meditation-audio_test_2.mp3',
            ),
            GuidedPractice(
              time: 'Evening',
              title: 'Evening Release Ritual',
              audioUrl:
                  'https://foreverhealthyliving.com/wp-content/uploads/test/meditation-audio_test_3.mp3',
            ),
          ],
        );
      case 2:
        return const DailyJourney(
          dayNumber: 2,
          title: 'DAY TWO — RISE',
          mantra: 'Energy returns when clarity aligns with purpose.',
          itinerary: [
            GuidedPractice(
              time: 'Morning',
              title: 'Cold Plunge or Power Breath',
              audioUrl:
                  'https://foreverhealthyliving.com/wp-content/uploads/test/meditation-audio_test.mp3',
            ),
            MedicalEvent(
              time: '9 AM',
              title: '10-Pass Ozone Therapy',
              description: 'Super-oxygenating your system for peak energy.',
              location: 'Medical Wing',
            ),
            MedicalEvent(
              time: '10 AM',
              title: 'Peptides & NAD+ Optimization',
              description: 'Activating cellular repair and vitality.',
              location: 'Medical Wing',
            ),
            GuidedPractice(
              time: 'Afternoon',
              title: 'Future-Self Visualization',
              audioUrl:
                  'https://foreverhealthyliving.com/wp-content/uploads/test/meditation-audio_test_2.mp3',
            ),
            JournalingSection(
              time: 'Afternoon',
              title: 'Journaling: Activating Your Future Self',
              prompts: [
                JournalingPrompt(
                  id: 'd2q1',
                  promptText: 'Who is my next-level self?',
                ),
                JournalingPrompt(
                  id: 'd2q2',
                  promptText: 'What would I do if I fully trusted myself?',
                ),
                JournalingPrompt(
                  id: 'd2q3',
                  promptText: 'How do I show up when I lead from clarity?',
                ),
                JournalingPrompt(
                  id: 'd2q4',
                  promptText:
                      'How does my most powerful self speak, move, and lead?',
                ),
                JournalingPrompt(
                  id: 'd2q5',
                  promptText: 'What action anchors this identity?',
                ),
              ],
            ),
            GuidedPractice(
              time: 'Evening',
              title: 'Evening Reflection + Lock-in',
              audioUrl:
                  'https://foreverhealthyliving.com/wp-content/uploads/test/meditation-audio_test_3.mp3',
            ),
          ],
        );
      case 3:
        return const DailyJourney(
          dayNumber: 3,
          title: 'DAY THREE — REBIRTH',
          mantra: 'I am the designer of my destiny.',
          itinerary: [
            MedicalEvent(
              time: '9 AM',
              title: 'Stem-Cell Therapy',
              description: 'The pinnacle of regeneration begins.',
              location: 'Medical Wing',
            ),
            MedicalEvent(
              time: '10AM',
              title: 'Longevity Infusions & Neural Rejuvenation',
              description:
                  'Supporting your system for long-term transformation.',
              location: 'Medical Wing',
            ),
            GuidedPractice(
              time: 'Afternoon',
              title: 'Quantum Heart Coherence Meditation',
              audioUrl:
                  'https://foreverhealthyliving.com/wp-content/uploads/test/meditation-audio_test.mp3',
            ),
            JournalingSection(
              time: 'Afternoon',
              title: 'Journaling: Anchoring Your New Identity',
              prompts: [
                JournalingPrompt(
                  id: 'd3q1',
                  promptText: 'Who am I, now that I\'ve chosen to rise?',
                ),
                JournalingPrompt(
                  id: 'd3q2',
                  promptText: 'What rituals will anchor this identity daily?',
                ),
                JournalingPrompt(
                  id: 'd3q3',
                  promptText: 'What does my new reality look and feel like?',
                ),
                JournalingPrompt(
                  id: 'd3q4',
                  promptText: 'What boundaries protect this version of me?',
                ),
                JournalingPrompt(
                  id: 'd3q5',
                  promptText: 'What am I no longer willing to tolerate?',
                ),
              ],
            ),
            GuidedPractice(
              time: 'Evening',
              title: 'Gratitude + Declaration Ritual',
              audioUrl:
                  'https://foreverhealthyliving.com/wp-content/uploads/test/meditation-audio_test_2.mp3',
            ),
          ],
        );
      default:
        throw UnimplementedError(
          'Journey content for day $dayNumber has not been implemented yet.',
        );
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
