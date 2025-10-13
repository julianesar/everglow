import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../features/report/report_controller.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Screen displaying the final AI-generated Rebirth Protocol report.
///
/// This screen watches the [reportControllerProvider] to display the
/// async state of report generation with proper loading, error, and data states.
/// Includes functionality to export the report as a PDF document.
class ReportScreen extends ConsumerWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(reportControllerProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Your Rebirth Protocol')),
      body: reportAsync.when(
        loading: () => _buildLoadingState(theme),
        error: (error, stack) => _buildErrorState(context, ref, error, theme),
        data: (reportText) => _buildDataState(reportText, theme),
      ),
      floatingActionButton: reportAsync.hasValue
          ? FloatingActionButton.extended(
              onPressed: () => _exportToPdf(context, reportAsync.value!),
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('Export to PDF'),
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
            )
          : null,
    );
  }

  /// Builds the loading state with synthesis animation.
  Widget _buildLoadingState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(strokeWidth: 3),
          const SizedBox(height: 24),
          Text(
            'Forging your Rebirth Protocol...',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.secondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Builds the error state with retry functionality.
  Widget _buildErrorState(
    BuildContext context,
    WidgetRef ref,
    Object error,
    ThemeData theme,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
            const SizedBox(height: 24),
            Text(
              'Failed to generate your report',
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              error.toString(),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                ref.invalidate(reportControllerProvider);
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the data state displaying the generated report.
  Widget _buildDataState(String reportText, ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section with icon
          Row(
            children: [
              Icon(
                Icons.auto_awesome,
                color: theme.colorScheme.primary,
                size: 32,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Your Personalized Report',
                  style: theme.textTheme.headlineMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Divider
          Divider(color: theme.dividerTheme.color),
          const SizedBox(height: 24),

          // Report content with Markdown rendering
          MarkdownBody(
            data: reportText,
            styleSheet: MarkdownStyleSheet(
              p: theme.textTheme.bodyLarge,
              h1: theme.textTheme.headlineLarge,
              h2: theme.textTheme.headlineMedium,
              h3: theme.textTheme.headlineSmall,
              h4: theme.textTheme.titleLarge,
              h5: theme.textTheme.titleMedium,
              h6: theme.textTheme.titleSmall,
              blockquote: theme.textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
                color: theme.colorScheme.secondary,
              ),
              code: theme.textTheme.bodyMedium?.copyWith(
                fontFamily: 'monospace',
                backgroundColor: theme.colorScheme.surface,
              ),
              listBullet: theme.textTheme.bodyLarge,
            ),
          ),

          // Bottom padding for FAB
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  /// Exports the report to a PDF file.
  Future<void> _exportToPdf(BuildContext context, String reportText) async {
    final theme = Theme.of(context);

    try {
      // Create PDF document
      final pdf = pw.Document();

      // Add page with report content
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (context) => [
            pw.Header(
              level: 0,
              child: pw.Text(
                'Your Rebirth Protocol',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Divider(),
            pw.SizedBox(height: 20),
            pw.Text(
              reportText,
              style: const pw.TextStyle(fontSize: 12, lineSpacing: 1.5),
            ),
          ],
        ),
      );

      // Show print/save dialog
      await Printing.layoutPdf(
        onLayout: (format) async => pdf.save(),
        name: 'rebirth_protocol_report.pdf',
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Report exported successfully'),
            backgroundColor: theme.colorScheme.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to export: ${e.toString()}'),
            backgroundColor: theme.colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
