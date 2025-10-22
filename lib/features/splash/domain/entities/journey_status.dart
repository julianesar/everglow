/// Represents the overall status of the user's journey through the program.
///
/// This enum tracks the user's progress across the three-day journey,
/// from initial authentication through completion.
enum JourneyStatus {
  /// User is authenticated but does not have a booking yet.
  ///
  /// This state indicates that the user needs to select their transformation dates
  /// before proceeding to onboarding.
  needsBooking,

  /// User has a booking but has not yet completed onboarding.
  ///
  /// This state indicates that the user needs to complete the medical intake
  /// and concierge preferences before accessing the main app features.
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
