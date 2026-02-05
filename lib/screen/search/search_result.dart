import 'dart:convert';

import 'package:flight_booking/Model/Airport.dart';
import 'package:flight_booking/Model/FakeFlight.dart';
import 'package:flight_booking/models/flight_offer.dart';
import 'package:flight_booking/models/flight_results_request.dart';
import 'package:flight_booking/screen/search/flight_details.dart';
import 'package:flight_booking/screen/widgets/constant.dart';
import 'package:flight_booking/services/flight_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../generated/l10n.dart' as lang;
import '../../controllers/flight_controller.dart';
import '../../models/flight_bound.dart';
import '../widgets/orange_dots_loader.dart';
import '../widgets/button_global.dart';
import '../widgets/EditSearchBottomSheet.dart';
import '../widgets/flight_search_loading.dart';
import 'filter.dart';

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
  bool isDirectOnly = false;
  List<FakeFlight> flights = [];
  List<FlightOffer> apiFlights = [];
  Set<int> expandedOutbound = {};
  Set<int> expandedReturn = {};
  // For multi-destination: Map of offerIndex -> Set of expanded journey indices
  Map<int, Set<int>> expandedJourneys = {};
  String selectedSortOption = 'Le moins cher';

  // Filter options
  int selectedFilterCategory = 2; // 0: Compagnies, 1: Prix, 2: Escale, 3: Aéroport
  int selectedFilterTab = 0; // 0: Aller, 1: Retour
  String selectedEscaleOption = 'Tous';

  // Airline filter - null means show all (for quick chips)
  String? selectedAirlineCode;

  // Filter dialog selections
  Set<String> selectedFilterAirlineCodes = {};  // Airlines selected in filter dialog
  Set<String> selectedDepartureAirportCodes = {};  // Departure airports selected in filter
  Set<String> selectedArrivalAirportCodes = {};  // Arrival airports selected in filter

  // API Pagination state
  int _currentPage = 1;
  int? _totalPages;
  bool _isLoadingMore = false;
  bool _hasMorePages = true;
  final ScrollController _scrollController = ScrollController();

  // Responsive breakpoints
  bool get isSmallScreen => MediaQuery.of(context).size.width < 360;
  bool get isMediumScreen => MediaQuery.of(context).size.width < 400;
  double get screenWidth => MediaQuery.of(context).size.width;

  // Flight controller for new searches
  final FlightController _flightController = FlightController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.flightOffers != null && widget.flightOffers!.isNotEmpty) {
        // Use API flight offers
        setState(() {
          apiFlights = widget.flightOffers!;

          // Determine if there are more pages based on total offers
          // API returns 15 items per page by default
          const int perPage = 15;
          final int currentCount = apiFlights.length;
          final int total = widget.totalOffers ?? currentCount;

          // If we have a total and current count is less, there are more pages
          _hasMorePages = widget.searchCode != null && currentCount < total;

          // Calculate total pages if we have total
          if (widget.totalOffers != null && widget.totalOffers! > 0) {
            _totalPages = (widget.totalOffers! / perPage).ceil();
          }

          debugPrint('Pagination initialized: currentCount=$currentCount, total=$total, hasMorePages=$_hasMorePages, totalPages=$_totalPages');
        });
      } else {
        // Fall back to fake data
        _loadFakeFlightsFromAirports();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
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
                  departureDate: _formatDateForApi(departureDate!),
                ));

                // Additional legs
                for (final leg in multiDestinationLegs) {
                  if (leg.fromAirport != null && leg.toAirport != null && leg.departureDate != null) {
                    bounds.add(FlightBound(
                      origin: leg.fromAirport!.code,
                      destination: leg.toAirport!.code,
                      departureDate: _formatDateForApi(leg.departureDate!),
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

  // Format date to API format (YYYY-MM-DD)
  String _formatDateForApi(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreItems();
    }
  }

  Future<void> _loadMoreItems() async {
    // If no searchCode, can't use API pagination
    debugPrint('_loadMoreItems called: searchCode=${widget.searchCode}, hasMorePages=$_hasMorePages, isLoadingMore=$_isLoadingMore');

    if (widget.searchCode == null || !_hasMorePages || _isLoadingMore) {
      debugPrint('_loadMoreItems skipped: searchCode=${widget.searchCode}, hasMorePages=$_hasMorePages, isLoadingMore=$_isLoadingMore');
      return;
    }

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final request = FlightResultsRequest(
        searchCode: widget.searchCode!,
        page: _currentPage + 1,
        airline: selectedAirlineCode,
      );

      debugPrint('Calling FlightService.getResults with page=${_currentPage + 1}');
      final response = await FlightService.getResults(request);

      if (mounted) {
        setState(() {
          final previousCount = apiFlights.length;
          // Append new offers to existing list
          apiFlights.addAll(response.offers);
          _currentPage = response.currentPage ?? (_currentPage + 1);
          _totalPages = response.totalPages;
          _hasMorePages = response.totalPages != null && _currentPage < response.totalPages!;
          _isLoadingMore = false;

          debugPrint('Loaded ${response.offers.length} new offers. Total: $previousCount -> ${apiFlights.length}. Page: $_currentPage/$_totalPages, hasMore: $_hasMorePages');
        });
      }
    } catch (e) {
      debugPrint('Error loading more flights: $e');
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
      }
    }
  }

  // Reset pagination when filters change
  void _resetPagination() {
    setState(() {
      _currentPage = 1;
      _hasMorePages = true;
      _totalPages = null;
    });
  }

  // Reload flights from API with current filters (page 1)
  Future<void> _reloadFlightsWithFilters() async {
    if (widget.searchCode == null) return;

    setState(() {
      _isLoadingMore = true;
      apiFlights.clear();
      _currentPage = 1;
    });

    try {
      final request = FlightResultsRequest(
        searchCode: widget.searchCode!,
        page: 1,
        airline: selectedAirlineCode,
      );

      final response = await FlightService.getResults(request);

      if (mounted) {
        setState(() {
          apiFlights = response.offers;
          _currentPage = response.currentPage ?? 1;
          _totalPages = response.totalPages;
          _hasMorePages = response.totalPages != null && _currentPage < response.totalPages!;
          _isLoadingMore = false;
        });
      }
    } catch (e) {
      debugPrint('Error reloading flights: $e');
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
      }
    }
  }

  // Build paginated API flights list as slivers
  List<Widget> _buildPaginatedApiFlightsList(String fromCode, String toCode) {
    final allFilteredFlights = filteredApiFlights;

    // Show empty state if filters return no results
    if (allFilteredFlights.isEmpty && (selectedAirlineCode != null || isDirectOnly)) {
      return [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    isDirectOnly ? Icons.flight : Icons.filter_alt_off,
                    size: 64,
                    color: kSubTitleColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isDirectOnly && selectedAirlineCode == null
                        ? 'Aucun vol direct disponible'
                        : isDirectOnly
                            ? 'Aucun vol direct pour cette compagnie'
                            : 'Aucun vol pour cette compagnie',
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
                      setState(() {
                        if (isDirectOnly) isDirectOnly = false;
                        if (selectedAirlineCode != null) selectedAirlineCode = null;
                      });
                      _resetPagination();
                    },
                    child: Text(
                      'Afficher tous les vols',
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
              child: _buildApiFlightCard(offer, i, fromCode, toCode),
            );
          },
          childCount: allFilteredFlights.length,
        ),
      ),
      // Loading indicator or "Load more" area
      if (_hasMorePages || _isLoadingMore)
        SliverToBoxAdapter(
          child: _isLoadingMore
              ? const PaginationLoader(message: 'Chargement des vols...')
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Text(
                      _totalPages != null
                          ? 'Page $_currentPage / $_totalPages - Faites défiler pour plus'
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

  bool get hasApiFlights => apiFlights.isNotEmpty;

  Future<void> _loadFakeFlightsFromAirports() async {
    final data = await DefaultAssetBundle.of(context)
        .loadString('assets/data/airports.json');

    final List decoded = json.decode(data);
    final airports = decoded.map((e) => Airport.fromJson(e)).toList();

    final fromCode = widget.fromAirport.code;

    final results = airports.where((a) => a.code != fromCode).take(10).map((a) {
      return FakeFlight(
        airline: 'Turkish airline',
        departureTime: '17.35',
        arrivalTime: '17.35',
        duration: '2 h 35 min.',
        stops: 0,
        price: 16316 + (a.code.codeUnitAt(0) * 10),
        oldPrice: 18000 + (a.code.codeUnitAt(1) * 10),
      );
    }).toList();

    setState(() {
      flights = results;
    });
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('d MMM').format(date);
  }

  String _formatFlightDate(DateTime? date) {
    if (date == null) return '29 Jan 26';
    return DateFormat('d MMM yy').format(date);
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
          _buildHeader(fromCity, toCity, totalPassengers),

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
                  child: _buildFilterSection(),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: 12),
                ),

                // Price filter chips
                SliverToBoxAdapter(
                  child: _buildPriceChips(),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: 28),
                ),

                // Flight cards with pagination
                if (hasApiFlights)
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
                        final f = flights[i];
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 10 : 16),
                          child: _buildFlightCard(f, i, fromCode, toCode),
                        );
                      },
                      childCount: flights.length,
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

  Widget _buildHeader(String fromCity, String toCity, int totalPassengers) {
    final startDate = _formatDate(widget.dateRange?.start);
    final endDate = _formatDate(widget.dateRange?.end);
    final statusBarHeight = MediaQuery.of(context).padding.top;

    // Responsive values
    final horizontalPadding = isSmallScreen ? 10.0 : 16.0;
    final containerPadding = isSmallScreen ? 8.0 : 12.0;
    final titleFontSize = isSmallScreen ? 13.0 : (isMediumScreen ? 14.0 : 16.0);
    final subTitleFontSize = isSmallScreen ? 10.0 : 12.0;
    final iconSize = isSmallScreen ? 20.0 : 24.0;
    final smallIconSize = isSmallScreen ? 12.0 : 14.0;

    return Container(
      decoration: const BoxDecoration(
        color: Color.fromRGBO(255, 81, 0, 1),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        child: Stack(
          children: [
            // Background image on top of gradient
            Positioned.fill(
              child: Image.asset(
                'assets/backgroundAppBar.png',
                fit: BoxFit.cover,
              ),
            ),
          // Main content
          Padding(
            padding: EdgeInsets.only(
              top: statusBarHeight + 16,
              left: horizontalPadding,
              right: horizontalPadding,
              bottom: 20,
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: containerPadding, vertical: containerPadding),
              decoration: BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Back button
                  SmallTapEffect(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back, color: kTitleColor, size: iconSize),
                  ),
                  SizedBox(width: isSmallScreen ? 8 : 12),

                  // Route info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              flex: 1,
                              child: Text(
                                fromCity,
                                style: kTextStyle.copyWith(
                                  color: kTitleColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: titleFontSize,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: isSmallScreen ? 4 : 6),
                            Text(
                              '⇆',
                              style: kTextStyle.copyWith(
                                color: kTitleColor,
                                fontWeight: FontWeight.bold,
                                fontSize: titleFontSize,
                              ),
                            ),
                            SizedBox(width: isSmallScreen ? 4 : 6),
                            Flexible(
                              flex: 1,
                              child: Text(
                                toCity,
                                style: kTextStyle.copyWith(
                                  color: kTitleColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: titleFontSize,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        // Use Wrap for small screens to allow text to flow
                        isSmallScreen
                            ? Wrap(
                                spacing: 4,
                                runSpacing: 2,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    '$startDate - $endDate',
                                    style: kTextStyle.copyWith(
                                      color: kTitleColor,
                                      fontSize: subTitleFontSize,
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.person_outline,
                                          color: kTitleColor.withOpacity(0.8), size: smallIconSize),
                                      const SizedBox(width: 2),
                                      Text(
                                        '$totalPassengers',
                                        style: kTextStyle.copyWith(
                                          color: kTitleColor,
                                          fontSize: subTitleFontSize,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      '$startDate à $endDate',
                                      style: kTextStyle.copyWith(
                                        color: kTitleColor,
                                        fontSize: subTitleFontSize,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    ' · ',
                                    style: kTextStyle.copyWith(
                                      color: kTitleColor,
                                      fontSize: subTitleFontSize,
                                    ),
                                  ),
                                  Icon(Icons.person_outline,
                                      color: kTitleColor.withOpacity(0.8), size: smallIconSize),
                                  const SizedBox(width: 2),
                                  Text(
                                    '$totalPassengers',
                                    style: kTextStyle.copyWith(
                                      color: kTitleColor,
                                      fontSize: subTitleFontSize,
                                    ),
                                  ),
                                  Text(
                                    ' · ',
                                    style: kTextStyle.copyWith(
                                      color: kTitleColor,
                                      fontSize: subTitleFontSize,
                                    ),
                                  ),
                                  Icon(Icons.luggage_outlined,
                                      color: kTitleColor.withOpacity(0.8), size: smallIconSize),
                                  const SizedBox(width: 2),
                                  Text(
                                    '${widget.infantCount}',
                                    style: kTextStyle.copyWith(
                                      color: kSubTitleColor,
                                      fontSize: subTitleFontSize,
                                    ),
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),

                  // Edit button - shows bottom sheet to modify search parameters
                  SmallTapEffect(
                    onTap: _showEditSearchBottomSheet,
                    child: Container(
                      padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
                      decoration: BoxDecoration(
                        color: kWhite.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.asset(
                        'assets/editer 1.png',
                        width: isSmallScreen ? 16 : 20,
                        height: isSmallScreen ? 16 : 20,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.edit,
                            color: kWhite,
                            size: isSmallScreen ? 16 : 20,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildFilterSection() {
    // Responsive values
    final horizontalPadding = isSmallScreen ? 10.0 : 16.0;
    final buttonPaddingH = isSmallScreen ? 8.0 : 14.0;
    final buttonPaddingV = isSmallScreen ? 6.0 : 8.0;
    final fontSize = isSmallScreen ? 12.0 : 14.0;
    final iconSize = isSmallScreen ? 14.0 : 18.0;
    final buttonSpacing = isSmallScreen ? 6.0 : 10.0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: isSmallScreen
          // Compact layout for small screens
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Vol direct toggle with count
                Row(
                  children: [
                    Text(
                      'Vol direct',
                      style: kTextStyle.copyWith(
                        color: kTitleColor,
                        fontSize: fontSize,
                      ),
                    ),
                    if (hasApiFlights && directFlightsCount > 0) ...[
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: kPrimaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$directFlightsCount',
                          style: kTextStyle.copyWith(
                            color: kPrimaryColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(width: 4),
                    SizedBox(
                      height: 22,
                      child: Switch(
                        value: isDirectOnly,
                        onChanged: directFlightsCount > 0
                            ? (val) {
                                setState(() => isDirectOnly = val);
                                _resetPagination();
                              }
                            : null,
                        activeColor: kPrimaryColor,
                        activeTrackColor: kPrimaryColor.withOpacity(0.3),
                        inactiveThumbColor: directFlightsCount > 0 ? kWhite : kSubTitleColor,
                        inactiveTrackColor: const Color(0xFFE0E0E0),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                      ),
                    ),
                    const Spacer(),
                    // Filter and Sort buttons in a row
                    _buildCompactFilterButton(buttonPaddingH, buttonPaddingV, fontSize, iconSize),
                    SizedBox(width: buttonSpacing),
                    _buildCompactSortButton(buttonPaddingH, buttonPaddingV, fontSize, iconSize),
                  ],
                ),
              ],
            )
          // Normal layout for medium and large screens - wrapped in scroll view to prevent overflow
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  // Vol direct toggle with count
                  Text(
                    'Vol direct',
                    style: kTextStyle.copyWith(
                      color: kTitleColor,
                      fontSize: fontSize,
                    ),
                  ),
                  if (hasApiFlights && directFlightsCount > 0) ...[
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: kPrimaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$directFlightsCount',
                        style: kTextStyle.copyWith(
                          color: kPrimaryColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(width: 4),
                  SizedBox(
                    height: 24,
                    child: Switch(
                      value: isDirectOnly,
                      onChanged: directFlightsCount > 0
                          ? (val) {
                              setState(() => isDirectOnly = val);
                              _resetPagination();
                            }
                          : null,
                      activeColor: kPrimaryColor,
                      activeTrackColor: kPrimaryColor.withOpacity(0.3),
                      inactiveThumbColor: directFlightsCount > 0 ? kWhite : kSubTitleColor,
                      inactiveTrackColor: const Color(0xFFE0E0E0),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                    ),
                  ),

                  SizedBox(width: buttonSpacing * 2),

                  // Filtrer button
                  SmallTapEffect(
                    onTap: () => _showFilterBottomSheet(),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: buttonPaddingH, vertical: buttonPaddingV),
                      decoration: BoxDecoration(
                        color: activeFilterCount > 0 ? kPrimaryColor.withOpacity(0.1) : kWhite,
                        border: Border.all(color: kPrimaryColor, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/filter.png',
                            width: iconSize,
                            height: iconSize,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.tune, color: kPrimaryColor, size: iconSize);
                            },
                        ),
                        SizedBox(width: isMediumScreen ? 4 : 8),
                        Text(
                          'Filtrer',
                          style: kTextStyle.copyWith(
                            color: kPrimaryColor,
                            fontSize: fontSize,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (activeFilterCount > 0) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '$activeFilterCount',
                              style: kTextStyle.copyWith(
                                color: kWhite,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                SizedBox(width: buttonSpacing),

                // Trier button
                SmallTapEffect(
                  onTap: () => _showSortBottomSheet(),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: buttonPaddingH, vertical: buttonPaddingV),
                    decoration: BoxDecoration(
                      color: kWhite,
                      border: Border.all(color: kPrimaryColor, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/trie.png',
                          width: iconSize,
                          height: iconSize,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.swap_vert, color: kPrimaryColor, size: iconSize);
                          },
                        ),
                        SizedBox(width: isMediumScreen ? 4 : 8),
                        Text(
                          _getSortDisplayText(selectedSortOption),
                          style: kTextStyle.copyWith(
                            color: kPrimaryColor,
                            fontSize: fontSize,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: kPrimaryColor,
                          size: iconSize,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  // Count of active filters from the filter dialog
  int get activeFilterCount {
    int count = 0;
    if (selectedFilterAirlineCodes.isNotEmpty) count++;
    if (selectedDepartureAirportCodes.isNotEmpty) count++;
    if (selectedArrivalAirportCodes.isNotEmpty) count++;
    if (selectedEscaleOption != 'Tous') count++;
    return count;
  }

  // Compact filter button for small screens
  Widget _buildCompactFilterButton(double paddingH, double paddingV, double fontSize, double iconSize) {
    final hasActiveFilters = activeFilterCount > 0;
    return SmallTapEffect(
      onTap: () => _showFilterBottomSheet(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
        decoration: BoxDecoration(
          color: hasActiveFilters ? kPrimaryColor.withOpacity(0.1) : kWhite,
          border: Border.all(color: kPrimaryColor, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.tune, color: kPrimaryColor, size: iconSize),
            const SizedBox(width: 4),
            Text(
              'Filtrer',
              style: kTextStyle.copyWith(
                color: kPrimaryColor,
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (hasActiveFilters) ...[
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$activeFilterCount',
                  style: kTextStyle.copyWith(
                    color: kWhite,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Compact sort button for small screens
  Widget _buildCompactSortButton(double paddingH, double paddingV, double fontSize, double iconSize) {
    return SmallTapEffect(
      onTap: () => _showSortBottomSheet(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
        decoration: BoxDecoration(
          color: kWhite,
          border: Border.all(color: kPrimaryColor, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.swap_vert, color: kPrimaryColor, size: iconSize),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down,
              color: kPrimaryColor,
              size: iconSize,
            ),
          ],
        ),
      ),
    );
  }

  void _showSortBottomSheet() {
    String tempSelectedOption = selectedSortOption;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: const BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Trier par',
                        style: GoogleFonts.poppins(
                          color: kTitleColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: kBorderColorTextField),
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 18,
                            color: kSubTitleColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Sort options
                  _buildSortOption(
                    'Le moins cher',
                    tempSelectedOption,
                    (value) {
                      setModalState(() => tempSelectedOption = value);
                    },
                  ),
                  _buildSortOption(
                    'Le plus cher',
                    tempSelectedOption,
                    (value) {
                      setModalState(() => tempSelectedOption = value);
                    },
                  ),
                  _buildSortOption(
                    'Heure de départ',
                    tempSelectedOption,
                    (value) {
                      setModalState(() => tempSelectedOption = value);
                    },
                  ),
                  _buildSortOption(
                    'Heure d\'arrivée',
                    tempSelectedOption,
                    (value) {
                      setModalState(() => tempSelectedOption = value);
                    },
                  ),
                  _buildSortOption(
                    'Durée du vol',
                    tempSelectedOption,
                    (value) {
                      setModalState(() => tempSelectedOption = value);
                    },
                  ),

                  const SizedBox(height: 24),

                  // Apply button
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedSortOption = tempSelectedOption;
                        _sortFlights(tempSelectedOption);
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'Appliquer',
                          style: GoogleFonts.poppins(
                            color: kWhite,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Sort flights based on selected option
  void _sortFlights(String sortOption) {
    if (!hasApiFlights) return;

    apiFlights.sort((a, b) {
      switch (sortOption) {
        case 'Le moins cher':
          return a.totalPrice.compareTo(b.totalPrice);

        case 'Le plus cher':
          return b.totalPrice.compareTo(a.totalPrice);

        case 'Heure de départ':
          final aDeparture = _getFlightDepartureDateTime(a);
          final bDeparture = _getFlightDepartureDateTime(b);
          if (aDeparture == null && bDeparture == null) return 0;
          if (aDeparture == null) return 1;
          if (bDeparture == null) return -1;
          return aDeparture.compareTo(bDeparture);

        case 'Heure d\'arrivée':
          final aArrival = _getFlightArrivalDateTime(a);
          final bArrival = _getFlightArrivalDateTime(b);
          if (aArrival == null && bArrival == null) return 0;
          if (aArrival == null) return 1;
          if (bArrival == null) return -1;
          return aArrival.compareTo(bArrival);

        case 'Durée du vol':
          final aDuration = _getFlightTotalDuration(a);
          final bDuration = _getFlightTotalDuration(b);
          return aDuration.compareTo(bDuration);

        default:
          return 0;
      }
    });
  }

  // Get departure datetime from first journey's first segment
  DateTime? _getFlightDepartureDateTime(FlightOffer offer) {
    if (offer.journey.isEmpty) return null;
    final firstJourney = offer.journey.first;
    if (firstJourney.flightSegments.isEmpty) return null;
    final firstSegment = firstJourney.flightSegments.first;
    final dateTimeStr = firstSegment.departureDateTime;
    if (dateTimeStr == null) return null;
    return DateTime.tryParse(dateTimeStr);
  }

  // Get arrival datetime from first journey's last segment
  DateTime? _getFlightArrivalDateTime(FlightOffer offer) {
    if (offer.journey.isEmpty) return null;
    final firstJourney = offer.journey.first;
    if (firstJourney.flightSegments.isEmpty) return null;
    final lastSegment = firstJourney.flightSegments.last;
    final dateTimeStr = lastSegment.arrivalDateTime;
    if (dateTimeStr == null) return null;
    return DateTime.tryParse(dateTimeStr);
  }

  // Get total flight duration in minutes
  int _getFlightTotalDuration(FlightOffer offer) {
    // Try to get from detail first
    if (offer.detail?.elapsedDurationTime != null) {
      return offer.detail!.elapsedDurationTime!;
    }

    // Calculate from journeys
    int totalMinutes = 0;
    for (final journey in offer.journey) {
      // Try flight info duration
      if (journey.flight?.flightInfo?.durationTime != null) {
        totalMinutes += journey.flight!.flightInfo!.durationTime!;
      } else {
        // Calculate from segments
        for (final segment in journey.flightSegments) {
          final durationStr = segment.duration;
          if (durationStr != null) {
            totalMinutes += _parseDurationToMinutes(durationStr);
          }
        }
      }
    }
    return totalMinutes;
  }

  // Parse duration string (e.g., "2h 30m" or "PT2H30M") to minutes
  int _parseDurationToMinutes(String duration) {
    // Handle ISO 8601 format (PT2H30M)
    if (duration.startsWith('PT')) {
      int minutes = 0;
      final hourMatch = RegExp(r'(\d+)H').firstMatch(duration);
      final minMatch = RegExp(r'(\d+)M').firstMatch(duration);
      if (hourMatch != null) {
        minutes += int.parse(hourMatch.group(1)!) * 60;
      }
      if (minMatch != null) {
        minutes += int.parse(minMatch.group(1)!);
      }
      return minutes;
    }

    // Handle simple format (2h 30m or 2:30)
    final parts = duration.replaceAll(RegExp(r'[^\d:]'), ' ').trim().split(RegExp(r'[\s:]+'));
    if (parts.length >= 2) {
      final hours = int.tryParse(parts[0]) ?? 0;
      final mins = int.tryParse(parts[1]) ?? 0;
      return hours * 60 + mins;
    }
    return 0;
  }

  // Get short display text for sort button
  String _getSortDisplayText(String sortOption) {
    switch (sortOption) {
      case 'Le moins cher':
        return 'Prix ↑';
      case 'Le plus cher':
        return 'Prix ↓';
      case 'Heure de départ':
        return 'Départ';
      case 'Heure d\'arrivée':
        return 'Arrivée';
      case 'Durée du vol':
        return 'Durée';
      default:
        return 'Trier';
    }
  }

  Widget _buildSortOption(String title, String selectedValue, Function(String) onChanged) {
    final isSelected = title == selectedValue;
    return GestureDetector(
      onTap: () => onChanged(title),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? kPrimaryColor : kBorderColorTextField,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: kPrimaryColor,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: GoogleFonts.poppins(
                color: kTitleColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Dynamic filter data - can be loaded from API/JSON
  // Dynamic filter data extracted from API flights
  Map<String, dynamic> get filterData {
    // Extract unique airlines from API flights
    final Map<String, Map<String, dynamic>> airlinesMap = {};
    double minPrice = double.infinity;
    double maxPrice = 0;
    final Map<String, Map<String, dynamic>> departureAirportsMap = {};
    final Map<String, Map<String, dynamic>> arrivalAirportsMap = {};
    int maxStops = 0;

    if (hasApiFlights) {
      for (final offer in apiFlights) {
        // Get price range
        final price = offer.totalPrice;
        if (price < minPrice) minPrice = price;
        if (price > maxPrice) maxPrice = price;

        for (final journey in offer.journey) {
          // Track max stops
          final stops = journey.flight?.stopQuantity ?? (journey.flightSegments.length - 1);
          if (stops > maxStops) maxStops = stops;

          for (int i = 0; i < journey.flightSegments.length; i++) {
            final segment = journey.flightSegments[i];

            // Extract airline info
            final airlineCode = segment.operatingAirline ?? segment.marketingAirline;
            final airlineName = segment.operatingAirlineName ?? segment.marketingAirlineName ?? 'Airline';
            if (airlineCode != null && airlineCode.isNotEmpty && !airlinesMap.containsKey(airlineCode)) {
              airlinesMap[airlineCode] = {
                'name': airlineName,
                'code': airlineCode,
                'logo': _getAirlineLogoUrl(airlineCode),
                'selected': selectedFilterAirlineCodes.contains(airlineCode.toUpperCase()),
              };
            }

            // Extract departure airports (first segment of first journey)
            if (i == 0) {
              final depCode = segment.departureAirportCode;
              final depDetails = segment.departureAirportDetails;
              if (depCode != null && !departureAirportsMap.containsKey(depCode)) {
                departureAirportsMap[depCode] = {
                  'name': depDetails?.name ?? depCode,
                  'code': depCode,
                  'city': depDetails?.city ?? '',
                  'selected': selectedDepartureAirportCodes.contains(depCode),
                };
              }
            }

            // Extract arrival airports (last segment of last journey)
            if (i == journey.flightSegments.length - 1) {
              final arrCode = segment.arrivalAirportCode;
              final arrDetails = segment.arrivalAirportDetails;
              if (arrCode != null && !arrivalAirportsMap.containsKey(arrCode)) {
                arrivalAirportsMap[arrCode] = {
                  'name': arrDetails?.name ?? arrCode,
                  'code': arrCode,
                  'city': arrDetails?.city ?? '',
                  'selected': selectedArrivalAirportCodes.contains(arrCode),
                };
              }
            }
          }
        }
      }
    }

    // Build escale options based on max stops found
    final List<String> escaleOptions = ['Tous', 'Direct'];
    if (maxStops >= 1) escaleOptions.add('Jusqu\'à 1 escale');
    if (maxStops >= 2) escaleOptions.add('Jusqu\'à 2 escales');

    // Get cities for departure/arrival sections
    final departureCity = departureAirportsMap.isNotEmpty
        ? (departureAirportsMap.values.first['city'] as String?) ?? widget.fromAirport.city
        : widget.fromAirport.city;
    final arrivalCity = arrivalAirportsMap.isNotEmpty
        ? (arrivalAirportsMap.values.first['city'] as String?) ?? widget.toAirport.city
        : widget.toAirport.city;

    return {
      'categories': ['Compagnies', 'Prix', 'Escale', 'Aéroport'],
      'compagnies': airlinesMap.values.toList(),
      'prix': {
        'min': minPrice == double.infinity ? 0 : minPrice,
        'max': maxPrice == 0 ? 50000 : maxPrice,
        'currency': apiFlights.isNotEmpty ? apiFlights.first.currency : 'DZD',
      },
      'escale': escaleOptions,
      'aeroports': {
        'depart': {
          'city': departureCity.split(',').first,
          'airports': departureAirportsMap.values.toList(),
        },
        'arrivee': {
          'city': arrivalCity.split(',').first,
          'airports': arrivalAirportsMap.values.toList(),
        },
      },
    };
  }

  void _showFilterBottomSheet() {
    int tempSelectedCategory = selectedFilterCategory;
    int tempSelectedTab = selectedFilterTab;
    String tempEscaleOption = selectedEscaleOption;

    // Create mutable copies of filter data
    List<Map<String, dynamic>> tempCompagnies = List.from(
      (filterData['compagnies'] as List).map((e) => Map<String, dynamic>.from(e)),
    );
    Map<String, dynamic> tempAeroports = {
      'depart': {
        'city': filterData['aeroports']['depart']['city'],
        'airports': List.from(
          (filterData['aeroports']['depart']['airports'] as List)
              .map((e) => Map<String, dynamic>.from(e)),
        ),
      },
      'arrivee': {
        'city': filterData['aeroports']['arrivee']['city'],
        'airports': List.from(
          (filterData['aeroports']['arrivee']['airports'] as List)
              .map((e) => Map<String, dynamic>.from(e)),
        ),
      },
    };

    final List<String> filterCategories = List<String>.from(filterData['categories']);
    final List<String> escaleOptions = List<String>.from(filterData['escale']);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            // Responsive values for bottom sheet
            final sheetWidth = MediaQuery.of(context).size.width;
            final isSheetSmall = sheetWidth < 360;
            final isSheetMedium = sheetWidth < 400;
            final menuWidth = isSheetSmall ? 85.0 : (isSheetMedium ? 95.0 : 110.0);
            final menuFontSize = isSheetSmall ? 10.0 : 12.0;
            final menuPaddingH = isSheetSmall ? 8.0 : 12.0;
            final menuPaddingV = isSheetSmall ? 10.0 : 14.0;
            final headerPadding = isSheetSmall ? 14.0 : 20.0;
            final headerFontSize = isSheetSmall ? 16.0 : 18.0;

            return Container(
              height: MediaQuery.of(context).size.height * 0.55,
              decoration: const BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: EdgeInsets.all(headerPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Filtrer',
                          style: GoogleFonts.poppins(
                            color: kTitleColor,
                            fontSize: headerFontSize,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: kBorderColorTextField),
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 18,
                              color: kSubTitleColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 1, color: kBorderColorTextField),

                  // Content
                  Expanded(
                    child: Row(
                      children: [
                        // Left side menu - auto-sized to fit longest text
                        IntrinsicWidth(
                          child: Container(
                            constraints: BoxConstraints(
                              minWidth: menuWidth,
                            ),
                            decoration: const BoxDecoration(
                              border: Border(
                                right: BorderSide(color: kBorderColorTextField),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(filterCategories.length, (index) {
                                final isSelected = tempSelectedCategory == index;
                                return GestureDetector(
                                  onTap: () {
                                    setModalState(() => tempSelectedCategory = index);
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: menuPaddingH,
                                      vertical: menuPaddingV,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected ? const Color(0xFFF5F5F5) : Colors.transparent,
                                    ),
                                    child: Text(
                                      filterCategories[index],
                                      style: GoogleFonts.poppins(
                                        color: isSelected ? kTitleColor : kSubTitleColor,
                                        fontSize: menuFontSize,
                                        fontWeight: FontWeight.w500,
                                        height: 30 / 12,
                                      ),
                                      softWrap: false,
                                      maxLines: 1,
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),

                        // Right side content
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Tabs: Aller / Retour
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setModalState(() => tempSelectedTab = 0);
                                      },
                                      child: Column(
                                        children: [
                                          Text(
                                            'Aller',
                                            style: GoogleFonts.poppins(
                                              color: tempSelectedTab == 0 ? kTitleColor : kSubTitleColor,
                                              fontSize: 14,
                                              fontWeight: tempSelectedTab == 0 ? FontWeight.w500 : FontWeight.w400,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Container(
                                            height: 2,
                                            width: 40,
                                            color: tempSelectedTab == 0 ? kPrimaryColor : Colors.transparent,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 24),
                                    GestureDetector(
                                      onTap: () {
                                        setModalState(() => tempSelectedTab = 1);
                                      },
                                      child: Column(
                                        children: [
                                          Text(
                                            'Retour',
                                            style: GoogleFonts.poppins(
                                              color: tempSelectedTab == 1 ? kTitleColor : kSubTitleColor,
                                              fontSize: 14,
                                              fontWeight: tempSelectedTab == 1 ? FontWeight.w500 : FontWeight.w400,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Container(
                                            height: 2,
                                            width: 50,
                                            color: tempSelectedTab == 1 ? kPrimaryColor : Colors.transparent,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                // Filter content based on selected category
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: _buildFilterContent(
                                      tempSelectedCategory,
                                      tempEscaleOption,
                                      escaleOptions,
                                      tempCompagnies,
                                      tempAeroports,
                                      (value) => setModalState(() => tempEscaleOption = value),
                                      (index, value) => setModalState(() {
                                        tempCompagnies[index]['selected'] = value;
                                      }),
                                      (type, index, value) => setModalState(() {
                                        tempAeroports[type]['airports'][index]['selected'] = value;
                                      }),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Bottom action bar
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: kWhite,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 16,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      top: false,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Reset button - only resets current filter category
                          GestureDetector(
                            onTap: () {
                              setModalState(() {
                                switch (tempSelectedCategory) {
                                  case 0: // Compagnies
                                    for (var c in tempCompagnies) {
                                      c['selected'] = false;
                                    }
                                    break;
                                  case 1: // Prix
                                    // Reset price range if implemented
                                    break;
                                  case 2: // Escale
                                    tempEscaleOption = 'Tous';
                                    break;
                                  case 3: // Aéroport
                                    for (var a in tempAeroports['depart']['airports']) {
                                      a['selected'] = false;
                                    }
                                    for (var a in tempAeroports['arrivee']['airports']) {
                                      a['selected'] = false;
                                    }
                                    break;
                                }
                              });
                            },
                            child: Container(
                              height: 30,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0F0F0),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  'Réinitialiser',
                                  style: GoogleFonts.poppins(
                                    color: kTitleColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Apply button
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedFilterCategory = tempSelectedCategory;
                                selectedFilterTab = tempSelectedTab;
                                selectedEscaleOption = tempEscaleOption;

                                // Save selected airlines from filter (uppercase for consistent comparison)
                                selectedFilterAirlineCodes = tempCompagnies
                                    .where((c) => c['selected'] == true)
                                    .map((c) => (c['code'] as String).toUpperCase())
                                    .toSet();

                                // Save selected departure airports
                                selectedDepartureAirportCodes = (tempAeroports['depart']['airports'] as List)
                                    .where((a) => a['selected'] == true)
                                    .map((a) => a['code'] as String)
                                    .toSet();

                                // Save selected arrival airports
                                selectedArrivalAirportCodes = (tempAeroports['arrivee']['airports'] as List)
                                    .where((a) => a['selected'] == true)
                                    .map((a) => a['code'] as String)
                                    .toSet();

                                // Clear the quick chip filter when applying dialog filters
                                if (selectedFilterAirlineCodes.isNotEmpty) {
                                  selectedAirlineCode = null;
                                }
                              });
                              _resetPagination();
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 126,
                              height: 30,
                              decoration: BoxDecoration(
                                color: kWhite,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: kPrimaryColor, width: 1.5),
                              ),
                              child: Center(
                                child: Text(
                                  'Appliquer',
                                  style: GoogleFonts.poppins(
                                    color: kPrimaryColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFilterContent(
    int category,
    String escaleOption,
    List<String> escaleOptions,
    List<Map<String, dynamic>> compagnies,
    Map<String, dynamic> aeroports,
    Function(String) onEscaleChanged,
    Function(int, bool) onCompagnieChanged,
    Function(String, int, bool) onAeroportChanged,
  ) {
    switch (category) {
      case 0: // Compagnies
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: compagnies.asMap().entries.map((entry) {
            final index = entry.key;
            final compagnie = entry.value;
            return _buildCompagnieOption(
              compagnie['name'],
              compagnie['logo'],
              compagnie['selected'],
              (value) => onCompagnieChanged(index, value),
            );
          }).toList(),
        );

      case 1: // Prix
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sélectionner une plage de prix',
              style: GoogleFonts.poppins(
                color: kSubTitleColor,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 16),
            // Price range slider would go here
            Text(
              '0 - 50 000 DZD',
              style: GoogleFonts.poppins(
                color: kTitleColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );

      case 2: // Escale
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: escaleOptions.map((option) {
            final isSelected = escaleOption == option;
            return _buildRadioOption(option, isSelected, () => onEscaleChanged(option));
          }).toList(),
        );

      case 3: // Aéroport
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Departure airports
            Text(
              'Départ de ${aeroports['depart']['city']}',
              style: GoogleFonts.poppins(
                color: kTitleColor,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            ...(aeroports['depart']['airports'] as List).asMap().entries.map((entry) {
              final index = entry.key;
              final airport = entry.value;
              return _buildCheckboxOption(
                airport['name'],
                airport['selected'],
                (value) => onAeroportChanged('depart', index, value),
              );
            }).toList(),

            const SizedBox(height: 16),

            // Arrival airports
            Text(
              'Arrivée à ${aeroports['arrivee']['city']}',
              style: GoogleFonts.poppins(
                color: kTitleColor,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            ...(aeroports['arrivee']['airports'] as List).asMap().entries.map((entry) {
              final index = entry.key;
              final airport = entry.value;
              return _buildCheckboxOption(
                airport['name'],
                airport['selected'],
                (value) => onAeroportChanged('arrivee', index, value),
              );
            }).toList(),
          ],
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildRadioOption(String title, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? kPrimaryColor : kBorderColorTextField,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: kPrimaryColor,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: GoogleFonts.poppins(
                color: kTitleColor,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckboxOption(String title, bool isSelected, Function(bool) onChanged) {
    return GestureDetector(
      onTap: () => onChanged(!isSelected),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isSelected ? kPrimaryColor : kBorderColorTextField,
                  width: 1.5,
                ),
                color: isSelected ? kPrimaryColor : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 14,
                      color: kWhite,
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  color: kTitleColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompagnieOption(String name, String logo, bool isSelected, Function(bool) onChanged) {
    return GestureDetector(
      onTap: () => onChanged(!isSelected),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            // Airline logo from network
            ClipOval(
              child: Image.network(
                logo,
                width: 40,
                height: 40,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: kPrimaryColor.withOpacity(0.1),
                    ),
                    child: Center(
                      child: Text(
                        name.isNotEmpty ? name[0].toUpperCase() : 'A',
                        style: GoogleFonts.poppins(
                          color: kPrimaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: kPrimaryColor.withOpacity(0.05),
                    ),
                    child: const Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: kPrimaryColor,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            // Airline name
            Expanded(
              child: Text(
                name,
                style: GoogleFonts.poppins(
                  color: kTitleColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  height: 30 / 12,
                ),
              ),
            ),
            // Checkbox
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isSelected ? kPrimaryColor : const Color(0xFFD0D0D0),
                  width: 1.5,
                ),
                color: isSelected ? kPrimaryColor : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: kWhite,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  // Extract unique airlines with their best prices from API flights
  List<Map<String, dynamic>> get filterChips {
    if (!hasApiFlights) {
      // Return empty list if no API data - chips won't show
      return [];
    }

    // Map to store airline code -> {name, bestPrice, code}
    final Map<String, Map<String, dynamic>> airlineData = {};

    for (final offer in apiFlights) {
      for (final journey in offer.journey) {
        for (final segment in journey.flightSegments) {
          final airlineCode = segment.operatingAirline ?? segment.marketingAirline;
          final airlineName = segment.operatingAirlineName ?? segment.marketingAirlineName ?? 'Airline';

          if (airlineCode != null && airlineCode.isNotEmpty) {
            final price = offer.totalPrice;

            if (!airlineData.containsKey(airlineCode)) {
              airlineData[airlineCode] = {
                'code': airlineCode,
                'name': airlineName,
                'bestPrice': price,
              };
            } else {
              // Update if this offer has a better price
              if (price < (airlineData[airlineCode]!['bestPrice'] as double)) {
                airlineData[airlineCode]!['bestPrice'] = price;
              }
            }
          }
        }
      }
    }

    // Convert to list of chips
    final chips = airlineData.values.map((data) {
      final code = data['code'] as String;
      final name = data['name'] as String;
      final price = data['bestPrice'] as double;

      return {
        'text': '${price.toInt()} DZD',
        'airlineName': name,
        'airlineCode': code,
        'type': 'price',
      };
    }).toList();

    // Sort by price (numeric comparison)
    chips.sort((a, b) {
      final priceA = int.tryParse((a['text'] as String).replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
      final priceB = int.tryParse((b['text'] as String).replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
      return priceA.compareTo(priceB);
    });

    return chips;
  }

  // Helper to get airline logo URL from API
  String _getAirlineLogoUrl(String airlineCode) {
    // Using pics.avs.io API for airline logos (works with any IATA code)
    // Alternative APIs:
    // - https://content.airhex.com/content/logos/airlines_{code}_50_50_s.png
    // - https://www.gstatic.com/flights/airline_logos/70px/{code}.png
    return 'https://pics.avs.io/70/70/${airlineCode.toUpperCase()}.png';
  }

  // Get filtered flights based on all filter options
  List<FlightOffer> get filteredApiFlights {
    List<FlightOffer> result = apiFlights;

    // Filter by direct flights if toggle is on or escale option is "Direct"
    if (isDirectOnly || selectedEscaleOption == 'Direct') {
      result = result.where((offer) => _isDirectFlight(offer)).toList();
    }

    // Filter by escale option (stops)
    if (selectedEscaleOption == 'Jusqu\'à 1 escale') {
      result = result.where((offer) => _getMaxStops(offer) <= 1).toList();
    } else if (selectedEscaleOption == 'Jusqu\'à 2 escales') {
      result = result.where((offer) => _getMaxStops(offer) <= 2).toList();
    }

    // Filter by quick chip airline selection
    if (selectedAirlineCode != null) {
      result = result.where((offer) {
        for (final journey in offer.journey) {
          for (final segment in journey.flightSegments) {
            final code = segment.operatingAirline ?? segment.marketingAirline;
            if (code?.toUpperCase() == selectedAirlineCode?.toUpperCase()) {
              return true;
            }
          }
        }
        return false;
      }).toList();
    }

    // Filter by airlines selected in filter dialog (Compagnies)
    if (selectedFilterAirlineCodes.isNotEmpty) {
      result = result.where((offer) {
        for (final journey in offer.journey) {
          for (final segment in journey.flightSegments) {
            final code = segment.operatingAirline ?? segment.marketingAirline;
            if (code != null && selectedFilterAirlineCodes.contains(code.toUpperCase())) {
              return true;
            }
          }
        }
        return false;
      }).toList();
    }

    // Filter by departure airports (Aéroport)
    if (selectedDepartureAirportCodes.isNotEmpty) {
      result = result.where((offer) {
        // Check the first segment of the first journey for departure
        if (offer.journey.isNotEmpty && offer.journey.first.flightSegments.isNotEmpty) {
          final depCode = offer.journey.first.flightSegments.first.departureAirportCode;
          return depCode != null && selectedDepartureAirportCodes.contains(depCode);
        }
        return false;
      }).toList();
    }

    // Filter by arrival airports (Aéroport)
    if (selectedArrivalAirportCodes.isNotEmpty) {
      result = result.where((offer) {
        // Check the last segment of the last journey for arrival
        if (offer.journey.isNotEmpty && offer.journey.last.flightSegments.isNotEmpty) {
          final arrCode = offer.journey.last.flightSegments.last.arrivalAirportCode;
          return arrCode != null && selectedArrivalAirportCodes.contains(arrCode);
        }
        return false;
      }).toList();
    }

    return result;
  }

  // Get the maximum number of stops in any journey of an offer
  int _getMaxStops(FlightOffer offer) {
    int maxStops = 0;
    for (final journey in offer.journey) {
      final stops = journey.flight?.stopQuantity ?? (journey.flightSegments.length - 1);
      if (stops > maxStops) maxStops = stops;
    }
    return maxStops;
  }

  // Check if a flight offer is direct (no stops)
  bool _isDirectFlight(FlightOffer offer) {
    for (final journey in offer.journey) {
      final stops = journey.flight?.stopQuantity ?? (journey.flightSegments.length - 1);
      if (stops > 0) {
        return false; // Has stops, not direct
      }
    }
    return true; // All journeys are direct
  }

  // Count of direct flights available
  int get directFlightsCount {
    return apiFlights.where((offer) => _isDirectFlight(offer)).length;
  }

  Widget _buildPriceChips() {
    final chips = filterChips;

    if (chips.isEmpty) {
      return const SizedBox.shrink();
    }

    // Responsive values
    final chipHeight = isSmallScreen ? 30.0 : 36.0;
    final chipPaddingH = isSmallScreen ? 10.0 : 16.0;
    final chipFontSize = isSmallScreen ? 12.0 : 14.0;
    final chipMargin = isSmallScreen ? 6.0 : 10.0;
    final logoSize = isSmallScreen ? 18.0 : 22.0;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 5 : 7),
      child: Row(
        children: [
          // "All" chip to clear filter
          SmallTapEffect(
            onTap: () {
              setState(() {
                selectedAirlineCode = null;
              });
              _resetPagination();
            },
            child: Container(
              height: chipHeight,
              margin: EdgeInsets.only(right: chipMargin),
              padding: EdgeInsets.symmetric(horizontal: chipPaddingH),
              decoration: BoxDecoration(
                color: selectedAirlineCode == null ? kPrimaryColor.withOpacity(0.1) : kWhite,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: selectedAirlineCode == null ? kPrimaryColor : kBorderColorTextField,
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  'Tous',
                  style: kTextStyle.copyWith(
                    color: selectedAirlineCode == null ? kPrimaryColor : kTitleColor,
                    fontSize: chipFontSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          // Airline chips
          ...chips.map((chip) {
            final airlineName = chip['airlineName'] as String? ?? '';
            final airlineCode = chip['airlineCode'] as String? ?? '';
            final isSelected = selectedAirlineCode == airlineCode;

            return SmallTapEffect(
              onTap: () {
                setState(() {
                  if (selectedAirlineCode == airlineCode) {
                    selectedAirlineCode = null;
                  } else {
                    selectedAirlineCode = airlineCode;
                  }
                });
                _resetPagination();
              },
              child: Tooltip(
                message: airlineName.isNotEmpty ? airlineName : airlineCode,
                child: Container(
                  height: chipHeight,
                  margin: EdgeInsets.only(right: chipMargin),
                  padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 8 : 12),
                  decoration: BoxDecoration(
                    color: isSelected ? kPrimaryColor.withOpacity(0.1) : kWhite,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? kPrimaryColor : kBorderColorTextField,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Airline logo from API
                      ClipOval(
                        child: Image.network(
                          _getAirlineLogoUrl(airlineCode),
                          width: logoSize,
                          height: logoSize,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: logoSize,
                              height: logoSize,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: kPrimaryColor.withOpacity(0.1),
                              ),
                              child: Center(
                                child: Text(
                                  airlineCode.isNotEmpty ? airlineCode : 'A',
                                  style: kTextStyle.copyWith(
                                    color: kPrimaryColor,
                                    fontSize: isSmallScreen ? 6 : 8,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              width: logoSize,
                              height: logoSize,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: kPrimaryColor.withOpacity(0.05),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(width: isSmallScreen ? 4 : 8),
                      // Price text
                      Text(
                        chip['text'],
                        style: kTextStyle.copyWith(
                          color: kTitleColor,
                          fontSize: chipFontSize,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  // Widget _buildPromoBanner() {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(horizontal: 16),
  //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  //     decoration: BoxDecoration(
  //       color: const Color(0xFFFFF3E0),
  //       borderRadius: BorderRadius.circular(8),
  //     ),
  //     child: Row(
  //       children: [
  //         const Icon(Icons.local_offer, color: kPrimaryColor, size: 20),
  //         const SizedBox(width: 8),
  //         Expanded(
  //           child: Text(
  //             'Trouvez les offres aux meilleurs prix!',
  //             style: kTextStyle.copyWith(
  //               color: kTitleColor,
  //               fontSize: 13,
  //               fontWeight: FontWeight.w500,
  //             ),
  //           ),
  //         ),
  //         Text(
  //           'Cliquez ici',
  //           style: kTextStyle.copyWith(
  //             color: kPrimaryColor,
  //             fontSize: 13,
  //             fontWeight: FontWeight.w600,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildFlightCard(
      FakeFlight f, int index, String fromCode, String toCode) {
    final flightNumber = 'TK ${123456 + index}';
    final outboundDate = _formatFlightDate(widget.dateRange?.start);
    final returnDate = _formatFlightDate(widget.dateRange?.end);
    final isOutboundExpanded = expandedOutbound.contains(index);
    final isReturnExpanded = expandedReturn.contains(index);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBorderColorTextField),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recommandé badge
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(221, 225, 255, 1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'Recommandé',
                style: kTextStyle.copyWith(
                  color: const Color.fromRGBO(147, 133, 245, 1),
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                // Outbound Flight
                _buildFlightSegment(
                  airlineLogo: 'assets/turkish_airlines.png',
                  airlineName: '${f.airline} $flightNumber',
                  departureDate: outboundDate,
                  arrivalDate: outboundDate,
                  departureTime: f.departureTime,
                  arrivalTime: f.arrivalTime,
                  fromCode: fromCode,
                  toCode: toCode,
                  duration: f.duration,
                  isDirect: f.stops == 0,
                  isExpanded: isOutboundExpanded,
                  onToggleExpand: () {
                    setState(() {
                      if (isOutboundExpanded) {
                        expandedOutbound.remove(index);
                      } else {
                        expandedOutbound.add(index);
                      }
                    });
                  },
                ),

                const SizedBox(height: 8),
                const Divider(height: 1, color: kBorderColorTextField),
                const SizedBox(height: 8),

                // Return Flight
                _buildFlightSegment(
                  airlineLogo: 'assets/turkish_airlines.png',
                  airlineName: '${f.airline} $flightNumber',
                  departureDate: returnDate,
                  arrivalDate: returnDate,
                  departureTime: f.departureTime,
                  arrivalTime: f.arrivalTime,
                  fromCode: toCode,
                  toCode: fromCode,
                  duration: f.duration,
                  isDirect: f.stops == 0,
                  isExpanded: isReturnExpanded,
                  onToggleExpand: () {
                    setState(() {
                      if (isReturnExpanded) {
                        expandedReturn.remove(index);
                      } else {
                        expandedReturn.add(index);
                      }
                    });
                  },
                ),

                const SizedBox(height: 12),

                // Price and Reserve button
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Price with dropdown



                    const SizedBox(width: 12),

                    // Reserve button
                    GestureDetector(
                      onTap: () => const FlightDetails().launch(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Réservez',
                          style: kTextStyle.copyWith(
                            color: kWhite,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Build flight card from API FlightOffer
  Widget _buildApiFlightCard(FlightOffer offer, int index, String fromCode, String toCode) {
    final isOutboundExpanded = expandedOutbound.contains(index);
    final isReturnExpanded = expandedReturn.contains(index);

    // Use convenience getters from FlightOffer
    final price = offer.totalPrice;
    final currency = offer.currency;
    final isRefundable = offer.isRefundable;
    final airlineName = offer.airlineName;
    final airlineCode = offer.airlineCode;

    // Get journey data safely
    final journeyList = offer.journey;
    final hasJourney = journeyList.isNotEmpty;
    final isMultiDestination = widget.isMultiDestination && journeyList.length > 2;

    // Baggage info
    final hasBaggage = offer.detail?.checkedBaggageIncluded ?? false;

    // For multi-destination, we'll build segments dynamically
    if (isMultiDestination) {
      return _buildMultiDestinationCard(
        offer: offer,
        index: index,
        hasBaggage: hasBaggage,
        isRefundable: isRefundable,
        price: price,
        currency: currency,
      );
    }

    // Original logic for one-way and round-trip
    // Outbound flight details
    String outboundAirline = airlineName;
    String outboundAirlineCode = airlineCode;
    String outboundFlightNumber = '';
    String outboundDepartureTime = '--:--';
    String outboundArrivalTime = '--:--';
    String outboundDuration = '--';
    int outboundStops = 0;
    String outboundFromCode = fromCode;
    String outboundToCode = toCode;
    List<FlightSegmentDetail> outboundSegments = [];

    if (hasJourney) {
      final outboundJourney = journeyList.first;
      final outboundFlight = outboundJourney.flight;
      outboundSegments = outboundJourney.flightSegments;

      if (outboundSegments.isNotEmpty) {
        final firstSegment = outboundSegments.first;
        final lastSegment = outboundSegments.last;

        outboundAirline = firstSegment.marketingAirlineName ?? airlineName;
        outboundAirlineCode = firstSegment.marketingAirline ?? airlineCode;
        outboundFlightNumber = firstSegment.flightNumber?.toString() ?? '';
        outboundDepartureTime = firstSegment.departureDateTime ?? '--:--';
        outboundArrivalTime = lastSegment.arrivalDateTime ?? '--:--';
        outboundFromCode = firstSegment.departureAirportCode ?? fromCode;
        outboundToCode = lastSegment.arrivalAirportCode ?? toCode;
      }

      outboundDuration = outboundFlight?.flightInfo?.duration ?? '--';
      outboundStops = outboundFlight?.stopQuantity ?? 0;
    }

    // Check for return journey (for round-trip)
    final hasReturnJourney = journeyList.length > 1 && !widget.isOneWay;

    String returnAirline = outboundAirline;
    String returnAirlineCode = outboundAirlineCode;
    String returnFlightNumber = '';
    String returnDepartureTime = '--:--';
    String returnArrivalTime = '--:--';
    String returnDuration = '--';
    int returnStops = 0;
    String returnFromCode = toCode;
    String returnToCode = fromCode;
    List<FlightSegmentDetail> returnSegments = [];

    if (hasReturnJourney) {
      final returnJourney = journeyList[1];
      final returnFlight = returnJourney.flight;
      returnSegments = returnJourney.flightSegments;

      if (returnSegments.isNotEmpty) {
        final returnFirstSegment = returnSegments.first;
        final returnLastSegment = returnSegments.last;

        returnAirline = returnFirstSegment.marketingAirlineName ?? outboundAirline;
        returnAirlineCode = returnFirstSegment.marketingAirline ?? outboundAirlineCode;
        returnFlightNumber = returnFirstSegment.flightNumber?.toString() ?? '';
        returnDepartureTime = returnFirstSegment.departureDateTime ?? '--:--';
        returnArrivalTime = returnLastSegment.arrivalDateTime ?? '--:--';
        returnFromCode = returnFirstSegment.departureAirportCode ?? toCode;
        returnToCode = returnLastSegment.arrivalAirportCode ?? fromCode;
      }

      returnDuration = returnFlight?.flightInfo?.duration ?? '--';
      returnStops = returnFlight?.stopQuantity ?? 0;
    }

    // Responsive values for card
    final cardPadding = isSmallScreen ? 8.0 : 12.0;
    final badgeFontSize = isSmallScreen ? 8.0 : 10.0;
    final badgeIconSize = isSmallScreen ? 12.0 : 14.0;
    final badgePaddingH = isSmallScreen ? 6.0 : 8.0;
    final badgePaddingV = isSmallScreen ? 3.0 : 4.0;

    return Container(
      margin: EdgeInsets.only(bottom: isSmallScreen ? 8 : 10),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBorderColorTextField),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recommandé badge
          if (index == 0)
            Padding(
              padding: EdgeInsets.only(left: cardPadding, top: isSmallScreen ? 8 : 10),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: badgePaddingH, vertical: badgePaddingV),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(221, 225, 255, 1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Recommandé',
                  style: kTextStyle.copyWith(
                    color: const Color.fromRGBO(147, 133, 245, 1),
                    fontSize: badgeFontSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

          Padding(
            padding: EdgeInsets.all(cardPadding),
            child: Column(
              children: [
                // Baggage and refund badges
                Wrap(
                  spacing: isSmallScreen ? 4 : 8,
                  runSpacing: 4,
                  children: [
                    if (hasBaggage == true)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: badgePaddingH, vertical: badgePaddingV),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.luggage, size: badgeIconSize, color: Colors.green[700]),
                            SizedBox(width: isSmallScreen ? 2 : 4),
                            Text(
                              isSmallScreen ? 'Bagages' : 'Bagages inclus',
                              style: kTextStyle.copyWith(
                                color: Colors.green[700],
                                fontSize: badgeFontSize,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (isRefundable == true)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: badgePaddingH, vertical: badgePaddingV),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle_outline, size: badgeIconSize, color: Colors.blue[700]),
                            SizedBox(width: isSmallScreen ? 2 : 4),
                            Text(
                              'Remboursable',
                              style: kTextStyle.copyWith(
                                color: Colors.blue[700],
                                fontSize: badgeFontSize,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                if (hasBaggage == true || isRefundable == true) SizedBox(height: isSmallScreen ? 8 : 10),

                // Outbound Flight Segment
                _buildFlightSegment(
                  airlineLogo: _getAirlineLogo(outboundAirlineCode),
                  airlineName: '$outboundAirline ${outboundAirlineCode}$outboundFlightNumber',
                  departureDate: _formatDateTimeString(outboundDepartureTime),
                  arrivalDate: _formatDateTimeString(outboundArrivalTime),
                  departureTime: _formatTimeFromDateTime(outboundDepartureTime),
                  arrivalTime: _formatTimeFromDateTime(outboundArrivalTime),
                  fromCode: outboundFromCode,
                  toCode: outboundToCode,
                  duration: outboundDuration,
                  isDirect: outboundStops == 0,
                  isExpanded: isOutboundExpanded,
                  onToggleExpand: () {
                    setState(() {
                      if (isOutboundExpanded) {
                        expandedOutbound.remove(index);
                      } else {
                        expandedOutbound.add(index);
                      }
                    });
                  },
                  stops: outboundStops,
                  segments: outboundSegments,
                ),

                // Return Flight Segment (for round-trip)
                if (hasReturnJourney) ...[
                  const SizedBox(height: 8),
                  const Divider(height: 1, color: kBorderColorTextField),
                  const SizedBox(height: 8),
                  _buildFlightSegment(
                    airlineLogo: _getAirlineLogo(returnAirlineCode),
                    airlineName: '$returnAirline ${returnAirlineCode}$returnFlightNumber',
                    departureDate: _formatDateTimeString(returnDepartureTime),
                    arrivalDate: _formatDateTimeString(returnArrivalTime),
                    departureTime: _formatTimeFromDateTime(returnDepartureTime),
                    arrivalTime: _formatTimeFromDateTime(returnArrivalTime),
                    fromCode: returnFromCode,
                    toCode: returnToCode,
                    duration: returnDuration,
                    isDirect: returnStops == 0,
                    isExpanded: isReturnExpanded,
                    onToggleExpand: () {
                      setState(() {
                        if (isReturnExpanded) {
                          expandedReturn.remove(index);
                        } else {
                          expandedReturn.add(index);
                        }
                      });
                    },
                    stops: returnStops,
                    segments: returnSegments,
                  ),
                ],

                SizedBox(height: isSmallScreen ? 8 : 12),

                // Price and Reserve button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Stops info
                    if (outboundStops > 0)
                      Flexible(
                        child: Text(
                          '$outboundStops escale${outboundStops > 1 ? 's' : ''}',
                          style: kTextStyle.copyWith(
                            color: kPrimaryColor,
                            fontSize: isSmallScreen ? 10 : 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    else
                      Flexible(
                        child: Text(
                          'Vol direct',
                          style: kTextStyle.copyWith(
                            color: Colors.green[700],
                            fontSize: isSmallScreen ? 10 : 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Price - clickable to show details
                        GestureDetector(
                          onTap: () => _showPriceDetailsBottomSheet(context, offer),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${price.toStringAsFixed(0)} $currency',
                                    style: GoogleFonts.poppins(
                                      color: kTitleColor,
                                      fontWeight: FontWeight.w800,
                                      fontSize: isSmallScreen ? 13 : 16,
                                      height: 24 / 16,
                                    ),
                                  ),
                                  Text(
                                    isSmallScreen ? '/pers.' : 'par personne',
                                    style: kTextStyle.copyWith(
                                      color: kSubTitleColor,
                                      fontSize: isSmallScreen ? 8 : 10,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 2),
                              Icon(Icons.keyboard_arrow_down, color: kTitleColor, size: isSmallScreen ? 14 : 18),
                            ],
                          ),
                        ),

                        SizedBox(width: isSmallScreen ? 6 : 12),

                        // Reserve button
                        GestureDetector(
                          onTap: () => const FlightDetails().launch(context),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isSmallScreen ? 12 : 20,
                              vertical: isSmallScreen ? 6 : 8,
                            ),
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              isSmallScreen ? 'Réserver' : 'Réservez',
                              style: kTextStyle.copyWith(
                                color: kWhite,
                                fontWeight: FontWeight.w600,
                                fontSize: isSmallScreen ? 11 : 13,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Build multi-destination flight card with all journeys
  Widget _buildMultiDestinationCard({
    required FlightOffer offer,
    required int index,
    required bool hasBaggage,
    required bool isRefundable,
    required double price,
    required String currency,
  }) {
    final journeyList = offer.journey;
    final airlineName = offer.airlineName;
    final airlineCode = offer.airlineCode;

    // Initialize expanded journeys set for this offer if not exists
    if (!expandedJourneys.containsKey(index)) {
      expandedJourneys[index] = {};
    }

    // Calculate total stops across all journeys
    int totalStops = 0;
    for (final journey in journeyList) {
      totalStops += journey.flight?.stopQuantity ?? 0;
    }

    // Responsive values for multi-destination card
    final cardPadding = isSmallScreen ? 8.0 : 12.0;
    final badgeFontSize = isSmallScreen ? 8.0 : 10.0;
    final badgeIconSize = isSmallScreen ? 12.0 : 14.0;
    final badgePaddingH = isSmallScreen ? 6.0 : 8.0;
    final badgePaddingV = isSmallScreen ? 3.0 : 4.0;

    return Container(
      margin: EdgeInsets.only(bottom: isSmallScreen ? 8 : 10),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBorderColorTextField),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recommandé badge
          if (index == 0)
            Padding(
              padding: EdgeInsets.only(left: cardPadding, top: isSmallScreen ? 8 : 10),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: badgePaddingH, vertical: badgePaddingV),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(221, 225, 255, 1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Recommandé',
                  style: kTextStyle.copyWith(
                    color: const Color.fromRGBO(147, 133, 245, 1),
                    fontSize: badgeFontSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

          // Multi-destination badge
          Padding(
            padding: EdgeInsets.only(left: cardPadding, top: index == 0 ? (isSmallScreen ? 4 : 6) : (isSmallScreen ? 8 : 10)),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: badgePaddingH, vertical: badgePaddingV),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                isSmallScreen
                    ? 'Multi-dest. (${journeyList.length})'
                    : 'Multi-destination (${journeyList.length} trajets)',
                style: kTextStyle.copyWith(
                  color: Colors.purple[700],
                  fontSize: badgeFontSize,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(cardPadding),
            child: Column(
              children: [
                // Baggage and refund badges
                Wrap(
                  spacing: isSmallScreen ? 4 : 8,
                  runSpacing: 4,
                  children: [
                    if (hasBaggage == true)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: badgePaddingH, vertical: badgePaddingV),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.luggage, size: badgeIconSize, color: Colors.green[700]),
                            SizedBox(width: isSmallScreen ? 2 : 4),
                            Text(
                              isSmallScreen ? 'Bagages' : 'Bagages inclus',
                              style: kTextStyle.copyWith(
                                color: Colors.green[700],
                                fontSize: badgeFontSize,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (isRefundable == true)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: badgePaddingH, vertical: badgePaddingV),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle_outline, size: badgeIconSize, color: Colors.blue[700]),
                            SizedBox(width: isSmallScreen ? 2 : 4),
                            Text(
                              'Remboursable',
                              style: kTextStyle.copyWith(
                                color: Colors.blue[700],
                                fontSize: badgeFontSize,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                if (hasBaggage == true || isRefundable == true) SizedBox(height: isSmallScreen ? 8 : 10),

                // Build all journey segments dynamically
                ...journeyList.asMap().entries.map((entry) {
                  final journeyIndex = entry.key;
                  final journey = entry.value;
                  final flight = journey.flight;
                  final segments = journey.flightSegments;

                  // Get journey details
                  String journeyAirline = airlineName;
                  String journeyAirlineCode = airlineCode;
                  String journeyFlightNumber = '';
                  String journeyDepartureTime = '--:--';
                  String journeyArrivalTime = '--:--';
                  String journeyFromCode = '--';
                  String journeyToCode = '--';

                  if (segments.isNotEmpty) {
                    final firstSegment = segments.first;
                    final lastSegment = segments.last;

                    journeyAirline = firstSegment.marketingAirlineName ?? airlineName;
                    journeyAirlineCode = firstSegment.marketingAirline ?? airlineCode;
                    journeyFlightNumber = firstSegment.flightNumber?.toString() ?? '';
                    journeyDepartureTime = firstSegment.departureDateTime ?? '--:--';
                    journeyArrivalTime = lastSegment.arrivalDateTime ?? '--:--';
                    journeyFromCode = firstSegment.departureAirportCode ?? '--';
                    journeyToCode = lastSegment.arrivalAirportCode ?? '--';
                  }

                  final journeyDuration = flight?.flightInfo?.duration ?? '--';
                  final journeyStops = flight?.stopQuantity ?? 0;
                  final isExpanded = expandedJourneys[index]?.contains(journeyIndex) ?? false;

                  return Column(
                    children: [
                      if (journeyIndex > 0) ...[
                        const SizedBox(height: 8),
                        const Divider(height: 1, color: kBorderColorTextField),
                        const SizedBox(height: 8),
                      ],
                      // Journey label
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Trajet ${journeyIndex + 1}',
                          style: kTextStyle.copyWith(
                            color: kPrimaryColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      _buildFlightSegment(
                        airlineLogo: _getAirlineLogo(journeyAirlineCode),
                        airlineName: '$journeyAirline ${journeyAirlineCode}$journeyFlightNumber',
                        departureDate: _formatDateTimeString(journeyDepartureTime),
                        arrivalDate: _formatDateTimeString(journeyArrivalTime),
                        departureTime: _formatTimeFromDateTime(journeyDepartureTime),
                        arrivalTime: _formatTimeFromDateTime(journeyArrivalTime),
                        fromCode: journeyFromCode,
                        toCode: journeyToCode,
                        duration: journeyDuration,
                        isDirect: journeyStops == 0,
                        isExpanded: isExpanded,
                        onToggleExpand: () {
                          setState(() {
                            if (isExpanded) {
                              expandedJourneys[index]?.remove(journeyIndex);
                            } else {
                              expandedJourneys[index]?.add(journeyIndex);
                            }
                          });
                        },
                        stops: journeyStops,
                        segments: segments,
                      ),
                    ],
                  );
                }).toList(),

                SizedBox(height: isSmallScreen ? 8 : 12),

                // Price and Reserve button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Stops info
                    if (totalStops > 0)
                      Flexible(
                        child: Text(
                          isSmallScreen
                              ? '$totalStops esc.'
                              : '$totalStops escale${totalStops > 1 ? 's' : ''} au total',
                          style: kTextStyle.copyWith(
                            color: kPrimaryColor,
                            fontSize: isSmallScreen ? 10 : 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    else
                      Flexible(
                        child: Text(
                          'Vols directs',
                          style: kTextStyle.copyWith(
                            color: Colors.green[700],
                            fontSize: isSmallScreen ? 10 : 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Price - clickable to show details
                        GestureDetector(
                          onTap: () => _showPriceDetailsBottomSheet(context, offer),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${price.toStringAsFixed(0)} $currency',
                                    style: GoogleFonts.poppins(
                                      color: kTitleColor,
                                      fontWeight: FontWeight.w800,
                                      fontSize: isSmallScreen ? 13 : 16,
                                      height: 24 / 16,
                                    ),
                                  ),
                                  Text(
                                    isSmallScreen ? '/pers.' : 'par personne',
                                    style: kTextStyle.copyWith(
                                      color: kSubTitleColor,
                                      fontSize: isSmallScreen ? 8 : 10,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 2),
                              Icon(Icons.keyboard_arrow_down, color: kTitleColor, size: isSmallScreen ? 14 : 18),
                            ],
                          ),
                        ),

                        SizedBox(width: isSmallScreen ? 6 : 12),

                        // Reserve button
                        GestureDetector(
                          onTap: () => const FlightDetails().launch(context),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isSmallScreen ? 12 : 20,
                              vertical: isSmallScreen ? 6 : 8,
                            ),
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              isSmallScreen ? 'Réserver' : 'Réservez',
                              style: kTextStyle.copyWith(
                                color: kWhite,
                                fontWeight: FontWeight.w600,
                                fontSize: isSmallScreen ? 11 : 13,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Format time string from API (handles various formats)
  String _formatTime(String? time) {
    if (time == null || time.isEmpty) return '--:--';
    // If already in HH:mm format, return as is
    if (time.contains(':') && time.length <= 5) return time;
    // Try to parse ISO datetime
    try {
      final dt = DateTime.parse(time);
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return time.length >= 5 ? time.substring(0, 5) : time;
    }
  }

  // Format time from ISO datetime string (e.g., "2026-03-10T07:00:00" -> "07:00")
  String _formatTimeFromDateTime(String? dateTime) {
    if (dateTime == null || dateTime.isEmpty) return '--:--';
    try {
      final dt = DateTime.parse(dateTime);
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      // Try to extract time from string like "07:00:00"
      if (dateTime.contains(':')) {
        final parts = dateTime.split(':');
        if (parts.length >= 2) {
          return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
        }
      }
      return '--:--';
    }
  }

  // Format date from ISO datetime string (e.g., "2026-03-10T07:00:00" -> "10 Mar")
  String _formatDateTimeString(String? dateTime) {
    if (dateTime == null || dateTime.isEmpty) return '';
    try {
      final dt = DateTime.parse(dateTime);
      final locale = Localizations.localeOf(context).languageCode;
      return DateFormat('dd MMM', locale).format(dt);
    } catch (_) {
      return '';
    }
  }

  // Get airline logo URL from API based on airline code
  String _getAirlineLogo(String airlineCode) {
    // Using pics.avs.io API for airline logos (works with any IATA code)
    return _getAirlineLogoUrl(airlineCode);
  }

  // Show baggage details bottom sheet
  void _showBaggageDetailsBottomSheet(BuildContext context, BaggageAllowance? baggage) {
    // Get baggage info
    String cabinBaggageText = 'Non inclus';
    String checkedBaggageText = 'Non inclus';

    if (baggage != null) {
      // Cabin baggage
      if (baggage.cabinBaggage.isNotEmpty) {
        final cabin = baggage.cabinBaggage.first;
        final paxType = _getPaxTypeDisplayName(cabin.paxType);
        final value = cabin.value ?? 0;
        final unit = cabin.unit ?? 'KG';
        cabinBaggageText = '$paxType: $value$unit';
      }

      // Checked baggage
      if (baggage.checkedInBaggage.isNotEmpty) {
        final checked = baggage.checkedInBaggage.first;
        final paxType = _getPaxTypeDisplayName(checked.paxType);
        final value = checked.value ?? 0;
        final unit = checked.unit ?? 'pièces';
        if (unit.toUpperCase() == 'PC' || unit.toUpperCase() == 'PIECE' || unit.toUpperCase() == 'PIECES') {
          checkedBaggageText = '$paxType: $value pièce${value > 1 ? 's' : ''}';
        } else {
          checkedBaggageText = '$paxType: $value$unit';
        }
      }
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Détails bagages',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF333333),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade200,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 18,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1, color: Color(0xFFE0E0E0)),
              const SizedBox(height: 16),

              // Checked baggage
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Bagages en soute:',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF666666),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    checkedBaggageText,
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF333333),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Cabin baggage
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Bagages à main:',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF666666),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    cabinBaggageText,
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF333333),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  // Get passenger type display name
  String _getPaxTypeDisplayName(String? paxType) {
    switch (paxType?.toUpperCase()) {
      case 'ADT':
        return 'Adulte';
      case 'CHD':
        return 'Enfant';
      case 'INF':
        return 'Bébé';
      default:
        return 'Adulte';
    }
  }

  // Show price details bottom sheet
  void _showPriceDetailsBottomSheet(BuildContext context, FlightOffer offer) {
    final fare = offer.fare;
    final isRefundable = offer.isRefundable;
    final currency = offer.currency;
    final totalFare = fare?.totalFare ?? 0;

    // Format number with spaces as thousand separator
    String formatPrice(double price) {
      final formatted = price.toStringAsFixed(0);
      final buffer = StringBuffer();
      int count = 0;
      for (int i = formatted.length - 1; i >= 0; i--) {
        buffer.write(formatted[i]);
        count++;
        if (count == 3 && i > 0) {
          buffer.write(' ');
          count = 0;
        }
      }
      return buffer.toString().split('').reversed.join();
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Détails prix',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF333333),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade200,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 18,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Refundable badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isRefundable
                      ? const Color(0xFFE8F5E9)
                      : const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isRefundable ? 'Remboursable' : 'Non remboursable',
                  style: GoogleFonts.poppins(
                    color: isRefundable
                        ? const Color(0xFF4CAF50)
                        : const Color(0xFFE53935),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Fare breakdown by passenger type
              if (fare != null && fare.fareBreakdown.isNotEmpty) ...[
                ...fare.fareBreakdown.map((breakdown) {
                  final paxType = _getPaxTypeDisplayName(breakdown.paxType);
                  final quantity = breakdown.effectiveQuantity > 0 ? breakdown.effectiveQuantity : 1;
                  final baseFare = breakdown.effectiveBaseFare;
                  final tax = breakdown.effectiveTotalTax;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Passenger count
                      Text(
                        '${quantity}x $paxType',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF333333),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Base fare
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Frais de base',
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF666666),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            '${formatPrice(baseFare)} $currency',
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF333333),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Taxes
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Taxes par ${paxType.toLowerCase()}',
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF666666),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            '${formatPrice(tax)} $currency',
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF333333),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                  );
                }).toList(),
              ] else ...[
                // Fallback if no fare breakdown
                Text(
                  '1x Adulte',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF333333),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Frais de base',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF666666),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      '${formatPrice(fare?.baseFare ?? totalFare)} $currency',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF333333),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Taxes par adulte',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF666666),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      '${formatPrice(fare?.totalTax ?? 0)} $currency',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF333333),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],

              const Divider(height: 1, color: Color(0xFFE0E0E0)),
              const SizedBox(height: 12),

              // Total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total TTC',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF333333),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${formatPrice(totalFare)} $currency',
                    style: GoogleFonts.poppins(
                      color: kPrimaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFlightSegment({
    required String airlineLogo,
    required String airlineName,
    required String departureDate,
    required String arrivalDate,
    required String departureTime,
    required String arrivalTime,
    required String fromCode,
    required String toCode,
    required String duration,
    required bool isDirect,
    required bool isExpanded,
    required VoidCallback onToggleExpand,
    int? stops,
    List<dynamic>? segments,
    BaggageAllowance? baggageAllowance,
  }) {
    // Colors from design
    const Color textGray = Color.fromRGBO(130, 130, 130, 1);
    const Color textBlack = Color.fromRGBO(51, 51, 51, 1);
    const Color textOrange = Color.fromRGBO(255, 87, 34, 1);
    const Color directGreen = Color.fromRGBO(76, 175, 80, 1);
    const Color detailsBlue = Color.fromRGBO(0, 118, 209, 1);

    // Responsive values
    final dateFontSize = isSmallScreen ? 9.0 : 11.0;
    final timeFontSize = isSmallScreen ? 12.0 : 14.0;
    final badgeFontSize = isSmallScreen ? 8.0 : 10.0;
    final badgePaddingH = isSmallScreen ? 6.0 : 10.0;
    final badgePaddingV = isSmallScreen ? 3.0 : 5.0;
    final airlineLogoSize = isSmallScreen ? 16.0 : 20.0;
    final baggageIconSize = isSmallScreen ? 12.0 : 16.0;
    final baggageFontSize = isSmallScreen ? 8.0 : 10.0;

    // Get baggage info from baggageAllowance or segments
    BaggageAllowance? baggage = baggageAllowance;
    String cabinWeight = '7Kg';
    String checkedWeight = '24Kg';

    if (baggage == null && segments != null && segments.isNotEmpty) {
      // Try to get baggage from first segment
      final firstSeg = segments.first;
      if (firstSeg is FlightSegmentDetail) {
        baggage = firstSeg.baggageAllowance;
      }
    }

    if (baggage != null) {
      if (baggage.cabinBaggage.isNotEmpty) {
        final cabin = baggage.cabinBaggage.first;
        cabinWeight = '${cabin.value ?? 7}${cabin.unit ?? 'Kg'}';
      }
      if (baggage.checkedInBaggage.isNotEmpty) {
        final checked = baggage.checkedInBaggage.first;
        final unit = checked.unit ?? 'Kg';
        if (unit.toUpperCase() == 'PC' || unit.toUpperCase() == 'PIECE' || unit.toUpperCase() == 'PIECES') {
          checkedWeight = '${checked.value ?? 1}PC';
        } else {
          checkedWeight = '${checked.value ?? 24}$unit';
        }
      }
    }
    const Color lineGray = Color.fromRGBO(200, 200, 200, 1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Airline info row
        Row(
          children: [
            ClipOval(
              child: Image.network(
                airlineLogo,
                height: airlineLogoSize,
                width: airlineLogoSize,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback to airline code initials if image fails to load
                  final code = airlineName.split(' ').length > 1
                      ? airlineName.split(' ')[1]
                      : airlineName.substring(0, 2);
                  return Container(
                    height: airlineLogoSize,
                    width: airlineLogoSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: kPrimaryColor.withOpacity(0.1),
                    ),
                    child: Center(
                      child: Text(
                        code.substring(0, code.length > 2 ? 2 : code.length),
                        style: GoogleFonts.poppins(
                          color: kPrimaryColor,
                          fontSize: isSmallScreen ? 6 : 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: airlineLogoSize,
                    width: airlineLogoSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: kPrimaryColor.withOpacity(0.1),
                    ),
                  );
                },
              ),
            ),
            SizedBox(width: isSmallScreen ? 4 : 8),
            Expanded(
              child: Text(
                airlineName,
                style: GoogleFonts.poppins(
                  color: textBlack,
                  fontWeight: FontWeight.w500,
                  fontSize: isSmallScreen ? 10 : 12,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),

        SizedBox(height: isSmallScreen ? 4 : 6),

        // Flight times row with connecting lines
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Departure column
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  departureDate,
                  style: GoogleFonts.poppins(
                    color: textGray,
                    fontSize: dateFontSize,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
                Text(
                  departureTime,
                  style: GoogleFonts.poppins(
                    color: textBlack,
                    fontWeight: FontWeight.w500,
                    fontSize: timeFontSize,
                    height: 1.4,
                  ),
                ),
                Text(
                  fromCode,
                  style: GoogleFonts.poppins(
                    color: textGray,
                    fontSize: dateFontSize,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ],
            ),

            // Left connecting line
            Expanded(
              child: Container(
                height: 1,
                color: lineGray,
                margin: EdgeInsets.only(left: isSmallScreen ? 3 : 6, right: 0),
              ),
            ),

            // Duration and Direct badge - centered
            Container(
              padding: EdgeInsets.symmetric(horizontal: badgePaddingH, vertical: badgePaddingV),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(241, 241, 241, 1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: isSmallScreen
                  // Compact badge for small screens
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          duration,
                          style: GoogleFonts.poppins(
                            color: textGray,
                            fontSize: badgeFontSize,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          isDirect ? 'Direct' : '${stops ?? 1} esc.',
                          style: GoogleFonts.poppins(
                            color: isDirect ? directGreen : textOrange,
                            fontSize: badgeFontSize,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )
                  : RichText(
                      text: TextSpan(
                        style: GoogleFonts.poppins(
                          color: textGray,
                          fontSize: badgeFontSize,
                          fontWeight: FontWeight.w400,
                        ),
                        children: [
                          TextSpan(text: '$duration . '),
                          TextSpan(
                            text: isDirect ? 'Direct' : '${stops ?? 1} escale',
                            style: GoogleFonts.poppins(
                              color: isDirect ? directGreen : textOrange,
                              fontSize: badgeFontSize,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),

            // Right connecting line
            Expanded(
              child: Container(
                height: 1,
                color: lineGray,
                margin: EdgeInsets.only(left: 0, right: isSmallScreen ? 3 : 6),
              ),
            ),

            // Arrival column
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  arrivalDate,
                  style: GoogleFonts.poppins(
                    color: textGray,
                    fontSize: dateFontSize,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
                Text(
                  arrivalTime,
                  style: GoogleFonts.poppins(
                    color: textBlack,
                    fontWeight: FontWeight.w500,
                    fontSize: timeFontSize,
                    height: 1.4,
                  ),
                ),
                Text(
                  toCode,
                  style: GoogleFonts.poppins(
                    color: textGray,
                    fontSize: dateFontSize,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ],
        ),

        SizedBox(height: isSmallScreen ? 4 : 6),

        // Baggage info and Details row
        Row(
          children: [
            // Baggage icons - clickable to show details
            Expanded(
              child: GestureDetector(
                onTap: () => _showBaggageDetailsBottomSheet(context, baggage),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/cabin_bag.png',
                      width: baggageIconSize,
                      height: baggageIconSize,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.work_outline, color: textGray, size: baggageIconSize - 2);
                      },
                    ),
                    SizedBox(width: isSmallScreen ? 2 : 3),
                    Text(
                      cabinWeight,
                      style: GoogleFonts.poppins(
                        color: textGray,
                        fontSize: baggageFontSize,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(width: isSmallScreen ? 4 : 8),
                    Image.asset(
                      'assets/luggage.png',
                      width: baggageIconSize,
                      height: baggageIconSize,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.luggage_outlined, color: textGray, size: baggageIconSize - 2);
                      },
                    ),
                    SizedBox(width: isSmallScreen ? 2 : 3),
                    Flexible(
                      child: Text(
                        checkedWeight,
                        style: GoogleFonts.poppins(
                          color: textGray,
                          fontSize: baggageFontSize,
                          fontWeight: FontWeight.w400,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Icon(Icons.keyboard_arrow_down, color: textGray, size: isSmallScreen ? 12 : 14),
                  ],
                ),
              ),
            ),

            // Details dropdown
            GestureDetector(
              onTap: onToggleExpand,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isSmallScreen ? 'Détails' : 'Détails vol',
                    style: GoogleFonts.poppins(
                      color: detailsBlue,
                      fontSize: baggageFontSize,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: detailsBlue,
                    size: isSmallScreen ? 12 : 14,
                  ),
                ],
              ),
            ),
          ],
        ),

        // Expanded details
        if (isExpanded) ...[
          SizedBox(height: isSmallScreen ? 6 : 8),
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
            decoration: BoxDecoration(
              color: kWebsiteGreyBg,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Informations du vol',
                  style: GoogleFonts.poppins(
                    color: textBlack,
                    fontWeight: FontWeight.w600,
                    fontSize: isSmallScreen ? 10 : 11,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 4 : 6),
                _buildDetailRow('Compagnie', airlineName.split(' ').first),
                _buildDetailRow('Numéro de vol', airlineName.split(' ').last),
                _buildDetailRow('Classe', 'Économique'),
                _buildDetailRow('Bagage cabine', '7 Kg inclus'),
                _buildDetailRow('Bagage soute', '24 Kg inclus'),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    final fontSize = isSmallScreen ? 9.0 : 10.0;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 1 : 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              style: kTextStyle.copyWith(
                color: kSubTitleColor,
                fontSize: fontSize,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              style: kTextStyle.copyWith(
                color: kTitleColor,
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for flowing wave patterns
class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..style = PaintingStyle.fill;

    // First wave
    final path1 = Path();
    path1.moveTo(0, size.height * 0.6);
    path1.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.75,
      size.width * 0.5,
      size.height * 0.6,
    );
    path1.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.45,
      size.width,
      size.height * 0.6,
    );
    path1.lineTo(size.width, size.height);
    path1.lineTo(0, size.height);
    path1.close();
    canvas.drawPath(path1, paint);

    // Second wave
    final paint2 = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    final path2 = Path();
    path2.moveTo(0, size.height * 0.7);
    path2.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.85,
      size.width * 0.6,
      size.height * 0.7,
    );
    path2.quadraticBezierTo(
      size.width * 0.85,
      size.height * 0.55,
      size.width,
      size.height * 0.75,
    );
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
