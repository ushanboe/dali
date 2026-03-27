import 'package:flutter/material.dart';
import '../models/avatar_config.dart';

/// Paints the base human figure: head, neck, shoulders, torso, arms, legs.
/// All coordinates are normalised to a 1.0 × 1.0 space.
class BodyPainter extends CustomPainter {
  final AvatarConfig config;

  BodyPainter(this.config);

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    Offset s(double x, double y) => Offset(x * w, y * h);
    double sw(double x) => x * w;
    double sh(double y) => y * h;

    final skinPaint = Paint()..color = config.skinTone;
    final skinDark = Paint()..color = _darken(config.skinTone, 0.12);
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    // --- Legs ---
    final legPaint = Paint()..color = const Color(0xFF3A5A8A);
    _roundedRect(canvas, s(0.34, 0.72), sw(0.13), sh(0.24), sw(0.065), legPaint);
    _roundedRect(canvas, s(0.53, 0.72), sw(0.13), sh(0.24), sw(0.065), legPaint);

    // Leg shading
    final legShade = Paint()..color = const Color(0xFF2C4A7A);
    _roundedRect(canvas, s(0.43, 0.72), sw(0.04), sh(0.24), sw(0.02), legShade);

    // --- Torso shadow ---
    canvas.drawOval(
      Rect.fromCenter(center: s(0.50, 0.65), width: sw(0.42), height: sh(0.06)),
      shadowPaint,
    );

    // --- Torso ---
    final torsoPath = Path();
    torsoPath.moveTo(s(0.28, 0.72).dx, s(0.28, 0.72).dy);
    torsoPath.quadraticBezierTo(sw(0.28), sh(0.44), sw(0.38), sh(0.44));
    torsoPath.lineTo(sw(0.62), sh(0.44));
    torsoPath.quadraticBezierTo(sw(0.72), sh(0.44), sw(0.72), sh(0.72));
    torsoPath.close();
    canvas.drawPath(torsoPath, skinPaint);

    // --- Arms ---
    final armL = Path();
    armL.moveTo(sw(0.30), sh(0.46));
    armL.quadraticBezierTo(sw(0.12), sh(0.52), sw(0.16), sh(0.70));
    armL.quadraticBezierTo(sw(0.20), sh(0.72), sw(0.26), sh(0.68));
    armL.quadraticBezierTo(sw(0.26), sh(0.54), sw(0.38), sh(0.50));
    armL.close();
    canvas.drawPath(armL, skinPaint);
    canvas.drawPath(armL, skinDark..style = PaintingStyle.stroke..strokeWidth = sw(0.005));

    final armR = Path();
    armR.moveTo(sw(0.70), sh(0.46));
    armR.quadraticBezierTo(sw(0.88), sh(0.52), sw(0.84), sh(0.70));
    armR.quadraticBezierTo(sw(0.80), sh(0.72), sw(0.74), sh(0.68));
    armR.quadraticBezierTo(sw(0.74), sh(0.54), sw(0.62), sh(0.50));
    armR.close();
    canvas.drawPath(armR, skinPaint);

    // Torso shading
    final torsoBright = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withOpacity(0.15),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(sw(0.28), sh(0.44), sw(0.44), sh(0.28)));
    canvas.drawPath(torsoPath, torsoBright);

    // --- Neck ---
    final neckRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(sw(0.44), sh(0.36), sw(0.12), sh(0.10)),
      Radius.circular(sw(0.06)),
    );
    canvas.drawRRect(neckRect, skinPaint);

    // --- Head shadow ---
    canvas.drawOval(
      Rect.fromCenter(center: s(0.50, 0.235), width: sw(0.40), height: sh(0.40)),
      shadowPaint,
    );

    // --- Head ---
    final headPath = Path();
    headPath.addOval(
      Rect.fromCenter(center: s(0.50, 0.22), width: sw(0.38), height: sh(0.36)),
    );
    canvas.drawPath(headPath, skinPaint);

    // Head highlight
    final headHighlight = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.3, -0.4),
        radius: 0.6,
        colors: [
          Colors.white.withOpacity(0.18),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCenter(center: s(0.50, 0.22), width: sw(0.38), height: sh(0.36)),
      );
    canvas.drawPath(headPath, headHighlight);

    // Ear left
    canvas.drawOval(
      Rect.fromCenter(center: s(0.315, 0.225), width: sw(0.06), height: sh(0.08)),
      skinPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: s(0.685, 0.225), width: sw(0.06), height: sh(0.08)),
      skinPaint,
    );

    // Inner ear
    final innerEar = Paint()..color = _darken(config.skinTone, 0.08);
    canvas.drawOval(
      Rect.fromCenter(center: s(0.318, 0.228), width: sw(0.03), height: sh(0.04)),
      innerEar,
    );
    canvas.drawOval(
      Rect.fromCenter(center: s(0.682, 0.228), width: sw(0.03), height: sh(0.04)),
      innerEar,
    );
  }

  void _roundedRect(Canvas canvas, Offset topLeft, double width, double height, double radius, Paint paint) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(topLeft.dx, topLeft.dy, width, height),
        Radius.circular(radius),
      ),
      paint,
    );
  }

  Color _darken(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
  }

  @override
  bool shouldRepaint(BodyPainter oldDelegate) =>
      oldDelegate.config.skinTone != config.skinTone ||
      oldDelegate.config.clothing != config.clothing;
}
