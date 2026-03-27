import 'package:flutter/material.dart';
import '../models/effects_config.dart';
import '../painters/particle_painter.dart';

/// Animated particle overlay widget. Renders looping particles over its area.
///
/// Use in a [Stack] over any content:
/// ```dart
/// Stack(
///   children: [
///     DaliScene(config: sceneConfig),
///     DaliAvatar(config: avatarConfig, size: 200),
///     const DaliEffects(type: ParticleType.confetti),
///   ],
/// )
/// ```
///
/// Or standalone as a full-screen effect:
/// ```dart
/// DaliEffects(type: ParticleType.hearts, color: Colors.pink, size: 300)
/// ```
class DaliEffects extends StatefulWidget {
  final ParticleType type;
  final Color? color;
  final double? width;
  final double? height;

  /// Animation speed multiplier. 1.0 = normal, 2.0 = double speed.
  final double speed;

  /// Whether the animation loops continuously.
  final bool loop;

  const DaliEffects({
    super.key,
    required this.type,
    this.color,
    this.width,
    this.height,
    this.speed = 1.0,
    this.loop = true,
  });

  @override
  State<DaliEffects> createState() => _DaliEffectsState();
}

class _DaliEffectsState extends State<DaliEffects>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (4000 / widget.speed).round()),
    );
    if (widget.loop) {
      _controller.repeat();
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) => CustomPaint(
          painter: ParticlePainter(
            type: widget.type,
            time: _controller.value,
            color: widget.color,
          ),
          size: Size(
            widget.width ?? double.infinity,
            widget.height ?? double.infinity,
          ),
        ),
      ),
    );
  }
}
