import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../user/presentation/controllers/user_controller.dart';

/// Provider to track if this is the user's first time viewing the hub.
/// Defaults to true and is set to false after the first render.
final isFirstHubViewProvider = StateProvider<bool>((ref) => true);

/// Transformation Hub screen for users who have completed the journey.
///
/// This screen serves as the main hub for users to:
/// - View their name and integration statement
/// - Access their Rebirth Protocol report
/// - Review individual day itineraries
/// - Navigate through their transformation journey
class HubScreen extends ConsumerWidget {
  const HubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    // Watch the user controller provider
    final userAsync = ref.watch(userControllerProvider);

    // Watch the isFirstHubView provider
    final isFirstHubView = ref.watch(isFirstHubViewProvider);

    // After the first render, set isFirstHubView to false
    ref.listen(userControllerProvider, (_, __) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(isFirstHubViewProvider.notifier).state = false;
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Transformation Hub',
          style: textTheme.titleLarge?.copyWith(
            color: const Color(0xFFFFD700), // Liquid Gold
          ),
        ),
        elevation: 0,
        backgroundColor: const Color(0xFF111111), // Charcoal Soul
      ),
      body: userAsync.when(
        // Loading state
        loading: () => const Center(child: CircularProgressIndicator()),

        // Error state
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: colorScheme.error),
                const SizedBox(height: 16),
                Text(
                  'Error Loading Hub',
                  style: textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),

        // Data state - user data loaded
        data: (user) {
          // Default values if user data is not available
          final userName = user?.name ?? 'Transformer';
          final integrationStatement = user?.integrationStatement ??
              'Your personal integration statement will appear here.';

          // Determine the greeting based on whether this is the first visit
          final greeting = isFirstHubView ? 'Congratulations,' : 'Welcome back,';

          return SafeArea(
            child: CustomScrollView(
              slivers: [
                // Welcome section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Greeting - subtle and light
                        Text(
                          greeting,
                          style: textTheme.headlineMedium?.copyWith(
                            color: const Color(
                              0xFFEAEAEA,
                            ).withValues(alpha: 0.8), // Alabaster
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        // User name - large and prominent with Liquid Gold
                        Text(
                          userName,
                          style: textTheme.headlineLarge?.copyWith(
                            color: const Color(0xFFFFD700), // Liquid Gold
                            fontWeight: FontWeight.w700,
                            fontSize: 40,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Integration Statement
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
                    child: _IntegrationStatementCard(
                      statement: integrationStatement,
                    ),
                  ),
                ),

                // Main featured card - Rebirth Protocol
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
                    child: _RebirthProtocolCard(
                      onTap: () => context.push('/report'),
                    ),
                  ),
                ),

                // Section title for day reviews
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 40, 24, 16),
                    child: Text(
                      'Review Your Journey',
                      style: textTheme.titleLarge?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // Day review list - elegant ListTile design
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                    child: Column(
                      children: [
                        _DayListTile(
                          dayNumber: 1,
                          onTap: () => context.push('/day/1'),
                        ),
                        const SizedBox(height: 12),
                        _DayListTile(
                          dayNumber: 2,
                          onTap: () => context.push('/day/2'),
                        ),
                        const SizedBox(height: 12),
                        _DayListTile(
                          dayNumber: 3,
                          onTap: () => context.push('/day/3'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Card widget for displaying the user's integration statement.
/// Designed to replicate the style of the header card in DayScreen.
class _IntegrationStatementCard extends StatelessWidget {
  const _IntegrationStatementCard({required this.statement});

  final String statement;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(
          Icons.format_quote,
          color: const Color(0xFF00FFFF), // Bio-Electric Cyan
          size: 28,
        ),
        title: Text(
          'Your Integration Statement',
          style: textTheme.titleSmall?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            statement,
            style: const TextStyle(
              fontFamily: 'Lora',
              fontStyle: FontStyle.italic,
              fontSize: 18,
              height: 1.7,
              color: Color(0xFFEAEAEA), // Alabaster
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}

/// Featured card for accessing the Rebirth Protocol report.
class _RebirthProtocolCard extends StatelessWidget {
  const _RebirthProtocolCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFFD700), // Liquid Gold
                Color(0xFF00FFFF), // Bio-Electric Cyan
              ],
              stops: [0.0, 1.0],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00FFFF).withValues(alpha: 0.3),
                blurRadius: 20,
                spreadRadius: 0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Large star icon
                const Icon(
                  Icons.auto_awesome,
                  size: 72,
                  color: Color(0xFF111111), // Charcoal Soul
                ),
                const SizedBox(height: 24),

                // Small "View Your" text
                Text(
                  'View Your',
                  style: textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF111111).withValues(alpha: 0.7),
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                // Large "Rebirth Protocol" text with Satoshi
                Text(
                  'Rebirth Protocol',
                  style: const TextStyle(
                    fontFamily: 'Satoshi',
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111111), // Charcoal Soul
                    letterSpacing: -0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Large arrow
                const Icon(
                  Icons.arrow_forward_rounded,
                  color: Color(0xFF111111), // Charcoal Soul
                  size: 48,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Elegant ListTile for reviewing individual day itineraries.
/// Uses a cleaner, more cohesive design with CircleAvatar for day number.
class _DayListTile extends StatelessWidget {
  const _DayListTile({required this.dayNumber, required this.onTap});

  final int dayNumber;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Card(
      elevation: 0,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: const Color(
            0xFF00FFFF,
          ).withValues(alpha: 0.3), // Bio-Electric Cyan
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        leading: CircleAvatar(
          backgroundColor: const Color(
            0xFF00FFFF,
          ).withValues(alpha: 0.2), // Bio-Electric Cyan with low opacity
          child: Text(
            '$dayNumber',
            style: textTheme.titleLarge?.copyWith(
              color: const Color(0xFF00FFFF), // Bio-Electric Cyan
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          'Review Day $dayNumber',
          style: textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: colorScheme.onSurface.withValues(alpha: 0.6),
        ),
        onTap: onTap,
      ),
    );
  }
}
