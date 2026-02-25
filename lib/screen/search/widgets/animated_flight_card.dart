import 'package:flutter/material.dart';

/// Wraps a flight card with staggered fade + slide-up animation.
///
/// Uses [Interval] curves from a shared parent [AnimationController]
/// to create a stagger effect: each card at [index] starts its animation
/// 80ms after the previous one, with each card animating over 250ms.
///
/// Only the first [itemCount] cards are animated — pagination-loaded
/// items beyond this threshold should not use this wrapper.
class AnimatedFlightCard extends AnimatedWidget {
  final Widget child;
  final int index;
  final int itemCount;

  const AnimatedFlightCard({
    super.key,
    required Animation<double> animation,
    required this.child,
    required this.index,
    required this.itemCount,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;

    // Stagger timing: 80ms delay between items, 250ms per item animation
    // Total timeline = (itemCount - 1) * 80 + 250 ms
    final totalMs = ((itemCount - 1) * 80 + 250).toDouble();
    final startMs = (index * 80).toDouble();
    final endMs = startMs + 250.0;

    final start = (startMs / totalMs).clamp(0.0, 1.0);
    final end = (endMs / totalMs).clamp(0.0, 1.0);

    final intervalAnimation = CurvedAnimation(
      parent: animation,
      curve: Interval(start, end, curve: Curves.easeOut),
    );

    return FadeTransition(
      opacity: intervalAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.15), // Subtle upward slide (10-15px)
          end: Offset.zero,
        ).animate(intervalAnimation),
        child: child,
      ),
    );
  }
}
