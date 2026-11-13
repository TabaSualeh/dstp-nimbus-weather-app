import 'package:flutter/material.dart';

/// Small MediaQuery-based helper used by the screens.
///
/// - [sp] scales a value designed for a 390px-wide phone to the current width
///   (clamped, so tiny phones don't get cramped and tablets don't get huge).
/// - [contentWidth] caps the layout width on tablets / landscape / web.
class Responsive {
  const Responsive._(this.size);

  factory Responsive.of(BuildContext context) => Responsive._(MediaQuery.sizeOf(context));

  static const double designWidth = 390;
  static const double maxContentWidth = 520;

  final Size size;

  double get width => size.width;
  double get height => size.height;

  double get contentWidth => width < maxContentWidth ? width : maxContentWidth;

  double get scale => (contentWidth / designWidth).clamp(0.85, 1.3).toDouble();

  double get horizontalPadding => (contentWidth * 0.06).clamp(16.0, 28.0).toDouble();

  /// Scale a design value (font size, padding, icon size, radius...).
  double sp(double value) => value * scale;
}

/// Centers [child] and limits its width to [Responsive.contentWidth].
/// Keeps the full available height so inner scroll views behave normally.
class ContentConstraint extends StatelessWidget {
  const ContentConstraint({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: r.contentWidth,
        height: double.infinity,
        child: child,
      ),
    );
  }
}
