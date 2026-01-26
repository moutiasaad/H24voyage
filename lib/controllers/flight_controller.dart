import 'package:flutter/foundation.dart';
import '../Model/Airport.dart';
import '../models/models.dart';
import '../services/flight_service.dart';

class FlightController extends ChangeNotifier {
  // Loading state
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Error state
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  // Search results
  FlightSearchResponse? _searchResponse;
  FlightSearchResponse? get searchResponse => _searchResponse;

  String? _searchCode;
  String? get searchCode => _searchCode;

  List<FlightOffer> _offers = [];
  List<FlightOffer> get offers => _offers;

  // Results with pagination
  FlightResultsResponse? _resultsResponse;
  FlightResultsResponse? get resultsResponse => _resultsResponse;

  int _currentPage = 1;
  int get currentPage => _currentPage;

  bool _hasMorePages = true;
  bool get hasMorePages => _hasMorePages;

  // Convert PassengerType enum to string
  static PassengerType _getPassengerType(String type) {
    switch (type.toUpperCase()) {
      case 'ADT':
        return PassengerType.ADT;
      case 'CHD':
        return PassengerType.CHD;
      case 'INF':
        return PassengerType.INF;
      case 'SNR':
        return PassengerType.SNR;
      case 'YNG':
        return PassengerType.YNG;
      case 'STD':
        return PassengerType.STD;
      default:
        return PassengerType.ADT;
    }
  }

  // Convert CabinClass string to enum
  static CabinClass _getCabinClass(String cabinClass) {
    switch (cabinClass.toLowerCase()) {
      case 'first':
      case 'f':
        return CabinClass.F;
      case 'business':
      case 'b':
        return CabinClass.B;
      case 'premium':
      case 'premium_economy':
      case 'pe':
        return CabinClass.PE;
      case 'economy':
      case 'e':
      default:
        return CabinClass.E;
    }
  }

  // Build passengers list from counts
  List<Passenger> _buildPassengers({
    required int adultCount,
    required int childCount,
    required int infantCount,
  }) {
    final passengers = <Passenger>[];
    int id = 1;

    for (int i = 0; i < adultCount; i++) {
      passengers.add(Passenger(id: (id++).toString(), ptc: PassengerType.ADT));
    }
    for (int i = 0; i < childCount; i++) {
      passengers.add(Passenger(id: (id++).toString(), ptc: PassengerType.CHD));
    }
    for (int i = 0; i < infantCount; i++) {
      passengers.add(Passenger(id: (id++).toString(), ptc: PassengerType.INF));
    }

    return passengers;
  }

  // Format date to API format (YYYY-MM-DD)
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  // Clear previous results
  void _clearResults() {
    _searchResponse = null;
    _resultsResponse = null;
    _searchCode = null;
    _offers = [];
    _currentPage = 1;
    _hasMorePages = true;
    _errorMessage = null;
  }

  // Search one-way flights
  Future<void> searchOneWay({
    required Airport fromAirport,
    required Airport toAirport,
    required DateTime departureDate,
    int adultCount = 1,
    int childCount = 0,
    int infantCount = 0,
    String cabinClass = 'economy',
    bool directOnly = false,
    bool withBaggage = false,
    List<String>? airlines,
  }) async {
    _isLoading = true;
    _clearResults();
    notifyListeners();

    try {
      final passengers = _buildPassengers(
        adultCount: adultCount,
        childCount: childCount,
        infantCount: infantCount,
      );

      final response = await FlightService.searchOneWay(
        origin: fromAirport.code,
        destination: toAirport.code,
        departureDate: _formatDate(departureDate),
        passengers: passengers,
        cabinClass: _getCabinClass(cabinClass),
        stops: directOnly ? 0 : null,
        baggage: withBaggage ? true : null,
        airlines: airlines,
      );

      _searchResponse = response;
      _searchCode = response.searchCode;

      // Extract offers from response using convenience getter
      _offers = response.offers;

      _errorMessage = null;
    } catch (e) {
      // Clean up error message by removing "Exception:" prefixes
      String errorMsg = e.toString();
      errorMsg = errorMsg.replaceAll(RegExp(r'Exception:\s*'), '');
      _errorMessage = errorMsg;
      debugPrint('Error searching one-way flights: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Search round-trip flights
  Future<void> searchRoundTrip({
    required Airport fromAirport,
    required Airport toAirport,
    required DateTime departureDate,
    required DateTime returnDate,
    int adultCount = 1,
    int childCount = 0,
    int infantCount = 0,
    String cabinClass = 'economy',
    bool directOnly = false,
    bool withBaggage = false,
    bool refundable = false,
    List<String>? airlines,
  }) async {
    _isLoading = true;
    _clearResults();
    notifyListeners();

    try {
      final passengers = _buildPassengers(
        adultCount: adultCount,
        childCount: childCount,
        infantCount: infantCount,
      );

      final response = await FlightService.searchRoundTrip(
        origin: fromAirport.code,
        destination: toAirport.code,
        departureDate: _formatDate(departureDate),
        returnDate: _formatDate(returnDate),
        passengers: passengers,
        cabinClass: _getCabinClass(cabinClass),
        stops: directOnly ? 0 : null,
        baggage: withBaggage ? true : null,
        refundable: refundable ? true : null,
        airlines: airlines,
      );

      _searchResponse = response;
      _searchCode = response.searchCode;

      // Extract offers from response using convenience getter
      _offers = response.offers;

      _errorMessage = null;
    } catch (e) {
      // Clean up error message by removing "Exception:" prefixes
      String errorMsg = e.toString();
      errorMsg = errorMsg.replaceAll(RegExp(r'Exception:\s*'), '');
      _errorMessage = errorMsg;
      debugPrint('Error searching round-trip flights: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Search multi-destination flights
  Future<void> searchMultiDestination({
    required List<FlightBound> bounds,
    int adultCount = 1,
    int childCount = 0,
    int infantCount = 0,
    String cabinClass = 'economy',
    bool directOnly = false,
    bool withBaggage = false,
    List<String>? airlines,
  }) async {
    _isLoading = true;
    _clearResults();
    notifyListeners();

    try {
      final passengers = _buildPassengers(
        adultCount: adultCount,
        childCount: childCount,
        infantCount: infantCount,
      );

      final response = await FlightService.searchMultiDestination(
        bounds: bounds,
        passengers: passengers,
        cabinClass: _getCabinClass(cabinClass),
        stops: directOnly ? 0 : null,
        baggage: withBaggage ? true : null,
        airlines: airlines,
      );

      _searchResponse = response;
      _searchCode = response.searchCode;

      // Extract offers from response using convenience getter
      _offers = response.offers;

      _errorMessage = null;
    } catch (e) {
      // Clean up error message by removing "Exception:" prefixes
      String errorMsg = e.toString();
      errorMsg = errorMsg.replaceAll(RegExp(r'Exception:\s*'), '');
      _errorMessage = errorMsg;
      debugPrint('Error searching multi-destination flights: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Generic search method that chooses the right type based on parameters
  Future<void> searchFlights({
    required Airport fromAirport,
    required Airport toAirport,
    required DateTime departureDate,
    DateTime? returnDate,
    int adultCount = 1,
    int childCount = 0,
    int infantCount = 0,
    String cabinClass = 'economy',
    bool directOnly = false,
    bool withBaggage = false,
    bool refundable = false,
    List<String>? airlines,
    bool isRoundTrip = true,
  }) async {
    if (isRoundTrip && returnDate != null) {
      await searchRoundTrip(
        fromAirport: fromAirport,
        toAirport: toAirport,
        departureDate: departureDate,
        returnDate: returnDate,
        adultCount: adultCount,
        childCount: childCount,
        infantCount: infantCount,
        cabinClass: cabinClass,
        directOnly: directOnly,
        withBaggage: withBaggage,
        refundable: refundable,
        airlines: airlines,
      );
    } else {
      await searchOneWay(
        fromAirport: fromAirport,
        toAirport: toAirport,
        departureDate: departureDate,
        adultCount: adultCount,
        childCount: childCount,
        infantCount: infantCount,
        cabinClass: cabinClass,
        directOnly: directOnly,
        withBaggage: withBaggage,
        airlines: airlines,
      );
    }
  }

  // Get results with filters (pagination, sorting, etc.)
  Future<void> getResults({
    int? page,
    double? minPrice,
    double? maxPrice,
    bool? isRefundable,
    String? sort,
    bool? includedBaggageOnly,
    bool? noCodeshare,
    String? airline,
  }) async {
    if (_searchCode == null) {
      _errorMessage = 'No search code available. Please search for flights first.';
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final request = FlightResultsRequest(
        searchCode: _searchCode!,
        page: page ?? _currentPage,
        minPrice: minPrice,
        maxPrice: maxPrice,
        isRefundable: isRefundable,
        sort: sort,
        includedBaggageOnly: includedBaggageOnly,
        noCodeshare: noCodeshare,
        airline: airline,
      );

      final response = await FlightService.getResults(request);

      _resultsResponse = response;
      _offers = response.offers;
      _currentPage = response.currentPage ?? page ?? _currentPage;
      _hasMorePages = response.totalPages != null &&
                      _currentPage < response.totalPages!;

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('Error getting results: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load next page of results
  Future<void> loadMoreResults({
    double? minPrice,
    double? maxPrice,
    bool? isRefundable,
    String? sort,
    String? airline,
  }) async {
    if (!_hasMorePages || _isLoading) return;

    await getResults(
      page: _currentPage + 1,
      minPrice: minPrice,
      maxPrice: maxPrice,
      isRefundable: isRefundable,
      sort: sort,
      airline: airline,
    );
  }

  // Sort offers by price (ascending)
  void sortByPriceAsc() {
    _offers.sort((a, b) => a.totalPrice.compareTo(b.totalPrice));
    notifyListeners();
  }

  // Sort offers by price (descending)
  void sortByPriceDesc() {
    _offers.sort((a, b) => b.totalPrice.compareTo(a.totalPrice));
    notifyListeners();
  }

  // Filter offers by direct flights only
  List<FlightOffer> getDirectFlightsOnly() {
    return _offers.where((offer) {
      // Check if all journeys have 0 stops
      return offer.journey.every((journey) =>
        (journey.flight?.stopQuantity ?? 0) == 0
      );
    }).toList();
  }

  // Filter offers by price range
  List<FlightOffer> getOffersByPriceRange(double minPrice, double maxPrice) {
    return _offers.where((offer) {
      final price = offer.totalPrice;
      return price >= minPrice && price <= maxPrice;
    }).toList();
  }

  // ============ Fare Breakdown Helpers ============

  // Get filter dependencies from search response
  FilterDependencies? get filterDependencies =>
      _searchResponse?.data?.filterDependencies;

  // Get price range from filter dependencies
  double? get minPrice => filterDependencies?.minRate;
  double? get maxPrice => filterDependencies?.maxRate;

  // Get available stops filter options (all bounds)
  List<List<BoundStopInfo>> get availableStops => filterDependencies?.stops ?? [];

  // Get available stops for a specific bound
  List<BoundStopInfo> getStopsForBound(int boundIndex) =>
      filterDependencies?.getStopsForBound(boundIndex) ?? [];

  // Get available time filters for a specific bound
  List<BoundTimeFilter> getTimesForBound(int boundIndex) =>
      filterDependencies?.getTimesForBound(boundIndex) ?? [];

  // Get available airlines
  List<AirlineInfo> get availableAirlines => filterDependencies?.airlines ?? [];

  // Get available airports
  List<AirportInfo> get availableAirports => filterDependencies?.airports ?? [];

  // Check if direct flights are available
  bool get hasDirectFlightsAvailable =>
      filterDependencies?.hasDirectFlights ?? false;

  // Get currency from response
  String get currency => _searchResponse?.data?.currency ?? 'DZD';

  // Get fare breakdown for a specific offer by passenger type
  FareBreakdown? getFareBreakdown(FlightOffer offer, String passengerType) {
    return offer.fare?.getFareForPassengerType(passengerType);
  }

  // Get adult fare for an offer
  FareBreakdown? getAdultFare(FlightOffer offer) {
    return offer.fare?.adultFare;
  }

  // Get child fare for an offer
  FareBreakdown? getChildFare(FlightOffer offer) {
    return offer.fare?.childFare;
  }

  // Get infant fare for an offer
  FareBreakdown? getInfantFare(FlightOffer offer) {
    return offer.fare?.infantFare;
  }

  // Get all fare breakdowns for an offer
  List<FareBreakdown> getFareBreakdowns(FlightOffer offer) {
    return offer.fare?.fareBreakdown ?? [];
  }

  // Get baggage allowance for a specific passenger type from an offer
  BaggageInfo? getCheckedBaggage(FlightOffer offer, String passengerType, {int journeyIndex = 0, int segmentIndex = 0}) {
    if (offer.journey.isEmpty) return null;
    if (journeyIndex >= offer.journey.length) return null;

    final journey = offer.journey[journeyIndex];
    if (journey.flightSegments.isEmpty) return null;
    if (segmentIndex >= journey.flightSegments.length) return null;

    final segment = journey.flightSegments[segmentIndex];
    final baggageList = segment.baggageAllowance?.checkedInBaggage ?? [];

    try {
      return baggageList.firstWhere(
        (b) => b.paxType?.toUpperCase() == passengerType.toUpperCase(),
      );
    } catch (_) {
      return baggageList.isNotEmpty ? baggageList.first : null;
    }
  }

  // Get cabin baggage for a specific passenger type from an offer
  BaggageInfo? getCabinBaggage(FlightOffer offer, String passengerType, {int journeyIndex = 0, int segmentIndex = 0}) {
    if (offer.journey.isEmpty) return null;
    if (journeyIndex >= offer.journey.length) return null;

    final journey = offer.journey[journeyIndex];
    if (journey.flightSegments.isEmpty) return null;
    if (segmentIndex >= journey.flightSegments.length) return null;

    final segment = journey.flightSegments[segmentIndex];
    final baggageList = segment.baggageAllowance?.cabinBaggage ?? [];

    try {
      return baggageList.firstWhere(
        (b) => b.paxType?.toUpperCase() == passengerType.toUpperCase(),
      );
    } catch (_) {
      return baggageList.isNotEmpty ? baggageList.first : null;
    }
  }

  // Format price with currency
  String formatPrice(double price, {String? currencyCode}) {
    final curr = currencyCode ?? currency;
    return '${price.toStringAsFixed(0)} $curr';
  }

  // Get total number of offers
  int get totalOffers => _searchResponse?.data?.total ?? _offers.length;

  // Filter offers by airline
  List<FlightOffer> getOffersByAirline(String airlineCode) {
    return _offers.where((offer) {
      return offer.airlineCode.toUpperCase() == airlineCode.toUpperCase();
    }).toList();
  }

  // Filter offers by refundable
  List<FlightOffer> getRefundableOffers() {
    return _offers.where((offer) => offer.isRefundable).toList();
  }

  // Filter offers by stops count
  List<FlightOffer> getOffersByStops(int maxStops) {
    return _offers.where((offer) {
      return offer.journey.every((journey) =>
        (journey.flight?.stopQuantity ?? 0) <= maxStops
      );
    }).toList();
  }

  // Get cheapest offer
  FlightOffer? get cheapestOffer {
    if (_offers.isEmpty) return null;
    return _offers.reduce((a, b) =>
      a.totalPrice < b.totalPrice ? a : b
    );
  }

  // Get fastest offer (by total duration)
  FlightOffer? get fastestOffer {
    if (_offers.isEmpty) return null;
    return _offers.reduce((a, b) {
      final aDuration = a.detail?.elapsedDurationTime ?? 999999;
      final bDuration = b.detail?.elapsedDurationTime ?? 999999;
      return aDuration < bDuration ? a : b;
    });
  }

  // Clear all data
  void clear() {
    _clearResults();
    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
