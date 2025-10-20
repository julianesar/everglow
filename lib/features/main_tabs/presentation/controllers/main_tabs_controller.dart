import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Controller for managing the selected tab in MainTabsScreen.
///
/// This controller holds the currently selected tab index and provides
/// a method to change it. It's used to allow other parts of the app
/// (like the LogisticsHub check-in celebration) to programmatically
/// switch tabs.
class MainTabsController extends StateNotifier<int> {
  MainTabsController() : super(0); // Default to tab 0 (Logistics Hub)

  /// Changes the selected tab to the specified index.
  ///
  /// Valid indices are:
  /// - 0: Logistics Hub
  /// - 1: Daily Journey
  /// - 2: User Profile
  void setTab(int index) {
    if (index >= 0 && index <= 2) {
      state = index;
    }
  }
}

/// Provider for the MainTabsController.
final mainTabsControllerProvider =
    StateNotifierProvider<MainTabsController, int>((ref) {
      return MainTabsController();
    });
