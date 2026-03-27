import 'package:flutter/material.dart';

enum FaceExpression {
  neutral,
  happy,
  excited,
  sad,
  surprised,
  thinking,
}

enum EyeShape {
  round,
  almond,
  wide,
  narrow,
  bright,
  sleepy,
}

class FaceConfig {
  final FaceExpression expression;
  final EyeShape eyeShape;
  final Color eyeColor;
  final bool blush;

  const FaceConfig({
    this.expression = FaceExpression.happy,
    this.eyeShape = EyeShape.round,
    this.eyeColor = const Color(0xFF3B2A1A),
    this.blush = false,
  });

  FaceConfig copyWith({
    FaceExpression? expression,
    EyeShape? eyeShape,
    Color? eyeColor,
    bool? blush,
  }) {
    return FaceConfig(
      expression: expression ?? this.expression,
      eyeShape: eyeShape ?? this.eyeShape,
      eyeColor: eyeColor ?? this.eyeColor,
      blush: blush ?? this.blush,
    );
  }
}
