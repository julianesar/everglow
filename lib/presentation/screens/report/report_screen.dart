import 'package:flutter/material.dart';

/// Screen displaying the final report
class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report'),
      ),
      body: const Center(
        child: Text(
          'Report Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
