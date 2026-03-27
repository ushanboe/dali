import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/effects_config.dart';

/// Paints an achievement badge. All drawing fits inside [Size].
///
/// Style: bold cartoon — thick outlines, bright fills, simple highlight in top-left.
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
  double _w(double x, Size sz) => x * sz.width;
  double _h(double y, Size sz) => y * sz.height;
  Offset _p(double x, double y, Size sz) => Offset(x * sz.width, y * sz.height);
  double _u(double scale, Size sz) => sz.height * scale;

  Paint _fill(Color c) => Paint()..color = c..style = PaintingStyle.fill;
  Paint _stroke(Color c, double w) => Paint()
    ..color = c..style = PaintingStyle.stroke..strokeWidth = w
    ..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round;

  Color _darken(Color c, double amt) {
    final h = HSLColor.fromColor(c);
    return h.withLightness((h.lightness - amt).clamp(0.0, 1.0)).toColor();
  }

  Color _lighten(Color c, double amt) {
    final h = HSLColor.fromColor(c);
    return h.withLightness((h.lightness + amt).clamp(0.0, 1.0)).toColor();
  }

  double _cos(double a) => math.cos(a);
  double _sin(double a) => math.sin(a);

  void _paintLabel(Canvas canvas, Size sz) {
    final tp = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: Colors.white,
          fontSize: _u(0.10, sz),
          fontWeight: FontWeight.bold,
          shadows: [Shadow(color: Colors.black.withOpacity(0.5), blurRadius: 3)],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(
      sz.width / 2 - tp.width / 2,
      sz.height * 0.80,
    ));
  }

  /// N-point star centred at [center].
  void _starPath(Path path, Offset center, double outerR, double innerR, int n) {
    for (int i = 0; i < n * 2; i++) {
      final angle = i * 3.14159 / n - 3.14159 / 2;
      final r = i.isEven ? outerR : innerR;
      final x = center.dx + r * _cos(angle);
      final y = center.dy + r * _sin(angle);
      if (i == 0) path.moveTo(x, y); else path.lineTo(x, y);
    }
    path.close();
  }

  /// Simple top-left shine circle — gives cartoon 3-D feel.
  void _shine(Canvas canvas, Offset center, double r) {
    canvas.drawCircle(
      Offset(center.dx - r * 0.30, center.dy - r * 0.32),
      r * 0.22,
      _fill(Colors.white.withOpacity(0.55)),
    );
  }

  // ── Star ───────────────────────────────────────────────────────────────────
  // A large clean 5-point star with thick outline and shine.
  void _paintStar(Canvas canvas, Size sz) {
    final col  = primaryColor;
    final dark = _darken(col, 0.22);
    final lite = _lighten(col, 0.26);
    final u    = _u(1, sz);
    final c    = _p(0.50, 0.50, sz);

    final outer = u * 0.44;
    final inner = u * 0.19;

    // Thick dark outline (drawn slightly larger)
    final outline = Path();
    _starPath(outline, c, outer + u * 0.025, inner - u * 0.008, 5);
    canvas.drawPath(outline, _fill(dark));

    // Main fill
    final star = Path();
    _starPath(star, c, outer, inner, 5);
    canvas.drawPath(star, _fill(col));

    // Top-left facet highlight
    final hilite = Path();
    _starPath(hilite, Offset(c.dx - outer * 0.12, c.dy - outer * 0.14),
        outer * 0.44, inner * 0.44, 5);
    canvas.drawPath(hilite, _fill(lite.withOpacity(0.50)));

    // Shine dot
    _shine(canvas, c, outer);
  }

  // ── Trophy ─────────────────────────────────────────────────────────────────
  void _paintTrophy(Canvas canvas, Size sz) {
    final col  = primaryColor;
    final dark = _darken(col, 0.22);
    final lite = _lighten(col, 0.26);
    final u    = _u(1, sz);

    // ── Cup ──
    final cup = Path()
      ..moveTo(_w(0.22, sz), _h(0.14, sz))
      ..lineTo(_w(0.78, sz), _h(0.14, sz))
      ..cubicTo(_w(0.82, sz), _h(0.42, sz),
                _w(0.70, sz), _h(0.58, sz),
                _w(0.56, sz), _h(0.62, sz))
      ..lineTo(_w(0.44, sz), _h(0.62, sz))
      ..cubicTo(_w(0.30, sz), _h(0.58, sz),
                _w(0.18, sz), _h(0.42, sz),
                _w(0.22, sz), _h(0.14, sz))
      ..close();

    // Handles
    for (final side in [-1.0, 1.0]) {
      canvas.drawArc(
        Rect.fromCenter(
          center: Offset(_w(0.50, sz) + side * _w(0.27, sz), _h(0.34, sz)),
          width: u * 0.17, height: u * 0.32,
        ),
        side > 0 ? -1.57 : 1.57, 3.14, false,
        _stroke(dark, u * 0.048),
      );
    }

    // Cup shadow (offset down-right)
    final cupShadow = Path()
      ..moveTo(_w(0.24, sz), _h(0.16, sz))
      ..lineTo(_w(0.80, sz), _h(0.16, sz))
      ..cubicTo(_w(0.84, sz), _h(0.44, sz),
                _w(0.72, sz), _h(0.60, sz),
                _w(0.57, sz), _h(0.64, sz))
      ..lineTo(_w(0.45, sz), _h(0.64, sz))
      ..cubicTo(_w(0.31, sz), _h(0.60, sz),
                _w(0.20, sz), _h(0.44, sz),
                _w(0.24, sz), _h(0.16, sz))
      ..close();
    canvas.drawPath(cupShadow, _fill(dark.withOpacity(0.28)));
    canvas.drawPath(cup, _fill(col));
    canvas.drawPath(cup, _stroke(dark, u * 0.024));

    // Highlight stripe on left of cup
    canvas.drawLine(
      _p(0.32, 0.18, sz), _p(0.36, 0.58, sz),
      _stroke(lite.withOpacity(0.55), u * 0.032),
    );

    // Stem
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(_w(0.43, sz), _h(0.62, sz), _w(0.14, sz), _h(0.14, sz)),
        Radius.circular(u * 0.01),
      ),
      _fill(dark),
    );
    // Base
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(_w(0.26, sz), _h(0.76, sz), _w(0.48, sz), _h(0.10, sz)),
        Radius.circular(u * 0.03),
      ),
      _fill(dark),
    );

    // Star on cup
    final starPath = Path();
    _starPath(starPath, _p(0.50, 0.37, sz), u * 0.14, u * 0.062, 5);
    canvas.drawPath(starPath, _fill(lite));
  }

  // ── Ribbon ─────────────────────────────────────────────────────────────────
  void _paintRibbon(Canvas canvas, Size sz) {
    final col  = primaryColor;
    final dark = _darken(col, 0.22);
    final u    = _u(1, sz);
    final cc   = _p(0.50, 0.36, sz);

    // Ribbon tails — drawn before circle so they sit behind
    for (final side in [-1.0, 1.0]) {
      final tail = Path()
        ..moveTo(_w(0.50, sz), _h(0.64, sz))
        ..lineTo(_w(0.50 + side * 0.28, sz), _h(0.94, sz))
        ..lineTo(_w(0.50 + side * 0.12, sz), _h(0.80, sz))
        ..lineTo(_w(0.50, sz), _h(0.68, sz))
        ..close();
      canvas.drawPath(tail, _fill(dark));
    }

    // Circle background (shadow)
    canvas.drawCircle(
        Offset(cc.dx + u * 0.015, cc.dy + u * 0.020), u * 0.36,
        _fill(dark.withOpacity(0.30)));

    // Circle fill
    canvas.drawCircle(cc, u * 0.36, _fill(col));
    // Inner ring
    canvas.drawCircle(cc, u * 0.29, _fill(_lighten(col, 0.10)));
    // Outline
    canvas.drawCircle(cc, u * 0.36, _stroke(dark, u * 0.024));

    // "1st" star
    final starPath = Path();
    _starPath(starPath, cc, u * 0.20, u * 0.09, 5);
    canvas.drawPath(starPath, _fill(const Color(0xFFFFD600)));
    canvas.drawPath(starPath,
        _stroke(_darken(const Color(0xFFFFD600), 0.24), u * 0.014));

    _shine(canvas, cc, u * 0.36);
  }

  // ── Medal ──────────────────────────────────────────────────────────────────
  void _paintMedal(Canvas canvas, Size sz) {
    final col     = primaryColor;
    final dark    = _darken(col, 0.22);
    final ribCol  = secondaryColor ?? const Color(0xFF1565C0);
    final u       = _u(1, sz);
    final dc      = _p(0.50, 0.63, sz);

    // Ribbon bar
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(_w(0.28, sz), _h(0.08, sz), _w(0.44, sz), _h(0.24, sz)),
        Radius.circular(u * 0.02),
      ),
      _fill(ribCol),
    );
    // Centre stripe
    canvas.drawRect(
      Rect.fromLTWH(_w(0.43, sz), _h(0.08, sz), _w(0.14, sz), _h(0.24, sz)),
      _fill(_lighten(ribCol, 0.22)),
    );
    // Chain link
    canvas.drawLine(_p(0.50, 0.32, sz), _p(0.50, 0.39, sz),
        _stroke(dark, u * 0.028));

    // Disc shadow
    canvas.drawCircle(
        Offset(dc.dx + u * 0.015, dc.dy + u * 0.020), u * 0.29,
        _fill(dark.withOpacity(0.28)));
    // Disc outer ring
    canvas.drawCircle(dc, u * 0.29, _fill(dark));
    // Disc inner
    canvas.drawCircle(dc, u * 0.24, _fill(col));

    // Star on disc
    final starPath = Path();
    _starPath(starPath, dc, u * 0.15, u * 0.066, 5);
    canvas.drawPath(starPath, _fill(Colors.white.withOpacity(0.95)));

    _shine(canvas, dc, u * 0.29);
  }

  // ── Shield ─────────────────────────────────────────────────────────────────
  void _paintShield(Canvas canvas, Size sz) {
    final col  = primaryColor;
    final dark = _darken(col, 0.22);
    final lite = _lighten(col, 0.22);
    final u    = _u(1, sz);

    Path buildShield(double ox, double oy) {
      return Path()
        ..moveTo(_w(0.14, sz) + ox, _h(0.12, sz) + oy)
        ..lineTo(_w(0.86, sz) + ox, _h(0.12, sz) + oy)
        ..cubicTo(
          _w(0.88, sz) + ox, _h(0.50, sz) + oy,
          _w(0.70, sz) + ox, _h(0.76, sz) + oy,
          _w(0.50, sz) + ox, _h(0.90, sz) + oy,
        )
        ..cubicTo(
          _w(0.30, sz) + ox, _h(0.76, sz) + oy,
          _w(0.12, sz) + ox, _h(0.50, sz) + oy,
          _w(0.14, sz) + ox, _h(0.12, sz) + oy,
        )
        ..close();
    }

    // Shadow
    canvas.drawPath(buildShield(u * 0.015, u * 0.020), _fill(dark.withOpacity(0.28)));
    // Fill
    canvas.drawPath(buildShield(0, 0), _fill(col));
    // Inner lighter area
    canvas.drawPath(
      Path()
        ..moveTo(_w(0.22, sz), _h(0.20, sz))
        ..lineTo(_w(0.78, sz), _h(0.20, sz))
        ..cubicTo(_w(0.80, sz), _h(0.50, sz), _w(0.66, sz), _h(0.70, sz),
            _w(0.50, sz), _h(0.82, sz))
        ..cubicTo(_w(0.34, sz), _h(0.70, sz), _w(0.20, sz), _h(0.50, sz),
            _w(0.22, sz), _h(0.20, sz))
        ..close(),
      _fill(lite.withOpacity(0.28)),
    );
    // Outline
    canvas.drawPath(buildShield(0, 0), _stroke(dark, u * 0.028));

    // Star on shield
    final starPath = Path();
    _starPath(starPath, _p(0.50, 0.50, sz), u * 0.24, u * 0.11, 5);
    canvas.drawPath(starPath, _fill(const Color(0xFFFFD600)));
    canvas.drawPath(starPath,
        _stroke(_darken(const Color(0xFFFFD600), 0.24), u * 0.014));

    _shine(canvas, _p(0.50, 0.50, sz), u * 0.40);
  }

  // ── Crown ──────────────────────────────────────────────────────────────────
  void _paintCrown(Canvas canvas, Size sz) {
    final col  = primaryColor;
    final dark = _darken(col, 0.22);
    final lite = _lighten(col, 0.26);
    final u    = _u(1, sz);

    Path buildCrown(double ox, double oy) {
      return Path()
        ..moveTo(_w(0.08, sz) + ox, _h(0.76, sz) + oy)
        ..lineTo(_w(0.08, sz) + ox, _h(0.36, sz) + oy)
        ..lineTo(_w(0.30, sz) + ox, _h(0.58, sz) + oy)
        ..lineTo(_w(0.50, sz) + ox, _h(0.18, sz) + oy)
        ..lineTo(_w(0.70, sz) + ox, _h(0.58, sz) + oy)
        ..lineTo(_w(0.92, sz) + ox, _h(0.36, sz) + oy)
        ..lineTo(_w(0.92, sz) + ox, _h(0.76, sz) + oy)
        ..close();
    }

    // Shadow
    canvas.drawPath(buildCrown(u * 0.015, u * 0.020), _fill(dark.withOpacity(0.28)));
    // Fill
    canvas.drawPath(buildCrown(0, 0), _fill(col));
    // Band
    canvas.drawRect(
      Rect.fromLTWH(_w(0.08, sz), _h(0.64, sz), _w(0.84, sz), _h(0.12, sz)),
      _fill(dark.withOpacity(0.40)),
    );
    // Outline
    canvas.drawPath(buildCrown(0, 0), _stroke(dark, u * 0.026));

    // Gems: left, top, right
    const gc = [Color(0xFFE53935), Color(0xFF29B6F6), Color(0xFFE53935)];
    final gp = [_p(0.30, 0.56, sz), _p(0.50, 0.16, sz), _p(0.70, 0.56, sz)];
    for (int i = 0; i < 3; i++) {
      canvas.drawCircle(gp[i], u * 0.062, _fill(gc[i]));
      canvas.drawCircle(gp[i], u * 0.062, _stroke(dark, u * 0.012));
      canvas.drawCircle(
          Offset(gp[i].dx - u * 0.016, gp[i].dy - u * 0.020),
          u * 0.022, _fill(Colors.white.withOpacity(0.65)));
    }

    // Highlight stripe on left panel
    canvas.drawLine(
      _p(0.16, 0.42, sz), _p(0.22, 0.72, sz),
      _stroke(lite.withOpacity(0.50), u * 0.026),
    );
  }

  // ── Heart ──────────────────────────────────────────────────────────────────
  void _paintHeart(Canvas canvas, Size sz) {
    final col  = primaryColor;
    final dark = _darken(col, 0.22);
    final lite = _lighten(col, 0.26);
    final u    = _u(1, sz);
    final c    = _p(0.50, 0.50, sz);

    Path buildHeart(double ox, double oy) {
      final path = Path();
      path.moveTo(c.dx + ox, c.dy + u * 0.32 + oy);
      path.cubicTo(
        c.dx - u * 0.52 + ox, c.dy - u * 0.10 + oy,
        c.dx - u * 0.52 + ox, c.dy - u * 0.46 + oy,
        c.dx + ox,             c.dy - u * 0.20 + oy,
      );
      path.cubicTo(
        c.dx + u * 0.52 + ox, c.dy - u * 0.46 + oy,
        c.dx + u * 0.52 + ox, c.dy - u * 0.10 + oy,
        c.dx + ox,             c.dy + u * 0.32 + oy,
      );
      return path;
    }

    // Shadow
    canvas.drawPath(buildHeart(u * 0.015, u * 0.020), _fill(dark.withOpacity(0.28)));
    // Fill
    canvas.drawPath(buildHeart(0, 0), _fill(col));
    // Outline
    canvas.drawPath(buildHeart(0, 0), _stroke(dark, u * 0.026));

    // Inner highlight (smaller heart, top-left)
    final ic = Offset(c.dx - u * 0.10, c.dy - u * 0.08);
    final innerPath = Path();
    innerPath.moveTo(ic.dx, ic.dy + u * 0.14);
    innerPath.cubicTo(
      ic.dx - u * 0.22, ic.dy - u * 0.04,
      ic.dx - u * 0.22, ic.dy - u * 0.20,
      ic.dx,             ic.dy - u * 0.08,
    );
    innerPath.cubicTo(
      ic.dx + u * 0.22, ic.dy - u * 0.20,
      ic.dx + u * 0.22, ic.dy - u * 0.04,
      ic.dx,             ic.dy + u * 0.14,
    );
    canvas.drawPath(innerPath, _fill(lite.withOpacity(0.40)));

    _shine(canvas, c, u * 0.46);
  }

  // ── Diamond ────────────────────────────────────────────────────────────────
  void _paintDiamond(Canvas canvas, Size sz) {
    final col  = primaryColor;
    final dark = _darken(col, 0.22);
    final lite = _lighten(col, 0.28);
    final u    = _u(1, sz);

    final top    = _p(0.50, 0.10, sz);
    final left   = _p(0.08, 0.40, sz);
    final right  = _p(0.92, 0.40, sz);
    final bottom = _p(0.50, 0.92, sz);
    final mid    = _h(0.40, sz);

    // Shadow
    final shadowPath = Path()
      ..moveTo(top.dx + u * 0.015, top.dy + u * 0.020)
      ..lineTo(right.dx + u * 0.015, right.dy + u * 0.020)
      ..lineTo(bottom.dx + u * 0.015, bottom.dy + u * 0.020)
      ..lineTo(left.dx + u * 0.015, left.dy + u * 0.020)
      ..close();
    canvas.drawPath(shadowPath, _fill(dark.withOpacity(0.28)));

    // Crown (top half — lighter)
    final crown = Path()
      ..moveTo(top.dx, top.dy)
      ..lineTo(right.dx, mid)
      ..lineTo(left.dx, mid)
      ..close();
    canvas.drawPath(crown, _fill(lite));

    // Pavilion (bottom half)
    final pavilion = Path()
      ..moveTo(left.dx, mid)
      ..lineTo(right.dx, mid)
      ..lineTo(bottom.dx, bottom.dy)
      ..close();
    canvas.drawPath(pavilion, _fill(col));

    // Facet lines
    final fp = _stroke(dark.withOpacity(0.40), u * 0.012);
    canvas.drawLine(top, bottom, fp);
    canvas.drawLine(left, right, fp);
    canvas.drawLine(top, left, fp);
    canvas.drawLine(top, right, fp);

    // Centre facet highlight
    final cf = Path()
      ..moveTo(_w(0.50, sz), _h(0.20, sz))
      ..lineTo(_w(0.70, sz), mid)
      ..lineTo(_w(0.50, sz), _h(0.60, sz))
      ..lineTo(_w(0.30, sz), mid)
      ..close();
    canvas.drawPath(cf, _fill(lite.withOpacity(0.55)));

    // Outline
    final outline = Path()
      ..moveTo(top.dx, top.dy)
      ..lineTo(right.dx, mid)
      ..lineTo(bottom.dx, bottom.dy)
      ..lineTo(left.dx, mid)
      ..close();
    canvas.drawPath(outline, _stroke(dark, u * 0.024));

    // Sparkle highlight
    canvas.drawCircle(
        Offset(_w(0.38, sz), _h(0.20, sz)), u * 0.046,
        _fill(Colors.white.withOpacity(0.80)));
  }
}
