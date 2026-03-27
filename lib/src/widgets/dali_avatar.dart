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
    // Pass 1 — hair sides/back (y > 15% of height).
    // Draws the portions that fall beside and below the head.
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, size.height * 0.15, size.width, size.height));
    HairPainter(config).paint(canvas, size);
    canvas.restore();

    // Body + head skin drawn over the hair centre — clears the face area.
    BodyPainter(config).paint(canvas, size);
    ClothingPainter(config).paint(canvas, size);

    // Pass 2 — hair crown cap (y < 28% of height).
    // Draws the top of the hair sitting on the head, above the brow line.
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height * 0.28));
    HairPainter(config).paint(canvas, size);
    canvas.restore();

    // Face always last — on top of everything.
    FacePainter(config).paint(canvas, size);
  }

  @override
  bool shouldRepaint(_AvatarComposedPainter oldDelegate) =>
      oldDelegate.config != config;
}
