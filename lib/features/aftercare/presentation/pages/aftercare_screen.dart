import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/data/repositories/auth_repository_impl.dart';
import '../../../aftercare/data/repositories/aftercare_repository_impl.dart';
import '../../../aftercare/domain/entities/commitment.dart';

/// Aftercare screen for post-journey wellness protocols and guidance.
///
/// This screen provides access to aftercare resources and account management
/// after completing the 3-day journey at EverGlow.
///
/// This is accessible from the main tabs navigation (Tab 2 - Aftercare).
class AftercareScreen extends ConsumerWidget {
  const AftercareScreen({super.key});

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    // Show confirmation dialog
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (shouldLogout == true && context.mounted) {
      try {
        // Perform logout
        await ref.read(authRepositoryProvider).signOut();

        // Navigate to auth screen
        if (context.mounted) {
          context.go('/auth');
        }
      } catch (e) {
        // Show error message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error logging out: $e'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commitmentsAsync = ref.watch(_commitmentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Aftercare Protocol'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => _handleLogout(context, ref),
          ),
        ],
      ),
      body: commitmentsAsync.when(
        data: (commitments) => _buildCommitmentsView(context, commitments),
        loading: () => _buildLoadingView(context),
        error: (error, stack) => _buildErrorView(context, error),
      ),
    );
  }

  /// Builds the main commitments view displaying all user commitments.
  Widget _buildCommitmentsView(
    BuildContext context,
    List<Commitment> commitments,
  ) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section
          Row(
            children: [
              Icon(
                Icons.favorite_border,
                size: 28,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Your Integration Commitments',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'These are the key commitments you made during your 3-day journey. Keep them close as you continue your transformation.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 32),

          // Commitments list
          if (commitments.isEmpty)
            _buildEmptyState(context)
          else
            ...commitments.map(
              (commitment) => Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: _buildCommitmentCard(context, commitment),
              ),
            ),

          // Lab Results section
          const SizedBox(height: 48),
          _buildLabResultsSection(context),

          // Call-to-action section
          const SizedBox(height: 48),
          _buildCallToActionSection(context),

          // Bottom padding for better scrolling experience
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  /// Builds a single commitment card with elegant styling.
  Widget _buildCommitmentCard(BuildContext context, Commitment commitment) {
    final theme = Theme.of(context);

    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Commitment text
            Text(
              commitment.commitmentText,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: 16,
                height: 1.6,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),

            // Day tag
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.wb_sunny_outlined,
                        size: 14,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Day ${commitment.sourceDay}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the lab results section with dummy data for MVP.
  Widget _buildLabResultsSection(BuildContext context) {
    final theme = Theme.of(context);

    // Dummy lab reports for MVP
    final labReports = [
      {'title': 'Pre-Treatment Analysis', 'date': 'June 10'},
      {'title': 'Mid-Journey Biomarkers', 'date': 'June 12'},
      {'title': 'Post-Treatment Biomarkers', 'date': 'June 14'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header section
        Row(
          children: [
            Icon(Icons.biotech, size: 28, color: theme.colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Your Biomarker Reports',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Access your comprehensive lab results and biomarker analyses from your journey.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 24),

        // Lab reports list
        Card(
          elevation: 3,
          child: Column(
            children: labReports.asMap().entries.map((entry) {
              final index = entry.key;
              final report = entry.value;
              final isLast = index == labReports.length - 1;

              return Column(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(
                          alpha: 0.15,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.picture_as_pdf,
                        color: theme.colorScheme.primary,
                        size: 24,
                      ),
                    ),
                    title: Text(
                      report['title']!,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        report['date']!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Opening ${report['title']?.toLowerCase()}.pdf... (feature coming soon)',
                          ),
                          behavior: SnackBarBehavior.floating,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                  if (!isLast)
                    Divider(
                      height: 1,
                      indent: 76,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  /// Builds the call-to-action section for continued support.
  Widget _buildCallToActionSection(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.15),
            theme.colorScheme.primary.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Icon and title
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.spa_outlined,
                size: 32,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  'Your Journey Continues',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Description
          Text(
            'Experience personalized care with exclusive access to our wellness concierge. Book a follow-up consultation to deepen your transformation.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
              height: 1.6,
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),

          // Call-to-action button
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(
                        Icons.mark_email_read_outlined,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Contacting your concierge... (feature coming soon)',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: theme.colorScheme.surface,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.all(16),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 18),
              elevation: 2,
              shadowColor: theme.colorScheme.primary.withValues(alpha: 0.4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'BOOK FOLLOW-UP CONSULTATION',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  Icons.arrow_forward,
                  size: 18,
                  color: theme.colorScheme.onPrimary,
                ),
              ],
            ),
          ),

          // Additional subtle text
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.verified_outlined,
                size: 16,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              const SizedBox(width: 6),
              Text(
                'Exclusive access for EverGlow members',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds the loading view while commitments are being extracted.
  Widget _buildLoadingView(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: theme.colorScheme.primary),
          const SizedBox(height: 24),
          Text(
            'Extracting your commitments...',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the error view if commitment extraction fails.
  Widget _buildErrorView(BuildContext context, Object error) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: theme.colorScheme.error.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 24),
            Text(
              'Failed to load commitments',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              error.toString(),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the empty state view when no commitments are found.
  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.note_alt_outlined,
              size: 64,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 24),
            Text(
              'No commitments found',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Complete your journal entries to extract your integration commitments.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Provider that fetches commitments from the aftercare repository.
///
/// This FutureProvider calls [AftercareRepository.extractCommitmentsFromJournal]
/// to retrieve the user's integration commitments from their journal entries.
final _commitmentsProvider = FutureProvider<List<Commitment>>((ref) async {
  final aftercareRepo = await ref.watch(aftercareRepositoryProvider.future);
  return aftercareRepo.extractCommitmentsFromJournal();
});
