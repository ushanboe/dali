import 'package:flutter/material.dart';
import '../models/avatar_config.dart';

/// Paints hair in normalised 1.0 × 1.0 space.
///
/// Head reference (from BodyPainter):
///   Center (0.50, 0.22), width 0.38, height 0.36
///   Top y ≈ 0.04  |  Chin y ≈ 0.40  |  Ears at x ≈ 0.31 / 0.69
///
/// Two-pass rendering (DaliAvatar):
///   Pass 1 — clip y > 0.15 → sides / back (behind body)
///   Pass 2 — clip y < 0.28 → crown cap (on top of body)
///
/// Design rule: crown cap is a SOLID filled shape so no scalp shows through.
/// Hairline sits at y ≈ 0.13 (upper forehead).
class HairPainter extends CustomPainter {
  final AvatarConfig config;
  HairPainter(this.config);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    double sw(double x) => x * w;
    double sh(double y) => y * h;
    Offset s(double x, double y) => Offset(x * w, y * h);

    final base = Paint()..color = config.hair.color;
    final hi = Paint()
      ..color = config.hair.highlightColor.withOpacity(0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = sw(0.014)
      ..strokeCap = StrokeCap.round;

    switch (config.hair.style) {
      case HairStyle.shortStraight:  _shortStraight(canvas, s, sw, sh, base, hi);
      case HairStyle.shortCurly:     _shortCurly(canvas, s, sw, sh, base, hi);
      case HairStyle.mediumStraight: _mediumStraight(canvas, s, sw, sh, base, hi);
      case HairStyle.mediumWavy:     _mediumWavy(canvas, s, sw, sh, base, hi);
      case HairStyle.longStraight:   _longStraight(canvas, s, sw, sh, base, hi);
      case HairStyle.longCurly:      _longCurly(canvas, s, sw, sh, base, hi);
      case HairStyle.bob:            _bob(canvas, s, sw, sh, base, hi);
      case HairStyle.ponytail:       _ponytail(canvas, s, sw, sh, base, hi);
      case HairStyle.bun:            _bun(canvas, s, sw, sh, base, hi);
      case HairStyle.braids:         _braids(canvas, s, sw, sh, base, hi);
      case HairStyle.afro:           _afro(canvas, s, sw, sh, base, hi);
      case HairStyle.pixie:          _pixie(canvas, s, sw, sh, base, hi);
    }
  }

  @override
  bool shouldRepaint(HairPainter old) => old.config.hair != config.hair;

  // ── Shared cap builder ────────────────────────────────────────────────────
  /// Solid crown: left side up to hairline, crown arc, right side down.
  /// Returns an open path — caller closes/continues the bottom.
  Path _capPath(
    double Function(double) sw,
    double Function(double) sh, {
    double leftX = 0.28,
    double rightX = 0.72,
    double crownY = 0.01,
    double hairlineY = 0.13,
    double sideBottomY = 0.26,
  }) {
    final path = Path();
    path.moveTo(sw(leftX), sh(sideBottomY));
    path.lineTo(sw(leftX), sh(hairlineY));
    path.cubicTo(
      sw(leftX - 0.02), sh(hairlineY - 0.06),
      sw(leftX),        sh(crownY + 0.02),
      sw(0.50),         sh(crownY),
    );
    path.cubicTo(
      sw(rightX),        sh(crownY + 0.02),
      sw(rightX + 0.02), sh(hairlineY - 0.06),
      sw(rightX),        sh(hairlineY),
    );
    path.lineTo(sw(rightX), sh(sideBottomY));
    return path;
  }

  // ── Short Straight ────────────────────────────────────────────────────────
  void _shortStraight(
    Canvas canvas,
    Offset Function(double, double) s,
    double Function(double) sw,
    double Function(double) sh,
    Paint base,
    Paint hi,
  ) {
    final path = _capPath(sw, sh,
        leftX: 0.28, rightX: 0.72, crownY: 0.01, hairlineY: 0.13, sideBottomY: 0.27);
    path.lineTo(sw(0.28), sh(0.27));
    path.close();
    canvas.drawPath(path, base);
    canvas.drawLine(s(0.38, 0.04), s(0.38, 0.26), hi);
    canvas.drawLine(s(0.50, 0.02), s(0.50, 0.26), hi);
    canvas.drawLine(s(0.62, 0.04), s(0.62, 0.26), hi);
  }

  // ── Short Curly ───────────────────────────────────────────────────────────
  void _shortCurly(
    Canvas canvas,
    Offset Function(double, double) s,
    double Function(double) sw,
    double Function(double) sh,
    Paint base,
    Paint hi,
  ) {
    final path = Path();
    path.moveTo(sw(0.28), sh(0.27));
    path.lineTo(sw(0.28), sh(0.15));
    path.cubicTo(sw(0.26), sh(0.09), sw(0.28), sh(0.04), sw(0.34), sh(0.04));
    path.cubicTo(sw(0.38), sh(0.01), sw(0.44), sh(0.00), sw(0.50), sh(0.01));
    path.cubicTo(sw(0.56), sh(0.00), sw(0.62), sh(0.01), sw(0.66), sh(0.04));
    path.cubicTo(sw(0.72), sh(0.04), sw(0.74), sh(0.09), sw(0.72), sh(0.15));
    path.lineTo(sw(0.72), sh(0.27));
    path.lineTo(sw(0.28), sh(0.27));
    path.close();
    canvas.drawPath(path, base);
    for (final cx in [0.38, 0.50, 0.62]) {
      canvas.drawArc(
        Rect.fromCenter(center: s(cx, 0.08), width: sw(0.08), height: sh(0.07)),
        -2.5, 2.5, false, hi,
      );
    }
  }

  // ── Medium Straight ───────────────────────────────────────────────────────
  void _mediumStraight(
    Canvas canvas,
    Offset Function(double, double) s,
    double Function(double) sw,
    double Function(double) sh,
    Paint base,
    Paint hi,
  ) {
    final path = _capPath(sw, sh,
        leftX: 0.26, rightX: 0.74, crownY: 0.01, hairlineY: 0.13, sideBottomY: 0.48);
    path.lineTo(sw(0.26), sh(0.48));
    path.close();
    canvas.drawPath(path, base);
    canvas.drawLine(s(0.38, 0.04), s(0.38, 0.48), hi);
    canvas.drawLine(s(0.50, 0.02), s(0.50, 0.48), hi);
    canvas.drawLine(s(0.62, 0.04), s(0.62, 0.48), hi);
  }

  // ── Medium Wavy ───────────────────────────────────────────────────────────
  void _mediumWavy(
    Canvas canvas,
    Offset Function(double, double) s,
    double Function(double) sw,
    double Function(double) sh,
    Paint base,
    Paint hi,
  ) {
    final path = _capPath(sw, sh,
        leftX: 0.26, rightX: 0.74, crownY: 0.01, hairlineY: 0.13, sideBottomY: 0.48);
    path.cubicTo(sw(0.72), sh(0.46), sw(0.68), sh(0.50), sw(0.64), sh(0.46));
    path.cubicTo(sw(0.60), sh(0.42), sw(0.56), sh(0.50), sw(0.50), sh(0.46));
    path.cubicTo(sw(0.44), sh(0.42), sw(0.40), sh(0.50), sw(0.36), sh(0.46));
    path.cubicTo(sw(0.32), sh(0.42), sw(0.28), sh(0.46), sw(0.26), sh(0.48));
    path.close();
    canvas.drawPath(path, base);
    canvas.drawLine(s(0.38, 0.04), s(0.40, 0.46), hi);
    canvas.drawLine(s(0.50, 0.02), s(0.50, 0.46), hi);
    canvas.drawLine(s(0.62, 0.04), s(0.60, 0.46), hi);
  }

  // ── Long Straight ─────────────────────────────────────────────────────────
  void _longStraight(
    Canvas canvas,
    Offset Function(double, double) s,
    double Function(double) sw,
    double Function(double) sh,
    Paint base,
    Paint hi,
  ) {
    final path = _capPath(sw, sh,
        leftX: 0.26, rightX: 0.74, crownY: 0.01, hairlineY: 0.13, sideBottomY: 0.72);
    path.lineTo(sw(0.26), sh(0.72));
    path.close();
    canvas.drawPath(path, base);
    canvas.drawLine(s(0.38, 0.04), s(0.38, 0.72), hi);
    canvas.drawLine(s(0.50, 0.02), s(0.50, 0.72), hi);
    canvas.drawLine(s(0.62, 0.04), s(0.62, 0.72), hi);
  }

  // ── Long Curly ────────────────────────────────────────────────────────────
  void _longCurly(
    Canvas canvas,
    Offset Function(double, double) s,
    double Function(double) sw,
    double Function(double) sh,
    Paint base,
    Paint hi,
  ) {
    final path = Path();
    path.moveTo(sw(0.22), sh(0.70));
    path.cubicTo(sw(0.16), sh(0.55), sw(0.20), sh(0.30), sw(0.26), sh(0.13));
    path.cubicTo(sw(0.24), sh(0.05), sw(0.28), sh(0.01), sw(0.50), sh(0.01));
    path.cubicTo(sw(0.72), sh(0.01), sw(0.76), sh(0.05), sw(0.74), sh(0.13));
    path.cubicTo(sw(0.80), sh(0.30), sw(0.84), sh(0.55), sw(0.78), sh(0.70));
    path.cubicTo(sw(0.80), sh(0.64), sw(0.76), sh(0.58), sw(0.74), sh(0.64));
    path.cubicTo(sw(0.72), sh(0.70), sw(0.68), sh(0.64), sw(0.64), sh(0.68));
    path.lineTo(sw(0.36), sh(0.68));
    path.cubicTo(sw(0.32), sh(0.64), sw(0.28), sh(0.70), sw(0.26), sh(0.64));
    path.cubicTo(sw(0.24), sh(0.58), sw(0.20), sh(0.64), sw(0.22), sh(0.70));
    path.close();
    canvas.drawPath(path, base);
    for (final rec in [
      (0.34, 0.52, 0.05), (0.50, 0.58, 0.05), (0.66, 0.52, 0.05),
      (0.28, 0.36, 0.04), (0.72, 0.36, 0.04),
    ]) {
      final cx = rec.$1; final cy = rec.$2; final r = rec.$3;
      canvas.drawArc(
        Rect.fromCenter(center: s(cx, cy), width: sw(r * 2), height: sh(r * 2)),
        -2.2, 2.2, false, hi,
      );
    }
  }

  // ── Bob ───────────────────────────────────────────────────────────────────
  void _bob(
    Canvas canvas,
    Offset Function(double, double) s,
    double Function(double) sw,
    double Function(double) sh,
    Paint base,
    Paint hi,
  ) {
    final path = Path();
    path.moveTo(sw(0.24), sh(0.42));
    path.cubicTo(sw(0.22), sh(0.34), sw(0.24), sh(0.18), sw(0.28), sh(0.13));
    path.cubicTo(sw(0.26), sh(0.05), sw(0.30), sh(0.01), sw(0.50), sh(0.01));
    path.cubicTo(sw(0.70), sh(0.01), sw(0.74), sh(0.05), sw(0.72), sh(0.13));
    path.cubicTo(sw(0.76), sh(0.18), sw(0.78), sh(0.34), sw(0.76), sh(0.42));
    path.cubicTo(sw(0.74), sh(0.44), sw(0.64), sh(0.46), sw(0.54), sh(0.44));
    path.quadraticBezierTo(sw(0.50), sh(0.43), sw(0.46), sh(0.44));
    path.cubicTo(sw(0.36), sh(0.46), sw(0.26), sh(0.44), sw(0.24), sh(0.42));
    path.close();
    canvas.drawPath(path, base);
    canvas.drawLine(s(0.38, 0.04), s(0.34, 0.44), hi);
    canvas.drawLine(s(0.50, 0.02), s(0.50, 0.44), hi);
    canvas.drawLine(s(0.62, 0.04), s(0.66, 0.44), hi);
  }

  // ── Ponytail ──────────────────────────────────────────────────────────────
  void _ponytail(
    Canvas canvas,
    Offset Function(double, double) s,
    double Function(double) sw,
    double Function(double) sh,
    Paint base,
    Paint hi,
  ) {
    // Tail drawn first — shows behind the head via Pass 1
    final tail = Path();
    tail.moveTo(sw(0.46), sh(0.20));
    tail.cubicTo(sw(0.40), sh(0.32), sw(0.38), sh(0.50), sw(0.42), sh(0.66));
    tail.cubicTo(sw(0.44), sh(0.74), sw(0.56), sh(0.74), sw(0.58), sh(0.66));
    tail.cubicTo(sw(0.62), sh(0.50), sw(0.60), sh(0.32), sw(0.54), sh(0.20));
    tail.close();
    canvas.drawPath(tail, base);
    canvas.drawLine(s(0.50, 0.22), s(0.50, 0.72), hi);

    // Tight crown cap
    final cap = _capPath(sw, sh,
        leftX: 0.30, rightX: 0.70, crownY: 0.01, hairlineY: 0.13, sideBottomY: 0.24);
    cap.cubicTo(sw(0.66), sh(0.22), sw(0.56), sh(0.20), sw(0.50), sh(0.20));
    cap.cubicTo(sw(0.44), sh(0.20), sw(0.34), sh(0.22), sw(0.30), sh(0.24));
    cap.close();
    canvas.drawPath(cap, base);

    // Hair tie
    final tiePaint = Paint()
      ..color = _darken(base.color, 0.28)..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(center: s(0.50, 0.20), width: sw(0.14), height: sh(0.06)),
      tiePaint,
    );
    canvas.drawLine(s(0.42, 0.04), s(0.40, 0.20), hi);
  }

  // ── Bun ───────────────────────────────────────────────────────────────────
  void _bun(
    Canvas canvas,
    Offset Function(double, double) s,
    double Function(double) sw,
    double Function(double) sh,
    Paint base,
    Paint hi,
  ) {
    // Tight crown cap (hair gathered upward)
    final cap = _capPath(sw, sh,
        leftX: 0.30, rightX: 0.70, crownY: 0.08, hairlineY: 0.14, sideBottomY: 0.28);
    cap.lineTo(sw(0.30), sh(0.28));
    cap.close();
    canvas.drawPath(cap, base);

    // Bun on top of head
    canvas.drawOval(
      Rect.fromCenter(center: s(0.50, 0.04), width: sw(0.24), height: sh(0.14)),
      base,
    );
    canvas.drawArc(
      Rect.fromCenter(center: s(0.50, 0.04), width: sw(0.22), height: sh(0.12)),
      0.5, 2.5, false, hi,
    );
    canvas.drawOval(
      Rect.fromCenter(center: s(0.45, 0.02), width: sw(0.08), height: sh(0.05)),
      Paint()..color = hi.color..style = PaintingStyle.fill,
    );
    canvas.drawLine(s(0.42, 0.10), s(0.44, 0.27), hi);
  }

  // ── Braids ────────────────────────────────────────────────────────────────
  void _braids(
    Canvas canvas,
    Offset Function(double, double) s,
    double Function(double) sw,
    double Function(double) sh,
    Paint base,
    Paint hi,
  ) {
    final cap = _capPath(sw, sh,
        leftX: 0.30, rightX: 0.70, crownY: 0.01, hairlineY: 0.13, sideBottomY: 0.24);
    cap.lineTo(sw(0.30), sh(0.24));
    cap.close();
    canvas.drawPath(cap, base);

    canvas.drawLine(s(0.50, 0.03), s(0.50, 0.22),
        Paint()
          ..color = _darken(base.color, 0.25)
          ..strokeWidth = sw(0.012)
          ..style = PaintingStyle.stroke);

    _drawBraid(canvas, s, sw, sh, base, hi, 0.38, 0.22, 0.72);
    _drawBraid(canvas, s, sw, sh, base, hi, 0.62, 0.22, 0.72);
  }

  void _drawBraid(
    Canvas canvas,
    Offset Function(double, double) s,
    double Function(double) sw,
    double Function(double) sh,
    Paint base,
    Paint hi,
    double bx,
    double startY,
    double endY,
  ) {
    const segs = 8;
    final strand = Paint()
      ..color = base.color..style = PaintingStyle.stroke..strokeWidth = sw(0.042);
    final cross = Paint()
      ..color = _darken(base.color, 0.18)
      ..style = PaintingStyle.stroke..strokeWidth = sw(0.014);

    for (int i = 0; i < segs; i++) {
      final t1 = i / segs;
      final t2 = (i + 1) / segs;
      final y1 = startY + (endY - startY) * t1;
      final y2 = startY + (endY - startY) * t2;
      final xOff = 0.022 * (i.isEven ? 1 : -1);
      canvas.drawLine(s(bx + xOff, y1), s(bx - xOff, y2), strand);
      canvas.drawLine(s(bx + xOff * 0.5, y1), s(bx - xOff * 0.5, y2), cross);
    }
    canvas.drawOval(
      Rect.fromCenter(
          center: s(bx, endY + 0.01), width: sw(0.042), height: sh(0.024)),
      Paint()..color = _darken(base.color, 0.3),
    );
  }

  // ── Afro ──────────────────────────────────────────────────────────────────
  void _afro(
    Canvas canvas,
    Offset Function(double, double) s,
    double Function(double) sw,
    double Function(double) sh,
    Paint base,
    Paint hi,
  ) {
    final blobs = [
      (0.50, 0.10, 0.38, 0.44),
      (0.32, 0.14, 0.22, 0.30),
      (0.68, 0.14, 0.22, 0.30),
      (0.22, 0.22, 0.16, 0.24),
      (0.78, 0.22, 0.16, 0.24),
      (0.40, 0.04, 0.22, 0.18),
      (0.60, 0.04, 0.22, 0.18),
      (0.50, 0.00, 0.18, 0.14),
    ];
    for (final b in blobs) {
      canvas.drawOval(
        Rect.fromCenter(
            center: s(b.$1, b.$2), width: sw(b.$3), height: sh(b.$4)),
        base,
      );
    }
    canvas.drawOval(
      Rect.fromCenter(center: s(0.42, 0.06), width: sw(0.14), height: sh(0.10)),
      Paint()..color = Colors.white.withOpacity(0.12),
    );
    for (final t in [
      (0.38, 0.06), (0.50, 0.02), (0.62, 0.06),
      (0.28, 0.14), (0.72, 0.14), (0.24, 0.22), (0.76, 0.22),
    ]) {
      canvas.drawCircle(s(t.$1, t.$2), sw(0.016),
          Paint()..color = hi.color..style = PaintingStyle.fill);
    }
  }

  // ── Pixie ─────────────────────────────────────────────────────────────────
  void _pixie(
    Canvas canvas,
    Offset Function(double, double) s,
    double Function(double) sw,
    double Function(double) sh,
    Paint base,
    Paint hi,
  ) {
    final path = Path();
    path.moveTo(sw(0.30), sh(0.22));
    path.lineTo(sw(0.30), sh(0.14));
    path.cubicTo(sw(0.28), sh(0.06), sw(0.32), sh(0.01), sw(0.50), sh(0.01));
    path.cubicTo(sw(0.68), sh(0.01), sw(0.72), sh(0.06), sw(0.70), sh(0.14));
    path.lineTo(sw(0.70), sh(0.22));
    path.cubicTo(sw(0.62), sh(0.20), sw(0.54), sh(0.22), sw(0.48), sh(0.24));
    path.cubicTo(sw(0.42), sh(0.22), sw(0.36), sh(0.20), sw(0.30), sh(0.22));
    path.close();
    canvas.drawPath(path, base);

    final wisp = Path();
    wisp.moveTo(sw(0.32), sh(0.20));
    wisp.cubicTo(sw(0.30), sh(0.24), sw(0.28), sh(0.27), sw(0.32), sh(0.29));
    wisp.cubicTo(sw(0.35), sh(0.27), sw(0.37), sh(0.23), sw(0.36), sh(0.20));
    wisp.close();
    canvas.drawPath(wisp, base);

    canvas.drawLine(s(0.44, 0.04), s(0.42, 0.21), hi);
    canvas.drawLine(s(0.52, 0.02), s(0.50, 0.20), hi);
    canvas.drawLine(s(0.60, 0.04), s(0.58, 0.21), hi);
  }

  Color _darken(Color c, double amt) {
    final h = HSLColor.fromColor(c);
    return h.withLightness((h.lightness - amt).clamp(0.0, 1.0)).toColor();
  }
}
