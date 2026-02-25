import 'package:flight_booking/Model/FakeFlight.dart';
import 'package:flight_booking/generated/l10n.dart' as lang;
import 'package:flight_booking/models/flight_offer.dart';
import 'package:flight_booking/screen/search/flight_details.dart';
import 'package:flight_booking/screen/search/booking_webview.dart';
import 'package:flight_booking/screen/widgets/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../controllers/search_result_controller.dart';

// ═══════════════════════════════════════════════════════════════════════════════
//  1. SORT BOTTOM SHEET
// ═══════════════════════════════════════════════════════════════════════════════

void showSortBottomSheet(BuildContext context, SearchResultController ctrl) {
  String tempSelectedOption = ctrl.selectedSortOption;

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
                      lang.S.of(context).sortBy,
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
                _SortOption(
                  title: lang.S.of(context).sortCheapest,
                  value: 'cheapest',
                  selectedValue: tempSelectedOption,
                  onChanged: (value) {
                    setModalState(() => tempSelectedOption = value);
                  },
                ),
                _SortOption(
                  title: lang.S.of(context).sortMostExpensive,
                  value: 'most_expensive',
                  selectedValue: tempSelectedOption,
                  onChanged: (value) {
                    setModalState(() => tempSelectedOption = value);
                  },
                ),
                _SortOption(
                  title: lang.S.of(context).sortDepartureTime,
                  value: 'departure_time',
                  selectedValue: tempSelectedOption,
                  onChanged: (value) {
                    setModalState(() => tempSelectedOption = value);
                  },
                ),
                _SortOption(
                  title: lang.S.of(context).sortArrivalTime,
                  value: 'arrival_time',
                  selectedValue: tempSelectedOption,
                  onChanged: (value) {
                    setModalState(() => tempSelectedOption = value);
                  },
                ),
                _SortOption(
                  title: lang.S.of(context).sortFlightDuration,
                  value: 'flight_duration',
                  selectedValue: tempSelectedOption,
                  onChanged: (value) {
                    setModalState(() => tempSelectedOption = value);
                  },
                ),

                const SizedBox(height: 24),

                // Apply button
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    ctrl.applySortAndReload(tempSelectedOption);
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
                        lang.S.of(context).sheetApply,
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

class _SortOption extends StatelessWidget {
  final String title;
  final String value;
  final String selectedValue;
  final Function(String) onChanged;

  const _SortOption({
    required this.title,
    required this.value,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == selectedValue;
    return GestureDetector(
      onTap: () => onChanged(value),
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
}

// ═══════════════════════════════════════════════════════════════════════════════
//  2. FILTER BOTTOM SHEET
// ═══════════════════════════════════════════════════════════════════════════════

void showFilterBottomSheet(BuildContext context, SearchResultController ctrl) {
  int tempSelectedCategory = ctrl.selectedFilterCategory;
  int tempSelectedTab = ctrl.selectedFilterTab;
  final bool showRetourTab = ctrl.isRoundTrip;

  // Prix filter: single global range from API filterDependencies (minRate/maxRate)
  final fData = ctrl.filterData;
  final prixData = fData['prix'] as Map<String, dynamic>;
  final double prixMin = (prixData['min'] as num).toDouble();
  final double prixMax = (prixData['max'] as num).toDouble();
  final String currency = prixData['currency'] as String? ?? 'DZD';
  RangeValues priceRange = ctrl.selectedPriceRange ?? RangeValues(prixMin, prixMax);

  final List<String> filterCategories = List<String>.from(fData['categories']);

  // ── Aller tab state (journey 0) ──
  final allerData = ctrl.filterDataForJourney(0);
  List<Map<String, dynamic>> allerCompagnies = List.from(
    (allerData['compagnies'] as List).map((e) => Map<String, dynamic>.from(e)),
  );
  Map<String, dynamic> allerAeroports = {
    'depart': {
      'city': allerData['aeroports']['depart']['city'],
      'airports': List.from(
        (allerData['aeroports']['depart']['airports'] as List)
            .map((e) => Map<String, dynamic>.from(e)),
      ),
    },
    'arrivee': {
      'city': allerData['aeroports']['arrivee']['city'],
      'airports': List.from(
        (allerData['aeroports']['arrivee']['airports'] as List)
            .map((e) => Map<String, dynamic>.from(e)),
      ),
    },
  };
  String allerEscaleOption = ctrl.selectedEscaleOption;
  RangeValues allerDepTimeRange = ctrl.selectedDepTimeRange;
  RangeValues allerArrTimeRange = ctrl.selectedArrTimeRange;
  List<String> allerEscaleOptions = List<String>.from(allerData['escale']);
  Set<int> allerDepartureSlots = {};
  Set<int> allerArrivalSlots = {};

  // ── Retour tab state (journey 1) ──
  final retourData = showRetourTab ? ctrl.filterDataForJourney(1) : null;
  List<Map<String, dynamic>> retourCompagnies = retourData != null
      ? List.from(
          (retourData['compagnies'] as List).map((e) => Map<String, dynamic>.from(e)),
        )
      : [];
  Map<String, dynamic> retourAeroports = retourData != null
      ? {
          'depart': {
            'city': retourData['aeroports']['depart']['city'],
            'airports': List.from(
              (retourData['aeroports']['depart']['airports'] as List)
                  .map((e) => Map<String, dynamic>.from(e)),
            ),
          },
          'arrivee': {
            'city': retourData['aeroports']['arrivee']['city'],
            'airports': List.from(
              (retourData['aeroports']['arrivee']['airports'] as List)
                  .map((e) => Map<String, dynamic>.from(e)),
            ),
          },
        }
      : {'depart': {'city': '', 'airports': []}, 'arrivee': {'city': '', 'airports': []}};
  String retourEscaleOption = ctrl.retourEscaleOption;
  RangeValues retourDepTimeRange = ctrl.retourDepTimeRange;
  RangeValues retourArrTimeRange = ctrl.retourArrTimeRange;
  Set<int> retourDepartureSlots = {};
  Set<int> retourArrivalSlots = {};
  List<String> retourEscaleOptions = retourData != null
      ? List<String>.from(retourData['escale'])
      : ['Tous'];

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

          // Select the correct state based on current tab
          final isAllerTab = tempSelectedTab == 0;
          final currentEscaleOption = isAllerTab ? allerEscaleOption : retourEscaleOption;
          final currentEscaleOptions = isAllerTab ? allerEscaleOptions : retourEscaleOptions;
          final currentCompagnies = isAllerTab ? allerCompagnies : retourCompagnies;
          final currentAeroports = isAllerTab ? allerAeroports : retourAeroports;
          final currentDepTimeRange = isAllerTab ? allerDepTimeRange : retourDepTimeRange;
          final currentArrTimeRange = isAllerTab ? allerArrTimeRange : retourArrTimeRange;
          final currentPriceRange = priceRange; // Single global price filter
          final currentDepartureSlots = isAllerTab ? allerDepartureSlots : retourDepartureSlots;
          final currentArrivalSlots = isAllerTab ? allerArrivalSlots : retourArrivalSlots;

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
                        lang.S.of(context).filterTitle,
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
                      // Left side menu
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
                              if (showRetourTab)
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setModalState(() => tempSelectedTab = 0);
                                      },
                                      child: Column(
                                        children: [
                                          Text(
                                            lang.S.of(context).filterOutbound,
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
                                            lang.S.of(context).filterReturn,
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
                              if (showRetourTab) const SizedBox(height: 16),

                              // Filter content based on selected category + tab
                              Expanded(
                                child: SingleChildScrollView(
                                  child: _buildFilterContent(
                                    context,
                                    tempSelectedCategory,
                                    currentEscaleOption,
                                    currentEscaleOptions,
                                    currentCompagnies,
                                    currentAeroports,
                                    (value) => setModalState(() {
                                      if (isAllerTab) {
                                        allerEscaleOption = value;
                                      } else {
                                        retourEscaleOption = value;
                                      }
                                    }),
                                    (index, value) => setModalState(() {
                                      currentCompagnies[index]['selected'] = value;
                                    }),
                                    (type, index, value) => setModalState(() {
                                      currentAeroports[type]['airports'][index]['selected'] = value;
                                    }),
                                    depTimeRange: currentDepTimeRange,
                                    arrTimeRange: currentArrTimeRange,
                                    onDepTimeChanged: (v) => setModalState(() {
                                      if (isAllerTab) {
                                        allerDepTimeRange = v;
                                      } else {
                                        retourDepTimeRange = v;
                                      }
                                    }),
                                    onArrTimeChanged: (v) => setModalState(() {
                                      if (isAllerTab) {
                                        allerArrTimeRange = v;
                                      } else {
                                        retourArrTimeRange = v;
                                      }
                                    }),
                                    priceRange: currentPriceRange,
                                    priceMin: prixMin,
                                    priceMax: prixMax,
                                    priceCurrency: currency,
                                    onPriceRangeChanged: (v) => setModalState(() {
                                      priceRange = v;
                                    }),
                                    departureAirportName: currentAeroports['depart']['city'] as String? ?? '',
                                    arrivalAirportName: currentAeroports['arrivee']['city'] as String? ?? '',
                                    selectedDepartureSlots: currentDepartureSlots,
                                    selectedArrivalSlots: currentArrivalSlots,
                                    onDepartureSlotsChanged: (slots) => setModalState(() {
                                      if (isAllerTab) {
                                        allerDepartureSlots = slots;
                                      } else {
                                        retourDepartureSlots = slots;
                                      }
                                    }),
                                    onArrivalSlotsChanged: (slots) => setModalState(() {
                                      if (isAllerTab) {
                                        allerArrivalSlots = slots;
                                      } else {
                                        retourArrivalSlots = slots;
                                      }
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
                        // Reset button - resets ALL filters (both tabs)
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            ctrl.resetAllFilters();
                            ctrl.reloadFlightsWithFilters();
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
                                lang.S.of(context).filterReset,
                                style: GoogleFonts.poppins(
                                  color: kTitleColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Apply button - applies BOTH tab filters
                        GestureDetector(
                          onTap: () {
                            // Extract Aller airline/airport codes
                            final allerAirlineCodes = allerCompagnies
                                .where((c) => c['selected'] == true)
                                .map((c) => (c['code'] as String).toUpperCase())
                                .toSet();
                            final allerDepAirportCodes = (allerAeroports['depart']['airports'] as List)
                                .where((a) => a['selected'] == true)
                                .map((a) => a['code'] as String)
                                .toSet();
                            final allerArrAirportCodes = (allerAeroports['arrivee']['airports'] as List)
                                .where((a) => a['selected'] == true)
                                .map((a) => a['code'] as String)
                                .toSet();

                            // Extract Retour airline/airport codes
                            final retourAirlineCodes = retourCompagnies
                                .where((c) => c['selected'] == true)
                                .map((c) => (c['code'] as String).toUpperCase())
                                .toSet();
                            final retourDepAirportCodesSet = (retourAeroports['depart']['airports'] as List)
                                .where((a) => a['selected'] == true)
                                .map((a) => a['code'] as String)
                                .toSet();
                            final retourArrAirportCodesSet = (retourAeroports['arrivee']['airports'] as List)
                                .where((a) => a['selected'] == true)
                                .map((a) => a['code'] as String)
                                .toSet();

                            // Price range per journey: null if full range (no filter)
                            // Price: single global filter (not per journey)
                            final priceToApply = (priceRange.start > prixMin || priceRange.end < prixMax)
                                ? priceRange
                                : null;

                            // Convert time slot selections to RangeValues
                            // Slot 0: 0-8, Slot 1: 8-16, Slot 2: 16-24
                            RangeValues slotsToRange(Set<int> slots) {
                              if (slots.isEmpty) return const RangeValues(0, 24);
                              const starts = [0.0, 8.0, 16.0];
                              const ends = [8.0, 16.0, 24.0];
                              double min = 24;
                              double max = 0;
                              for (final s in slots) {
                                if (starts[s] < min) min = starts[s];
                                if (ends[s] > max) max = ends[s];
                              }
                              return RangeValues(min, max);
                            }
                            final allerDepTime = allerDepartureSlots.isNotEmpty
                                ? slotsToRange(allerDepartureSlots)
                                : allerDepTimeRange;
                            final allerArrTime = allerArrivalSlots.isNotEmpty
                                ? slotsToRange(allerArrivalSlots)
                                : allerArrTimeRange;
                            final retourDepTime = retourDepartureSlots.isNotEmpty
                                ? slotsToRange(retourDepartureSlots)
                                : retourDepTimeRange;
                            final retourArrTime = retourArrivalSlots.isNotEmpty
                                ? slotsToRange(retourArrivalSlots)
                                : retourArrTimeRange;

                            Navigator.pop(context);
                            ctrl.applyFilters(
                              filterCategory: tempSelectedCategory,
                              filterTab: tempSelectedTab,
                              // Aller
                              escaleOption: allerEscaleOption,
                              airlineCodes: allerAirlineCodes,
                              departureAirportCodes: allerDepAirportCodes,
                              arrivalAirportCodes: allerArrAirportCodes,
                              depTimeRange: allerDepTime,
                              arrTimeRange: allerArrTime,
                              priceRange: priceToApply,
                              depTimeSlots: allerDepartureSlots,
                              arrTimeSlots: allerArrivalSlots,
                              // Retour
                              retourEscaleOption: retourEscaleOption,
                              retourAirlineCodes: retourAirlineCodes,
                              retourDepartureAirportCodes: retourDepAirportCodesSet,
                              retourArrivalAirportCodes: retourArrAirportCodesSet,
                              retourDepTimeRange: retourDepTime,
                              retourArrTimeRange: retourArrTime,
                              retourDepTimeSlots: retourDepartureSlots,
                              retourArrTimeSlots: retourArrivalSlots,
                            );
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
                                lang.S.of(context).sheetApply,
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

// ── Filter content builder ──

Widget _buildFilterContent(
  BuildContext context,
  int category,
  String escaleOption,
  List<String> escaleOptions,
  List<Map<String, dynamic>> compagnies,
  Map<String, dynamic> aeroports,
  Function(String) onEscaleChanged,
  Function(int, bool) onCompagnieChanged,
  Function(String, int, bool) onAeroportChanged, {
  RangeValues depTimeRange = const RangeValues(0, 24),
  RangeValues arrTimeRange = const RangeValues(0, 24),
  Function(RangeValues)? onDepTimeChanged,
  Function(RangeValues)? onArrTimeChanged,
  RangeValues? priceRange,
  double priceMin = 0,
  double priceMax = 50000,
  String priceCurrency = 'DZD',
  Function(RangeValues)? onPriceRangeChanged,
  String departureAirportName = '',
  String arrivalAirportName = '',
  Set<int> selectedDepartureSlots = const {},
  Set<int> selectedArrivalSlots = const {},
  Function(Set<int>)? onDepartureSlotsChanged,
  Function(Set<int>)? onArrivalSlotsChanged,
}) {
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
      final effectivePriceRange = priceRange ?? RangeValues(priceMin, priceMax);
      // Ensure slider step of 100 DZD for better UX
      final double sliderMin = (priceMin / 100).floorToDouble() * 100;
      final double sliderMax = (priceMax / 100).ceilToDouble() * 100;
      final int divisions = ((sliderMax - sliderMin) / 100).round().clamp(1, 1000);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lang.S.of(context).filterSelectPriceRange,
            style: GoogleFonts.poppins(
              color: kTitleColor,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${effectivePriceRange.start.round()} $priceCurrency',
                style: GoogleFonts.poppins(fontSize: 12, color: kSubTitleColor),
              ),
              Text(
                '${effectivePriceRange.end.round()} $priceCurrency',
                style: GoogleFonts.poppins(fontSize: 12, color: kSubTitleColor),
              ),
            ],
          ),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: kPrimaryColor,
              inactiveTrackColor: kBorderColorTextField,
              thumbColor: kPrimaryColor,
              overlayColor: kPrimaryColor.withValues(alpha: 0.1),
              rangeThumbShape: const RoundRangeSliderThumbShape(enabledThumbRadius: 8),
              valueIndicatorColor: kPrimaryColor,
              valueIndicatorTextStyle: GoogleFonts.poppins(
                color: kWhite,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
              showValueIndicator: ShowValueIndicator.always,
            ),
            child: RangeSlider(
              values: RangeValues(
                effectivePriceRange.start.clamp(sliderMin, sliderMax),
                effectivePriceRange.end.clamp(sliderMin, sliderMax),
              ),
              min: sliderMin,
              max: sliderMax,
              divisions: divisions,
              labels: RangeLabels(
                '${effectivePriceRange.start.round()}',
                '${effectivePriceRange.end.round()}',
              ),
              onChanged: (v) => onPriceRangeChanged?.call(v),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                lang.S.of(context).filterMin(sliderMin.round().toString(), priceCurrency),
                style: GoogleFonts.poppins(fontSize: 11, color: kSubTitleColor),
              ),
              Text(
                lang.S.of(context).filterMax(sliderMax.round().toString(), priceCurrency),
                style: GoogleFonts.poppins(fontSize: 11, color: kSubTitleColor),
              ),
            ],
          ),
        ],
      );

    case 2: // Escale
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Route info
          if (departureAirportName.isNotEmpty || arrivalAirportName.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                '${departureAirportName.isNotEmpty ? departureAirportName : lang.S.of(context).filterDepartureDefault}'
                ' → '
                '${arrivalAirportName.isNotEmpty ? arrivalAirportName : lang.S.of(context).filterArrivalDefault}',
                style: GoogleFonts.poppins(
                  color: kSubTitleColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          // Stop chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: escaleOptions.where((o) => o != 'Tous').map((option) {
              final isSelected = escaleOption == option;
              final int stopCount = option == 'Direct' ? 0
                  : option.contains('1') ? 1
                  : 2;
              final Color activeColor = isSelected ? kPrimaryColor : kSubTitleColor;
              return GestureDetector(
                onTap: () => onEscaleChanged(isSelected ? 'Tous' : option),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? kPrimaryColor.withValues(alpha: 0.06) : kWhite,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? kPrimaryColor : kBorderColorTextField,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Flight path icon
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.flight_land, size: 14, color: activeColor),
                          ...List.generate(stopCount > 0 ? stopCount : 0, (i) => Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('····', style: TextStyle(color: activeColor, fontSize: 9, height: 1, letterSpacing: 1)),
                              Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: activeColor, width: 1.2),
                                ),
                                child: Center(
                                  child: Text(
                                    '${i + 1}',
                                    style: TextStyle(color: activeColor, fontSize: 8, fontWeight: FontWeight.w600, height: 1.1),
                                  ),
                                ),
                              ),
                            ],
                          )),
                          Text('········', style: TextStyle(color: activeColor, fontSize: 9, height: 1, letterSpacing: 1)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        stopCount == 0
                            ? lang.S.of(context).cardDirectFlight
                            : (stopCount == 1
                                ? lang.S.of(context).cardStop('1')
                                : lang.S.of(context).cardStops('2')),
                        style: GoogleFonts.poppins(
                          color: isSelected ? kPrimaryColor : kTitleColor,
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      );

    case 3: // Horaires
      final timeSlots = [
        {'label': lang.S.of(context).filterEarlyMorning, 'range': '(00:00 - 07:59)', 'asset': 'assets/matin_tot.svg'},
        {'label': lang.S.of(context).filterMorning, 'range': '(08:00 - 15:59)', 'asset': 'assets/matin.svg'},
        {'label': lang.S.of(context).filterEvening, 'range': '(16:00 - 23:59)', 'asset': 'assets/soir.svg'},
      ];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Departure airport time slots
          Text(
            departureAirportName.isNotEmpty ? departureAirportName : lang.S.of(context).filterDepartureDefault,
            style: GoogleFonts.poppins(
              color: kTitleColor,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          ...List.generate(timeSlots.length, (i) {
            final isSelected = selectedDepartureSlots.contains(i);
            return _buildTimeSlotCard(
              slot: timeSlots[i],
              isSelected: isSelected,
              onTap: () {
                final newSlots = Set<int>.from(selectedDepartureSlots);
                if (isSelected) {
                  newSlots.remove(i);
                } else {
                  newSlots.add(i);
                }
                onDepartureSlotsChanged?.call(newSlots);
              },
            );
          }),
          const SizedBox(height: 16),
          // Arrival airport time slots
          Text(
            arrivalAirportName.isNotEmpty ? arrivalAirportName : lang.S.of(context).filterArrivalDefault,
            style: GoogleFonts.poppins(
              color: kTitleColor,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          ...List.generate(timeSlots.length, (i) {
            final isSelected = selectedArrivalSlots.contains(i);
            return _buildTimeSlotCard(
              slot: timeSlots[i],
              isSelected: isSelected,
              onTap: () {
                final newSlots = Set<int>.from(selectedArrivalSlots);
                if (isSelected) {
                  newSlots.remove(i);
                } else {
                  newSlots.add(i);
                }
                onArrivalSlotsChanged?.call(newSlots);
              },
            );
          }),
        ],
      );

    case 4: // Aéroport
      final depAirports = aeroports['depart']['airports'] as List;
      final arrAirports = aeroports['arrivee']['airports'] as List;
      final connAirports = (aeroports['connexion']?['airports'] as List?) ?? [];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Departure airports
          Text(
            lang.S.of(context).filterDepartureFrom(aeroports['depart']['city'] as String),
            style: GoogleFonts.poppins(
              color: kTitleColor,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          ...depAirports.asMap().entries.map((entry) {
            final index = entry.key;
            final airport = entry.value;
            return _buildCheckboxOption(
              '${airport['code']} - ${airport['name']}',
              airport['selected'],
              (value) => onAeroportChanged('depart', index, value),
            );
          }).toList(),

          const SizedBox(height: 16),

          // Arrival airports
          Text(
            lang.S.of(context).filterArrivalAt(aeroports['arrivee']['city'] as String),
            style: GoogleFonts.poppins(
              color: kTitleColor,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          ...arrAirports.asMap().entries.map((entry) {
            final index = entry.key;
            final airport = entry.value;
            return _buildCheckboxOption(
              '${airport['code']} - ${airport['name']}',
              airport['selected'],
              (value) => onAeroportChanged('arrivee', index, value),
            );
          }).toList(),

          // Connection airports (only show if there are layover airports)
          if (connAirports.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              lang.S.of(context).filterLayoversVia,
              style: GoogleFonts.poppins(
                color: kTitleColor,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            ...connAirports.map((airport) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(Icons.connecting_airports, size: 16, color: kSubTitleColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${airport['code']} - ${airport['name']}',
                        style: GoogleFonts.poppins(fontSize: 13, color: kSubTitleColor),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
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

Widget _buildTimeSlotCard({
  required Map<String, String> slot,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? kPrimaryColor.withOpacity(0.08) : kWhite,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? kPrimaryColor : kBorderColorTextField,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              slot['asset']!,
              width: 28,
              height: 28,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    slot['label']!,
                    style: GoogleFonts.poppins(
                      color: isSelected ? kPrimaryColor : kTitleColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    slot['range']!,
                    style: GoogleFonts.poppins(
                      color: kSubTitleColor,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// ═══════════════════════════════════════════════════════════════════════════════
//  3. BAGGAGE DETAILS BOTTOM SHEET
// ═══════════════════════════════════════════════════════════════════════════════

void showBaggageDetailsBottomSheet(BuildContext context, BaggageAllowance? baggage) {
  // Get baggage info
  String cabinBaggageText = lang.S.of(context).baggageNotIncluded;
  String checkedBaggageText = lang.S.of(context).baggageNotIncluded;

  if (baggage != null) {
    // Cabin baggage
    if (baggage.cabinBaggage.isNotEmpty) {
      final cabin = baggage.cabinBaggage.first;
      final paxType = SearchResultController.getPaxTypeDisplayName(cabin.paxType);
      final value = cabin.value ?? 0;
      final unit = cabin.unit ?? 'KG';
      cabinBaggageText = '$paxType: $value$unit';
    }

    // Checked baggage
    if (baggage.checkedInBaggage.isNotEmpty) {
      final checked = baggage.checkedInBaggage.first;
      final paxType = SearchResultController.getPaxTypeDisplayName(checked.paxType);
      final value = checked.value ?? 0;
      final unit = checked.unit ?? 'PC';
      if (unit.toUpperCase() == 'PC' || unit.toUpperCase() == 'PIECE' || unit.toUpperCase() == 'PIECES') {
        checkedBaggageText = '$paxType: ${value > 1 ? lang.S.of(context).baggagePieces(value.toString()) : lang.S.of(context).baggagePiece(value.toString())}';
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
                  lang.S.of(context).baggageDetailsTitle,
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
                  lang.S.of(context).baggageCheckedLabel,
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
                  lang.S.of(context).baggageCabinLabel,
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

// ═══════════════════════════════════════════════════════════════════════════════
//  4. PRICE DETAILS BOTTOM SHEET
// ═══════════════════════════════════════════════════════════════════════════════

void showPriceDetailsBottomSheet(BuildContext context, FlightOffer offer) {
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
                  lang.S.of(context).priceDetailsTitle,
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
                isRefundable ? lang.S.of(context).cardRefundable : lang.S.of(context).priceNonRefundable,
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
                final paxType = SearchResultController.getPaxTypeDisplayName(breakdown.paxType);
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
                          lang.S.of(context).priceBaseFare,
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
                          lang.S.of(context).priceTaxesPer(paxType.toLowerCase()),
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
                lang.S.of(context).priceAdultFallback,
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
                    lang.S.of(context).priceBaseFare,
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
                    lang.S.of(context).priceTaxesPerAdult,
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
                  lang.S.of(context).priceTotalInclTax,
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

// ═══════════════════════════════════════════════════════════════════════════════
//  5. FLIGHT DETAILS BOTTOM SHEET (with Aller / Retour tabs)
// ═══════════════════════════════════════════════════════════════════════════════

void showFlightDetailsBottomSheet(
  BuildContext context,
  FlightOffer offer,
  SearchResultController ctrl, {
  required bool isOneWay,
  int initialTab = 0,
}) {
  final price = offer.totalPrice;
  final currency = offer.currency;
  final journeyList = offer.journey;
  final isRoundTrip = !isOneWay && journeyList.length > 1;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      final screenHeight = MediaQuery.of(ctx).size.height;
      final bottomPadding = MediaQuery.of(ctx).padding.bottom;
      final maxSheetHeight = screenHeight * 0.9;

      int selectedTab = initialTab.clamp(0, journeyList.length - 1);

      return StatefulBuilder(
        builder: (ctx, setModalState) {
          final currentJourney = journeyList.isNotEmpty
              ? journeyList[selectedTab.clamp(0, journeyList.length - 1)]
              : null;

          return ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxSheetHeight),
            child: Container(
              decoration: const BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle bar
                  GestureDetector(
                    onTap: () => Navigator.pop(ctx),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 6),
                      child: Container(
                        width: 40, height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                  // Title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        lang.S.of(ctx).sheetFlightDetails,
                        style: GoogleFonts.poppins(
                          color: kTitleColor,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                  // ── Aller / Retour tab bar ──
                  if (isRoundTrip)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F3F3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: List.generate(journeyList.length, (i) {
                            final isSelected = selectedTab == i;
                            final journey = journeyList[i];
                            final segs = journey.flightSegments;
                            final depCode = segs.isNotEmpty ? (segs.first.departureAirportCode ?? '') : '';
                            final arrCode = segs.isNotEmpty ? (segs.last.arrivalAirportCode ?? '') : '';
                            final label = i == 0 ? lang.S.of(ctx).filterOutbound : lang.S.of(ctx).filterReturn;

                            return Expanded(
                              child: GestureDetector(
                                onTap: () => setModalState(() => selectedTab = i),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  margin: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    color: isSelected ? kWhite : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.08),
                                              blurRadius: 4,
                                              offset: const Offset(0, 1),
                                            ),
                                          ]
                                        : [],
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          i == 0 ? Icons.flight_takeoff : Icons.flight_land,
                                          size: 16,
                                          color: isSelected ? kPrimaryColor : kSubTitleColor,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          '$label ($depCode - $arrCode)',
                                          style: GoogleFonts.poppins(
                                            color: isSelected ? kPrimaryColor : kSubTitleColor,
                                            fontSize: 12,
                                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),

                  if (isRoundTrip) const SizedBox(height: 12),
                  const Divider(height: 1, color: Color(0xFFE2E2E2)),

                  // ── Journey content ──
                  if (currentJourney != null)
                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                        child: _FlightJourneyContent(
                          journey: currentJourney,
                          ctrl: ctrl,
                          journeyIndex: selectedTab,
                        ),
                      ),
                    ),

                  // ── Bottom bar: price + reserve button ──
                  Container(
                    padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + bottomPadding),
                    decoration: BoxDecoration(
                      color: kWhite,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 8,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                lang.S.of(ctx).sheetPricePerPerson(price.toStringAsFixed(0), currency),
                                style: GoogleFonts.poppins(
                                  color: kTitleColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                isRoundTrip ? lang.S.of(ctx).sheetRoundTrip : lang.S.of(ctx).sheetOneWay,
                                style: GoogleFonts.poppins(
                                  color: kSubTitleColor,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(ctx);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BookingWebView(
                                  url: 'https://www.google.com',
                                  title: lang.S.of(ctx).detailBookingTitle,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              lang.S.of(ctx).sheetBookFlight,
                              style: GoogleFonts.poppins(
                                color: kWhite,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
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
          );
        },
      );
    },
  );
}

// ── Journey content widget (all segments for one journey) ──
class _FlightJourneyContent extends StatelessWidget {
  final FlightJourney journey;
  final SearchResultController ctrl;
  final int journeyIndex;

  const _FlightJourneyContent({
    required this.journey,
    required this.ctrl,
    required this.journeyIndex,
  });

  @override
  Widget build(BuildContext context) {
    final segments = journey.flightSegments;
    if (segments.isEmpty) return const SizedBox.shrink();

    final firstSeg = segments.first;
    final lastSeg = segments.last;
    final depCity = firstSeg.departureAirportDetails?.city ?? firstSeg.departureAirportCode ?? '';
    final arrCity = lastSeg.arrivalAirportDetails?.city ?? lastSeg.arrivalAirportCode ?? '';
    final journeyDuration = journey.flight?.flightInfo?.duration ?? '--';
    final stops = journey.flight?.stopQuantity ?? (segments.length - 1);
    final stopsText = stops == 0
        ? lang.S.of(context).cardDirectFlight
        : (stops > 1 ? lang.S.of(context).cardStops(stops.toString()) : lang.S.of(context).cardStop(stops.toString()));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Journey header
        Row(
          children: [
            Icon(
              journeyIndex == 0 ? Icons.flight_takeoff : Icons.flight_land,
              color: kPrimaryColor,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '$depCity \u2013 $arrCity',
                style: GoogleFonts.poppins(
                  color: kTitleColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        // Duration + stops summary
        Padding(
          padding: const EdgeInsets.only(left: 26),
          child: Text(
            '$journeyDuration  \u2022  $stopsText',
            style: GoogleFonts.poppins(
              color: kSubTitleColor,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Segments
        ...segments.asMap().entries.map((entry) {
          final sIdx = entry.key;
          final seg = entry.value;
          final nextSeg = sIdx < segments.length - 1 ? segments[sIdx + 1] : null;

          return Column(
            children: [
              _FlightSegmentCard(seg: seg, ctrl: ctrl),
              // Layover between segments
              if (nextSeg != null)
                _LayoverCard(
                  currentSeg: seg,
                  nextSeg: nextSeg,
                  ctrl: ctrl,
                ),
            ],
          );
        }),
      ],
    );
  }
}

// ── Single segment card with timeline ──
class _FlightSegmentCard extends StatelessWidget {
  final FlightSegmentDetail seg;
  final SearchResultController ctrl;

  const _FlightSegmentCard({required this.seg, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final depTime = SearchResultController.formatTimeFromDateTime(seg.departureDateTime);
    final arrTime = SearchResultController.formatTimeFromDateTime(seg.arrivalDateTime);
    final depDateFull = ctrl.formatDateDayFull(seg.departureDateTime);
    final arrDateFull = ctrl.formatDateDayFull(seg.arrivalDateTime);
    final depCode = seg.departureAirportCode ?? '';
    final arrCode = seg.arrivalAirportCode ?? '';
    final depAirportName = seg.departureAirportDetails?.name ?? lang.S.of(context).segmentAirportFallback(depCode);
    final arrAirportName = seg.arrivalAirportDetails?.name ?? lang.S.of(context).segmentAirportFallback(arrCode);
    final depTerminal = seg.departureTerminal;
    final arrTerminal = seg.arrivalTerminal;
    final airlineCode = seg.marketingAirline ?? seg.operatingAirline ?? '';
    final segAirlineName = seg.marketingAirlineName ?? seg.operatingAirlineName ?? airlineCode;
    // Resolve correct name from API airlines list
    final airlineName = airlineCode.isNotEmpty
        ? ctrl.resolveAirlineName(airlineCode, segAirlineName)
        : segAirlineName;
    final flightNum = seg.flightNumber?.toString() ?? '';
    final seats = seg.seatsAvailable;
    final cabinClass = seg.cabinClass ?? lang.S.of(context).classEconomy;
    final duration = seg.duration ?? '--';
    final equipmentType = seg.equipmentType;
    final equipmentName = seg.equipmentName;
    final airlineLogoUrl = SearchResultController.getAirlineLogoUrl(airlineCode);

    // Baggage
    String checkedBag = '--';
    String cabinBag = '--';
    final bag = seg.baggageAllowance;
    if (bag != null) {
      if (bag.checkedInBaggage.isNotEmpty) {
        final cb = bag.checkedInBaggage.first;
        final unit = cb.unit ?? 'Kg';
        if (unit.toUpperCase().contains('PC') || unit.toUpperCase().contains('PIECE')) {
          checkedBag = (cb.value ?? 1) > 1 ? lang.S.of(context).baggagePieces((cb.value ?? 1).toString()) : lang.S.of(context).baggagePiece((cb.value ?? 1).toString());
        } else {
          checkedBag = '${cb.value ?? 24} $unit';
        }
      }
      if (bag.cabinBaggage.isNotEmpty) {
        final hb = bag.cabinBaggage.first;
        cabinBag = '${hb.value ?? 7} ${hb.unit ?? 'Kg'}';
      }
    }

    // Equipment display
    final equipmentDisplay = equipmentName != null && equipmentName.isNotEmpty
        ? equipmentName
        : (equipmentType != null && equipmentType.isNotEmpty ? equipmentType : null);

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Timeline with departure / arrival ──
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Left: times ──
                SizedBox(
                  width: 58,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        depTime,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: kTitleColor,
                        ),
                      ),
                      Text(
                        depDateFull,
                        style: GoogleFonts.poppins(fontSize: 9, color: kSubTitleColor),
                      ),
                      const Spacer(),
                      Text(
                        arrTime,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: kTitleColor,
                        ),
                      ),
                      Text(
                        arrDateFull,
                        style: GoogleFonts.poppins(fontSize: 9, color: kSubTitleColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // ── Timeline dots ──
                SizedBox(
                  width: 20,
                  child: Column(
                    children: [
                      const SizedBox(height: 4),
                      Container(
                        width: 12, height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: kPrimaryColor, width: 2.5),
                          color: kWhite,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: 2,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [kPrimaryColor, kPrimaryColor.withOpacity(0.3)],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 12, height: 12,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: kPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                // ── Right: airport info + flight details ──
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Departure airport
                      Text(
                        '$depAirportName ($depCode)',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: kTitleColor,
                        ),
                      ),
                      if (depTerminal != null)
                        Text(
                          lang.S.of(context).segmentTerminal(depTerminal!),
                          style: GoogleFonts.poppins(fontSize: 11, color: kSubTitleColor),
                        ),

                      const SizedBox(height: 12),

                      // ── Airline + flight info block ──
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAFAFA),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFEEEEEE)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Airline row
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Image.network(
                                    airlineLogoUrl,
                                    width: 24, height: 24,
                                    fit: BoxFit.contain,
                                    errorBuilder: (_, __, ___) => Container(
                                      width: 24, height: 24,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: kPrimaryColor.withOpacity(0.1),
                                      ),
                                      child: Center(
                                        child: Text(
                                          airlineCode,
                                          style: GoogleFonts.poppins(
                                            fontSize: 8,
                                            fontWeight: FontWeight.bold,
                                            color: kPrimaryColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        airlineName,
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: kTitleColor,
                                        ),
                                      ),
                                      Text(
                                        '${lang.S.of(context).segmentFlightInfo(airlineCode, flightNum)}${equipmentDisplay != null ? '  \u2022  $equipmentDisplay' : ''}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 10,
                                          color: kSubTitleColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Duration, cabin, seats row
                            Wrap(
                              spacing: 12,
                              runSpacing: 6,
                              children: [
                                _InfoChip(
                                  icon: Icons.schedule,
                                  text: duration,
                                ),
                                _InfoChip(
                                  icon: Icons.airline_seat_recline_normal,
                                  text: cabinClass,
                                ),
                                if (seats != null)
                                  _InfoChip(
                                    icon: Icons.event_seat,
                                    text: lang.S.of(context).segmentSeats(seats.toString()),
                                    textColor: const Color(0xFF2E7D32),
                                    iconColor: const Color(0xFF2E7D32),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Arrival airport
                      Text(
                        '$arrAirportName ($arrCode)',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: kTitleColor,
                        ),
                      ),
                      if (arrTerminal != null)
                        Text(
                          lang.S.of(context).segmentTerminal(arrTerminal!),
                          style: GoogleFonts.poppins(fontSize: 11, color: kSubTitleColor),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ── Baggage info ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8F8),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFEEEEEE)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lang.S.of(context).segmentBaggage,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: kTitleColor,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.luggage, size: 16, color: kPrimaryColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        lang.S.of(context).segmentCheckedBag(checkedBag),
                        style: GoogleFonts.poppins(fontSize: 11, color: kTitleColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.backpack, size: 16, color: kPrimaryColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        lang.S.of(context).segmentCabinBag(cabinBag),
                        style: GoogleFonts.poppins(fontSize: 11, color: kTitleColor),
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
}

// ── Layover card between segments ──
class _LayoverCard extends StatelessWidget {
  final FlightSegmentDetail currentSeg;
  final FlightSegmentDetail nextSeg;
  final SearchResultController ctrl;

  const _LayoverCard({
    required this.currentSeg,
    required this.nextSeg,
    required this.ctrl,
  });

  @override
  Widget build(BuildContext context) {
    final airportCode = currentSeg.arrivalAirportCode ?? '';
    final airportName = currentSeg.arrivalAirportDetails?.name ?? airportCode;
    final layoverTime = currentSeg.layoverTime ?? _calculateLayover();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F0),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFFE0B2)),
      ),
      child: Row(
        children: [
          Icon(Icons.access_time_filled, size: 18, color: kPrimaryColor),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lang.S.of(context).layoverAt(airportName, airportCode),
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: kTitleColor,
                  ),
                ),
                if (layoverTime.isNotEmpty)
                  Text(
                    lang.S.of(context).layoverDuration(layoverTime),
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: kSubTitleColor,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _calculateLayover() {
    if (currentSeg.arrivalDateTime == null || nextSeg.departureDateTime == null) return '';
    try {
      final arrival = DateTime.parse(currentSeg.arrivalDateTime!);
      final departure = DateTime.parse(nextSeg.departureDateTime!);
      final diff = departure.difference(arrival);
      final hours = diff.inHours;
      final minutes = diff.inMinutes % 60;
      if (hours > 0 && minutes > 0) return '${hours}h ${minutes}min';
      if (hours > 0) return '${hours}h';
      return '${minutes}min';
    } catch (_) {
      return '';
    }
  }
}

// ── Small info chip (icon + text) ──
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? textColor;
  final Color? iconColor;

  const _InfoChip({
    required this.icon,
    required this.text,
    this.textColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: iconColor ?? kSubTitleColor),
        const SizedBox(width: 4),
        Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: textColor ?? kSubTitleColor,
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  7. FAKE FLIGHT DETAILS BOTTOM SHEET
// ═══════════════════════════════════════════════════════════════════════════════

void showFakeFlightDetailsBottomSheet(
  BuildContext context, {
  required FakeFlight flight,
  required int index,
  required String fromCode,
  required String toCode,
  required DateTimeRange? dateRange,
}) {
  final flightNumber = 'TK ${123456 + index}';
  final outboundDate = SearchResultController.formatFlightDate(dateRange?.start);
  final returnDate = SearchResultController.formatFlightDate(dateRange?.end);
  final hasReturn = dateRange != null && dateRange.start != dateRange.end;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      final screenHeight = MediaQuery.of(ctx).size.height;
      final bottomPadding = MediaQuery.of(ctx).padding.bottom;
      final maxSheetHeight = screenHeight * 0.9;

      int selectedTab = 0;

      return StatefulBuilder(
        builder: (ctx, setModalState) {
          // Current tab data
          final isAllerTab = selectedTab == 0;
          final currentFromCode = isAllerTab ? fromCode : toCode;
          final currentToCode = isAllerTab ? toCode : fromCode;
          final currentDate = isAllerTab ? outboundDate : returnDate;

          return ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxSheetHeight),
            child: Container(
              decoration: const BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle bar
                  GestureDetector(
                    onTap: () => Navigator.pop(ctx),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 6),
                      child: Container(
                        width: 40, height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                  // Title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        lang.S.of(ctx).sheetFlightDetails,
                        style: GoogleFonts.poppins(
                          color: kTitleColor,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                  // ── Aller / Retour tab bar ──
                  if (hasReturn)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F3F3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: List.generate(2, (i) {
                            final isSelected = selectedTab == i;
                            final label = i == 0 ? lang.S.of(ctx).filterOutbound : lang.S.of(ctx).filterReturn;
                            final depCode = i == 0 ? fromCode : toCode;
                            final arrCode = i == 0 ? toCode : fromCode;

                            return Expanded(
                              child: GestureDetector(
                                onTap: () => setModalState(() => selectedTab = i),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  margin: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    color: isSelected ? kWhite : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.08),
                                              blurRadius: 4,
                                              offset: const Offset(0, 1),
                                            ),
                                          ]
                                        : [],
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          i == 0 ? Icons.flight_takeoff : Icons.flight_land,
                                          size: 16,
                                          color: isSelected ? kPrimaryColor : kSubTitleColor,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          '$label ($depCode - $arrCode)',
                                          style: GoogleFonts.poppins(
                                            color: isSelected ? kPrimaryColor : kSubTitleColor,
                                            fontSize: 12,
                                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),

                  if (hasReturn) const SizedBox(height: 12),
                  const Divider(height: 1),

                  // ── Journey content ──
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: _FakeFlightJourneyContent(
                        flight: flight,
                        flightNumber: flightNumber,
                        fromCode: currentFromCode,
                        toCode: currentToCode,
                        date: currentDate,
                        journeyIndex: selectedTab,
                      ),
                    ),
                  ),

                  // ── Bottom bar: price + reserve button ──
                  Container(
                    padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + bottomPadding),
                    decoration: BoxDecoration(
                      color: kWhite,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 8,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                lang.S.of(ctx).sheetPricePerPerson(flight.price.toString(), 'DZD'),
                                style: GoogleFonts.poppins(
                                  color: kTitleColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                hasReturn ? lang.S.of(ctx).sheetRoundTrip : lang.S.of(ctx).sheetOneWay,
                                style: GoogleFonts.poppins(
                                  color: kSubTitleColor,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(ctx);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BookingWebView(
                                  url: 'https://www.google.com',
                                  title: lang.S.of(ctx).detailBookingTitle,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              lang.S.of(ctx).sheetBookFlight,
                              style: GoogleFonts.poppins(
                                color: kWhite,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
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
          );
        },
      );
    },
  );
}

// ── Fake flight journey content (single segment for fake data) ──
class _FakeFlightJourneyContent extends StatelessWidget {
  final FakeFlight flight;
  final String flightNumber;
  final String fromCode;
  final String toCode;
  final String date;
  final int journeyIndex;

  const _FakeFlightJourneyContent({
    required this.flight,
    required this.flightNumber,
    required this.fromCode,
    required this.toCode,
    required this.date,
    required this.journeyIndex,
  });

  @override
  Widget build(BuildContext context) {
    final stopsText = flight.stops == 0
        ? lang.S.of(context).cardDirectFlight
        : (flight.stops > 1 ? lang.S.of(context).cardStops(flight.stops.toString()) : lang.S.of(context).cardStop(flight.stops.toString()));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Journey header
        Row(
          children: [
            Icon(
              journeyIndex == 0 ? Icons.flight_takeoff : Icons.flight_land,
              color: kPrimaryColor,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '$fromCode \u2013 $toCode',
                style: GoogleFonts.poppins(
                  color: kTitleColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        // Duration + stops summary
        Padding(
          padding: const EdgeInsets.only(left: 26),
          child: Text(
            '${flight.duration}  \u2022  $stopsText',
            style: GoogleFonts.poppins(
              color: kSubTitleColor,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // ── Timeline with departure / arrival ──
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Left: times ──
              SizedBox(
                width: 58,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      flight.departureTime,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: kTitleColor,
                      ),
                    ),
                    Text(
                      date,
                      style: GoogleFonts.poppins(fontSize: 9, color: kSubTitleColor),
                    ),
                    const Spacer(),
                    Text(
                      flight.arrivalTime,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: kTitleColor,
                      ),
                    ),
                    Text(
                      date,
                      style: GoogleFonts.poppins(fontSize: 9, color: kSubTitleColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // ── Timeline dots ──
              SizedBox(
                width: 20,
                child: Column(
                  children: [
                    const SizedBox(height: 4),
                    Container(
                      width: 12, height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: kPrimaryColor, width: 2.5),
                        color: kWhite,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: 2,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [kPrimaryColor, kPrimaryColor.withOpacity(0.3)],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 12, height: 12,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: kPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              // ── Right: airport info + flight details ──
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Departure airport
                    Text(
                      lang.S.of(context).segmentAirportFallback(fromCode),
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: kTitleColor,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ── Airline + flight info block ──
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAFAFA),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFEEEEEE)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Airline row
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Image.asset(
                                  'assets/turkish_airlines.png',
                                  width: 24, height: 24,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 24, height: 24,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: kPrimaryColor.withOpacity(0.1),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'TK',
                                        style: GoogleFonts.poppins(
                                          fontSize: 8,
                                          fontWeight: FontWeight.bold,
                                          color: kPrimaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      flight.airline,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: kTitleColor,
                                      ),
                                    ),
                                    Text(
                                      lang.S.of(context).segmentFlightInfo(flightNumber, '').trimRight(),
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        color: kSubTitleColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Duration, cabin row
                          Wrap(
                            spacing: 12,
                            runSpacing: 6,
                            children: [
                              _InfoChip(
                                icon: Icons.schedule,
                                text: flight.duration,
                              ),
                              _InfoChip(
                                icon: Icons.airline_seat_recline_normal,
                                text: lang.S.of(context).classEconomy,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Arrival airport
                    Text(
                      lang.S.of(context).segmentAirportFallback(toCode),
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: kTitleColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // ── Baggage info ──
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F8F8),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFEEEEEE)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lang.S.of(context).segmentBaggage,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: kTitleColor,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.luggage, size: 16, color: kPrimaryColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      lang.S.of(context).segmentCheckedBag('24 Kg'),
                      style: GoogleFonts.poppins(fontSize: 11, color: kTitleColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.backpack, size: 16, color: kPrimaryColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      lang.S.of(context).segmentCabinBag('7 Kg'),
                      style: GoogleFonts.poppins(fontSize: 11, color: kTitleColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

