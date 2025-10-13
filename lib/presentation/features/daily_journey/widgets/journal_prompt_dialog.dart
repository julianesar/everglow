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

  /// Optional initial response text to pre-populate the dialog (for editing)
  final String? initialResponse;

  const JournalPromptDialog({
    super.key,
    required this.prompt,
    this.initialResponse,
  });

  /// Shows the journal prompt dialog and returns the entered text or null.
  ///
  /// Optionally accepts an [initialResponse] parameter to pre-populate the
  /// text field when editing an existing response.
  ///
  /// Example usage:
  /// ```dart
  /// // For new entry
  /// final response = await JournalPromptDialog.show(context, myPrompt);
  ///
  /// // For editing existing entry
  /// final response = await JournalPromptDialog.show(
  ///   context,
  ///   myPrompt,
  ///   initialResponse: existingText,
  /// );
  ///
  /// if (response != null) {
  ///   // Handle the user's journal entry
  /// }
  /// ```
  static Future<String?> show(
    BuildContext context,
    JournalingPrompt prompt, {
    String? initialResponse,
  }) {
    return showDialog<String>(
      context: context,
      builder: (context) =>
          JournalPromptDialog(prompt: prompt, initialResponse: initialResponse),
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
    // Initialize controller with existing response if provided
    _controller = TextEditingController(text: widget.initialResponse ?? '');
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text(widget.prompt.promptText, style: theme.textTheme.titleLarge),
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
        TextButton(onPressed: _handleCancel, child: const Text('Cancel')),
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
