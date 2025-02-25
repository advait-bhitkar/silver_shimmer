import 'package:flutter/material.dart';
import 'shimmer.dart';
import 'shimmer_theme.dart';
import 'shimmer_direction.dart';
import 'shimmer_effect.dart';

extension ShimmerText on Text {
  Widget shimmer({
    bool shimmer = true,
    double? width, // ✅ Custom width
    double? height, // ✅ Custom height
    double? shimmerAngle,
    Duration? duration,
    double? speedFactor,
    Color? baseColor,
    Color? highlightColor,
    List<Color>? gradientColors,
    ShimmerDirection? direction,
    ShimmerEffect? effect,
    Duration? disableAfter,
  }) {
    if (!shimmer) return this; // Show actual text when shimmer is false

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
        width: width, // Estimate width if not provided
        height: height, // Use font size as height
        child: Container(
          color: theme.baseColor, // ✅ Hide text with theme's base color
          child: Opacity(
            opacity: 0.0, // ✅ Completely hide the text
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

extension ShimmerExtension on Widget {
  Widget shimmer({
    bool shimmer = true,
    double? shimmerAngle, // ✅ Custom width
    double? width, // ✅ Custom width
    double? height, // ✅ Custom height
    Duration? duration,
    double? speedFactor,
    Color? baseColor,
    Color? highlightColor,
    List<Color>? gradientColors,
    ShimmerDirection? direction,
    ShimmerEffect? effect,
    Duration? disableAfter,
  }) {
    if (!shimmer) return this;

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
        width: width, // ✅ Apply custom width
        height: height, // ✅ Apply custom height
        child: this,
      )// ,
    );
  }
}
