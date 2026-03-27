import 'package:flutter/material.dart';

/// 12 inclusive skin tones from lightest to darkest.
class SkinTones {
  SkinTones._();

  static const Color porcelain    = Color(0xFFFFF0E0);
  static const Color ivory        = Color(0xFFF5DEB3);
  static const Color cream        = Color(0xFFF5C5A3);
  static const Color peach        = Color(0xFFE8A882);
  static const Color sand         = Color(0xFFD4956A);
  static const Color warm         = Color(0xFFC68642);
  static const Color honey        = Color(0xFFB5713C);
  static const Color caramel      = Color(0xFF9B5A2C);
  static const Color amber        = Color(0xFF7C4A1E);
  static const Color sienna       = Color(0xFF6B3A1F);
  static const Color mahogany     = Color(0xFF4A2512);
  static const Color ebony        = Color(0xFF2C1810);

  static const List<Color> all = [
    porcelain, ivory, cream, peach, sand, warm,
    honey, caramel, amber, sienna, mahogany, ebony,
  ];
}
