import 'package:flutter/material.dart';
import 'hair_config.dart';
import 'face_config.dart';
import 'clothing_config.dart';

export 'hair_config.dart';
export 'face_config.dart';
export 'clothing_config.dart';

class AvatarConfig {
  final Color skinTone;
  final HairConfig hair;
  final FaceConfig face;
  final ClothingConfig clothing;

  const AvatarConfig({
    this.skinTone = const Color(0xFFF5C5A3),
    this.hair = const HairConfig(),
    this.face = const FaceConfig(),
    this.clothing = const ClothingConfig(),
  });

  AvatarConfig copyWith({
    Color? skinTone,
    HairConfig? hair,
    FaceConfig? face,
    ClothingConfig? clothing,
  }) {
    return AvatarConfig(
      skinTone: skinTone ?? this.skinTone,
      hair: hair ?? this.hair,
      face: face ?? this.face,
      clothing: clothing ?? this.clothing,
    );
  }
}
