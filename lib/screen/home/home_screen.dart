import 'package:flight_booking/Model/Airport.dart';
import 'package:flight_booking/screen/widgets/SearchBottomSheet.dart';
import 'package:flight_booking/screen/widgets/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flight_booking/generated/l10n.dart' as lang;
import 'package:intl/intl.dart';

import '../../controllers/flight_controller.dart';
import '../../models/models.dart';
import '../search/search.dart';
import '../search/search_result.dart';
import '../widgets/button_global.dart';
import '../widgets/CustomDatePicker.dart';
import '../widgets/flight_search_loading.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

/// Model for advantage slider items - dynamic for future API
class AdvantageSliderItem {
  final String id;
  final String backgroundImage;
  final String? iconImage;
  final String title;
  final String subtitle;

  AdvantageSliderItem({
    required this.id,
    required this.backgroundImage,
    this.iconImage,
    required this.title,
    required this.subtitle,
  });

  factory AdvantageSliderItem.fromJson(Map<String, dynamic> json) {
    return AdvantageSliderItem(
      id: json['id'] ?? '',
      backgroundImage: json['background_image'] ?? '',
      iconImage: json['icon_image'],
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
    );
  }
}

/// Model for offer slider items - dynamic for future API
class OfferSliderItem {
  final String id;
  final String backgroundImage;
  final VoidCallback? onTap;

  OfferSliderItem({
    required this.id,
    required this.backgroundImage,
    this.onTap,
  });

  factory OfferSliderItem.fromJson(Map<String, dynamic> json) {
    return OfferSliderItem(
      id: json['id'] ?? '',
      backgroundImage: json['background_image'] ?? '',
    );
  }
}

/// Model for multi-destination flight leg
class MultiDestinationLeg {
  Airport? fromAirport;
  Airport? toAirport;
  DateTime? departureDate;

  MultiDestinationLeg({
    this.fromAirport,
    this.toAirport,
    this.departureDate,
  });
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  TabController? tabController;

  // Flight controller for API calls
  final FlightController _flightController = FlightController();
  bool _isSearching = false;

  // Slider controllers and indices
  final PageController _advantagesPageController = PageController();
  final PageController _offersPageController = PageController();
  int _currentAdvantageIndex = 0;
  int _currentOfferIndex = 0;

  // Dynamic slider data - can be replaced with API call
  late List<AdvantageSliderItem> _advantageSliders;
  late List<OfferSliderItem> _offerSliders;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this, initialIndex: 0);

    // Default airports (Algeria -> Tunisia)
    fromAirport = airports.firstWhere((a) => a.code == "ALG", orElse: () => airports.first);
    toAirport = airports.firstWhere((a) => a.code == "TUN", orElse: () => airports.first);

    // Initialize slider data - replace with API call in future
    _loadSliderData();
  }

  /// Load slider data - replace with API call in future
  void _loadSliderData() {
    _advantageSliders = [
      AdvantageSliderItem(
        id: '1',
        backgroundImage: 'assets/home1.png',
        iconImage: 'assets/garantie.png',
        title: 'Obtenez le meilleur prix',
        subtitle: 'à chaque fois',
      ),
      AdvantageSliderItem(
        id: '2',
        backgroundImage: 'assets/home1.png',
        iconImage: 'assets/garantie.png',
        title: 'Service client 24/7',
        subtitle: 'à votre écoute',
      ),
    ];

    _offerSliders = [
      OfferSliderItem(
        id: '1',
        backgroundImage: 'assets/home2.png',
      ),
      OfferSliderItem(
        id: '2',
        backgroundImage: 'assets/home2.png',
      ),
    ];
  }

  @override
  void dispose() {
    _advantagesPageController.dispose();
    _offersPageController.dispose();
    super.dispose();
  }

  List<Widget> flights = [];
  Airport? fromAirport;
  Airport? toAirport;

  // Multi-destination legs - each leg has its own airports and date
  List<MultiDestinationLeg> multiDestinationLegs = [];

  int adultCount = 1;
  int childCount = 0;
  int infantCount = 0;
  int flightNumber = 0;
  bool showCounter = false;
  int selectedIndex = 0; // Default to Aller-retour (Round-trip) at index 0

  List<String> classKeys = ['first', 'business', 'premium_economy', 'economy'];
  String selectedClass = 'economy';
  // String selectedClass = 'Economy';

  String _getClassDisplayName(String classKey) {
    switch (classKey) {
      case 'first':
        return 'Première';
      case 'business':
        return 'Affaires';
      case 'premium_economy':
        return 'Éco Premium';
      case 'economy':
      default:
        return 'Économique';
    }
  }

  DateTime? departureDate;
  DateTime? returnDate;
  bool isFlexibleDates = false;
  DateTimeRange? _selectedDateRange;

  DateTime selectedDate = DateTime.now();

  // Toggle switches for direct flights and baggage
  bool isDirectFlight = false;
  bool withBaggage = false;

  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: selectedDate,
  //     lastDate: DateTime(2101),
  //   );
  //   if (picked != null && picked != selectedDate) {
  //     setState(() {
  //       selectedDate = picked;
  //       departureDateTitle = selectedDate.toString().substring(0, 10);
  //     });
  //   }
  // }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final locale = Localizations.localeOf(context).languageCode;
    return DateFormat('dd MMM', locale).format(date);
  }

  // Show loading screen and search one-way flights
  void _showLoadingAndSearchOneWay() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlightSearchLoading(
          destinationCity: toAirport?.city ?? 'Destination',
          searchFunction: () => _performOneWaySearch(),
          onSearchComplete: () {
            Navigator.pop(context); // Pop loading screen
            if (!_flightController.hasError) {
              SearchResult(
                fromAirport: fromAirport!,
                toAirport: toAirport!,
                adultCount: adultCount,
                childCount: childCount,
                infantCount: infantCount,
                dateRange: departureDate != null
                    ? DateTimeRange(start: departureDate!, end: departureDate!)
                    : null,
                flightOffers: _flightController.offers,
                isOneWay: true,
              ).launch(context);
            } else {
              toast(_flightController.errorMessage ?? 'Erreur lors de la recherche');
            }
          },
        ),
      ),
    );
  }

  // Perform the actual one-way search API call
  Future<void> _performOneWaySearch() async {
    await _flightController.searchOneWay(
      fromAirport: fromAirport!,
      toAirport: toAirport!,
      departureDate: departureDate!,
      adultCount: adultCount,
      childCount: childCount,
      infantCount: infantCount,
      cabinClass: selectedClass,
      directOnly: isDirectFlight,
      withBaggage: withBaggage,
    );
  }

  // Show loading screen and search round-trip flights
  void _showLoadingAndSearchRoundTrip() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlightSearchLoading(
          destinationCity: toAirport?.city ?? 'Destination',
          searchFunction: () => _performRoundTripSearch(),
          onSearchComplete: () {
            Navigator.pop(context); // Pop loading screen
            if (!_flightController.hasError) {
              SearchResult(
                fromAirport: fromAirport!,
                toAirport: toAirport!,
                adultCount: adultCount,
                childCount: childCount,
                infantCount: infantCount,
                dateRange: _selectedDateRange,
                flightOffers: _flightController.offers,
                isOneWay: false,
              ).launch(context);
            } else {
              toast(_flightController.errorMessage ?? 'Erreur lors de la recherche');
            }
          },
        ),
      ),
    );
  }

  // Perform the actual round-trip search API call
  Future<void> _performRoundTripSearch() async {
    await _flightController.searchRoundTrip(
      fromAirport: fromAirport!,
      toAirport: toAirport!,
      departureDate: departureDate!,
      returnDate: returnDate!,
      adultCount: adultCount,
      childCount: childCount,
      infantCount: infantCount,
      cabinClass: selectedClass,
      directOnly: isDirectFlight,
      withBaggage: withBaggage,
    );
  }

  // Legacy search methods (kept for compatibility)
  Future<void> _searchOneWayFlights() async {
    _showLoadingAndSearchOneWay();
  }

  Future<void> _searchRoundTripFlights() async {
    _showLoadingAndSearchRoundTrip();
  }

  // Search multi-destination flights using the API
  Future<void> _searchMultiDestinationFlights() async {
    setState(() => _isSearching = true);

    try {
      // Build bounds from all multi-destination legs
      final bounds = <FlightBound>[];

      // Helper function to format date
      String formatDate(DateTime date) {
        return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      }

      // First leg: from the main from/to airports with departure date
      if (fromAirport != null && toAirport != null && departureDate != null) {
        bounds.add(FlightBound(
          origin: fromAirport!.code,
          destination: toAirport!.code,
          departureDate: formatDate(departureDate!),
        ));
      }

      // Add additional legs from multiDestinationLegs list
      for (final leg in multiDestinationLegs) {
        if (leg.fromAirport != null && leg.toAirport != null && leg.departureDate != null) {
          bounds.add(FlightBound(
            origin: leg.fromAirport!.code,
            destination: leg.toAirport!.code,
            departureDate: formatDate(leg.departureDate!),
          ));
        }
      }

      // Validate that we have at least 2 legs for multi-destination
      if (bounds.length < 2) {
        toast('Veuillez ajouter au moins 2 vols pour une recherche multi-destination.');
        setState(() => _isSearching = false);
        return;
      }

      await _flightController.searchMultiDestination(
        bounds: bounds,
        adultCount: adultCount,
        childCount: childCount,
        infantCount: infantCount,
        cabinClass: selectedClass,
        directOnly: isDirectFlight,
        withBaggage: withBaggage,
      );

      if (_flightController.hasError) {
        toast(_flightController.errorMessage ?? 'Erreur lors de la recherche');
      } else {
        // Navigate to SearchResult with the flight offers
        SearchResult(
          fromAirport: fromAirport!,
          toAirport: toAirport!,
          adultCount: adultCount,
          childCount: childCount,
          infantCount: infantCount,
          dateRange: departureDate != null
              ? DateTimeRange(start: departureDate!, end: departureDate!)
              : null,
          flightOffers: _flightController.offers,
          isOneWay: false,
          isMultiDestination: true,
        ).launch(context);
      }
    } catch (e) {
      toast('Erreur: $e');
    } finally {
      setState(() => _isSearching = false);
    }
  }

  // Build widget for a multi-destination leg
  Widget _buildMultiDestinationLegWidget(MultiDestinationLeg leg, int index) {
    return Container(
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                children: [
                  // From airport
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: InkWell(
                      onTap: () async {
                        final result = await showModalBottomSheet<Airport>(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                          ),
                          builder: (_) => const SearchBottomSheet(),
                        );

                        if (result != null) {
                          setState(() {
                            multiDestinationLegs[index].fromAirport = result;
                          });
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.flight_takeoff,
                              color: kPrimaryColor,
                              size: 26,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Lieu de départ',
                                    style: kTextStyle.copyWith(
                                      color: Colors.grey.shade600,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    leg.fromAirport != null
                                        ? '${leg.fromAirport!.city} (${leg.fromAirport!.code})'
                                        : 'Sélectionner un aéroport',
                                    style: kTextStyle.copyWith(
                                      color: kTitleColor,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // To airport
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: InkWell(
                      onTap: () async {
                        final result = await showModalBottomSheet<Airport>(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                          ),
                          builder: (_) => const SearchBottomSheet(),
                        );

                        if (result != null) {
                          setState(() {
                            multiDestinationLegs[index].toAirport = result;
                          });
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.flight_land,
                              color: kPrimaryColor,
                              size: 26,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Destination',
                                    style: kTextStyle.copyWith(
                                      color: Colors.grey.shade600,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    leg.toAirport != null
                                        ? '${leg.toAirport!.city} (${leg.toAirport!.code})'
                                        : 'Sélectionner un aéroport',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: kTextStyle.copyWith(
                                      color: kTitleColor,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Positioned swap button
              Positioned(
                right: 12,
                top: 0,
                bottom: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        final temp = multiDestinationLegs[index].fromAirport;
                        multiDestinationLegs[index].fromAirport = multiDestinationLegs[index].toAirport;
                        multiDestinationLegs[index].toAirport = temp;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: kPrimaryColor,
                      ),
                      child: Image.asset(
                        'images/double-fleche.png',
                        width: 22,
                        height: 22,
                        color: kWhite,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          // Date picker for this leg
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: InkWell(
              onTap: () => _showLegDatePicker(index),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                child: Row(
                  children: [
                    const Icon(
                      IconlyLight.calendar,
                      color: kPrimaryColor,
                      size: 26,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Départ',
                            style: kTextStyle.copyWith(
                              color: Colors.grey.shade600,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            leg.departureDate != null
                                ? DateFormat('dd MMM yyyy', 'fr').format(leg.departureDate!)
                                : 'Sélectionner une date',
                            style: kTextStyle.copyWith(
                              color: kTitleColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Show date picker for a specific multi-destination leg
  void _showLegDatePicker(int legIndex) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CustomDatePicker(
        initialStartDate: multiDestinationLegs[legIndex].departureDate,
        initialEndDate: null,
        isRoundTrip: false,
      ),
    );

    if (result != null) {
      setState(() {
        multiDestinationLegs[legIndex].departureDate = result['departure'] as DateTime?;
      });
    }
  }

  void _showCustomDatePicker() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CustomDatePicker(
        initialStartDate: departureDate,
        initialEndDate: returnDate,
        isRoundTrip: selectedIndex == 0,
      ),
    );

    if (result != null) {
      setState(() {
        departureDate = result['departure'] as DateTime?;
        // Only set return date for round-trip (Aller-retour)
        if (selectedIndex == 0) {
          returnDate = result['return'] as DateTime?;
          isFlexibleDates = result['flexible'] as bool? ?? false;
        } else {
          // For one-way (Aller simple), always clear return date
          returnDate = null;
          isFlexibleDates = false;
        }

        // Update the DateTimeRange for compatibility with SearchResult
        if (departureDate != null && returnDate != null) {
          _selectedDateRange = DateTimeRange(
            start: departureDate!,
            end: returnDate!,
          );
        }
      });
    }
  }

  // void _showReturnDate() async {
  //   final DateTimeRange? result = await showDateRangePicker(
  //     context: context,
  //     firstDate: selectedDate,
  //     lastDate: DateTime(2030, 12, 31),
  //     currentDate: DateTime.now(),
  //     saveText: 'Done',
  //   );
  //   if (result != null && result != _selectedDateRange) {
  //     setState(
  //       () {
  //         _selectedDateRange = result;
  //         returnDateTitle = _selectedDateRange.toString().substring(26, 36);
  //       },
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: DefaultTabController(
        initialIndex: 0,
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // Background image with opacity
              Positioned.fill(
                child: Opacity(
                  opacity: 0.2,
                  child: Image.asset(
                    'images/background-home.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Column(
                children: [
          Container(
            height: 290,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
              ),
              child: Stack(
                children: [
                  // Solid orange background
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFFF5100),
                            Color(0xFFFF5100),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Background image on top
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.8,
                      child: Image.asset(
                        'images/background-home.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Content
                  Padding(
              padding: const EdgeInsets.only(top: 50.0, left: 15.0, right: 15.0, bottom: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with logo and notification
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Image.asset(
                          'images/logo-h24-v2.png',
                          height: 40,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: const BoxDecoration(
                          color: Color(0xFFE14900),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.notifications,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Flight icon with text
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: const BoxDecoration(
                          color: Color(0xFFE14900),
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          'images/avion.png',
                          width: 24,
                          height: 24,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Réserver votre vol',
                        style: kTextStyle.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
                ],
              ),
            ),
          )

          ],
              ),
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 178, left: 15.0, right: 15),
                      child: Material(
                        borderRadius: BorderRadius.circular(30.0),
                        elevation: 2,
                        shadowColor: kDarkWhite,
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: kWhite,
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TabBar(
                                controller: tabController,
                                labelPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                                labelStyle: kTextStyle.copyWith(
                                  color: kTitleColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  height: 0.8,
                                ),
                                unselectedLabelStyle: kTextStyle.copyWith(
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                  height: 0.8,
                                ),
                                unselectedLabelColor: kTitleColor,
                                labelColor: kTitleColor,
                                indicatorColor: kPrimaryColor,
                                indicatorWeight: 4.0,
                                indicatorSize: TabBarIndicatorSize.label,
                                dividerColor: Colors.transparent,
                                indicator: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(3.0),
                                    topRight: Radius.circular(3.0),
                                  ),
                                  border: const Border(
                                    bottom: BorderSide(
                                      color: kPrimaryColor,
                                      width: 4.0,
                                    ),
                                  ),
                                ),
                                onTap: (index) {
                                  setState(() {
                                    selectedIndex = index;
                                    // Clear return date when switching to "Aller simple" (one-way)
                                    if (index == 1) {
                                      returnDate = null;
                                      _selectedDateRange = null;
                                    }
                                  });
                                },
                                tabs: [
                                  Tab(
                                    height: 32,
                                    text: lang.S.of(context).tab2,
                                  ),
                                  Tab(
                                    height: 32,
                                    text: lang.S.of(context).tab1,
                                  ),
                                  Tab(
                                    height: 32,
                                    text: lang.S.of(context).tab3,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20.0),
                              Column(
                                children: [
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                  Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF5F5F5),
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        child: InkWell(
                                          onTap: () async {
                                            final result = await showModalBottomSheet<Airport>(
                                              context: context,
                                              isScrollControlled: true,
                                              backgroundColor: Colors.transparent,
                                              shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                                              ),
                                              builder: (_) => const SearchBottomSheet(),
                                            );

                                            if (result != null) {
                                              setState(() {
                                                fromAirport = result;
                                              });
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.flight_takeoff,
                                                  color: kPrimaryColor,
                                                  size: 26,
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        'Lieu de départ',
                                                        style: kTextStyle.copyWith(
                                                          color: Colors.grey.shade600,
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 2),
                                                      Text(
                                                        fromAirport != null
                                                            ? '${fromAirport!.city} (${fromAirport!.code}- tous les aéroports)'
                                                            : 'Paris (PAR- tous les aéroports)',
                                                        style: kTextStyle.copyWith(
                                                          color: kTitleColor,
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12), // Space between the two inputs
                                      Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF5F5F5),
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        child: InkWell(
                                          onTap: () async {
                                            final result = await showModalBottomSheet<Airport>(
                                              context: context,
                                              isScrollControlled: true,
                                              backgroundColor: Colors.transparent,
                                              shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                                              ),
                                              builder: (_) => const SearchBottomSheet(),
                                            );

                                            if (result != null) {
                                              setState(() {
                                                toAirport = result;
                                              });
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.flight_land,
                                                  color: kPrimaryColor,
                                                  size: 26,
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        'Destination',
                                                        style: kTextStyle.copyWith(
                                                          color: Colors.grey.shade600,
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 2),
                                                      Text(
                                                        toAirport != null
                                                            ? '${toAirport!.city} (${toAirport!.code}-aéroport ..)'
                                                            : 'Tunis (TUN-aéroport ..)',
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: kTextStyle.copyWith(
                                                          color: kTitleColor,
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Positioned swap button - overlapping both inputs
                                  Positioned(
                                    right: 12,
                                    top: 0,
                                    bottom: 0,
                                    child: Center(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            // Swap the airports
                                            final temp = fromAirport;
                                            fromAirport = toAirport;
                                            toAirport = temp;
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(10.0),
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: kPrimaryColor,
                                          ),
                                          child: Image.asset(
                                            'images/double-fleche.png',
                                            width: 22,
                                            height: 22,
                                            color: kWhite,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10.0),
                              // For Aller-retour: Show both dates side by side
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF5F5F5),
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          _showCustomDatePicker();
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                IconlyLight.calendar,
                                                color: kPrimaryColor,
                                                size: 26,
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      'Départ',
                                                      style: kTextStyle.copyWith(
                                                        color: Colors.grey.shade600,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Text(
                                                      departureDate != null
                                                          ? DateFormat('dd MMM yyyy', 'fr').format(departureDate!)
                                                          : '14 jan. 2026',
                                                      style: kTextStyle.copyWith(
                                                        color: kTitleColor,
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10.0).visible(selectedIndex == 0),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF5F5F5),
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          _showCustomDatePicker();
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                IconlyLight.calendar,
                                                color: kPrimaryColor,
                                                size: 26,
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      'Retour',
                                                      style: kTextStyle.copyWith(
                                                        color: Colors.grey.shade600,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Text(
                                                      returnDate != null
                                                          ? DateFormat('dd MMM yyyy', 'fr').format(returnDate!)
                                                          : '14 jan. 2026',
                                                      style: kTextStyle.copyWith(
                                                        color: kTitleColor,
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ).visible(selectedIndex == 0),
                                ],
                              ),
                              const SizedBox(height: 10.0),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                isScrollControlled: true,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                context: context,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(
                                    builder: (BuildContext context, setStated) {
                                    return Container(
                                      constraints: BoxConstraints(
                                        maxHeight: MediaQuery.of(context).size.height * 0.85,
                                      ),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(20.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        lang.S.of(context).travellerTitle,
                                                        style: kTextStyle.copyWith(
                                                          color: kTitleColor,
                                                          fontSize: 18.0,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      const Icon(
                                                        FeatherIcons.x,
                                                        size: 18.0,
                                                        color: kTitleColor,
                                                      ).onTap(() => finish(context)),
                                                    ],
                                                  ),
                                                  Text(
                                                    'Algerie a Tunisie, Jeu. 8 janv. 2026',
                                                    style: kTextStyle.copyWith(color: kSubTitleColor),
                                                  ),
                                                ],
                                              ),
                                            ),
                                        Container(
                                          padding: const EdgeInsets.all(20.0),
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(30.0),
                                              topLeft: Radius.circular(30.0),
                                            ),
                                            color: kWhite,
                                            boxShadow: [
                                              BoxShadow(
                                                color: kDarkWhite,
                                                spreadRadius: 5.0,
                                                blurRadius: 7.0,
                                                offset: Offset(0, -5),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              // 👨 Adults
                                              Row(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(lang.S.of(context).adults,
                                                          style: kTextStyle.copyWith(
                                                              color: kTitleColor,
                                                              fontWeight: FontWeight.bold)),
                                                      Text('12 ans et plus',
                                                          style: kTextStyle.copyWith(
                                                              color: kSubTitleColor)),
                                                    ],
                                                  ),
                                                  const Spacer(),
                                                  _counterButton(
                                                    icon: FeatherIcons.minus,
                                                    enabled: adultCount > 1,
                                                    onTap: () {
                                                      setStated(() {
                                                        if (adultCount > 1) adultCount--;
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(adultCount.toString()),
                                                  const SizedBox(width: 10),
                                                  _counterButton(
                                                    icon: FeatherIcons.plus,
                                                    enabled: (adultCount + childCount + infantCount) < 9,
                                                    onTap: () {
                                                      setStated(() {
                                                        if ((adultCount + childCount + infantCount) < 9) {
                                                          adultCount++;
                                                        }
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                              const Divider(thickness: 1.0, color: kBorderColorTextField),
                                              const SizedBox(height: 15),

                                              // 👶 Child
                                              Row(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(lang.S.of(context).child,
                                                          style: kTextStyle.copyWith(
                                                              color: kTitleColor,
                                                              fontWeight: FontWeight.bold)),
                                                      Text('2-12 ans',
                                                          style: kTextStyle.copyWith(
                                                              color: kSubTitleColor)),
                                                    ],
                                                  ),
                                                  const Spacer(),
                                                  _counterButton(
                                                    icon: FeatherIcons.minus,
                                                    enabled: childCount > 0,
                                                    onTap: () {
                                                      setStated(() {
                                                        if (childCount > 0) childCount--;
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(childCount.toString()),
                                                  const SizedBox(width: 10),
                                                  _counterButton(
                                                    icon: FeatherIcons.plus,
                                                    enabled: (adultCount + childCount + infantCount) < 9,
                                                    onTap: () {
                                                      setStated(() {
                                                        if ((adultCount + childCount + infantCount) < 9) {
                                                          childCount++;
                                                        }
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                              const Divider(thickness: 1.0, color: kBorderColorTextField),
                                              const SizedBox(height: 15),

                                              // 🍼 Infants
                                              Row(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(lang.S.of(context).infants,
                                                          style: kTextStyle.copyWith(
                                                              color: kTitleColor,
                                                              fontWeight: FontWeight.bold)),
                                                      Text('Moins de 2 ans',
                                                          style: kTextStyle.copyWith(
                                                              color: kSubTitleColor)),
                                                    ],
                                                  ),
                                                  const Spacer(),
                                                  _counterButton(
                                                    icon: FeatherIcons.minus,
                                                    enabled: infantCount > 0,
                                                    onTap: () {
                                                      setStated(() {
                                                        if (infantCount > 0) infantCount--;
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(infantCount.toString()),
                                                  const SizedBox(width: 10),
                                                  _counterButton(
                                                    icon: FeatherIcons.plus,
                                                    enabled: (adultCount + childCount + infantCount) < 9,
                                                    onTap: () {
                                                      setStated(() {
                                                        if ((adultCount + childCount + infantCount) < 9) {
                                                          infantCount++;
                                                        }
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                              const Divider(thickness: 1.0, color: kBorderColorTextField),
                                              const SizedBox(height: 30),

                                              // 🎫 Class Selection Header
                                              Row(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'Classe de cabine',
                                                        style: kTextStyle.copyWith(
                                                          color: kTitleColor,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Sélectionnez votre classe de voyage',
                                                        style: kTextStyle.copyWith(color: kSubTitleColor),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const Divider(thickness: 1.0, color: kBorderColorTextField),
                                              const SizedBox(height: 10),

                                              // First Class (F)
                                              ListTile(
                                                contentPadding: EdgeInsets.zero,
                                                title: Text(
                                                  'Première classe (F)',
                                                  style: kTextStyle.copyWith(
                                                    color: kTitleColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                subtitle: Text(
                                                  'Luxe absolu et service personnalisé',
                                                  style: kTextStyle.copyWith(color: kSubTitleColor),
                                                ),
                                                trailing: selectedClass == 'first'
                                                    ? const Icon(Icons.check_circle, color: kPrimaryColor)
                                                    : const Icon(Icons.radio_button_unchecked, color: kSubTitleColor),
                                                onTap: () {
                                                  setStated(() {
                                                    selectedClass = 'first';
                                                  });
                                                },
                                              ),
                                              const Divider(thickness: 1.0, color: kBorderColorTextField),

                                              // Business Class (B)
                                              ListTile(
                                                contentPadding: EdgeInsets.zero,
                                                title: Text(
                                                  'Classe Affaires (B)',
                                                  style: kTextStyle.copyWith(
                                                    color: kTitleColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                subtitle: Text(
                                                  'Confort premium et services exclusifs',
                                                  style: kTextStyle.copyWith(color: kSubTitleColor),
                                                ),
                                                trailing: selectedClass == 'business'
                                                    ? const Icon(Icons.check_circle, color: kPrimaryColor)
                                                    : const Icon(Icons.radio_button_unchecked, color: kSubTitleColor),
                                                onTap: () {
                                                  setStated(() {
                                                    selectedClass = 'business';
                                                  });
                                                },
                                              ),
                                              const Divider(thickness: 1.0, color: kBorderColorTextField),

                                              // Premium Economy (PE)
                                              ListTile(
                                                contentPadding: EdgeInsets.zero,
                                                title: Text(
                                                  'Économie Premium (PE)',
                                                  style: kTextStyle.copyWith(
                                                    color: kTitleColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                subtitle: Text(
                                                  'Plus d\'espace et de confort',
                                                  style: kTextStyle.copyWith(color: kSubTitleColor),
                                                ),
                                                trailing: selectedClass == 'premium_economy'
                                                    ? const Icon(Icons.check_circle, color: kPrimaryColor)
                                                    : const Icon(Icons.radio_button_unchecked, color: kSubTitleColor),
                                                onTap: () {
                                                  setStated(() {
                                                    selectedClass = 'premium_economy';
                                                  });
                                                },
                                              ),
                                              const Divider(thickness: 1.0, color: kBorderColorTextField),

                                              // Economy Class (E)
                                              ListTile(
                                                contentPadding: EdgeInsets.zero,
                                                title: Text(
                                                  'Économie (E)',
                                                  style: kTextStyle.copyWith(
                                                    color: kTitleColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                subtitle: Text(
                                                  'Tarif standard avec bagages inclus',
                                                  style: kTextStyle.copyWith(color: kSubTitleColor),
                                                ),
                                                trailing: selectedClass == 'economy'
                                                    ? const Icon(Icons.check_circle, color: kPrimaryColor)
                                                    : const Icon(Icons.radio_button_unchecked, color: kSubTitleColor),
                                                onTap: () {
                                                  setStated(() {
                                                    selectedClass = 'economy';
                                                  });
                                                },
                                              ),
                                              const Divider(thickness: 1.0, color: kBorderColorTextField),
                                              const SizedBox(height: 20),

                                              // ✅ Done Button
                                              ButtonGlobal(
                                                buttontext: lang.S.of(context).done,
                                                buttonDecoration: kButtonDecoration.copyWith(
                                                  color: kPrimaryColor,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    finish(context);
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  );
                                  },
                                );
                              },
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.person_outline,
                                  color: kPrimaryColor,
                                  size: 26,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Passager',
                                        style: kTextStyle.copyWith(
                                          color: Colors.grey.shade600,
                                          fontSize: 13,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '$adultCount Adulte, $childCount enfant, $infantCount ${infantCount > 1 ? 's' : ''}',
                                        style: kTextStyle.copyWith(
                                          color: kTitleColor,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                                  const SizedBox(height: 10.0),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF5F5F5),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(30.0),
                                          ),
                                          context: context,
                                          builder: (BuildContext context) {
                                            return StatefulBuilder(
                                              builder: (BuildContext context, setModalState) {
                                                final t = lang.S.of(context);
                                              return Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(20.0),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              t.classTitle,
                                                              style: kTextStyle.copyWith(
                                                                color: kTitleColor,
                                                                fontSize: 18.0,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                            const Spacer(),
                                                            const Icon(
                                                              FeatherIcons.x,
                                                              size: 18.0,
                                                              color: kTitleColor,
                                                            ).onTap(() => finish(context)),
                                                          ],
                                                        ),
                                                        Text(
                                                          'Algerie a Tunisie, Jeu. 8 janv. 2026',
                                                          style: kTextStyle.copyWith(color: kSubTitleColor),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets.all(20.0),
                                                    decoration: const BoxDecoration(
                                                      borderRadius: BorderRadius.only(
                                                        topRight: Radius.circular(30.0),
                                                        topLeft: Radius.circular(30.0),
                                                      ),
                                                      color: kWhite,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: kDarkWhite,
                                                          spreadRadius: 5.0,
                                                          blurRadius: 7.0,
                                                          offset: Offset(0, -5),
                                                        ),
                                                      ],
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        ListTile(
                                                          contentPadding: EdgeInsets.zero,
                                                          title: Text(
                                                            t.classEconomy,
                                                            style: kTextStyle.copyWith(
                                                              color: kTitleColor,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                          trailing: selectedClass == 'economy'
                                                              ? const Icon(Icons.check_circle, color: kPrimaryColor)
                                                              : const Icon(Icons.radio_button_unchecked, color: kSubTitleColor),
                                                          onTap: () {
                                                            setState(() {
                                                              selectedClass = 'economy';
                                                            });
                                                            Navigator.pop(context);
                                                          },
                                                        ),
                                                        const Divider(
                                                          thickness: 1.0,
                                                          color: kBorderColorTextField,
                                                        ),
                                                        ListTile(
                                                          contentPadding: EdgeInsets.zero,
                                                          title: Text(
                                                            t.classBusiness,
                                                            style: kTextStyle.copyWith(
                                                              color: kTitleColor,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                          trailing: selectedClass == 'business'
                                                              ? const Icon(Icons.check_circle, color: kPrimaryColor)
                                                              : const Icon(Icons.radio_button_unchecked, color: kSubTitleColor),
                                                          onTap: () {
                                                            setState(() {
                                                              selectedClass = 'business';
                                                            });
                                                            Navigator.pop(context);
                                                          },
                                                        ),
                                                        const Divider(
                                                          thickness: 1.0,
                                                          color: kBorderColorTextField,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.airline_seat_recline_extra,
                                            color: kPrimaryColor,
                                            size: 26,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  'Classe',
                                                  style: kTextStyle.copyWith(
                                                    color: Colors.grey.shade600,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  selectedClass == 'economy' ? 'Economique' : 'Affaires',
                                                  style: kTextStyle.copyWith(
                                                    color: kTitleColor,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                  const SizedBox(height: 15.0),
                                  // Toggle switches for direct flights and baggage
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              height: 24,
                                              child: Switch(
                                                value: isDirectFlight,
                                                onChanged: (value) {
                                                  setState(() {
                                                    isDirectFlight = value;
                                                  });
                                                },
                                                activeColor: kPrimaryColor,
                                                activeTrackColor: kPrimaryColor.withOpacity(0.3),
                                                inactiveThumbColor: kWhite,
                                                inactiveTrackColor: const Color(0xFFE0E0E0),
                                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Flexible(
                                              child: Text(
                                                'Vols directs',
                                                style: kTextStyle.copyWith(
                                                  color: kTitleColor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              height: 24,
                                              child: Switch(
                                                value: withBaggage,
                                                onChanged: (value) {
                                                  setState(() {
                                                    withBaggage = value;
                                                  });
                                                },
                                                activeColor: kPrimaryColor,
                                                activeTrackColor: kPrimaryColor.withOpacity(0.3),
                                                inactiveThumbColor: kWhite,
                                                inactiveTrackColor: const Color(0xFFE0E0E0),
                                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Flexible(
                                              child: Text(
                                                'Avec bagages',
                                                style: kTextStyle.copyWith(
                                                  color: kTitleColor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15.0),
                                  ButtonGlobalWithoutIcon(
                                    buttontext: _isSearching ? 'Recherche en cours...' : 'Rechercher vols',
                                    buttonDecoration: kButtonDecoration.copyWith(
                                      color: _isSearching ? kPrimaryColor.withOpacity(0.7) : kPrimaryColor,
                                      borderRadius: BorderRadius.circular(100.0),
                                    ),
                                    onPressed: () {
                                      if (_isSearching) return;

                                      if (fromAirport == null || toAirport == null) {
                                        toast('Veuillez sélectionner les aéroports de départ et d\'arrivée.');
                                        return;
                                      }

                                      if (departureDate == null) {
                                        toast('Veuillez sélectionner une date de départ.');
                                        return;
                                      }

                                      // Tab2 (selectedIndex == 0) = Aller-retour (Round-trip)
                                      if (selectedIndex == 0) {
                                        if (returnDate == null) {
                                          toast('Veuillez sélectionner une date de retour.');
                                          return;
                                        }
                                        _searchRoundTripFlights();
                                      }
                                      // Tab1 (selectedIndex == 1) = Aller simple (One-way)
                                      else if (selectedIndex == 1) {
                                        _searchOneWayFlights();
                                      }
                                    },
                                    buttonTextColor: kWhite,
                                  )
                                ],
                              ).visible(selectedIndex != 2),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  // Vol 1 header
                                  Row(
                                    children: [
                                      Text(
                                        '${lang.S.of(context).flight} 1',
                                        style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5.0),
                                  // Vol 1 - From/To airports
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF5F5F5),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            child: InkWell(
                                              onTap: () async {
                                                final result = await showModalBottomSheet<Airport>(
                                                  context: context,
                                                  isScrollControlled: true,
                                                  backgroundColor: Colors.transparent,
                                                  shape: const RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                                                  ),
                                                  builder: (_) => const SearchBottomSheet(),
                                                );

                                                if (result != null) {
                                                  setState(() {
                                                    fromAirport = result;
                                                  });
                                                }
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.flight_takeoff,
                                                      color: kPrimaryColor,
                                                      size: 26,
                                                    ),
                                                    const SizedBox(width: 12),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                            'Lieu de départ',
                                                            style: kTextStyle.copyWith(
                                                              color: Colors.grey.shade600,
                                                              fontSize: 13,
                                                            ),
                                                          ),
                                                          const SizedBox(height: 2),
                                                          Text(
                                                            fromAirport != null
                                                                ? '${fromAirport!.city} (${fromAirport!.code})'
                                                                : 'Sélectionner un aéroport',
                                                            style: kTextStyle.copyWith(
                                                              color: kTitleColor,
                                                              fontSize: 13,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF5F5F5),
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            child: InkWell(
                                              onTap: () async {
                                                final result = await showModalBottomSheet<Airport>(
                                                  context: context,
                                                  isScrollControlled: true,
                                                  backgroundColor: Colors.transparent,
                                                  shape: const RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                                                  ),
                                                  builder: (_) => const SearchBottomSheet(),
                                                );

                                                if (result != null) {
                                                  setState(() {
                                                    toAirport = result;
                                                  });
                                                }
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.flight_land,
                                                      color: kPrimaryColor,
                                                      size: 26,
                                                    ),
                                                    const SizedBox(width: 12),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                            'Destination',
                                                            style: kTextStyle.copyWith(
                                                              color: Colors.grey.shade600,
                                                              fontSize: 13,
                                                            ),
                                                          ),
                                                          const SizedBox(height: 2),
                                                          Text(
                                                            toAirport != null
                                                                ? '${toAirport!.city} (${toAirport!.code})'
                                                                : 'Sélectionner un aéroport',
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: kTextStyle.copyWith(
                                                              color: kTitleColor,
                                                              fontSize: 13,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Positioned swap button
                                      Positioned(
                                        right: 12,
                                        top: 0,
                                        bottom: 0,
                                        child: Center(
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                final temp = fromAirport;
                                                fromAirport = toAirport;
                                                toAirport = temp;
                                              });
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(10.0),
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: kPrimaryColor,
                                              ),
                                              child: Image.asset(
                                                'images/double-fleche.png',
                                                width: 22,
                                                height: 22,
                                                color: kWhite,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5.0),
                                  // Vol 1 - Date picker
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF5F5F5),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        _showCustomDatePicker();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              IconlyLight.calendar,
                                              color: kPrimaryColor,
                                              size: 26,
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    'Départ',
                                                    style: kTextStyle.copyWith(
                                                      color: Colors.grey.shade600,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    departureDate != null
                                                        ? DateFormat('dd MMM yyyy', 'fr').format(departureDate!)
                                                        : 'Sélectionner une date',
                                                    style: kTextStyle.copyWith(
                                                      color: kTitleColor,
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Multi-destination legs list
                                  ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: multiDestinationLegs.length,
                                      itemBuilder: (_, i) {
                                        final leg = multiDestinationLegs[i];
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  '${lang.S.of(context).flight} ${i + 2}',
                                                  style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                                ),
                                                const Spacer(),
                                                GestureDetector(
                                                  child: const Icon(
                                                    FeatherIcons.x,
                                                    color: kSubTitleColor,
                                                  ),
                                                  onTap: () {
                                                    setState(() {
                                                      multiDestinationLegs.removeAt(i);
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                            _buildMultiDestinationLegWidget(leg, i),
                                          ],
                                        );
                                      }),
                                  const SizedBox(height: 10.0),
                                  ButtonGlobalWithoutIcon(
                                    buttontext: lang.S.of(context).addFightButton,
                                    buttonDecoration: kButtonDecoration.copyWith(
                                      color: kWhite,
                                      border: Border.all(color: kPrimaryColor),
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        // Add a new leg with the previous leg's destination as the new origin
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
                                      });
                                    },
                                    buttonTextColor: kPrimaryColor,
                                  ),
                                  const SizedBox(height: 10.0),
                                  // Passenger selector
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF5F5F5),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: InkWell(
                                      onTap: () => showModalBottomSheet(
                                        isScrollControlled: true,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30.0),
                                        ),
                                        context: context,
                                        builder: (BuildContext context) {
                                          return StatefulBuilder(builder: (BuildContext context, setStated) {
                                            return Container(
                                              constraints: BoxConstraints(
                                                maxHeight: MediaQuery.of(context).size.height * 0.85,
                                              ),
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.all(20.0),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                lang.S.of(context).travellerTitle,
                                                                style: kTextStyle.copyWith(
                                                                  color: kTitleColor,
                                                                  fontSize: 18.0,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                              const Spacer(),
                                                              const Icon(
                                                                FeatherIcons.x,
                                                                size: 18.0,
                                                                color: kTitleColor,
                                                              ).onTap(() => finish(context)),
                                                            ],
                                                          ),
                                                          Text(
                                                            '${fromAirport?.city ?? 'Départ'} à ${toAirport?.city ?? 'Destination'}',
                                                            style: kTextStyle.copyWith(color: kSubTitleColor),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                Container(
                                                  padding: const EdgeInsets.all(20.0),
                                                  decoration: const BoxDecoration(
                                                    borderRadius: BorderRadius.only(
                                                      topRight: Radius.circular(30.0),
                                                      topLeft: Radius.circular(30.0),
                                                    ),
                                                    color: kWhite,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: kDarkWhite,
                                                        spreadRadius: 5.0,
                                                        blurRadius: 7.0,
                                                        offset: Offset(0, -5),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      /// Adults
                                                      Row(
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                lang.S.of(context).adults,
                                                                style: kTextStyle.copyWith(
                                                                    color: kTitleColor,
                                                                    fontWeight: FontWeight.bold),
                                                              ),
                                                              Text(
                                                                '12 ans et plus',
                                                                style:
                                                                kTextStyle.copyWith(color: kSubTitleColor),
                                                              ),
                                                            ],
                                                          ),
                                                          const Spacer(),
                                                          Container(
                                                            padding: const EdgeInsets.all(5.0),
                                                            decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              color: adultCount == 1
                                                                  ? kPrimaryColor.withOpacity(0.2)
                                                                  : kPrimaryColor,
                                                            ),
                                                            child: const Icon(
                                                              FeatherIcons.minus,
                                                              color: Colors.white,
                                                              size: 14.0,
                                                            ).onTap(() {
                                                              setStated(() {
                                                                adultCount > 1
                                                                    ? adultCount--
                                                                    : adultCount = 1;
                                                              });
                                                            }),
                                                          ),
                                                          const SizedBox(width: 10.0),
                                                          Text(adultCount.toString()),
                                                          const SizedBox(width: 10.0),
                                                          Container(
                                                            padding: const EdgeInsets.all(5.0),
                                                            decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              color: (adultCount + childCount + infantCount) >= 9
                                                                  ? kPrimaryColor.withOpacity(0.2)
                                                                  : kPrimaryColor,
                                                            ),
                                                            child: const Icon(
                                                              FeatherIcons.plus,
                                                              color: Colors.white,
                                                              size: 14.0,
                                                            ).onTap(() {
                                                              setStated(() {
                                                                if ((adultCount + childCount + infantCount) < 9) {
                                                                  adultCount++;
                                                                }
                                                              });
                                                            }),
                                                          ),
                                                        ],
                                                      ),

                                                      const Divider(color: kBorderColorTextField),
                                                      const SizedBox(height: 15.0),

                                                      /// Children
                                                      Row(
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                lang.S.of(context).child,
                                                                style: kTextStyle.copyWith(
                                                                    color: kTitleColor,
                                                                    fontWeight: FontWeight.bold),
                                                              ),
                                                              Text(
                                                                '2-12 ans',
                                                                style:
                                                                kTextStyle.copyWith(color: kSubTitleColor),
                                                              ),
                                                            ],
                                                          ),
                                                          const Spacer(),
                                                          Container(
                                                            padding: const EdgeInsets.all(5.0),
                                                            decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              color: childCount == 0
                                                                  ? kPrimaryColor.withOpacity(0.2)
                                                                  : kPrimaryColor,
                                                            ),
                                                            child: const Icon(
                                                              FeatherIcons.minus,
                                                              color: Colors.white,
                                                              size: 14.0,
                                                            ).onTap(() {
                                                              setStated(() {
                                                                childCount > 0
                                                                    ? childCount--
                                                                    : childCount = 0;
                                                              });
                                                            }),
                                                          ),
                                                          const SizedBox(width: 10.0),
                                                          Text(childCount.toString()),
                                                          const SizedBox(width: 10.0),
                                                          Container(
                                                            padding: const EdgeInsets.all(5.0),
                                                            decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              color: (adultCount + childCount + infantCount) >= 9
                                                                  ? kPrimaryColor.withOpacity(0.2)
                                                                  : kPrimaryColor,
                                                            ),
                                                            child: const Icon(
                                                              FeatherIcons.plus,
                                                              color: Colors.white,
                                                              size: 14.0,
                                                            ).onTap(() {
                                                              setStated(() {
                                                                if ((adultCount + childCount + infantCount) < 9) {
                                                                  childCount++;
                                                                }
                                                              });
                                                            }),
                                                          ),
                                                        ],
                                                      ),

                                                      const Divider(color: kBorderColorTextField),
                                                      const SizedBox(height: 15.0),

                                                      /// Infants
                                                      Row(
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                lang.S.of(context).infants,
                                                                style: kTextStyle.copyWith(
                                                                    color: kTitleColor,
                                                                    fontWeight: FontWeight.bold),
                                                              ),
                                                              Text(
                                                                'Moins de 2 ans',
                                                                style:
                                                                kTextStyle.copyWith(color: kSubTitleColor),
                                                              ),
                                                            ],
                                                          ),
                                                          const Spacer(),
                                                          Container(
                                                            padding: const EdgeInsets.all(5.0),
                                                            decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              color: infantCount == 0
                                                                  ? kPrimaryColor.withOpacity(0.2)
                                                                  : kPrimaryColor,
                                                            ),
                                                            child: const Icon(
                                                              FeatherIcons.minus,
                                                              color: Colors.white,
                                                              size: 14.0,
                                                            ).onTap(() {
                                                              setStated(() {
                                                                infantCount > 0
                                                                    ? infantCount--
                                                                    : infantCount = 0;
                                                              });
                                                            }),
                                                          ),
                                                          const SizedBox(width: 10.0),
                                                          Text(infantCount.toString()),
                                                          const SizedBox(width: 10.0),
                                                          Container(
                                                            padding: const EdgeInsets.all(5.0),
                                                            decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              color: (adultCount + childCount + infantCount) >= 9
                                                                  ? kPrimaryColor.withOpacity(0.2)
                                                                  : kPrimaryColor,
                                                            ),
                                                            child: const Icon(
                                                              FeatherIcons.plus,
                                                              color: Colors.white,
                                                              size: 14.0,
                                                            ).onTap(() {
                                                              setStated(() {
                                                                if ((adultCount + childCount + infantCount) < 9) {
                                                                  infantCount++;
                                                                }
                                                              });
                                                            }),
                                                          ),
                                                        ],
                                                      ),

                                                      const Divider(color: kBorderColorTextField),
                                                      const SizedBox(height: 30.0),

                                                      // 🎫 Class Selection Header
                                                      Row(
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                'Classe de cabine',
                                                                style: kTextStyle.copyWith(
                                                                  color: kTitleColor,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                              Text(
                                                                'Sélectionnez votre classe de voyage',
                                                                style: kTextStyle.copyWith(color: kSubTitleColor),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      const Divider(thickness: 1.0, color: kBorderColorTextField),
                                                      const SizedBox(height: 10),

                                                      // First Class (F)
                                                      ListTile(
                                                        contentPadding: EdgeInsets.zero,
                                                        title: Text(
                                                          'Première classe (F)',
                                                          style: kTextStyle.copyWith(
                                                            color: kTitleColor,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                        subtitle: Text(
                                                          'Luxe absolu et service personnalisé',
                                                          style: kTextStyle.copyWith(color: kSubTitleColor),
                                                        ),
                                                        trailing: selectedClass == 'first'
                                                            ? const Icon(Icons.check_circle, color: kPrimaryColor)
                                                            : const Icon(Icons.radio_button_unchecked, color: kSubTitleColor),
                                                        onTap: () {
                                                          setStated(() {
                                                            selectedClass = 'first';
                                                          });
                                                        },
                                                      ),
                                                      const Divider(thickness: 1.0, color: kBorderColorTextField),

                                                      // Business Class (B)
                                                      ListTile(
                                                        contentPadding: EdgeInsets.zero,
                                                        title: Text(
                                                          'Classe Affaires (B)',
                                                          style: kTextStyle.copyWith(
                                                            color: kTitleColor,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                        subtitle: Text(
                                                          'Confort premium et services exclusifs',
                                                          style: kTextStyle.copyWith(color: kSubTitleColor),
                                                        ),
                                                        trailing: selectedClass == 'business'
                                                            ? const Icon(Icons.check_circle, color: kPrimaryColor)
                                                            : const Icon(Icons.radio_button_unchecked, color: kSubTitleColor),
                                                        onTap: () {
                                                          setStated(() {
                                                            selectedClass = 'business';
                                                          });
                                                        },
                                                      ),
                                                      const Divider(thickness: 1.0, color: kBorderColorTextField),

                                                      // Premium Economy (PE)
                                                      ListTile(
                                                        contentPadding: EdgeInsets.zero,
                                                        title: Text(
                                                          'Économie Premium (PE)',
                                                          style: kTextStyle.copyWith(
                                                            color: kTitleColor,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                        subtitle: Text(
                                                          'Plus d\'espace et de confort',
                                                          style: kTextStyle.copyWith(color: kSubTitleColor),
                                                        ),
                                                        trailing: selectedClass == 'premium_economy'
                                                            ? const Icon(Icons.check_circle, color: kPrimaryColor)
                                                            : const Icon(Icons.radio_button_unchecked, color: kSubTitleColor),
                                                        onTap: () {
                                                          setStated(() {
                                                            selectedClass = 'premium_economy';
                                                          });
                                                        },
                                                      ),
                                                      const Divider(thickness: 1.0, color: kBorderColorTextField),

                                                      // Economy Class (E)
                                                      ListTile(
                                                        contentPadding: EdgeInsets.zero,
                                                        title: Text(
                                                          'Économie (E)',
                                                          style: kTextStyle.copyWith(
                                                            color: kTitleColor,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                        subtitle: Text(
                                                          'Tarif standard avec bagages inclus',
                                                          style: kTextStyle.copyWith(color: kSubTitleColor),
                                                        ),
                                                        trailing: selectedClass == 'economy'
                                                            ? const Icon(Icons.check_circle, color: kPrimaryColor)
                                                            : const Icon(Icons.radio_button_unchecked, color: kSubTitleColor),
                                                        onTap: () {
                                                          setStated(() {
                                                            selectedClass = 'economy';
                                                          });
                                                        },
                                                      ),
                                                      const Divider(thickness: 1.0, color: kBorderColorTextField),
                                                      const SizedBox(height: 20.0),

                                                      ButtonGlobal(
                                                        buttontext: lang.S.of(context).done,
                                                        buttonDecoration:
                                                        kButtonDecoration.copyWith(color: kPrimaryColor),
                                                        onPressed: () {
                                                          setState(() {
                                                            finish(context);
                                                          });
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          );
                                          });
                                        },
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              FeatherIcons.users,
                                              color: kPrimaryColor,
                                              size: 26,
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    'Voyageurs',
                                                    style: kTextStyle.copyWith(
                                                      color: Colors.grey.shade600,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    '$adultCount Adulte${adultCount > 1 ? 's' : ''}, $childCount Enfant${childCount > 1 ? 's' : ''}, $infantCount Bébé${infantCount > 1 ? 's' : ''}',
                                                    style: kTextStyle.copyWith(
                                                      color: kTitleColor,
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Icon(
                                              IconlyLight.arrowDown2,
                                              color: kSubTitleColor,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10.0),
                                  // Class selector
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF5F5F5),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(30.0),
                                          ),
                                          context: context,
                                          builder: (BuildContext context) {
                                            return StatefulBuilder(
                                              builder: (BuildContext context, setModalState) {
                                                final t = lang.S.of(context);
                                                return Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.all(20.0),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                t.classTitle,
                                                                style: kTextStyle.copyWith(
                                                                  color: kTitleColor,
                                                                  fontSize: 18.0,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                              const Spacer(),
                                                              const Icon(
                                                                FeatherIcons.x,
                                                                size: 18.0,
                                                                color: kTitleColor,
                                                              ).onTap(() => finish(context)),
                                                            ],
                                                          ),
                                                          Text(
                                                            '${fromAirport?.city ?? 'Départ'} à ${toAirport?.city ?? 'Destination'}',
                                                            style: kTextStyle.copyWith(color: kSubTitleColor),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: const EdgeInsets.all(20.0),
                                                      decoration: const BoxDecoration(
                                                        borderRadius: BorderRadius.only(
                                                          topRight: Radius.circular(30.0),
                                                          topLeft: Radius.circular(30.0),
                                                        ),
                                                        color: kWhite,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: kDarkWhite,
                                                            spreadRadius: 5.0,
                                                            blurRadius: 7.0,
                                                            offset: Offset(0, -5),
                                                          ),
                                                        ],
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          ListTile(
                                                            contentPadding: EdgeInsets.zero,
                                                            title: Text(
                                                              t.classEconomy,
                                                              style: kTextStyle.copyWith(
                                                                color: kTitleColor,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                            trailing: selectedClass == 'economy'
                                                                ? const Icon(Icons.check_circle, color: kPrimaryColor)
                                                                : const Icon(Icons.radio_button_unchecked, color: kSubTitleColor),
                                                            onTap: () {
                                                              setState(() {
                                                                selectedClass = 'economy';
                                                              });
                                                              Navigator.pop(context);
                                                            },
                                                          ),
                                                          const Divider(
                                                            thickness: 1.0,
                                                            color: kBorderColorTextField,
                                                          ),
                                                          ListTile(
                                                            contentPadding: EdgeInsets.zero,
                                                            title: Text(
                                                              t.classBusiness,
                                                              style: kTextStyle.copyWith(
                                                                color: kTitleColor,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                            trailing: selectedClass == 'business'
                                                                ? const Icon(Icons.check_circle, color: kPrimaryColor)
                                                                : const Icon(Icons.radio_button_unchecked, color: kSubTitleColor),
                                                            onTap: () {
                                                              setState(() {
                                                                selectedClass = 'business';
                                                              });
                                                              Navigator.pop(context);
                                                            },
                                                          ),
                                                          const Divider(
                                                            thickness: 1.0,
                                                            color: kBorderColorTextField,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.airline_seat_recline_extra,
                                              color: kPrimaryColor,
                                              size: 26,
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    'Classe',
                                                    style: kTextStyle.copyWith(
                                                      color: Colors.grey.shade600,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    selectedClass == 'economy'
                                                        ? lang.S.of(context).classEconomy
                                                        : lang.S.of(context).classBusiness,
                                                    style: kTextStyle.copyWith(
                                                      color: kTitleColor,
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Icon(
                                              IconlyLight.arrowDown2,
                                              color: kSubTitleColor,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10.0),
                                  ButtonGlobalWithoutIcon(
                                    buttontext: lang.S.of(context).searchFlight,
                                    buttonDecoration: kButtonDecoration.copyWith(
                                      color: kPrimaryColor,
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    onPressed: () {
                                      // Validate first leg
                                      if (fromAirport == null || toAirport == null) {
                                        toast('Veuillez sélectionner les aéroports de départ et d\'arrivée pour le vol 1.');
                                        return;
                                      }
                                      if (departureDate == null) {
                                        toast('Veuillez sélectionner une date de départ pour le vol 1.');
                                        return;
                                      }

                                      // Validate additional legs
                                      for (int i = 0; i < multiDestinationLegs.length; i++) {
                                        final leg = multiDestinationLegs[i];
                                        if (leg.fromAirport == null || leg.toAirport == null) {
                                          toast('Veuillez sélectionner les aéroports pour le vol ${i + 2}.');
                                          return;
                                        }
                                        if (leg.departureDate == null) {
                                          toast('Veuillez sélectionner une date pour le vol ${i + 2}.');
                                          return;
                                        }
                                      }

                                      _searchMultiDestinationFlights();
                                    },

                                    buttonTextColor: kWhite,
                                  )
                                ],
                              ).visible(selectedIndex == 2),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    // Nos avantages section - Dynamic Slider
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nos avantages',
                            style: kTextStyle.copyWith(
                              color: kTitleColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                          const SizedBox(height: 15.0),
                          SizedBox(
                            height: 100,
                            child: Stack(
                              children: [
                                PageView.builder(
                                  controller: _advantagesPageController,
                                  itemCount: _advantageSliders.length,
                                  onPageChanged: (index) {
                                    setState(() {
                                      _currentAdvantageIndex = index;
                                    });
                                  },
                                  itemBuilder: (context, index) {
                                    final item = _advantageSliders[index];
                                    return Container(
                                      margin: const EdgeInsets.only(right: 4),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16.0),
                                        image: DecorationImage(
                                          image: AssetImage(item.backgroundImage),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                                        child: Row(
                                          children: [
                                            if (item.iconImage != null)
                                              Image.asset(
                                                item.iconImage!,
                                                width: 50,
                                                height: 50,
                                              ),
                                            const SizedBox(width: 16.0),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    item.title,
                                                    style: kTextStyle.copyWith(
                                                      color: kTitleColor,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 17.0,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4.0),
                                                  Text(
                                                    item.subtitle,
                                                    style: kTextStyle.copyWith(
                                                      color: kTitleColor.withOpacity(0.8),
                                                      fontSize: 15.0,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                // Dots indicator inside image - bottom right
                                Positioned(
                                  bottom: 12,
                                  right: 16,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: List.generate(
                                      _advantageSliders.length,
                                      (index) => AnimatedContainer(
                                        duration: const Duration(milliseconds: 300),
                                        margin: const EdgeInsets.symmetric(horizontal: 3.0),
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: _currentAdvantageIndex == index
                                              ? kPrimaryColor
                                              : Colors.grey.shade400,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25.0),
                    // Nos offres pour vous section - Dynamic Slider
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nos offres pour vous',
                            style: kTextStyle.copyWith(
                              color: kTitleColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                          const SizedBox(height: 15.0),
                          SizedBox(
                            height: 160,
                            child: Stack(
                              children: [
                                PageView.builder(
                                  controller: _offersPageController,
                                  itemCount: _offerSliders.length,
                                  onPageChanged: (index) {
                                    setState(() {
                                      _currentOfferIndex = index;
                                    });
                                  },
                                  itemBuilder: (context, index) {
                                    final item = _offerSliders[index];
                                    return GestureDetector(
                                      onTap: item.onTap,
                                      child: Container(
                                        margin: const EdgeInsets.only(right: 4),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16.0),
                                          image: DecorationImage(
                                            image: AssetImage(item.backgroundImage),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                // Dots indicator inside image - bottom right
                                Positioned(
                                  bottom: 12,
                                  right: 16,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: List.generate(
                                      _offerSliders.length,
                                      (index) => AnimatedContainer(
                                        duration: const Duration(milliseconds: 300),
                                        margin: const EdgeInsets.symmetric(horizontal: 3.0),
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: _currentOfferIndex == index
                                              ? kPrimaryColor
                                              : Colors.grey.shade400,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30.0),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget _counterButton({
    required IconData icon,
    bool enabled = true,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: enabled
            ? kPrimaryColor
            : kPrimaryColor.withOpacity(0.2),
      ),
      child: Icon(icon, color: Colors.white, size: 14.0)
          .onTap(enabled ? onTap : () {}),
    );
  }

}
