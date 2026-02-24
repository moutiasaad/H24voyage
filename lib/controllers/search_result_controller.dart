import 'dart:convert';

import 'package:flight_booking/Model/Airport.dart';
import 'package:flight_booking/Model/FakeFlight.dart';
import 'package:flight_booking/models/flight_offer.dart';
import 'package:flight_booking/models/flight_search_response.dart';
import 'package:flight_booking/models/flight_results_request.dart';
import 'package:flight_booking/models/flight_results_response.dart';
import 'package:flight_booking/services/flight_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SearchResultController extends ChangeNotifier {
  // ── Constructor params (immutable config from widget) ──
  final String? searchCode;
  final Airport fromAirport;
  final Airport toAirport;
  final String locale;

  SearchResultController({
    this.searchCode,
    required this.fromAirport,
    required this.toAirport,
    this.locale = 'fr',
  });

  // ── Disposal safety ──
  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  // ═══════════════════════════════════════════════════════════
  //  STATE FIELDS (private) + GETTERS (public)
  // ═══════════════════════════════════════════════════════════

  // ── Core data ──
  List<FakeFlight> _flights = [];
  List<FakeFlight> get flights => _flights;

  List<FlightOffer> _apiFlights = [];
  List<FlightOffer> get apiFlights => _apiFlights;

  List<AirlineInfo> _apiAirlines = [];
  List<AirlineInfo> get apiAirlines => _apiAirlines;

  Set<int> _expandedOutbound = {};
  Set<int> get expandedOutbound => _expandedOutbound;

  Set<int> _expandedReturn = {};
  Set<int> get expandedReturn => _expandedReturn;

  Map<int, Set<int>> _expandedJourneys = {};
  Map<int, Set<int>> get expandedJourneys => _expandedJourneys;

  // ── Sort & filter state ──
  bool _isDirectOnly = false;
  bool get isDirectOnly => _isDirectOnly;

  String _selectedSortOption = 'cheapest';
  String get selectedSortOption => _selectedSortOption;

  int _selectedFilterCategory = 2;
  int get selectedFilterCategory => _selectedFilterCategory;

  int _selectedFilterTab = 0;
  int get selectedFilterTab => _selectedFilterTab;

  String _selectedEscaleOption = 'Tous';
  String get selectedEscaleOption => _selectedEscaleOption;

  String? _selectedAirlineCode;
  String? get selectedAirlineCode => _selectedAirlineCode;

  Set<String> _selectedFilterAirlineCodes = {};
  Set<String> get selectedFilterAirlineCodes => _selectedFilterAirlineCodes;

  Set<String> _selectedDepartureAirportCodes = {};
  Set<String> get selectedDepartureAirportCodes => _selectedDepartureAirportCodes;

  Set<String> _selectedArrivalAirportCodes = {};
  Set<String> get selectedArrivalAirportCodes => _selectedArrivalAirportCodes;

  RangeValues _selectedDepTimeRange = const RangeValues(0, 24);
  RangeValues get selectedDepTimeRange => _selectedDepTimeRange;

  RangeValues _selectedArrTimeRange = const RangeValues(0, 24);
  RangeValues get selectedArrTimeRange => _selectedArrTimeRange;

  RangeValues? _selectedPriceRange;
  RangeValues? get selectedPriceRange => _selectedPriceRange;

  RangeValues? _retourPriceRange;
  RangeValues? get retourPriceRange => _retourPriceRange;

  // ── Retour journey filter state ──
  String _retourEscaleOption = 'Tous';
  String get retourEscaleOption => _retourEscaleOption;

  Set<String> _retourAirlineCodes = {};
  Set<String> get retourAirlineCodes => _retourAirlineCodes;

  RangeValues _retourDepTimeRange = const RangeValues(0, 24);
  RangeValues get retourDepTimeRange => _retourDepTimeRange;

  RangeValues _retourArrTimeRange = const RangeValues(0, 24);
  RangeValues get retourArrTimeRange => _retourArrTimeRange;

  Set<String> _retourDepAirportCodes = {};
  Set<String> get retourDepAirportCodes => _retourDepAirportCodes;

  Set<String> _retourArrAirportCodes = {};
  Set<String> get retourArrAirportCodes => _retourArrAirportCodes;

  // ── Pagination state ──
  int _currentPage = 1;
  int get currentPage => _currentPage;

  int? _totalPages;
  int? get totalPages => _totalPages;

  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

  bool _isReloading = false;
  bool get isReloading => _isReloading;

  bool _hasMorePages = true;
  bool get hasMorePages => _hasMorePages;

  // ═══════════════════════════════════════════════════════════
  //  PUBLIC SETTERS / MUTATORS
  // ═══════════════════════════════════════════════════════════

  void setDirectOnly(bool value) {
    _isDirectOnly = value;
    notifyListeners();
  }

  void setSelectedAirlineCode(String? code) {
    _selectedAirlineCode = code;
    notifyListeners();
  }

  void setSelectedSortOption(String option) {
    _selectedSortOption = option;
    _sortFlights(option);
    notifyListeners();
  }

  void setSelectedFilterCategory(int category) {
    _selectedFilterCategory = category;
    notifyListeners();
  }

  void setSelectedFilterTab(int tab) {
    _selectedFilterTab = tab;
    notifyListeners();
  }

  void setSelectedEscaleOption(String option) {
    _selectedEscaleOption = option;
    notifyListeners();
  }

  void setSelectedFilterAirlineCodes(Set<String> codes) {
    _selectedFilterAirlineCodes = codes;
    notifyListeners();
  }

  void setSelectedDepartureAirportCodes(Set<String> codes) {
    _selectedDepartureAirportCodes = codes;
    notifyListeners();
  }

  void setSelectedArrivalAirportCodes(Set<String> codes) {
    _selectedArrivalAirportCodes = codes;
    notifyListeners();
  }

  void setSelectedDepTimeRange(RangeValues range) {
    _selectedDepTimeRange = range;
    notifyListeners();
  }

  void setSelectedArrTimeRange(RangeValues range) {
    _selectedArrTimeRange = range;
    notifyListeners();
  }

  void setSelectedPriceRange(RangeValues? range) {
    _selectedPriceRange = range;
    notifyListeners();
  }

  void setRetourPriceRange(RangeValues? range) {
    _retourPriceRange = range;
    notifyListeners();
  }

  void toggleExpandedOutbound(int index) {
    if (_expandedOutbound.contains(index)) {
      _expandedOutbound.remove(index);
    } else {
      _expandedOutbound.add(index);
    }
    notifyListeners();
  }

  void toggleExpandedReturn(int index) {
    if (_expandedReturn.contains(index)) {
      _expandedReturn.remove(index);
    } else {
      _expandedReturn.add(index);
    }
    notifyListeners();
  }

  void toggleExpandedJourney(int offerIndex, int journeyIndex) {
    _expandedJourneys[offerIndex] ??= {};
    if (_expandedJourneys[offerIndex]!.contains(journeyIndex)) {
      _expandedJourneys[offerIndex]!.remove(journeyIndex);
    } else {
      _expandedJourneys[offerIndex]!.add(journeyIndex);
    }
    notifyListeners();
  }

  /// Resets ALL filter state back to defaults.
  void resetAllFilters() {
    _isDirectOnly = false;
    _selectedAirlineCode = null;
    _selectedFilterCategory = 0;
    _selectedFilterTab = 0;
    _selectedFilterAirlineCodes = {};
    _selectedEscaleOption = 'Tous';
    _selectedDepartureAirportCodes = {};
    _selectedArrivalAirportCodes = {};
    _selectedDepTimeRange = const RangeValues(0, 24);
    _selectedArrTimeRange = const RangeValues(0, 24);
    _selectedPriceRange = null;
    _retourPriceRange = null;
    // Retour filters
    _retourEscaleOption = 'Tous';
    _retourAirlineCodes = {};
    _retourDepTimeRange = const RangeValues(0, 24);
    _retourArrTimeRange = const RangeValues(0, 24);
    _retourDepAirportCodes = {};
    _retourArrAirportCodes = {};
    notifyListeners();
  }

  /// Bulk-apply all filter dialog values at once, then reload from API.
  void applyFilters({
    required int filterCategory,
    required int filterTab,
    required String escaleOption,
    required Set<String> airlineCodes,
    required Set<String> departureAirportCodes,
    required Set<String> arrivalAirportCodes,
    required RangeValues depTimeRange,
    required RangeValues arrTimeRange,
    required RangeValues? priceRange,
    // Retour journey filters (optional, for round-trip)
    String? retourEscaleOption,
    Set<String>? retourAirlineCodes,
    Set<String>? retourDepartureAirportCodes,
    Set<String>? retourArrivalAirportCodes,
    RangeValues? retourDepTimeRange,
    RangeValues? retourArrTimeRange,
    RangeValues? retourPriceRange,
  }) {
    _selectedFilterCategory = filterCategory;
    _selectedFilterTab = filterTab;

    // Aller filters
    _selectedEscaleOption = escaleOption;
    _selectedFilterAirlineCodes = airlineCodes;
    _selectedDepartureAirportCodes = departureAirportCodes;
    _selectedArrivalAirportCodes = arrivalAirportCodes;
    _selectedDepTimeRange = depTimeRange;
    _selectedArrTimeRange = arrTimeRange;
    _selectedPriceRange = priceRange;
    _retourPriceRange = retourPriceRange;

    // Retour filters
    _retourEscaleOption = retourEscaleOption ?? 'Tous';
    _retourAirlineCodes = retourAirlineCodes ?? {};
    _retourDepTimeRange = retourDepTimeRange ?? const RangeValues(0, 24);
    _retourArrTimeRange = retourArrTimeRange ?? const RangeValues(0, 24);
    _retourDepAirportCodes = retourDepartureAirportCodes ?? {};
    _retourArrAirportCodes = retourArrivalAirportCodes ?? {};

    // Clear the quick chip filter when applying dialog airline filters
    if (_selectedFilterAirlineCodes.isNotEmpty || _retourAirlineCodes.isNotEmpty) {
      _selectedAirlineCode = null;
    }
    notifyListeners();
    reloadFlightsWithFilters();
  }

  /// Sets sort option, re-sorts, and reloads from API if price-based sort.
  void applySortAndReload(String option) {
    final oldSort = _selectedSortOption;
    _selectedSortOption = option;
    _sortFlights(option);
    notifyListeners();

    final isPriceSort = option == 'cheapest' || option == 'most_expensive';
    final wasOldPriceSort = oldSort == 'cheapest' || oldSort == 'most_expensive';
    if (isPriceSort || wasOldPriceSort) {
      reloadFlightsWithFilters();
    }
  }

  /// Selects a quick-chip airline and reloads from API.
  void selectAirlineChip(String? code) {
    if (_selectedAirlineCode == code) {
      _selectedAirlineCode = null;
    } else {
      _selectedAirlineCode = code;
    }
    notifyListeners();
    reloadFlightsWithFilters();
  }

  // ═══════════════════════════════════════════════════════════
  //  INITIALIZATION
  // ═══════════════════════════════════════════════════════════

  /// Called from widget initState after construction.
  void initialize({
    List<FlightOffer>? initialOffers,
    int? totalOffers,
    String? assetJsonData,
    List<AirlineInfo>? apiAirlines,
  }) {
    if (apiAirlines != null) {
      _apiAirlines = apiAirlines;
    }
    if (initialOffers != null && initialOffers.isNotEmpty) {
      _apiFlights = initialOffers;

      const int perPage = 15;
      final int currentCount = _apiFlights.length;
      final int total = totalOffers ?? 0;

      if (searchCode != null) {
        if (total > 0) {
          _hasMorePages = currentCount < total;
          _totalPages = (total / perPage).ceil();
        } else {
          _hasMorePages = currentCount >= perPage;
          _totalPages = null;
        }
      } else {
        _hasMorePages = false;
      }

      debugPrint(
        'Pagination initialized: currentCount=$currentCount, total=$total, '
        'hasMorePages=$_hasMorePages, totalPages=$_totalPages, searchCode=$searchCode',
      );
      notifyListeners();
    } else if (assetJsonData != null) {
      _loadFakeFlightsFromData(assetJsonData);
    }
  }

  // ═══════════════════════════════════════════════════════════
  //  API / PAGINATION
  // ═══════════════════════════════════════════════════════════

  /// Builds a [FlightResultsRequest] with all currently active filters applied.
  FlightResultsRequest buildFilteredRequest({required int page}) {
    String? airlineParam;
    // Combine airline codes from both Aller and Retour for API request
    final combinedAirlines = <String>{};
    combinedAirlines.addAll(_selectedFilterAirlineCodes);
    combinedAirlines.addAll(_retourAirlineCodes);
    if (combinedAirlines.isNotEmpty) {
      airlineParam = combinedAirlines.join(',');
    } else if (_selectedAirlineCode != null) {
      airlineParam = _selectedAirlineCode;
    }

    String? sortParam;
    switch (_selectedSortOption) {
      case 'cheapest':
        sortParam = 'P:asc';
        break;
      case 'most_expensive':
        sortParam = 'P:desc';
        break;
      default:
        sortParam = null;
    }

    return FlightResultsRequest(
      searchCode: searchCode!,
      page: page,
      airline: airlineParam,
      sort: sortParam,
      minPrice: _selectedPriceRange?.start,
      maxPrice: _selectedPriceRange?.end,
    );
  }

  /// Loads the next page of results from the API.
  Future<void> loadMoreItems() async {
    if (searchCode == null || !_hasMorePages || _isLoadingMore) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final request = buildFilteredRequest(page: _currentPage + 1);
      final response = await FlightService.getResults(request);

      if (!_disposed) {
        // Deduplicate
        final existingIds = _apiFlights
            .where((o) => o.offerId != null)
            .map((o) => o.offerId)
            .toSet();
        final newOffers = response.offers
            .where((o) => o.offerId == null || !existingIds.contains(o.offerId))
            .toList();
        _apiFlights.addAll(newOffers);

        _currentPage = response.currentPage ?? (_currentPage + 1);
        _totalPages = response.totalPages;
        _updateHasMorePages(response);
        _isLoadingMore = false;
        _sortFlights(_selectedSortOption);

        debugPrint(
          'Pagination loaded: page=$_currentPage, newOffers=${newOffers.length}, '
          'total=${_apiFlights.length}, hasMore=$_hasMorePages',
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading more flights: $e');
      if (!_disposed) {
        _isLoadingMore = false;
        notifyListeners();
      }
    }
  }

  /// Determines whether there are more pages to load.
  void _updateHasMorePages(FlightResultsResponse response) {
    if (response.totalPages != null) {
      _hasMorePages = _currentPage < response.totalPages!;
    } else if (response.total != null) {
      _hasMorePages = _apiFlights.length < response.total!;
    } else {
      final perPage = response.perPage ?? 15;
      _hasMorePages = response.offers.length >= perPage;
    }
  }

  /// Reloads flights from API with current filters (page 1).
  Future<void> reloadFlightsWithFilters() async {
    if (searchCode == null) return;

    _isReloading = true;
    _isLoadingMore = true;
    _apiFlights.clear();
    _currentPage = 1;
    _hasMorePages = true;
    _totalPages = null;
    notifyListeners();

    try {
      final request = buildFilteredRequest(page: 1);
      debugPrint('Reloading flights with filters: ${request.toQueryParams()}');
      final response = await FlightService.getResults(request);

      if (!_disposed) {
        _apiFlights = response.offers;
        _currentPage = response.currentPage ?? 1;
        _totalPages = response.totalPages;
        _updateHasMorePages(response);
        _isReloading = false;
        _isLoadingMore = false;
        _sortFlights(_selectedSortOption);

        debugPrint(
          'Reload complete: page=$_currentPage, offers=${_apiFlights.length}, '
          'hasMore=$_hasMorePages, totalPages=$_totalPages',
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error reloading flights: $e');
      if (!_disposed) {
        _isReloading = false;
        _isLoadingMore = false;
        notifyListeners();
      }
    }
  }

  // ═══════════════════════════════════════════════════════════
  //  SORTING
  // ═══════════════════════════════════════════════════════════

  void _sortFlights(String sortOption) {
    if (!hasApiFlights) return;

    _apiFlights.sort((a, b) {
      switch (sortOption) {
        case 'cheapest':
          return a.totalPrice.compareTo(b.totalPrice);
        case 'most_expensive':
          return b.totalPrice.compareTo(a.totalPrice);
        case 'departure_time':
          final aDep = getFlightDepartureDateTime(a);
          final bDep = getFlightDepartureDateTime(b);
          if (aDep == null && bDep == null) return 0;
          if (aDep == null) return 1;
          if (bDep == null) return -1;
          return aDep.compareTo(bDep);
        case 'arrival_time':
          final aArr = getFlightArrivalDateTime(a);
          final bArr = getFlightArrivalDateTime(b);
          if (aArr == null && bArr == null) return 0;
          if (aArr == null) return 1;
          if (bArr == null) return -1;
          return aArr.compareTo(bArr);
        case 'flight_duration':
          return getFlightTotalDuration(a).compareTo(getFlightTotalDuration(b));
        default:
          return 0;
      }
    });
  }

  // ═══════════════════════════════════════════════════════════
  //  FAKE DATA (fallback)
  // ═══════════════════════════════════════════════════════════

  void _loadFakeFlightsFromData(String jsonData) {
    final List decoded = json.decode(jsonData);
    final airports = decoded.map((e) => Airport.fromJson(e)).toList();
    final fromCode = fromAirport.code;

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

    _flights = results;
    notifyListeners();
  }

  // ═══════════════════════════════════════════════════════════
  //  COMPUTED GETTERS
  // ═══════════════════════════════════════════════════════════

  bool get hasApiFlights => _apiFlights.isNotEmpty;

  bool get isRoundTrip =>
      hasApiFlights && _apiFlights.any((o) => o.journey.length > 1);

  int get directFlightsCount =>
      _apiFlights.where((offer) => isDirectFlight(offer)).length;

  bool get _hasRetourFilters =>
      _retourEscaleOption != 'Tous' ||
      _retourAirlineCodes.isNotEmpty ||
      _retourDepAirportCodes.isNotEmpty ||
      _retourArrAirportCodes.isNotEmpty ||
      _retourPriceRange != null ||
      _retourDepTimeRange.start > 0 ||
      _retourDepTimeRange.end < 24 ||
      _retourArrTimeRange.start > 0 ||
      _retourArrTimeRange.end < 24;

  int get activeFilterCount {
    int count = 0;
    if (_selectedFilterAirlineCodes.isNotEmpty) count++;
    if (_selectedDepartureAirportCodes.isNotEmpty) count++;
    if (_selectedArrivalAirportCodes.isNotEmpty) count++;
    if (_selectedEscaleOption != 'Tous') count++;
    if (_selectedPriceRange != null) count++;
    if (_selectedDepTimeRange.start > 0 || _selectedDepTimeRange.end < 24) count++;
    if (_selectedArrTimeRange.start > 0 || _selectedArrTimeRange.end < 24) count++;
    // Retour filters
    if (_retourPriceRange != null) count++;
    if (_retourAirlineCodes.isNotEmpty) count++;
    if (_retourDepAirportCodes.isNotEmpty) count++;
    if (_retourArrAirportCodes.isNotEmpty) count++;
    if (_retourEscaleOption != 'Tous') count++;
    if (_retourDepTimeRange.start > 0 || _retourDepTimeRange.end < 24) count++;
    if (_retourArrTimeRange.start > 0 || _retourArrTimeRange.end < 24) count++;
    return count;
  }

  bool get hasActiveFilters =>
      _selectedAirlineCode != null ||
      _isDirectOnly ||
      _selectedFilterAirlineCodes.isNotEmpty ||
      _selectedEscaleOption != 'Tous' ||
      _selectedPriceRange != null ||
      _selectedDepartureAirportCodes.isNotEmpty ||
      _selectedArrivalAirportCodes.isNotEmpty ||
      _selectedDepTimeRange.start > 0 ||
      _selectedDepTimeRange.end < 24 ||
      _selectedArrTimeRange.start > 0 ||
      _selectedArrTimeRange.end < 24 ||
      _hasRetourFilters;

  /// Checks if a specific journey of an offer passes the given filters.
  bool _offerPassesJourneyFilter(
    FlightOffer offer,
    int journeyIndex, {
    required String escaleOption,
    required Set<String> airlineCodes,
    required RangeValues depTimeRange,
    required RangeValues arrTimeRange,
    required Set<String> depAirportCodes,
    required Set<String> arrAirportCodes,
  }) {
    if (journeyIndex >= offer.journey.length) return true;
    final journey = offer.journey[journeyIndex];
    final segments = journey.flightSegments;
    if (segments.isEmpty) return true;

    // Escale / stops
    final stops = journey.flight?.stopQuantity ?? (segments.length - 1);
    if (escaleOption == 'Direct' && stops > 0) return false;
    if (escaleOption == 'Jusqu\'à 1 escale' && stops > 1) return false;
    if (escaleOption == 'Jusqu\'à 2 escales' && stops > 2) return false;

    // Airlines
    if (airlineCodes.isNotEmpty) {
      bool found = false;
      for (final seg in segments) {
        final code = seg.operatingAirline ?? seg.marketingAirline;
        if (code != null && airlineCodes.contains(code.toUpperCase())) {
          found = true;
          break;
        }
      }
      if (!found) return false;
    }

    // Departure airport
    if (depAirportCodes.isNotEmpty) {
      final depCode = segments.first.departureAirportCode;
      if (depCode == null || !depAirportCodes.contains(depCode)) return false;
    }

    // Arrival airport
    if (arrAirportCodes.isNotEmpty) {
      final arrCode = segments.last.arrivalAirportCode;
      if (arrCode == null || !arrAirportCodes.contains(arrCode)) return false;
    }

    // Departure time
    if (depTimeRange.start > 0 || depTimeRange.end < 24) {
      final depDt = segments.first.departureDateTime;
      if (depDt != null) {
        try {
          final dt = DateTime.parse(depDt);
          final hour = dt.hour + dt.minute / 60.0;
          if (hour < depTimeRange.start || hour > depTimeRange.end) return false;
        } catch (_) {}
      }
    }

    // Arrival time
    if (arrTimeRange.start > 0 || arrTimeRange.end < 24) {
      final arrDt = segments.last.arrivalDateTime;
      if (arrDt != null) {
        try {
          final dt = DateTime.parse(arrDt);
          final hour = dt.hour + dt.minute / 60.0;
          if (hour < arrTimeRange.start || hour > arrTimeRange.end) return false;
        } catch (_) {}
      }
    }

    return true;
  }

  /// Applies all active client-side filters on [_apiFlights].
  List<FlightOffer> get filteredApiFlights {
    List<FlightOffer> result = _apiFlights;

    // Direct-only toggle (global)
    if (_isDirectOnly) {
      result = result.where((offer) => isDirectFlight(offer)).toList();
    }

    // Quick chip airline (global)
    if (_selectedAirlineCode != null) {
      result = result.where((offer) {
        for (final journey in offer.journey) {
          for (final segment in journey.flightSegments) {
            final code = segment.operatingAirline ?? segment.marketingAirline;
            if (code?.toUpperCase() == _selectedAirlineCode?.toUpperCase()) {
              return true;
            }
          }
        }
        return false;
      }).toList();
    }

    // Price range (global)
    if (_selectedPriceRange != null) {
      result = result.where((offer) {
        final price = offer.totalPrice;
        return price >= _selectedPriceRange!.start && price <= _selectedPriceRange!.end;
      }).toList();
    }

    // Aller journey filters (journey index 0)
    final hasAllerFilters =
        _selectedEscaleOption != 'Tous' ||
        _selectedFilterAirlineCodes.isNotEmpty ||
        _selectedDepartureAirportCodes.isNotEmpty ||
        _selectedArrivalAirportCodes.isNotEmpty ||
        _selectedDepTimeRange.start > 0 ||
        _selectedDepTimeRange.end < 24 ||
        _selectedArrTimeRange.start > 0 ||
        _selectedArrTimeRange.end < 24;

    if (hasAllerFilters) {
      result = result.where((offer) => _offerPassesJourneyFilter(
        offer, 0,
        escaleOption: _selectedEscaleOption,
        airlineCodes: _selectedFilterAirlineCodes,
        depTimeRange: _selectedDepTimeRange,
        arrTimeRange: _selectedArrTimeRange,
        depAirportCodes: _selectedDepartureAirportCodes,
        arrAirportCodes: _selectedArrivalAirportCodes,
      )).toList();
    }

    // Retour journey filters (journey index 1)
    if (_hasRetourFilters) {
      result = result.where((offer) => _offerPassesJourneyFilter(
        offer, 1,
        escaleOption: _retourEscaleOption,
        airlineCodes: _retourAirlineCodes,
        depTimeRange: _retourDepTimeRange,
        arrTimeRange: _retourArrTimeRange,
        depAirportCodes: _retourDepAirportCodes,
        arrAirportCodes: _retourArrAirportCodes,
      )).toList();
    }

    return result;
  }

  /// Extracts airline chips with best prices from the API airlines list,
  /// falling back to extracting from flight segments if not available.
  List<Map<String, dynamic>> get filterChips {
    // Use API airlines data when available (correct names & prices from server)
    if (_apiAirlines.isNotEmpty) {
      final chips = _apiAirlines
          .where((a) => a.iataCode != null && a.iataCode!.isNotEmpty)
          .map((a) => {
                'text': '${a.price?.toInt() ?? 0} DZD',
                'airlineName': a.name ?? a.iataCode ?? 'Airline',
                'airlineCode': a.iataCode!,
                'price': a.price?.toInt() ?? 0,
                'type': 'price',
              })
          .toList();

      chips.sort((a, b) => (a['price'] as int).compareTo(b['price'] as int));

      return chips;
    }

    // Fallback: extract from flight segments
    if (!hasApiFlights) return [];

    final Map<String, Map<String, dynamic>> airlineData = {};

    for (final offer in _apiFlights) {
      for (final journey in offer.journey) {
        for (final segment in journey.flightSegments) {
          final airlineCode = segment.operatingAirline ?? segment.marketingAirline;
          final airlineName =
              segment.operatingAirlineName ?? segment.marketingAirlineName ?? 'Airline';

          if (airlineCode != null && airlineCode.isNotEmpty) {
            final price = offer.totalPrice;

            if (!airlineData.containsKey(airlineCode)) {
              airlineData[airlineCode] = {
                'code': airlineCode,
                'name': airlineName,
                'bestPrice': price,
              };
            } else {
              if (price < (airlineData[airlineCode]!['bestPrice'] as double)) {
                airlineData[airlineCode]!['bestPrice'] = price;
              }
            }
          }
        }
      }
    }

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

    chips.sort((a, b) {
      final priceA = int.tryParse((a['text'] as String).replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
      final priceB = int.tryParse((b['text'] as String).replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
      return priceA.compareTo(priceB);
    });

    return chips;
  }

  /// Extracts filter metadata (airlines, prices, airports, stops) from loaded flights.
  /// Lookup airline name from API airlines list, falling back to segment name.
  String resolveAirlineName(String code, String fallback) {
    if (_apiAirlines.isNotEmpty) {
      final match = _apiAirlines.where(
        (a) => a.iataCode?.toUpperCase() == code.toUpperCase(),
      );
      if (match.isNotEmpty && match.first.name != null && match.first.name!.isNotEmpty) {
        return match.first.name!;
      }
    }
    return fallback;
  }

  Map<String, dynamic> get filterData {
    final Map<String, Map<String, dynamic>> airlinesMap = {};
    double minPrice = double.infinity;
    double maxPrice = 0;
    final Map<String, Map<String, dynamic>> outDepAirportsMap = {};
    final Map<String, Map<String, dynamic>> outArrAirportsMap = {};
    final Map<String, Map<String, dynamic>> connectionAirportsMap = {};
    int maxStopsFound = 0;

    // If we have API airlines, seed the map with them first (correct names)
    if (_apiAirlines.isNotEmpty) {
      for (final airline in _apiAirlines) {
        final code = airline.iataCode;
        if (code != null && code.isNotEmpty && !airlinesMap.containsKey(code)) {
          airlinesMap[code] = {
            'name': airline.name ?? code,
            'code': code,
            'logo': getAirlineLogoUrl(code),
            'selected': _selectedFilterAirlineCodes.contains(code.toUpperCase()),
          };
        }
      }
    }

    if (hasApiFlights) {
      for (final offer in _apiFlights) {
        final price = offer.totalPrice;
        if (price < minPrice) minPrice = price;
        if (price > maxPrice) maxPrice = price;

        for (int jIdx = 0; jIdx < offer.journey.length; jIdx++) {
          final journey = offer.journey[jIdx];
          final segments = journey.flightSegments;
          if (segments.isEmpty) continue;

          final stops = journey.flight?.stopQuantity ?? (segments.length - 1);
          if (stops > maxStopsFound) maxStopsFound = stops;

          for (int i = 0; i < segments.length; i++) {
            final segment = segments[i];

            final airlineCode = segment.operatingAirline ?? segment.marketingAirline;
            final airlineName =
                segment.operatingAirlineName ?? segment.marketingAirlineName ?? 'Airline';
            if (airlineCode != null &&
                airlineCode.isNotEmpty &&
                !airlinesMap.containsKey(airlineCode)) {
              airlinesMap[airlineCode] = {
                'name': resolveAirlineName(airlineCode, airlineName),
                'code': airlineCode,
                'logo': getAirlineLogoUrl(airlineCode),
                'selected': _selectedFilterAirlineCodes.contains(airlineCode.toUpperCase()),
              };
            }

            if (jIdx == 0) {
              if (i == 0) {
                final depCode = segment.departureAirportCode;
                final depDetails = segment.departureAirportDetails;
                if (depCode != null && !outDepAirportsMap.containsKey(depCode)) {
                  outDepAirportsMap[depCode] = {
                    'name': depDetails?.name ?? depCode,
                    'code': depCode,
                    'city': depDetails?.city ?? '',
                    'selected': _selectedDepartureAirportCodes.contains(depCode),
                  };
                }
              }

              if (i == segments.length - 1) {
                final arrCode = segment.arrivalAirportCode;
                final arrDetails = segment.arrivalAirportDetails;
                if (arrCode != null && !outArrAirportsMap.containsKey(arrCode)) {
                  outArrAirportsMap[arrCode] = {
                    'name': arrDetails?.name ?? arrCode,
                    'code': arrCode,
                    'city': arrDetails?.city ?? '',
                    'selected': _selectedArrivalAirportCodes.contains(arrCode),
                  };
                }
              }

              if (segments.length > 1 && i < segments.length - 1) {
                final connCode = segment.arrivalAirportCode;
                final connDetails = segment.arrivalAirportDetails;
                if (connCode != null && !connectionAirportsMap.containsKey(connCode)) {
                  connectionAirportsMap[connCode] = {
                    'name': connDetails?.name ?? connCode,
                    'code': connCode,
                    'city': connDetails?.city ?? '',
                    'selected': false,
                  };
                }
              }
            }
          }
        }
      }
    }

    final List<String> escaleOptions = ['Tous', 'Direct'];
    if (maxStopsFound >= 1) escaleOptions.add('Jusqu\'à 1 escale');
    if (maxStopsFound >= 2) escaleOptions.add('Jusqu\'à 2 escales');

    final departureCity = outDepAirportsMap.isNotEmpty
        ? (outDepAirportsMap.values.first['city'] as String?) ?? fromAirport.city
        : fromAirport.city;
    final arrivalCity = outArrAirportsMap.isNotEmpty
        ? (outArrAirportsMap.values.first['city'] as String?) ?? toAirport.city
        : toAirport.city;

    return {
      'categories': ['Compagnies', 'Prix', 'Escale', 'Horaires', 'Aéroport'],
      'compagnies': airlinesMap.values.toList(),
      'prix': {
        'min': minPrice == double.infinity ? 0 : minPrice,
        'max': maxPrice == 0 ? 50000 : maxPrice,
        'currency': _apiFlights.isNotEmpty ? _apiFlights.first.currency : 'DZD',
      },
      'escale': escaleOptions,
      'aeroports': {
        'depart': {
          'city': departureCity,
          'airports': outDepAirportsMap.values.toList(),
        },
        'arrivee': {
          'city': arrivalCity,
          'airports': outArrAirportsMap.values.toList(),
        },
        'connexion': {
          'airports': connectionAirportsMap.values.toList(),
        },
      },
    };
  }

  /// Extracts filter metadata scoped to a specific journey index.
  /// journeyIndex 0 = Aller, 1 = Retour.
  Map<String, dynamic> filterDataForJourney(int journeyIndex) {
    final Map<String, Map<String, dynamic>> airlinesMap = {};
    final Map<String, Map<String, dynamic>> depAirportsMap = {};
    final Map<String, Map<String, dynamic>> arrAirportsMap = {};
    final Map<String, Map<String, dynamic>> connectionAirportsMap = {};
    int maxStopsFound = 0;

    final currentAirlineCodes = journeyIndex == 0
        ? _selectedFilterAirlineCodes
        : _retourAirlineCodes;
    final currentDepAirportCodes = journeyIndex == 0
        ? _selectedDepartureAirportCodes
        : _retourDepAirportCodes;
    final currentArrAirportCodes = journeyIndex == 0
        ? _selectedArrivalAirportCodes
        : _retourArrAirportCodes;

    // Seed with API airlines for correct names
    if (_apiAirlines.isNotEmpty) {
      for (final airline in _apiAirlines) {
        final code = airline.iataCode;
        if (code != null && code.isNotEmpty && !airlinesMap.containsKey(code)) {
          airlinesMap[code] = {
            'name': airline.name ?? code,
            'code': code,
            'logo': getAirlineLogoUrl(code),
            'selected': currentAirlineCodes.contains(code.toUpperCase()),
          };
        }
      }
    }

    if (hasApiFlights) {
      for (final offer in _apiFlights) {
        if (journeyIndex >= offer.journey.length) continue;
        final journey = offer.journey[journeyIndex];
        final segments = journey.flightSegments;
        if (segments.isEmpty) continue;

        final stops = journey.flight?.stopQuantity ?? (segments.length - 1);
        if (stops > maxStopsFound) maxStopsFound = stops;

        for (int i = 0; i < segments.length; i++) {
          final segment = segments[i];

          // Airlines
          final airlineCode = segment.operatingAirline ?? segment.marketingAirline;
          final airlineName =
              segment.operatingAirlineName ?? segment.marketingAirlineName ?? 'Airline';
          if (airlineCode != null &&
              airlineCode.isNotEmpty &&
              !airlinesMap.containsKey(airlineCode)) {
            airlinesMap[airlineCode] = {
              'name': resolveAirlineName(airlineCode, airlineName),
              'code': airlineCode,
              'logo': getAirlineLogoUrl(airlineCode),
              'selected': currentAirlineCodes.contains(airlineCode.toUpperCase()),
            };
          }

          // First segment = departure airport
          if (i == 0) {
            final depCode = segment.departureAirportCode;
            final depDetails = segment.departureAirportDetails;
            if (depCode != null && !depAirportsMap.containsKey(depCode)) {
              depAirportsMap[depCode] = {
                'name': depDetails?.name ?? depCode,
                'code': depCode,
                'city': depDetails?.city ?? '',
                'selected': currentDepAirportCodes.contains(depCode),
              };
            }
          }

          // Last segment = arrival airport
          if (i == segments.length - 1) {
            final arrCode = segment.arrivalAirportCode;
            final arrDetails = segment.arrivalAirportDetails;
            if (arrCode != null && !arrAirportsMap.containsKey(arrCode)) {
              arrAirportsMap[arrCode] = {
                'name': arrDetails?.name ?? arrCode,
                'code': arrCode,
                'city': arrDetails?.city ?? '',
                'selected': currentArrAirportCodes.contains(arrCode),
              };
            }
          }

          // Connection airports
          if (segments.length > 1 && i < segments.length - 1) {
            final connCode = segment.arrivalAirportCode;
            final connDetails = segment.arrivalAirportDetails;
            if (connCode != null && !connectionAirportsMap.containsKey(connCode)) {
              connectionAirportsMap[connCode] = {
                'name': connDetails?.name ?? connCode,
                'code': connCode,
                'city': connDetails?.city ?? '',
                'selected': false,
              };
            }
          }
        }
      }
    }

    final List<String> escaleOptions = ['Tous', 'Direct'];
    if (maxStopsFound >= 1) escaleOptions.add('Jusqu\'à 1 escale');
    if (maxStopsFound >= 2) escaleOptions.add('Jusqu\'à 2 escales');

    // For retour journey, departure/arrival cities are swapped
    final departureCity = depAirportsMap.isNotEmpty
        ? (depAirportsMap.values.first['city'] as String?) ??
            (journeyIndex == 0 ? fromAirport.city : toAirport.city)
        : (journeyIndex == 0 ? fromAirport.city : toAirport.city);
    final arrivalCity = arrAirportsMap.isNotEmpty
        ? (arrAirportsMap.values.first['city'] as String?) ??
            (journeyIndex == 0 ? toAirport.city : fromAirport.city)
        : (journeyIndex == 0 ? toAirport.city : fromAirport.city);

    return {
      'compagnies': airlinesMap.values.toList(),
      'escale': escaleOptions,
      'aeroports': {
        'depart': {
          'city': departureCity,
          'airports': depAirportsMap.values.toList(),
        },
        'arrivee': {
          'city': arrivalCity,
          'airports': arrAirportsMap.values.toList(),
        },
        'connexion': {
          'airports': connectionAirportsMap.values.toList(),
        },
      },
    };
  }

  // ═══════════════════════════════════════════════════════════
  //  STATIC UTILITY METHODS
  // ═══════════════════════════════════════════════════════════

  static String formatDateForApi(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  static String formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('d MMM').format(date);
  }

  static String formatFlightDate(DateTime? date) {
    if (date == null) return '29 Jan 26';
    return DateFormat('d MMM yy').format(date);
  }

  static String formatTime(String? time) {
    if (time == null || time.isEmpty) return '--:--';
    if (time.contains(':') && time.length <= 5) return time;
    try {
      final dt = DateTime.parse(time);
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return time.length >= 5 ? time.substring(0, 5) : time;
    }
  }

  static String formatTimeFromDateTime(String? dateTime) {
    if (dateTime == null || dateTime.isEmpty) return '--:--';
    try {
      final dt = DateTime.parse(dateTime);
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      if (dateTime.contains(':')) {
        final parts = dateTime.split(':');
        if (parts.length >= 2) {
          return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
        }
      }
      return '--:--';
    }
  }

  static String formatHour(double h) {
    final hours = h.floor();
    final minutes = ((h - hours) * 60).round();
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  static String getPaxTypeDisplayName(String? paxType) {
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

  static String getAirlineLogoUrl(String airlineCode) {
    return 'https://pics.avs.io/200/200/${airlineCode.toUpperCase()}.png';
  }

  /// Returns the fixed sort key identifier (not translated).
  /// Use the UI layer with lang.S for translated short labels.
  static String getSortDisplayKey(String sortOption) {
    return sortOption;
  }

  static int parseDurationToMinutes(String duration) {
    if (duration.startsWith('PT')) {
      int minutes = 0;
      final hourMatch = RegExp(r'(\d+)H').firstMatch(duration);
      final minMatch = RegExp(r'(\d+)M').firstMatch(duration);
      if (hourMatch != null) minutes += int.parse(hourMatch.group(1)!) * 60;
      if (minMatch != null) minutes += int.parse(minMatch.group(1)!);
      return minutes;
    }
    final parts = duration.replaceAll(RegExp(r'[^\d:]'), ' ').trim().split(RegExp(r'[\s:]+'));
    if (parts.length >= 2) {
      final hours = int.tryParse(parts[0]) ?? 0;
      final mins = int.tryParse(parts[1]) ?? 0;
      return hours * 60 + mins;
    }
    return 0;
  }

  static DateTime? getFlightDepartureDateTime(FlightOffer offer) {
    if (offer.journey.isEmpty) return null;
    final firstJourney = offer.journey.first;
    if (firstJourney.flightSegments.isEmpty) return null;
    final dateTimeStr = firstJourney.flightSegments.first.departureDateTime;
    if (dateTimeStr == null) return null;
    return DateTime.tryParse(dateTimeStr);
  }

  static DateTime? getFlightArrivalDateTime(FlightOffer offer) {
    if (offer.journey.isEmpty) return null;
    final firstJourney = offer.journey.first;
    if (firstJourney.flightSegments.isEmpty) return null;
    final dateTimeStr = firstJourney.flightSegments.last.arrivalDateTime;
    if (dateTimeStr == null) return null;
    return DateTime.tryParse(dateTimeStr);
  }

  static int getFlightTotalDuration(FlightOffer offer) {
    if (offer.detail?.elapsedDurationTime != null) {
      return offer.detail!.elapsedDurationTime!;
    }
    int totalMinutes = 0;
    for (final journey in offer.journey) {
      if (journey.flight?.flightInfo?.durationTime != null) {
        totalMinutes += journey.flight!.flightInfo!.durationTime!;
      } else {
        for (final segment in journey.flightSegments) {
          final durationStr = segment.duration;
          if (durationStr != null) {
            totalMinutes += parseDurationToMinutes(durationStr);
          }
        }
      }
    }
    return totalMinutes;
  }

  static bool isDirectFlight(FlightOffer offer) {
    for (final journey in offer.journey) {
      final stops = journey.flight?.stopQuantity ?? (journey.flightSegments.length - 1);
      if (stops > 0) return false;
    }
    return true;
  }

  static int getMaxStops(FlightOffer offer) {
    int maxStops = 0;
    for (final journey in offer.journey) {
      final stops = journey.flight?.stopQuantity ?? (journey.flightSegments.length - 1);
      if (stops > maxStops) maxStops = stops;
    }
    return maxStops;
  }

  // ── Locale-dependent instance methods ──

  String formatDateTimeString(String? dateTime) {
    if (dateTime == null || dateTime.isEmpty) return '';
    try {
      final dt = DateTime.parse(dateTime);
      return DateFormat('dd MMM', locale).format(dt);
    } catch (_) {
      return '';
    }
  }

  String formatDateDayFull(String? dateTime) {
    if (dateTime == null || dateTime.isEmpty) return '';
    try {
      final dt = DateTime.parse(dateTime);
      return DateFormat('E. d MMM.', locale).format(dt);
    } catch (_) {
      return '';
    }
  }
}
