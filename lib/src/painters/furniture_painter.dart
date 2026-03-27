import 'package:flutter/material.dart';
import '../models/object_config.dart';

/// Paints one of 8 cartoon furniture/room items. All drawing fits inside [Size].
class FurniturePainter extends CustomPainter {
  final FurnitureType type;
  final Color primaryColor;
  final Color? secondaryColor;

  FurniturePainter({
    required this.type,
    required this.primaryColor,
    this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    switch (type) {
      case FurnitureType.chair:  _paintChair(canvas, size);
      case FurnitureType.table:  _paintTable(canvas, size);
      case FurnitureType.bed:    _paintBed(canvas, size);
      case FurnitureType.sofa:   _paintSofa(canvas, size);
      case FurnitureType.lamp:   _paintLamp(canvas, size);
      case FurnitureType.mirror: _paintMirror(canvas, size);
      case FurnitureType.shelf:  _paintShelf(canvas, size);
      case FurnitureType.door:   _paintDoor(canvas, size);
    }
  }

  @override
  bool shouldRepaint(FurniturePainter old) =>
      old.type != type || old.primaryColor != primaryColor;

  // ── Helpers ────────────────────────────────────────────────────────────────
  Offset _s(double x, double y, Size sz) => Offset(x * sz.width, y * sz.height);
  double _sw(double x, Size sz) => x * sz.width;
  double _sh(double y, Size sz) => y * sz.height;
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

  void _rect(Canvas canvas, double x, double y, double w, double h, Color c,
      {double r = 0.0, Size? sz}) {
    final rect = sz != null
        ? Rect.fromLTWH(_sw(x, sz), _sh(y, sz), _sw(w, sz), _sh(h, sz))
        : Rect.fromLTWH(x, y, w, h);
    if (r > 0) {
      canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(r)), _fill(c));
    } else {
      canvas.drawRect(rect, _fill(c));
    }
  }

  // ── Chair ──────────────────────────────────────────────────────────────────
  void _paintChair(Canvas canvas, Size sz) {
    final wood = primaryColor;
    final dark = _darken(wood, 0.15);
    final cushion = secondaryColor ?? const Color(0xFF9C27B0);
    final u = _u(1, sz);

    // Back legs
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(_sw(0.16, sz), _sh(0.32, sz), _sw(0.08, sz), _sh(0.58, sz)),
        Radius.circular(u * 0.02),
      ),
      _fill(dark),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(_sw(0.76, sz), _sh(0.32, sz), _sw(0.08, sz), _sh(0.58, sz)),
        Radius.circular(u * 0.02),
      ),
      _fill(dark),
    );
    // Front legs
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(_sw(0.18, sz), _sh(0.58, sz), _sw(0.08, sz), _sh(0.34, sz)),
        Radius.circular(u * 0.02),
      ),
      _fill(wood),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(_sw(0.74, sz), _sh(0.58, sz), _sw(0.08, sz), _sh(0.34, sz)),
        Radius.circular(u * 0.02),
      ),
      _fill(wood),
    );
    // Seat
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(_sw(0.12, sz), _sh(0.54, sz), _sw(0.76, sz), _sh(0.10, sz)),
        Radius.circular(u * 0.03),
      ),
      _fill(cushion),
    );
    // Seat cushion highlight
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(_sw(0.16, sz), _sh(0.54, sz), _sw(0.68, sz), _sh(0.04, sz)),
        Radius.circular(u * 0.02),
      ),
      _fill(_lighten(cushion, 0.15)),
    );
    // Back rest
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(_sw(0.12, sz), _sh(0.18, sz), _sw(0.76, sz), _sh(0.16, sz)),
        Radius.circular(u * 0.04),
      ),
      _fill(cushion),
    );
    // Back support spindles
    for (final sx in [0.32, 0.50, 0.68]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(_sw(sx - 0.03, sz), _sh(0.34, sz), _sw(0.06, sz), _sh(0.20, sz)),
          Radius.circular(u * 0.015),
        ),
        _fill(dark),
      );
    }
  }

  // ── Table ──────────────────────────────────────────────────────────────────
  void _paintTable(Canvas canvas, Size sz) {
    final wood = primaryColor;
    final dark = _darken(wood, 0.12);
    final u = _u(1, sz);

    // Legs
    for (final lx in [0.14, 0.80]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(_sw(lx, sz), _sh(0.44, sz), _sw(0.08, sz), _sh(0.48, sz)),
          Radius.circular(u * 0.02),
        ),
        _fill(dark),
      );
    }
    // Cross support
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(_sw(0.16, sz), _sh(0.70, sz), _sw(0.68, sz), _sh(0.05, sz)),
        Radius.circular(u * 0.01),
      ),
      _fill(dark),
    );
    // Tabletop
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(_sw(0.06, sz), _sh(0.30, sz), _sw(0.88, sz), _sh(0.14, sz)),
        Radius.circular(u * 0.04),
      ),
      _fill(wood),
    );
    // Wood grain lines
    for (int i = 0; i < 3; i++) {
      canvas.drawLine(
        _s(0.10, 0.36 + i * 0.03, sz), _s(0.90, 0.36 + i * 0.03, sz),
        _stroke(dark.withOpacity(0.25), u * 0.008),
      );
    }
    // Edge shadow
    canvas.drawLine(
      _s(0.06, 0.44, sz), _s(0.94, 0.44, sz),
      _stroke(dark.withOpacity(0.4), u * 0.012),
    );
  }

  // ── Bed ────────────────────────────────────────────────────────────────────
  void _paintBed(Canvas canvas, Size sz) {
    final frame = primaryColor;
    final dark = _darken(frame, 0.12);
    final sheet = secondaryColor ?? const Color(0xFFF8BBD0);
    final u = _u(1, sz);

    // Frame base
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(_sw(0.06, sz), _sh(0.40, sz), _sw(0.88, sz), _sh(0.48, sz)),
        Radius.circular(u * 0.04),
      ),
      _fill(frame),
    );
    // Mattress
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(_sw(0.10, sz), _sh(0.36, sz), _sw(0.80, sz), _sh(0.28, sz)),
        Radius.circular(u * 0.04),
      ),
      _fill(Colors.white),
    );
    // Sheet
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(_sw(0.10, sz), _sh(0.36, sz), _sw(0.80, sz), _sh(0.22, sz)),
        Radius.circular(u * 0.03),
      ),
      _fill(sheet),
    );
    // Pillow
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(_sw(0.16, sz), _sh(0.30, sz), _sw(0.30, sz), _sh(0.14, sz)),
        Radius.circular(u * 0.04),
      ),
      _fill(Colors.white),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(_sw(0.54, sz), _sh(0.30, sz), _sw(0.30, sz), _sh(0.14, sz)),
        Radius.circular(u * 0.04),
      ),
      _fill(Colors.white),
    );
    // Headboard
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(_sw(0.06, sz), _sh(0.14, sz), _sw(0.88, sz), _sh(0.26, sz)),
        Radius.circular(u * 0.06),
      ),
      _fill(dark),
    );
    // Headboard panel
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(_sw(0.14, sz), _sh(0.18, sz), _sw(0.72, sz), _sh(0.18, sz)),
        Radius.circular(u * 0.04),
      ),
      _fill(_lighten(dark, 0.10)),
    );
    // Feet
    for (final fx in [0.12, 0.82]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(_sw(fx, sz), _sh(0.86, sz), _sw(0.07, sz), _sh(0.08, sz)),
          Radius.circular(u * 0.02),
        ),
        _fill(dark),
      );
    }
  }

  // ── Sofa ───────────────────────────────────────────────────────────────────
  void _paintSofa(Canvas canvas, Size sz) {
    final base = primaryColor;
    final dark = _darken(base, 0.12);
    final light = _lighten(base, 0.10);
    final u = _u(1, sz);

    // Legs
    for (final lx in [0.12, 0.82]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(_sw(lx, sz), _sh(0.80, sz), _sw(0.06, sz), _sh(0.14, sz)),
          Radius.circular(u * 0.02),
        ),
        _fill(dark),
      );
    }
    // Base body
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(_sw(0.06, sz), _sh(0.56, sz), _sw(0.88, sz), _sh(0.28, sz)),
        Radius.circular(u * 0.05),
      ),
      _fill(base),
    );
    // Seat cushions
    for (final cx in [0.22, 0.50, 0.78]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(_sw(cx - 0.14, sz), _sh(0.52, sz), _sw(0.28, sz), _sh(0.14, sz)),
          Radius.circular(u * 0.04),
        ),
        _fill(light),
      );
    }
    // Backrest
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(_sw(0.06, sz), _sh(0.30, sz), _sw(0.88, sz), _sh(0.26, sz)),
        Radius.circular(u * 0.05),
      ),
      _fill(base),
    );
    // Back cushions
    for (final cx in [0.22, 0.50, 0.78]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(_sw(cx - 0.14, sz), _sh(0.32, sz), _sw(0.28, sz), _sh(0.22, sz)),
          Radius.circular(u * 0.04),
        ),
        _fill(light),
      );
    }
    // Armrests
    for (final ax in [0.06, 0.82]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(_sw(ax, sz), _sh(0.40, sz), _sw(0.12, sz), _sh(0.44, sz)),
          Radius.circular(u * 0.05),
        ),
        _fill(dark),
      );
    }
  }

  // ── Lamp ───────────────────────────────────────────────────────────────────
  void _paintLamp(Canvas canvas, Size sz) {
    final shade = primaryColor;
    final dark = _darken(shade, 0.15);
    final u = _u(1, sz);
    const metal = Color(0xFF9E9E9E);

    // Base
    canvas.drawOval(
      Rect.fromCenter(center: _s(0.50, 0.90, sz), width: _sw(0.50, sz), height: _sh(0.08, sz)),
      _fill(metal),
    );
    // Stem
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: _s(0.50, 0.72, sz), width: _u(0.04, sz), height: _u(0.30, sz)),
        Radius.circular(u * 0.01),
      ),
      _fill(metal),
    );
    // Neck knob
    canvas.drawCircle(_s(0.50, 0.56, sz), u * 0.04, _fill(metal));
    // Shade (trapezoid)
    final shadePath = Path()
      ..moveTo(_s(0.28, 0.54, sz).dx, _s(0.0, 0.54, sz).dy)
      ..lineTo(_s(0.18, 0.24, sz).dx, _s(0.0, 0.24, sz).dy)
      ..lineTo(_s(0.82, 0.24, sz).dx, _s(0.0, 0.24, sz).dy)
      ..lineTo(_s(0.72, 0.54, sz).dx, _s(0.0, 0.54, sz).dy)
      ..close();
    canvas.drawPath(shadePath, _fill(shade));
    // Shade bottom rim
    canvas.drawLine(_s(0.28, 0.54, sz), _s(0.72, 0.54, sz), _stroke(dark, u * 0.020));
    // Shade top rim
    canvas.drawLine(_s(0.18, 0.24, sz), _s(0.82, 0.24, sz), _stroke(dark, u * 0.016));
    // Glow from bulb
    canvas.drawCircle(_s(0.50, 0.56, sz), u * 0.14,
        _fill(const Color(0xFFFFF9C4).withOpacity(0.35)));
    // Shade highlight
    canvas.drawLine(_s(0.30, 0.28, sz), _s(0.36, 0.52, sz),
        _stroke(Colors.white.withOpacity(0.3), u * 0.030));
  }

  // ── Mirror ─────────────────────────────────────────────────────────────────
  void _paintMirror(Canvas canvas, Size sz) {
    final frame = primaryColor;
    final dark = _darken(frame, 0.12);
    final u = _u(1, sz);

    // Frame
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(_sw(0.14, sz), _sh(0.06, sz), _sw(0.72, sz), _sh(0.80, sz)),
        Radius.circular(u * 0.08),
      ),
      _fill(frame),
    );
    // Mirror glass
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(_sw(0.22, sz), _sh(0.12, sz), _sw(0.56, sz), _sh(0.66, sz)),
        Radius.circular(u * 0.04),
      ),
      _fill(const Color(0xFFB3E5FC).withOpacity(0.5)),
    );
    // Glass reflection sheen
    canvas.drawLine(_s(0.28, 0.14, sz), _s(0.38, 0.76, sz),
        _stroke(Colors.white.withOpacity(0.4), u * 0.030));
    canvas.drawLine(_s(0.38, 0.14, sz), _s(0.44, 0.76, sz),
        _stroke(Colors.white.withOpacity(0.2), u * 0.016));
    // Frame decorative corners
    for (final (cx, cy) in [
      (0.14, 0.06), (0.86, 0.06), (0.14, 0.86), (0.86, 0.86)
    ]) {
      canvas.drawCircle(_s(cx, cy, sz), u * 0.04, _fill(dark));
    }
    // Frame edge detail
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(_sw(0.14, sz), _sh(0.06, sz), _sw(0.72, sz), _sh(0.80, sz)),
        Radius.circular(u * 0.08),
      ),
      _stroke(dark, u * 0.016),
    );
    // Stand
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(_sw(0.42, sz), _sh(0.86, sz), _sw(0.16, sz), _sh(0.08, sz)),
        Radius.circular(u * 0.02),
      ),
      _fill(dark),
    );
    canvas.drawOval(
      Rect.fromCenter(center: _s(0.50, 0.95, sz), width: _sw(0.32, sz), height: _sh(0.04, sz)),
      _fill(dark),
    );
  }

  // ── Shelf ──────────────────────────────────────────────────────────────────
  void _paintShelf(Canvas canvas, Size sz) {
    final wood = primaryColor;
    final dark = _darken(wood, 0.15);
    final u = _u(1, sz);

    // Back board
    canvas.drawRect(
      Rect.fromLTWH(_sw(0.06, sz), _sh(0.10, sz), _sw(0.88, sz), _sh(0.82, sz)),
      _fill(_darken(wood, 0.08)),
    );
    // Three shelves
    for (int i = 0; i < 3; i++) {
      final y = 0.18 + i * 0.26;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(_sw(0.06, sz), _sh(y, sz), _sw(0.88, sz), _sh(0.07, sz)),
          Radius.circular(u * 0.02),
        ),
        _fill(wood),
      );
      // Shelf edge shadow
      canvas.drawLine(_s(0.06, y + 0.07, sz), _s(0.94, y + 0.07, sz),
          _stroke(dark.withOpacity(0.3), u * 0.010));
    }
    // Side panels
    for (final sx in [0.06, 0.88]) {
      canvas.drawRect(
        Rect.fromLTWH(_sw(sx, sz), _sh(0.10, sz), _sw(0.06, sz), _sh(0.82, sz)),
        _fill(dark),
      );
    }
    // Small items on shelves
    // Shelf 1: two books
    canvas.drawRect(
      Rect.fromLTWH(_sw(0.16, sz), _sh(0.10, sz), _sw(0.08, sz), _sh(0.08, sz)),
      _fill(const Color(0xFFE53935)),
    );
    canvas.drawRect(
      Rect.fromLTWH(_sw(0.25, sz), _sh(0.10, sz), _sw(0.06, sz), _sh(0.08, sz)),
      _fill(const Color(0xFF1565C0)),
    );
    // Shelf 2: small plant pot
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(_sw(0.44, sz), _sh(0.36, sz), _sw(0.12, sz), _sh(0.08, sz)),
        Radius.circular(u * 0.02),
      ),
      _fill(const Color(0xFF8D6E63)),
    );
    canvas.drawCircle(_s(0.50, 0.32, sz), u * 0.04, _fill(const Color(0xFF43A047)));
    // Shelf 3: small frame
    canvas.drawRect(
      Rect.fromLTWH(_sw(0.64, sz), _sh(0.62, sz), _sw(0.10, sz), _sh(0.08, sz)),
      _fill(dark),
    );
    canvas.drawRect(
      Rect.fromLTWH(_sw(0.66, sz), _sh(0.63, sz), _sw(0.06, sz), _sh(0.06, sz)),
      _fill(const Color(0xFFB3E5FC).withOpacity(0.6)),
    );
  }

  // ── Door ───────────────────────────────────────────────────────────────────
  void _paintDoor(Canvas canvas, Size sz) {
    final wood = primaryColor;
    final dark = _darken(wood, 0.15);
    final light = _lighten(wood, 0.12);
    final u = _u(1, sz);

    // Door frame
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(_sw(0.04, sz), _sh(0.04, sz), _sw(0.92, sz), _sh(0.92, sz)),
        Radius.circular(u * 0.03),
      ),
      _fill(dark),
    );
    // Door body
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(_sw(0.10, sz), _sh(0.06, sz), _sw(0.80, sz), _sh(0.88, sz)),
        Radius.circular(u * 0.02),
      ),
      _fill(wood),
    );
    // Top panels (2)
    for (final cx in [0.30, 0.70]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(_sw(cx - 0.16, sz), _sh(0.12, sz), _sw(0.32, sz), _sh(0.22, sz)),
          Radius.circular(u * 0.03),
        ),
        _fill(light),
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(_sw(cx - 0.16, sz), _sh(0.12, sz), _sw(0.32, sz), _sh(0.22, sz)),
          Radius.circular(u * 0.03),
        ),
        _stroke(dark.withOpacity(0.4), u * 0.010),
      );
    }
    // Bottom panels (2)
    for (final cx in [0.30, 0.70]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(_sw(cx - 0.16, sz), _sh(0.42, sz), _sw(0.32, sz), _sh(0.42, sz)),
          Radius.circular(u * 0.03),
        ),
        _fill(light),
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(_sw(cx - 0.16, sz), _sh(0.42, sz), _sw(0.32, sz), _sh(0.42, sz)),
          Radius.circular(u * 0.03),
        ),
        _stroke(dark.withOpacity(0.4), u * 0.010),
      );
    }
    // Doorknob
    canvas.drawCircle(_s(0.72, 0.56, sz), u * 0.045, _fill(const Color(0xFFFFC107)));
    canvas.drawCircle(_s(0.70, 0.54, sz), u * 0.016,
        _fill(Colors.white.withOpacity(0.5)));
    // Hinge hints
    for (final hy in [0.20, 0.50, 0.78]) {
      canvas.drawRect(
        Rect.fromCenter(center: _s(0.12, hy, sz), width: _u(0.028, sz), height: _u(0.055, sz)),
        _fill(const Color(0xFFBDBDBD)),
      );
    }
  }
}
