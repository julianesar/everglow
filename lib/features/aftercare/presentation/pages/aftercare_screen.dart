import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import '../../../../core/database/isar_provider.dart';
import '../../../auth/data/repositories/auth_repository_impl.dart';
import '../../../aftercare/data/repositories/aftercare_repository_impl.dart';
import '../../../aftercare/domain/entities/commitment.dart';
import '../../../journal/data/repositories/journal_repository_impl.dart';
import '../../../user/data/models/user_model.dart';

/// Aftercare screen for post-journey wellness protocols and guidance.
///
/// This screen provides access to aftercare resources and account management
/// after completing the 3-day journey at EverGlow.
///
/// This is accessible from the main tabs navigation (Tab 2 - Aftercare).
class AftercareScreen extends ConsumerStatefulWidget {
  const AftercareScreen({super.key});

  @override
  ConsumerState<AftercareScreen> createState() => _AftercareScreenState();
}

class _AftercareScreenState extends ConsumerState<AftercareScreen> {
  bool _isGeneratingCommitments = false;

  Future<void> _handleLogout(BuildContext context) async {
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

  /// Generates commitments using AI based on journal entries
  Future<void> _generateCommitmentsWithAI() async {
    final theme = Theme.of(context);

    // Check if user already has 10 commitments
    final commitmentsAsync = ref.read(_commitmentsProvider);
    final currentCommitments = commitmentsAsync.valueOrNull ?? [];

    if (currentCommitments.length >= 10) {
      // Show message that max commitments reached
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Maximum of 10 commitments reached. Please delete some commitments to generate new ones.',
            ),
            backgroundColor: theme.colorScheme.error,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
          ),
        );
      }
      return;
    }

    setState(() {
      _isGeneratingCommitments = true;
    });

    try {
      final aftercareRepo = await ref.read(aftercareRepositoryProvider.future);
      await aftercareRepo.extractCommitmentsFromJournal(forceRefresh: true);

      // Invalidate the provider to refresh the UI
      ref.invalidate(_commitmentsProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Commitments generated successfully!'),
            backgroundColor: Theme.of(context).colorScheme.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate commitments: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGeneratingCommitments = false;
        });
      }
    }
  }

  /// Shows a dialog to add a manual commitment
  Future<void> _showAddManualCommitmentDialog() async {
    final theme = Theme.of(context);

    // Check if user already has 10 commitments
    final commitmentsAsync = ref.read(_commitmentsProvider);
    final currentCommitments = commitmentsAsync.valueOrNull ?? [];

    if (currentCommitments.length >= 10) {
      // Show message that max commitments reached
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Maximum of 10 commitments reached. Please delete some commitments to add new ones.',
            ),
            backgroundColor: theme.colorScheme.error,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
          ),
        );
      }
      return;
    }

    final commitmentController = TextEditingController();
    int selectedDay = 1;

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.15,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.edit_outlined,
                          color: theme.colorScheme.primary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Add Commitment',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Description
                  Text(
                    'Create a personal commitment that reflects your journey and intentions.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Commitment text field
                  Text(
                    'Your Commitment',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: commitmentController,
                    maxLines: 4,
                    maxLength: 300,
                    decoration: InputDecoration(
                      hintText:
                          'e.g., I will practice daily meditation for 15 minutes...',
                      hintStyle: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.4,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: theme.colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: theme.colorScheme.surface,
                      counterStyle: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.5,
                        ),
                      ),
                    ),
                    style: theme.textTheme.bodyMedium,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: 24),

                  // Day selection
                  Text(
                    'Associated Journey Day',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [1, 2, 3].map((day) {
                      final isSelected = selectedDay == day;
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: day < 3 ? 8.0 : 0),
                          child: ChoiceChip(
                            label: SizedBox(
                              width: double.infinity,
                              child: Text(
                                'Day $day',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? theme.colorScheme.onPrimary
                                      : theme.colorScheme.onSurface,
                                ),
                              ),
                            ),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) {
                                setDialogState(() {
                                  selectedDay = day;
                                });
                              }
                            },
                            selectedColor: theme.colorScheme.primary,
                            backgroundColor: theme.colorScheme.surface,
                            side: BorderSide(
                              color: isSelected
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.outline.withValues(
                                      alpha: 0.3,
                                    ),
                              width: isSelected ? 2 : 1,
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(dialogContext).pop(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(color: theme.colorScheme.outline),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            final text = commitmentController.text.trim();
                            if (text.isNotEmpty) {
                              Navigator.of(
                                dialogContext,
                              ).pop({'text': text, 'day': selectedDay});
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 2,
                          ),
                          child: const Text(
                            'Add',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    // If user confirmed, add the commitment
    if (result != null && mounted) {
      try {
        final aftercareRepo = await ref.read(
          aftercareRepositoryProvider.future,
        );
        await aftercareRepo.addManualCommitment(
          commitmentText: result['text'] as String,
          sourceDay: result['day'] as int,
        );

        // Refresh the commitments list
        ref.invalidate(_commitmentsProvider);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Commitment added successfully!'),
              backgroundColor: theme.colorScheme.primary,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          final errorMessage =
              e.toString().contains('Maximum of 10 commitments')
              ? 'Maximum of 10 commitments reached. Please delete some commitments to add new ones.'
              : 'Failed to add commitment: $e';

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: theme.colorScheme.error,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
    }
  }

  /// Checks if there are any completed journal entries
  Future<bool> _hasCompletedJournalEntries() async {
    try {
      final journalRepo = await ref.read(journalRepositoryProvider.future);
      final allUserData = await journalRepo.getAllUserData();

      // Check if there's any data for any day
      if (allUserData.isEmpty) {
        return false;
      }

      // Check if any day has journal entries with actual content
      for (final entry in allUserData.values) {
        if (entry is Map<String, dynamic>) {
          final journalEntries =
              entry['journal_entries'] as Map<String, dynamic>?;
          if (journalEntries != null && journalEntries.isNotEmpty) {
            // Check if any entry has non-empty content
            final hasContent = journalEntries.values.any(
              (value) => value is String && value.trim().isNotEmpty,
            );
            if (hasContent) {
              return true;
            }
          }
        }
      }

      return false;
    } catch (e) {
      debugPrint('[AftercareScreen] Error checking journal entries: $e');
      return false;
    }
  }

  /// Checks if the Rebirth Protocol report has already been generated.
  ///
  /// Returns true if the report exists in cache, false otherwise.
  Future<bool> _hasGeneratedReport() async {
    try {
      final isar = await ref.read(isarProvider.future);
      final users = isar.users;
      final user = await users.where().findFirst();

      if (user == null) {
        return false;
      }

      final report = user.generatedReport;
      return report != null && report.trim().isNotEmpty;
    } catch (e) {
      debugPrint('[AftercareScreen] Error checking generated report: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final commitmentsAsync = ref.watch(_commitmentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Aftercare Protocol'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => _handleLogout(context),
          ),
        ],
      ),
      body: FutureBuilder<bool>(
        future: _hasCompletedJournalEntries(),
        builder: (context, hasEntriesSnapshot) {
          if (!hasEntriesSnapshot.hasData) {
            return _buildLoadingView(context);
          }

          final hasJournalEntries = hasEntriesSnapshot.data ?? false;

          return commitmentsAsync.when(
            data: (commitments) =>
                _buildCommitmentsView(context, commitments, hasJournalEntries),
            loading: () => _buildLoadingView(context),
            error: (error, stack) => _buildErrorView(context, error),
          );
        },
      ),
    );
  }

  /// Builds the main commitments view displaying all user commitments.
  Widget _buildCommitmentsView(
    BuildContext context,
    List<Commitment> commitments,
    bool hasJournalEntries,
  ) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rebirth Protocol Report Card - First thing user sees
          _buildRebirthProtocolCard(context, theme),
          const SizedBox(height: 48),

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

          // Empty state message (only shown when no commitments)
          if (commitments.isEmpty)
            _buildEmptyStateMessage(context, hasJournalEntries),

          // Commitments list
          if (commitments.isNotEmpty) ...[
            ...commitments.map(
              (commitment) => Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: _buildCommitmentCard(context, commitment),
              ),
            ),
          ],

          // Action buttons: Always visible unless at max capacity
          if (commitments.length < 10) ...[
            if (commitments.isNotEmpty) const SizedBox(height: 24),
            if (hasJournalEntries) ...[
              // AI Generation button (shown if journal entries exist and less than 10 commitments)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isGeneratingCommitments
                      ? null
                      : _generateCommitmentsWithAI,
                  icon: _isGeneratingCommitments
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              theme.colorScheme.onPrimary,
                            ),
                          ),
                        )
                      : const Icon(Icons.auto_awesome, size: 20),
                  label: Text(
                    _isGeneratingCommitments
                        ? 'Generating with AI...'
                        : commitments.isEmpty
                            ? 'Generate with AI'
                            : 'Generate More with AI',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 24,
                    ),
                    elevation: 2,
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
            // Manual addition button (always shown if less than 10 commitments)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _showAddManualCommitmentDialog,
                icon: Icon(
                  Icons.add_circle_outline,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                label: Text(
                  commitments.isEmpty
                      ? 'Add Manual Commitment'
                      : 'Add Another Commitment',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 24,
                  ),
                  side: BorderSide(
                    color: theme.colorScheme.primary,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ] else ...[
            // Show message when max commitments reached
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'You have reached the maximum of 10 commitments. Delete some to add new ones.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

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

  /// Builds the Rebirth Protocol report generation card.
  ///
  /// This is the first element the user sees on the aftercare screen.
  /// It provides access to the AI-generated comprehensive journey report.
  Widget _buildRebirthProtocolCard(BuildContext context, ThemeData theme) {
    return FutureBuilder<bool>(
      future: _hasGeneratedReport(),
      builder: (context, snapshot) {
        // Default to false while loading
        final hasReport = snapshot.data ?? false;

        // Determine button text and icon based on report status
        final buttonText = hasReport
            ? 'View Your Protocol'
            : 'Generate with AI';
        final buttonIcon = hasReport
            ? Icons.description_outlined
            : Icons.auto_awesome;
        final subtitle = hasReport
            ? 'AI-Generated Journey Synthesis'
            : 'Ready to Generate';

        return Card(
          elevation: 4,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primary.withValues(alpha: 0.1),
                  theme.colorScheme.secondary.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon and title row
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.15,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          buttonIcon,
                          size: 32,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your Rebirth Protocol',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              subtitle,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.6,
                                ),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Description
                  Text(
                    hasReport
                        ? 'Your personalized transformation report is ready. Review the comprehensive synthesis of your 3-day journey, celebrating your growth, insights, and the new you.'
                        : 'Discover the full story of your 3-day transformation. Our AI will analyze your entire journey to create a comprehensive, personalized report celebrating your growth, insights, and the new you.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      height: 1.6,
                      color: theme.colorScheme.onSurface.withValues(
                        alpha: 0.85,
                      ),
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Action button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        context.push('/report');
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 18,
                          horizontal: 24,
                        ),
                        elevation: 2,
                        shadowColor: theme.colorScheme.primary.withValues(
                          alpha: 0.4,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            buttonIcon,
                            size: 20,
                            color: theme.colorScheme.onPrimary,
                          ),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Text(
                              buttonText,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 18,
                            color: theme.colorScheme.onPrimary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Shows a confirmation dialog before deleting a commitment
  Future<void> _confirmDeleteCommitment(
    BuildContext context,
    Commitment commitment,
  ) async {
    final theme = Theme.of(context);

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(
              Icons.delete_outline,
              color: theme.colorScheme.error,
              size: 28,
            ),
            const SizedBox(width: 12),
            const Expanded(child: Text('Delete Commitment')),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to delete this commitment?',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.error.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                commitment.commitmentText,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This action cannot be undone.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error.withValues(alpha: 0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
              foregroundColor: theme.colorScheme.onError,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete == true && context.mounted) {
      try {
        final aftercareRepo = await ref.read(
          aftercareRepositoryProvider.future,
        );
        await aftercareRepo.deleteCommitment(commitment.id);

        // Refresh the commitments list
        ref.invalidate(_commitmentsProvider);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Commitment deleted successfully'),
              backgroundColor: theme.colorScheme.primary,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete commitment: $e'),
              backgroundColor: theme.colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

  /// Builds a single commitment card with elegant styling.
  Widget _buildCommitmentCard(BuildContext context, Commitment commitment) {
    final theme = Theme.of(context);

    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
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
            ),
            const SizedBox(width: 12),
            // Delete button - centered vertically in the entire card
            IconButton(
              icon: Icon(
                Icons.delete_outline,
                size: 20,
                color: theme.colorScheme.error.withValues(alpha: 0.7),
              ),
              onPressed: () => _confirmDeleteCommitment(context, commitment),
              tooltip: 'Delete commitment',
              constraints: const BoxConstraints(),
              padding: const EdgeInsets.all(4),
              visualDensity: VisualDensity.compact,
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
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
              elevation: 2,
              shadowColor: theme.colorScheme.primary.withValues(alpha: 0.4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 20,
                  color: theme.colorScheme.onPrimary,
                ),
                const SizedBox(width: 12),
                const Flexible(
                  child: Text(
                    'Book Consultation',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_rounded,
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
              Flexible(
                child: Text(
                  'Exclusive access for EverGlow members',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
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
            const SizedBox(height: 24),
            Consumer(
              builder: (context, ref, _) => ElevatedButton.icon(
                onPressed: () {
                  // Retry by invalidating the provider
                  ref.invalidate(_commitmentsProvider);
                },
                icon: const Icon(Icons.refresh, size: 20),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a simple empty state message when there are no commitments yet.
  Widget _buildEmptyStateMessage(
    BuildContext context,
    bool hasJournalEntries,
  ) {
    final theme = Theme.of(context);

    if (!hasJournalEntries) {
      // No journal entries - show message to complete journal first
      return Container(
        padding: const EdgeInsets.all(24.0),
        margin: const EdgeInsets.only(bottom: 32.0),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.note_alt_outlined,
              size: 48,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'No Journal Entries Yet',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Complete at least one journal entry during your journey to generate commitments with AI.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Has journal entries but no commitments - show simple message
    return Container(
      padding: const EdgeInsets.all(24.0),
      margin: const EdgeInsets.only(bottom: 32.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.auto_awesome,
            size: 48,
            color: theme.colorScheme.primary.withValues(alpha: 0.7),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'No Commitments Yet',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Create your integration commitments using AI or add them manually.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Provider that fetches commitments from Supabase.
///
/// This provider retrieves commitments that have been saved to Supabase.
/// It does NOT trigger AI generation automatically.
/// Users must explicitly click "Generate with AI" to create commitments.
final _commitmentsProvider = FutureProvider.autoDispose<List<Commitment>>((
  ref,
) async {
  // Get the repository and fetch commitments from Supabase
  final aftercareRepo = await ref.watch(aftercareRepositoryProvider.future);

  // This will only return cached commitments from Supabase
  // It won't trigger AI generation
  return await aftercareRepo.extractCommitmentsFromJournal(forceRefresh: false);
});
