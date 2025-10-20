import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../logistics_hub/presentation/pages/logistics_hub_screen.dart';
import '../../../daily_journey/presentation/pages/day_screen.dart';
import '../../../user_profile/presentation/pages/user_profile_screen.dart';
import '../controllers/main_tabs_controller.dart';

/// Main tabs screen for authenticated users who have completed onboarding.
///
/// This screen provides access to three main tabs:
/// - Tab 0: Logistics Hub (booking and arrival information)
/// - Tab 1: Daily Journey (3 days of practices)
/// - Tab 2: User Profile (account settings and logout)
///
/// The screen uses a bottom navigation bar for tab switching and maintains
/// the state of each tab independently.
class MainTabsScreen extends ConsumerStatefulWidget {
  /// Creates a main tabs screen.
  ///
  /// [initialTab] specifies which tab to show initially (0, 1, or 2).
  /// Defaults to 0 (Logistics Hub).
  const MainTabsScreen({super.key, this.initialTab = 0});

  /// The index of the tab to display initially (0 = Logistics, 1 = Journey, 2 = Profile)
  final int initialTab;

  @override
  ConsumerState<MainTabsScreen> createState() => _MainTabsScreenState();
}

class _MainTabsScreenState extends ConsumerState<MainTabsScreen> {
  // List of tab widgets
  static final List<Widget> _pages = const [
    LogisticsHubScreen(),
    _DailyJourneyTab(),
    UserProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Set the initial tab in the controller
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mainTabsControllerProvider.notifier).setTab(widget.initialTab);
    });
  }

  void _onItemTapped(int index) {
    ref.read(mainTabsControllerProvider.notifier).setTab(index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Watch the selected tab from the controller
    final selectedIndex = ref.watch(mainTabsControllerProvider);

    return Scaffold(
      body: IndexedStack(index: selectedIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: _onItemTapped,
        backgroundColor: theme.scaffoldBackgroundColor,
        indicatorColor: theme.colorScheme.primary.withValues(alpha: 0.2),
        elevation: 8,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(
              Icons.home_rounded,
              color: theme.colorScheme.primary,
            ),
            label: 'Logistics',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(
              Icons.calendar_today_rounded,
              color: theme.colorScheme.primary,
            ),
            label: 'Journey',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(
              Icons.person_rounded,
              color: theme.colorScheme.primary,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

/// Daily Journey tab widget that shows day 1 by default.
///
/// This widget provides access to the 3-day journey. Initially shows day 1,
/// and users can navigate between days using the timeline navigator within
/// the DayScreen. All navigation happens within this tab without leaving the
/// tab context.
class _DailyJourneyTab extends StatefulWidget {
  const _DailyJourneyTab();

  @override
  State<_DailyJourneyTab> createState() => _DailyJourneyTabState();
}

class _DailyJourneyTabState extends State<_DailyJourneyTab> {
  // Current day being displayed (1-3)
  int _currentDay = 1;

  /// Changes the current day and rebuilds the widget
  void _changeDay(int newDay) {
    if (newDay >= 1 && newDay <= 3 && newDay != _currentDay) {
      setState(() {
        _currentDay = newDay;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Display the current day screen with navigation callbacks
    return DayScreen(
      dayId: _currentDay.toString(),
      onNavigateToDay: _changeDay,
    );
  }
}
