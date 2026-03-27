import 'package:flutter/material.dart';
import '../models/avatar_config.dart';

/// Paints facial features: eyes, eyebrows, nose, mouth, blush.
class FacePainter extends CustomPainter {
  final AvatarConfig config;

  FacePainter(this.config);

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    Offset s(double x, double y) => Offset(x * w, y * h);
    double sw(double x) => x * w;
    double sh(double y) => y * h;

    final face = config.face;
    final eyePaint = Paint()..color = face.eyeColor;
    final whitePaint = Paint()..color = Colors.white;
    final browPaint = Paint()
      ..color = _darken(config.hair.color, 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = sw(0.022)
      ..strokeCap = StrokeCap.round;
    final skinDark = Paint()..color = _darken(config.skinTone, 0.10);

    // ── Eyebrows ──────────────────────────────────────────────────────────
    _drawEyebrow(canvas, s, sw, sh, browPaint, face.expression, isLeft: true);
    _drawEyebrow(canvas, s, sw, sh, browPaint, face.expression, isLeft: false);

    // ── Eyes ──────────────────────────────────────────────────────────────
    _drawEye(canvas, s, sw, sh, eyePaint, whitePaint, face.eyeShape, isLeft: true);
    _drawEye(canvas, s, sw, sh, eyePaint, whitePaint, face.eyeShape, isLeft: false);

    // ── Nose ──────────────────────────────────────────────────────────────
    _drawNose(canvas, s, sw, sh, skinDark);

    // ── Mouth ─────────────────────────────────────────────────────────────
    _drawMouth(canvas, s, sw, sh, face.expression, config.skinTone);

    // ── Blush ─────────────────────────────────────────────────────────────
    if (face.blush) {
      final blushPaint = Paint()..color = const Color(0xFFFF9999).withOpacity(0.40);
      canvas.drawOval(
        Rect.fromCenter(center: s(0.37, 0.27), width: sw(0.09), height: sh(0.04)),
        blushPaint,
      );
      canvas.drawOval(
        Rect.fromCenter(center: s(0.63, 0.27), width: sw(0.09), height: sh(0.04)),
        blushPaint,
      );
    }
  }

  // ── Eyebrows ──────────────────────────────────────────────────────────────
  void _drawEyebrow(Canvas canvas, Offset Function(double, double) s,
      double Function(double) sw, double Function(double) sh,
      Paint brow, FaceExpression expr, {required bool isLeft}) {
    final cx = isLeft ? 0.40 : 0.60;
    final dir = isLeft ? 1.0 : -1.0;

    switch (expr) {
      case FaceExpression.neutral:
        canvas.drawLine(s(cx - 0.05 * dir, 0.175), s(cx + 0.05 * dir, 0.175), brow);
      case FaceExpression.happy:
        canvas.drawArc(
          Rect.fromCenter(center: s(cx, 0.20), width: sw(0.10), height: sh(0.04)),
          -2.8, 1.4, false, brow,
        );
      case FaceExpression.excited:
        canvas.drawArc(
          Rect.fromCenter(center: s(cx, 0.19), width: sw(0.11), height: sh(0.05)),
          -2.9, 1.6, false, brow,
        );
      case FaceExpression.sad:
        canvas.drawArc(
          Rect.fromCenter(center: s(cx, 0.15), width: sw(0.10), height: sh(0.04)),
          isLeft ? -1.2 : -2.0, 1.4, false, brow,
        );
      case FaceExpression.surprised:
        canvas.drawArc(
          Rect.fromCenter(center: s(cx, 0.17), width: sw(0.10), height: sh(0.06)),
          -2.8, 1.6, false, brow,
        );
      case FaceExpression.thinking:
        if (isLeft) {
          canvas.drawArc(
            Rect.fromCenter(center: s(cx, 0.175), width: sw(0.10), height: sh(0.04)),
            -2.8, 1.4, false, brow,
          );
        } else {
          // One raised eyebrow
          canvas.drawArc(
            Rect.fromCenter(center: s(cx, 0.155), width: sw(0.10), height: sh(0.06)),
            -2.8, 1.4, false, brow,
          );
        }
    }
  }

  // ── Eyes ──────────────────────────────────────────────────────────────────
  void _drawEye(Canvas canvas, Offset Function(double, double) s,
      double Function(double) sw, double Function(double) sh,
      Paint eyePaint, Paint whitePaint, EyeShape shape, {required bool isLeft}) {
    final cx = isLeft ? 0.40 : 0.60;

    double eyeW = sw(0.09);
    double eyeH = sh(0.05);

    switch (shape) {
      case EyeShape.round:
        eyeW = sw(0.09); eyeH = sh(0.06);
      case EyeShape.almond:
        eyeW = sw(0.10); eyeH = sh(0.045);
      case EyeShape.wide:
        eyeW = sw(0.11); eyeH = sh(0.07);
      case EyeShape.narrow:
        eyeW = sw(0.09); eyeH = sh(0.032);
      case EyeShape.bright:
        eyeW = sw(0.10); eyeH = sh(0.065);
      case EyeShape.sleepy:
        eyeW = sw(0.09); eyeH = sh(0.035);
    }

    final eyeRect = Rect.fromCenter(center: s(cx, 0.235), width: eyeW, height: eyeH);

    // White of eye
    canvas.drawOval(eyeRect, whitePaint);

    // Iris
    final irisSize = eyeW * 0.55;
    canvas.drawCircle(s(cx, 0.237), irisSize / 2, eyePaint);

    // Pupil
    canvas.drawCircle(
      s(cx + 0.005, 0.239),
      irisSize / 3.5,
      Paint()..color = Colors.black.withOpacity(0.85),
    );

    // Eye shine
    canvas.drawCircle(
      s(cx - 0.012, 0.228),
      irisSize / 7,
      Paint()..color = Colors.white.withOpacity(0.90),
    );

    // Eyelid / top lash line
    final lashPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = sw(0.015)
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(eyeRect, -3.14, 3.14, false, lashPaint);

    // Lower lash line (lighter)
    canvas.drawArc(
      eyeRect.deflate(eyeH * 0.1),
      0, 3.14, false,
      lashPaint..color = Colors.black38..strokeWidth = sw(0.008),
    );

    // Sleepy half-lid
    if (shape == EyeShape.sleepy) {
      final lidPaint = Paint()..color = _darken(const Color(0xFFF5C5A3), 0.08);
      canvas.drawArc(
        Rect.fromCenter(center: s(cx, 0.230), width: eyeW, height: eyeH * 0.6),
        -3.14, 3.14, false, lidPaint,
      );
    }
  }

  // ── Nose ──────────────────────────────────────────────────────────────────
  void _drawNose(Canvas canvas, Offset Function(double, double) s,
      double Function(double) sw, double Function(double) sh, Paint paint) {
    final nosePaint = paint..style = PaintingStyle.stroke..strokeWidth = sw(0.012)..strokeCap = StrokeCap.round;
    final path = Path();
    path.moveTo(sw(0.48), sh(0.265));
    path.quadraticBezierTo(sw(0.47), sh(0.295), sw(0.45), sh(0.300));
    path.quadraticBezierTo(sw(0.50), sh(0.308), sw(0.55), sh(0.300));
    path.quadraticBezierTo(sw(0.53), sh(0.295), sw(0.52), sh(0.265));
    canvas.drawPath(path, nosePaint);
  }

  // ── Mouth ─────────────────────────────────────────────────────────────────
  void _drawMouth(Canvas canvas, Offset Function(double, double) s,
      double Function(double) sw, double Function(double) sh,
      FaceExpression expr, Color skinTone) {
    final lipPaint = Paint()
      ..color = _darken(skinTone, 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = sw(0.022)
      ..strokeCap = StrokeCap.round;
    final innerPaint = Paint()..color = const Color(0xFFCC4444);
    final teethPaint = Paint()..color = Colors.white;

    switch (expr) {
      case FaceExpression.neutral:
        canvas.drawLine(s(0.44, 0.335), s(0.56, 0.335), lipPaint);

      case FaceExpression.happy:
        final smile = Path();
        smile.moveTo(sw(0.43), sh(0.325));
        smile.quadraticBezierTo(sw(0.50), sh(0.360), sw(0.57), sh(0.325));
        canvas.drawPath(smile, lipPaint);

      case FaceExpression.excited:
        // Open mouth smile
        final mouth = Path();
        mouth.moveTo(sw(0.42), sh(0.320));
        mouth.quadraticBezierTo(sw(0.50), sh(0.370), sw(0.58), sh(0.320));
        mouth.quadraticBezierTo(sw(0.50), sh(0.340), sw(0.42), sh(0.320));
        canvas.drawPath(mouth, innerPaint..style = PaintingStyle.fill);
        canvas.drawPath(mouth, lipPaint..style = PaintingStyle.stroke);
        // Teeth
        canvas.drawRect(
          Rect.fromLTWH(sw(0.44), sh(0.320), sw(0.12), sh(0.015)),
          teethPaint,
        );

      case FaceExpression.sad:
        final frown = Path();
        frown.moveTo(sw(0.43), sh(0.345));
        frown.quadraticBezierTo(sw(0.50), sh(0.315), sw(0.57), sh(0.345));
        canvas.drawPath(frown, lipPaint);

      case FaceExpression.surprised:
        // Open O mouth
        canvas.drawOval(
          Rect.fromCenter(center: s(0.50, 0.340), width: sw(0.08), height: sh(0.05)),
          innerPaint..style = PaintingStyle.fill,
        );
        canvas.drawOval(
          Rect.fromCenter(center: s(0.50, 0.340), width: sw(0.08), height: sh(0.05)),
          lipPaint..style = PaintingStyle.stroke..strokeWidth = sw(0.018),
        );

      case FaceExpression.thinking:
        // Slight sideways smile
        final think = Path();
        think.moveTo(sw(0.44), sh(0.335));
        think.quadraticBezierTo(sw(0.50), sh(0.348), sw(0.56), sh(0.330));
        canvas.drawPath(think, lipPaint);
    }
  }

  Color _darken(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
  }

  @override
  bool shouldRepaint(FacePainter oldDelegate) =>
      oldDelegate.config.face != config.face ||
      oldDelegate.config.skinTone != config.skinTone ||
      oldDelegate.config.hair.color != config.hair.color;
}
