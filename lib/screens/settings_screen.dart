import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../data/language_packs.dart';
import '../widgets/app_info.dart';
import '../widgets/app_top_bar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // In a real app, download state is persisted in SharedPreferences
  final Set<String> _downloadedPacks = {'latin'};
  final Map<String, double> _downloading = {};

  void _togglePack(LanguagePack pack) {
    if (pack.isBundled) return;

    if (_downloading.containsKey(pack.id)) {
      setState(() => _downloading.remove(pack.id));
    } else if (_downloadedPacks.contains(pack.id)) {
      _deletePack(pack);
    } else {
      _downloadPack(pack);
    }
  }

  Future<void> _downloadPack(LanguagePack pack) async {
    setState(() => _downloading[pack.id] = 0.0);

    // Simulate download progress; replace with actual ML Kit model manager
    for (var i = 1; i <= 20; i++) {
      await Future.delayed(const Duration(milliseconds: 120));
      if (!mounted || !_downloading.containsKey(pack.id)) return;
      setState(() => _downloading[pack.id] = i / 20);
    }

    if (mounted) {
      setState(() {
        _downloadedPacks.add(pack.id);
        _downloading.remove(pack.id);
      });
    }
  }

  void _deletePack(LanguagePack pack) {
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Remove ${pack.name}?'),
        content:
            const Text('You can re-download it anytime you have internet.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: context.palette.error),
            child: const Text('Remove'),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true && mounted) {
        setState(() => _downloadedPacks.remove(pack.id));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final regions = availableLanguagePacks.map((p) => p.region).toSet();

    return Scaffold(
      appBar: AppTopBar(
        leading: AppBarIconButton(
          icon: Icons.menu,
          tooltip: 'Menu',
          onPressed: () => showAppMenu(context),
        ),
        actions: [
          AppBarIconButton(
            icon: Icons.account_circle_outlined,
            tooltip: 'About IsItVeg',
            onPressed: () => showAboutApp(context),
          ),
        ],
      ),
      body: AppContentCanvas(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
          ),
          children: [
            Text('Language Packs', style: AppText.titleLg(palette.onSurface)),
            const SizedBox(height: AppSpacing.sm),
            const _InfoBanner(
              text:
                  'Download languages before you travel to ensure offline scanning '
                  'works when you don\'t have an internet connection.',
            ),
            const SizedBox(height: AppSpacing.lg),
            for (final region in regions) ...[
              _RegionHeader(label: region),
              const SizedBox(height: AppSpacing.sm),
              for (final pack
                  in availableLanguagePacks.where((p) => p.region == region))
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _LanguagePackCard(
                    pack: pack,
                    isInstalled:
                        pack.isBundled || _downloadedPacks.contains(pack.id),
                    progress: _downloading[pack.id],
                    onAction: () => _togglePack(pack),
                  ),
                ),
              const SizedBox(height: AppSpacing.sm),
            ],
            const SizedBox(height: AppSpacing.base),
            const _AboutSection(),
          ],
        ),
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  final String text;
  const _InfoBanner({required this.text});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: palette.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border:
            Border.all(color: palette.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: Icon(Icons.info, size: 20, color: palette.primary),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(text, style: AppText.bodySm(palette.onSurfaceVariant)),
          ),
        ],
      ),
    );
  }
}

class _RegionHeader extends StatelessWidget {
  final String label;
  const _RegionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      padding: const EdgeInsets.only(left: AppSpacing.base),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: palette.primary, width: 2),
        ),
      ),
      child: Text(
        label.toUpperCase(),
        style: AppText.labelCaps(palette.outline).copyWith(letterSpacing: 1.0),
      ),
    );
  }
}

class _LanguagePackCard extends StatelessWidget {
  final LanguagePack pack;
  final bool isInstalled;
  final double? progress;
  final VoidCallback onAction;

  const _LanguagePackCard({
    required this.pack,
    required this.isInstalled,
    required this.progress,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isDownloading = progress != null;

    final sizeLabel =
        pack.estimatedSizeMb == 0 ? 'Bundled' : '${pack.estimatedSizeMb} MB';

    return Container(
      decoration: BoxDecoration(
        color: palette.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isDownloading
              ? palette.primary.withValues(alpha: 0.3)
              : palette.outlineVariant,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Stack(
          children: [
            // Download progress wash
            if (isDownloading)
              Positioned.fill(
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progress,
                  child: ColoredBox(
                    color: palette.primary.withValues(alpha: 0.08),
                  ),
                ),
              ),
            // Installed accent rail
            if (isInstalled && !isDownloading)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: 4,
                child: ColoredBox(
                  color: palette.primary.withValues(alpha: 0.2),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                pack.name,
                                overflow: TextOverflow.ellipsis,
                                style: AppText.titleLg(palette.onSurface),
                              ),
                            ),
                            if (isInstalled && !isDownloading) ...[
                              const SizedBox(width: AppSpacing.base),
                              const _InstalledChip(),
                            ],
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          pack.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.bodySm(palette.onSurfaceVariant),
                        ),
                        const SizedBox(height: AppSpacing.base),
                        if (isDownloading)
                          Wrap(
                            spacing: AppSpacing.base,
                            children: [
                              Text(
                                'Downloading… ${(progress! * 100).round()}%',
                                style: AppText.labelCaps(palette.primary),
                              ),
                              Text('•',
                                  style: AppText.labelCaps(palette.outline)),
                              Text(sizeLabel,
                                  style: AppText.labelCaps(palette.outline)),
                            ],
                          )
                        else
                          Text(sizeLabel,
                              style: AppText.labelCaps(palette.outline)),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  _PackActionButton(
                    isBundled: pack.isBundled,
                    isInstalled: isInstalled,
                    isDownloading: isDownloading,
                    onTap: onAction,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InstalledChip extends StatelessWidget {
  const _InstalledChip();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: palette.primaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, size: 12, color: palette.onPrimaryContainer),
          const SizedBox(width: AppSpacing.xs),
          Text(
            'Installed',
            style: AppText.labelCaps(palette.onPrimaryContainer)
                .copyWith(fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _PackActionButton extends StatelessWidget {
  final bool isBundled;
  final bool isInstalled;
  final bool isDownloading;
  final VoidCallback onTap;

  const _PackActionButton({
    required this.isBundled,
    required this.isInstalled,
    required this.isDownloading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    if (isBundled) return const SizedBox(width: 0);

    final (icon, background, foreground, border) = isDownloading
        ? (
            Icons.close,
            palette.surfaceContainer,
            palette.onSurface,
            null,
          )
        : isInstalled
            ? (
                Icons.delete_outline,
                palette.surfaceContainer,
                palette.onSurface,
                null,
              )
            : (
                Icons.download,
                palette.surfaceContainerHigh,
                palette.primary,
                palette.outlineVariant.withValues(alpha: 0.5),
              );

    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: background,
          shape: BoxShape.circle,
          border: border == null ? null : Border.all(color: border),
        ),
        child: Icon(icon, size: 20, color: foreground),
      ),
    );
  }
}

class _AboutSection extends StatelessWidget {
  const _AboutSection();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.xl),
      padding: const EdgeInsets.only(top: AppSpacing.lg),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: palette.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
      ),
      child: Opacity(
        opacity: 0.85,
        child: Column(
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
            const SizedBox(height: AppSpacing.base),
            Text(
              'IsItVeg Scanner',
              style: AppText.bodySm(palette.onSurface)
                  .copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Version 1.0.0 (Build 1)',
              style: AppText.bodySm(palette.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _AboutLink(
                  label: 'How it works',
                  onTap: () => showHowItWorks(context),
                ),
                const SizedBox(width: AppSpacing.md),
                _AboutLink(
                  label: 'Privacy',
                  onTap: () => showPrivacy(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AboutLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _AboutLink({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return InkWell(
      onTap: onTap,
      child: Text(
        label,
        style: AppText.bodySm(palette.primary).copyWith(
          decoration: TextDecoration.underline,
          decorationColor: palette.primary,
        ),
      ),
    );
  }
}
