import 'dart:async';
import 'dart:math';
import 'package:flight_booking/generated/l10n.dart' as lang;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constant.dart';

class FlightSearchLoading extends StatefulWidget {
  final String destinationCity;
  final Future<void> Function() searchFunction;
  final VoidCallback onSearchComplete;
  /// Called after search completes to get the real total number of flights.
  final int Function()? getTotalFlights;

  const FlightSearchLoading({
    Key? key,
    required this.destinationCity,
    required this.searchFunction,
    required this.onSearchComplete,
    this.getTotalFlights,
  }) : super(key: key);

  @override
  State<FlightSearchLoading> createState() => _FlightSearchLoadingState();
}

class _FlightSearchLoadingState extends State<FlightSearchLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  int _providersCount = 0;
  int _combinationsCount = 0;
  int _targetCombinations = 0; // Real total from API
  bool _apiDone = false;
  Timer? _countTimer;
  bool _searchComplete = false;
  late final Stopwatch _stopwatch;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch()..start();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _startCountAnimation();
    _performSearch();
  }

  void _startCountAnimation() {
    final random = Random();
    _countTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!mounted) return;
      setState(() {
        // Providers counter
        if (_providersCount < 185) {
          _providersCount += random.nextInt(15) + 5;
          if (_providersCount > 185) _providersCount = 185;
        }

        if (_apiDone && _targetCombinations > 0) {
          // API done: animate quickly toward real total
          final remaining = _targetCombinations - _combinationsCount;
          if (remaining > 0) {
            final increment = max(1, (remaining / 8).round()) + random.nextInt(max(1, (remaining / 15).round()));
            _combinationsCount += increment;
            if (_combinationsCount > _targetCombinations) {
              _combinationsCount = _targetCombinations;
            }
          }
        } else if (!_apiDone) {
          // While waiting for API: slowly climb to 50 over ~5 seconds
          // Using elapsed time to control the pace
          final elapsed = _stopwatch.elapsedMilliseconds;
          final progress = (elapsed / 5000).clamp(0.0, 1.0);
          // Ease-out curve: fast at start, slows down near 50
          final eased = 1.0 - pow(1.0 - progress, 2.5);
          final target = (eased * 50).round();
          if (_combinationsCount < target) {
            _combinationsCount = target;
          }
        }
      });
    });
  }

  Future<void> _performSearch() async {
    try {
      await widget.searchFunction();

      final realTotal = widget.getTotalFlights?.call() ?? 0;
      if (mounted) {
        setState(() {
          _apiDone = true;
          _targetCombinations = realTotal;
          _providersCount = 185;
        });
      }

      // Wait for the counter to animate to the real total
      await Future.delayed(const Duration(milliseconds: 1500));

      if (mounted) {
        setState(() {
          _searchComplete = true;
          _combinationsCount = realTotal;
        });
      }
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) {
        widget.onSearchComplete();
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(lang.S.of(context).loadingSearchError(e.toString()))),
        );
      }
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _countTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C2C2C),
      body: Stack(
        children: [
          // Background image with dark overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('images/city_background.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.6),
                    BlendMode.darken,
                  ),
                  onError: (exception, stackTrace) {},
                ),
              ),
              child: Container(
                color: const Color(0xFF3C3C3C).withOpacity(0.85),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: kPrimaryColor,
                          size: 24,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          lang.S.of(context).loadingResults,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.jost(
                            color: kWhite,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                    ],
                  ),
                ),

                // Destination text
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: widget.destinationCity,
                          style: GoogleFonts.jost(
                            color: kWhite,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: lang.S.of(context).loadingAwaitsYou,
                          style: GoogleFonts.jost(
                            color: kWhite.withOpacity(0.8),
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Main loading area
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated plane with circular progress
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Rotating orange circle
                            AnimatedBuilder(
                              animation: _rotationController,
                              builder: (context, child) {
                                return Transform.rotate(
                                  angle: _rotationController.value * 2 * pi,
                                  child: CustomPaint(
                                    size: const Size(110, 110),
                                    painter: CircularProgressPainter(
                                      progress: 0.75,
                                      color: kPrimaryColor,
                                      strokeWidth: 4,
                                    ),
                                  ),
                                );
                              },
                            ),
                            // Plane icon
                            Container(
                              width: 80,
                              height: 80,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF4A4A4A),
                              ),
                              child: const Icon(
                                Icons.flight,
                                color: kWhite,
                                size: 40,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Please wait text
                      Text(
                        lang.S.of(context).loadingPleaseWait,
                        style: GoogleFonts.jost(
                          color: kPrimaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Searching for flights
                      Text(
                        lang.S.of(context).loadingSearchingFlights,
                        style: GoogleFonts.jost(
                          color: kWhite,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 60),

                      // Stats row
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildStatColumn(
                                lang.S.of(context).loadingConnectingTo,
                                _providersCount.toString(),
                                lang.S.of(context).loadingProviders,
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 60,
                              color: kWhite.withOpacity(0.2),
                            ),
                            Expanded(
                              child: _buildStatColumn(
                                lang.S.of(context).loadingResultsLabel,
                                _combinationsCount.toString(),
                                lang.S.of(context).loadingFlightsFound,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom promotional section
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: kWhite,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lang.S.of(context).loadingMeanwhile,
                              style: GoogleFonts.jost(
                                color: kSubTitleColor,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: lang.S.of(context).loadingPromoText1,
                                    style: GoogleFonts.jost(
                                      color: kTitleColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '30%',
                                    style: GoogleFonts.jost(
                                      color: kPrimaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: lang.S.of(context).loadingPromoText2,
                                    style: GoogleFonts.jost(
                                      color: kTitleColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: lang.S.of(context).loadingPromoAccommodation,
                                    style: GoogleFonts.jost(
                                      color: kPrimaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: kPrimaryColor,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'H24',
                                    style: GoogleFonts.jost(
                                      color: kWhite,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Voyages',
                                  style: GoogleFonts.jost(
                                    color: kTitleColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'images/hotel_promo.jpg',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: kPrimaryColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.hotel,
                                color: kPrimaryColor,
                                size: 40,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, String subtitle) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.jost(
            color: kWhite.withOpacity(0.6),
            fontSize: 10,
            fontWeight: FontWeight.w500,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.jost(
            color: kWhite,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          subtitle,
          style: GoogleFonts.jost(
            color: kWhite.withOpacity(0.8),
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

// Custom painter for the circular progress
class CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  CircularProgressPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
