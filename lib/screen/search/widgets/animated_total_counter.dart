import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/constant.dart';

/// Animated flight count widget: counts up from [previousTotal] to [total].
///
/// Uses [IntTween] driven by the parent [animation] to smoothly
/// interpolate between the old and new totals.
class AnimatedTotalCounter extends StatelessWidget {
  final Animation<double> animation;
  final int total;
  final int previousTotal;
  final String suffix;

  const AnimatedTotalCounter({
    super.key,
    required this.animation,
    required this.total,
    required this.previousTotal,
    this.suffix = 'Vols disponibles',
  });

  @override
  Widget build(BuildContext context) {
    if (total <= 0 && previousTotal <= 0) return const SizedBox.shrink();

    final tween = IntTween(begin: previousTotal, end: total);

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final displayValue = tween.evaluate(animation);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$displayValue',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: kTitleColor,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                suffix,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: kSubTitleColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
