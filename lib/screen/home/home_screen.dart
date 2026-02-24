import 'package:flight_booking/screen/widgets/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:flight_booking/generated/l10n.dart' as lang;

import '../../controllers/airport_controller.dart';
import '../../models/models.dart';
import '../search/search_result.dart';
import '../widgets/CustomDatePicker.dart';
import '../widgets/flight_search_loading.dart';
import '../notification/notification_screen.dart';

import 'controller/home_search_controller.dart';
import 'widgets/home_header.dart';
import 'widgets/flight_search_tabs.dart';
import 'widgets/round_trip_form.dart';
import 'widgets/multi_destination_form.dart';
import 'widgets/advantage_slider.dart';
import 'widgets/offer_slider.dart';
import 'widgets/passenger_bottom_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  TabController? tabController;
  late final HomeSearchController _ctrl;

  final PageController _advantagesPageController = PageController();
  final PageController _offersPageController = PageController();

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    _ctrl = context.read<HomeSearchController>();
    _ctrl.initDefaults();
    _ctrl.addListener(_onControllerChanged);
    context.read<AirportController>().preloadAirports();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _ctrl.loadSliderData(lang.S.of(context));
  }

  @override
  void dispose() {
    _ctrl.removeListener(_onControllerChanged);
    _advantagesPageController.dispose();
    _offersPageController.dispose();
    super.dispose();
  }

  void _onControllerChanged() => setState(() {});

  // ── Date pickers ──
  void _showCustomDatePicker() async {
    final isRoundTrip = _ctrl.selectedIndex == 0 || _ctrl.selectedIndex == 2;
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CustomDatePicker(
        initialStartDate: _ctrl.departureDate,
        initialEndDate: _ctrl.returnDate,
        isRoundTrip: isRoundTrip,
      ),
    );
    if (result != null) _ctrl.updateDates(result);
  }

  void _showLegDatePicker(int legIndex) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CustomDatePicker(
        initialStartDate: _ctrl.multiDestinationLegs[legIndex].departureDate,
        initialEndDate: null,
        isRoundTrip: false,
      ),
    );
    if (result != null) _ctrl.updateLegDate(legIndex, result);
  }

  // ── Passenger bottom sheet ──
  void _showPassengerBottomSheet() async {
    final t = lang.S.of(context);
    final result = await PassengerBottomSheet.show(
      context,
      adultCount: _ctrl.adultCount,
      childCount: _ctrl.childCount,
      infantCount: _ctrl.infantCount,
      youngCount: _ctrl.youngCount,
      seniorCount: _ctrl.seniorCount,
      selectedClass: _ctrl.selectedClass,
      classKeys: _ctrl.classKeys,
      getClassDisplayName: (key) => _ctrl.getClassDisplayName(key, t),
    );
    if (result != null) _ctrl.updatePassengers(result);
  }

  // ── Search navigation ──
  void _onSearch() {
    if (_ctrl.isSearching) return;
    final t = lang.S.of(context);

    if (_ctrl.fromAirport == null || _ctrl.toAirport == null) {
      toast(t.homeSelectAirportsError);
      return;
    }
    if (_ctrl.departureDate == null) {
      toast(t.homeSelectDepartureDate);
      return;
    }

    if (_ctrl.selectedIndex == 0) {
      if (_ctrl.returnDate == null) {
        toast(t.homeSelectReturnDate);
        return;
      }
      _showLoadingAndSearchRoundTrip();
    } else if (_ctrl.selectedIndex == 1) {
      _showLoadingAndSearchOneWay();
    }
  }

  void _onMultiDestinationSearch() {
    final t = lang.S.of(context);

    if (_ctrl.fromAirport == null || _ctrl.toAirport == null) {
      toast(t.homeSelectAirportsFlight1);
      return;
    }
    if (_ctrl.departureDate == null) {
      toast(t.homeSelectDateFlight1);
      return;
    }

    for (int i = 0; i < _ctrl.multiDestinationLegs.length; i++) {
      final leg = _ctrl.multiDestinationLegs[i];
      if (leg.fromAirport == null || leg.toAirport == null) {
        toast(t.homeSelectAirportsFlightN(i + 2));
        return;
      }
      if (leg.departureDate == null) {
        toast(t.homeSelectDateFlightN(i + 2));
        return;
      }
    }

    _searchMultiDestinationFlights();
  }

  void _showLoadingAndSearchOneWay() {
    final fc = _ctrl.flightController;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlightSearchLoading(
          destinationCity: _ctrl.toAirport?.city ?? lang.S.of(context).homeDefaultDestination,
          searchFunction: () => fc.searchOneWay(
            fromAirport: _ctrl.fromAirport!,
            toAirport: _ctrl.toAirport!,
            departureDate: _ctrl.departureDate!,
            adultCount: _ctrl.adultCount,
            childCount: _ctrl.childCount,
            infantCount: _ctrl.infantCount,
            cabinClass: _ctrl.selectedClass,
            directOnly: _ctrl.isDirectFlight,
            withBaggage: _ctrl.withBaggage,
          ),
          getTotalFlights: () => fc.totalOffers,
          onSearchComplete: () {
            Navigator.pop(context);
            SearchResult(
              fromAirport: _ctrl.fromAirport!,
              toAirport: _ctrl.toAirport!,
              adultCount: _ctrl.adultCount,
              childCount: _ctrl.childCount,
              infantCount: _ctrl.infantCount,
              dateRange: _ctrl.departureDate != null
                  ? DateTimeRange(start: _ctrl.departureDate!, end: _ctrl.departureDate!)
                  : null,
              flightOffers: fc.hasError ? [] : fc.offers,
              isOneWay: true,
              searchCode: fc.searchCode,
              totalOffers: fc.totalOffers,
              errorMessage: fc.hasError
                  ? fc.errorMessage ?? lang.S.of(context).homeSearchError
                  : null,
              apiAirlines: fc.availableAirlines,
            ).launch(context);
          },
        ),
      ),
    );
  }

  void _showLoadingAndSearchRoundTrip() {
    final fc = _ctrl.flightController;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlightSearchLoading(
          destinationCity: _ctrl.toAirport?.city ?? lang.S.of(context).homeDefaultDestination,
          searchFunction: () => fc.searchRoundTrip(
            fromAirport: _ctrl.fromAirport!,
            toAirport: _ctrl.toAirport!,
            departureDate: _ctrl.departureDate!,
            returnDate: _ctrl.returnDate!,
            adultCount: _ctrl.adultCount,
            childCount: _ctrl.childCount,
            infantCount: _ctrl.infantCount,
            cabinClass: _ctrl.selectedClass,
            directOnly: _ctrl.isDirectFlight,
            withBaggage: _ctrl.withBaggage,
          ),
          getTotalFlights: () => fc.totalOffers,
          onSearchComplete: () {
            Navigator.pop(context);
            SearchResult(
              fromAirport: _ctrl.fromAirport!,
              toAirport: _ctrl.toAirport!,
              adultCount: _ctrl.adultCount,
              childCount: _ctrl.childCount,
              infantCount: _ctrl.infantCount,
              dateRange: _ctrl.selectedDateRange,
              flightOffers: fc.hasError ? [] : fc.offers,
              isOneWay: false,
              searchCode: fc.searchCode,
              totalOffers: fc.totalOffers,
              errorMessage: fc.hasError
                  ? fc.errorMessage ?? lang.S.of(context).homeSearchError
                  : null,
              apiAirlines: fc.availableAirlines,
            ).launch(context);
          },
        ),
      ),
    );
  }

  Future<void> _searchMultiDestinationFlights() async {
    _ctrl.isSearching = true;
    final fc = _ctrl.flightController;
    final t = lang.S.of(context);

    try {
      final bounds = <FlightBound>[];
      String fmtDate(DateTime d) =>
          '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

      if (_ctrl.fromAirport != null && _ctrl.toAirport != null && _ctrl.departureDate != null) {
        bounds.add(FlightBound(
          origin: _ctrl.fromAirport!.code,
          destination: _ctrl.toAirport!.code,
          departureDate: fmtDate(_ctrl.departureDate!),
        ));
      }

      for (final leg in _ctrl.multiDestinationLegs) {
        if (leg.fromAirport != null && leg.toAirport != null && leg.departureDate != null) {
          bounds.add(FlightBound(
            origin: leg.fromAirport!.code,
            destination: leg.toAirport!.code,
            departureDate: fmtDate(leg.departureDate!),
          ));
        }
      }

      if (bounds.length < 2) {
        toast(t.homeMultiMinFlights);
        _ctrl.isSearching = false;
        return;
      }

      await fc.searchMultiDestination(
        bounds: bounds,
        adultCount: _ctrl.adultCount,
        childCount: _ctrl.childCount,
        infantCount: _ctrl.infantCount,
        cabinClass: _ctrl.selectedClass,
        directOnly: _ctrl.isDirectFlight,
        withBaggage: _ctrl.withBaggage,
      );

      SearchResult(
        fromAirport: _ctrl.fromAirport!,
        toAirport: _ctrl.toAirport!,
        adultCount: _ctrl.adultCount,
        childCount: _ctrl.childCount,
        infantCount: _ctrl.infantCount,
        dateRange: _ctrl.departureDate != null
            ? DateTimeRange(start: _ctrl.departureDate!, end: _ctrl.departureDate!)
            : null,
        flightOffers: fc.hasError ? [] : fc.offers,
        isOneWay: false,
        isMultiDestination: true,
        searchCode: fc.searchCode,
        totalOffers: fc.totalOffers,
        errorMessage: fc.hasError ? fc.errorMessage ?? t.homeSearchError : null,
        apiAirlines: fc.availableAirlines,
      ).launch(context);
    } catch (e) {
      SearchResult(
        fromAirport: _ctrl.fromAirport!,
        toAirport: _ctrl.toAirport!,
        adultCount: _ctrl.adultCount,
        childCount: _ctrl.childCount,
        infantCount: _ctrl.infantCount,
        dateRange: _ctrl.departureDate != null
            ? DateTimeRange(start: _ctrl.departureDate!, end: _ctrl.departureDate!)
            : null,
        flightOffers: [],
        isOneWay: false,
        isMultiDestination: true,
        errorMessage: t.homeErrorPrefix('$e'),
      ).launch(context);
    } finally {
      _ctrl.isSearching = false;
    }
  }

  // ── Build ──
  @override
  Widget build(BuildContext context) {
    final t = lang.S.of(context);
    final classDisplay = _ctrl.getClassDisplayName(_ctrl.selectedClass, t);

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
            children: [
              Positioned.fill(
                child: Opacity(
                  opacity: 0.2,
                  child: Image.asset('images/background-home.png', fit: BoxFit.cover),
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        HomeHeader(
                          onNotificationTap: () => const NotificationScreen().launch(context),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: MediaQuery.of(context).padding.top + 130),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15.0),
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
                                      FlightSearchTabs(
                                        tabController: tabController!,
                                        selectedIndex: _ctrl.selectedIndex,
                                        onTabChanged: (index) {
                                          tabController!.animateTo(index);
                                          _ctrl.setTabIndex(index);
                                        },
                                      ),
                                      const SizedBox(height: 20.0),
                                      RoundTripForm(
                                        selectedIndex: _ctrl.selectedIndex,
                                        fromAirport: _ctrl.fromAirport,
                                        toAirport: _ctrl.toAirport,
                                        departureDate: _ctrl.departureDate,
                                        returnDate: _ctrl.returnDate,
                                        totalPassengers: _ctrl.totalPassengers,
                                        classDisplayName: classDisplay,
                                        isDirectFlight: _ctrl.isDirectFlight,
                                        withBaggage: _ctrl.withBaggage,
                                        isSearching: _ctrl.isSearching,
                                        onFromChanged: _ctrl.setFromAirport,
                                        onToChanged: _ctrl.setToAirport,
                                        onSwap: _ctrl.swapAirports,
                                        onDateTap: _showCustomDatePicker,
                                        onPassengerTap: _showPassengerBottomSheet,
                                        onDirectFlightChanged: _ctrl.setDirectFlight,
                                        onBaggageChanged: _ctrl.setWithBaggage,
                                        onSearch: _onSearch,
                                      ),
                                      MultiDestinationForm(
                                        selectedIndex: _ctrl.selectedIndex,
                                        fromAirport: _ctrl.fromAirport,
                                        toAirport: _ctrl.toAirport,
                                        departureDate: _ctrl.departureDate,
                                        returnDate: _ctrl.returnDate,
                                        multiDestinationLegs: _ctrl.multiDestinationLegs,
                                        totalPassengers: _ctrl.totalPassengers,
                                        classDisplayName: classDisplay,
                                        isDirectFlight: _ctrl.isDirectFlight,
                                        withBaggage: _ctrl.withBaggage,
                                        onFromChanged: _ctrl.setFromAirport,
                                        onToChanged: _ctrl.setToAirport,
                                        onSwap: _ctrl.swapAirports,
                                        onDateTap: _showCustomDatePicker,
                                        onPassengerTap: _showPassengerBottomSheet,
                                        onDirectFlightChanged: _ctrl.setDirectFlight,
                                        onBaggageChanged: _ctrl.setWithBaggage,
                                        onAddLeg: _ctrl.addMultiDestinationLeg,
                                        onRemoveLeg: _ctrl.removeMultiDestinationLeg,
                                        onLegFromChanged: _ctrl.setLegFromAirport,
                                        onLegToChanged: _ctrl.setLegToAirport,
                                        onLegSwap: _ctrl.swapLegAirports,
                                        onLegDateTap: _showLegDatePicker,
                                        onSearch: _onMultiDestinationSearch,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    AdvantageSlider(
                      items: _ctrl.advantageSliders,
                      pageController: _advantagesPageController,
                      currentIndex: _ctrl.currentAdvantageIndex,
                      onPageChanged: _ctrl.setAdvantageIndex,
                    ),
                    const SizedBox(height: 25.0),
                    OfferSlider(
                      items: _ctrl.offerSliders,
                      pageController: _offersPageController,
                      currentIndex: _ctrl.currentOfferIndex,
                      onPageChanged: _ctrl.setOfferIndex,
                    ),
                    const SizedBox(height: 30.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
