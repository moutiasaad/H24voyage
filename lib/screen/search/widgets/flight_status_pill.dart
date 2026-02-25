import 'package:flight_booking/generated/l10n.dart' as lang;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Animated bottom pill: search progress → result count → dismiss.
///
/// Timeline (total 6.5s):
/// Phase 1 (0→1.8s):  Dark pill slides up, progress bar sweeps, loading text
/// Phase 2 (1.8→2.6s): Bg dark→green, text → "N vols disponibles", checkmark
/// Phase 3 (2.6→4.2s): Green pill with checkmark holds (1.6s)
/// Phase 4 (4.2→6.5s): Pill shrinks → circle → fades out
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

  // 6.5s total
  static const _masterDuration = Duration(milliseconds: 6500);

  // Phase 1 ends at 1.8s → 1800/6500 ≈ 0.277
  static const _phase1End = 0.277;

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

    // Slide up: 0→600ms (0→0.092)
    _slideUp = Tween<double>(begin: 80.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.0, 0.092, curve: Curves.easeOutCubic),
      ),
    );

    // Fade in: 0→350ms (0→0.054)
    _pillOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.0, 0.054, curve: Curves.easeOut),
      ),
    );

    _progressBar = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _progressController,
        curve: Curves.easeInOut,
      ),
    );

    // ── Phase 2: Color + checkmark (1.8→2.6s = 0.277→0.40) ──

    _bgColor = ColorTween(
      begin: const Color(0xFF1E1E2C),
      end: const Color(0xFF22C55E),
    ).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.277, 0.40, curve: Curves.easeOut),
      ),
    );

    // Checkmark: 1.9→2.6s (0.292→0.40)
    _checkScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.2), weight: 55),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 0.95), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 0.95, end: 1.0), weight: 25),
    ]).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.292, 0.42, curve: Curves.easeOut),
      ),
    );

    // ── Phase 3: Hold (2.6→4.2s = 0.40→0.646) ──

    // ── Phase 4: Shrink + fade (4.2→6.5s = 0.646→1.0) ──

    // Pill shrinks: 4.2→5.8s (0.646→0.892)
    _pillWidth = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.646, 0.892, curve: Curves.easeInCubic),
      ),
    );

    // Fade out: 5.8→6.5s (0.892→1.0)
    _dismissOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.892, 1.0, curve: Curves.easeOut),
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
