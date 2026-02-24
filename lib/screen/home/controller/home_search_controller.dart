import 'package:flutter/material.dart';
import 'package:flight_booking/Model/Airport.dart';
import 'package:flight_booking/generated/l10n.dart' as lang;
import 'package:flight_booking/controllers/flight_controller.dart';
import 'package:intl/intl.dart';
import '../models/multi_destination_leg.dart';
import '../models/advantage_slider_item.dart';
import '../models/offer_slider_item.dart';

class HomeSearchController extends ChangeNotifier {
  // Airports
  Airport? fromAirport;
  Airport? toAirport;

  // Multi-destination legs
  List<MultiDestinationLeg> multiDestinationLegs = [];

  // Passenger counts
  int adultCount = 1;
  int childCount = 0;
  int infantCount = 0;
  int youngCount = 0;
  int seniorCount = 0;

  int selectedIndex = 0; // 0 = Round-trip, 1 = One-way, 2 = Multi-destination

  // Class selection
  List<String> classKeys = ['first', 'business', 'premium_economy', 'economy'];
  String selectedClass = 'economy';

  // Dates
  DateTime? departureDate;
  DateTime? returnDate;
  DateTimeRange? _selectedDateRange;

  // Toggle switches
  bool isDirectFlight = false;
  bool withBaggage = false;

  // Search state
  bool _isSearching = false;

  // Flight controller for API calls
  final FlightController _flightController = FlightController();

  // Slider data
  List<AdvantageSliderItem> advantageSliders = [];
  List<OfferSliderItem> offerSliders = [];
  int currentAdvantageIndex = 0;
  int currentOfferIndex = 0;

  // Getters
  int get totalPassengers =>
      adultCount + childCount + infantCount + youngCount + seniorCount;

  bool get isSearching => _isSearching;
  set isSearching(bool value) {
    _isSearching = value;
    notifyListeners();
  }

  FlightController get flightController => _flightController;

  DateTimeRange? get selectedDateRange => _selectedDateRange;
  set selectedDateRange(DateTimeRange? value) {
    _selectedDateRange = value;
    notifyListeners();
  }

  /// Get the localized display name for a class key
  String getClassDisplayName(String classKey, lang.S t) {
    switch (classKey) {
      case 'first':
        return t.homeClassFirstShort;
      case 'business':
        return t.homeClassBusinessShort;
      case 'premium_economy':
        return t.homeClassPremiumEconomyShort;
      case 'economy':
      default:
        return t.homeClassEconomyShort;
    }
  }

  /// Format a date for display using French locale
  String formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd MMM yyyy', 'fr').format(date);
  }

  /// Swap from and to airports
  void swapAirports() {
    final temp = fromAirport;
    fromAirport = toAirport;
    toAirport = temp;
    notifyListeners();
  }

  /// Set the selected tab index
  void setTabIndex(int index) {
    selectedIndex = index;
    if (index == 1) {
      returnDate = null;
      _selectedDateRange = null;
    }
    notifyListeners();
  }

  /// Set from airport
  void setFromAirport(Airport airport) {
    fromAirport = airport;
    notifyListeners();
  }

  /// Set to airport
  void setToAirport(Airport airport) {
    toAirport = airport;
    notifyListeners();
  }

  /// Update dates from date picker result
  void updateDates(Map<String, dynamic> result) {
    departureDate = result['departure'] as DateTime?;
    final isRoundTrip = selectedIndex == 0 || selectedIndex == 2;
    if (isRoundTrip) {
      returnDate = result['return'] as DateTime?;
    } else {
      returnDate = null;
    }
    if (departureDate != null && returnDate != null) {
      _selectedDateRange = DateTimeRange(start: departureDate!, end: returnDate!);
    }
    notifyListeners();
  }

  /// Update leg date from date picker result
  void updateLegDate(int legIndex, Map<String, dynamic> result) {
    if (legIndex >= 0 && legIndex < multiDestinationLegs.length) {
      multiDestinationLegs[legIndex].departureDate = result['departure'] as DateTime?;
      notifyListeners();
    }
  }

  /// Set leg from airport
  void setLegFromAirport(int index, Airport airport) {
    if (index >= 0 && index < multiDestinationLegs.length) {
      multiDestinationLegs[index].fromAirport = airport;
      notifyListeners();
    }
  }

  /// Set leg to airport
  void setLegToAirport(int index, Airport airport) {
    if (index >= 0 && index < multiDestinationLegs.length) {
      multiDestinationLegs[index].toAirport = airport;
      notifyListeners();
    }
  }

  /// Swap airports for a specific multi-destination leg
  void swapLegAirports(int index) {
    if (index >= 0 && index < multiDestinationLegs.length) {
      final temp = multiDestinationLegs[index].fromAirport;
      multiDestinationLegs[index].fromAirport = multiDestinationLegs[index].toAirport;
      multiDestinationLegs[index].toAirport = temp;
      notifyListeners();
    }
  }

  /// Remove a multi-destination leg at the given index
  void removeMultiDestinationLeg(int index) {
    if (index >= 0 && index < multiDestinationLegs.length) {
      multiDestinationLegs.removeAt(index);
      notifyListeners();
    }
  }

  /// Add a new multi-destination leg with smart defaults
  void addMultiDestinationLeg() {
    if (multiDestinationLegs.length >= 3) return;
    Airport? newFromAirport;
    if (multiDestinationLegs.isNotEmpty) {
      newFromAirport = multiDestinationLegs.last.toAirport;
    } else {
      newFromAirport = toAirport;
    }
    multiDestinationLegs.add(MultiDestinationLeg(
      fromAirport: newFromAirport,
      toAirport: null,
      departureDate: null,
    ));
    notifyListeners();
  }

  /// Update passenger counts and class from bottom sheet result
  void updatePassengers(Map<String, dynamic> result) {
    adultCount = result['adultCount'] as int;
    childCount = result['childCount'] as int;
    infantCount = result['infantCount'] as int;
    youngCount = result['youngCount'] as int;
    seniorCount = result['seniorCount'] as int;
    selectedClass = result['selectedClass'] as String;
    notifyListeners();
  }

  /// Set toggle values
  void setDirectFlight(bool value) {
    isDirectFlight = value;
    notifyListeners();
  }

  void setWithBaggage(bool value) {
    withBaggage = value;
    notifyListeners();
  }

  /// Set slider indices
  void setAdvantageIndex(int index) {
    currentAdvantageIndex = index;
    notifyListeners();
  }

  void setOfferIndex(int index) {
    currentOfferIndex = index;
    notifyListeners();
  }

  /// Load slider data with translations
  void loadSliderData(lang.S t) {
    advantageSliders = [
      AdvantageSliderItem(
        id: '1',
        backgroundImage: 'assets/home1.png',
        iconImage: 'assets/garantie.png',
        title: t.homeAdvantageTitle1,
        subtitle: t.homeAdvantageSubtitle1,
      ),
      AdvantageSliderItem(
        id: '2',
        backgroundImage: 'assets/home1.png',
        iconImage: 'assets/garantie.png',
        title: t.homeAdvantageTitle2,
        subtitle: t.homeAdvantageSubtitle2,
      ),
    ];

    offerSliders = [
      OfferSliderItem(id: '1', backgroundImage: 'assets/home2.png'),
      OfferSliderItem(id: '2', backgroundImage: 'assets/home2.png'),
    ];
  }

  /// Initialize default values
  void initDefaults() {
    fromAirport = airports.firstWhere(
      (a) => a.code == "ALG",
      orElse: () => airports.first,
    );
    toAirport = null;

    departureDate = DateTime.now();
    returnDate = DateTime.now().add(const Duration(days: 1));
    _selectedDateRange = DateTimeRange(start: departureDate!, end: returnDate!);
  }
}
