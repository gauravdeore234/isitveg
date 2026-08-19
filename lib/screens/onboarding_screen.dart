import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../widgets/leaf_logo.dart';
import 'home_shell.dart';

class OnboardingScreen extends StatelessWidget {
  final VoidCallback? onComplete;
  const OnboardingScreen({super.key, this.onComplete});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.containerMargin,
                AppSpacing.xl,
                AppSpacing.containerMargin,
                AppSpacing.lg,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: AppSpacing.lg),
                          // Logo — 160px primary-container disc
                          Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.12),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: const LeafLogo(size: 160),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          Text(
                            'IsItVeg',
                            style: AppText.displayLgMobile(palette.primary),
                          ),
                          const SizedBox(height: AppSpacing.base),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 280),
                            child: Text(
                              'Know what you eat. No internet needed.',
                              textAlign: TextAlign.center,
                              style: AppText.bodyLg(palette.onSurfaceVariant),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          const _FeatureRow(
                            icon: Icons.photo_camera_outlined,
                            title: 'Camera',
                            subtitle:
                                'Scan ingredient lists directly from packaging.',
                          ),
                          const SizedBox(height: AppSpacing.md),
                          const _FeatureRow(
                            icon: Icons.check_circle_outline,
                            title: 'Instantly Know',
                            subtitle:
                                'Quickly see if the food is vegetarian or vegan safe.',
                          ),
                          const SizedBox(height: AppSpacing.md),
                          const _FeatureRow(
                            icon: Icons.wifi_off_outlined,
                            title: 'Works Offline',
                            subtitle:
                                'Analyze ingredients completely without Wi-Fi or data.',
                          ),
                          const SizedBox(height: AppSpacing.lg),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        textStyle: AppText.titleLg(AppColors.onPrimary),
                      ),
                      onPressed: () {
                        onComplete?.call();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const HomeShell()),
                        );
                      },
                      child: const Text('Get Started'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FeatureRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: palette.surfaceContainerHigh,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 24, color: palette.primary),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppText.titleLg(palette.onSurface)),
              const SizedBox(height: AppSpacing.xs),
              Text(
                subtitle,
                style: AppText.bodySm(palette.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
