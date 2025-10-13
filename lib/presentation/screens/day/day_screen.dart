import 'package:flutter/material.dart';

/// Screen displaying the daily itinerary for a specific day
class DayScreen extends StatelessWidget {
  const DayScreen({
    super.key,
    required this.dayId,
  });

  /// The ID of the day to display
  final String dayId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Day $dayId'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Day Screen',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 16),
            Text(
              'Day ID: $dayId',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
