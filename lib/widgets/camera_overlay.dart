import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../config/theme.dart';

/// Scanner viewfinder: a 65% black scrim with a clear guide window,
/// sharp corner brackets and a pulsing green recognition line.
class CameraOverlay extends StatefulWidget {
  /// Space reserved at the bottom for the controls + nav bar, so the
  /// guide window stays optically centred in the visible canvas.
  final double bottomInset;

  const CameraOverlay({super.key, this.bottomInset = 0});

  @override
  State<CameraOverlay> createState() => _CameraOverlayState();
}

class _CameraOverlayState extends State<CameraOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scanController;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth * 0.85;
        final available = constraints.maxHeight - widget.bottomInset;
        final height = available * 0.5 > 380 ? 380.0 : available * 0.5;
        final left = (constraints.maxWidth - width) / 2;
        final top = (available - height) / 2;
        final rect = Rect.fromLTWH(left, top, width, height);

        return Stack(
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(painter: _ViewfinderPainter(rect: rect)),
              ),
            ),
            // Caption pill, sitting just above the guide window (and clear of
            // the Manual pill in the top-right corner).
            Positioned(
              left: left,
              width: width,
              top: top - 40,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    border:
                        Border.all(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  child: Text(
                    'Position ingredients label here',
                    style: AppText.bodySm(Colors.white),
                  ),
                ),
              ),
            ),
            // Pulsing recognition line
            AnimatedBuilder(
              animation: _scanController,
              builder: (context, _) {
                final t = _scanController.value;
                final y = top + height * (0.05 + 0.90 * t);
                final opacity = t < 0.1
                    ? t / 0.1
                    : t > 0.9
                        ? (1 - t) / 0.1
                        : 1.0;
                return Positioned(
                  left: left,
                  width: width,
                  top: y,
                  child: IgnorePointer(
                    child: Opacity(
                      opacity: opacity.clamp(0.0, 1.0),
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          color: AppColors.primaryFixed,
                          borderRadius: BorderRadius.circular(AppRadius.full),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  AppColors.primaryFixed.withValues(alpha: 0.6),
                              blurRadius: 15,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class _ViewfinderPainter extends CustomPainter {
  final Rect rect;

  _ViewfinderPainter({required this.rect});

  @override
  void paint(Canvas canvas, Size size) {
    // Scrim with the guide window knocked out
    final scrim = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(4)))
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(
        scrim, Paint()..color = Colors.black.withValues(alpha: 0.65));

    // Corner brackets: 32px arms, 4px stroke
    final bracket = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    const arm = 32.0;
    void corner(Offset origin, double dx, double dy) {
      canvas.drawLine(origin, origin.translate(arm * dx, 0), bracket);
      canvas.drawLine(origin, origin.translate(0, arm * dy), bracket);
    }

    corner(rect.topLeft, 1, 1);
    corner(rect.topRight, -1, 1);
    corner(rect.bottomLeft, 1, -1);
    corner(rect.bottomRight, -1, -1);
  }

  @override
  bool shouldRepaint(covariant _ViewfinderPainter old) => old.rect != rect;
}

class CameraViewport extends StatelessWidget {
  final CameraController controller;

  const CameraViewport({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return const SizedBox.shrink();
    }

    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        width: controller.value.previewSize!.height,
        height: controller.value.previewSize!.width,
        child: controller.buildPreview(),
      ),
    );
  }
}
