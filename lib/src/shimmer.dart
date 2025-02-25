import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'shimmer_direction.dart';
import 'shimmer_effect.dart';

class Shimmer extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double speedFactor;
  final Color baseColor;
  final Color highlightColor;
  final List<Color>? gradientColors;
  final ShimmerDirection direction;
  final ShimmerEffect effect;
  final Duration? disableAfter;
  final double? shimmerAngle;

  const Shimmer({
    Key? key,
    required this.child,
    this.duration = const Duration(seconds: 2),
    this.speedFactor = 1.0,
    this.baseColor = const Color(0xFFE0E0E0),
    this.highlightColor = const Color(0xFFF5F5F5),
    this.gradientColors,
    this.direction = ShimmerDirection.leftToRight,
    this.effect = ShimmerEffect.classic,
    this.disableAfter,
    this.shimmerAngle,
  }) : super(key: key);

  @override
  _ShimmerState createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isShimmering = true;

  @override
  void initState() {
    super.initState();

    final adjustedDuration = Duration(milliseconds: (widget.duration.inMilliseconds ~/ widget.speedFactor));

    _controller = AnimationController(vsync: this, duration: adjustedDuration)..repeat();

    if (widget.disableAfter != null) {
      Future.delayed(widget.disableAfter!, () {
        if (mounted) {
          setState(() {
            _isShimmering = false;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isShimmering) return widget.child;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            final colors = _getShimmerColors();
            final stops = _getGradientStops();

            final gradient = LinearGradient(
              colors: colors,
              stops: stops,
              begin: _getBeginAlignment(),
              end: _getEndAlignment(),
            );
            return gradient.createShader(bounds);
          },
          blendMode: BlendMode.srcIn,
          child: widget.child,
        );
      },
    );
  }

  /// Get gradient colors based on shimmer effect
  List<Color> _getShimmerColors() {
    switch (widget.effect) {
      case ShimmerEffect.wave:
        return [
          widget.baseColor,
          widget.highlightColor,
          widget.baseColor.withOpacity(0.8),
          widget.highlightColor,
          widget.baseColor,
        ];
      case ShimmerEffect.pulse:
        final pulseOpacity = sin(_controller.value * pi).abs();
        return [
          widget.baseColor.withOpacity(pulseOpacity * 0.5),
          widget.highlightColor.withOpacity(pulseOpacity),
          widget.baseColor.withOpacity(pulseOpacity * 0.5),
        ];
      case ShimmerEffect.classic:
      default:
        return [widget.baseColor, widget.highlightColor, widget.baseColor];
    }
  }

  /// Get gradient stops based on shimmer effect
  List<double> _getGradientStops() {
    switch (widget.effect) {
      case ShimmerEffect.wave:
        return [
          (_controller.value - 0.6).clamp(0.0, 1.0),
          (_controller.value - 0.3).clamp(0.0, 1.0),
          _controller.value,
          (_controller.value + 0.3).clamp(0.0, 1.0),
          (_controller.value + 0.6).clamp(0.0, 1.0),
        ];
      case ShimmerEffect.pulse:
        return [0.2, 0.5, 0.8];
      case ShimmerEffect.classic:
      default:
        return [
          (_controller.value - 0.5).clamp(0.0, 1.0),
          _controller.value,
          (_controller.value + 0.5).clamp(0.0, 1.0),
        ];
    }
  }

  /// Get start alignment based on direction or angle
  Alignment _getBeginAlignment() {
    if (widget.shimmerAngle != null) {
      return _calculateAlignment(widget.shimmerAngle!, isStart: true);
    }
    switch (widget.direction) {
      case ShimmerDirection.topToBottom:
        return Alignment.topCenter;
      case ShimmerDirection.diagonal:
        return Alignment.topLeft;
      case ShimmerDirection.leftToRight:
      default:
        return Alignment.centerLeft;
    }
  }

  /// Get end alignment based on direction or angle
  Alignment _getEndAlignment() {
    if (widget.shimmerAngle != null) {
      return _calculateAlignment(widget.shimmerAngle!, isStart: false);
    }
    switch (widget.direction) {
      case ShimmerDirection.topToBottom:
        return Alignment.bottomCenter;
      case ShimmerDirection.diagonal:
        return Alignment.bottomRight;
      case ShimmerDirection.leftToRight:
      default:
        return Alignment.centerRight;
    }
  }

  /// Convert angle to gradient alignment
  /// Convert angle to extended gradient alignment
  Alignment _calculateAlignment(double angle, {required bool isStart}) {
    final radians = angle * (pi / 180.0);
    final x = cos(radians);
    final y = sin(radians);

    // Extend alignment beyond [-1,1] range for a seamless effect
    final scale = 2.0;

    return isStart ? Alignment(-x * scale, -y * scale) : Alignment(x * scale, y * scale);
  }
}
