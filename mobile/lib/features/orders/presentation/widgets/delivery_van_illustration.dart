import 'package:flutter/material.dart';

class DeliveryVanIllustration extends StatelessWidget {
  final double size;

  const DeliveryVanIllustration({
    super.key,
    this.size = 80,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFE0F2FE),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFBAE6FD), width: 1.5),
      ),
      child: Center(
        child: SizedBox(
          width: size * 0.72,
          height: size * 0.52,
          child: CustomPaint(
            painter: _DeliveryVanPainter(),
          ),
        ),
      ),
    );
  }
}

class _DeliveryVanPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Subtle ground shadow
    final shadowPaint = Paint()
      ..color = const Color(0x1A0F172A)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.5, h * 0.94),
        width: w * 0.85,
        height: h * 0.16,
      ),
      shadowPaint,
    );

    // Van Body (Cargo Box)
    final vanBodyPaint = Paint()..color = const Color(0xFF2563EB);
    final cargoRect = RRect.fromRectAndCorners(
      Rect.fromLTWH(0, h * 0.1, w * 0.68, h * 0.7),
      topLeft: const Radius.circular(6),
      bottomLeft: const Radius.circular(4),
    );
    canvas.drawRRect(cargoRect, vanBodyPaint);

    // Van Cabin / Front
    final cabinPath = Path()
      ..moveTo(w * 0.66, h * 0.1)
      ..lineTo(w * 0.86, h * 0.32)
      ..quadraticBezierTo(w * 0.98, h * 0.44, w * 0.98, h * 0.58)
      ..lineTo(w * 0.98, h * 0.8)
      ..lineTo(w * 0.66, h * 0.8)
      ..close();
    canvas.drawPath(cabinPath, vanBodyPaint);

    // Windshield
    final windshieldPaint = Paint()..color = const Color(0xFF93C5FD);
    final windshieldPath = Path()
      ..moveTo(w * 0.68, h * 0.16)
      ..lineTo(w * 0.84, h * 0.34)
      ..lineTo(w * 0.84, h * 0.48)
      ..lineTo(w * 0.68, h * 0.48)
      ..close();
    canvas.drawPath(windshieldPath, windshieldPaint);

    // Door line
    final linePaint = Paint()
      ..color = const Color(0xFF1D4ED8)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(w * 0.68, h * 0.1), Offset(w * 0.68, h * 0.8), linePaint);

    // "Grozzby" Text on Cargo Side
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'Grozzby',
        style: TextStyle(
          color: Colors.white,
          fontSize: 8.5,
          fontWeight: FontWeight.w900,
          fontFamily: 'Inter',
          letterSpacing: 0.2,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(w * 0.08, h * 0.32));

    // Wheels (Rear and Front)
    void drawWheel(double cx, double cy) {
      final wheelRadius = h * 0.19;
      // Tire (Black)
      final tirePaint = Paint()..color = const Color(0xFF0F172A);
      canvas.drawCircle(Offset(cx, cy), wheelRadius, tirePaint);

      // Rim (White)
      final rimPaint = Paint()..color = Colors.white;
      canvas.drawCircle(Offset(cx, cy), wheelRadius * 0.55, rimPaint);

      // Hub (Blue)
      final hubPaint = Paint()..color = const Color(0xFF2563EB);
      canvas.drawCircle(Offset(cx, cy), wheelRadius * 0.25, hubPaint);
    }

    drawWheel(w * 0.2, h * 0.82);
    drawWheel(w * 0.78, h * 0.82);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
