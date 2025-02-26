import 'package:flutter/material.dart';
import 'shimmer.dart';
import 'shimmer_theme.dart';
import 'shimmer_direction.dart';
import 'shimmer_effect.dart';

/// Extension on [Text] widget to add shimmer effect.
extension ShimmerText on Text {
  /// Applies a shimmer effect to the text.
  ///
  /// If [shimmer] is false, it returns the original text.
  Widget shimmer({
    bool shimmer = true,
    double? width, // Custom width
    double? height, // Custom height
    double? shimmerAngle,
    Duration? duration,
    double? speedFactor,
    Color? baseColor,
    Color? highlightColor,
    List<Color>? gradientColors,
    ShimmerDirection? direction,
    ShimmerEffect? effect,
    Duration? disableAfter,
    double borderRadius = 8.0, // NEW: Rounded corner support
  }) {
    if (!shimmer) return this; // Return original text if shimmer is disabled

    final theme = ShimmerTheme();

    return Shimmer(
      shimmerAngle: shimmerAngle ?? theme.shimmerAngle,
      duration: duration ?? theme.duration,
      speedFactor: speedFactor ?? theme.speedFactor,
      baseColor: baseColor ?? theme.baseColor,
      highlightColor: highlightColor ?? theme.highlightColor,
      gradientColors: gradientColors,
      direction: direction ?? theme.direction,
      effect: effect ?? theme.effect,
      disableAfter: disableAfter ?? theme.disableAfter,
      child: SizedBox(
        width: width,
        height: height,
        child: Container(
          decoration: BoxDecoration(
            color: theme.baseColor, // Hide text with theme's base color
            borderRadius: BorderRadius.circular(borderRadius), // Apply rounded corners
          ),
          child: Opacity(
            opacity: 0.0, // Hide the text
            child: Text(
              this.data ?? "",
              style: this.style,
            ),
          ),
        ),
      ),
    );
  }
}

/// Extension on any [Widget] to apply a shimmer effect.
extension ShimmerExtension on Widget {
  /// Wraps the widget with a shimmer effect.
  ///
  /// If [shimmer] is false, it returns the original widget.
  Widget shimmer({
    bool shimmer = true,
    double? shimmerAngle, // Custom shimmer angle
    double? width, // Custom width
    double? height, // Custom height
    Duration? duration,
    double? speedFactor,
    Color? baseColor,
    Color? highlightColor,
    List<Color>? gradientColors,
    ShimmerDirection? direction,
    ShimmerEffect? effect,
    Duration? disableAfter,
  }) {
    if (!shimmer) return this; // Return original widget if shimmer is disabled

    final theme = ShimmerTheme();

    return Shimmer(
      shimmerAngle: shimmerAngle ?? theme.shimmerAngle,
      duration: duration ?? theme.duration,
      speedFactor: speedFactor ?? theme.speedFactor,
      baseColor: baseColor ?? theme.baseColor,
      highlightColor: highlightColor ?? theme.highlightColor,
      gradientColors: gradientColors,
      direction: direction ?? theme.direction,
      effect: effect ?? theme.effect,
      disableAfter: disableAfter ?? theme.disableAfter,
      child: SizedBox(
        width: width, // Apply custom width if provided
        height: height, // Apply custom height if provided
        child: this,
      ),
    );
  }
}
