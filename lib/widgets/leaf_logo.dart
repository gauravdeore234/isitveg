import 'package:flutter/material.dart';
import '../config/theme.dart';

class LeafLogo extends StatelessWidget {
  final double size;
  final Color circleColor;
  final Color leafColor;

  const LeafLogo({
    super.key,
    this.size = 80,
    this.circleColor = AppColors.primaryContainer,
    this.leafColor = AppColors.onPrimaryContainer,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter:
            _LeafLogoPainter(circleColor: circleColor, leafColor: leafColor),
      ),
    );
  }
}

class _LeafLogoPainter extends CustomPainter {
  final Color circleColor;
  final Color leafColor;

  _LeafLogoPainter({required this.circleColor, required this.leafColor});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2;

    // Outer green circle (primary-container)
    canvas.drawCircle(Offset(cx, cy), r, Paint()..color = circleColor);

    final s = size.width;

    // White leaf body
    final stemX = cx - s * 0.03;
    final stemY = cy + s * 0.25;
    final tipX = cx + s * 0.12;
    final tipY = cy - s * 0.27;

    final leafPath = Path()
      ..moveTo(stemX, stemY)
      ..cubicTo(
        stemX - s * 0.22,
        stemY - s * 0.10,
        tipX - s * 0.28,
        tipY + s * 0.10,
        tipX,
        tipY,
      )
      ..cubicTo(
        tipX + s * 0.12,
        tipY + s * 0.10,
        stemX + s * 0.20,
        stemY - s * 0.14,
        stemX,
        stemY,
      )
      ..close();
    canvas.drawPath(leafPath, Paint()..color = leafColor);

    // Center vein, drawn in the circle colour so it reads as a cut-out
    canvas.drawLine(
      Offset(stemX, stemY),
      Offset(tipX, tipY),
      Paint()
        ..color = circleColor
        ..strokeWidth = s * 0.026
        ..strokeCap = StrokeCap.round,
    );

    // Curved stem below leaf body
    final stemPath = Path()
      ..moveTo(stemX, stemY)
      ..quadraticBezierTo(
          stemX - s * 0.06, stemY + s * 0.10, stemX, stemY + s * 0.17);
    canvas.drawPath(
      stemPath,
      Paint()
        ..color = leafColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = s * 0.042
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_LeafLogoPainter old) =>
      old.circleColor != circleColor || old.leafColor != leafColor;
}
