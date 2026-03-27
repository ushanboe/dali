import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/object_config.dart';

/// Paints one of 12 cartoon food items. All drawing fits inside [Size].
class FoodPainter extends CustomPainter {
  final FoodType type;
  final Color? primaryColor;

  FoodPainter({required this.type, this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    switch (type) {
      case FoodType.apple:       _paintApple(canvas, size);
      case FoodType.banana:      _paintBanana(canvas, size);
      case FoodType.pizza:       _paintPizza(canvas, size);
      case FoodType.cake:        _paintCake(canvas, size);
      case FoodType.iceCream:    _paintIceCream(canvas, size);
      case FoodType.burger:      _paintBurger(canvas, size);
      case FoodType.donut:       _paintDonut(canvas, size);
      case FoodType.watermelon:  _paintWatermelon(canvas, size);
      case FoodType.cupcake:     _paintCupcake(canvas, size);
      case FoodType.strawberry:  _paintStrawberry(canvas, size);
      case FoodType.lollipop:    _paintLollipop(canvas, size);
      case FoodType.star:        _paintStar(canvas, size);
    }
  }

  @override
  bool shouldRepaint(FoodPainter old) => old.type != type;

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

  double _cos(double a) => math.cos(a);
  double _sin(double a) => math.sin(a);

  void _shine(Canvas canvas, Offset center, double r) {
    canvas.drawCircle(center, r * 0.22,
        _fill(Colors.white.withOpacity(0.65)));
  }

  // ── Apple ──────────────────────────────────────────────────────────────────
  void _paintApple(Canvas canvas, Size sz) {
    final base = primaryColor ?? const Color(0xFFE53935);
    final u = _u(1, sz);

    // Body (two overlapping circles for apple shape)
    canvas.drawCircle(_s(0.46, 0.56, sz), u * 0.34, _fill(base));
    canvas.drawCircle(_s(0.56, 0.56, sz), u * 0.32, _fill(base));
    // Indent top
    canvas.drawCircle(_s(0.50, 0.30, sz), u * 0.09,
        _fill(const Color(0xFF1B5E20)));
    // Stem
    canvas.drawLine(_s(0.50, 0.28, sz), _s(0.52, 0.18, sz),
        _stroke(const Color(0xFF5D4037), u * 0.035));
    // Leaf
    final leaf = Path()
      ..moveTo(_s(0.52, 0.22, sz).dx, _s(0.0, 0.22, sz).dy)
      ..cubicTo(
        _s(0.64, 0.14, sz).dx, _s(0.0, 0.14, sz).dy,
        _s(0.70, 0.22, sz).dx, _s(0.0, 0.22, sz).dy,
        _s(0.56, 0.26, sz).dx, _s(0.0, 0.26, sz).dy,
      )
      ..close();
    canvas.drawPath(leaf, _fill(const Color(0xFF43A047)));
    _shine(canvas, _s(0.38, 0.44, sz), u * 0.34);
  }

  // ── Banana ─────────────────────────────────────────────────────────────────
  void _paintBanana(Canvas canvas, Size sz) {
    final u = _u(1, sz);
    const base = Color(0xFFFFD600);
    const dark = Color(0xFFF57F17);

    final path = Path()
      ..moveTo(_s(0.18, 0.72, sz).dx, _s(0.0, 0.72, sz).dy)
      ..cubicTo(
        _s(0.10, 0.38, sz).dx, _s(0.0, 0.38, sz).dy,
        _s(0.50, 0.08, sz).dx, _s(0.0, 0.08, sz).dy,
        _s(0.82, 0.28, sz).dx, _s(0.0, 0.28, sz).dy,
      )
      ..cubicTo(
        _s(0.90, 0.34, sz).dx, _s(0.0, 0.34, sz).dy,
        _s(0.88, 0.44, sz).dx, _s(0.0, 0.44, sz).dy,
        _s(0.82, 0.46, sz).dx, _s(0.0, 0.46, sz).dy,
      )
      ..cubicTo(
        _s(0.56, 0.28, sz).dx, _s(0.0, 0.28, sz).dy,
        _s(0.20, 0.50, sz).dx, _s(0.0, 0.50, sz).dy,
        _s(0.26, 0.72, sz).dx, _s(0.0, 0.72, sz).dy,
      )
      ..close();
    canvas.drawPath(path, _fill(base));
    // Ridge line
    final ridge = Path()
      ..moveTo(_s(0.22, 0.72, sz).dx, _s(0.0, 0.72, sz).dy)
      ..cubicTo(
        _s(0.14, 0.42, sz).dx, _s(0.0, 0.42, sz).dy,
        _s(0.52, 0.14, sz).dx, _s(0.0, 0.14, sz).dy,
        _s(0.82, 0.37, sz).dx, _s(0.0, 0.37, sz).dy,
      );
    canvas.drawPath(ridge, _stroke(dark, u * 0.018));
    // Tips
    canvas.drawCircle(_s(0.18, 0.72, sz), u * 0.035, _fill(dark));
    canvas.drawCircle(_s(0.82, 0.28, sz), u * 0.030, _fill(dark));
  }

  // ── Pizza ──────────────────────────────────────────────────────────────────
  void _paintPizza(Canvas canvas, Size sz) {
    final u = _u(1, sz);

    // Crust (big triangle)
    final crust = Path()
      ..moveTo(_s(0.50, 0.10, sz).dx, _s(0.0, 0.10, sz).dy)
      ..lineTo(_s(0.10, 0.88, sz).dx, _s(0.0, 0.88, sz).dy)
      ..lineTo(_s(0.90, 0.88, sz).dx, _s(0.0, 0.88, sz).dy)
      ..close();
    canvas.drawPath(crust, _fill(const Color(0xFFE65100)));
    // Dough
    final dough = Path()
      ..moveTo(_s(0.50, 0.18, sz).dx, _s(0.0, 0.18, sz).dy)
      ..lineTo(_s(0.15, 0.82, sz).dx, _s(0.0, 0.82, sz).dy)
      ..lineTo(_s(0.85, 0.82, sz).dx, _s(0.0, 0.82, sz).dy)
      ..close();
    canvas.drawPath(dough, _fill(const Color(0xFFFFF9C4)));
    // Sauce
    final sauce = Path()
      ..moveTo(_s(0.50, 0.24, sz).dx, _s(0.0, 0.24, sz).dy)
      ..lineTo(_s(0.20, 0.76, sz).dx, _s(0.0, 0.76, sz).dy)
      ..lineTo(_s(0.80, 0.76, sz).dx, _s(0.0, 0.76, sz).dy)
      ..close();
    canvas.drawPath(sauce, _fill(const Color(0xFFE53935).withOpacity(0.85)));
    // Cheese blobs
    for (final (cx, cy) in [(0.50, 0.42), (0.36, 0.60), (0.64, 0.60), (0.50, 0.66)]) {
      canvas.drawCircle(_s(cx, cy, sz), u * 0.08, _fill(const Color(0xFFFFF176)));
    }
    // Pepperoni
    for (final (px, py) in [(0.50, 0.34), (0.38, 0.54), (0.62, 0.54), (0.50, 0.58)]) {
      canvas.drawCircle(_s(px, py, sz), u * 0.055, _fill(const Color(0xFFC62828)));
    }
    // Crust end bumps
    for (int i = 0; i < 5; i++) {
      canvas.drawCircle(
        _s(0.15 + i * 0.175, 0.86, sz), u * 0.038,
        _fill(const Color(0xFFBF360C)),
      );
    }
  }

  // ── Cake ───────────────────────────────────────────────────────────────────
  void _paintCake(Canvas canvas, Size sz) {
    final base = primaryColor ?? const Color(0xFFE91E63);
    final u = _u(1, sz);

    // Bottom tier
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(_s(0.10, 0.54, sz).dx, _s(0.0, 0.54, sz).dy,
            sz.width * 0.80, sz.height * 0.32),
        Radius.circular(u * 0.04),
      ),
      _fill(base),
    );
    // Top tier
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(_s(0.24, 0.30, sz).dx, _s(0.0, 0.30, sz).dy,
            sz.width * 0.52, sz.height * 0.24),
        Radius.circular(u * 0.04),
      ),
      _fill(_darken(base, 0.08)),
    );
    // Icing drips on bottom tier
    for (int i = 0; i < 6; i++) {
      canvas.drawOval(
        Rect.fromCenter(
          center: _s(0.18 + i * 0.13, 0.54, sz), width: u * 0.07, height: u * 0.06,
        ),
        _fill(Colors.white),
      );
    }
    // Icing drips on top tier
    for (int i = 0; i < 4; i++) {
      canvas.drawOval(
        Rect.fromCenter(
          center: _s(0.30 + i * 0.13, 0.30, sz), width: u * 0.06, height: u * 0.05,
        ),
        _fill(Colors.white.withOpacity(0.9)),
      );
    }
    // Candles
    for (final (cx, cy) in [(0.36, 0.22), (0.50, 0.18), (0.64, 0.22)]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: _s(cx, cy, sz), width: u * 0.04, height: u * 0.10),
          Radius.circular(u * 0.01),
        ),
        _fill(const Color(0xFFFFEB3B)),
      );
      // Flame
      canvas.drawOval(
        Rect.fromCenter(
          center: _s(cx, cy - 0.07, sz), width: u * 0.025, height: u * 0.04,
        ),
        _fill(const Color(0xFFFF9800)),
      );
    }
    // Cherry on top
    canvas.drawCircle(_s(0.50, 0.22, sz), u * 0.045, _fill(const Color(0xFFC62828)));
    canvas.drawLine(_s(0.50, 0.17, sz), _s(0.52, 0.12, sz),
        _stroke(const Color(0xFF2E7D32), u * 0.018));
    // Sprinkles
    for (final (sx, sy, col) in [
      (0.22, 0.62, Color(0xFFFF5252)),
      (0.42, 0.70, Color(0xFF40C4FF)),
      (0.60, 0.64, Color(0xFFFFFF00)),
      (0.75, 0.72, Color(0xFF69F0AE)),
      (0.32, 0.74, Color(0xFFFF9800)),
    ]) {
      canvas.drawOval(
        Rect.fromCenter(center: _s(sx, sy, sz), width: u * 0.04, height: u * 0.015),
        _fill(col),
      );
    }
  }

  // ── Ice Cream ──────────────────────────────────────────────────────────────
  void _paintIceCream(Canvas canvas, Size sz) {
    final scoopColor = primaryColor ?? const Color(0xFFFFB7C5);
    final u = _u(1, sz);

    // Cone
    final cone = Path()
      ..moveTo(_s(0.32, 0.54, sz).dx, _s(0.0, 0.54, sz).dy)
      ..lineTo(_s(0.50, 0.90, sz).dx, _s(0.0, 0.90, sz).dy)
      ..lineTo(_s(0.68, 0.54, sz).dx, _s(0.0, 0.54, sz).dy)
      ..close();
    canvas.drawPath(cone, _fill(const Color(0xFFE65100)));
    // Waffle lines
    for (int i = 1; i < 4; i++) {
      final t = i / 4.0;
      final y = 0.54 + t * 0.36;
      final xOff = t * 0.18;
      canvas.drawLine(_s(0.32 + xOff, y, sz), _s(0.68 - xOff, y, sz),
          _stroke(const Color(0xFFBF360C), u * 0.012));
    }
    for (int i = 0; i < 4; i++) {
      canvas.drawLine(
        _s(0.38 + i * 0.08, 0.54, sz),
        _s(0.44 + i * 0.06, 0.90, sz),
        _stroke(const Color(0xFFBF360C), u * 0.010),
      );
    }

    // Scoop 1 (bottom)
    canvas.drawCircle(_s(0.50, 0.44, sz), u * 0.22, _fill(scoopColor));
    // Scoop 2 (top)
    canvas.drawCircle(_s(0.42, 0.26, sz), u * 0.17,
        _fill(const Color(0xFFA5D6A7)));
    canvas.drawCircle(_s(0.60, 0.24, sz), u * 0.16,
        _fill(const Color(0xFFFFCC80)));
    // Shine on scoops
    _shine(canvas, _s(0.42, 0.36, sz), u * 0.22);
    _shine(canvas, _s(0.36, 0.20, sz), u * 0.17);
    // Drip
    final drip = Path()
      ..moveTo(_s(0.62, 0.46, sz).dx, _s(0.0, 0.46, sz).dy)
      ..cubicTo(
        _s(0.65, 0.50, sz).dx, _s(0.0, 0.50, sz).dy,
        _s(0.66, 0.54, sz).dx, _s(0.0, 0.54, sz).dy,
        _s(0.63, 0.57, sz).dx, _s(0.0, 0.57, sz).dy,
      );
    canvas.drawPath(drip, _stroke(scoopColor.withOpacity(0.8), u * 0.025));
    // Cherry
    canvas.drawCircle(_s(0.42, 0.14, sz), u * 0.04, _fill(const Color(0xFFC62828)));
    canvas.drawLine(_s(0.42, 0.10, sz), _s(0.44, 0.06, sz),
        _stroke(const Color(0xFF2E7D32), u * 0.018));
  }

  // ── Burger ─────────────────────────────────────────────────────────────────
  void _paintBurger(Canvas canvas, Size sz) {
    final u = _u(1, sz);

    void _roundRect(double x, double y, double w, double h, Color c, {double r = 0.04}) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(_s(x, y, sz).dx, _s(0.0, y, sz).dy, sz.width * w, sz.height * h),
          Radius.circular(u * r),
        ),
        _fill(c),
      );
    }

    // Bottom bun
    canvas.drawOval(
      Rect.fromCenter(center: _s(0.50, 0.84, sz), width: sz.width * 0.74, height: sz.height * 0.14),
      _fill(const Color(0xFFE65100)),
    );
    // Patty
    _roundRect(0.12, 0.72, 0.76, 0.10, const Color(0xFF5D4037));
    // Cheese
    _roundRect(0.10, 0.66, 0.80, 0.07, const Color(0xFFFDD835));
    // Lettuce
    final lettuce = Path()
      ..moveTo(_s(0.10, 0.66, sz).dx, _s(0.0, 0.66, sz).dy);
    for (int i = 0; i < 8; i++) {
      lettuce.quadraticBezierTo(
        _s(0.16 + i * 0.10, 0.60, sz).dx, _s(0.0, 0.60, sz).dy,
        _s(0.20 + i * 0.10, 0.66, sz).dx, _s(0.0, 0.66, sz).dy,
      );
    }
    lettuce.lineTo(_s(0.90, 0.66, sz).dx, _s(0.0, 0.66, sz).dy);
    lettuce.close();
    canvas.drawPath(lettuce, _fill(const Color(0xFF66BB6A)));
    // Tomato
    _roundRect(0.14, 0.57, 0.72, 0.07, const Color(0xFFE53935));
    // Top bun
    canvas.drawOval(
      Rect.fromCenter(center: _s(0.50, 0.44, sz), width: sz.width * 0.74, height: sz.height * 0.30),
      _fill(const Color(0xFFE65100)),
    );
    // Sesame seeds
    for (final (sx, sy) in [(0.38, 0.36), (0.50, 0.30), (0.62, 0.34), (0.44, 0.42)]) {
      canvas.drawOval(
        Rect.fromCenter(center: _s(sx, sy, sz), width: u * 0.05, height: u * 0.025),
        _fill(Colors.white.withOpacity(0.8)),
      );
    }
  }

  // ── Donut ──────────────────────────────────────────────────────────────────
  void _paintDonut(Canvas canvas, Size sz) {
    final icing = primaryColor ?? const Color(0xFFE91E63);
    final u = _u(1, sz);

    // Outer circle (donut body)
    canvas.drawCircle(_s(0.50, 0.50, sz), u * 0.38, _fill(const Color(0xFFE65100)));
    // Icing
    canvas.drawCircle(_s(0.50, 0.50, sz), u * 0.36, _fill(icing));
    // Hole
    canvas.drawCircle(_s(0.50, 0.50, sz), u * 0.14, _fill(Colors.white));
    // Sprinkles
    final sprinkleColors = [Colors.red, Colors.blue, Colors.yellow, Colors.green, Colors.purple];
    final sprinkles = [
      (0.30, 0.24), (0.50, 0.18), (0.70, 0.26),
      (0.78, 0.44), (0.72, 0.68), (0.50, 0.76),
      (0.28, 0.68), (0.22, 0.46),
    ];
    for (int i = 0; i < sprinkles.length; i++) {
      final (sx, sy) = sprinkles[i];
      final angle = i * 0.8;
      final cos = _cos(angle);
      final sin = _sin(angle);
      final center = _s(sx, sy, sz);
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(angle);
      canvas.drawOval(
        Rect.fromCenter(center: Offset.zero, width: u * 0.06, height: u * 0.02),
        _fill(sprinkleColors[i % sprinkleColors.length]),
      );
      canvas.restore();
    }
    // Shine
    canvas.drawCircle(_s(0.36, 0.36, sz), u * 0.07,
        _fill(Colors.white.withOpacity(0.30)));
  }

  // ── Watermelon ─────────────────────────────────────────────────────────────
  void _paintWatermelon(Canvas canvas, Size sz) {
    final u = _u(1, sz);

    // Rind (full semicircle)
    canvas.drawCircle(_s(0.50, 0.70, sz), u * 0.42, _fill(const Color(0xFF2E7D32)));
    // White layer
    canvas.drawCircle(_s(0.50, 0.70, sz), u * 0.38, _fill(Colors.white));
    // Flesh
    canvas.drawCircle(_s(0.50, 0.70, sz), u * 0.34, _fill(const Color(0xFFEF5350)));
    // Cut flat top — clip the top away to look like a slice
    canvas.drawRect(
      Rect.fromLTWH(0, 0, sz.width, sz.height * 0.68),
      _fill(Colors.transparent),
    );
    // Flat cut surface
    canvas.drawRect(
      Rect.fromLTWH(_s(0.08, 0.68, sz).dx, 0, sz.width * 0.84, sz.height * 0.68),
      _fill(const Color(0xFFEF5350)),
    );
    // White line on cut
    canvas.drawLine(_s(0.08, 0.68, sz), _s(0.92, 0.68, sz),
        _stroke(Colors.white, u * 0.018));
    // Green rind on cut edge
    canvas.drawLine(_s(0.08, 0.68, sz), _s(0.92, 0.68, sz),
        _stroke(const Color(0xFF2E7D32), u * 0.032));
    canvas.drawLine(_s(0.08, 0.68, sz), _s(0.92, 0.68, sz),
        _stroke(Colors.white, u * 0.018));
    // Seeds
    for (final (sx, sy) in [
      (0.36, 0.50), (0.50, 0.44), (0.64, 0.50),
      (0.44, 0.58), (0.58, 0.56),
    ]) {
      canvas.drawOval(
        Rect.fromCenter(center: _s(sx, sy, sz), width: u * 0.025, height: u * 0.042),
        _fill(const Color(0xFF1A1A1A)),
      );
    }
  }

  // ── Cupcake ────────────────────────────────────────────────────────────────
  void _paintCupcake(Canvas canvas, Size sz) {
    final icing = primaryColor ?? const Color(0xFF9C27B0);
    final u = _u(1, sz);

    // Wrapper
    final wrapper = Path()
      ..moveTo(_s(0.22, 0.54, sz).dx, _s(0.0, 0.54, sz).dy)
      ..lineTo(_s(0.28, 0.88, sz).dx, _s(0.0, 0.88, sz).dy)
      ..lineTo(_s(0.72, 0.88, sz).dx, _s(0.0, 0.88, sz).dy)
      ..lineTo(_s(0.78, 0.54, sz).dx, _s(0.0, 0.54, sz).dy)
      ..close();
    canvas.drawPath(wrapper, _fill(const Color(0xFFFFF9C4)));
    // Wrapper stripes
    for (int i = 0; i < 5; i++) {
      canvas.drawLine(
        _s(0.26 + i * 0.12, 0.54, sz),
        _s(0.30 + i * 0.10, 0.88, sz),
        _stroke(const Color(0xFFFFEB3B), u * 0.014),
      );
    }
    // Cake base
    canvas.drawOval(
      Rect.fromCenter(center: _s(0.50, 0.54, sz), width: sz.width * 0.56, height: sz.height * 0.10),
      _fill(const Color(0xFFE65100)),
    );
    // Icing swirl (3 decreasing circles)
    canvas.drawCircle(_s(0.50, 0.42, sz), u * 0.24, _fill(icing));
    canvas.drawCircle(_s(0.50, 0.34, sz), u * 0.17, _fill(icing));
    canvas.drawCircle(_s(0.50, 0.26, sz), u * 0.10, _fill(icing));
    // Cherry on top
    canvas.drawCircle(_s(0.50, 0.20, sz), u * 0.05, _fill(const Color(0xFFC62828)));
    // Sprinkles on icing
    for (final (sx, sy, col) in [
      (0.38, 0.44, Colors.red),
      (0.62, 0.40, Colors.yellow),
      (0.42, 0.36, Colors.blue),
      (0.58, 0.32, Colors.green),
    ]) {
      canvas.drawOval(
        Rect.fromCenter(center: _s(sx, sy, sz), width: u * 0.04, height: u * 0.015),
        _fill(col),
      );
    }
    // Shine
    _shine(canvas, _s(0.42, 0.36, sz), u * 0.24);
  }

  // ── Strawberry ─────────────────────────────────────────────────────────────
  void _paintStrawberry(Canvas canvas, Size sz) {
    final u = _u(1, sz);

    // Body
    final body = Path()
      ..moveTo(_s(0.50, 0.84, sz).dx, _s(0.0, 0.84, sz).dy)
      ..cubicTo(
        _s(0.20, 0.70, sz).dx, _s(0.0, 0.70, sz).dy,
        _s(0.16, 0.40, sz).dx, _s(0.0, 0.40, sz).dy,
        _s(0.34, 0.28, sz).dx, _s(0.0, 0.28, sz).dy,
      )
      ..cubicTo(
        _s(0.40, 0.22, sz).dx, _s(0.0, 0.22, sz).dy,
        _s(0.60, 0.22, sz).dx, _s(0.0, 0.22, sz).dy,
        _s(0.66, 0.28, sz).dx, _s(0.0, 0.28, sz).dy,
      )
      ..cubicTo(
        _s(0.84, 0.40, sz).dx, _s(0.0, 0.40, sz).dy,
        _s(0.80, 0.70, sz).dx, _s(0.0, 0.70, sz).dy,
        _s(0.50, 0.84, sz).dx, _s(0.0, 0.84, sz).dy,
      );
    canvas.drawPath(body, _fill(const Color(0xFFE53935)));
    // Seeds
    for (final (sx, sy) in [
      (0.40, 0.42), (0.56, 0.38), (0.36, 0.56),
      (0.52, 0.54), (0.64, 0.52), (0.44, 0.68), (0.58, 0.70),
    ]) {
      canvas.drawOval(
        Rect.fromCenter(center: _s(sx, sy, sz), width: u * 0.022, height: u * 0.030),
        _fill(const Color(0xFFFFF9C4)),
      );
    }
    // Leaves / hull
    for (final (lx, ly, tx, ty) in [
      (0.50, 0.28, 0.44, 0.12), (0.50, 0.28, 0.50, 0.08),
      (0.50, 0.28, 0.56, 0.12),
    ]) {
      final leaf = Path()
        ..moveTo(_s(lx - 0.06, ly, sz).dx, _s(0.0, ly, sz).dy)
        ..cubicTo(
          _s(tx, ty, sz).dx, _s(0.0, ty, sz).dy,
          _s(tx + 0.04, ty, sz).dx, _s(0.0, ty, sz).dy,
          _s(lx + 0.06, ly, sz).dx, _s(0.0, ly, sz).dy,
        )
        ..close();
      canvas.drawPath(leaf, _fill(const Color(0xFF43A047)));
    }
    _shine(canvas, _s(0.38, 0.44, sz), u * 0.5);
  }

  // ── Lollipop ───────────────────────────────────────────────────────────────
  void _paintLollipop(Canvas canvas, Size sz) {
    final base = primaryColor ?? const Color(0xFFE91E63);
    final u = _u(1, sz);

    // Stick
    canvas.drawLine(_s(0.50, 0.52, sz), _s(0.50, 0.92, sz),
        _stroke(const Color(0xFFBCAAA4), u * 0.04));
    // Candy circle
    canvas.drawCircle(_s(0.50, 0.36, sz), u * 0.30, _fill(base));
    // Swirl stripes
    for (int i = 0; i < 4; i++) {
      final angle = i * 1.5708;
      final swirlPath = Path()
        ..moveTo(_s(0.50, 0.36, sz).dx, _s(0.0, 0.36, sz).dy)
        ..arcTo(
          Rect.fromCenter(center: _s(0.50, 0.36, sz), width: u * 0.60, height: u * 0.60),
          angle, 1.3, false,
        );
      canvas.drawPath(swirlPath, _stroke(Colors.white.withOpacity(0.55), u * 0.060));
    }
    // Shine
    _shine(canvas, _s(0.38, 0.25, sz), u * 0.30);
    canvas.drawCircle(_s(0.38, 0.25, sz), u * 0.22 * 0.22,
        _fill(Colors.white.withOpacity(0.4)));
  }

  // ── Star ───────────────────────────────────────────────────────────────────
  void _paintStar(Canvas canvas, Size sz) {
    final base = primaryColor ?? const Color(0xFFFFD600);
    final u = _u(1, sz);

    final path = Path();
    for (int i = 0; i < 10; i++) {
      final angle = i * 3.14159 / 5 - 3.14159 / 2;
      final r = i.isEven ? u * 0.42 : u * 0.18;
      final x = _s(0.50, 0.50, sz).dx + r * _cos(angle);
      final y = _s(0.50, 0.50, sz).dy + r * _sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, _fill(base));
    canvas.drawPath(path, _stroke(_darken(base, 0.15), u * 0.020));
    _shine(canvas, _s(0.40, 0.36, sz), u * 0.42);
  }
}
