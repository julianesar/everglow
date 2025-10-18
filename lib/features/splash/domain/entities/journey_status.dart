/// Represents the overall status of the user's journey through the program.
///
/// This enum tracks the user's progress across the three-day journey,
/// from initial onboarding through completion.
enum JourneyStatus {
  /// User has not yet completed onboarding (no user exists in database).
  ///
  /// This is the initial state when the app is first launched.
  needsOnboarding,

  /// User has completed onboarding and has a booking, but has not checked in yet.
  ///
  /// This state indicates that the user is waiting for their arrival date
  /// or has arrived but not yet completed the check-in process.
  awaitingArrival,

  /// User has completed onboarding and is actively working through the journey.
  ///
  /// This state indicates that a user exists but has not yet completed
  /// all three days of the program.
  inProgress,

  /// User has completed all three days of the journey.
  ///
  /// This state indicates that the AI-generated report has been created,
  /// marking the successful completion of the three-day program.
  completed,
}
