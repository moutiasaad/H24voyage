import 'package:flight_booking/Model/Airport.dart';
import 'package:flight_booking/models/flight_offer.dart';
import 'package:flight_booking/screen/widgets/constant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../controllers/flight_controller.dart';
import '../../controllers/search_result_controller.dart';
import '../../models/flight_bound.dart';
import '../widgets/orange_dots_loader.dart';
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
                );
              } else if (isOneWay) {
                await _flightController.searchOneWay(
                  fromAirport: fromAirport,
                  toAirport: toAirport,
                  departureDate: departureDate!,
                  adultCount: adultCount,
                  childCount: childCount,
                  infantCount: infantCount,
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
                );
              }
            },
            onSearchComplete: () {
              Navigator.pop(context); // Pop loading screen
              if (!_flightController.hasError) {
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
                      flightOffers: _flightController.offers,
                      isOneWay: isOneWay,
                      isMultiDestination: isMultiDestination,
                      searchCode: _flightController.searchCode,
                      totalOffers: _flightController.totalOffers,
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(_flightController.errorMessage ?? 'Erreur lors de la recherche'),
                  ),
                );
              }
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
        const SliverToBoxAdapter(
          child: PaginationLoader(message: 'Chargement des vols...'),
        ),
      ];
    }

    if (allFilteredFlights.isEmpty && _ctrl.hasActiveFilters) {
      return [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: Column(
                children: [
                  const Icon(
                    Icons.filter_alt_off,
                    size: 64,
                    color: kSubTitleColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Aucun vol ne correspond à vos filtres',
                    style: GoogleFonts.poppins(
                      color: kTitleColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      _ctrl.resetAllFilters();
                      _ctrl.reloadFlightsWithFilters();
                    },
                    child: Text(
                      'Réinitialiser les filtres',
                      style: GoogleFonts.poppins(
                        color: kPrimaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
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
              ? const PaginationLoader(message: 'Chargement des vols...')
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Text(
                      _ctrl.totalPages != null
                          ? 'Page ${_ctrl.currentPage} / ${_ctrl.totalPages} - Faites défiler pour plus'
                          : 'Faites défiler pour charger plus de vols',
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
                      padding: const EdgeInsets.all(32),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.flight_outlined, size: 64, color: kSubTitleColor),
                            const SizedBox(height: 16),
                            Text(
                              'Aucun vol trouvé',
                              style: GoogleFonts.poppins(
                                color: kTitleColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Essayez de modifier vos critères de recherche',
                              style: GoogleFonts.poppins(
                                color: kSubTitleColor,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
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
