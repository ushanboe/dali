import 'package:flutter/material.dart';
import '../models/scene_config.dart';
import 'sky_painter.dart';

/// Paints a full scene background for any of the 10 scene types.
class ScenePainter extends CustomPainter {
  final SceneConfig config;

  ScenePainter(this.config);

  @override
  void paint(Canvas canvas, Size size) {
    switch (config.type) {
      case SceneType.park:       _paintPark(canvas, size);
      case SceneType.beach:      _paintBeach(canvas, size);
      case SceneType.city:       _paintCity(canvas, size);
      case SceneType.forest:     _paintForest(canvas, size);
      case SceneType.bedroom:    _paintBedroom(canvas, size);
      case SceneType.kitchen:    _paintKitchen(canvas, size);
      case SceneType.classroom:  _paintClassroom(canvas, size);
      case SceneType.salon:      _paintSalon(canvas, size);
      case SceneType.space:      _paintSpace(canvas, size);
      case SceneType.underwater: _paintUnderwater(canvas, size);
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  Offset s(double x, double y, Size sz) => Offset(x * sz.width, y * sz.height);
  double sw(double x, Size sz) => x * sz.width;
  double sh(double y, Size sz) => y * sz.height;
  /// Unit for sizing detail elements — based on height so proportions stay
  /// correct at any aspect ratio (prevents giant trees on wide screens).
  double u(double scale, Size sz) => sz.height * scale;

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

  void _gradientRect(Canvas canvas, Rect rect, List<Color> colors,
      {AlignmentGeometry begin = Alignment.topCenter,
       AlignmentGeometry end = Alignment.bottomCenter}) {
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: begin, end: end, colors: colors,
        ).createShader(rect),
    );
  }

  // ── Park ──────────────────────────────────────────────────────────────────
  void _paintPark(Canvas canvas, Size sz) {
    SkyPainter(config).paint(canvas, sz, skyBottom: 0.60);
    _paintGround(canvas, sz, 0.60, const Color(0xFF4CAF50), const Color(0xFF388E3C));
    _paintTree(canvas, sz, 0.15, 0.60, 0.12);
    _paintTree(canvas, sz, 0.82, 0.60, 0.10);
    _paintTree(canvas, sz, 0.55, 0.58, 0.08);
    _paintPath(canvas, sz);
    _paintFlowers(canvas, sz);
    if (config.weather == Weather.snowy) _paintSnowGround(canvas, sz, 0.60);
  }

  void _paintGround(Canvas canvas, Size sz, double y, Color top, Color bottom) {
    _gradientRect(
      canvas,
      Rect.fromLTWH(0, sh(y, sz), sz.width, sh(1 - y, sz)),
      [top, bottom],
    );
    // Ground highlight strip
    canvas.drawRect(
      Rect.fromLTWH(0, sh(y, sz), sz.width, sh(0.015, sz)),
      _fill(_lighten(top, 0.12)),
    );
  }

  void _paintTree(Canvas canvas, Size sz, double cx, double groundY, double scale) {
    final w = sz.width; final h = sz.height;
    final r = u(scale, sz); // height-based unit
    // Trunk
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(w * cx, h * groundY + r * 0.4),
            width: r * 0.22, height: r * 0.8),
        Radius.circular(r * 0.11),
      ),
      _fill(const Color(0xFF795548)),
    );
    // Canopy layers (3 overlapping circles)
    final canopyColors = [const Color(0xFF2E7D32), const Color(0xFF4CAF50), const Color(0xFF66BB6A)];
    for (int i = 0; i < 3; i++) {
      final layerY = h * groundY - r * (0.5 + i * 0.42);
      final layerR = r * (0.65 - i * 0.08);
      canvas.drawCircle(Offset(w * cx, layerY), layerR, _fill(canopyColors[i]));
    }
    // Highlight
    canvas.drawCircle(
      Offset(w * cx - r * 0.18, h * groundY - r * 1.3),
      r * 0.20, _fill(Colors.white.withOpacity(0.14)),
    );
  }

  void _paintPath(Canvas canvas, Size sz) {
    final path = Path();
    path.moveTo(sw(0.38, sz), sh(1.0, sz));
    path.quadraticBezierTo(sw(0.44, sz), sh(0.72, sz), sw(0.48, sz), sh(0.60, sz));
    path.lineTo(sw(0.52, sz), sh(0.60, sz));
    path.quadraticBezierTo(sw(0.56, sz), sh(0.72, sz), sw(0.62, sz), sh(1.0, sz));
    canvas.drawPath(path, _fill(const Color(0xFFD7CCC8)));
    // Path edge lines
    canvas.drawPath(path, _stroke(const Color(0xFFBCAAA4), sw(0.005, sz)));
  }

  void _paintFlowers(Canvas canvas, Size sz) {
    final positions = [(0.22, 0.68), (0.35, 0.72), (0.65, 0.70), (0.74, 0.66)];
    final colors = [Colors.red, Colors.yellow, Colors.pink, Colors.white];
    for (int i = 0; i < positions.length; i++) {
      final (fx, fy) = positions[i];
      final r = u(0.030, sz);
      // Petals
      for (int p = 0; p < 5; p++) {
        final angle = p * 1.2566;
        canvas.drawCircle(
          Offset(s(fx, fy, sz).dx + r * 1.1 * _cos(angle),
                 s(fx, fy, sz).dy + r * 1.1 * _sin(angle)),
          r * 0.7, _fill(colors[i].withOpacity(0.9)),
        );
      }
      canvas.drawCircle(s(fx, fy, sz), r * 0.7, _fill(Colors.yellow));
    }
  }

  void _paintSnowGround(Canvas canvas, Size sz, double y) {
    _gradientRect(
      canvas,
      Rect.fromLTWH(0, sh(y, sz), sz.width, sh(1 - y, sz)),
      [Colors.white, const Color(0xFFE3F2FD)],
    );
  }

  // ── Beach ─────────────────────────────────────────────────────────────────
  void _paintBeach(Canvas canvas, Size sz) {
    SkyPainter(config).paint(canvas, sz, skyBottom: 0.52);

    // Ocean
    _gradientRect(
      canvas,
      Rect.fromLTWH(0, sh(0.50, sz), sz.width, sh(0.22, sz)),
      [const Color(0xFF0288D1), const Color(0xFF0097A7)],
    );
    // Ocean shimmer
    for (int i = 0; i < 4; i++) {
      canvas.drawLine(
        s(0.0 + i * 0.08, 0.56 + i * 0.018, sz),
        s(0.6 + i * 0.05, 0.56 + i * 0.018, sz),
        _stroke(Colors.white.withOpacity(0.25), sw(0.008, sz)),
      );
    }
    // Waves
    final wavePath = Path();
    wavePath.moveTo(0, sh(0.525, sz));
    for (int i = 0; i < 6; i++) {
      wavePath.quadraticBezierTo(
        sw(i * 0.18 + 0.09, sz), sh(0.515, sz),
        sw((i + 1) * 0.18, sz), sh(0.525, sz),
      );
    }
    canvas.drawPath(wavePath, _stroke(Colors.white.withOpacity(0.6), sw(0.008, sz)));

    // Sand
    _gradientRect(
      canvas,
      Rect.fromLTWH(0, sh(0.70, sz), sz.width, sh(0.30, sz)),
      [const Color(0xFFFFE082), const Color(0xFFFFD54F)],
    );
    // Wet sand (darker near water)
    _gradientRect(
      canvas,
      Rect.fromLTWH(0, sh(0.68, sz), sz.width, sh(0.06, sz)),
      [const Color(0xFFFFCC02).withOpacity(0.0), const Color(0xFFD4A017)],
      begin: Alignment.topCenter, end: Alignment.bottomCenter,
    );

    // Palm tree
    _paintPalmTree(canvas, sz, 0.15, 0.70);

    // Seashells
    for (final (sx, sy) in [(0.55, 0.80), (0.70, 0.88), (0.40, 0.92)]) {
      canvas.drawOval(
        Rect.fromCenter(center: s(sx, sy, sz), width: sw(0.035, sz), height: sh(0.018, sz)),
        _fill(Colors.white.withOpacity(0.8)),
      );
    }
  }

  void _paintPalmTree(Canvas canvas, Size sz, double cx, double groundY) {
    // Curved trunk
    final trunk = Path();
    trunk.moveTo(sw(cx, sz), sh(groundY, sz));
    trunk.quadraticBezierTo(
      sw(cx + 0.04, sz), sh(groundY - 0.18, sz),
      sw(cx + 0.02, sz), sh(groundY - 0.30, sz),
    );
    trunk.lineTo(sw(cx + 0.05, sz), sh(groundY - 0.30, sz));
    trunk.quadraticBezierTo(
      sw(cx + 0.07, sz), sh(groundY - 0.18, sz),
      sw(cx + 0.04, sz), sh(groundY, sz),
    );
    canvas.drawPath(trunk, _fill(const Color(0xFF8D6E63)));

    // Palm fronds
    final frondTip = Offset(sw(cx + 0.03, sz), sh(groundY - 0.31, sz));
    final fronds = [
      (cx - 0.14, groundY - 0.38), (cx + 0.18, groundY - 0.36),
      (cx - 0.08, groundY - 0.44), (cx + 0.12, groundY - 0.44),
      (cx + 0.02, groundY - 0.46),
    ];
    for (final (fx, fy) in fronds) {
      final path = Path();
      path.moveTo(frondTip.dx, frondTip.dy);
      path.quadraticBezierTo(
        sw((cx + fx) / 2, sz), sh((groundY - 0.31 + fy) / 2 - 0.04, sz),
        sw(fx, sz), sh(fy, sz),
      );
      canvas.drawPath(path, _stroke(const Color(0xFF388E3C), sw(0.022, sz)));
    }

    // Coconuts
    canvas.drawCircle(Offset(sw(cx + 0.02, sz), sh(groundY - 0.30, sz)),
        sw(0.022, sz), _fill(const Color(0xFF795548)));
  }

  // ── City ──────────────────────────────────────────────────────────────────
  void _paintCity(Canvas canvas, Size sz) {
    SkyPainter(config).paint(canvas, sz, skyBottom: 0.62);
    _paintBuildings(canvas, sz);
    _paintSidewalk(canvas, sz);
    _paintRoad(canvas, sz);
  }

  void _paintBuildings(Canvas canvas, Size sz) {
    final buildings = [
      (0.0,  0.15, 0.18, 0.62, const Color(0xFF546E7A)),
      (0.16, 0.25, 0.14, 0.62, const Color(0xFF607D8B)),
      (0.28, 0.10, 0.20, 0.62, const Color(0xFF455A64)),
      (0.46, 0.30, 0.16, 0.62, const Color(0xFF78909C)),
      (0.60, 0.18, 0.22, 0.62, const Color(0xFF546E7A)),
      (0.80, 0.22, 0.20, 0.62, const Color(0xFF607D8B)),
    ];

    for (final (bx, by, bw, groundY, color) in buildings) {
      // Building body
      canvas.drawRect(
        Rect.fromLTWH(sw(bx, sz), sh(by, sz), sw(bw, sz), sh(groundY - by, sz)),
        _fill(color),
      );
      // Windows
      final winColor = config.timeOfDay == DayTime.night
          ? Colors.yellow.withOpacity(0.8)
          : Colors.lightBlue.withOpacity(0.5);
      for (int row = 0; row < 5; row++) {
        for (int col = 0; col < 3; col++) {
          final wx = bx + 0.015 + col * (bw / 3.2);
          final wy = by + 0.04 + row * 0.07;
          if (wy + 0.04 < groundY) {
            canvas.drawRRect(
              RRect.fromRectAndRadius(
                Rect.fromLTWH(sw(wx, sz), sh(wy, sz), sw(bw / 4.5, sz), sh(0.04, sz)),
                Radius.circular(sw(0.005, sz)),
              ),
              _fill(winColor),
            );
          }
        }
      }
      // Building outline
      canvas.drawRect(
        Rect.fromLTWH(sw(bx, sz), sh(by, sz), sw(bw, sz), sh(groundY - by, sz)),
        _stroke(_darken(color, 0.15), sw(0.004, sz)),
      );
    }
  }

  void _paintSidewalk(Canvas canvas, Size sz) {
    canvas.drawRect(
      Rect.fromLTWH(0, sh(0.62, sz), sz.width, sh(0.12, sz)),
      _fill(const Color(0xFFBDBDBD)),
    );
    // Pavement lines
    for (int i = 0; i < 8; i++) {
      canvas.drawLine(
        s(i * 0.13, 0.62, sz), s(i * 0.13, 0.74, sz),
        _stroke(Colors.white.withOpacity(0.3), sw(0.004, sz)),
      );
    }
  }

  void _paintRoad(Canvas canvas, Size sz) {
    canvas.drawRect(
      Rect.fromLTWH(0, sh(0.74, sz), sz.width, sh(0.26, sz)),
      _fill(const Color(0xFF424242)),
    );
    // Dashed centre line
    final dashPaint = _fill(Colors.white.withOpacity(0.7));
    for (int i = 0; i < 7; i++) {
      canvas.drawRect(
        Rect.fromLTWH(sw(i * 0.15, sz), sh(0.865, sz), sw(0.08, sz), sh(0.018, sz)),
        dashPaint,
      );
    }
    // Kerb line
    canvas.drawLine(
      s(0, 0.74, sz), s(1, 0.74, sz),
      _stroke(Colors.white.withOpacity(0.4), sw(0.006, sz)),
    );
  }

  // ── Forest ────────────────────────────────────────────────────────────────
  void _paintForest(Canvas canvas, Size sz) {
    SkyPainter(config).paint(canvas, sz, skyBottom: 0.45);
    // Dense tree line background
    _paintForestLayer(canvas, sz, 0.38, 0.18, const Color(0xFF2E7D32), 6);
    _paintForestLayer(canvas, sz, 0.50, 0.22, const Color(0xFF388E3C), 5);
    _paintForestLayer(canvas, sz, 0.60, 0.26, const Color(0xFF43A047), 4);
    // Forest floor
    _gradientRect(
      canvas,
      Rect.fromLTWH(0, sh(0.60, sz), sz.width, sh(0.40, sz)),
      [const Color(0xFF33691E), const Color(0xFF1B5E20)],
    );
    // Undergrowth
    _paintUndergrowth(canvas, sz);
    // Light rays
    _paintLightRays(canvas, sz);
    if (config.weather == Weather.snowy) _paintSnowGround(canvas, sz, 0.60);
  }

  void _paintForestLayer(Canvas canvas, Size sz, double groundY, double scale,
      Color color, int count) {
    for (int i = 0; i < count; i++) {
      final cx = (i + 0.5) / count + (i % 2 == 0 ? -0.03 : 0.03);
      _paintPineTree(canvas, sz, cx, groundY, scale, color);
    }
  }

  void _paintPineTree(Canvas canvas, Size sz, double cx, double groundY,
      double scale, Color color) {
    final w = sz.width; final h = sz.height;
    final r = u(scale, sz); // height-based
    // Trunk
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(w * cx, h * groundY + r * 0.2),
        width: r * 0.14, height: r * 0.40,
      ),
      _fill(const Color(0xFF5D4037)),
    );
    // Three triangle tiers
    for (int t = 0; t < 3; t++) {
      final tierBottom = h * groundY - r * (t * 0.38);
      final tierTop = tierBottom - r * 0.50;
      final tierHalfW = r * (0.60 - t * 0.08);
      final tri = Path();
      tri.moveTo(w * cx, tierTop);
      tri.lineTo(w * cx - tierHalfW, tierBottom);
      tri.lineTo(w * cx + tierHalfW, tierBottom);
      tri.close();
      canvas.drawPath(tri, _fill(t == 0 ? _darken(color, 0.1) : (t == 1 ? color : _lighten(color, 0.08))));
    }
  }

  void _paintUndergrowth(Canvas canvas, Size sz) {
    final bushes = [(0.10, 0.62), (0.35, 0.64), (0.60, 0.61), (0.85, 0.63)];
    for (final (bx, by) in bushes) {
      canvas.drawOval(
        Rect.fromCenter(center: s(bx, by, sz), width: sw(0.14, sz), height: sh(0.06, sz)),
        _fill(const Color(0xFF1B5E20)),
      );
    }
  }

  void _paintLightRays(Canvas canvas, Size sz) {
    final rayPaint = Paint()
      ..color = Colors.yellow.withOpacity(0.06)
      ..style = PaintingStyle.fill;
    for (int i = 0; i < 3; i++) {
      final cx = 0.25 + i * 0.28;
      final path = Path();
      path.moveTo(sw(cx, sz), sh(0.0, sz));
      path.lineTo(sw(cx - 0.06, sz), sh(0.70, sz));
      path.lineTo(sw(cx + 0.06, sz), sh(0.70, sz));
      path.close();
      canvas.drawPath(path, rayPaint);
    }
  }

  // ── Bedroom ───────────────────────────────────────────────────────────────
  void _paintBedroom(Canvas canvas, Size sz) {
    // Wall
    _gradientRect(
      canvas,
      Rect.fromLTWH(0, 0, sz.width, sh(0.82, sz)),
      [const Color(0xFFE8EAF6), const Color(0xFFC5CAE9)],
    );
    // Wallpaper pattern
    _paintWallpaperDots(canvas, sz, const Color(0xFFB0BEC5).withOpacity(0.3));
    // Floor
    _paintWoodFloor(canvas, sz, 0.82, const Color(0xFFD7A97B));
    // Window
    _paintWindow(canvas, sz, 0.12, 0.12, 0.28, 0.40);
    // Bed
    _paintBed(canvas, sz);
    // Lamp
    _paintLamp(canvas, sz, 0.82, 0.30);
    // Picture frame
    _paintPictureFrame(canvas, sz, 0.62, 0.15, 0.22, 0.25);
    // Baseboard
    canvas.drawRect(
      Rect.fromLTWH(0, sh(0.82, sz), sz.width, sh(0.025, sz)),
      _fill(Colors.white.withOpacity(0.6)),
    );
  }

  void _paintWallpaperDots(Canvas canvas, Size sz, Color color) {
    for (int row = 0; row < 6; row++) {
      for (int col = 0; col < 8; col++) {
        if ((row + col) % 2 == 0) continue;
        canvas.drawCircle(
          s(col * 0.14 + 0.07, row * 0.12 + 0.06, sz),
          sw(0.015, sz),
          _fill(color),
        );
      }
    }
  }

  void _paintWoodFloor(Canvas canvas, Size sz, double y, Color color) {
    _gradientRect(
      canvas,
      Rect.fromLTWH(0, sh(y, sz), sz.width, sh(1 - y, sz)),
      [color, _darken(color, 0.15)],
    );
    // Planks
    for (int i = 0; i < 5; i++) {
      canvas.drawLine(
        s(0, y + i * (1 - y) / 5, sz), s(1, y + i * (1 - y) / 5, sz),
        _stroke(_darken(color, 0.08), sh(0.003, sz)),
      );
    }
    for (int i = 0; i < 6; i++) {
      canvas.drawLine(
        s(i * 0.18, y, sz), s(i * 0.18, 1, sz),
        _stroke(_darken(color, 0.06), sw(0.002, sz)),
      );
    }
  }

  void _paintWindow(Canvas canvas, Size sz, double x, double y, double w, double h) {
    // Window frame
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(sw(x, sz), sh(y, sz), sw(w, sz), sh(h, sz)),
        Radius.circular(sw(0.01, sz)),
      ),
      _fill(Colors.white),
    );
    // Sky outside
    final skyColor = switch (config.timeOfDay) {
      DayTime.day => const Color(0xFF81D4FA),
      DayTime.dawn => const Color(0xFFFF9800),
      DayTime.dusk => const Color(0xFFE53935),
      DayTime.night => const Color(0xFF0D1B3E),
    };
    canvas.drawRect(
      Rect.fromLTWH(sw(x + 0.02, sz), sh(y + 0.025, sz), sw(w - 0.04, sz), sh(h - 0.05, sz)),
      _fill(skyColor),
    );
    // Window cross
    canvas.drawLine(
      s(x + w / 2, y + 0.025, sz), s(x + w / 2, y + h - 0.025, sz),
      _stroke(Colors.white, sw(0.012, sz)),
    );
    canvas.drawLine(
      s(x + 0.02, y + h / 2, sz), s(x + w - 0.02, y + h / 2, sz),
      _stroke(Colors.white, sw(0.012, sz)),
    );
    // Curtains
    final curtainL = Path();
    curtainL.moveTo(sw(x - 0.01, sz), sh(y - 0.01, sz));
    curtainL.quadraticBezierTo(sw(x + 0.04, sz), sh(y + h * 0.4, sz), sw(x + 0.02, sz), sh(y + h + 0.01, sz));
    curtainL.lineTo(sw(x - 0.01, sz), sh(y + h + 0.01, sz));
    canvas.drawPath(curtainL, _fill(const Color(0xFF9575CD).withOpacity(0.8)));
    final curtainR = Path();
    curtainR.moveTo(sw(x + w + 0.01, sz), sh(y - 0.01, sz));
    curtainR.quadraticBezierTo(sw(x + w - 0.04, sz), sh(y + h * 0.4, sz), sw(x + w - 0.02, sz), sh(y + h + 0.01, sz));
    curtainR.lineTo(sw(x + w + 0.01, sz), sh(y + h + 0.01, sz));
    canvas.drawPath(curtainR, _fill(const Color(0xFF9575CD).withOpacity(0.8)));
  }

  void _paintBed(Canvas canvas, Size sz) {
    // Bed frame
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(sw(0.55, sz), sh(0.55, sz), sw(0.42, sz), sh(0.30, sz)),
        Radius.circular(sw(0.02, sz)),
      ),
      _fill(const Color(0xFF8D6E63)),
    );
    // Mattress
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(sw(0.56, sz), sh(0.58, sz), sw(0.40, sz), sh(0.22, sz)),
        Radius.circular(sw(0.015, sz)),
      ),
      _fill(Colors.white),
    );
    // Pillow
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(sw(0.58, sz), sh(0.60, sz), sw(0.15, sz), sh(0.10, sz)),
        Radius.circular(sw(0.012, sz)),
      ),
      _fill(const Color(0xFFE1BEE7)),
    );
    // Blanket
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(sw(0.56, sz), sh(0.68, sz), sw(0.40, sz), sh(0.12, sz)),
        Radius.circular(sw(0.01, sz)),
      ),
      _fill(const Color(0xFF7986CB)),
    );
    // Headboard
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(sw(0.55, sz), sh(0.48, sz), sw(0.42, sz), sh(0.10, sz)),
        Radius.circular(sw(0.015, sz)),
      ),
      _fill(const Color(0xFF6D4C41)),
    );
  }

  void _paintLamp(Canvas canvas, Size sz, double groundY, double cx) {
    // Stand
    canvas.drawLine(
      s(cx, groundY - 0.22, sz), s(cx, groundY, sz),
      _stroke(const Color(0xFF9E9E9E), sw(0.012, sz)),
    );
    // Base
    canvas.drawOval(
      Rect.fromCenter(center: s(cx, groundY, sz), width: sw(0.06, sz), height: sh(0.02, sz)),
      _fill(const Color(0xFF9E9E9E)),
    );
    // Shade
    final shade = Path();
    shade.moveTo(sw(cx - 0.06, sz), sh(groundY - 0.10, sz));
    shade.lineTo(sw(cx + 0.06, sz), sh(groundY - 0.10, sz));
    shade.lineTo(sw(cx + 0.04, sz), sh(groundY - 0.22, sz));
    shade.lineTo(sw(cx - 0.04, sz), sh(groundY - 0.22, sz));
    shade.close();
    canvas.drawPath(shade, _fill(const Color(0xFFFFF9C4)));
    // Light glow
    if (config.timeOfDay == DayTime.night) {
      canvas.drawCircle(
        s(cx, groundY - 0.12, sz), sw(0.12, sz),
        Paint()..color = Colors.yellow.withOpacity(0.12),
      );
    }
  }

  void _paintPictureFrame(Canvas canvas, Size sz, double x, double y, double w, double h) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(sw(x, sz), sh(y, sz), sw(w, sz), sh(h, sz)),
        Radius.circular(sw(0.01, sz)),
      ),
      _fill(const Color(0xFF8D6E63)),
    );
    // Picture inside — simple landscape
    canvas.drawRect(
      Rect.fromLTWH(sw(x + 0.015, sz), sh(y + 0.025, sz), sw(w - 0.03, sz), sh(h - 0.05, sz)),
      _fill(const Color(0xFF81D4FA)),
    );
    canvas.drawRect(
      Rect.fromLTWH(sw(x + 0.015, sz), sh(y + h * 0.6, sz), sw(w - 0.03, sz), sh(h * 0.4 - 0.025, sz)),
      _fill(const Color(0xFF4CAF50)),
    );
  }

  // ── Kitchen ───────────────────────────────────────────────────────────────
  void _paintKitchen(Canvas canvas, Size sz) {
    // Walls — warm off-white
    canvas.drawRect(
      Rect.fromLTWH(0, 0, sz.width, sh(0.80, sz)),
      _fill(const Color(0xFFFFF8F0)),
    );
    // Tile splashback
    _paintKitchenTiles(canvas, sz, 0.30, 0.52, const Color(0xFFB2EBF2));
    _paintWoodFloor(canvas, sz, 0.80, const Color(0xFFD4A574));
    _paintCountertops(canvas, sz);
    _paintCabinets(canvas, sz);
    _paintWindow(canvas, sz, 0.35, 0.10, 0.30, 0.22);
    _paintKitchenAppliances(canvas, sz);
  }

  void _paintKitchenTiles(Canvas canvas, Size sz, double y1, double y2, Color color) {
    for (int row = 0; row < 4; row++) {
      for (int col = 0; col < 8; col++) {
        final tx = col * 0.13;
        final ty = y1 + row * (y2 - y1) / 4;
        canvas.drawRect(
          Rect.fromLTWH(sw(tx + 0.005, sz), sh(ty + 0.005, sz),
              sw(0.12, sz), sh((y2 - y1) / 4 - 0.01, sz)),
          _fill(color.withOpacity(0.7)),
        );
        canvas.drawRect(
          Rect.fromLTWH(sw(tx, sz), sh(ty, sz), sw(0.13, sz), sh((y2 - y1) / 4, sz)),
          _stroke(Colors.white, sw(0.003, sz)),
        );
      }
    }
  }

  void _paintCountertops(Canvas canvas, Size sz) {
    // Left counter
    canvas.drawRect(
      Rect.fromLTWH(0, sh(0.52, sz), sw(0.30, sz), sh(0.28, sz)),
      _fill(const Color(0xFF78909C)),
    );
    canvas.drawRect(
      Rect.fromLTWH(0, sh(0.52, sz), sw(0.32, sz), sh(0.025, sz)),
      _fill(const Color(0xFF90A4AE)),
    );
    // Right counter
    canvas.drawRect(
      Rect.fromLTWH(sw(0.70, sz), sh(0.52, sz), sw(0.30, sz), sh(0.28, sz)),
      _fill(const Color(0xFF78909C)),
    );
    canvas.drawRect(
      Rect.fromLTWH(sw(0.68, sz), sh(0.52, sz), sw(0.32, sz), sh(0.025, sz)),
      _fill(const Color(0xFF90A4AE)),
    );
  }

  void _paintCabinets(Canvas canvas, Size sz) {
    // Upper left
    for (int i = 0; i < 2; i++) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(sw(i * 0.16 + 0.02, sz), sh(0.08, sz), sw(0.14, sz), sh(0.22, sz)),
          Radius.circular(sw(0.008, sz)),
        ),
        _fill(const Color(0xFFFFFFFF)),
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(sw(i * 0.16 + 0.02, sz), sh(0.08, sz), sw(0.14, sz), sh(0.22, sz)),
          Radius.circular(sw(0.008, sz)),
        ),
        _stroke(const Color(0xFFCFD8DC), sw(0.004, sz)),
      );
      canvas.drawCircle(s(i * 0.16 + 0.09, 0.19, sz), sw(0.008, sz), _fill(const Color(0xFFB0BEC5)));
    }
    // Upper right
    for (int i = 0; i < 2; i++) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(sw(0.72 + i * 0.14, sz), sh(0.08, sz), sw(0.12, sz), sh(0.22, sz)),
          Radius.circular(sw(0.008, sz)),
        ),
        _fill(Colors.white),
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(sw(0.72 + i * 0.14, sz), sh(0.08, sz), sw(0.12, sz), sh(0.22, sz)),
          Radius.circular(sw(0.008, sz)),
        ),
        _stroke(const Color(0xFFCFD8DC), sw(0.004, sz)),
      );
    }
  }

  void _paintKitchenAppliances(Canvas canvas, Size sz) {
    // Sink
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(sw(0.36, sz), sh(0.545, sz), sw(0.28, sz), sh(0.12, sz)),
        Radius.circular(sw(0.01, sz)),
      ),
      _fill(const Color(0xFFB0BEC5)),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(sw(0.38, sz), sh(0.56, sz), sw(0.24, sz), sh(0.09, sz)),
        Radius.circular(sw(0.008, sz)),
      ),
      _fill(const Color(0xFF78909C)),
    );
    // Faucet
    canvas.drawRect(
      Rect.fromLTWH(sw(0.488, sz), sh(0.49, sz), sw(0.024, sz), sh(0.06, sz)),
      _fill(const Color(0xFF9E9E9E)),
    );
    canvas.drawOval(
      Rect.fromCenter(center: s(0.50, 0.50, sz), width: sw(0.04, sz), height: sh(0.015, sz)),
      _fill(const Color(0xFFBDBDBD)),
    );
  }

  // ── Classroom ─────────────────────────────────────────────────────────────
  void _paintClassroom(Canvas canvas, Size sz) {
    // Walls
    canvas.drawRect(
      Rect.fromLTWH(0, 0, sz.width, sh(0.82, sz)),
      _fill(const Color(0xFFF5F5DC)),
    );
    _paintWoodFloor(canvas, sz, 0.82, const Color(0xFFD4A574));
    _paintChalkboard(canvas, sz);
    _paintWindows(canvas, sz);
    _paintDesks(canvas, sz);
    _paintBookshelf(canvas, sz);
  }

  void _paintChalkboard(Canvas canvas, Size sz) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(sw(0.18, sz), sh(0.08, sz), sw(0.64, sz), sh(0.32, sz)),
        Radius.circular(sw(0.01, sz)),
      ),
      _fill(const Color(0xFF37474F)),
    );
    // Chalk writing (wavy lines)
    for (int i = 0; i < 3; i++) {
      final linePath = Path();
      linePath.moveTo(sw(0.22, sz), sh(0.14 + i * 0.07, sz));
      for (int j = 0; j < 8; j++) {
        linePath.quadraticBezierTo(
          sw(0.24 + j * 0.07, sz), sh(0.12 + i * 0.07 + (j % 2 == 0 ? 0.01 : -0.01), sz),
          sw(0.26 + j * 0.07, sz), sh(0.14 + i * 0.07, sz),
        );
      }
      canvas.drawPath(linePath, _stroke(Colors.white.withOpacity(0.5), sw(0.005, sz)));
    }
    // Chalk tray
    canvas.drawRect(
      Rect.fromLTWH(sw(0.18, sz), sh(0.40, sz), sw(0.64, sz), sh(0.018, sz)),
      _fill(const Color(0xFF546E7A)),
    );
    // Chalk pieces
    for (int i = 0; i < 3; i++) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(sw(0.28 + i * 0.10, sz), sh(0.400, sz), sw(0.05, sz), sh(0.012, sz)),
          Radius.circular(sw(0.004, sz)),
        ),
        _fill(Colors.white.withOpacity(0.8)),
      );
    }
  }

  void _paintWindows(Canvas canvas, Size sz) {
    _paintWindow(canvas, sz, 0.02, 0.12, 0.14, 0.30);
    _paintWindow(canvas, sz, 0.84, 0.12, 0.14, 0.30);
  }

  void _paintDesks(Canvas canvas, Size sz) {
    final desks = [(0.12, 0.65), (0.38, 0.65), (0.62, 0.65), (0.25, 0.76), (0.50, 0.76), (0.75, 0.76)];
    for (final (dx, dy) in desks) {
      // Desk top
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(sw(dx - 0.08, sz), sh(dy, sz), sw(0.16, sz), sh(0.04, sz)),
          Radius.circular(sw(0.005, sz)),
        ),
        _fill(const Color(0xFFD7A97B)),
      );
      // Legs
      canvas.drawRect(
        Rect.fromLTWH(sw(dx - 0.07, sz), sh(dy + 0.04, sz), sw(0.008, sz), sh(0.05, sz)),
        _fill(const Color(0xFF9E9E9E)),
      );
      canvas.drawRect(
        Rect.fromLTWH(sw(dx + 0.062, sz), sh(dy + 0.04, sz), sw(0.008, sz), sh(0.05, sz)),
        _fill(const Color(0xFF9E9E9E)),
      );
    }
  }

  void _paintBookshelf(Canvas canvas, Size sz) {
    canvas.drawRect(
      Rect.fromLTWH(sw(0.88, sz), sh(0.45, sz), sw(0.12, sz), sh(0.37, sz)),
      _fill(const Color(0xFF8D6E63)),
    );
    final bookColors = [Colors.red, Colors.blue, Colors.green, Colors.orange,
      Colors.purple, Colors.teal, Colors.pink];
    for (int i = 0; i < 7; i++) {
      canvas.drawRect(
        Rect.fromLTWH(sw(0.89, sz), sh(0.46 + i * 0.044, sz), sw(0.10, sz), sh(0.038, sz)),
        _fill(bookColors[i].withOpacity(0.8)),
      );
    }
  }

  // ── Salon ─────────────────────────────────────────────────────────────────
  void _paintSalon(Canvas canvas, Size sz) {
    // Walls — pale pink
    canvas.drawRect(
      Rect.fromLTWH(0, 0, sz.width, sh(0.82, sz)),
      _fill(const Color(0xFFFCE4EC)),
    );
    _paintWallpaperDots(canvas, sz, const Color(0xFFF48FB1).withOpacity(0.3));
    _paintTileFloor(canvas, sz, 0.82, const Color(0xFFFFFFFF), const Color(0xFFF8BBD9));
    _paintMirrorStation(canvas, sz, 0.08, 0.0, 0.38);
    _paintMirrorStation(canvas, sz, 0.56, 0.0, 0.38);
    _paintSalonChair(canvas, sz, 0.24, 0.55);
    _paintSalonChair(canvas, sz, 0.72, 0.55);
    _paintSalonProducts(canvas, sz);
  }

  void _paintTileFloor(Canvas canvas, Size sz, double y, Color light, Color dark) {
    for (int row = 0; row < 4; row++) {
      for (int col = 0; col < 8; col++) {
        final isLight = (row + col) % 2 == 0;
        canvas.drawRect(
          Rect.fromLTWH(sw(col * 0.125, sz), sh(y + row * (1 - y) / 4, sz),
              sw(0.125, sz), sh((1 - y) / 4, sz)),
          _fill(isLight ? light : dark),
        );
      }
    }
  }

  void _paintMirrorStation(Canvas canvas, Size sz, double x, double y, double w) {
    // Counter
    canvas.drawRect(
      Rect.fromLTWH(sw(x, sz), sh(0.50, sz), sw(w, sz), sh(0.32, sz)),
      _fill(const Color(0xFFFFFFFF)),
    );
    canvas.drawRect(
      Rect.fromLTWH(sw(x, sz), sh(0.50, sz), sw(w, sz), sh(0.018, sz)),
      _fill(const Color(0xFFF8BBD9)),
    );
    // Mirror
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(sw(x + 0.04, sz), sh(y + 0.06, sz), sw(w - 0.08, sz), sh(0.42, sz)),
        Radius.circular(sw(0.015, sz)),
      ),
      _fill(const Color(0xFFE0F7FA)),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(sw(x + 0.04, sz), sh(y + 0.06, sz), sw(w - 0.08, sz), sh(0.42, sz)),
        Radius.circular(sw(0.015, sz)),
      ),
      _stroke(const Color(0xFFF48FB1), sw(0.012, sz)),
    );
    // Mirror light bulbs
    for (int i = 0; i < 4; i++) {
      canvas.drawCircle(
        s(x + 0.04 + i * ((w - 0.08) / 3), y + 0.06, sz),
        sw(0.012, sz),
        _fill(Colors.yellow.withOpacity(0.8)),
      );
    }
  }

  void _paintSalonChair(Canvas canvas, Size sz, double cx, double y) {
    // Base
    canvas.drawRect(
      Rect.fromLTWH(sw(cx - 0.06, sz), sh(y + 0.20, sz), sw(0.12, sz), sh(0.04, sz)),
      _fill(const Color(0xFF9E9E9E)),
    );
    canvas.drawLine(s(cx, y + 0.24, sz), s(cx, y + 0.28, sz),
        _stroke(const Color(0xFF9E9E9E), sw(0.025, sz)));
    // Seat
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(sw(cx - 0.08, sz), sh(y + 0.12, sz), sw(0.16, sz), sh(0.09, sz)),
        Radius.circular(sw(0.015, sz)),
      ),
      _fill(const Color(0xFFEC407A)),
    );
    // Back
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(sw(cx - 0.07, sz), sh(y, sz), sw(0.14, sz), sh(0.13, sz)),
        Radius.circular(sw(0.02, sz)),
      ),
      _fill(const Color(0xFFEC407A)),
    );
    // Armrests
    for (final ax in [cx - 0.09, cx + 0.06]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(sw(ax, sz), sh(y + 0.10, sz), sw(0.03, sz), sh(0.04, sz)),
          Radius.circular(sw(0.008, sz)),
        ),
        _fill(const Color(0xFFC62828)),
      );
    }
  }

  void _paintSalonProducts(Canvas canvas, Size sz) {
    final products = [(0.10, 0.46), (0.14, 0.46), (0.18, 0.46),
                      (0.60, 0.46), (0.64, 0.46), (0.68, 0.46)];
    final colors = [Colors.pink, Colors.purple, Colors.teal,
                    Colors.pink, Colors.orange, Colors.blue];
    for (int i = 0; i < products.length; i++) {
      final (px, py) = products[i];
      // Bottle
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(sw(px, sz), sh(py, sz), sw(0.028, sz), sh(0.06, sz)),
          Radius.circular(sw(0.008, sz)),
        ),
        _fill(colors[i].withOpacity(0.8)),
      );
      // Cap
      canvas.drawRect(
        Rect.fromLTWH(sw(px + 0.004, sz), sh(py - 0.015, sz), sw(0.020, sz), sh(0.018, sz)),
        _fill(_darken(colors[i], 0.15)),
      );
    }
  }

  // ── Space ─────────────────────────────────────────────────────────────────
  void _paintSpace(Canvas canvas, Size sz) {
    // Deep space gradient
    _gradientRect(canvas, Rect.fromLTWH(0, 0, sz.width, sz.height),
        [const Color(0xFF000005), const Color(0xFF0A0020), const Color(0xFF000510)]);
    _paintNebula(canvas, sz);
    _paintSpaceStars(canvas, sz);
    _paintPlanets(canvas, sz);
    _paintMilkyWay(canvas, sz);
  }

  void _paintNebula(Canvas canvas, Size sz) {
    final nebulae = [
      (0.25, 0.30, const Color(0xFF4A148C), 0.20),
      (0.70, 0.45, const Color(0xFF0D47A1), 0.18),
      (0.50, 0.70, const Color(0xFF880E4F), 0.15),
    ];
    for (final (nx, ny, color, radius) in nebulae) {
      canvas.drawCircle(
        s(nx, ny, sz), sw(radius, sz),
        Paint()
          ..color = color.withOpacity(0.25)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, sw(0.08, sz)),
      );
    }
  }

  void _paintSpaceStars(Canvas canvas, Size sz) {
    final starData = [
      (0.05, 0.08, 0.8), (0.12, 0.22, 0.6), (0.20, 0.05, 1.0), (0.28, 0.35, 0.7),
      (0.35, 0.12, 0.9), (0.42, 0.55, 0.5), (0.50, 0.18, 0.8), (0.58, 0.42, 0.6),
      (0.65, 0.08, 1.0), (0.72, 0.28, 0.7), (0.80, 0.60, 0.9), (0.88, 0.15, 0.8),
      (0.93, 0.38, 0.6), (0.15, 0.70, 0.7), (0.33, 0.82, 0.5), (0.55, 0.88, 0.6),
      (0.78, 0.75, 0.8), (0.95, 0.80, 0.7),
    ];
    for (final (sx, sy, brightness) in starData) {
      canvas.drawCircle(
        s(sx, sy, sz), sw(0.006, sz),
        _fill(Colors.white.withOpacity(brightness)),
      );
      // Twinkle cross
      if (brightness > 0.75) {
        canvas.drawLine(
          s(sx - 0.015, sy, sz), s(sx + 0.015, sy, sz),
          _stroke(Colors.white.withOpacity(0.3), sw(0.002, sz)),
        );
        canvas.drawLine(
          s(sx, sy - 0.02, sz), s(sx, sy + 0.02, sz),
          _stroke(Colors.white.withOpacity(0.3), sw(0.002, sz)),
        );
      }
    }
  }

  void _paintPlanets(Canvas canvas, Size sz) {
    // Large planet
    final p1 = Paint()
      ..shader = RadialGradient(colors: [
        const Color(0xFF42A5F5), const Color(0xFF1565C0), const Color(0xFF0D47A1),
      ]).createShader(Rect.fromCircle(center: s(0.78, 0.22, sz), radius: sw(0.12, sz)));
    canvas.drawCircle(s(0.78, 0.22, sz), sw(0.12, sz), p1);
    // Planet rings
    final ringPaint = Paint()
      ..color = const Color(0xFF90CAF9).withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = sh(0.015, sz);
    canvas.drawOval(
      Rect.fromCenter(center: s(0.78, 0.22, sz), width: sw(0.30, sz), height: sh(0.05, sz)),
      ringPaint,
    );
    // Small planet
    canvas.drawCircle(s(0.18, 0.68, sz), sw(0.06, sz),
        _fill(const Color(0xFFE57373).withOpacity(0.9)));
    canvas.drawCircle(s(0.20, 0.66, sz), sw(0.02, sz),
        _fill(Colors.white.withOpacity(0.15)));
    // Moon
    canvas.drawCircle(s(0.30, 0.80, sz), sw(0.025, sz),
        _fill(const Color(0xFFB0BEC5)));
  }

  void _paintMilkyWay(Canvas canvas, Size sz) {
    final milkyPaint = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, sw(0.04, sz));
    final path = Path();
    path.moveTo(0, sh(0.60, sz));
    path.quadraticBezierTo(sw(0.40, sz), sh(0.30, sz), sw(1.0, sz), sh(0.50, sz));
    path.lineTo(sw(1.0, sz), sh(0.65, sz));
    path.quadraticBezierTo(sw(0.40, sz), sh(0.45, sz), 0, sh(0.75, sz));
    path.close();
    canvas.drawPath(path, milkyPaint);
  }

  // ── Underwater ────────────────────────────────────────────────────────────
  void _paintUnderwater(Canvas canvas, Size sz) {
    // Water gradient
    _gradientRect(canvas, Rect.fromLTWH(0, 0, sz.width, sz.height), [
      const Color(0xFF0277BD),
      const Color(0xFF01579B),
      const Color(0xFF002171),
    ]);
    _paintLightShafts(canvas, sz);
    _paintCoral(canvas, sz);
    _paintSeaweed(canvas, sz);
    _paintSandBottom(canvas, sz);
    _paintFish(canvas, sz);
    _paintBubbles(canvas, sz);
  }

  void _paintLightShafts(Canvas canvas, Size sz) {
    final shaftPaint = Paint()
      ..color = Colors.white.withOpacity(0.06)
      ..style = PaintingStyle.fill;
    for (int i = 0; i < 4; i++) {
      final cx = 0.15 + i * 0.24;
      final path = Path();
      path.moveTo(sw(cx - 0.04, sz), 0);
      path.lineTo(sw(cx + 0.04, sz), 0);
      path.lineTo(sw(cx + 0.12, sz), sz.height);
      path.lineTo(sw(cx - 0.12, sz), sz.height);
      path.close();
      canvas.drawPath(path, shaftPaint);
    }
  }

  void _paintCoral(Canvas canvas, Size sz) {
    final coralData = [
      (0.08, 0.75, const Color(0xFFE91E63), 5),
      (0.22, 0.78, const Color(0xFFFF5722), 4),
      (0.70, 0.76, const Color(0xFFFF4081), 6),
      (0.85, 0.74, const Color(0xFFE040FB), 4),
    ];
    for (final (cx, cy, color, branches) in coralData) {
      _drawCoral(canvas, sz, cx, cy, color, branches);
    }
  }

  void _drawCoral(Canvas canvas, Size sz, double cx, double cy, Color color, int branches) {
    final stemH = u(0.22, sz);
    final stemPaint = _stroke(color, u(0.018, sz));
    final base = s(cx, cy, sz);
    canvas.drawLine(base, Offset(base.dx, base.dy - stemH), stemPaint);
    for (int i = 0; i < branches; i++) {
      final t = (i + 1) / (branches + 1);
      final dir = i % 2 == 0 ? 1.0 : -1.0;
      final bx = base.dx + dir * u(0.06 + i * 0.015, sz);
      final by = base.dy - stemH * t;
      canvas.drawLine(
        Offset(base.dx, by), Offset(bx, by - u(0.08, sz)),
        _stroke(_lighten(color, 0.12), u(0.012, sz)),
      );
      // Tip dot
      canvas.drawCircle(Offset(bx, by - u(0.08, sz)), u(0.016, sz),
          _fill(_lighten(color, 0.2)));
    }
  }

  void _paintSeaweed(Canvas canvas, Size sz) {
    for (final (sx, direction) in [(0.35, 1), (0.50, -1), (0.60, 1), (0.92, -1)]) {
      final path = Path();
      path.moveTo(sw(sx, sz), sh(1.0, sz));
      for (int i = 0; i < 5; i++) {
        final cx = sx + direction * 0.04 * ((i % 2) * 2 - 1);
        final y = 1.0 - (i + 1) * 0.10;
        path.quadraticBezierTo(sw(cx, sz), sh(y + 0.05, sz), sw(sx, sz), sh(y, sz));
      }
      canvas.drawPath(path, _stroke(const Color(0xFF2E7D32), sw(0.018, sz)));
    }
  }

  void _paintSandBottom(Canvas canvas, Size sz) {
    _gradientRect(
      canvas,
      Rect.fromLTWH(0, sh(0.86, sz), sz.width, sh(0.14, sz)),
      [const Color(0xFFD4A017), const Color(0xFFB8860B)],
    );
    // Sand ripples
    for (int i = 0; i < 4; i++) {
      canvas.drawOval(
        Rect.fromCenter(center: s(0.20 + i * 0.22, 0.89, sz),
            width: sw(0.14, sz), height: sh(0.018, sz)),
        _stroke(Colors.white.withOpacity(0.2), sw(0.004, sz)),
      );
    }
  }

  void _paintFish(Canvas canvas, Size sz) {
    final fishData = [
      (0.35, 0.30, const Color(0xFFFF9800), 1.0),
      (0.62, 0.50, const Color(0xFF29B6F6), -1.0),
      (0.15, 0.55, const Color(0xFFFF5722), 1.0),
      (0.80, 0.35, const Color(0xFFFFEB3B), -1.0),
    ];
    for (final (fx, fy, color, dir) in fishData) {
      _drawFish(canvas, sz, fx, fy, color, dir);
    }
  }

  void _drawFish(Canvas canvas, Size sz, double cx, double cy, Color color, double dir) {
    final bw = u(0.10, sz); // body half-length — height based
    final bh = u(0.040, sz);

    // Body
    final body = Path();
    body.moveTo(s(cx, cy, sz).dx + dir * bw, s(cx, cy, sz).dy);
    body.quadraticBezierTo(
      s(cx, cy, sz).dx + dir * bw * 0.4, s(cx, cy, sz).dy - bh,
      s(cx, cy, sz).dx - dir * bw * 0.6, s(cx, cy, sz).dy,
    );
    body.quadraticBezierTo(
      s(cx, cy, sz).dx + dir * bw * 0.4, s(cx, cy, sz).dy + bh,
      s(cx, cy, sz).dx + dir * bw, s(cx, cy, sz).dy,
    );
    canvas.drawPath(body, _fill(color));

    // Tail
    final tail = Path();
    final tailX = s(cx, cy, sz).dx - dir * bw * 0.6;
    tail.moveTo(tailX, s(cx, cy, sz).dy);
    tail.lineTo(tailX - dir * bw * 0.5, s(cx, cy, sz).dy - bh);
    tail.lineTo(tailX - dir * bw * 0.5, s(cx, cy, sz).dy + bh);
    tail.close();
    canvas.drawPath(tail, _fill(_darken(color, 0.12)));

    // Fin on top
    final finPath = Path();
    finPath.moveTo(s(cx, cy, sz).dx, s(cx, cy, sz).dy - bh * 0.5);
    finPath.quadraticBezierTo(
      s(cx, cy, sz).dx + dir * bw * 0.2, s(cx, cy, sz).dy - bh * 1.5,
      s(cx, cy, sz).dx + dir * bw * 0.4, s(cx, cy, sz).dy - bh * 0.6,
    );
    canvas.drawPath(finPath, _stroke(_darken(color, 0.08), u(0.008, sz)));

    // Eye
    canvas.drawCircle(
      Offset(s(cx, cy, sz).dx + dir * bw * 0.55, s(cx, cy, sz).dy - bh * 0.25),
      u(0.014, sz), _fill(Colors.white),
    );
    canvas.drawCircle(
      Offset(s(cx, cy, sz).dx + dir * bw * 0.55, s(cx, cy, sz).dy - bh * 0.25),
      u(0.007, sz), _fill(Colors.black87),
    );

    // Stripe
    canvas.drawLine(
      Offset(s(cx, cy, sz).dx + dir * bw * 0.1, s(cx, cy, sz).dy - bh * 0.85),
      Offset(s(cx, cy, sz).dx + dir * bw * 0.1, s(cx, cy, sz).dy + bh * 0.85),
      _stroke(Colors.white.withOpacity(0.35), u(0.007, sz)),
    );
  }

  void _paintBubbles(Canvas canvas, Size sz) {
    final bubbles = [
      (0.10, 0.50, 0.020), (0.25, 0.35, 0.030), (0.45, 0.20, 0.016),
      (0.65, 0.40, 0.024), (0.80, 0.25, 0.034), (0.90, 0.55, 0.018),
    ];
    for (final (bx, by, r) in bubbles) {
      final rad = u(r, sz);
      canvas.drawCircle(s(bx, by, sz), rad,
          _stroke(Colors.white.withOpacity(0.45), u(0.006, sz)));
      // Shine highlight
      canvas.drawArc(
        Rect.fromCircle(center: Offset(s(bx, by, sz).dx - rad * 0.3, s(bx, by, sz).dy - rad * 0.3), radius: rad * 0.38),
        -1.0, 1.2, false,
        _stroke(Colors.white.withOpacity(0.7), u(0.004, sz)),
      );
    }
  }

  @override
  bool shouldRepaint(ScenePainter old) =>
      old.config.type != config.type ||
      old.config.timeOfDay != config.timeOfDay ||
      old.config.weather != config.weather;
}
