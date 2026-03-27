import 'package:flutter/material.dart';
import '../models/object_config.dart';

/// Paints one of 10 cartoon animals. All drawing fits inside the given [Size].
class AnimalPainter extends CustomPainter {
  final AnimalType type;
  final Color primaryColor;
  final Color? secondaryColor;

  AnimalPainter({
    required this.type,
    required this.primaryColor,
    this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    switch (type) {
      case AnimalType.cat:       _paintCat(canvas, size);
      case AnimalType.dog:       _paintDog(canvas, size);
      case AnimalType.rabbit:    _paintRabbit(canvas, size);
      case AnimalType.bird:      _paintBird(canvas, size);
      case AnimalType.fish:      _paintFish(canvas, size);
      case AnimalType.bear:      _paintBear(canvas, size);
      case AnimalType.fox:       _paintFox(canvas, size);
      case AnimalType.penguin:   _paintPenguin(canvas, size);
      case AnimalType.elephant:  _paintElephant(canvas, size);
      case AnimalType.lion:      _paintLion(canvas, size);
    }
  }

  @override
  bool shouldRepaint(AnimalPainter old) =>
      old.type != type || old.primaryColor != primaryColor;

  // ── Helpers ────────────────────────────────────────────────────────────────
  Offset _s(double x, double y, Size sz) => Offset(x * sz.width, y * sz.height);
  double _u(double scale, Size sz) => sz.height * scale;

  Paint _fill(Color c) => Paint()..color = c..style = PaintingStyle.fill;
  Paint _stroke(Color c, double w) => Paint()
    ..color = c..style = PaintingStyle.stroke..strokeWidth = w..strokeCap = StrokeCap.round;

  Color _darken(Color c, double amt) {
    final h = HSLColor.fromColor(c);
    return h.withLightness((h.lightness - amt).clamp(0.0, 1.0)).toColor();
  }

  Color _lighten(Color c, double amt) {
    final h = HSLColor.fromColor(c);
    return h.withLightness((h.lightness + amt).clamp(0.0, 1.0)).toColor();
  }

  void _eye(Canvas canvas, Offset center, double r) {
    canvas.drawCircle(center, r, _fill(Colors.white));
    canvas.drawCircle(center, r * 0.55, _fill(const Color(0xFF1A1A1A)));
    canvas.drawCircle(
      Offset(center.dx - r * 0.2, center.dy - r * 0.2), r * 0.22,
      _fill(Colors.white.withOpacity(0.8)),
    );
  }

  // ── Cat ────────────────────────────────────────────────────────────────────
  void _paintCat(Canvas canvas, Size sz) {
    final base = primaryColor;
    final dark = _darken(base, 0.12);
    final light = _lighten(base, 0.18);
    final u = _u(1, sz);

    // Body
    canvas.drawOval(
      Rect.fromCenter(center: _s(0.50, 0.70, sz), width: u * 0.55, height: u * 0.42),
      _fill(base),
    );
    // Head
    canvas.drawCircle(_s(0.50, 0.38, sz), u * 0.26, _fill(base));
    // Ears
    for (final (ex, flip) in [(-0.16, -1.0), (0.16, 1.0)]) {
      final path = Path()
        ..moveTo(_s(0.50 + ex, 0.18, sz).dx, _s(0.0, 0.18, sz).dy)
        ..lineTo(_s(0.50 + ex + flip * 0.10, 0.08, sz).dx, _s(0.0, 0.08, sz).dy)
        ..lineTo(_s(0.50 + ex + flip * 0.20, 0.22, sz).dx, _s(0.0, 0.22, sz).dy)
        ..close();
      canvas.drawPath(path, _fill(dark));
      // Inner ear
      final innerPath = Path()
        ..moveTo(_s(0.50 + ex, 0.19, sz).dx, _s(0.0, 0.19, sz).dy)
        ..lineTo(_s(0.50 + ex + flip * 0.07, 0.11, sz).dx, _s(0.0, 0.11, sz).dy)
        ..lineTo(_s(0.50 + ex + flip * 0.14, 0.22, sz).dx, _s(0.0, 0.22, sz).dy)
        ..close();
      canvas.drawPath(innerPath, _fill(Colors.pink.shade200));
    }
    // Face markings
    canvas.drawCircle(_s(0.50, 0.44, sz), u * 0.10, _fill(light));
    // Eyes
    _eye(canvas, _s(0.40, 0.35, sz), u * 0.055);
    _eye(canvas, _s(0.60, 0.35, sz), u * 0.055);
    // Nose
    final nosePath = Path()
      ..moveTo(_s(0.50, 0.41, sz).dx, _s(0.0, 0.41, sz).dy)
      ..lineTo(_s(0.47, 0.44, sz).dx, _s(0.0, 0.44, sz).dy)
      ..lineTo(_s(0.53, 0.44, sz).dx, _s(0.0, 0.44, sz).dy)
      ..close();
    canvas.drawPath(nosePath, _fill(Colors.pink.shade400));
    // Mouth
    canvas.drawArc(
      Rect.fromCenter(center: _s(0.465, 0.455, sz), width: u * 0.09, height: u * 0.06),
      0.3, 1.5, false, _stroke(dark, u * 0.018),
    );
    canvas.drawArc(
      Rect.fromCenter(center: _s(0.535, 0.455, sz), width: u * 0.09, height: u * 0.06),
      1.8, -1.5, false, _stroke(dark, u * 0.018),
    );
    // Whiskers
    for (final (wx, wy, tx, ty) in [
      (0.50, 0.42, 0.10, 0.40), (0.50, 0.44, 0.10, 0.44),
      (0.50, 0.42, 0.90, 0.40), (0.50, 0.44, 0.90, 0.44),
    ]) {
      canvas.drawLine(_s(wx, wy, sz), _s(tx, ty, sz),
          _stroke(dark.withOpacity(0.5), u * 0.012));
    }
    // Tail
    final tailPath = Path()
      ..moveTo(_s(0.72, 0.72, sz).dx, _s(0.72, 0.72, sz).dy)
      ..cubicTo(
        _s(0.90, 0.68, sz).dx, _s(0.90, 0.68, sz).dy,
        _s(0.95, 0.55, sz).dx, _s(0.95, 0.55, sz).dy,
        _s(0.85, 0.52, sz).dx, _s(0.85, 0.52, sz).dy,
      );
    canvas.drawPath(tailPath, _stroke(base, u * 0.06));
    canvas.drawCircle(_s(0.85, 0.52, sz), u * 0.04, _fill(light));
    // Paws
    for (final px in [0.38, 0.62]) {
      canvas.drawOval(
        Rect.fromCenter(center: _s(px, 0.88, sz), width: u * 0.14, height: u * 0.09),
        _fill(dark),
      );
    }
  }

  // ── Dog ────────────────────────────────────────────────────────────────────
  void _paintDog(Canvas canvas, Size sz) {
    final base = primaryColor;
    final dark = _darken(base, 0.15);
    final light = _lighten(base, 0.2);
    final u = _u(1, sz);

    // Body
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: _s(0.50, 0.68, sz), width: u * 0.52, height: u * 0.38),
        Radius.circular(u * 0.12),
      ),
      _fill(base),
    );
    // Head
    canvas.drawCircle(_s(0.50, 0.36, sz), u * 0.27, _fill(base));
    // Floppy ears
    for (final (ex, flip) in [(-0.22, 1.0), (0.22, -1.0)]) {
      canvas.drawOval(
        Rect.fromCenter(
          center: _s(0.50 + ex, 0.36, sz),
          width: u * 0.14, height: u * 0.28,
        ),
        _fill(dark),
      );
    }
    // Snout
    canvas.drawOval(
      Rect.fromCenter(center: _s(0.50, 0.43, sz), width: u * 0.22, height: u * 0.16),
      _fill(light),
    );
    // Eyes
    _eye(canvas, _s(0.40, 0.32, sz), u * 0.055);
    _eye(canvas, _s(0.60, 0.32, sz), u * 0.055);
    // Nose
    canvas.drawOval(
      Rect.fromCenter(center: _s(0.50, 0.40, sz), width: u * 0.11, height: u * 0.07),
      _fill(const Color(0xFF2D1B00)),
    );
    // Mouth
    canvas.drawLine(_s(0.50, 0.44, sz), _s(0.50, 0.47, sz), _stroke(dark, u * 0.018));
    canvas.drawArc(
      Rect.fromCenter(center: _s(0.46, 0.47, sz), width: u * 0.09, height: u * 0.05),
      0, 3.14, false, _stroke(dark, u * 0.018),
    );
    canvas.drawArc(
      Rect.fromCenter(center: _s(0.54, 0.47, sz), width: u * 0.09, height: u * 0.05),
      0, 3.14, false, _stroke(dark, u * 0.018),
    );
    // Tongue
    canvas.drawOval(
      Rect.fromCenter(center: _s(0.50, 0.49, sz), width: u * 0.09, height: u * 0.06),
      _fill(Colors.pink.shade300),
    );
    // Tail
    final tailPath = Path()
      ..moveTo(_s(0.74, 0.60, sz).dx, _s(0.74, 0.60, sz).dy)
      ..cubicTo(
        _s(0.90, 0.55, sz).dx, _s(0.90, 0.55, sz).dy,
        _s(0.95, 0.45, sz).dx, _s(0.95, 0.45, sz).dy,
        _s(0.88, 0.38, sz).dx, _s(0.88, 0.38, sz).dy,
      );
    canvas.drawPath(tailPath, _stroke(base, u * 0.06));
    // Paws
    for (final px in [0.36, 0.64]) {
      canvas.drawOval(
        Rect.fromCenter(center: _s(px, 0.86, sz), width: u * 0.14, height: u * 0.10),
        _fill(dark),
      );
    }
  }

  // ── Rabbit ─────────────────────────────────────────────────────────────────
  void _paintRabbit(Canvas canvas, Size sz) {
    final base = primaryColor;
    final dark = _darken(base, 0.10);
    final u = _u(1, sz);

    // Long ears
    for (final ex in [-0.14, 0.14]) {
      canvas.drawOval(
        Rect.fromCenter(center: _s(0.50 + ex, 0.14, sz), width: u * 0.10, height: u * 0.26),
        _fill(base),
      );
      canvas.drawOval(
        Rect.fromCenter(center: _s(0.50 + ex, 0.14, sz), width: u * 0.05, height: u * 0.20),
        _fill(Colors.pink.shade200),
      );
    }
    // Body
    canvas.drawOval(
      Rect.fromCenter(center: _s(0.50, 0.68, sz), width: u * 0.50, height: u * 0.44),
      _fill(base),
    );
    // Head
    canvas.drawCircle(_s(0.50, 0.36, sz), u * 0.24, _fill(base));
    // Eyes
    _eye(canvas, _s(0.41, 0.33, sz), u * 0.052);
    _eye(canvas, _s(0.59, 0.33, sz), u * 0.052);
    // Nose
    canvas.drawCircle(_s(0.50, 0.41, sz), u * 0.035, _fill(Colors.pink.shade300));
    // Mouth
    canvas.drawLine(_s(0.50, 0.41, sz), _s(0.50, 0.44, sz), _stroke(dark, u * 0.016));
    canvas.drawArc(
      Rect.fromCenter(center: _s(0.46, 0.44, sz), width: u * 0.08, height: u * 0.05),
      0, 3.14, false, _stroke(dark, u * 0.016),
    );
    canvas.drawArc(
      Rect.fromCenter(center: _s(0.54, 0.44, sz), width: u * 0.08, height: u * 0.05),
      0, 3.14, false, _stroke(dark, u * 0.016),
    );
    // Fluffy tail
    canvas.drawCircle(_s(0.74, 0.72, sz), u * 0.07, _fill(Colors.white));
    // Paws
    for (final px in [0.36, 0.64]) {
      canvas.drawOval(
        Rect.fromCenter(center: _s(px, 0.88, sz), width: u * 0.13, height: u * 0.09),
        _fill(dark),
      );
    }
  }

  // ── Bird ───────────────────────────────────────────────────────────────────
  void _paintBird(Canvas canvas, Size sz) {
    final base = primaryColor;
    final dark = _darken(base, 0.15);
    final wing = _lighten(base, 0.15);
    final u = _u(1, sz);

    // Body
    canvas.drawOval(
      Rect.fromCenter(center: _s(0.50, 0.62, sz), width: u * 0.42, height: u * 0.34),
      _fill(base),
    );
    // Wing
    final wingPath = Path()
      ..moveTo(_s(0.50, 0.60, sz).dx, _s(0.0, 0.60, sz).dy)
      ..cubicTo(
        _s(0.28, 0.52, sz).dx, _s(0.0, 0.52, sz).dy,
        _s(0.18, 0.62, sz).dx, _s(0.0, 0.62, sz).dy,
        _s(0.28, 0.72, sz).dx, _s(0.0, 0.72, sz).dy,
      )
      ..lineTo(_s(0.50, 0.70, sz).dx, _s(0.0, 0.70, sz).dy)
      ..close();
    canvas.drawPath(wingPath, _fill(wing));
    // Head
    canvas.drawCircle(_s(0.60, 0.36, sz), u * 0.20, _fill(base));
    // Beak
    final beakPath = Path()
      ..moveTo(_s(0.78, 0.36, sz).dx, _s(0.0, 0.36, sz).dy)
      ..lineTo(_s(0.90, 0.34, sz).dx, _s(0.0, 0.34, sz).dy)
      ..lineTo(_s(0.90, 0.39, sz).dx, _s(0.0, 0.39, sz).dy)
      ..close();
    canvas.drawPath(beakPath, _fill(const Color(0xFFFF9800)));
    // Eye
    _eye(canvas, _s(0.66, 0.33, sz), u * 0.055);
    // Tail feathers
    final tailPath = Path()
      ..moveTo(_s(0.30, 0.65, sz).dx, _s(0.0, 0.65, sz).dy)
      ..lineTo(_s(0.12, 0.60, sz).dx, _s(0.0, 0.60, sz).dy)
      ..lineTo(_s(0.14, 0.68, sz).dx, _s(0.0, 0.68, sz).dy)
      ..lineTo(_s(0.10, 0.72, sz).dx, _s(0.0, 0.72, sz).dy)
      ..lineTo(_s(0.30, 0.70, sz).dx, _s(0.0, 0.70, sz).dy)
      ..close();
    canvas.drawPath(tailPath, _fill(dark));
    // Feet
    for (final (fx, fy) in [(0.44, 0.88), (0.56, 0.88)]) {
      canvas.drawLine(_s(fx, 0.78, sz), _s(fx, fy, sz), _stroke(const Color(0xFFFF9800), u * 0.02));
      for (final tx in [-0.04, 0.0, 0.04]) {
        canvas.drawLine(_s(fx, fy, sz), _s(fx + tx, fy + 0.06, sz),
            _stroke(const Color(0xFFFF9800), u * 0.016));
      }
    }
  }

  // ── Fish ───────────────────────────────────────────────────────────────────
  void _paintFish(Canvas canvas, Size sz) {
    final base = primaryColor;
    final dark = _darken(base, 0.15);
    final light = _lighten(base, 0.2);
    final u = _u(1, sz);

    // Tail
    final tailPath = Path()
      ..moveTo(_s(0.22, 0.50, sz).dx, _s(0.0, 0.50, sz).dy)
      ..lineTo(_s(0.06, 0.30, sz).dx, _s(0.0, 0.30, sz).dy)
      ..lineTo(_s(0.06, 0.70, sz).dx, _s(0.0, 0.70, sz).dy)
      ..close();
    canvas.drawPath(tailPath, _fill(dark));
    // Body
    canvas.drawOval(
      Rect.fromCenter(center: _s(0.55, 0.50, sz), width: u * 0.56, height: u * 0.34),
      _fill(base),
    );
    // Scales stripe
    canvas.drawOval(
      Rect.fromCenter(center: _s(0.55, 0.50, sz), width: u * 0.40, height: u * 0.20),
      _fill(light.withOpacity(0.5)),
    );
    // Dorsal fin
    final dorsal = Path()
      ..moveTo(_s(0.42, 0.34, sz).dx, _s(0.0, 0.34, sz).dy)
      ..cubicTo(
        _s(0.52, 0.18, sz).dx, _s(0.0, 0.18, sz).dy,
        _s(0.65, 0.18, sz).dx, _s(0.0, 0.18, sz).dy,
        _s(0.72, 0.34, sz).dx, _s(0.0, 0.34, sz).dy,
      )
      ..close();
    canvas.drawPath(dorsal, _fill(dark));
    // Pectoral fin
    final pectFin = Path()
      ..moveTo(_s(0.60, 0.52, sz).dx, _s(0.0, 0.52, sz).dy)
      ..cubicTo(
        _s(0.62, 0.64, sz).dx, _s(0.0, 0.64, sz).dy,
        _s(0.52, 0.68, sz).dx, _s(0.0, 0.68, sz).dy,
        _s(0.48, 0.60, sz).dx, _s(0.0, 0.60, sz).dy,
      )
      ..close();
    canvas.drawPath(pectFin, _fill(dark));
    // Eye
    _eye(canvas, _s(0.74, 0.46, sz), u * 0.060);
    // Mouth
    canvas.drawArc(
      Rect.fromCenter(center: _s(0.83, 0.51, sz), width: u * 0.07, height: u * 0.05),
      0.5, 2.0, false, _stroke(dark, u * 0.018),
    );
  }

  // ── Bear ───────────────────────────────────────────────────────────────────
  void _paintBear(Canvas canvas, Size sz) {
    final base = primaryColor;
    final dark = _darken(base, 0.15);
    final light = _lighten(base, 0.22);
    final u = _u(1, sz);

    // Body
    canvas.drawOval(
      Rect.fromCenter(center: _s(0.50, 0.70, sz), width: u * 0.52, height: u * 0.42),
      _fill(base),
    );
    // Round ears
    for (final ex in [-0.22, 0.22]) {
      canvas.drawCircle(_s(0.50 + ex, 0.17, sz), u * 0.10, _fill(base));
      canvas.drawCircle(_s(0.50 + ex, 0.17, sz), u * 0.055, _fill(dark));
    }
    // Head
    canvas.drawCircle(_s(0.50, 0.34, sz), u * 0.26, _fill(base));
    // Muzzle
    canvas.drawOval(
      Rect.fromCenter(center: _s(0.50, 0.42, sz), width: u * 0.22, height: u * 0.15),
      _fill(light),
    );
    // Eyes
    _eye(canvas, _s(0.40, 0.29, sz), u * 0.052);
    _eye(canvas, _s(0.60, 0.29, sz), u * 0.052);
    // Nose
    canvas.drawOval(
      Rect.fromCenter(center: _s(0.50, 0.38, sz), width: u * 0.10, height: u * 0.065),
      _fill(const Color(0xFF1A1A1A)),
    );
    // Mouth
    canvas.drawLine(_s(0.50, 0.41, sz), _s(0.50, 0.44, sz), _stroke(dark, u * 0.016));
    canvas.drawArc(
      Rect.fromCenter(center: _s(0.46, 0.44, sz), width: u * 0.09, height: u * 0.05),
      0, 3.14, false, _stroke(dark, u * 0.016),
    );
    canvas.drawArc(
      Rect.fromCenter(center: _s(0.54, 0.44, sz), width: u * 0.09, height: u * 0.05),
      0, 3.14, false, _stroke(dark, u * 0.016),
    );
    // Belly patch
    canvas.drawOval(
      Rect.fromCenter(center: _s(0.50, 0.68, sz), width: u * 0.26, height: u * 0.28),
      _fill(light),
    );
    // Paws
    for (final px in [0.34, 0.66]) {
      canvas.drawOval(
        Rect.fromCenter(center: _s(px, 0.87, sz), width: u * 0.14, height: u * 0.10),
        _fill(dark),
      );
    }
  }

  // ── Fox ────────────────────────────────────────────────────────────────────
  void _paintFox(Canvas canvas, Size sz) {
    final base = primaryColor.withRed(220).withGreen(100).withBlue(30);
    final dark = _darken(base, 0.15);
    final u = _u(1, sz);

    // Body
    canvas.drawOval(
      Rect.fromCenter(center: _s(0.50, 0.70, sz), width: u * 0.50, height: u * 0.40),
      _fill(base),
    );
    // Pointed ears
    for (final (ex, flip) in [(-0.18, -1.0), (0.18, 1.0)]) {
      final ear = Path()
        ..moveTo(_s(0.50 + ex - flip * 0.06, 0.20, sz).dx, _s(0.0, 0.20, sz).dy)
        ..lineTo(_s(0.50 + ex + flip * 0.02, 0.06, sz).dx, _s(0.0, 0.06, sz).dy)
        ..lineTo(_s(0.50 + ex + flip * 0.14, 0.20, sz).dx, _s(0.0, 0.20, sz).dy)
        ..close();
      canvas.drawPath(ear, _fill(base));
      final innerEar = Path()
        ..moveTo(_s(0.50 + ex - flip * 0.03, 0.19, sz).dx, _s(0.0, 0.19, sz).dy)
        ..lineTo(_s(0.50 + ex + flip * 0.02, 0.10, sz).dx, _s(0.0, 0.10, sz).dy)
        ..lineTo(_s(0.50 + ex + flip * 0.09, 0.19, sz).dx, _s(0.0, 0.19, sz).dy)
        ..close();
      canvas.drawPath(innerEar, _fill(Colors.pink.shade200));
    }
    // Head
    canvas.drawCircle(_s(0.50, 0.34, sz), u * 0.26, _fill(base));
    // Mask — white snout area
    final mask = Path()
      ..moveTo(_s(0.50, 0.28, sz).dx, _s(0.0, 0.28, sz).dy)
      ..cubicTo(
        _s(0.36, 0.30, sz).dx, _s(0.0, 0.30, sz).dy,
        _s(0.34, 0.42, sz).dx, _s(0.0, 0.42, sz).dy,
        _s(0.50, 0.48, sz).dx, _s(0.0, 0.48, sz).dy,
      )
      ..cubicTo(
        _s(0.66, 0.42, sz).dx, _s(0.0, 0.42, sz).dy,
        _s(0.64, 0.30, sz).dx, _s(0.0, 0.30, sz).dy,
        _s(0.50, 0.28, sz).dx, _s(0.0, 0.28, sz).dy,
      );
    canvas.drawPath(mask, _fill(Colors.white));
    // Eyes
    _eye(canvas, _s(0.40, 0.30, sz), u * 0.052);
    _eye(canvas, _s(0.60, 0.30, sz), u * 0.052);
    // Nose
    canvas.drawCircle(_s(0.50, 0.38, sz), u * 0.035, _fill(const Color(0xFF1A1A1A)));
    // Bushy tail
    final tail = Path()
      ..moveTo(_s(0.72, 0.74, sz).dx, _s(0.0, 0.74, sz).dy)
      ..cubicTo(
        _s(0.92, 0.70, sz).dx, _s(0.0, 0.70, sz).dy,
        _s(0.98, 0.56, sz).dx, _s(0.0, 0.56, sz).dy,
        _s(0.90, 0.48, sz).dx, _s(0.0, 0.48, sz).dy,
      )
      ..cubicTo(
        _s(0.82, 0.52, sz).dx, _s(0.0, 0.52, sz).dy,
        _s(0.80, 0.64, sz).dx, _s(0.0, 0.64, sz).dy,
        _s(0.72, 0.74, sz).dx, _s(0.0, 0.74, sz).dy,
      );
    canvas.drawPath(tail, _fill(base));
    canvas.drawCircle(_s(0.90, 0.48, sz), u * 0.065, _fill(Colors.white));
    // Paws
    for (final px in [0.36, 0.64]) {
      canvas.drawOval(
        Rect.fromCenter(center: _s(px, 0.87, sz), width: u * 0.13, height: u * 0.09),
        _fill(dark),
      );
    }
  }

  // ── Penguin ────────────────────────────────────────────────────────────────
  void _paintPenguin(Canvas canvas, Size sz) {
    final u = _u(1, sz);
    const body = Color(0xFF212121);
    const belly = Colors.white;
    const beak = Color(0xFFFF9800);

    // Body
    canvas.drawOval(
      Rect.fromCenter(center: _s(0.50, 0.68, sz), width: u * 0.46, height: u * 0.44),
      _fill(body),
    );
    // Belly
    canvas.drawOval(
      Rect.fromCenter(center: _s(0.50, 0.68, sz), width: u * 0.28, height: u * 0.34),
      _fill(belly),
    );
    // Head
    canvas.drawCircle(_s(0.50, 0.32, sz), u * 0.22, _fill(body));
    // Face white patch
    canvas.drawOval(
      Rect.fromCenter(center: _s(0.50, 0.35, sz), width: u * 0.22, height: u * 0.18),
      _fill(belly),
    );
    // Eyes
    _eye(canvas, _s(0.43, 0.28, sz), u * 0.052);
    _eye(canvas, _s(0.57, 0.28, sz), u * 0.052);
    // Beak
    final beakPath = Path()
      ..moveTo(_s(0.44, 0.36, sz).dx, _s(0.0, 0.36, sz).dy)
      ..lineTo(_s(0.50, 0.42, sz).dx, _s(0.0, 0.42, sz).dy)
      ..lineTo(_s(0.56, 0.36, sz).dx, _s(0.0, 0.36, sz).dy)
      ..close();
    canvas.drawPath(beakPath, _fill(beak));
    // Wings
    for (final (wx, flip) in [(0.22, -1.0), (0.78, 1.0)]) {
      canvas.drawOval(
        Rect.fromCenter(center: _s(wx, 0.66, sz), width: u * 0.12, height: u * 0.28),
        _fill(body),
      );
    }
    // Feet
    for (final fx in [0.40, 0.60]) {
      canvas.drawOval(
        Rect.fromCenter(center: _s(fx, 0.91, sz), width: u * 0.14, height: u * 0.07),
        _fill(beak),
      );
    }
  }

  // ── Elephant ───────────────────────────────────────────────────────────────
  void _paintElephant(Canvas canvas, Size sz) {
    final base = primaryColor;
    final dark = _darken(base, 0.12);
    final light = _lighten(base, 0.15);
    final u = _u(1, sz);

    // Body
    canvas.drawOval(
      Rect.fromCenter(center: _s(0.50, 0.68, sz), width: u * 0.58, height: u * 0.40),
      _fill(base),
    );
    // Head
    canvas.drawCircle(_s(0.50, 0.34, sz), u * 0.26, _fill(base));
    // Big ears
    for (final (ex, flip) in [(-0.32, -1.0), (0.32, 1.0)]) {
      canvas.drawOval(
        Rect.fromCenter(center: _s(0.50 + ex, 0.34, sz), width: u * 0.20, height: u * 0.28),
        _fill(dark),
      );
      canvas.drawOval(
        Rect.fromCenter(center: _s(0.50 + ex, 0.34, sz), width: u * 0.13, height: u * 0.20),
        _fill(Colors.pink.shade200.withOpacity(0.6)),
      );
    }
    // Trunk
    final trunk = Path()
      ..moveTo(_s(0.43, 0.44, sz).dx, _s(0.0, 0.44, sz).dy)
      ..cubicTo(
        _s(0.38, 0.56, sz).dx, _s(0.0, 0.56, sz).dy,
        _s(0.32, 0.64, sz).dx, _s(0.0, 0.64, sz).dy,
        _s(0.36, 0.70, sz).dx, _s(0.0, 0.70, sz).dy,
      )
      ..cubicTo(
        _s(0.40, 0.72, sz).dx, _s(0.0, 0.72, sz).dy,
        _s(0.45, 0.68, sz).dx, _s(0.0, 0.68, sz).dy,
        _s(0.43, 0.44, sz).dx, _s(0.0, 0.44, sz).dy,
      );
    canvas.drawPath(trunk, _fill(base));
    // Trunk tip
    canvas.drawCircle(_s(0.36, 0.70, sz), u * 0.04, _fill(dark));
    // Eyes
    _eye(canvas, _s(0.42, 0.28, sz), u * 0.055);
    _eye(canvas, _s(0.60, 0.28, sz), u * 0.055);
    // Tusks
    for (final (tx, sign) in [(0.44, -1.0), (0.58, 1.0)]) {
      canvas.drawArc(
        Rect.fromCenter(center: _s(tx + sign * 0.04, 0.46, sz), width: u * 0.10, height: u * 0.10),
        sign > 0 ? 3.14 : 0, 1.5, false,
        _stroke(Colors.white.withOpacity(0.9), u * 0.025),
      );
    }
    // Legs
    for (final lx in [0.33, 0.43, 0.57, 0.67]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: _s(lx, 0.88, sz), width: u * 0.11, height: u * 0.14),
          Radius.circular(u * 0.04),
        ),
        _fill(dark),
      );
    }
  }

  // ── Lion ───────────────────────────────────────────────────────────────────
  void _paintLion(Canvas canvas, Size sz) {
    final base = const Color(0xFFE6A020);
    final dark = _darken(base, 0.15);
    final mane = const Color(0xFF8B4513);
    final u = _u(1, sz);

    // Body
    canvas.drawOval(
      Rect.fromCenter(center: _s(0.50, 0.70, sz), width: u * 0.52, height: u * 0.38),
      _fill(base),
    );
    // Mane (large circle behind head)
    canvas.drawCircle(_s(0.50, 0.36, sz), u * 0.36, _fill(mane));
    // Head
    canvas.drawCircle(_s(0.50, 0.36, sz), u * 0.24, _fill(base));
    // Muzzle
    canvas.drawOval(
      Rect.fromCenter(center: _s(0.50, 0.43, sz), width: u * 0.22, height: u * 0.15),
      _fill(_lighten(base, 0.22)),
    );
    // Ears (poking out of mane)
    for (final ex in [-0.28, 0.28]) {
      canvas.drawCircle(_s(0.50 + ex, 0.16, sz), u * 0.08, _fill(base));
      canvas.drawCircle(_s(0.50 + ex, 0.16, sz), u * 0.04, _fill(Colors.pink.shade200));
    }
    // Eyes
    _eye(canvas, _s(0.41, 0.32, sz), u * 0.055);
    _eye(canvas, _s(0.59, 0.32, sz), u * 0.055);
    // Nose
    final nosePath = Path()
      ..moveTo(_s(0.50, 0.39, sz).dx, _s(0.0, 0.39, sz).dy)
      ..lineTo(_s(0.46, 0.43, sz).dx, _s(0.0, 0.43, sz).dy)
      ..lineTo(_s(0.54, 0.43, sz).dx, _s(0.0, 0.43, sz).dy)
      ..close();
    canvas.drawPath(nosePath, _fill(Colors.pink.shade400));
    // Mouth
    canvas.drawLine(_s(0.50, 0.43, sz), _s(0.50, 0.46, sz), _stroke(dark, u * 0.016));
    canvas.drawArc(
      Rect.fromCenter(center: _s(0.46, 0.46, sz), width: u * 0.09, height: u * 0.05),
      0, 3.14, false, _stroke(dark, u * 0.016),
    );
    canvas.drawArc(
      Rect.fromCenter(center: _s(0.54, 0.46, sz), width: u * 0.09, height: u * 0.05),
      0, 3.14, false, _stroke(dark, u * 0.016),
    );
    // Whisker dots
    for (final (wx, wy) in [(0.36, 0.42), (0.38, 0.44), (0.64, 0.42), (0.62, 0.44)]) {
      canvas.drawCircle(_s(wx, wy, sz), u * 0.014, _fill(dark.withOpacity(0.4)));
    }
    // Tail with tuft
    final tail = Path()
      ..moveTo(_s(0.74, 0.72, sz).dx, _s(0.0, 0.72, sz).dy)
      ..cubicTo(
        _s(0.92, 0.68, sz).dx, _s(0.0, 0.68, sz).dy,
        _s(0.96, 0.56, sz).dx, _s(0.0, 0.56, sz).dy,
        _s(0.88, 0.50, sz).dx, _s(0.0, 0.50, sz).dy,
      );
    canvas.drawPath(tail, _stroke(base, u * 0.055));
    canvas.drawCircle(_s(0.88, 0.50, sz), u * 0.065, _fill(mane));
    // Paws
    for (final px in [0.35, 0.65]) {
      canvas.drawOval(
        Rect.fromCenter(center: _s(px, 0.87, sz), width: u * 0.13, height: u * 0.09),
        _fill(dark),
      );
    }
  }
}
