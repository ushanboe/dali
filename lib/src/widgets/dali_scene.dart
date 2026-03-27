import 'package:flutter/material.dart';
import '../models/scene_config.dart';
import '../painters/scene_painter.dart';

/// A full scene background widget — drop in behind a DaliAvatar.
///
/// ```dart
/// Stack(
///   children: [
///     DaliScene(config: SceneConfig(type: SceneType.beach, timeOfDay: DayTime.day)),
///     Positioned(bottom: 0, child: DaliAvatar(config: avatarConfig, size: 200)),
///   ],
/// )
/// ```
class DaliScene extends StatelessWidget {
  final SceneConfig config;
  final double? width;
  final double? height;

  const DaliScene({
    super.key,
    required this.config,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: ScenePainter(config),
        size: Size(width ?? double.infinity, height ?? double.infinity),
      ),
    );
  }
}
