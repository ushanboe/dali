import 'package:flutter/material.dart';

/// 20 hair colors — natural tones and fantasy colors.
class HairColors {
  HairColors._();

  // Natural
  static const Color jetBlack     = Color(0xFF0A0A0A);
  static const Color darkBrown    = Color(0xFF3B1F0A);
  static const Color mediumBrown  = Color(0xFF6B3A1F);
  static const Color lightBrown   = Color(0xFF9B6B3A);
  static const Color darkBlonde   = Color(0xFFB8860B);
  static const Color blonde       = Color(0xFFD4A017);
  static const Color lightBlonde  = Color(0xFFF5D78E);
  static const Color strawberry   = Color(0xFFD4735E);
  static const Color auburn       = Color(0xFF8B3A2A);
  static const Color ginger       = Color(0xFFCC5500);
  static const Color grey         = Color(0xFF9E9E9E);
  static const Color white        = Color(0xFFF5F5F5);

  // Fantasy
  static const Color raven        = Color(0xFF1A1A2E);
  static const Color burgundy     = Color(0xFF6D1F2B);
  static const Color roseGold     = Color(0xFFB76E79);
  static const Color lavender     = Color(0xFF9B8EC4);
  static const Color teal         = Color(0xFF2E8B8B);
  static const Color cobalt       = Color(0xFF1A3A6B);
  static const Color emerald      = Color(0xFF2E6B3A);
  static const Color coral        = Color(0xFFE8614A);

  static const List<Color> natural = [
    jetBlack, darkBrown, mediumBrown, lightBrown, darkBlonde, blonde,
    lightBlonde, strawberry, auburn, ginger, grey, white,
  ];

  static const List<Color> fantasy = [
    raven, burgundy, roseGold, lavender, teal, cobalt, emerald, coral,
  ];

  static const List<Color> all = [...natural, ...fantasy];
}
