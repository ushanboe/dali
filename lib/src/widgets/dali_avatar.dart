import 'package:flutter/material.dart';
import '../models/avatar_config.dart';
import '../painters/body_painter.dart';
import '../painters/clothing_painter.dart';
import '../painters/hair_painter.dart';
import '../painters/face_painter.dart';

/// A fully composed avatar widget built from layered CustomPainters.
///
/// Drop-in replacement for Image.asset — no image files needed.
///
/// ```dart
/// DaliAvatar(
///   config: AvatarConfig(
///     skinTone: SkinTones.honey,
///     hair: HairConfig(style: HairStyle.longCurly, color: HairColors.auburn),
///     face: FaceConfig(expression: FaceExpression.happy, blush: true),
///     clothing: ClothingConfig(item: ClothingItem.dress, primaryColor: Colors.pink),
///   ),
///   size: 200,
/// )
/// ```
class DaliAvatar extends StatelessWidget {
  final AvatarConfig config;
  final double size;

  const DaliAvatar({
    super.key,
    required this.config,
    this.size = 200,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _AvatarComposedPainter(config),
      ),
    );
  }
}

/// Composes all layer painters into a single CustomPainter for efficiency.
class _AvatarComposedPainter extends CustomPainter {
  final AvatarConfig config;

  _AvatarComposedPainter(this.config);

  @override
  void paint(Canvas canvas, Size size) {
    // Back hair layer (styles that go behind the head)
    final backHairStyles = {
      HairStyle.longStraight,
      HairStyle.longCurly,
      HairStyle.mediumStraight,
      HairStyle.mediumWavy,
      HairStyle.braids,
      HairStyle.ponytail,
    };

    if (backHairStyles.contains(config.hair.style)) {
      HairPainter(config).paint(canvas, size);
    }

    // Body + clothing
    BodyPainter(config).paint(canvas, size);
    ClothingPainter(config).paint(canvas, size);

    // Front hair (short styles that sit on top of head)
    if (!backHairStyles.contains(config.hair.style)) {
      HairPainter(config).paint(canvas, size);
    }

    // Face always on top
    FacePainter(config).paint(canvas, size);
  }

  @override
  bool shouldRepaint(_AvatarComposedPainter oldDelegate) =>
      oldDelegate.config != config;
}
