import 'package:flutter/material.dart';
import '../models/effects_config.dart';
import '../painters/badge_painter.dart';

/// An achievement badge that animates in with a scale + bounce reveal.
///
/// ```dart
/// DaliBadge(
///   type: BadgeType.star,
///   size: 120,
///   color: Color(0xFFFFD600),
///   label: 'Winner!',
/// )
/// ```
///
/// Set [animate] to false for a static badge (no reveal animation).
class DaliBadge extends StatefulWidget {
  final BadgeType type;
  final double size;
  final Color color;
  final Color? secondaryColor;
  final String? label;

  /// Play the bounce-in animation on first display.
  final bool animate;

  const DaliBadge({
    super.key,
    required this.type,
    this.size = 120,
    this.color = const Color(0xFFFFD600),
    this.secondaryColor,
    this.label,
    this.animate = true,
  });

  @override
  State<DaliBadge> createState() => _DaliBadgeState();
}

class _DaliBadgeState extends State<DaliBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scale = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.20), weight: 55),
      TweenSequenceItem(tween: Tween(begin: 1.20, end: 0.90), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 0.90, end: 1.05), weight: 15),
      TweenSequenceItem(tween: Tween(begin: 1.05, end: 1.00), weight: 10),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _opacity = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    if (widget.animate) {
      _controller.forward();
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) => Opacity(
        opacity: _opacity.value,
        child: Transform.scale(
          scale: _scale.value,
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: CustomPaint(
              painter: BadgePainter(
                type: widget.type,
                primaryColor: widget.color,
                secondaryColor: widget.secondaryColor,
                label: widget.label,
              ),
              size: Size(widget.size, widget.size),
            ),
          ),
        ),
      ),
    );
  }
}
