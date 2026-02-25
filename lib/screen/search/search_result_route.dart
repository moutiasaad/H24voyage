import 'package:flutter/material.dart';

/// Premium page route that slides the SearchResult screen up from the bottom
/// with a dimming background overlay — like Airbnb/Booking.com panel effect.
///
/// Animation flow:
/// 1. Entry: black overlay fades in (0→0.25 opacity) while page slides up
/// 2. Dismiss: page slides back down while overlay fades out (auto on pop/back)
class SearchResultRoute<T> extends PageRoute<T> {
  final WidgetBuilder builder;

  SearchResultRoute({required this.builder}) : super(fullscreenDialog: false);

  @override
  bool get opaque => false; // Let previous screen show through for dim effect

  @override
  bool get barrierDismissible => false;

  @override
  Color? get barrierColor => null; // We handle dimming manually in transitions

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 350);

  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 300);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return builder(context);
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // Slide: Offset(0,1) → Offset(0,0) with easeOutCubic
    final slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    ));

    // Dim overlay: opacity 0 → 0.25, slightly ahead of slide
    final dimAnimation = Tween<double>(begin: 0.0, end: 0.25).animate(
      CurvedAnimation(
        parent: animation,
        curve: const Interval(0.0, 0.85, curve: Curves.easeOut),
      ),
    );

    return Stack(
      children: [
        // Background dim overlay
        FadeTransition(
          opacity: dimAnimation,
          child: const ColoredBox(
            color: Colors.black,
            child: SizedBox.expand(),
          ),
        ),
        // Page content sliding up
        SlideTransition(
          position: slideAnimation,
          child: child,
        ),
      ],
    );
  }
}
