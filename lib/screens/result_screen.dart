import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../models/scan_result.dart';
import '../services/history_service.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/verdict_badge.dart';
import '../widgets/flagged_ingredient_card.dart';
import 'manual_entry_screen.dart';

class ResultScreen extends StatefulWidget {
  final ScanResult result;

  /// False when the screen is reopened from history, so revisiting a past
  /// scan does not write a duplicate row.
  final bool saveToHistory;

  const ResultScreen({
    super.key,
    required this.result,
    this.saveToHistory = true,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _springAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _springAnim =
        CurvedAnimation(parent: _animController, curve: Curves.elasticOut);
    _animController.forward();
    if (widget.saveToHistory) {
      HistoryService().saveScan(widget.result.toMap());
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _editText() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ManualEntryScreen(initialText: widget.result.rawText),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final result = widget.result;
    final palette = context.palette;

    return Scaffold(
      appBar: AppTopBar.back(context),
      body: AppContentCanvas(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ScaleTransition(
                scale: _springAnim,
                child: VerdictBadge(
                  verdict: result.verdict,
                  categoryChips: result.categoryChips,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              _FadeInUp(
                controller: _animController,
                delay: 0.2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Flagged Ingredients',
                      style: AppText.titleLg(palette.onSurface),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    if (result.flaggedIngredients.isEmpty)
                      const _EmptyFlaggedCard()
                    else
                      for (final flagged in result.flaggedIngredients)
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: FlaggedIngredientCard(flagged: flagged),
                        ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              _FadeInUp(
                controller: _animController,
                delay: 0.3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            'Extracted Text',
                            overflow: TextOverflow.ellipsis,
                            style: AppText.titleLg(palette.onSurface),
                          ),
                        ),
                        InkWell(
                          onTap: _editText,
                          borderRadius: BorderRadius.circular(AppRadius.xs),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.xs,
                              vertical: AppSpacing.xs,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.edit_outlined,
                                    size: 16, color: palette.primary),
                                const SizedBox(width: AppSpacing.xs),
                                Text('Edit',
                                    style: AppText.bodySm(palette.primary)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _ExtractedTextCard(text: result.rawText),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              _FadeInUp(
                controller: _animController,
                delay: 0.4,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.document_scanner_outlined, size: 22),
                  label: const Text('Scan Another'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyFlaggedCard extends StatelessWidget {
  const _EmptyFlaggedCard();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xl,
      ),
      decoration: BoxDecoration(
        color: palette.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: palette.outlineVariant),
      ),
      child: Column(
        children: [
          Icon(Icons.verified_outlined, size: 24, color: palette.outline),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'No restricted ingredients found.',
            style: AppText.bodySm(palette.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

/// Scrollable OCR output, capped at 300px with a fade at the bottom edge
/// so it reads as "more below".
class _ExtractedTextCard extends StatelessWidget {
  final String text;
  const _ExtractedTextCard({required this.text});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Container(
      decoration: BoxDecoration(
        color: palette.surfaceContainer,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: palette.outlineVariant),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Stack(
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 300),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: SelectableText(
                  text.isEmpty ? 'No text extracted.' : text,
                  style: AppText.bodySm(palette.onSurfaceVariant)
                      .copyWith(height: 1.6),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 32,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        palette.surfaceContainer,
                        palette.surfaceContainer.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Staggered "fade-in-up" entrance used by the result sections.
class _FadeInUp extends StatelessWidget {
  final AnimationController controller;
  final double delay;
  final Widget child;

  const _FadeInUp({
    required this.controller,
    required this.delay,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final animation = CurvedAnimation(
      parent: controller,
      curve:
          Interval(delay, (delay + 0.5).clamp(0.0, 1.0), curve: Curves.easeOut),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) => Opacity(
        opacity: animation.value,
        child: Transform.translate(
          offset: Offset(0, 16 * (1 - animation.value)),
          child: child,
        ),
      ),
      child: child,
    );
  }
}
