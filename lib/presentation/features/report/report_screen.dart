import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'report_controller.dart';

/// Final report screen that displays the AI-generated personal growth report.
///
/// This screen:
/// - Watches the [ReportController] to manage async state
/// - Shows a synthesis animation during loading
/// - Displays the report in a beautifully formatted markdown view
/// - Provides a PDF export button for saving the report
class ReportScreen extends ConsumerWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportState = ref.watch(reportControllerProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Your Rebirth Protocol'), elevation: 0),
      body: reportState.when(
        // Loading state - Show synthesis animation
        loading: () => _buildLoadingState(context, theme),

        // Error state - Show error message with retry option
        error: (error, stackTrace) =>
            _buildErrorState(context, theme, error, ref),

        // Data state - Show the formatted report
        data: (report) => _buildReportContent(context, theme, report),
      ),
      // PDF export button (visible when report is loaded)
      floatingActionButton: reportState.hasValue
          ? FloatingActionButton.extended(
              onPressed: () {
                // TODO: Implement PDF export functionality
              },
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('Export PDF'),
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
            )
          : null,
    );
  }

  /// Builds the loading state with synthesis animation.
  Widget _buildLoadingState(BuildContext context, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Circular progress indicator with quantum glow theme colors
          SizedBox(
            width: 80,
            height: 80,
            child: CircularProgressIndicator(
              strokeWidth: 6,
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.primary,
              ),
              backgroundColor: theme.colorScheme.secondary.withValues(
                alpha: 0.2,
              ),
            ),
          ),
          const SizedBox(height: 32),
          // Synthesis message
          Text(
            'Forging your Rebirth Protocol...',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // Subtext
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'Our AI is analyzing your 21-day journey to create your personalized growth report.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the error state with retry button.
  Widget _buildErrorState(
    BuildContext context,
    ThemeData theme,
    Object error,
    WidgetRef ref,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Error icon
            Icon(Icons.error_outline, size: 80, color: theme.colorScheme.error),
            const SizedBox(height: 24),
            // Error title
            Text(
              'Unable to Generate Report',
              style: theme.textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            // Error message
            Text(
              error.toString(),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            // Retry button
            ElevatedButton.icon(
              onPressed: () {
                ref.read(reportControllerProvider.notifier).regenerateReport();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the report content display with markdown formatting.
  Widget _buildReportContent(
    BuildContext context,
    ThemeData theme,
    String report,
  ) {
    return Column(
      children: [
        // Report header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.primary.withValues(alpha: 0.1),
                theme.colorScheme.secondary.withValues(alpha: 0.1),
              ],
            ),
            border: Border(
              bottom: BorderSide(
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Personal Growth Journey',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'A comprehensive analysis of your 21-day transformation',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
        // Scrollable report content
        Expanded(
          child: Markdown(
            data: report,
            selectable: true,
            padding: const EdgeInsets.all(24),
            styleSheet: MarkdownStyleSheet(
              // Headings
              h1: theme.textTheme.displaySmall?.copyWith(
                color: theme.colorScheme.primary,
                height: 1.5,
              ),
              h2: theme.textTheme.headlineLarge?.copyWith(
                color: theme.colorScheme.primary,
                height: 1.5,
              ),
              h3: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.secondary,
                height: 1.5,
              ),
              h4: theme.textTheme.headlineSmall?.copyWith(height: 1.5),
              h5: theme.textTheme.titleLarge?.copyWith(height: 1.5),
              h6: theme.textTheme.titleMedium?.copyWith(height: 1.5),
              // Body text
              p: theme.textTheme.bodyLarge?.copyWith(
                height: 1.8,
                letterSpacing: 0.3,
              ),
              // Lists
              listBullet: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.primary,
              ),
              listIndent: 24,
              // Block quotes
              blockquote: theme.textTheme.bodyLarge?.copyWith(
                fontStyle: FontStyle.italic,
                color: theme.colorScheme.secondary,
              ),
              blockquoteDecoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: theme.colorScheme.secondary,
                    width: 4,
                  ),
                ),
              ),
              blockquotePadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              // Code
              code: theme.textTheme.bodyMedium?.copyWith(
                fontFamily: 'monospace',
                backgroundColor: theme.colorScheme.surface,
              ),
              // Emphasis
              em: const TextStyle(fontStyle: FontStyle.italic),
              strong: const TextStyle(fontWeight: FontWeight.bold),
              // Horizontal rule
              horizontalRuleDecoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
