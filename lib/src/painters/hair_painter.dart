import 'package:flutter/material.dart';
import '../models/avatar_config.dart';

/// Paints hair over the head using vector Path objects.
/// All 12 styles are defined in normalised 1.0 × 1.0 space.
class HairPainter extends CustomPainter {
  final AvatarConfig config;

  HairPainter(this.config);

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    double sw(double x) => x * w;
    double sh(double y) => y * h;
    Offset s(double x, double y) => Offset(x * w, y * h);

    final hair = config.hair;
    final basePaint = Paint()..color = hair.color;
    final highlight = Paint()
      ..color = hair.highlightColor.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = sw(0.015);

    switch (hair.style) {
      case HairStyle.shortStraight:
        _shortStraight(canvas, s, sw, sh, basePaint, highlight);
      case HairStyle.shortCurly:
        _shortCurly(canvas, s, sw, sh, basePaint, highlight);
      case HairStyle.mediumStraight:
        _mediumStraight(canvas, s, sw, sh, basePaint, highlight);
      case HairStyle.mediumWavy:
        _mediumWavy(canvas, s, sw, sh, basePaint, highlight);
      case HairStyle.longStraight:
        _longStraight(canvas, s, sw, sh, basePaint, highlight);
      case HairStyle.longCurly:
        _longCurly(canvas, s, sw, sh, basePaint, highlight);
      case HairStyle.bob:
        _bob(canvas, s, sw, sh, basePaint, highlight);
      case HairStyle.ponytail:
        _ponytail(canvas, s, sw, sh, basePaint, highlight);
      case HairStyle.bun:
        _bun(canvas, s, sw, sh, basePaint, highlight);
      case HairStyle.braids:
        _braids(canvas, s, sw, sh, basePaint, highlight);
      case HairStyle.afro:
        _afro(canvas, s, sw, sh, basePaint, highlight);
      case HairStyle.pixie:
        _pixie(canvas, s, sw, sh, basePaint, highlight);
    }
  }

  // ── Short Straight ────────────────────────────────────────────────────────
  void _shortStraight(Canvas canvas, Offset Function(double, double) s,
      double Function(double) sw, double Function(double) sh,
      Paint base, Paint hi) {
    final path = Path();
    path.moveTo(sw(0.32), sh(0.22));
    path.lineTo(sw(0.32), sh(0.12));
    path.quadraticBezierTo(sw(0.50), sh(0.04), sw(0.68), sh(0.12));
    path.lineTo(sw(0.68), sh(0.22));
    path.quadraticBezierTo(sw(0.50), sh(0.08), sw(0.32), sh(0.22));
    path.close();
    canvas.drawPath(path, base);
    canvas.drawLine(s(0.38, 0.09), s(0.38, 0.20), hi);
    canvas.drawLine(s(0.50, 0.07), s(0.50, 0.18), hi);
  }

  // ── Short Curly ───────────────────────────────────────────────────────────
  void _shortCurly(Canvas canvas, Offset Function(double, double) s,
      double Function(double) sw, double Function(double) sh,
      Paint base, Paint hi) {
    final path = Path();
    path.moveTo(sw(0.32), sh(0.24));
    // Bumpy top with curls
    path.cubicTo(sw(0.30), sh(0.12), sw(0.34), sh(0.05), sw(0.42), sh(0.06));
    path.cubicTo(sw(0.44), sh(0.03), sw(0.48), sh(0.03), sw(0.50), sh(0.05));
    path.cubicTo(sw(0.52), sh(0.03), sw(0.56), sh(0.03), sw(0.58), sh(0.06));
    path.cubicTo(sw(0.66), sh(0.05), sw(0.70), sh(0.12), sw(0.68), sh(0.24));
    path.quadraticBezierTo(sw(0.50), sh(0.10), sw(0.32), sh(0.24));
    path.close();
    canvas.drawPath(path, base);
    // Curl highlights
    for (final cx in [0.38, 0.50, 0.62]) {
      canvas.drawArc(
        Rect.fromCenter(center: s(cx, 0.10), width: sw(0.07), height: sh(0.06)),
        -2.5, 2.5, false, hi,
      );
    }
  }

  // ── Medium Straight ───────────────────────────────────────────────────────
  void _mediumStraight(Canvas canvas, Offset Function(double, double) s,
      double Function(double) sw, double Function(double) sh,
      Paint base, Paint hi) {
    final path = Path();
    // Back layer
    path.moveTo(sw(0.30), sh(0.44));
    path.lineTo(sw(0.30), sh(0.12));
    path.quadraticBezierTo(sw(0.50), sh(0.04), sw(0.70), sh(0.12));
    path.lineTo(sw(0.70), sh(0.44));
    path.lineTo(sw(0.64), sh(0.44));
    path.lineTo(sw(0.64), sh(0.18));
    path.quadraticBezierTo(sw(0.50), sh(0.09), sw(0.36), sh(0.18));
    path.lineTo(sw(0.36), sh(0.44));
    path.close();
    canvas.drawPath(path, base);
    canvas.drawLine(s(0.40, 0.10), s(0.40, 0.44), hi);
    canvas.drawLine(s(0.50, 0.07), s(0.50, 0.44), hi);
    canvas.drawLine(s(0.60, 0.10), s(0.60, 0.44), hi);
  }

  // ── Medium Wavy ───────────────────────────────────────────────────────────
  void _mediumWavy(Canvas canvas, Offset Function(double, double) s,
      double Function(double) sw, double Function(double) sh,
      Paint base, Paint hi) {
    final path = Path();
    path.moveTo(sw(0.30), sh(0.44));
    path.cubicTo(sw(0.26), sh(0.36), sw(0.30), sh(0.18), sw(0.32), sh(0.12));
    path.quadraticBezierTo(sw(0.50), sh(0.04), sw(0.68), sh(0.12));
    path.cubicTo(sw(0.70), sh(0.18), sw(0.74), sh(0.36), sw(0.70), sh(0.44));
    // Wavy bottom edge
    path.cubicTo(sw(0.68), sh(0.42), sw(0.66), sh(0.46), sw(0.64), sh(0.42));
    path.cubicTo(sw(0.62), sh(0.38), sw(0.60), sh(0.44), sw(0.58), sh(0.40));
    path.cubicTo(sw(0.56), sh(0.36), sw(0.54), sh(0.42), sw(0.50), sh(0.40));
    path.cubicTo(sw(0.46), sh(0.38), sw(0.44), sh(0.44), sw(0.42), sh(0.40));
    path.cubicTo(sw(0.40), sh(0.36), sw(0.38), sh(0.42), sw(0.36), sh(0.42));
    path.cubicTo(sw(0.34), sh(0.42), sw(0.32), sh(0.46), sw(0.30), sh(0.44));
    path.close();
    canvas.drawPath(path, base);
    canvas.drawLine(s(0.42, 0.10), s(0.40, 0.42), hi);
    canvas.drawLine(s(0.58, 0.10), s(0.60, 0.42), hi);
  }

  // ── Long Straight ─────────────────────────────────────────────────────────
  void _longStraight(Canvas canvas, Offset Function(double, double) s,
      double Function(double) sw, double Function(double) sh,
      Paint base, Paint hi) {
    final path = Path();
    path.moveTo(sw(0.28), sh(0.68));
    path.lineTo(sw(0.28), sh(0.12));
    path.quadraticBezierTo(sw(0.50), sh(0.04), sw(0.72), sh(0.12));
    path.lineTo(sw(0.72), sh(0.68));
    path.lineTo(sw(0.66), sh(0.68));
    path.lineTo(sw(0.66), sh(0.16));
    path.quadraticBezierTo(sw(0.50), sh(0.09), sw(0.34), sh(0.16));
    path.lineTo(sw(0.34), sh(0.68));
    path.close();
    canvas.drawPath(path, base);
    canvas.drawLine(s(0.40, 0.10), s(0.40, 0.68), hi);
    canvas.drawLine(s(0.50, 0.07), s(0.50, 0.68), hi);
    canvas.drawLine(s(0.60, 0.10), s(0.60, 0.68), hi);
  }

  // ── Long Curly ────────────────────────────────────────────────────────────
  void _longCurly(Canvas canvas, Offset Function(double, double) s,
      double Function(double) sw, double Function(double) sh,
      Paint base, Paint hi) {
    // Wide flowing curly silhouette
    final path = Path();
    path.moveTo(sw(0.26), sh(0.68));
    path.cubicTo(sw(0.18), sh(0.55), sw(0.20), sh(0.30), sw(0.28), sh(0.12));
    path.quadraticBezierTo(sw(0.50), sh(0.04), sw(0.72), sh(0.12));
    path.cubicTo(sw(0.80), sh(0.30), sw(0.82), sh(0.55), sw(0.74), sh(0.68));
    // Curly right edge
    path.cubicTo(sw(0.76), sh(0.62), sw(0.72), sh(0.56), sw(0.74), sh(0.52));
    path.cubicTo(sw(0.76), sh(0.46), sw(0.72), sh(0.42), sw(0.70), sh(0.48));
    path.cubicTo(sw(0.68), sh(0.54), sw(0.66), sh(0.50), sw(0.64), sh(0.56));
    // Across bottom
    path.lineTo(sw(0.36), sh(0.56));
    // Curly left edge
    path.cubicTo(sw(0.34), sh(0.50), sw(0.32), sh(0.54), sw(0.30), sh(0.48));
    path.cubicTo(sw(0.28), sh(0.42), sw(0.24), sh(0.46), sw(0.26), sh(0.52));
    path.cubicTo(sw(0.28), sh(0.56), sw(0.24), sh(0.62), sw(0.26), sh(0.68));
    path.close();
    canvas.drawPath(path, base);
    // Curl highlights
    for (final (cx, cy, r) in [
      (0.36, 0.50, 0.05), (0.50, 0.55, 0.05), (0.64, 0.50, 0.05),
      (0.30, 0.36, 0.04), (0.70, 0.36, 0.04),
    ]) {
      canvas.drawArc(
        Rect.fromCenter(center: s(cx, cy), width: sw(r * 2), height: sh(r * 2)),
        -2.2, 2.2, false, hi,
      );
    }
  }

  // ── Bob ───────────────────────────────────────────────────────────────────
  void _bob(Canvas canvas, Offset Function(double, double) s,
      double Function(double) sw, double Function(double) sh,
      Paint base, Paint hi) {
    final path = Path();
    // Outer silhouette: sides hang straight to jaw, slightly flared
    path.moveTo(sw(0.24), sh(0.42));
    path.cubicTo(sw(0.20), sh(0.32), sw(0.22), sh(0.16), sw(0.28), sh(0.10));
    path.quadraticBezierTo(sw(0.50), sh(0.02), sw(0.72), sh(0.10));
    path.cubicTo(sw(0.78), sh(0.16), sw(0.80), sh(0.32), sw(0.76), sh(0.42));
    // Straight flat bottom with slight curve inward at centre
    path.cubicTo(sw(0.74), sh(0.44), sw(0.64), sh(0.46), sw(0.54), sh(0.44));
    path.quadraticBezierTo(sw(0.50), sh(0.43), sw(0.46), sh(0.44));
    path.cubicTo(sw(0.36), sh(0.46), sw(0.26), sh(0.44), sw(0.24), sh(0.42));
    path.close();
    canvas.drawPath(path, base);
    // Highlight strands
    canvas.drawLine(s(0.38, 0.07), s(0.34, 0.44), hi);
    canvas.drawLine(s(0.50, 0.04), s(0.50, 0.44), hi);
    canvas.drawLine(s(0.62, 0.07), s(0.66, 0.44), hi);
  }

  // ── Ponytail ──────────────────────────────────────────────────────────────
  void _ponytail(Canvas canvas, Offset Function(double, double) s,
      double Function(double) sw, double Function(double) sh,
      Paint base, Paint hi) {
    // Tail drawn first so cap sits on top
    final tail = Path();
    tail.moveTo(sw(0.44), sh(0.18));
    tail.cubicTo(sw(0.38), sh(0.30), sw(0.36), sh(0.48), sw(0.40), sh(0.64));
    tail.cubicTo(sw(0.44), sh(0.74), sw(0.56), sh(0.74), sw(0.60), sh(0.64));
    tail.cubicTo(sw(0.64), sh(0.48), sw(0.62), sh(0.30), sw(0.56), sh(0.18));
    tail.close();
    canvas.drawPath(tail, base);
    canvas.drawLine(s(0.50, 0.20), s(0.50, 0.72), hi);

    // Head cap — smooth sides pulled back tight
    final cap = Path();
    cap.moveTo(sw(0.32), sh(0.30));
    cap.cubicTo(sw(0.28), sh(0.20), sw(0.30), sh(0.10), sw(0.34), sh(0.06));
    cap.quadraticBezierTo(sw(0.50), sh(0.00), sw(0.66), sh(0.06));
    cap.cubicTo(sw(0.70), sh(0.10), sw(0.72), sh(0.20), sw(0.68), sh(0.30));
    // Smooth curve back to the tie point
    cap.cubicTo(sw(0.64), sh(0.26), sw(0.56), sh(0.22), sw(0.50), sh(0.22));
    cap.cubicTo(sw(0.44), sh(0.22), sw(0.36), sh(0.26), sw(0.32), sh(0.30));
    cap.close();
    canvas.drawPath(cap, base);

    // Hair tie band
    final tiePaint = Paint()
      ..color = _darken(base.color, 0.28)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(center: s(0.50, 0.20), width: sw(0.12), height: sh(0.06)),
      tiePaint,
    );
    // Tie highlight
    canvas.drawOval(
      Rect.fromCenter(center: s(0.48, 0.18), width: sw(0.04), height: sh(0.02)),
      Paint()..color = hi.color..style = PaintingStyle.fill,
    );
    // Cap highlight strand
    canvas.drawLine(s(0.44, 0.04), s(0.42, 0.22), hi);
  }

  // ── Bun ───────────────────────────────────────────────────────────────────
  void _bun(Canvas canvas, Offset Function(double, double) s,
      double Function(double) sw, double Function(double) sh,
      Paint base, Paint hi) {
    // Smooth sides
    final path = Path();
    path.moveTo(sw(0.34), sh(0.30));
    path.lineTo(sw(0.34), sh(0.12));
    path.quadraticBezierTo(sw(0.50), sh(0.06), sw(0.66), sh(0.12));
    path.lineTo(sw(0.66), sh(0.30));
    path.quadraticBezierTo(sw(0.58), sh(0.27), sw(0.50), sh(0.26));
    path.quadraticBezierTo(sw(0.42), sh(0.27), sw(0.34), sh(0.30));
    path.close();
    canvas.drawPath(path, base);

    // Top bun
    canvas.drawOval(
      Rect.fromCenter(center: s(0.50, 0.06), width: sw(0.20), height: sh(0.10)),
      base,
    );
    // Bun shine
    canvas.drawOval(
      Rect.fromCenter(center: s(0.46, 0.04), width: sw(0.06), height: sh(0.04)),
      Paint()..color = hi.color..style = PaintingStyle.fill,
    );
    // Bun wrap line
    canvas.drawArc(
      Rect.fromCenter(center: s(0.50, 0.06), width: sw(0.18), height: sh(0.09)),
      0.5, 2.5, false,
      hi,
    );
  }

  // ── Braids ────────────────────────────────────────────────────────────────
  void _braids(Canvas canvas, Offset Function(double, double) s,
      double Function(double) sw, double Function(double) sh,
      Paint base, Paint hi) {
    // Top and sides
    final top = Path();
    top.moveTo(sw(0.34), sh(0.22));
    top.lineTo(sw(0.34), sh(0.12));
    top.quadraticBezierTo(sw(0.50), sh(0.04), sw(0.66), sh(0.12));
    top.lineTo(sw(0.66), sh(0.22));
    top.quadraticBezierTo(sw(0.50), sh(0.16), sw(0.34), sh(0.22));
    top.close();
    canvas.drawPath(top, base);

    // Center part
    canvas.drawLine(s(0.50, 0.06), s(0.50, 0.20),
        Paint()..color = _darken(base.color, 0.25)..strokeWidth = sw(0.012)..style = PaintingStyle.stroke);

    // Left braid
    _drawBraid(canvas, s, sw, sh, base, hi, 0.38, 0.20, 0.32, 0.70);
    // Right braid
    _drawBraid(canvas, s, sw, sh, base, hi, 0.62, 0.20, 0.68, 0.70);
  }

  void _drawBraid(Canvas canvas, Offset Function(double, double) s,
      double Function(double) sw, double Function(double) sh,
      Paint base, Paint hi, double sx, double sy, double ex, double ey) {
    final segments = 8;
    final braidPaint = Paint()..color = base.color..style = PaintingStyle.stroke..strokeWidth = sw(0.04);
    final crossPaint = Paint()..color = _darken(base.color, 0.20)..style = PaintingStyle.stroke..strokeWidth = sw(0.015);

    for (int i = 0; i < segments; i++) {
      final t1 = i / segments;
      final t2 = (i + 1) / segments;
      final y1 = sy + (ey - sy) * t1;
      final y2 = sy + (ey - sy) * t2;
      final xOffset = 0.025 * (i % 2 == 0 ? 1 : -1);
      canvas.drawLine(
        s(sx + xOffset, y1),
        s(sx - xOffset, y2),
        braidPaint,
      );
      canvas.drawLine(s(sx + xOffset * 0.5, y1), s(sx - xOffset * 0.5, y2), crossPaint);
    }

    // Braid tip
    canvas.drawOval(
      Rect.fromCenter(center: s(sx + (ex - sx) * 0.1, ey), width: sw(0.04), height: sh(0.025)),
      Paint()..color = _darken(base.color, 0.3),
    );
  }

  // ── Afro ──────────────────────────────────────────────────────────────────
  void _afro(Canvas canvas, Offset Function(double, double) s,
      double Function(double) sw, double Function(double) sh,
      Paint base, Paint hi) {
    // Large rounded cloud — multiple overlapping ovals
    final circles = [
      (0.50, 0.12, 0.32, 0.38), // center
      (0.36, 0.14, 0.20, 0.28), // left
      (0.64, 0.14, 0.20, 0.28), // right
      (0.28, 0.20, 0.16, 0.20), // far left
      (0.72, 0.20, 0.16, 0.20), // far right
      (0.42, 0.08, 0.18, 0.16), // upper left
      (0.58, 0.08, 0.18, 0.16), // upper right
      (0.50, 0.05, 0.14, 0.12), // top
    ];

    for (final (cx, cy, cw, ch) in circles) {
      canvas.drawOval(
        Rect.fromCenter(center: s(cx, cy), width: sw(cw), height: sh(ch)),
        base,
      );
    }

    // Volume highlight
    final volHighlight = Paint()
      ..color = Colors.white.withOpacity(0.12)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(center: s(0.44, 0.09), width: sw(0.12), height: sh(0.08)),
      volHighlight,
    );

    // Texture dots
    final texturePaint = Paint()..color = hi.color..style = PaintingStyle.fill;
    final rng = [
      (0.40, 0.08), (0.52, 0.06), (0.60, 0.10), (0.34, 0.14),
      (0.66, 0.14), (0.30, 0.20), (0.70, 0.20),
    ];
    for (final (tx, ty) in rng) {
      canvas.drawCircle(s(tx, ty), sw(0.015), texturePaint);
    }
  }

  // ── Pixie ─────────────────────────────────────────────────────────────────
  void _pixie(Canvas canvas, Offset Function(double, double) s,
      double Function(double) sw, double Function(double) sh,
      Paint base, Paint hi) {
    final path = Path();
    // Very close-cropped with a forward swept point
    path.moveTo(sw(0.34), sh(0.22));
    path.lineTo(sw(0.34), sh(0.14));
    path.quadraticBezierTo(sw(0.50), sh(0.06), sw(0.66), sh(0.14));
    path.lineTo(sw(0.66), sh(0.22));
    // Taper on left to a small point toward forehead
    path.cubicTo(sw(0.60), sh(0.20), sw(0.54), sh(0.22), sw(0.48), sh(0.24));
    // Swept point
    path.cubicTo(sw(0.44), sh(0.22), sw(0.38), sh(0.20), sw(0.34), sh(0.22));
    path.close();
    canvas.drawPath(path, base);

    // Swept front wisp
    final wisp = Path();
    wisp.moveTo(sw(0.36), sh(0.20));
    wisp.cubicTo(sw(0.34), sh(0.24), sw(0.32), sh(0.26), sw(0.36), sh(0.28));
    wisp.cubicTo(sw(0.38), sh(0.26), sw(0.40), sh(0.22), sw(0.40), sh(0.20));
    wisp.close();
    canvas.drawPath(wisp, base);

    // Short texture lines
    canvas.drawLine(s(0.44, 0.10), s(0.42, 0.20), hi);
    canvas.drawLine(s(0.52, 0.08), s(0.50, 0.19), hi);
    canvas.drawLine(s(0.60, 0.10), s(0.58, 0.20), hi);
  }

  Color _darken(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
  }

  @override
  bool shouldRepaint(HairPainter oldDelegate) =>
      oldDelegate.config.hair != config.hair;
}
