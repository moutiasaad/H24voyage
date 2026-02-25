import 'package:flutter/material.dart';

/// A single shimmer skeleton card mimicking flight card layout.
class ShimmerFlightCard extends StatelessWidget {
  final Animation<double> animation;

  const ShimmerFlightCard({super.key, required this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: airline logo + route
              Row(
                children: [
                  _shimmerBox(animation, 32, 32, isCircle: true),
                  const SizedBox(width: 10),
                  _shimmerBox(animation, 80, 12),
                  const Spacer(),
                  _shimmerBox(animation, 50, 12),
                ],
              ),
              const SizedBox(height: 14),
              // Route line: departure — plane icon — arrival
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _shimmerBox(animation, 40, 18),
                        const SizedBox(height: 4),
                        _shimmerBox(animation, 30, 10),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Column(
                        children: [
                          _shimmerBox(animation, 60, 8),
                          const SizedBox(height: 6),
                          _shimmerBox(animation, 80, 2),
                          const SizedBox(height: 6),
                          _shimmerBox(animation, 40, 8),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _shimmerBox(animation, 40, 18),
                        const SizedBox(height: 4),
                        _shimmerBox(animation, 30, 10),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              // Bottom row: baggage info + price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _shimmerBox(animation, 60, 12),
                  _shimmerBox(animation, 70, 20),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Renders a list of 3 shimmer skeleton cards as slivers.
class ShimmerFlightCardList extends StatelessWidget {
  final Animation<double> animation;
  final int count;

  const ShimmerFlightCardList({
    super.key,
    required this.animation,
    this.count = 3,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => ShimmerFlightCard(animation: animation),
        childCount: count,
      ),
    );
  }
}

/// A rounded shimmer placeholder box with animated gradient.
Widget _shimmerBox(
  Animation<double> animation,
  double width,
  double height, {
  bool isCircle = false,
}) {
  return AnimatedBuilder(
    animation: animation,
    builder: (context, child) {
      final shimmerValue = animation.value;
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: isCircle ? null : BorderRadius.circular(4),
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
          gradient: LinearGradient(
            begin: Alignment(-1.0 + 2.0 * shimmerValue, 0),
            end: Alignment(-1.0 + 2.0 * shimmerValue + 1.0, 0),
            colors: [
              Colors.grey.shade200,
              Colors.grey.shade100,
              Colors.white,
              Colors.grey.shade100,
              Colors.grey.shade200,
            ],
            stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
          ),
        ),
      );
    },
  );
}
