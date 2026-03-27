import 'package:flutter/material.dart';
import '../models/effects_config.dart';

/// Paints animated particles driven by a [time] value (0.0 → 1.0, repeating).
///
/// Use with [DaliEffects] for automatic animation, or pass a static [time]
/// for a snapshot (e.g. screenshots, thumbnails).
class ParticlePainter extends CustomPainter {
  final ParticleType type;
  final double time; // 0.0 – 1.0
  final Color? color;

  ParticlePainter({
    required this.type,
    required this.time,
    this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    switch (type) {
      case ParticleType.confetti: _paintConfetti(canvas, size);
      case ParticleType.sparkles: _paintSparkles(canvas, size);
      case ParticleType.bubbles:  _paintBubbles(canvas, size);
      case ParticleType.stars:    _paintStars(canvas, size);
      case ParticleType.hearts:   _paintHearts(canvas, size);
      case ParticleType.snow:     _paintSnow(canvas, size);
    }
  }

  @override
  bool shouldRepaint(ParticlePainter old) => old.time != time || old.type != type;

  // ── Helpers ────────────────────────────────────────────────────────────────
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

  /// Deterministic pseudo-random from seed.
  double _rand(int seed) {
    final x = (seed * 1664525 + 1013904223) & 0x7FFFFFFF;
    return x / 0x7FFFFFFF;
  }

  Paint _fill(Color c) => Paint()..color = c..style = PaintingStyle.fill;

  // ── Confetti ───────────────────────────────────────────────────────────────
  void _paintConfetti(Canvas canvas, Size sz) {
    const colors = [
      Color(0xFFE53935), Color(0xFF9C27B0), Color(0xFF1E88E5),
      Color(0xFF43A047), Color(0xFFFDD835), Color(0xFFFF9800),
      Color(0xFFFF4081), Color(0xFF00BCD4),
    ];

    for (int i = 0; i < 40; i++) {
      final xBase = _rand(i * 7 + 1);
      final yBase = _rand(i * 7 + 2);
      final speed = 0.3 + _rand(i * 7 + 3) * 0.7;
      final size = 4.0 + _rand(i * 7 + 4) * 8.0;
      final rotation = _rand(i * 7 + 5) * 6.28;
      final wobble = _rand(i * 7 + 6) * 0.15;
      final col = colors[i % colors.length];

      // y moves downward, wraps around
      final y = (yBase + time * speed) % 1.0;
      final x = xBase + wobble * _sin(time * 6.28 * 2 + i.toDouble());

      final cx = x * sz.width;
      final cy = y * sz.height;

      canvas.save();
      canvas.translate(cx, cy);
      canvas.rotate(rotation + time * 3.14 * speed * 2);

      // Alternate between rectangles and circles
      if (i % 3 == 0) {
        canvas.drawRect(
          Rect.fromCenter(center: Offset.zero, width: size, height: size * 0.5),
          _fill(col),
        );
      } else if (i % 3 == 1) {
        canvas.drawCircle(Offset.zero, size * 0.4, _fill(col));
      } else {
        // Pentagon-ish squiggle
        final path = Path()
          ..moveTo(0, -size * 0.5)
          ..lineTo(size * 0.4, size * 0.3)
          ..lineTo(-size * 0.4, size * 0.3)
          ..close();
        canvas.drawPath(path, _fill(col));
      }

      canvas.restore();
    }
  }

  // ── Sparkles ───────────────────────────────────────────────────────────────
  void _paintSparkles(Canvas canvas, Size sz) {
    final base = color ?? const Color(0xFFFFD600);

    for (int i = 0; i < 20; i++) {
      final cx = _rand(i * 5 + 1) * sz.width;
      final cy = _rand(i * 5 + 2) * sz.height;
      final phase = _rand(i * 5 + 3);
      final maxSize = 6.0 + _rand(i * 5 + 4) * 14.0;

      // Each sparkle pulses in/out at its own phase
      final pulse = _sin((time + phase) * 6.28 * 1.5);
      final opacity = ((pulse + 1) / 2).clamp(0.0, 1.0);
      final r = maxSize * opacity;

      if (r < 1.0) continue;

      final paint = _fill(base.withOpacity(opacity * 0.9));

      // 4-point star shape
      final path = Path();
      for (int p = 0; p < 8; p++) {
        final angle = p * 3.14159 / 4;
        final pr = p.isEven ? r : r * 0.35;
        final px = cx + pr * _cos(angle);
        final py = cy + pr * _sin(angle);
        if (p == 0) {
          path.moveTo(px, py);
        } else {
          path.lineTo(px, py);
        }
      }
      path.close();
      canvas.drawPath(path, paint);

      // Centre dot
      canvas.drawCircle(Offset(cx, cy), r * 0.25,
          _fill(Colors.white.withOpacity(opacity * 0.8)));
    }
  }

  // ── Bubbles ────────────────────────────────────────────────────────────────
  void _paintBubbles(Canvas canvas, Size sz) {
    final base = color ?? const Color(0xFF4FC3F7);

    for (int i = 0; i < 18; i++) {
      final xBase = _rand(i * 6 + 1);
      final yBase = _rand(i * 6 + 2);
      final speed = 0.15 + _rand(i * 6 + 3) * 0.35;
      final r = 8.0 + _rand(i * 6 + 4) * 18.0;
      final wobble = _rand(i * 6 + 5) * 0.08;

      // Bubbles rise upward
      final y = ((1.0 - yBase) - time * speed) % 1.0;
      final x = xBase + wobble * _sin(time * 6.28 + i.toDouble());

      final cx = x * sz.width;
      final cy = y * sz.height;

      // Fade in at bottom, fade out at top
      final fadeY = (y * 4).clamp(0.0, 1.0) * ((1 - y) * 4).clamp(0.0, 1.0);

      // Bubble outline
      canvas.drawCircle(
        Offset(cx, cy), r,
        Paint()
          ..color = base.withOpacity(0.3 * fadeY)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
      // Bubble fill
      canvas.drawCircle(Offset(cx, cy), r,
          _fill(base.withOpacity(0.10 * fadeY)));
      // Shine highlight
      canvas.drawCircle(
        Offset(cx - r * 0.3, cy - r * 0.3), r * 0.22,
        _fill(Colors.white.withOpacity(0.55 * fadeY)),
      );
      canvas.drawCircle(
        Offset(cx - r * 0.15, cy - r * 0.15), r * 0.10,
        _fill(Colors.white.withOpacity(0.80 * fadeY)),
      );
    }
  }

  // ── Stars ──────────────────────────────────────────────────────────────────
  void _paintStars(Canvas canvas, Size sz) {
    final base = color ?? const Color(0xFFFFD600);

    for (int i = 0; i < 15; i++) {
      final cx = _rand(i * 4 + 1) * sz.width;
      final cy = _rand(i * 4 + 2) * sz.height;
      final phase = _rand(i * 4 + 3);
      final maxR = 8.0 + _rand(i * 4 + 4) * 16.0;

      final pulse = (_sin((time + phase) * 6.28) + 1) / 2;
      final r = maxR * (0.4 + pulse * 0.6);
      final opacity = 0.5 + pulse * 0.5;

      final path = Path();
      for (int p = 0; p < 10; p++) {
        final angle = p * 3.14159 / 5 - 3.14159 / 2;
        final pr = p.isEven ? r : r * 0.40;
        final px = cx + pr * _cos(angle);
        final py = cy + pr * _sin(angle);
        if (p == 0) path.moveTo(px, py); else path.lineTo(px, py);
      }
      path.close();
      canvas.drawPath(path, _fill(base.withOpacity(opacity)));
      canvas.drawCircle(Offset(cx, cy), r * 0.15,
          _fill(Colors.white.withOpacity(opacity)));
    }
  }

  // ── Hearts ─────────────────────────────────────────────────────────────────
  void _paintHearts(Canvas canvas, Size sz) {
    final base = color ?? const Color(0xFFE91E63);

    for (int i = 0; i < 14; i++) {
      final xBase = _rand(i * 6 + 1);
      final yBase = _rand(i * 6 + 2);
      final speed = 0.12 + _rand(i * 6 + 3) * 0.28;
      final maxR = 8.0 + _rand(i * 6 + 4) * 16.0;
      final wobble = _rand(i * 6 + 5) * 0.06;
      final phase = _rand(i * 6 + 6);

      final y = ((1.0 - yBase) - time * speed) % 1.0;
      final x = xBase + wobble * _sin(time * 6.28 + i.toDouble());

      final cx = x * sz.width;
      final cy = y * sz.height;

      final fadeY = (y * 4).clamp(0.0, 1.0) * ((1 - y) * 3).clamp(0.0, 1.0);
      final pulse = 0.85 + 0.15 * _sin((time + phase) * 6.28 * 2);
      final r = maxR * pulse;

      _drawHeart(canvas, cx, cy, r, base.withOpacity(0.85 * fadeY));
    }
  }

  void _drawHeart(Canvas canvas, double cx, double cy, double r, Color col) {
    final path = Path();
    // Heart via two cubic beziers
    path.moveTo(cx, cy + r * 0.3);
    path.cubicTo(
      cx - r * 1.2, cy - r * 0.4,
      cx - r * 1.2, cy - r * 1.2,
      cx, cy - r * 0.5,
    );
    path.cubicTo(
      cx + r * 1.2, cy - r * 1.2,
      cx + r * 1.2, cy - r * 0.4,
      cx, cy + r * 0.3,
    );
    canvas.drawPath(path, _fill(col));
    // Shine
    canvas.drawCircle(Offset(cx - r * 0.35, cy - r * 0.55), r * 0.22,
        _fill(Colors.white.withOpacity(0.4)));
  }

  // ── Snow ───────────────────────────────────────────────────────────────────
  void _paintSnow(Canvas canvas, Size sz) {
    for (int i = 0; i < 30; i++) {
      final xBase = _rand(i * 5 + 1);
      final yBase = _rand(i * 5 + 2);
      final speed = 0.08 + _rand(i * 5 + 3) * 0.18;
      final r = 3.0 + _rand(i * 5 + 4) * 7.0;
      final drift = _rand(i * 5 + 5) * 0.06 - 0.03;

      final y = (yBase + time * speed) % 1.0;
      final x = (xBase + drift * time * 10) % 1.0;

      final cx = x * sz.width;
      final cy = y * sz.height;

      canvas.drawCircle(
        Offset(cx, cy), r,
        _fill(Colors.white.withOpacity(0.80)),
      );
      // Snowflake cross for larger flakes
      if (r > 7) {
        final p = Paint()
          ..color = Colors.white.withOpacity(0.5)
          ..strokeWidth = 1.2
          ..style = PaintingStyle.stroke;
        for (int arm = 0; arm < 6; arm++) {
          final angle = arm * 3.14159 / 3;
          canvas.drawLine(
            Offset(cx + _cos(angle) * r * 0.4, cy + _sin(angle) * r * 0.4),
            Offset(cx + _cos(angle) * r * 1.4, cy + _sin(angle) * r * 1.4),
            p,
          );
        }
      }
    }
  }
}
