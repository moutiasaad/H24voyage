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
  }) : super(key: key);

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  // ── Controller (owns all state, filters, pagination, sorting) ──
  late final SearchResultController _ctrl;

  // ── UI-only state ──
  final ScrollController _scrollController = ScrollController();
  final FlightController _flightController = FlightController();

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
    _ctrl.addListener(() {
      if (mounted) setState(() {});
    });

    _scrollController.addListener(_onScroll);

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
      );
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
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
                  builder: (context) => SearchResult(
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
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _ctrl.loadMoreItems();
    }
  }

  // Build paginated API flights list as slivers
  List<Widget> _buildPaginatedApiFlightsList(String fromCode, String toCode) {
    final allFilteredFlights = _ctrl.filteredApiFlights;

    // Show loading while reloading flights with filters
    if (_ctrl.isReloading) {
      return [
        SliverToBoxAdapter(
          child: PaginationLoader(message: lang.S.of(context).searchLoadingFlights),
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
                  Container(
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
            return Padding(
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
      body: Column(
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

          // Scrollable Content with Pagination
          Expanded(
            child: CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Duration banner (only for round-trip with both dates)
                if (widget.dateRange != null && widget.dateRange!.start != widget.dateRange!.end)
                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: kPrimaryColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: kPrimaryColor.withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.access_time_rounded, size: 18, color: kPrimaryColor),
                          const SizedBox(width: 8),
                          Text(
                            '${lang.S.of(context).searchStayDuration}${widget.dateRange!.duration.inDays} ${widget.dateRange!.duration.inDays > 1 ? lang.S.of(context).datePickerDays : lang.S.of(context).datePickerDay}',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: kPrimaryColor,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${DateFormat('dd MMM', 'fr').format(widget.dateRange!.start)} - ${DateFormat('dd MMM', 'fr').format(widget.dateRange!.end)}',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
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
                  child: SizedBox(height: 16),
                ),

                // Vol direct toggle + Filter buttons
                SliverToBoxAdapter(
                  child: FilterSection(
                    ctrl: _ctrl,
                    isSmallScreen: isSmallScreen,
                    isMediumScreen: isMediumScreen,
                    onFilterTap: () => showFilterBottomSheet(context, _ctrl),
                    onSortTap: () => showSortBottomSheet(context, _ctrl),
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

                // Bottom spacing
                const SliverToBoxAdapter(
                  child: SizedBox(height: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
