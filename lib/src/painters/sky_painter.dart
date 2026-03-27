import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/scene_config.dart';

/// Reusable sky painter — gradient + sun/moon + clouds + stars.
/// Used by all outdoor scenes.
class SkyPainter {
  final SceneConfig config;

  SkyPainter(this.config);

  void paint(Canvas canvas, Size size, {double skyBottom = 0.62}) {
    final w = size.width;
    final h = size.height;

    _paintGradient(canvas, size, skyBottom);
    _paintCelestialBody(canvas, w, h);
    if (config.weather == Weather.cloudy || config.weather == Weather.rainy ||
        config.weather == Weather.snowy) {
      _paintClouds(canvas, w, h, skyBottom, heavy: true);
    } else {
      _paintClouds(canvas, w, h, skyBottom, heavy: false);
    }
    if (config.timeOfDay == DayTime.night ||
        config.timeOfDay == DayTime.dawn) {
      _paintStars(canvas, w, h, skyBottom);
    }
    if (config.weather == Weather.rainy) _paintRain(canvas, w, h, skyBottom);
    if (config.weather == Weather.snowy) _paintSnow(canvas, w, h, skyBottom);
  }

  void _paintGradient(Canvas canvas, Size size, double skyBottom) {
    final colors = _skyColors();
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: colors,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height * skyBottom));
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height * skyBottom),
      paint,
    );
  }

  List<Color> _skyColors() => switch (config.timeOfDay) {
    DayTime.day => [const Color(0xFF4FC3F7), const Color(0xFF81D4FA), const Color(0xFFB3E5FC)],
    DayTime.dawn => [const Color(0xFF1A237E), const Color(0xFFE91E63), const Color(0xFFFF9800), const Color(0xFFFFCC80)],
    DayTime.dusk => [const Color(0xFF311B92), const Color(0xFFE53935), const Color(0xFFFF7043), const Color(0xFFFFB74D)],
    DayTime.night => [const Color(0xFF0A0A1A), const Color(0xFF0D1B3E), const Color(0xFF1A237E)],
  };

  void _paintCelestialBody(Canvas canvas, double w, double h) {
    switch (config.timeOfDay) {
      case DayTime.day:
      case DayTime.dawn:
        _paintSun(canvas, w, h);
      case DayTime.dusk:
        _paintSun(canvas, w, h, setting: true);
      case DayTime.night:
        _paintMoon(canvas, w, h);
    }
  }

  void _paintSun(Canvas canvas, double w, double h, {bool setting = false}) {
    final cx = w * 0.78;
    final cy = setting ? h * 0.52 : h * 0.15;
    final r = w * 0.07;

    // Glow
    final glowPaint = Paint()
      ..shader = RadialGradient(colors: [
        Colors.yellow.withOpacity(0.4),
        Colors.orange.withOpacity(0.15),
        Colors.transparent,
      ]).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r * 2.5));
    canvas.drawCircle(Offset(cx, cy), r * 2.5, glowPaint);

    // Sun disc
    final sunPaint = Paint()
      ..shader = RadialGradient(colors: [
        Colors.white,
        const Color(0xFFFFEB3B),
        const Color(0xFFFF9800),
      ]).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r));
    canvas.drawCircle(Offset(cx, cy), r, sunPaint);

    // Rays
    if (!setting) {
      final rayPaint = Paint()
        ..color = Colors.yellow.withOpacity(0.5)
        ..strokeWidth = w * 0.008
        ..style = PaintingStyle.stroke;
      for (int i = 0; i < 8; i++) {
        final angle = i * 3.14159 / 4;
        canvas.drawLine(
          Offset(cx + r * 1.3 * _cos(angle), cy + r * 1.3 * _sin(angle)),
          Offset(cx + r * 2.0 * _cos(angle), cy + r * 2.0 * _sin(angle)),
          rayPaint,
        );
      }
    }
  }

  void _paintMoon(Canvas canvas, double w, double h) {
    final cx = w * 0.78;
    final cy = h * 0.15;
    final r = w * 0.06;

    // Glow
    canvas.drawCircle(Offset(cx, cy), r * 2,
        Paint()..color = Colors.white.withOpacity(0.08));

    // Moon (crescent via overlapping circles)
    canvas.drawCircle(Offset(cx, cy), r,
        Paint()..color = const Color(0xFFF5F5DC));
    canvas.drawCircle(Offset(cx + r * 0.4, cy - r * 0.1), r * 0.85,
        Paint()..color = const Color(0xFF1A237E));

    // Moon craters
    final craterPaint = Paint()..color = Colors.white.withOpacity(0.15);
    canvas.drawCircle(Offset(cx - r * 0.3, cy + r * 0.2), r * 0.12, craterPaint);
    canvas.drawCircle(Offset(cx - r * 0.1, cy - r * 0.3), r * 0.08, craterPaint);
  }

  void _paintClouds(Canvas canvas, double w, double h, double skyBottom, {required bool heavy}) {
    final cloudColor = heavy
        ? Colors.grey.shade400.withOpacity(0.9)
        : Colors.white.withOpacity(0.88);

    final clouds = [
      (0.18, 0.18, 0.22, 1.0),
      (0.55, 0.24, 0.18, 0.85),
      (0.82, 0.14, 0.14, 0.7),
      (0.35, 0.32, 0.16, heavy ? 0.9 : 0.6),
    ];

    for (final (cx, cy, scale, opacity) in clouds) {
      if (cy > skyBottom - 0.05) continue;
      _drawCloud(canvas, w * cx, h * cy, w * scale,
          cloudColor.withOpacity((cloudColor.opacity * opacity).clamp(0, 1)));
    }
  }

  void _drawCloud(Canvas canvas, double cx, double cy, double scale, Color color) {
    final paint = Paint()..color = color;
    final puffs = [
      (0.0, 0.0, 0.5), (-0.35, 0.1, 0.38), (0.35, 0.08, 0.38),
      (-0.18, -0.18, 0.32), (0.18, -0.15, 0.30),
    ];
    for (final (ox, oy, r) in puffs) {
      canvas.drawCircle(Offset(cx + ox * scale, cy + oy * scale), r * scale, paint);
    }
  }

  void _paintStars(Canvas canvas, double w, double h, double skyBottom) {
    final starPaint = Paint()..color = Colors.white;
    final stars = [
      (0.10, 0.05), (0.25, 0.10), (0.42, 0.04), (0.58, 0.08),
      (0.70, 0.03), (0.85, 0.12), (0.15, 0.18), (0.50, 0.20),
      (0.65, 0.15), (0.90, 0.22), (0.32, 0.26), (0.77, 0.28),
      (0.05, 0.30), (0.45, 0.30), (0.88, 0.35),
    ];
    for (final (sx, sy) in stars) {
      if (sy > skyBottom - 0.05) continue;
      final brightness = 0.4 + (sx * 7 % 0.6);
      canvas.drawCircle(
        Offset(w * sx, h * sy),
        w * 0.005,
        starPaint..color = Colors.white.withOpacity(brightness),
      );
    }
  }

  void _paintRain(Canvas canvas, double w, double h, double skyBottom) {
    final rainPaint = Paint()
      ..color = Colors.lightBlue.withOpacity(0.4)
      ..strokeWidth = w * 0.004
      ..style = PaintingStyle.stroke;
    for (int i = 0; i < 20; i++) {
      final x = w * (i * 0.053 % 1.0);
      final y1 = h * (i * 0.071 % skyBottom);
      canvas.drawLine(Offset(x, y1), Offset(x - w * 0.01, y1 + h * 0.04), rainPaint);
    }
  }

  void _paintSnow(Canvas canvas, double w, double h, double skyBottom) {
    final snowPaint = Paint()..color = Colors.white.withOpacity(0.7);
    for (int i = 0; i < 18; i++) {
      final x = w * (i * 0.057 % 1.0);
      final y = h * (i * 0.067 % skyBottom);
      canvas.drawCircle(Offset(x, y), w * 0.007, snowPaint);
    }
  }

  double _cos(double a) => math.cos(a);
  double _sin(double a) => math.sin(a);
}
