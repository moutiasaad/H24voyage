import 'package:flight_booking/Model/Airport.dart';
import 'package:flight_booking/generated/l10n.dart' as lang;
import 'package:flight_booking/models/flight_offer.dart';
import 'package:flight_booking/models/flight_search_response.dart';
import 'package:flight_booking/screen/widgets/constant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../controllers/flight_controller.dart';
import '../../controllers/search_result_controller.dart';
import '../../models/flight_bound.dart';
import '../widgets/orange_dots_loader.dart';
import '../home/models/multi_destination_leg.dart';
import '../widgets/EditSearchBottomSheet.dart';
import '../widgets/flight_search_loading.dart';
import 'widgets/flight_card_widgets.dart';
import 'widgets/search_bottom_sheets.dart';
import 'widgets/search_filter_widgets.dart';
import 'widgets/animated_flight_card.dart';
import 'widgets/shimmer_flight_card.dart';
// import 'widgets/animated_total_counter.dart'; // Available for future use
import 'widgets/flight_status_pill.dart';

class SearchResult extends StatefulWidget {
  final Airport fromAirport;
  final Airport toAirport;
  final int adultCount;
  final int childCount;
  final int infantCount;
  final DateTimeRange? dateRange;
  final List<FlightOffer>? flightOffers;
  final bool isOneWay;
  final bool isMultiDestination;
  final String? searchCode;
  final int? totalOffers;
  final String? errorMessage;
  final List<AirlineInfo>? apiAirlines;
  final double? apiMinPrice;
  final double? apiMaxPrice;

  const SearchResult({
    Key? key,
    required this.fromAirport,
    required this.toAirport,
    required this.adultCount,
    required this.childCount,
    required this.infantCount,
    this.dateRange,
    this.flightOffers,
    this.isOneWay = false,
    this.isMultiDestination = false,
    this.searchCode,
    this.totalOffers,
    this.errorMessage,
    this.apiAirlines,
    this.apiMinPrice,
    this.apiMaxPrice,
  }) : super(key: key);

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult>
    with TickerProviderStateMixin {
  // ── Controller (owns all state, filters, pagination, sorting) ──
  late final SearchResultController _ctrl;

  // ── UI-only state ──
  final ScrollController _scrollController = ScrollController();
  final FlightController _flightController = FlightController();

  // ── Panel slide-up animation (plays once on page open) ──
  late final AnimationController _panelController;
  late final Animation<Offset> _panelSlide;
  late final Animation<double> _panelOpacity;

  // ── Stagger animation for flight cards ──
  late final AnimationController _staggerController;
  bool _previousIsReloading = false;
  bool _initialStaggerPlayed = false;
  int _staggerItemCount = 15;

  // ── Shimmer animation for loading skeleton cards ──
  late final AnimationController _shimmerController;

  // ── Fade-out animation for filter change ──
  late final AnimationController _fadeController;

  // ── Bounce animation for empty state icon ──
  late final AnimationController _bounceController;
  late final Animation<double> _bounceScale;

  // ── Floating sort/filter bar (scroll-up reveal) ──
  late final AnimationController _fabController;
  late final Animation<Offset> _fabSlide;
  double _lastScrollOffset = 0;

  // ── Bottom status pill ──
  final GlobalKey<FlightStatusPillState> _pillKey = GlobalKey();
  bool _pillDismissed = false;

  // Responsive breakpoints (need BuildContext)
  bool get isSmallScreen => MediaQuery.of(context).size.width < 360;
  bool get isMediumScreen => MediaQuery.of(context).size.width < 400;
  double get screenWidth => MediaQuery.of(context).size.width;

  /// Convert raw API error into a professional user-friendly message
  String _getUserFriendlyError(String raw, lang.S t) {
    final lower = raw.toLowerCase();
    if (lower.contains('aucun vol') || lower.contains('no flight')) {
      return t.searchErrorNoFlights;
    }
    if (lower.contains('timeout') || lower.contains('timed out')) {
      return t.searchErrorTimeout;
    }
    if (lower.contains('no internet') || lower.contains('network') || lower.contains('socket') || lower.contains('connection')) {
      return t.searchErrorNoInternet;
    }
    if (lower.contains('500') || lower.contains('server') || lower.contains('internal')) {
      return t.searchErrorServer;
    }
    if (lower.contains('401') || lower.contains('unauthorized') || lower.contains('token')) {
      return t.searchErrorSessionExpired;
    }
    if (lower.contains('403') || lower.contains('forbidden')) {
      return t.searchErrorForbidden;
    }
    if (lower.contains('404') || lower.contains('not found')) {
      return t.searchErrorNotFound;
    }
    if (lower.contains('429') || lower.contains('too many')) {
      return t.searchErrorTooMany;
    }
    return t.searchErrorUnexpected;
  }

  @override
  void initState() {
    super.initState();

    _ctrl = SearchResultController(
      searchCode: widget.searchCode,
      fromAirport: widget.fromAirport,
      toAirport: widget.toAirport,
    );

    // Panel slide-up animation: Offset(0,1) → Offset(0,0), 350ms
    _panelController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _panelSlide = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _panelController,
      curve: Curves.easeOutCubic,
    ));
    _panelOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _panelController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    // Stagger animation controller (duration set dynamically per batch)
    _staggerController = AnimationController(
      vsync: this,
      duration: _computeStaggerDuration(_staggerItemCount),
    );
    // Show floating bar after stagger completes — but only if pill is already gone
    _staggerController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        if (_pillDismissed) {
          _fabController.forward();
        }
      }
    });

    _shimmerController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat();

    // Fade-out for filter change
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      value: 1.0,
    );

    // Bounce for empty state icon
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _bounceScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.2), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 0.95), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 0.95, end: 1.0), weight: 30),
    ]).animate(_bounceController);

    // Floating sort/filter bar — slides up from bottom on scroll up
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fabSlide = Tween<Offset>(
      begin: const Offset(0, 1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _fabController,
      curve: Curves.easeOutCubic,
    ));

    _ctrl.addListener(_onControllerChanged);
    _scrollController.addListener(_onScroll);

    // Start panel slide-up after a short delay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 150), () {
        if (mounted) _panelController.forward();
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      String? assetData;
      if (widget.flightOffers == null || widget.flightOffers!.isEmpty) {
        assetData = await DefaultAssetBundle.of(context)
            .loadString('assets/data/airports.json');
      }
      _ctrl.initialize(
        initialOffers: widget.flightOffers,
        totalOffers: widget.totalOffers,
        assetJsonData: assetData,
        apiAirlines: widget.apiAirlines,
        apiMinPrice: widget.apiMinPrice,
        apiMaxPrice: widget.apiMaxPrice,
      );
    });
  }

  /// Detects data load and filter reload completion to trigger animations.
  void _onControllerChanged() {
    if (!mounted) return;

    // Detect reload START → restart pill, fade out existing cards, hide fab
    if (!_previousIsReloading && _ctrl.isReloading) {
      _fadeController.reverse();
      _fabController.reverse(); // hide during reload
      _pillDismissed = false;
      _pillKey.currentState?.restartForReload();
    }

    // Detect reload COMPLETE → complete pill, play stagger or bounce
    if (_previousIsReloading && !_ctrl.isReloading) {
      _pillKey.currentState?.completeWithTotal(_ctrl.totalFlights);
      if (_ctrl.hasApiFlights) {
        _fadeController.value = 1.0;
        _playStaggerAnimation(); // stagger listener will show fab on complete
      } else {
        // No stagger animation — fab will show when pill dismisses
        if (_ctrl.hasActiveFilters) {
          _bounceController.reset();
          _bounceController.forward();
        }
      }
    }
    _previousIsReloading = _ctrl.isReloading;

    // Trigger initial stagger when first data arrives
    if (!_initialStaggerPlayed &&
        !_ctrl.isReloading &&
        _ctrl.filteredApiFlights.isNotEmpty) {
      _initialStaggerPlayed = true;
      _pillKey.currentState?.completeWithTotal(_ctrl.totalFlights);
      _playStaggerAnimation();
    }

    setState(() {});
  }

  /// Computes total stagger duration: (itemCount-1)*80 + 250 ms
  Duration _computeStaggerDuration(int itemCount) {
    final capped = itemCount.clamp(1, 15);
    return Duration(milliseconds: (capped - 1) * 80 + 250);
  }

  /// Resets and plays the stagger animation for the current batch of cards.
  void _playStaggerAnimation() {
    _fabController.reverse(); // hide fab during card animation
    final count = _ctrl.filteredApiFlights.length.clamp(1, 15);
    _staggerItemCount = count;
    _staggerController.duration = _computeStaggerDuration(count);
    _staggerController.reset();
    _staggerController.forward();
  }

  @override
  void dispose() {
    _panelController.dispose();
    _staggerController.dispose();
    _shimmerController.dispose();
    _fadeController.dispose();
    _bounceController.dispose();
    _fabController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _ctrl.removeListener(_onControllerChanged);
    _ctrl.dispose();
    super.dispose();
  }

  /// Show edit search bottom sheet to modify search parameters
  void _showEditSearchBottomSheet() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (_) => EditSearchBottomSheet(
        fromAirport: widget.fromAirport,
        toAirport: widget.toAirport,
        adultCount: widget.adultCount,
        childCount: widget.childCount,
        infantCount: widget.infantCount,
        dateRange: widget.dateRange,
        isOneWay: widget.isOneWay,
        isMultiDestination: widget.isMultiDestination,
      ),
    );

    if (result != null && mounted) {
      final fromAirport = result['fromAirport'] as Airport;
      final toAirport = result['toAirport'] as Airport;
      final adultCount = result['adultCount'] as int;
      final childCount = result['childCount'] as int;
      final infantCount = result['infantCount'] as int;
      final departureDate = result['departureDate'] as DateTime?;
      final returnDate = result['returnDate'] as DateTime?;
      final isOneWay = result['isOneWay'] as bool;
      final isMultiDestination = result['isMultiDestination'] as bool? ?? false;
      final isDirectFlight = result['isDirectFlight'] as bool? ?? false;
      final multiDestinationLegs = result['multiDestinationLegs'] as List<MultiDestinationLeg>? ?? [];

      // Navigate to loading screen and perform search
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FlightSearchLoading(
            destinationCity: toAirport.city,
            searchFunction: () async {
              if (isMultiDestination) {
                // Build flight bounds for multi-destination
                final bounds = <FlightBound>[];

                // First leg (from main fromAirport to toAirport)
                bounds.add(FlightBound(
                  origin: fromAirport.code,
                  destination: toAirport.code,
                  departureDate: SearchResultController.formatDateForApi(departureDate!),
                ));

                // Additional legs
                for (final leg in multiDestinationLegs) {
                  if (leg.fromAirport != null && leg.toAirport != null && leg.departureDate != null) {
                    bounds.add(FlightBound(
                      origin: leg.fromAirport!.code,
                      destination: leg.toAirport!.code,
                      departureDate: SearchResultController.formatDateForApi(leg.departureDate!),
                    ));
                  }
                }

                await _flightController.searchMultiDestination(
                  bounds: bounds,
                  adultCount: adultCount,
                  childCount: childCount,
                  infantCount: infantCount,
                  directOnly: isDirectFlight,
                );
              } else if (isOneWay) {
                await _flightController.searchOneWay(
                  fromAirport: fromAirport,
                  toAirport: toAirport,
                  departureDate: departureDate!,
                  adultCount: adultCount,
                  childCount: childCount,
                  infantCount: infantCount,
                  directOnly: isDirectFlight,
                );
              } else {
                await _flightController.searchRoundTrip(
                  fromAirport: fromAirport,
                  toAirport: toAirport,
                  departureDate: departureDate!,
                  returnDate: returnDate!,
                  adultCount: adultCount,
                  childCount: childCount,
                  infantCount: infantCount,
                  directOnly: isDirectFlight,
                );
              }
            },
            onSearchComplete: () {
              Navigator.pop(context); // Pop loading screen
              // Navigate to new search result, replacing current one
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => SearchResult(
                    fromAirport: fromAirport,
                    toAirport: toAirport,
                    adultCount: adultCount,
                    childCount: childCount,
                    infantCount: infantCount,
                    dateRange: departureDate != null
                        ? DateTimeRange(
                            start: departureDate,
                            end: returnDate ?? departureDate,
                          )
                        : null,
                    flightOffers: _flightController.hasError ? [] : _flightController.offers,
                    isOneWay: isOneWay,
                    isMultiDestination: isMultiDestination,
                    searchCode: _flightController.searchCode,
                    totalOffers: _flightController.totalOffers,
                    errorMessage: _flightController.hasError
                        ? _flightController.errorMessage ?? lang.S.of(context).homeSearchError
                        : null,
                    apiAirlines: _flightController.availableAirlines,
                    apiMinPrice: _flightController.minPrice,
                    apiMaxPrice: _flightController.maxPrice,
                  ),
                ),
              );
            },
          ),
        ),
      );
    }
  }

  void _onScroll() {
    // Pagination
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _ctrl.loadMoreItems();
    }

    final offset = _scrollController.position.pixels;

    // Don't interfere while stagger animation is playing or pill is still visible
    if (_staggerController.isAnimating || !_pillDismissed) {
      _lastScrollOffset = offset;
      return;
    }

    // At top of page → show
    if (offset <= 0) {
      _fabController.forward();
    }
    // Scrolling up → show
    else if (offset < _lastScrollOffset - 5) {
      _fabController.forward();
    }
    // Scrolling down → hide
    else if (offset > _lastScrollOffset + 5) {
      _fabController.reverse();
    }
    _lastScrollOffset = offset;
  }

  // Build paginated API flights list as slivers
  List<Widget> _buildPaginatedApiFlightsList(String fromCode, String toCode) {
    final allFilteredFlights = _ctrl.filteredApiFlights;

    // Show shimmer skeleton cards while reloading or while chip filter is
    // pending (each airline chip always has ≥1 flight, so empty = still loading)
    if (_ctrl.isReloading ||
        (allFilteredFlights.isEmpty && _ctrl.selectedAirlineCode != null)) {
      return [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => ShimmerFlightCard(animation: _shimmerController),
            childCount: 3,
          ),
        ),
      ];
    }

    if (allFilteredFlights.isEmpty && _ctrl.hasActiveFilters) {
      return [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Center(
              child: Column(
                children: [
                  ScaleTransition(
                    scale: _bounceScale,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.filter_alt_off_rounded,
                        size: 40,
                        color: kSubTitleColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    lang.S.of(context).searchNoFlightsForFilters,
                    style: GoogleFonts.poppins(
                      color: kTitleColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    lang.S.of(context).searchTryModifyFilters,
                    style: GoogleFonts.poppins(
                      color: kSubTitleColor,
                      fontSize: 14,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  TextButton.icon(
                    onPressed: () {
                      _ctrl.resetAllFilters();
                      _ctrl.reloadFlightsWithFilters();
                    },
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: Text(
                      lang.S.of(context).searchResetFilters,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: kPrimaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: kPrimaryColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ];
    }

    return [
      // Flight cards - show all loaded flights (API pagination loads in batches)
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, i) {
            final offer = allFilteredFlights[i];
            final card = Padding(
              padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 10 : 16),
              child: ApiFlightCard(
                offer: offer,
                index: i,
                fromCode: fromCode,
                toCode: toCode,
                ctrl: _ctrl,
                isSmallScreen: isSmallScreen,
                isMediumScreen: isMediumScreen,
                isOneWay: widget.isOneWay,
                isMultiDestination: widget.isMultiDestination,
                onReserve: () => showFlightDetailsBottomSheet(context, offer, _ctrl, isOneWay: widget.isOneWay),
                onFlightDetailsTap: (journeyIndex) => showFlightDetailsBottomSheet(context, offer, _ctrl, isOneWay: widget.isOneWay, initialTab: journeyIndex),
                onPriceDetailsTap: (ctx, o) => showPriceDetailsBottomSheet(ctx, o),
                onBaggageDetailsTap: (ctx, b) => showBaggageDetailsBottomSheet(ctx, b),
              ),
            );

            // Stagger-animate the first batch; pagination items appear instantly
            if (i < _staggerItemCount) {
              return AnimatedFlightCard(
                animation: _staggerController,
                index: i,
                itemCount: _staggerItemCount,
                child: card,
              );
            }
            return card;
          },
          childCount: allFilteredFlights.length,
        ),
      ),
      // Loading indicator or "Load more" area
      if (_ctrl.hasMorePages || _ctrl.isLoadingMore)
        SliverToBoxAdapter(
          child: _ctrl.isLoadingMore
              ? PaginationLoader(message: lang.S.of(context).searchLoadingFlights)
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Text(
                      _ctrl.totalPages != null
                          ? lang.S.of(context).searchPageInfo(_ctrl.currentPage.toString(), _ctrl.totalPages.toString())
                          : lang.S.of(context).searchScrollForMore,
                      style: GoogleFonts.poppins(
                        color: kSubTitleColor,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final fromCity = widget.fromAirport.city.split(',')[0];
    final toCity = widget.toAirport.city.split(',')[0];
    final fromCode = widget.fromAirport.code;
    final toCode = widget.toAirport.code;
    final totalPassengers = widget.adultCount + widget.childCount;

    return Scaffold(
      backgroundColor: kWhite,
      body: Stack(
        children: [
          // Main content
          Column(
            children: [
              // Header Section with orange gradient
              SearchResultHeader(
                fromCity: fromCity,
                toCity: toCity,
                totalPassengers: totalPassengers,
                infantCount: widget.infantCount,
                dateRange: widget.dateRange,
                isSmallScreen: isSmallScreen,
                isMediumScreen: isMediumScreen,
                onBack: () => Navigator.pop(context),
                onEdit: _showEditSearchBottomSheet,
              ),

              // Animated content panel — slides up from bottom on page open
              Expanded(
            child: SlideTransition(
              position: _panelSlide,
              child: FadeTransition(
                opacity: _panelOpacity,
                child: Container(
                  decoration: const BoxDecoration(
                    color: kWhite,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x1A000000),
                        blurRadius: 16,
                        offset: Offset(0, -4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                    child: CustomScrollView(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        // Drag indicator
                        SliverToBoxAdapter(
                          child: Center(
                            child: Container(
                              margin: const EdgeInsets.only(top: 12, bottom: 4),
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ),

                        // Duration banner (only for round-trip with both dates)
                        if (widget.dateRange != null && widget.dateRange!.start != widget.dateRange!.end)
                          SliverToBoxAdapter(
                            child: Container(
                              margin: EdgeInsets.fromLTRB(isSmallScreen ? 10 : 16, 8, isSmallScreen ? 10 : 16, 0),
                              padding: EdgeInsets.symmetric(
                                horizontal: isSmallScreen ? 10 : 16,
                                vertical: isSmallScreen ? 8 : 10,
                              ),
                              decoration: BoxDecoration(
                                color: kPrimaryColor.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: kPrimaryColor.withOpacity(0.2)),
                              ),
                              child: isSmallScreen
                                  ? Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.access_time_rounded, size: 16, color: kPrimaryColor),
                                            const SizedBox(width: 6),
                                            Flexible(
                                              child: Text(
                                                '${lang.S.of(context).searchStayDuration}${widget.dateRange!.duration.inDays} ${widget.dateRange!.duration.inDays > 1 ? lang.S.of(context).datePickerDays : lang.S.of(context).datePickerDay}',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color: kPrimaryColor,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 22),
                                          child: Text(
                                            '${DateFormat('dd MMM', 'fr').format(widget.dateRange!.start)} - ${DateFormat('dd MMM', 'fr').format(widget.dateRange!.end)}',
                                            style: GoogleFonts.poppins(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                              color: kPrimaryColor.withOpacity(0.7),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        Icon(Icons.access_time_rounded, size: 18, color: kPrimaryColor),
                                        const SizedBox(width: 8),
                                        Flexible(
                                          child: Text(
                                            '${lang.S.of(context).searchStayDuration}${widget.dateRange!.duration.inDays} ${widget.dateRange!.duration.inDays > 1 ? lang.S.of(context).datePickerDays : lang.S.of(context).datePickerDay}',
                                            style: GoogleFonts.poppins(
                                              fontSize: isMediumScreen ? 12 : 13,
                                              fontWeight: FontWeight.w600,
                                              color: kPrimaryColor,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '${DateFormat('dd MMM', 'fr').format(widget.dateRange!.start)} - ${DateFormat('dd MMM', 'fr').format(widget.dateRange!.end)}',
                                          style: GoogleFonts.poppins(
                                            fontSize: isMediumScreen ? 11 : 12,
                                            fontWeight: FontWeight.w500,
                                            color: kPrimaryColor.withOpacity(0.7),
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),

                        // Top spacing
                        const SliverToBoxAdapter(
                          child: SizedBox(height: 12),
                        ),

                // Vol direct toggle + Filter buttons
                SliverToBoxAdapter(
                  child: FilterSection(
                    ctrl: _ctrl,
                    isSmallScreen: isSmallScreen,
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: 12),
                ),

                // Price filter chips
                SliverToBoxAdapter(
                  child: PriceChipsRow(
                    ctrl: _ctrl,
                    isSmallScreen: isSmallScreen,
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: 28),
                ),

                // Flight cards with pagination
                if (_ctrl.hasApiFlights || _ctrl.isReloading)
                  ..._buildPaginatedApiFlightsList(fromCode, toCode)
                else if (widget.flightOffers != null && widget.flightOffers!.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                      child: Center(
                        child: Builder(
                          builder: (context) {
                            final isNoFlights = widget.errorMessage == null ||
                                widget.errorMessage!.toLowerCase().contains('aucun vol') ||
                                widget.errorMessage!.toLowerCase().contains('no flight');
                            final isRealError = widget.errorMessage != null && !isNoFlights;

                            return Column(
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: isRealError
                                        ? Colors.red.shade50
                                        : Colors.grey.shade100,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    isRealError
                                        ? Icons.cloud_off_rounded
                                        : Icons.flight_outlined,
                                    size: 40,
                                    color: isRealError
                                        ? Colors.red.shade300
                                        : kSubTitleColor,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  isRealError
                                      ? lang.S.of(context).searchUnavailable
                                      : lang.S.of(context).searchNoFlightsFound,
                                  style: GoogleFonts.poppins(
                                    color: kTitleColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  isRealError
                                      ? _getUserFriendlyError(widget.errorMessage!, lang.S.of(context))
                                      : lang.S.of(context).searchTryModifyDates,
                                  style: GoogleFonts.poppins(
                                    color: kSubTitleColor,
                                    fontSize: 14,
                                    height: 1.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 24),
                                TextButton.icon(
                                  onPressed: _showEditSearchBottomSheet,
                                  icon: const Icon(Icons.edit, size: 18),
                                  label: Text(
                                    lang.S.of(context).searchEditSearch,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                    foregroundColor: kPrimaryColor,
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide(color: kPrimaryColor),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) {
                        final f = _ctrl.flights[i];
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 10 : 16),
                          child: FakeFlightCard(
                            flight: f,
                            index: i,
                            fromCode: fromCode,
                            toCode: toCode,
                            ctrl: _ctrl,
                            isSmallScreen: isSmallScreen,
                            dateRange: widget.dateRange,
                            onToggleOutbound: () => _ctrl.toggleExpandedOutbound(i),
                            onToggleReturn: () => _ctrl.toggleExpandedReturn(i),
                            onReserve: () => showFakeFlightDetailsBottomSheet(
                              context,
                              flight: f,
                              index: i,
                              fromCode: fromCode,
                              toCode: toCode,
                              dateRange: widget.dateRange,
                            ),
                          ),
                        );
                      },
                      childCount: _ctrl.flights.length,
                    ),
                  ),

                        // Bottom spacing for floating bar clearance
                        const SliverToBoxAdapter(
                          child: SizedBox(height: 100),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
            ],
          ),

          // Bottom status pill overlay
          if (!_pillDismissed)
            Positioned(
              left: 0,
              right: 0,
              bottom: MediaQuery.of(context).padding.bottom + 16,
              child: FlightStatusPill(
                key: _pillKey,
                totalFlights: _ctrl.totalFlights,
                isComplete: !_ctrl.isReloading && _ctrl.hasApiFlights,
                onDismissed: () {
                  if (mounted) {
                    setState(() => _pillDismissed = true);
                    // Pill is gone — show fab after a short pause
                    Future.delayed(const Duration(milliseconds: 800), () {
                      if (mounted && !_staggerController.isAnimating) {
                        _fabController.forward();
                      }
                    });
                  }
                },
              ),
            ),

          // Floating Sort & Filter bar — single capsule, appears after animation
          Positioned(
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).padding.bottom + 24,
            child: SlideTransition(
              position: _fabSlide,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: kPrimaryColor.withOpacity(0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Sort button
                      GestureDetector(
                        onTap: () => showSortBottomSheet(context, _ctrl),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.swap_vert, color: kWhite, size: 18),
                              const SizedBox(width: 6),
                              Text(
                                lang.S.of(context).sortDefaultShort,
                                style: kTextStyle.copyWith(
                                  color: kWhite,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Vertical divider
                      Container(
                        width: 1,
                        height: 24,
                        color: kWhite.withOpacity(0.4),
                      ),
                      // Filter button
                      GestureDetector(
                        onTap: () => showFilterBottomSheet(context, _ctrl),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.tune, color: kWhite, size: 18),
                              const SizedBox(width: 6),
                              Text(
                                lang.S.of(context).filterTitle,
                                style: kTextStyle.copyWith(
                                  color: kWhite,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (_ctrl.activeFilterCount > 0) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: kWhite,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '${_ctrl.activeFilterCount}',
                                    style: kTextStyle.copyWith(
                                      color: kPrimaryColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
