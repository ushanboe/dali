import 'package:flutter/material.dart';
import '../models/avatar_config.dart';

/// Paints clothing over the body torso area.
class ClothingPainter extends CustomPainter {
  final AvatarConfig config;

  ClothingPainter(this.config);

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    Offset s(double x, double y) => Offset(x * w, y * h);
    double sw(double x) => x * w;
    double sh(double y) => y * h;

    final c = config.clothing;

    switch (c.item) {
      case ClothingItem.tshirt:
        _drawTshirt(canvas, s, sw, sh, c);
      case ClothingItem.dress:
        _drawDress(canvas, s, sw, sh, c);
      case ClothingItem.hoodie:
        _drawHoodie(canvas, s, sw, sh, c);
      case ClothingItem.blouse:
        _drawBlouse(canvas, s, sw, sh, c);
      case ClothingItem.jacket:
        _drawJacket(canvas, s, sw, sh, c);
      case ClothingItem.sweater:
        _drawSweater(canvas, s, sw, sh, c);
      case ClothingItem.tanktop:
        _drawTanktop(canvas, s, sw, sh, c);
      case ClothingItem.formalShirt:
        _drawFormalShirt(canvas, s, sw, sh, c);
    }
  }

  void _drawTshirt(Canvas canvas, Offset Function(double, double) s,
      double Function(double) sw, double Function(double) sh, ClothingConfig c) {
    final paint = Paint()..color = c.primaryColor;
    final shade = Paint()..color = _darken(c.primaryColor, 0.15);

    // Body
    final body = Path();
    body.moveTo(s(0.28, 0.72).dx, s(0.28, 0.72).dy);
    body.quadraticBezierTo(sw(0.28), sh(0.46), sw(0.38), sh(0.46));
    body.lineTo(sw(0.62), sh(0.46));
    body.quadraticBezierTo(sw(0.72), sh(0.46), sw(0.72), sh(0.72));
    body.close();
    canvas.drawPath(body, paint);

    // Short sleeves
    final sleeveL = Path();
    sleeveL.moveTo(sw(0.30), sh(0.47));
    sleeveL.quadraticBezierTo(sw(0.18), sh(0.50), sw(0.20), sh(0.60));
    sleeveL.lineTo(sw(0.28), sh(0.58));
    sleeveL.quadraticBezierTo(sw(0.28), sh(0.52), sw(0.38), sh(0.49));
    sleeveL.close();
    canvas.drawPath(sleeveL, paint);
    canvas.drawPath(sleeveL, shade..style = PaintingStyle.stroke..strokeWidth = sw(0.005));

    final sleeveR = Path();
    sleeveR.moveTo(sw(0.70), sh(0.47));
    sleeveR.quadraticBezierTo(sw(0.82), sh(0.50), sw(0.80), sh(0.60));
    sleeveR.lineTo(sw(0.72), sh(0.58));
    sleeveR.quadraticBezierTo(sw(0.72), sh(0.52), sw(0.62), sh(0.49));
    sleeveR.close();
    canvas.drawPath(sleeveR, paint);

    // Collar
    final collar = Path();
    collar.moveTo(sw(0.42), sh(0.46));
    collar.quadraticBezierTo(sw(0.50), sh(0.50), sw(0.58), sh(0.46));
    canvas.drawPath(collar, shade..style = PaintingStyle.stroke..strokeWidth = sw(0.012));

    // Highlight
    final highlight = Paint()
      ..color = Colors.white.withOpacity(0.12)
      ..style = PaintingStyle.fill;
    final hiPath = Path();
    hiPath.moveTo(sw(0.36), sh(0.47));
    hiPath.quadraticBezierTo(sw(0.42), sh(0.58), sw(0.40), sh(0.70));
    hiPath.lineTo(sw(0.46), sh(0.70));
    hiPath.quadraticBezierTo(sw(0.44), sh(0.58), sw(0.44), sh(0.47));
    hiPath.close();
    canvas.drawPath(hiPath, highlight);
  }

  void _drawDress(Canvas canvas, Offset Function(double, double) s,
      double Function(double) sw, double Function(double) sh, ClothingConfig c) {
    final paint = Paint()..color = c.primaryColor;
    final shade = Paint()..color = _darken(c.primaryColor, 0.15);
    final accent = Paint()..color = c.secondaryColor;

    // Flared skirt extends into leg area
    final dress = Path();
    dress.moveTo(sw(0.38), sh(0.46));
    dress.lineTo(sw(0.62), sh(0.46));
    dress.quadraticBezierTo(sw(0.75), sh(0.58), sw(0.82), sh(0.96));
    dress.lineTo(sw(0.18), sh(0.96));
    dress.quadraticBezierTo(sw(0.25), sh(0.58), sw(0.38), sh(0.46));
    canvas.drawPath(dress, paint);

    // Bodice overlay
    final bodice = Path();
    bodice.moveTo(sw(0.38), sh(0.46));
    bodice.lineTo(sw(0.62), sh(0.46));
    bodice.lineTo(sw(0.64), sh(0.62));
    bodice.lineTo(sw(0.36), sh(0.62));
    bodice.close();
    canvas.drawPath(bodice, shade);

    // Waistband
    canvas.drawRect(
      Rect.fromLTWH(sw(0.34), sh(0.60), sw(0.32), sh(0.025)),
      accent,
    );

    // Thin straps
    canvas.drawLine(s(0.42, 0.44), s(0.40, 0.46), shade..strokeWidth = sw(0.025)..style = PaintingStyle.stroke);
    canvas.drawLine(s(0.58, 0.44), s(0.60, 0.46), shade..strokeWidth = sw(0.025)..style = PaintingStyle.stroke);

    // Skirt folds
    canvas.drawLine(s(0.44, 0.62), s(0.38, 0.96),
        Paint()..color = Colors.white.withOpacity(0.15)..strokeWidth = sw(0.012)..style = PaintingStyle.stroke);
    canvas.drawLine(s(0.56, 0.62), s(0.62, 0.96),
        Paint()..color = Colors.white.withOpacity(0.15)..strokeWidth = sw(0.012)..style = PaintingStyle.stroke);
  }

  void _drawHoodie(Canvas canvas, Offset Function(double, double) s,
      double Function(double) sw, double Function(double) sh, ClothingConfig c) {
    final paint = Paint()..color = c.primaryColor;
    final shade = Paint()..color = _darken(c.primaryColor, 0.18);

    // Body
    final body = Path();
    body.moveTo(s(0.26, 0.72).dx, s(0.26, 0.72).dy);
    body.quadraticBezierTo(sw(0.26), sh(0.45), sw(0.36), sh(0.45));
    body.lineTo(sw(0.64), sh(0.45));
    body.quadraticBezierTo(sw(0.74), sh(0.45), sw(0.74), sh(0.72));
    body.close();
    canvas.drawPath(body, paint);

    // Long sleeves
    for (final (ox, ex, side) in [(0.26, 0.14, -1.0), (0.74, 0.86, 1.0)]) {
      final sleeve = Path();
      sleeve.moveTo(sw(ox), sh(0.46));
      sleeve.quadraticBezierTo(sw(ex), sh(0.50), sw(ex), sh(0.72));
      sleeve.lineTo(sw(ex + side * 0.07), sh(0.72));
      sleeve.quadraticBezierTo(sw(ex + side * 0.07), sh(0.50), sw(ox + side * 0.08), sh(0.50));
      sleeve.close();
      canvas.drawPath(sleeve, paint);
      // Cuff
      canvas.drawRect(
        Rect.fromLTWH(sw((ex < 0.5 ? ex - 0.02 : ex - 0.05)), sh(0.70), sw(0.07), sh(0.025)),
        shade..style = PaintingStyle.fill,
      );
    }

    // Hood
    final hood = Path();
    hood.moveTo(sw(0.36), sh(0.46));
    hood.quadraticBezierTo(sw(0.36), sh(0.38), sw(0.50), sh(0.36));
    hood.quadraticBezierTo(sw(0.64), sh(0.38), sw(0.64), sh(0.46));
    canvas.drawPath(hood, shade..style = PaintingStyle.stroke..strokeWidth = sw(0.025)..style = PaintingStyle.stroke);

    // Kangaroo pocket
    final pocket = RRect.fromRectAndRadius(
      Rect.fromLTWH(sw(0.38), sh(0.61), sw(0.24), sh(0.07)),
      Radius.circular(sw(0.02)),
    );
    canvas.drawRRect(pocket, shade..style = PaintingStyle.stroke..strokeWidth = sw(0.008)..style = PaintingStyle.stroke);

    // Center zip line
    canvas.drawLine(s(0.50, 0.46), s(0.50, 0.72),
        Paint()..color = _darken(c.primaryColor, 0.25)..strokeWidth = sw(0.008)..style = PaintingStyle.stroke);
  }

  void _drawBlouse(Canvas canvas, Offset Function(double, double) s,
      double Function(double) sw, double Function(double) sh, ClothingConfig c) {
    final paint = Paint()..color = c.primaryColor;
    final shade = Paint()..color = _darken(c.primaryColor, 0.12);

    final body = Path();
    body.moveTo(s(0.30, 0.72).dx, s(0.30, 0.72).dy);
    body.quadraticBezierTo(sw(0.28), sh(0.46), sw(0.38), sh(0.46));
    body.lineTo(sw(0.62), sh(0.46));
    body.quadraticBezierTo(sw(0.72), sh(0.46), sw(0.70), sh(0.72));
    body.close();
    canvas.drawPath(body, paint);

    // Ruffled collar
    for (int i = 0; i < 5; i++) {
      final rx = 0.40 + i * 0.05;
      canvas.drawOval(
        Rect.fromCenter(center: Offset(sw(rx), sh(0.47)), width: sw(0.06), height: sh(0.03)),
        shade..style = PaintingStyle.fill,
      );
    }

    // Flowy sleeves
    final sleeveL = Path();
    sleeveL.moveTo(sw(0.30), sh(0.47));
    sleeveL.quadraticBezierTo(sw(0.14), sh(0.52), sw(0.18), sh(0.68));
    sleeveL.lineTo(sw(0.24), sh(0.66));
    sleeveL.quadraticBezierTo(sw(0.22), sh(0.54), sw(0.38), sh(0.50));
    sleeveL.close();
    canvas.drawPath(sleeveL, paint);

    final sleeveR = Path();
    sleeveR.moveTo(sw(0.70), sh(0.47));
    sleeveR.quadraticBezierTo(sw(0.86), sh(0.52), sw(0.82), sh(0.68));
    sleeveR.lineTo(sw(0.76), sh(0.66));
    sleeveR.quadraticBezierTo(sw(0.78), sh(0.54), sw(0.62), sh(0.50));
    sleeveR.close();
    canvas.drawPath(sleeveR, paint);

    // Subtle pattern - polka dots
    final dotPaint = Paint()..color = c.secondaryColor.withOpacity(0.4);
    final dots = [(0.38, 0.52), (0.50, 0.54), (0.62, 0.52), (0.44, 0.62), (0.56, 0.62), (0.50, 0.70)];
    for (final (dx, dy) in dots) {
      canvas.drawCircle(Offset(sw(dx), sh(dy)), sw(0.018), dotPaint);
    }
  }

  void _drawJacket(Canvas canvas, Offset Function(double, double) s,
      double Function(double) sw, double Function(double) sh, ClothingConfig c) {
    final paint = Paint()..color = c.primaryColor;
    final lapel = Paint()..color = c.secondaryColor;
    final shade = Paint()..color = _darken(c.primaryColor, 0.20);

    final body = Path();
    body.moveTo(s(0.26, 0.72).dx, s(0.26, 0.72).dy);
    body.quadraticBezierTo(sw(0.26), sh(0.45), sw(0.36), sh(0.45));
    body.lineTo(sw(0.64), sh(0.45));
    body.quadraticBezierTo(sw(0.74), sh(0.45), sw(0.74), sh(0.72));
    body.close();
    canvas.drawPath(body, paint);

    // Sleeves
    for (final (ox, ex, side) in [(0.26, 0.13, -1.0), (0.74, 0.87, 1.0)]) {
      final sleeve = Path();
      sleeve.moveTo(sw(ox), sh(0.46));
      sleeve.quadraticBezierTo(sw(ex), sh(0.50), sw(ex), sh(0.72));
      sleeve.lineTo(sw(ex + side * 0.08), sh(0.72));
      sleeve.quadraticBezierTo(sw(ex + side * 0.08), sh(0.50), sw(ox + side * 0.09), sh(0.50));
      sleeve.close();
      canvas.drawPath(sleeve, paint);
    }

    // Lapels
    final lapelL = Path();
    lapelL.moveTo(sw(0.50), sh(0.46));
    lapelL.lineTo(sw(0.38), sh(0.50));
    lapelL.lineTo(sw(0.36), sh(0.60));
    lapelL.lineTo(sw(0.46), sh(0.56));
    lapelL.close();
    canvas.drawPath(lapelL, lapel);

    final lapelR = Path();
    lapelR.moveTo(sw(0.50), sh(0.46));
    lapelR.lineTo(sw(0.62), sh(0.50));
    lapelR.lineTo(sw(0.64), sh(0.60));
    lapelR.lineTo(sw(0.54), sh(0.56));
    lapelR.close();
    canvas.drawPath(lapelR, lapel);

    // Buttons
    final btnPaint = Paint()..color = _darken(c.primaryColor, 0.3);
    for (int i = 0; i < 3; i++) {
      canvas.drawCircle(Offset(sw(0.50), sh(0.60 + i * 0.04)), sw(0.012), btnPaint);
    }

    // Pocket
    canvas.drawRect(
      Rect.fromLTWH(sw(0.58), sh(0.60), sw(0.08), sh(0.06)),
      shade..style = PaintingStyle.stroke..strokeWidth = sw(0.006)..style = PaintingStyle.stroke,
    );
  }

  void _drawSweater(Canvas canvas, Offset Function(double, double) s,
      double Function(double) sw, double Function(double) sh, ClothingConfig c) {
    final paint = Paint()..color = c.primaryColor;
    final shade = Paint()..color = _darken(c.primaryColor, 0.15);

    final body = Path();
    body.moveTo(s(0.28, 0.72).dx, s(0.28, 0.72).dy);
    body.quadraticBezierTo(sw(0.28), sh(0.46), sw(0.38), sh(0.46));
    body.lineTo(sw(0.62), sh(0.46));
    body.quadraticBezierTo(sw(0.72), sh(0.46), sw(0.72), sh(0.72));
    body.close();
    canvas.drawPath(body, paint);

    // Long sleeves
    for (final (ox, ex, side) in [(0.28, 0.15, -1.0), (0.72, 0.85, 1.0)]) {
      final sleeve = Path();
      sleeve.moveTo(sw(ox), sh(0.47));
      sleeve.quadraticBezierTo(sw(ex), sh(0.52), sw(ex), sh(0.72));
      sleeve.lineTo(sw(ex + side * 0.07), sh(0.72));
      sleeve.quadraticBezierTo(sw(ex + side * 0.07), sh(0.52), sw(ox + side * 0.09), sh(0.51));
      sleeve.close();
      canvas.drawPath(sleeve, paint);
    }

    // Ribbed neck
    final neckOval = Rect.fromCenter(center: Offset(sw(0.50), sh(0.47)), width: sw(0.22), height: sh(0.04));
    canvas.drawOval(neckOval, shade..style = PaintingStyle.fill);

    // Cable knit pattern lines
    final knitPaint = Paint()
      ..color = Colors.white.withOpacity(0.10)
      ..strokeWidth = sw(0.008)
      ..style = PaintingStyle.stroke;
    for (double y = 0.50; y < 0.72; y += 0.04) {
      canvas.drawLine(Offset(sw(0.32), sh(y)), Offset(sw(0.68), sh(y)), knitPaint);
    }

    // Ribbed hem
    final ribPaint = Paint()..color = shade.color;
    canvas.drawRect(Rect.fromLTWH(sw(0.28), sh(0.70), sw(0.44), sh(0.025)), ribPaint..style = PaintingStyle.fill);
  }

  void _drawTanktop(Canvas canvas, Offset Function(double, double) s,
      double Function(double) sw, double Function(double) sh, ClothingConfig c) {
    final paint = Paint()..color = c.primaryColor;
    final shade = Paint()..color = _darken(c.primaryColor, 0.12);

    final body = Path();
    body.moveTo(s(0.34, 0.72).dx, s(0.34, 0.72).dy);
    body.quadraticBezierTo(sw(0.32), sh(0.48), sw(0.40), sh(0.46));
    body.lineTo(sw(0.60), sh(0.46));
    body.quadraticBezierTo(sw(0.68), sh(0.48), sw(0.66), sh(0.72));
    body.close();
    canvas.drawPath(body, paint);

    // Wide straps
    canvas.drawRect(Rect.fromLTWH(sw(0.40), sh(0.44), sw(0.06), sh(0.04)), paint..style = PaintingStyle.fill);
    canvas.drawRect(Rect.fromLTWH(sw(0.54), sh(0.44), sw(0.06), sh(0.04)), paint..style = PaintingStyle.fill);

    // Scoop neck
    final neck = Path();
    neck.moveTo(sw(0.40), sh(0.47));
    neck.quadraticBezierTo(sw(0.50), sh(0.53), sw(0.60), sh(0.47));
    canvas.drawPath(neck, shade..style = PaintingStyle.stroke..strokeWidth = sw(0.012));

    // Color accent trim
    final trim = Paint()..color = c.secondaryColor;
    canvas.drawRect(Rect.fromLTWH(sw(0.34), sh(0.70), sw(0.32), sh(0.015)), trim..style = PaintingStyle.fill);
  }

  void _drawFormalShirt(Canvas canvas, Offset Function(double, double) s,
      double Function(double) sw, double Function(double) sh, ClothingConfig c) {
    final paint = Paint()..color = c.primaryColor;
    final shade = Paint()..color = _darken(c.primaryColor, 0.10);
    final accent = Paint()..color = c.secondaryColor;

    final body = Path();
    body.moveTo(s(0.28, 0.72).dx, s(0.28, 0.72).dy);
    body.quadraticBezierTo(sw(0.28), sh(0.45), sw(0.38), sh(0.45));
    body.lineTo(sw(0.62), sh(0.45));
    body.quadraticBezierTo(sw(0.72), sh(0.45), sw(0.72), sh(0.72));
    body.close();
    canvas.drawPath(body, paint);

    // Long sleeves
    for (final (ox, ex, side) in [(0.28, 0.14, -1.0), (0.72, 0.86, 1.0)]) {
      final sleeve = Path();
      sleeve.moveTo(sw(ox), sh(0.46));
      sleeve.quadraticBezierTo(sw(ex), sh(0.50), sw(ex), sh(0.72));
      sleeve.lineTo(sw(ex + side * 0.07), sh(0.72));
      sleeve.quadraticBezierTo(sw(ex + side * 0.07), sh(0.50), sw(ox + side * 0.08), sh(0.50));
      sleeve.close();
      canvas.drawPath(sleeve, paint);
      // Cuff
      canvas.drawRect(
        Rect.fromLTWH(sw((side < 0 ? ex - 0.02 : ex - 0.05)), sh(0.69), sw(0.07), sh(0.03)),
        shade..style = PaintingStyle.fill,
      );
    }

    // Collar points
    final collarL = Path();
    collarL.moveTo(sw(0.44), sh(0.45));
    collarL.lineTo(sw(0.40), sh(0.50));
    collarL.lineTo(sw(0.50), sh(0.48));
    collarL.close();
    canvas.drawPath(collarL, shade..style = PaintingStyle.fill);

    final collarR = Path();
    collarR.moveTo(sw(0.56), sh(0.45));
    collarR.lineTo(sw(0.60), sh(0.50));
    collarR.lineTo(sw(0.50), sh(0.48));
    collarR.close();
    canvas.drawPath(collarR, shade..style = PaintingStyle.fill);

    // Tie
    final tie = Path();
    tie.moveTo(sw(0.50), sh(0.48));
    tie.lineTo(sw(0.46), sh(0.55));
    tie.lineTo(sw(0.50), sh(0.68));
    tie.lineTo(sw(0.54), sh(0.55));
    tie.close();
    canvas.drawPath(tie, accent..style = PaintingStyle.fill);

    // Tie knot
    canvas.drawOval(
      Rect.fromCenter(center: Offset(sw(0.50), sh(0.50)), width: sw(0.05), height: sh(0.025)),
      accent..color = _darken(c.secondaryColor, 0.15),
    );

    // Shirt buttons
    final btnPaint = Paint()..color = shade.color;
    for (int i = 0; i < 4; i++) {
      canvas.drawCircle(Offset(sw(0.535), sh(0.52 + i * 0.05)), sw(0.008), btnPaint);
    }
  }

  Color _darken(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
  }

  @override
  bool shouldRepaint(ClothingPainter oldDelegate) =>
      oldDelegate.config.clothing != config.clothing;
}
