import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'shimmer_direction.dart';
import 'shimmer_effect.dart';

/// A widget that applies a shimmering effect to its child.
/// Useful for loading placeholders.
class Shimmer extends StatefulWidget {
  /// The widget to which the shimmer effect will be applied.
  final Widget child;

  /// The duration of the shimmer animation.
  final Duration duration;

  /// The speed factor to control the shimmer animation speed.
  final double speedFactor;

  /// The base color of the shimmer effect.
  final Color baseColor;

  /// The highlight color of the shimmer effect.
  final Color highlightColor;

  /// Optional custom gradient colors for the shimmer effect.
  final List<Color>? gradientColors;

  /// The direction in which the shimmer effect moves.
  final ShimmerDirection direction;

  /// The shimmer effect style (classic, wave, pulse, etc.).
  final ShimmerEffect effect;

  /// Optional duration after which the shimmer effect is disabled.
  final Duration? disableAfter;

  /// Optional angle (in degrees) for diagonal shimmering.
  final double? shimmerAngle;

  /// The size factor to scale the shimmer effect.
  final double shimmerSizeFactor;

  const Shimmer({
    super.key,
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
    this.shimmerSizeFactor = 1.0,  // Default to normal size
  });

  @override
  _ShimmerState createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _isShimmering = true;

  @override
  void initState() {
    super.initState();
    _initializeController();
    _handleDisableAfter();
  }

  /// Initializes the animation controller for the shimmer effect.
  void _initializeController() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (widget.duration.inMilliseconds ~/ widget.speedFactor)),
    )..repeat();
  }

  /// Handles disabling the shimmer effect after a specified duration.
  void _handleDisableAfter() {
    if (widget.disableAfter != null) {
      Future.delayed(widget.disableAfter!, () {
        if (mounted) {
          setState(() => _isShimmering = false);
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
    return _isShimmering ? _buildShimmerEffect() : widget.child;
  }

  /// Builds the shimmer effect using a ShaderMask.
  Widget _buildShimmerEffect() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) => _createShader(bounds),
          blendMode: BlendMode.srcIn,
          child: widget.child,
        );
      },
    );
  }

  /// Creates the shader used for the shimmer effect.
  Shader _createShader(Rect bounds) {
    double scale = widget.shimmerSizeFactor.clamp(0.5, 2.0); // Prevents extreme values
    return LinearGradient(
      colors: _getShimmerColors(),
      stops: _getGradientStops(scale), // Apply scaling
      begin: _getBeginAlignment(),
      end: _getEndAlignment(),
      tileMode: TileMode.mirror,
    ).createShader(bounds);
  }

  /// Returns the color stops for the shimmer effect based on the selected style.
  List<Color> _getShimmerColors() {
    switch (widget.effect) {
      case ShimmerEffect.wave:
        return [
          widget.baseColor,
          widget.highlightColor,
          widget.baseColor.withValues(alpha: 0.8),
          widget.highlightColor,
          widget.baseColor,
        ];
      case ShimmerEffect.pulse:
        final opacity = sin(_controller.value * pi).abs();
        return [
          widget.baseColor.withValues(alpha: opacity * 0.5),
          widget.highlightColor.withValues(alpha: opacity),
          widget.baseColor.withValues(alpha: opacity * 0.5),
        ];
      case ShimmerEffect.classic:
      default:
        return [widget.baseColor, widget.highlightColor, widget.baseColor];
    }
  }

  /// Returns the gradient stops for the shimmer effect.
  List<double> _getGradientStops(double scale) {
    switch (widget.effect) {
      case ShimmerEffect.wave:
        return [
          (_controller.value - 0.6 * scale).clamp(0.0, 1.0),
          (_controller.value - 0.3 * scale).clamp(0.0, 1.0),
          _controller.value,
          (_controller.value + 0.3 * scale).clamp(0.0, 1.0),
          (_controller.value + 0.6 * scale).clamp(0.0, 1.0),
        ];
      case ShimmerEffect.pulse:
        return [0.2, 0.5, 0.8];
      case ShimmerEffect.classic:
      default:
        return [
          (_controller.value - 0.5 * scale).clamp(0.0, 1.0),
          _controller.value,
          (_controller.value + 0.5 * scale).clamp(0.0, 1.0),
        ];
    }
  }

  /// Returns the starting alignment of the shimmer effect.
  Alignment _getBeginAlignment() {
    return widget.shimmerAngle != null
        ? _calculateAlignment(widget.shimmerAngle!, isStart: true)
        : _getDefaultAlignment(isStart: true);
  }

  /// Returns the ending alignment of the shimmer effect.
  Alignment _getEndAlignment() {
    return widget.shimmerAngle != null
        ? _calculateAlignment(widget.shimmerAngle!, isStart: false)
        : _getDefaultAlignment(isStart: false);
  }

  /// Returns the default alignment based on the shimmer direction.
  Alignment _getDefaultAlignment({required bool isStart}) {
    switch (widget.direction) {
      case ShimmerDirection.topToBottom:
        return isStart ? Alignment.topCenter : Alignment.bottomCenter;
      case ShimmerDirection.diagonal:
        return isStart ? Alignment.topLeft : Alignment.bottomRight;
      case ShimmerDirection.leftToRight:
      return isStart ? Alignment.centerLeft : Alignment.centerRight;
    }
  }

  /// Calculates the alignment based on the provided shimmer angle.
  Alignment _calculateAlignment(double angle, {required bool isStart}) {
    final radians = angle * (pi / 180.0);
    final x = cos(radians);
    final y = sin(radians);
    const scale = 2.0;
    return isStart ? Alignment(-x * scale, -y * scale) : Alignment(x * scale, y * scale);
  }
}
