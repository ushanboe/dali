import 'package:flutter/material.dart';

enum HairStyle {
  shortStraight,
  shortCurly,
  mediumStraight,
  mediumWavy,
  longStraight,
  longCurly,
  bob,
  ponytail,
  bun,
  braids,
  afro,
  pixie,
}

class HairConfig {
  final HairStyle style;
  final Color color;
  final Color highlightColor;

  const HairConfig({
    this.style = HairStyle.mediumStraight,
    this.color = const Color(0xFF3B1F0A),
    this.highlightColor = const Color(0xFF6B3A1F),
  });

  HairConfig copyWith({HairStyle? style, Color? color, Color? highlightColor}) {
    return HairConfig(
      style: style ?? this.style,
      color: color ?? this.color,
      highlightColor: highlightColor ?? this.highlightColor,
    );
  }
}
