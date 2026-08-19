import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../models/scan_result.dart';

/// Full-width result card whose fill encodes the verdict, per the design
/// system's colour-coded feedback language.
class VerdictBadge extends StatelessWidget {
  final Verdict verdict;
  final List<({String emoji, String label})> categoryChips;

  const VerdictBadge({
    super.key,
    required this.verdict,
    this.categoryChips = const [],
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final (bg, fg, icon) = switch (verdict) {
      Verdict.vegetarian => (
          palette.primaryContainer,
          palette.onPrimaryContainer,
          Icons.check_circle,
        ),
      Verdict.nonVegetarian => (
          palette.error,
          palette.onError,
          Icons.cancel,
        ),
      Verdict.uncertain => (
          palette.uncertain,
          palette.onSurface,
          Icons.help,
        ),
    };

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: CustomPaint(
        painter: _DotGridPainter(color: fg.withValues(alpha: 0.10)),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.lg),
          color: bg,
          child: Column(
            children: [
              Icon(icon, size: 64, color: fg),
              const SizedBox(height: AppSpacing.base),
              Text(verdict.label, style: AppText.displayLgMobile(fg)),
              const SizedBox(height: AppSpacing.xs),
              Text(
                verdict.summary,
                textAlign: TextAlign.center,
                style: AppText.bodyLg(fg.withValues(alpha: 0.9)),
              ),
              if (categoryChips.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.base,
                  alignment: WrapAlignment.center,
                  children: [
                    for (final chip in categoryChips)
                      _CategoryPill(
                        emoji: chip.emoji,
                        label: chip.label,
                        color: fg,
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryPill extends StatelessWidget {
  final String emoji;
  final String label;
  final Color color;

  const _CategoryPill({
    required this.emoji,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs + 2,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: AppSpacing.xs),
          Text(label, style: AppText.labelCaps(color)),
        ],
      ),
    );
  }
}

/// The subtle 16px dot grid layered over verdict cards.
class _DotGridPainter extends CustomPainter {
  final Color color;
  const _DotGridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    const step = 16.0;
    for (var y = 2.0; y < size.height; y += step) {
      for (var x = 2.0; x < size.width; x += step) {
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DotGridPainter old) => old.color != color;
}
