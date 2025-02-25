import 'package:flutter/material.dart';
import 'shimmer_direction.dart';
import 'shimmer_effect.dart';

class ShimmerTheme {
  static final ShimmerTheme _instance = ShimmerTheme._internal();

  factory ShimmerTheme() => _instance;

  ShimmerTheme._internal();

  /// Default shimmer properties
  Duration _duration = const Duration(seconds: 2);
  double _angle = 30.0;
  double _width = 1.0;
  double _height = 1.0;
  double _speedFactor = 1.0;
  Color _baseColor = const Color(0xFFE0E0E0);
  Color _highlightColor = const Color(0xFFF5F5F5);
  ShimmerDirection _direction = ShimmerDirection.leftToRight;
  ShimmerEffect _effect = ShimmerEffect.classic;
  Duration? _disableAfter;

  /// Getters for properties (Ensures encapsulation)
  Duration get duration => _duration;
  double get shimmerAngle => _angle;
  double get width => _width;
  double get height => _height;
  double get speedFactor => _speedFactor;
  Color get baseColor => _baseColor;
  Color get highlightColor => _highlightColor;
  ShimmerDirection get direction => _direction;
  ShimmerEffect get effect => _effect;
  Duration? get disableAfter => _disableAfter;

  /// Allows users to update shimmer theme globally with a fluent API
  ShimmerTheme update({
    Duration? duration,
    double? angle,
    double? speedFactor,
    double? width,
    double? height,
    Color? baseColor,
    Color? highlightColor,
    ShimmerDirection? direction,
    ShimmerEffect? effect,
    Duration? disableAfter,
  }) {
    _duration = duration ?? _duration;
    _angle = angle ?? _angle;
    _width = width ?? _width;
    _height = height ?? _height;
    _speedFactor = speedFactor ?? _speedFactor;
    _baseColor = baseColor ?? _baseColor;
    _highlightColor = highlightColor ?? _highlightColor;
    _direction = direction ?? _direction;
    _effect = effect ?? _effect;
    _disableAfter = disableAfter ?? _disableAfter;

    return this; // ✅ Fluent API (allows chaining)
  }
}
