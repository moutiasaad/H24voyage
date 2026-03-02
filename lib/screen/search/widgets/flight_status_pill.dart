import 'package:flight_booking/generated/l10n.dart' as lang;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Animated bottom pill: search progress → result count → dismiss.
///
/// Timeline (total 4.4s):
/// Phase 1 (0→1.8s):  Dark pill slides up, progress bar sweeps, loading text
/// Phase 2 (1.8→2.4s): Bg dark→green, text → "N vols disponibles", checkmark
/// Phase 3 (2.4→3.4s): Green pill with checkmark holds (1.0s)
/// Phase 4 (3.4→4.4s): Pill shrinks → circle → fades out (1.0s)
class FlightStatusPill extends StatefulWidget {
  final int totalFlights;
  final bool isComplete;
  final VoidCallback? onDismissed;

  const FlightStatusPill({
    super.key,
    required this.totalFlights,
    required this.isComplete,
    this.onDismissed,
  });

  @override
  State<FlightStatusPill> createState() => FlightStatusPillState();
}

class FlightStatusPillState extends State<FlightStatusPill>
    with TickerProviderStateMixin {
  late final AnimationController _masterController;
  late final AnimationController _progressController;

  late final Animation<double> _slideUp;
  late final Animation<double> _pillOpacity;
  late final Animation<double> _progressBar;
  late final Animation<Color?> _bgColor;
  late final Animation<double> _checkScale;
  late final Animation<double> _pillWidth;
  late final Animation<double> _dismissOpacity;

  bool _showResultText = false;
  bool _dismissed = false;
  int _displayedTotal = 0;

  int? _pendingTotal;
  bool _loadingPhaseComplete = false;

  // 4.4s total
  static const _masterDuration = Duration(milliseconds: 4400);

  // Phase 1 ends at 1.8s → 1800/4400 ≈ 0.409
  static const _phase1End = 0.409;

  @override
  void initState() {
    super.initState();

    _masterController = AnimationController(
      vsync: this,
      duration: _masterDuration,
    );

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    // ── Phase 1: Entrance (0→1.8s) ──

    // Slide up: 0→600ms (0→0.136)
    _slideUp = Tween<double>(begin: 80.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.0, 0.136, curve: Curves.easeOutCubic),
      ),
    );

    // Fade in: 0→350ms (0→0.080)
    _pillOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.0, 0.080, curve: Curves.easeOut),
      ),
    );

    _progressBar = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _progressController,
        curve: Curves.easeInOut,
      ),
    );

    // ── Phase 2: Color + checkmark (1.8→2.4s = 0.409→0.545) ──

    _bgColor = ColorTween(
      begin: const Color(0xFF1E1E2C),
      end: const Color(0xFF22C55E),
    ).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.409, 0.545, curve: Curves.easeOut),
      ),
    );

    // Checkmark: 1.9→2.5s (0.432→0.568)
    _checkScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.2), weight: 55),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 0.95), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 0.95, end: 1.0), weight: 25),
    ]).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.432, 0.568, curve: Curves.easeOut),
      ),
    );

    // ── Phase 3: Hold (2.4→3.4s = 0.545→0.773) ──

    // ── Phase 4: Shrink + fade (3.4→4.4s = 0.773→1.0) ──

    // Pill shrinks: 3.4→4.1s (0.773→0.932)
    _pillWidth = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.773, 0.932, curve: Curves.easeInCubic),
      ),
    );

    // Fade out: 4.1→4.4s (0.932→1.0)
    _dismissOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.932, 1.0, curve: Curves.easeOut),
      ),
    );

    _masterController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        setState(() => _dismissed = true);
        widget.onDismissed?.call();
      }
    });

    _masterController.addListener(_onMasterTick);
    _startLoadingPhase();
  }

  void _startLoadingPhase() {
    _progressController.repeat();
    // Animate through phase 1 (1.8s)
    _masterController.animateTo(_phase1End,
        duration: const Duration(milliseconds: 1800));
  }

  void _onMasterTick() {
    if (!mounted) return;
    if (_masterController.value >= _phase1End && !_loadingPhaseComplete) {
      _loadingPhaseComplete = true;
      if (_pendingTotal != null) {
        _triggerCompletion(_pendingTotal!);
      }
    }
  }

  void _triggerCompletion(int total) {
    _progressController.stop();
    setState(() {
      _displayedTotal = total;
      _showResultText = true;
    });
    _masterController.forward();
  }

  /// Called externally when data arrives.
  void completeWithTotal(int total) {
    if (_dismissed || !mounted) return;
    if (_loadingPhaseComplete) {
      _triggerCompletion(total);
    } else {
      _pendingTotal = total;
    }
  }

  /// Restart for a new filter reload.
  void restartForReload() {
    if (!mounted) return;
    setState(() {
      _showResultText = false;
      _dismissed = false;
      _loadingPhaseComplete = false;
      _pendingTotal = null;
    });
    _masterController.reset();
    _progressController.repeat();
    _masterController.animateTo(_phase1End,
        duration: const Duration(milliseconds: 1800));
  }

  @override
  void dispose() {
    _masterController.removeListener(_onMasterTick);
    _masterController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_dismissed) return const SizedBox.shrink();

    final t = lang.S.of(context);

    return AnimatedBuilder(
      animation: Listenable.merge([_masterController, _progressController]),
      builder: (context, child) {
        final bgColor = _bgColor.value ?? const Color(0xFF1E1E2C);
        final isGreen = _showResultText && _masterController.value >= _phase1End;
        final shrinkFraction = _pillWidth.value;
        final screenWidth = MediaQuery.of(context).size.width;
        final maxPillWidth = screenWidth * 0.85;
        const minPillWidth = 48.0;
        final currentWidth = minPillWidth +
            (maxPillWidth - minPillWidth) * (1.0 - shrinkFraction);

        return Transform.translate(
          offset: Offset(0, _slideUp.value),
          child: Opacity(
            opacity: (_pillOpacity.value * _dismissOpacity.value).clamp(0.0, 1.0),
            child: Center(
              child: Container(
                width: currentWidth.clamp(minPillWidth, maxPillWidth),
                height: 48,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: (isGreen
                              ? const Color(0xFF22C55E)
                              : Colors.black)
                          .withValues(alpha: 0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                clipBehavior: Clip.hardEdge,
                child: Stack(
                  children: [
                    // Progress bar (Phase 1)
                    if (!isGreen)
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        height: 3,
                        child: FractionallySizedBox(
                          widthFactor: _progressBar.value,
                          alignment: Alignment.centerLeft,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFF22C55E).withValues(alpha: 0.5),
                                  const Color(0xFF22C55E),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(1.5),
                            ),
                          ),
                        ),
                      ),

                    // Content
                    Center(
                      child: ClipRect(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: shrinkFraction > 0.3 ? 8 : 14,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (isGreen)
                                ScaleTransition(
                                  scale: _checkScale,
                                  child: Container(
                                    width: 26,
                                    height: 26,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.check_rounded,
                                      color: Color(0xFF22C55E),
                                      size: 17,
                                    ),
                                  ),
                                )
                              else
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white.withValues(alpha: 0.7),
                                    ),
                                  ),
                                ),

                              // Text (hidden early to prevent overflow)
                              if (shrinkFraction < 0.1) ...[
                                const SizedBox(width: 12),
                                Flexible(
                                  child: Text(
                                    _showResultText
                                        ? t.pillFlightsAvailable(_displayedTotal)
                                        : t.pillLoading,
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.1,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
