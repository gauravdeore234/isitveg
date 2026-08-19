import 'package:flutter/material.dart';
import '../config/theme.dart';

/// App-level information surfaces, shared by the Settings page and the
/// top app bar's menu / about buttons.

void showAppMenu(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    builder: (sheetContext) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _SheetHandle(),
          _MenuTile(
            icon: Icons.eco_outlined,
            label: 'How it works',
            onTap: () {
              Navigator.pop(sheetContext);
              showHowItWorks(context);
            },
          ),
          _MenuTile(
            icon: Icons.lock_outline,
            label: 'Privacy',
            onTap: () {
              Navigator.pop(sheetContext);
              showPrivacy(context);
            },
          ),
          _MenuTile(
            icon: Icons.info_outline,
            label: 'About IsItVeg',
            onTap: () {
              Navigator.pop(sheetContext);
              showAboutApp(context);
            },
          ),
          const SizedBox(height: AppSpacing.base),
        ],
      ),
    ),
  );
}

void showHowItWorks(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => const HowItWorksSheet(),
  );
}

void showPrivacy(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Privacy'),
      content: const Text(
        'IsItVeg runs entirely on your device. Photos, extracted text and scan '
        'history never leave your phone, and the app makes no network requests '
        'except when you download an optional language pack.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}

void showAboutApp(BuildContext context) {
  final palette = context.palette;

  showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: palette.surfaceContainerHigh,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.eco, color: palette.primary),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'IsItVeg Scanner',
            style: AppText.titleLg(palette.onSurface),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Know what you eat. No internet needed.',
            textAlign: TextAlign.center,
            style: AppText.bodySm(palette.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.base),
          Text(
            'Version 1.0.0 (Build 1)',
            style: AppText.labelCaps(palette.outline),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: context.palette.outlineVariant,
          borderRadius: BorderRadius.circular(AppRadius.xs),
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return ListTile(
      leading: Icon(icon, color: palette.primary),
      title: Text(label, style: AppText.bodyLg(palette.onSurface)),
      onTap: onTap,
    );
  }
}

class HowItWorksSheet extends StatelessWidget {
  const HowItWorksSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      builder: (_, scrollController) => SingleChildScrollView(
        controller: scrollController,
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(child: _SheetHandle()),
            const SizedBox(height: AppSpacing.md),
            Text('How IsItVeg Works',
                style: AppText.titleLg(palette.onSurface)),
            const SizedBox(height: AppSpacing.lg),
            const _Step(
              number: '1',
              title: 'Point & Scan',
              body:
                  'Aim your camera at the ingredient list on the back of any packaged food.',
            ),
            const _Step(
              number: '2',
              title: 'On-Device OCR',
              body:
                  'Google ML Kit reads the text directly on your phone — no internet needed.',
            ),
            const _Step(
              number: '3',
              title: 'Ingredient Matching',
              body:
                  'Over 200 non-vegetarian ingredients (including hidden ones like E120, gelatin, isinglass) are checked.',
            ),
            const _Step(
              number: '4',
              title: 'Instant Verdict',
              body:
                  'You see whether the product is Vegetarian, Non-Vegetarian, or Uncertain.',
            ),
            Text(
              'Note: "Uncertain" means some ingredients like "natural flavoring" or '
              'E471 could be from animal or plant sources — the packaging doesn\'t '
              'specify. When in doubt, avoid.',
              style: AppText.bodySm(palette.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _Step extends StatelessWidget {
  final String number;
  final String title;
  final String body;

  const _Step({required this.number, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: palette.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Text(
              number,
              style: AppText.labelCaps(palette.onPrimaryContainer),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppText.bodyLg(palette.onSurface)
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(body, style: AppText.bodySm(palette.onSurfaceVariant)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
