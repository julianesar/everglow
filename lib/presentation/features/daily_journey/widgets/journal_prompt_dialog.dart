import 'package:flutter/material.dart';
import 'package:everglow_app/domain/models/daily_journey_models.dart';

/// A reusable dialog widget for journaling prompts.
///
/// This dialog presents a journaling prompt to the user and allows them
/// to enter their reflection. It follows the app's "Quantum Glow" theme
/// with proper styling and user experience considerations.
///
/// The dialog returns the entered text when the user presses 'Save',
/// or null if they cancel.
class JournalPromptDialog extends StatefulWidget {
  /// The journaling prompt to display
  final JournalingPrompt prompt;

  const JournalPromptDialog({
    super.key,
    required this.prompt,
  });

  /// Shows the journal prompt dialog and returns the entered text or null.
  ///
  /// Example usage:
  /// ```dart
  /// final response = await showDialog<String>(
  ///   context: context,
  ///   builder: (context) => JournalPromptDialog(prompt: myPrompt),
  /// );
  /// if (response != null) {
  ///   // Handle the user's journal entry
  /// }
  /// ```
  static Future<String?> show(
    BuildContext context,
    JournalingPrompt prompt,
  ) {
    return showDialog<String>(
      context: context,
      builder: (context) => JournalPromptDialog(prompt: prompt),
    );
  }

  @override
  State<JournalPromptDialog> createState() => _JournalPromptDialogState();
}

class _JournalPromptDialogState extends State<JournalPromptDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSave() {
    Navigator.of(context).pop(_controller.text);
  }

  void _handleCancel() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      backgroundColor: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: Text(
        widget.prompt.promptText,
        style: theme.textTheme.titleLarge,
      ),
      content: TextFormField(
        controller: _controller,
        maxLines: 5,
        autofocus: true,
        style: theme.textTheme.bodyLarge,
        decoration: InputDecoration(
          hintText: 'Share your thoughts...',
          hintStyle: theme.inputDecorationTheme.hintStyle,
          filled: true,
          fillColor: theme.inputDecorationTheme.fillColor,
          border: theme.inputDecorationTheme.border,
          enabledBorder: theme.inputDecorationTheme.enabledBorder,
          focusedBorder: theme.inputDecorationTheme.focusedBorder,
        ),
      ),
      actions: [
        TextButton(
          onPressed: _handleCancel,
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _handleSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
