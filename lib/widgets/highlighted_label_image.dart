import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../models/ingredient.dart';

/// The scanned label photo with a coloured rectangle drawn around each flagged
/// ingredient's words, so the user can eyeball the verdict against the image.
///
/// Boxes come from ML Kit in image-pixel coordinates; we lay the image out at
/// its natural aspect ratio and scale the boxes by the rendered width.
class HighlightedLabelImage extends StatelessWidget {
  final String imagePath;
  final ui.Size? imageSize;
  final List<FlaggedIngredient> flagged;

  const HighlightedLabelImage({
    super.key,
    required this.imagePath,
    required this.imageSize,
    required this.flagged,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final size = imageSize;

    final image = Image.file(
      File(imagePath),
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
    );

    // Without pixel dimensions (e.g. a reopened history scan) we can't place
    // boxes, so just show the photo.
    if (size == null || size.width <= 0 || size.height <= 0) {
      return _framed(palette, image);
    }

    return _framed(
      palette,
      AspectRatio(
        aspectRatio: size.width / size.height,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final scale = constraints.maxWidth / size.width;
            return Stack(
              fit: StackFit.expand,
              children: [
                image,
                CustomPaint(
                  painter: _BoxPainter(
                    flagged: flagged,
                    scale: scale,
                    definiteColor: palette.error,
                    possibleColor: palette.uncertain,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _framed(AppPalette palette, Widget child) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: palette.surfaceContainer,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: palette.outlineVariant),
      ),
      child: child,
    );
  }
}

class _BoxPainter extends CustomPainter {
  final List<FlaggedIngredient> flagged;
  final double scale;
  final Color definiteColor;
  final Color possibleColor;

  _BoxPainter({
    required this.flagged,
    required this.scale,
    required this.definiteColor,
    required this.possibleColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final f in flagged) {
      final isDefinite = f.ingredient.severity == IngredientSeverity.definite;
      final color = isDefinite ? definiteColor : possibleColor;
      final stroke = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..color = color;
      final fill = Paint()..color = color.withValues(alpha: 0.15);

      for (final box in f.boxes) {
        final rect = RRect.fromRectAndRadius(
          Rect.fromLTRB(
            box.left * scale,
            box.top * scale,
            box.right * scale,
            box.bottom * scale,
          ).inflate(3),
          const Radius.circular(4),
        );
        canvas.drawRRect(rect, fill);
        canvas.drawRRect(rect, stroke);
      }
    }
  }

  @override
  bool shouldRepaint(_BoxPainter old) =>
      old.flagged != flagged || old.scale != scale;
}
