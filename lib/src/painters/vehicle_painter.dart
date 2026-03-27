import 'package:flutter/material.dart';
import '../models/object_config.dart';

/// Paints one of 6 cartoon vehicles. All drawing fits inside the given [Size].
class VehiclePainter extends CustomPainter {
  final VehicleType type;
  final Color primaryColor;
  final Color? secondaryColor;

  VehiclePainter({
    required this.type,
    required this.primaryColor,
    this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    switch (type) {
      case VehicleType.car:    _paintCar(canvas, size);
      case VehicleType.bus:    _paintBus(canvas, size);
      case VehicleType.bike:   _paintBike(canvas, size);
      case VehicleType.plane:  _paintPlane(canvas, size);
      case VehicleType.boat:   _paintBoat(canvas, size);
      case VehicleType.rocket: _paintRocket(canvas, size);
    }
  }

  @override
  bool shouldRepaint(VehiclePainter old) =>
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

  void _wheel(Canvas canvas, Offset center, double r) {
    canvas.drawCircle(center, r, _fill(const Color(0xFF212121)));
    canvas.drawCircle(center, r * 0.65, _fill(const Color(0xFF616161)));
    canvas.drawCircle(center, r * 0.28, _fill(const Color(0xFFBDBDBD)));
    // Spokes
    for (int i = 0; i < 5; i++) {
      final angle = i * 1.2566;
      final cos = _approxCos(angle);
      final sin = _approxCos(angle - 1.5708);
      canvas.drawLine(
        Offset(center.dx + cos * r * 0.28, center.dy + sin * r * 0.28),
        Offset(center.dx + cos * r * 0.62, center.dy + sin * r * 0.62),
        _stroke(const Color(0xFFBDBDBD), r * 0.08),
      );
    }
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

  // ── Car ────────────────────────────────────────────────────────────────────
  void _paintCar(Canvas canvas, Size sz) {
    final body = primaryColor;
    final dark = _darken(body, 0.15);
    final u = _u(1, sz);

    // Car body (lower)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(_sw(0.06, sz), _sh(0.52, sz), _sw(0.88, sz), _sh(0.28, sz)),
        Radius.circular(u * 0.06),
      ),
      _fill(body),
    );
    // Car roof (cabin)
    final roofPath = Path()
      ..moveTo(_s(0.22, 0.52, sz).dx, _s(0.0, 0.52, sz).dy)
      ..lineTo(_s(0.28, 0.28, sz).dx, _s(0.0, 0.28, sz).dy)
      ..lineTo(_s(0.72, 0.28, sz).dx, _s(0.0, 0.28, sz).dy)
      ..lineTo(_s(0.78, 0.52, sz).dx, _s(0.0, 0.52, sz).dy)
      ..close();
    canvas.drawPath(roofPath, _fill(dark));
    // Windows
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(_sw(0.30, sz), _sh(0.31, sz), _sw(0.17, sz), _sh(0.17, sz)),
        Radius.circular(u * 0.03),
      ),
      _fill(const Color(0xFFB3E5FC).withOpacity(0.8)),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(_sw(0.53, sz), _sh(0.31, sz), _sw(0.17, sz), _sh(0.17, sz)),
        Radius.circular(u * 0.03),
      ),
      _fill(const Color(0xFFB3E5FC).withOpacity(0.8)),
    );
    // Window shine
    canvas.drawLine(_s(0.32, 0.33, sz), _s(0.32, 0.45, sz),
        _stroke(Colors.white.withOpacity(0.5), u * 0.015));
    canvas.drawLine(_s(0.55, 0.33, sz), _s(0.55, 0.45, sz),
        _stroke(Colors.white.withOpacity(0.5), u * 0.015));
    // Door line
    canvas.drawLine(_s(0.50, 0.52, sz), _s(0.50, 0.78, sz),
        _stroke(dark, u * 0.014));
    // Door handles
    for (final dx in [0.35, 0.65]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: _s(dx, 0.65, sz), width: u * 0.07, height: u * 0.025),
          Radius.circular(u * 0.01),
        ),
        _fill(dark),
      );
    }
    // Headlights
    canvas.drawOval(
      Rect.fromCenter(center: _s(0.90, 0.60, sz), width: u * 0.07, height: u * 0.04),
      _fill(const Color(0xFFFFF9C4)),
    );
    canvas.drawOval(
      Rect.fromCenter(center: _s(0.10, 0.60, sz), width: u * 0.07, height: u * 0.04),
      _fill(const Color(0xFFFF8A80)),
    );
    // Wheels
    _wheel(canvas, _s(0.22, 0.82, sz), u * 0.11);
    _wheel(canvas, _s(0.78, 0.82, sz), u * 0.11);
    // Bumpers
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(_sw(0.03, sz), _sh(0.72, sz), _sw(0.10, sz), _sh(0.06, sz)),
        Radius.circular(u * 0.02),
      ),
      _fill(dark),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(_sw(0.87, sz), _sh(0.72, sz), _sw(0.10, sz), _sh(0.06, sz)),
        Radius.circular(u * 0.02),
      ),
      _fill(dark),
    );
  }

  // ── Bus ────────────────────────────────────────────────────────────────────
  void _paintBus(Canvas canvas, Size sz) {
    final body = primaryColor;
    final dark = _darken(body, 0.12);
    final u = _u(1, sz);

    // Main body
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(_sw(0.04, sz), _sh(0.20, sz), _sw(0.92, sz), _sh(0.58, sz)),
        Radius.circular(u * 0.06),
      ),
      _fill(body),
    );
    // Roof stripe
    canvas.drawRect(
      Rect.fromLTWH(_sw(0.04, sz), _sh(0.20, sz), _sw(0.92, sz), _sh(0.08, sz)),
      _fill(dark),
    );
    // Windows row
    for (int i = 0; i < 4; i++) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(_sw(0.10 + i * 0.20, sz), _sh(0.30, sz), _sw(0.14, sz), _sh(0.16, sz)),
          Radius.circular(u * 0.025),
        ),
        _fill(const Color(0xFFB3E5FC).withOpacity(0.85)),
      );
      canvas.drawLine(
        _s(0.12 + i * 0.20, 0.32, sz), _s(0.12 + i * 0.20, 0.44, sz),
        _stroke(Colors.white.withOpacity(0.4), u * 0.012),
      );
    }
    // Door
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(_sw(0.82, sz), _sh(0.34, sz), _sw(0.10, sz), _sh(0.28, sz)),
        Radius.circular(u * 0.02),
      ),
      _fill(const Color(0xFFB3E5FC).withOpacity(0.7)),
    );
    canvas.drawLine(_s(0.87, 0.34, sz), _s(0.87, 0.62, sz), _stroke(dark, u * 0.012));
    // Front/rear lights
    canvas.drawOval(
      Rect.fromCenter(center: _s(0.95, 0.44, sz), width: u * 0.06, height: u * 0.05),
      _fill(const Color(0xFFFFF9C4)),
    );
    canvas.drawOval(
      Rect.fromCenter(center: _s(0.05, 0.44, sz), width: u * 0.06, height: u * 0.05),
      _fill(const Color(0xFFFF8A80)),
    );
    // Stripe line along side
    canvas.drawLine(_s(0.04, 0.54, sz), _s(0.96, 0.54, sz), _stroke(dark, u * 0.018));
    // Wheels
    _wheel(canvas, _s(0.20, 0.84, sz), u * 0.10);
    _wheel(canvas, _s(0.50, 0.84, sz), u * 0.10);
    _wheel(canvas, _s(0.80, 0.84, sz), u * 0.10);
  }

  // ── Bike ───────────────────────────────────────────────────────────────────
  void _paintBike(Canvas canvas, Size sz) {
    final frame = primaryColor;
    final dark = _darken(frame, 0.15);
    final u = _u(1, sz);
    final metal = const Color(0xFF9E9E9E);

    // Wheels
    _wheel(canvas, _s(0.20, 0.70, sz), u * 0.22);
    _wheel(canvas, _s(0.80, 0.70, sz), u * 0.22);

    // Frame triangle
    final framePath = Path()
      ..moveTo(_s(0.50, 0.34, sz).dx, _s(0.0, 0.34, sz).dy) // seat
      ..lineTo(_s(0.80, 0.70, sz).dx, _s(0.0, 0.70, sz).dy) // rear axle
      ..lineTo(_s(0.50, 0.70, sz).dx, _s(0.0, 0.70, sz).dy) // bottom bracket
      ..lineTo(_s(0.50, 0.34, sz).dx, _s(0.0, 0.34, sz).dy) // back to seat
      ..moveTo(_s(0.50, 0.70, sz).dx, _s(0.0, 0.70, sz).dy) // bottom bracket
      ..lineTo(_s(0.20, 0.70, sz).dx, _s(0.0, 0.70, sz).dy) // front axle
      ..lineTo(_s(0.36, 0.36, sz).dx, _s(0.0, 0.36, sz).dy) // fork top
      ..lineTo(_s(0.50, 0.34, sz).dx, _s(0.0, 0.34, sz).dy); // seat tube
    canvas.drawPath(framePath, _stroke(frame, u * 0.038));

    // Fork
    canvas.drawLine(_s(0.36, 0.36, sz), _s(0.20, 0.70, sz), _stroke(dark, u * 0.030));
    // Handlebars
    canvas.drawLine(_s(0.36, 0.36, sz), _s(0.30, 0.26, sz), _stroke(metal, u * 0.030));
    canvas.drawLine(_s(0.26, 0.26, sz), _s(0.34, 0.26, sz), _stroke(metal, u * 0.030));
    // Seat
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: _s(0.52, 0.32, sz), width: u * 0.14, height: u * 0.04),
        Radius.circular(u * 0.02),
      ),
      _fill(dark),
    );
    // Seat post
    canvas.drawLine(_s(0.52, 0.34, sz), _s(0.52, 0.46, sz), _stroke(metal, u * 0.025));
    // Pedal crank
    canvas.drawCircle(_s(0.50, 0.70, sz), u * 0.04, _fill(metal));
    canvas.drawLine(_s(0.44, 0.70, sz), _s(0.56, 0.70, sz), _stroke(metal, u * 0.022));
    canvas.drawRect(
      Rect.fromCenter(center: _s(0.44, 0.70, sz), width: u * 0.04, height: u * 0.02),
      _fill(const Color(0xFF424242)),
    );
    canvas.drawRect(
      Rect.fromCenter(center: _s(0.56, 0.70, sz), width: u * 0.04, height: u * 0.02),
      _fill(const Color(0xFF424242)),
    );
  }

  // ── Plane ──────────────────────────────────────────────────────────────────
  void _paintPlane(Canvas canvas, Size sz) {
    final body = primaryColor;
    final dark = _darken(body, 0.12);
    final light = _lighten(body, 0.2);
    final u = _u(1, sz);

    // Main wing
    final wingPath = Path()
      ..moveTo(_s(0.30, 0.50, sz).dx, _s(0.0, 0.50, sz).dy)
      ..lineTo(_s(0.06, 0.72, sz).dx, _s(0.0, 0.72, sz).dy)
      ..lineTo(_s(0.20, 0.72, sz).dx, _s(0.0, 0.72, sz).dy)
      ..lineTo(_s(0.50, 0.54, sz).dx, _s(0.0, 0.54, sz).dy)
      ..close();
    canvas.drawPath(wingPath, _fill(dark));

    // Fuselage
    final fuselage = Path()
      ..moveTo(_s(0.92, 0.48, sz).dx, _s(0.0, 0.48, sz).dy)
      ..cubicTo(
        _s(1.0, 0.48, sz).dx, _s(0.0, 0.48, sz).dy,
        _s(1.0, 0.54, sz).dx, _s(0.0, 0.54, sz).dy,
        _s(0.92, 0.54, sz).dx, _s(0.0, 0.54, sz).dy,
      )
      ..lineTo(_s(0.08, 0.54, sz).dx, _s(0.0, 0.54, sz).dy)
      ..cubicTo(
        _s(0.02, 0.54, sz).dx, _s(0.0, 0.54, sz).dy,
        _s(0.02, 0.48, sz).dx, _s(0.0, 0.48, sz).dy,
        _s(0.08, 0.48, sz).dx, _s(0.0, 0.48, sz).dy,
      )
      ..close();
    canvas.drawPath(fuselage, _fill(body));

    // Tail fin (vertical)
    final tailV = Path()
      ..moveTo(_s(0.14, 0.48, sz).dx, _s(0.0, 0.48, sz).dy)
      ..lineTo(_s(0.10, 0.30, sz).dx, _s(0.0, 0.30, sz).dy)
      ..lineTo(_s(0.24, 0.48, sz).dx, _s(0.0, 0.48, sz).dy)
      ..close();
    canvas.drawPath(tailV, _fill(dark));

    // Tail fin (horizontal)
    final tailH = Path()
      ..moveTo(_s(0.16, 0.48, sz).dx, _s(0.0, 0.48, sz).dy)
      ..lineTo(_s(0.04, 0.60, sz).dx, _s(0.0, 0.60, sz).dy)
      ..lineTo(_s(0.12, 0.60, sz).dx, _s(0.0, 0.60, sz).dy)
      ..lineTo(_s(0.28, 0.54, sz).dx, _s(0.0, 0.54, sz).dy)
      ..close();
    canvas.drawPath(tailH, _fill(dark));

    // Cockpit windows
    for (int i = 0; i < 3; i++) {
      canvas.drawOval(
        Rect.fromCenter(
          center: _s(0.65 + i * 0.08, 0.50, sz),
          width: u * 0.055, height: u * 0.040,
        ),
        _fill(const Color(0xFFB3E5FC).withOpacity(0.85)),
      );
    }
    // Nose cockpit
    canvas.drawOval(
      Rect.fromCenter(center: _s(0.88, 0.50, sz), width: u * 0.065, height: u * 0.048),
      _fill(const Color(0xFFB3E5FC).withOpacity(0.9)),
    );
    // Engine
    canvas.drawOval(
      Rect.fromCenter(center: _s(0.38, 0.62, sz), width: u * 0.12, height: u * 0.07),
      _fill(dark),
    );
    canvas.drawOval(
      Rect.fromCenter(center: _s(0.34, 0.62, sz), width: u * 0.05, height: u * 0.06),
      _fill(const Color(0xFF424242)),
    );
    // Fuselage stripe
    canvas.drawLine(_s(0.20, 0.50, sz), _s(0.90, 0.50, sz),
        _stroke(light.withOpacity(0.5), u * 0.010));
  }

  // ── Boat ───────────────────────────────────────────────────────────────────
  void _paintBoat(Canvas canvas, Size sz) {
    final hull = primaryColor;
    final dark = _darken(hull, 0.15);
    final u = _u(1, sz);

    // Hull
    final hullPath = Path()
      ..moveTo(_s(0.06, 0.50, sz).dx, _s(0.0, 0.50, sz).dy)
      ..lineTo(_s(0.10, 0.72, sz).dx, _s(0.0, 0.72, sz).dy)
      ..cubicTo(
        _s(0.30, 0.80, sz).dx, _s(0.0, 0.80, sz).dy,
        _s(0.70, 0.80, sz).dx, _s(0.0, 0.80, sz).dy,
        _s(0.90, 0.72, sz).dx, _s(0.0, 0.72, sz).dy,
      )
      ..lineTo(_s(0.94, 0.50, sz).dx, _s(0.0, 0.50, sz).dy)
      ..close();
    canvas.drawPath(hullPath, _fill(hull));
    // Hull bottom stripe
    canvas.drawPath(hullPath, _stroke(dark, u * 0.020));
    // Waterline
    canvas.drawLine(_s(0.06, 0.50, sz), _s(0.94, 0.50, sz),
        _stroke(const Color(0xFF0288D1), u * 0.015));

    // Deck
    canvas.drawRect(
      Rect.fromLTWH(_sw(0.12, sz), _sh(0.36, sz), _sw(0.76, sz), _sh(0.14, sz)),
      _fill(_lighten(hull, 0.18)),
    );

    // Cabin
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(_sw(0.30, sz), _sh(0.16, sz), _sw(0.40, sz), _sh(0.22, sz)),
        Radius.circular(u * 0.04),
      ),
      _fill(Colors.white),
    );
    // Cabin windows
    for (final cx in [0.38, 0.50, 0.62]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: _s(cx, 0.25, sz), width: u * 0.08, height: u * 0.07),
          Radius.circular(u * 0.02),
        ),
        _fill(const Color(0xFFB3E5FC).withOpacity(0.85)),
      );
    }
    // Mast
    canvas.drawLine(_s(0.50, 0.36, sz), _s(0.50, 0.06, sz), _stroke(dark, u * 0.020));
    // Flag
    final flagPath = Path()
      ..moveTo(_s(0.50, 0.06, sz).dx, _s(0.0, 0.06, sz).dy)
      ..lineTo(_s(0.70, 0.10, sz).dx, _s(0.0, 0.10, sz).dy)
      ..lineTo(_s(0.50, 0.14, sz).dx, _s(0.0, 0.14, sz).dy)
      ..close();
    canvas.drawPath(flagPath, _fill(const Color(0xFFFF5252)));
    // Porthole
    canvas.drawCircle(_s(0.22, 0.44, sz), u * 0.04, _fill(dark));
    canvas.drawCircle(_s(0.22, 0.44, sz), u * 0.025, _fill(const Color(0xFFB3E5FC)));
  }

  // ── Rocket ─────────────────────────────────────────────────────────────────
  void _paintRocket(Canvas canvas, Size sz) {
    final body = primaryColor;
    final dark = _darken(body, 0.15);
    final light = _lighten(body, 0.2);
    final u = _u(1, sz);

    // Flame
    final flamePath = Path()
      ..moveTo(_s(0.38, 0.86, sz).dx, _s(0.0, 0.86, sz).dy)
      ..cubicTo(
        _s(0.36, 0.96, sz).dx, _s(0.0, 0.96, sz).dy,
        _s(0.44, 0.98, sz).dx, _s(0.0, 0.98, sz).dy,
        _s(0.50, 0.92, sz).dx, _s(0.0, 0.92, sz).dy,
      )
      ..cubicTo(
        _s(0.56, 0.98, sz).dx, _s(0.0, 0.98, sz).dy,
        _s(0.64, 0.96, sz).dx, _s(0.0, 0.96, sz).dy,
        _s(0.62, 0.86, sz).dx, _s(0.0, 0.86, sz).dy,
      )
      ..close();
    canvas.drawPath(flamePath, _fill(const Color(0xFFFF9800)));
    final innerFlame = Path()
      ..moveTo(_s(0.42, 0.86, sz).dx, _s(0.0, 0.86, sz).dy)
      ..cubicTo(
        _s(0.42, 0.92, sz).dx, _s(0.0, 0.92, sz).dy,
        _s(0.50, 0.95, sz).dx, _s(0.0, 0.95, sz).dy,
        _s(0.58, 0.86, sz).dx, _s(0.0, 0.86, sz).dy,
      )
      ..close();
    canvas.drawPath(innerFlame, _fill(const Color(0xFFFFEB3B)));

    // Fins
    for (final (fx, flip) in [(0.50, -1.0), (0.50, 1.0)]) {
      final fin = Path()
        ..moveTo(_s(0.50 + flip * 0.12, 0.70, sz).dx, _s(0.0, 0.70, sz).dy)
        ..lineTo(_s(0.50 + flip * 0.32, 0.86, sz).dx, _s(0.0, 0.86, sz).dy)
        ..lineTo(_s(0.50 + flip * 0.12, 0.86, sz).dx, _s(0.0, 0.86, sz).dy)
        ..close();
      canvas.drawPath(fin, _fill(dark));
    }

    // Body
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(_sw(0.34, sz), _sh(0.16, sz), _sw(0.32, sz), _sh(0.72, sz)),
        Radius.circular(u * 0.08),
      ),
      _fill(body),
    );

    // Nose cone
    final nosePath = Path()
      ..moveTo(_s(0.34, 0.16, sz).dx, _s(0.0, 0.16, sz).dy)
      ..cubicTo(
        _s(0.34, 0.06, sz).dx, _s(0.0, 0.06, sz).dy,
        _s(0.66, 0.06, sz).dx, _s(0.0, 0.06, sz).dy,
        _s(0.66, 0.16, sz).dx, _s(0.0, 0.16, sz).dy,
      )
      ..close();
    canvas.drawPath(nosePath, _fill(dark));

    // Window
    canvas.drawCircle(_s(0.50, 0.38, sz), u * 0.10, _fill(dark));
    canvas.drawCircle(_s(0.50, 0.38, sz), u * 0.075, _fill(const Color(0xFFB3E5FC)));
    canvas.drawCircle(_s(0.46, 0.35, sz), u * 0.025,
        _fill(Colors.white.withOpacity(0.7)));

    // Body stripes
    canvas.drawLine(_s(0.34, 0.54, sz), _s(0.66, 0.54, sz), _stroke(dark, u * 0.016));
    canvas.drawLine(_s(0.34, 0.64, sz), _s(0.66, 0.64, sz), _stroke(dark, u * 0.012));

    // Body highlight
    canvas.drawLine(_s(0.40, 0.18, sz), _s(0.40, 0.82, sz),
        _stroke(light.withOpacity(0.4), u * 0.022));
  }
}
