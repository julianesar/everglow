import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../domain/models/daily_journey_models.dart';
import '../../../data/repositories/daily_journey_repository.dart';

part 'daily_journey_controller.g.dart';

/// Controller for managing daily journey state and operations.
///
/// This controller fetches and manages the daily journey data for a specific day.
/// It uses Riverpod's AsyncNotifier to handle async state management.
@riverpod
class DailyJourneyController extends _$DailyJourneyController {
  /// Builds the initial state by fetching the daily journey for the given day.
  ///
  /// Throws an exception if the repository fails to fetch the data.
  @override
  Future<DailyJourney> build(int dayNumber) async {
    final repository = ref.watch(dailyJourneyRepositoryProvider);
    return await repository.getJourneyForDay(dayNumber);
  }

  // TODO: Add methods for saving user responses, reflections, etc.
}
