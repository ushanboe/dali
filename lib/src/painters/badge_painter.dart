import 'package:flutter/material.dart';
import '../models/effects_config.dart';

/// Paints an achievement badge. All drawing fits inside [Size].
class BadgePainter extends CustomPainter {
  final BadgeType type;
  final Color primaryColor;
  final Color? secondaryColor;
  final String? label;

  BadgePainter({
    required this.type,
    required this.primaryColor,
    this.secondaryColor,
    this.label,
  });

  @override
  void paint(Canvas canvas, Size size) {
    switch (type) {
      case BadgeType.star:    _paintStar(canvas, size);
      case BadgeType.trophy:  _paintTrophy(canvas, size);
      case BadgeType.ribbon:  _paintRibbon(canvas, size);
      case BadgeType.medal:   _paintMedal(canvas, size);
      case BadgeType.shield:  _paintShield(canvas, size);
      case BadgeType.crown:   _paintCrown(canvas, size);
      case BadgeType.heart:   _paintHeart(canvas, size);
      case BadgeType.diamond: _paintDiamond(canvas, size);
    }
    if (label != null && label!.isNotEmpty) _paintLabel(canvas, size);
  }

  @override
  bool shouldRepaint(BadgePainter old) =>
      old.type != type || old.primaryColor != primaryColor || old.label != label;

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

  double _approxCos(double a) {
    a = a % (2 * 3.14159265);
    double x = 1, term = 1;
    for (int i = 1; i <= 6; i++) {
      term *= -a * a / (2 * i * (2 * i - 1));
      x += term;
    }
    return x;
  }

  double _cos(double a) => _approxCos(a);
  double _sin(double a) => _approxCos(a - 1.5708);

  void _glow(Canvas canvas, Offset center, double r, Color col) {
    canvas.drawCircle(
      center, r * 1.3,
      Paint()
        ..shader = RadialGradient(colors: [
          col.withOpacity(0.35),
          col.withOpacity(0.12),
          Colors.transparent,
        ]).createShader(Rect.fromCircle(center: center, radius: r * 1.3)),
    );
  }

  void _paintLabel(Canvas canvas, Size sz) {
    final tp = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: Colors.white,
          fontSize: _u(0.11, sz),
          fontWeight: FontWeight.bold,
          shadows: [Shadow(color: Colors.black.withOpacity(0.5), blurRadius: 3)],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(
      sz.width / 2 - tp.width / 2,
      sz.height * 0.78,
    ));
  }

  void _starPath(Path path, Offset center, double outerR, double innerR, int points) {
    for (int i = 0; i < points * 2; i++) {
      final angle = i * 3.14159 / points - 3.14159 / 2;
      final r = i.isEven ? outerR : innerR;
      final x = center.dx + r * _cos(angle);
      final y = center.dy + r * _sin(angle);
      if (i == 0) path.moveTo(x, y); else path.lineTo(x, y);
    }
    path.close();
  }

  // ── Star Badge ─────────────────────────────────────────────────────────────
  void _paintStar(Canvas canvas, Size sz) {
    final gold = primaryColor;
    final dark = _darken(gold, 0.18);
    final light = _lighten(gold, 0.25);
    final u = _u(1, sz);
    final center = _s(0.50, 0.46, sz);

    _glow(canvas, center, u * 0.42, gold);

    // Outer burst ring
    final burstPath = Path();
    _starPath(burstPath, center, u * 0.44, u * 0.38, 16);
    canvas.drawPath(burstPath, _fill(dark.withOpacity(0.5)));

    // Main star
    final starPath = Path();
    _starPath(starPath, center, u * 0.40, u * 0.18, 5);
    canvas.drawPath(starPath, _fill(gold));
    canvas.drawPath(starPath, _stroke(dark, u * 0.016));

    // Shine
    final shinePath = Path();
    _starPath(shinePath, _s(0.43, 0.38, sz), u * 0.15, u * 0.07, 5);
    canvas.drawPath(shinePath, _fill(light.withOpacity(0.6)));

    // Centre dot
    canvas.drawCircle(center, u * 0.055, _fill(light));
  }

  // ── Trophy ─────────────────────────────────────────────────────────────────
  void _paintTrophy(Canvas canvas, Size sz) {
    final gold = primaryColor;
    final dark = _darken(gold, 0.18);
    final light = _lighten(gold, 0.22);
    final u = _u(1, sz);

    _glow(canvas, _s(0.50, 0.40, sz), u * 0.38, gold);

    // Handles
    for (final (hx, flip) in [(0.26, -1.0), (0.74, 1.0)]) {
      canvas.drawArc(
        Rect.fromCenter(center: _s(hx, 0.38, sz), width: u * 0.16, height: u * 0.28),
        flip > 0 ? -1.57 : 1.57, 3.14, false,
        _stroke(dark, u * 0.040),
      );
    }

    // Cup body
    final cup = Path()
      ..moveTo(_s(0.26, 0.18, sz).dx, _s(0.0, 0.18, sz).dy)
      ..lineTo(_s(0.74, 0.18, sz).dx, _s(0.0, 0.18, sz).dy)
      ..cubicTo(
        _s(0.76, 0.40, sz).dx, _s(0.0, 0.40, sz).dy,
        _s(0.68, 0.54, sz).dx, _s(0.0, 0.54, sz).dy,
        _s(0.57, 0.58, sz).dx, _s(0.0, 0.58, sz).dy,
      )
      ..lineTo(_s(0.43, 0.58, sz).dx, _s(0.0, 0.58, sz).dy)
      ..cubicTo(
        _s(0.32, 0.54, sz).dx, _s(0.0, 0.54, sz).dy,
        _s(0.24, 0.40, sz).dx, _s(0.0, 0.40, sz).dy,
        _s(0.26, 0.18, sz).dx, _s(0.0, 0.18, sz).dy,
      );
    canvas.drawPath(cup, _fill(gold));
    canvas.drawPath(cup, _stroke(dark, u * 0.016));

    // Stem
    canvas.drawRect(
      Rect.fromLTWH(_s(0.44, 0.58, sz).dx, _s(0.0, 0.58, sz).dy,
          sz.width * 0.12, sz.height * 0.16),
      _fill(dark),
    );
    // Base
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(_s(0.30, 0.74, sz).dx, _s(0.0, 0.74, sz).dy,
            sz.width * 0.40, sz.height * 0.08),
        Radius.circular(u * 0.025),
      ),
      _fill(dark),
    );

    // Star on cup
    final starPath = Path();
    _starPath(starPath, _s(0.50, 0.36, sz), u * 0.13, u * 0.06, 5);
    canvas.drawPath(starPath, _fill(light));

    // Shine on cup
    canvas.drawLine(_s(0.34, 0.22, sz), _s(0.38, 0.52, sz),
        _stroke(light.withOpacity(0.55), u * 0.030));
  }

  // ── Ribbon Badge ───────────────────────────────────────────────────────────
  void _paintRibbon(Canvas canvas, Size sz) {
    final base = primaryColor;
    final dark = _darken(base, 0.15);
    final light = _lighten(base, 0.2);
    final u = _u(1, sz);

    _glow(canvas, _s(0.50, 0.36, sz), u * 0.34, base);

    // Ribbon tails
    for (final (rx, flip) in [(0.36, -1.0), (0.64, 1.0)]) {
      final tail = Path()
        ..moveTo(_s(0.50, 0.62, sz).dx, _s(0.0, 0.62, sz).dy)
        ..lineTo(_s(rx, 0.90, sz).dx, _s(0.0, 0.90, sz).dy)
        ..lineTo(_s(rx + flip * 0.08, 0.78, sz).dx, _s(0.0, 0.78, sz).dy)
        ..lineTo(_s(0.50, 0.66, sz).dx, _s(0.0, 0.66, sz).dy)
        ..close();
      canvas.drawPath(tail, _fill(dark));
    }

    // Circle badge
    canvas.drawCircle(_s(0.50, 0.36, sz), u * 0.34, _fill(base));
    canvas.drawCircle(_s(0.50, 0.36, sz), u * 0.30, _fill(_lighten(base, 0.08)));
    canvas.drawCircle(_s(0.50, 0.36, sz), u * 0.34, _stroke(dark, u * 0.018));

    // "1st" text or star
    final starPath = Path();
    _starPath(starPath, _s(0.50, 0.36, sz), u * 0.20, u * 0.09, 5);
    canvas.drawPath(starPath, _fill(const Color(0xFFFFD600)));
    canvas.drawPath(starPath, _stroke(_darken(const Color(0xFFFFD600), 0.2), u * 0.012));

    // Shine
    canvas.drawCircle(_s(0.38, 0.26, sz), u * 0.08,
        _fill(Colors.white.withOpacity(0.35)));
  }

  // ── Medal ──────────────────────────────────────────────────────────────────
  void _paintMedal(Canvas canvas, Size sz) {
    final base = primaryColor;
    final dark = _darken(base, 0.15);
    final u = _u(1, sz);
    final ribbonColor = secondaryColor ?? const Color(0xFF1565C0);

    // Ribbon bar at top
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(_s(0.30, 0.10, sz).dx, _s(0.0, 0.10, sz).dy,
            sz.width * 0.40, sz.height * 0.24),
        Radius.circular(u * 0.02),
      ),
      _fill(ribbonColor),
    );
    // Ribbon stripe
    canvas.drawRect(
      Rect.fromLTWH(_s(0.44, 0.10, sz).dx, _s(0.0, 0.10, sz).dy,
          sz.width * 0.12, sz.height * 0.24),
      _fill(_lighten(ribbonColor, 0.2)),
    );
    // Chain link
    canvas.drawLine(_s(0.50, 0.34, sz), _s(0.50, 0.40, sz),
        _stroke(dark, u * 0.025));

    _glow(canvas, _s(0.50, 0.60, sz), u * 0.26, base);

    // Medal disc
    canvas.drawCircle(_s(0.50, 0.60, sz), u * 0.28, _fill(dark));
    canvas.drawCircle(_s(0.50, 0.60, sz), u * 0.24, _fill(base));

    // Inner ring
    canvas.drawCircle(_s(0.50, 0.60, sz), u * 0.18,
        _stroke(dark.withOpacity(0.4), u * 0.014));

    // Number 1
    final starPath = Path();
    _starPath(starPath, _s(0.50, 0.60, sz), u * 0.14, u * 0.06, 5);
    canvas.drawPath(starPath, _fill(Colors.white.withOpacity(0.9)));

    // Shine
    canvas.drawCircle(_s(0.41, 0.52, sz), u * 0.06,
        _fill(Colors.white.withOpacity(0.35)));
  }

  // ── Shield ─────────────────────────────────────────────────────────────────
  void _paintShield(Canvas canvas, Size sz) {
    final base = primaryColor;
    final dark = _darken(base, 0.15);
    final light = _lighten(base, 0.18);
    final u = _u(1, sz);

    _glow(canvas, _s(0.50, 0.46, sz), u * 0.40, base);

    // Shield outline (shadow)
    final shadowShield = Path()
      ..moveTo(_s(0.14, 0.16, sz).dx, _s(0.0, 0.16, sz).dy)
      ..lineTo(_s(0.86, 0.16, sz).dx, _s(0.0, 0.16, sz).dy)
      ..cubicTo(
        _s(0.88, 0.52, sz).dx, _s(0.0, 0.52, sz).dy,
        _s(0.70, 0.76, sz).dx, _s(0.0, 0.76, sz).dy,
        _s(0.50, 0.88, sz).dx, _s(0.0, 0.88, sz).dy,
      )
      ..cubicTo(
        _s(0.30, 0.76, sz).dx, _s(0.0, 0.76, sz).dy,
        _s(0.12, 0.52, sz).dx, _s(0.0, 0.52, sz).dy,
        _s(0.14, 0.16, sz).dx, _s(0.0, 0.16, sz).dy,
      )
      ..close();
    canvas.drawPath(shadowShield, _fill(dark.withOpacity(0.3)));
    canvas.translate(0, -u * 0.02);

    final shield = Path()
      ..moveTo(_s(0.14, 0.14, sz).dx, _s(0.0, 0.14, sz).dy)
      ..lineTo(_s(0.86, 0.14, sz).dx, _s(0.0, 0.14, sz).dy)
      ..cubicTo(
        _s(0.88, 0.50, sz).dx, _s(0.0, 0.50, sz).dy,
        _s(0.70, 0.74, sz).dx, _s(0.0, 0.74, sz).dy,
        _s(0.50, 0.86, sz).dx, _s(0.0, 0.86, sz).dy,
      )
      ..cubicTo(
        _s(0.30, 0.74, sz).dx, _s(0.0, 0.74, sz).dy,
        _s(0.12, 0.50, sz).dx, _s(0.0, 0.50, sz).dy,
        _s(0.14, 0.14, sz).dx, _s(0.0, 0.14, sz).dy,
      )
      ..close();
    canvas.drawPath(shield, _fill(base));
    canvas.drawPath(shield, _stroke(dark, u * 0.022));

    // Inner shield highlight
    final innerShield = Path()
      ..moveTo(_s(0.22, 0.20, sz).dx, _s(0.0, 0.20, sz).dy)
      ..lineTo(_s(0.78, 0.20, sz).dx, _s(0.0, 0.20, sz).dy)
      ..cubicTo(
        _s(0.80, 0.48, sz).dx, _s(0.0, 0.48, sz).dy,
        _s(0.66, 0.68, sz).dx, _s(0.0, 0.68, sz).dy,
        _s(0.50, 0.78, sz).dx, _s(0.0, 0.78, sz).dy,
      )
      ..cubicTo(
        _s(0.34, 0.68, sz).dx, _s(0.0, 0.68, sz).dy,
        _s(0.20, 0.48, sz).dx, _s(0.0, 0.48, sz).dy,
        _s(0.22, 0.20, sz).dx, _s(0.0, 0.20, sz).dy,
      )
      ..close();
    canvas.drawPath(innerShield, _fill(light.withOpacity(0.3)));

    // Star on shield
    final starPath = Path();
    _starPath(starPath, _s(0.50, 0.46, sz), u * 0.22, u * 0.10, 5);
    canvas.drawPath(starPath, _fill(const Color(0xFFFFD600)));
    canvas.drawPath(starPath, _stroke(_darken(const Color(0xFFFFD600), 0.2), u * 0.012));

    canvas.translate(0, u * 0.02);
  }

  // ── Crown ──────────────────────────────────────────────────────────────────
  void _paintCrown(Canvas canvas, Size sz) {
    final gold = primaryColor;
    final dark = _darken(gold, 0.18);
    final light = _lighten(gold, 0.22);
    final u = _u(1, sz);

    _glow(canvas, _s(0.50, 0.50, sz), u * 0.42, gold);

    // Crown body
    final crown = Path()
      ..moveTo(_s(0.10, 0.72, sz).dx, _s(0.0, 0.72, sz).dy)
      ..lineTo(_s(0.10, 0.38, sz).dx, _s(0.0, 0.38, sz).dy)
      ..lineTo(_s(0.28, 0.58, sz).dx, _s(0.0, 0.58, sz).dy)
      ..lineTo(_s(0.50, 0.22, sz).dx, _s(0.0, 0.22, sz).dy)
      ..lineTo(_s(0.72, 0.58, sz).dx, _s(0.0, 0.58, sz).dy)
      ..lineTo(_s(0.90, 0.38, sz).dx, _s(0.0, 0.38, sz).dy)
      ..lineTo(_s(0.90, 0.72, sz).dx, _s(0.0, 0.72, sz).dy)
      ..close();
    canvas.drawPath(crown, _fill(gold));
    canvas.drawPath(crown, _stroke(dark, u * 0.018));

    // Band
    canvas.drawRect(
      Rect.fromLTWH(_s(0.10, 0.64, sz).dx, _s(0.0, 0.64, sz).dy,
          sz.width * 0.80, sz.height * 0.10),
      _fill(dark.withOpacity(0.5)),
    );

    // Gems on tips
    const gemColors = [Color(0xFFE53935), Color(0xFF4FC3F7), Color(0xFFE53935)];
    for (int i = 0; i < 3; i++) {
      final gx = 0.28 + i * 0.22;
      final gy = i == 1 ? 0.20 : 0.56;
      canvas.drawCircle(_s(gx, gy, sz), u * 0.05, _fill(gemColors[i]));
      canvas.drawCircle(_s(gx - 0.01, gy - 0.015, sz), u * 0.018,
          _fill(Colors.white.withOpacity(0.6)));
    }

    // Shine
    canvas.drawLine(_s(0.18, 0.44, sz), _s(0.26, 0.70, sz),
        _stroke(light.withOpacity(0.5), u * 0.025));
  }

  // ── Heart Badge ────────────────────────────────────────────────────────────
  void _paintHeart(Canvas canvas, Size sz) {
    final base = primaryColor;
    final dark = _darken(base, 0.15);
    final light = _lighten(base, 0.22);
    final u = _u(1, sz);
    final center = _s(0.50, 0.46, sz);

    _glow(canvas, center, u * 0.40, base);

    // Heart shape
    final path = Path();
    path.moveTo(center.dx, center.dy + u * 0.28);
    path.cubicTo(
      center.dx - u * 0.48, center.dy - u * 0.12,
      center.dx - u * 0.48, center.dy - u * 0.42,
      center.dx, center.dy - u * 0.18,
    );
    path.cubicTo(
      center.dx + u * 0.48, center.dy - u * 0.42,
      center.dx + u * 0.48, center.dy - u * 0.12,
      center.dx, center.dy + u * 0.28,
    );
    canvas.drawPath(path, _fill(base));
    canvas.drawPath(path, _stroke(dark, u * 0.018));

    // Inner heart highlight
    final innerPath = Path();
    final ic = _s(0.42, 0.36, sz);
    innerPath.moveTo(ic.dx, ic.dy + u * 0.12);
    innerPath.cubicTo(
      ic.dx - u * 0.20, ic.dy - u * 0.05,
      ic.dx - u * 0.20, ic.dy - u * 0.18,
      ic.dx, ic.dy - u * 0.07,
    );
    innerPath.cubicTo(
      ic.dx + u * 0.20, ic.dy - u * 0.18,
      ic.dx + u * 0.20, ic.dy - u * 0.05,
      ic.dx, ic.dy + u * 0.12,
    );
    canvas.drawPath(innerPath, _fill(light.withOpacity(0.35)));

    // Shine
    canvas.drawCircle(_s(0.36, 0.30, sz), u * 0.07,
        _fill(Colors.white.withOpacity(0.45)));
  }

  // ── Diamond ────────────────────────────────────────────────────────────────
  void _paintDiamond(Canvas canvas, Size sz) {
    final base = primaryColor;
    final dark = _darken(base, 0.15);
    final light = _lighten(base, 0.25);
    final u = _u(1, sz);
    final center = _s(0.50, 0.50, sz);

    _glow(canvas, center, u * 0.42, base);

    // Diamond top (crown)
    final top = Path()
      ..moveTo(_s(0.50, 0.12, sz).dx, _s(0.0, 0.12, sz).dy)
      ..lineTo(_s(0.84, 0.38, sz).dx, _s(0.0, 0.38, sz).dy)
      ..lineTo(_s(0.16, 0.38, sz).dx, _s(0.0, 0.38, sz).dy)
      ..close();
    canvas.drawPath(top, _fill(light));

    // Diamond bottom (pavilion)
    final bottom = Path()
      ..moveTo(_s(0.16, 0.38, sz).dx, _s(0.0, 0.38, sz).dy)
      ..lineTo(_s(0.84, 0.38, sz).dx, _s(0.0, 0.38, sz).dy)
      ..lineTo(_s(0.50, 0.88, sz).dx, _s(0.0, 0.88, sz).dy)
      ..close();
    canvas.drawPath(bottom, _fill(base));

    // Facet lines
    canvas.drawLine(_s(0.50, 0.12, sz), _s(0.50, 0.88, sz),
        _stroke(dark.withOpacity(0.3), u * 0.010));
    canvas.drawLine(_s(0.16, 0.38, sz), _s(0.84, 0.38, sz),
        _stroke(dark.withOpacity(0.3), u * 0.010));
    canvas.drawLine(_s(0.50, 0.12, sz), _s(0.16, 0.38, sz),
        _stroke(dark.withOpacity(0.3), u * 0.010));
    canvas.drawLine(_s(0.50, 0.12, sz), _s(0.84, 0.38, sz),
        _stroke(dark.withOpacity(0.3), u * 0.010));

    // Centre facet
    final centre = Path()
      ..moveTo(_s(0.50, 0.22, sz).dx, _s(0.0, 0.22, sz).dy)
      ..lineTo(_s(0.68, 0.38, sz).dx, _s(0.0, 0.38, sz).dy)
      ..lineTo(_s(0.50, 0.58, sz).dx, _s(0.0, 0.58, sz).dy)
      ..lineTo(_s(0.32, 0.38, sz).dx, _s(0.0, 0.38, sz).dy)
      ..close();
    canvas.drawPath(centre, _fill(light.withOpacity(0.5)));

    // Outline
    final outline = Path()
      ..moveTo(_s(0.50, 0.12, sz).dx, _s(0.0, 0.12, sz).dy)
      ..lineTo(_s(0.84, 0.38, sz).dx, _s(0.0, 0.38, sz).dy)
      ..lineTo(_s(0.50, 0.88, sz).dx, _s(0.0, 0.88, sz).dy)
      ..lineTo(_s(0.16, 0.38, sz).dx, _s(0.0, 0.38, sz).dy)
      ..close();
    canvas.drawPath(outline, _stroke(dark, u * 0.018));

    // Top sparkle
    canvas.drawCircle(_s(0.42, 0.22, sz), u * 0.04,
        _fill(Colors.white.withOpacity(0.8)));
  }
}
