import 'dart:math' as math;
import 'package:flutter/material.dart';

class OrangeDotsLoader extends StatefulWidget {
  final double size;
  final Duration duration;

  const OrangeDotsLoader({
    Key? key,
    this.size = 50.0,
    this.duration = const Duration(milliseconds: 1200),
  }) : super(key: key);

  @override
  State<OrangeDotsLoader> createState() => _OrangeDotsLoaderState();
}

class _OrangeDotsLoaderState extends State<OrangeDotsLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _OrangeDotsPainter(
              progress: _controller.value,
            ),
          );
        },
      ),
    );
  }
}

class _OrangeDotsPainter extends CustomPainter {
  final double progress;
  static const int dotCount = 8;

  // Orange color gradient from dark to light
  static const List<Color> dotColors = [
    Color(0xFFFF6B00), // Dark orange
    Color(0xFFFF7F1A), // Medium-dark orange
    Color(0xFFFF9333), // Medium orange
    Color(0xFFFFA74D), // Medium-light orange
    Color(0xFFFFBB66), // Light orange
    Color(0xFFFFCF80), // Lighter orange
    Color(0xFFFFE399), // Very light orange
    Color(0xFFFFF7B2), // Pale orange/cream
  ];

  _OrangeDotsPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;
    final dotRadius = size.width / 14;

    for (int i = 0; i < dotCount; i++) {
      // Calculate the angle for each dot
      final angle = (2 * math.pi / dotCount) * i - math.pi / 2;

      // Calculate the color index based on animation progress
      final colorIndex = (i + (progress * dotCount).floor()) % dotCount;

      final dotX = center.dx + radius * math.cos(angle);
      final dotY = center.dy + radius * math.sin(angle);

      final paint = Paint()
        ..color = dotColors[colorIndex]
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(dotX, dotY), dotRadius, paint);
    }
  }

  @override
  bool shouldRepaint(_OrangeDotsPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

// Pagination loading widget with orange dots
class PaginationLoader extends StatelessWidget {
  final String? message;

  const PaginationLoader({
    Key? key,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const OrangeDotsLoader(size: 50),
          if (message != null) ...[
            const SizedBox(height: 12),
            Text(
              message!,
              style: const TextStyle(
                color: Color(0xFF6F7B8C),
                fontSize: 14,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
