import 'dart:convert';

import 'package:flight_booking/Model/Airport.dart';
import 'package:flight_booking/Model/FakeFlight.dart';
import 'package:flight_booking/screen/search/flight_details.dart';
import 'package:flight_booking/screen/widgets/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../generated/l10n.dart' as lang;
import 'filter.dart';

class SearchResult extends StatefulWidget {
  final Airport fromAirport;
  final Airport toAirport;
  final int adultCount;
  final int childCount;
  final int infantCount;
  final DateTimeRange? dateRange;

  const SearchResult({
    Key? key,
    required this.fromAirport,
    required this.toAirport,
    required this.adultCount,
    required this.childCount,
    required this.infantCount,
    this.dateRange,
  }) : super(key: key);

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  bool isDirectOnly = false;
  List<FakeFlight> flights = [];
  Set<int> expandedOutbound = {};
  Set<int> expandedReturn = {};
  String selectedSortOption = 'Le moins cher';

  // Filter options
  int selectedFilterCategory = 2; // 0: Compagnies, 1: Prix, 2: Escale, 3: Aéroport
  int selectedFilterTab = 0; // 0: Aller, 1: Retour
  String selectedEscaleOption = 'Tous';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFakeFlightsFromAirports();
    });
  }

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

          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // Vol direct toggle + Filter buttons
                  _buildFilterSection(),

                  const SizedBox(height: 12),

                  // Price filter chips
                  _buildPriceChips(),

                  const SizedBox(height: 12),

                  // Promotional banner
                  _buildPromoBanner(),

                  const SizedBox(height: 16),

                  // Flight cards
                  ListView.builder(
                    itemCount: flights.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder: (_, i) {
                      final f = flights[i];
                      return _buildFlightCard(f, i, fromCode, toCode);
                    },
                  ),

                  const SizedBox(height: 20),
                ],
              ),
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
              left: 16,
              right: 16,
              bottom: 20,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: kTitleColor, size: 24),
                  ),
                  const SizedBox(width: 12),

                  // Route info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              fromCity,
                              style: kTextStyle.copyWith(
                                color: kTitleColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '⇆',
                              style: kTextStyle.copyWith(
                                color: kTitleColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                toCity,
                                style: kTextStyle.copyWith(
                                  color: kTitleColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              '$startDate à $endDate',
                              style: kTextStyle.copyWith(
                                color: kTitleColor,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              ' · ',
                              style: kTextStyle.copyWith(
                                color: kTitleColor,
                                fontSize: 12,
                              ),
                            ),
                            Icon(Icons.person_outline,
                                color: kTitleColor.withOpacity(0.8), size: 14),
                            const SizedBox(width: 2),
                            Text(
                              '$totalPassengers',
                              style: kTextStyle.copyWith(
                                color: kTitleColor,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              ' · ',
                              style: kTextStyle.copyWith(
                                color: kTitleColor,
                                fontSize: 12,
                              ),
                            ),
                            Icon(Icons.luggage_outlined,
                                color: kTitleColor.withOpacity(0.8), size: 14),
                            const SizedBox(width: 2),
                            Text(
                              '${widget.infantCount}',
                              style: kTextStyle.copyWith(
                                color: kSubTitleColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // const SizedBox(width: 8),

                  // Edit button
                  Container(
                    padding: const EdgeInsets.all(8),
                    // decoration: BoxDecoration(
                    //   color: kWhite,
                    //   borderRadius: BorderRadius.circular(8),
                    //   border: Border.all(color: kPrimaryColor, width: 1.5),
                    // ),
                    child: Image.asset(
                      'assets/editer 1.png',
                      width: 20,
                      height: 20,
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Vol direct toggle
          Text(
            'Vol direct',
            style: kTextStyle.copyWith(
              color: kTitleColor,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 4),
          SizedBox(
            height: 24,
            child: Switch(
              value: isDirectOnly,
              onChanged: (val) => setState(() => isDirectOnly = val),
              activeColor: kPrimaryColor,
              activeTrackColor: kPrimaryColor.withOpacity(0.3),
              inactiveThumbColor: kWhite,
              inactiveTrackColor: const Color(0xFFE0E0E0),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
            ),
          ),

          const Spacer(),

          // Filtrer button
          GestureDetector(
            onTap: () => _showFilterBottomSheet(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: kWhite,
                border: Border.all(color: kPrimaryColor, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/filter.png',
                    width: 18,
                    height: 18,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.tune, color: kPrimaryColor, size: 18);
                    },
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Filtrer',
                    style: kTextStyle.copyWith(
                      color: kPrimaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Trier button
          GestureDetector(
            onTap: () => _showSortBottomSheet(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: kWhite,
                border: Border.all(color: kPrimaryColor, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/trie.png',
                    width: 18,
                    height: 18,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.swap_vert, color: kPrimaryColor, size: 18);
                    },
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Trier',
                    style: kTextStyle.copyWith(
                      color: kPrimaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
  Map<String, dynamic> get filterData => {
    'categories': ['Compagnies', 'Prix', 'Escale', 'Aéroport'],
    'compagnies': [
      {'name': 'Turkish airline', 'code': 'TK', 'logo': 'assets/turkish_airlines.png', 'selected': false},
      {'name': 'Tunisair', 'code': 'TU', 'logo': 'assets/TU.png', 'selected': false},
      {'name': 'Air algerie', 'code': 'AH', 'logo': 'assets/air_algerie.png', 'selected': false},
      {'name': 'Qatar-airways', 'code': 'QR', 'logo': 'assets/qatar_airways.png', 'selected': false},
      {'name': 'Nouvelair', 'code': 'BJ', 'logo': 'assets/nouvelair.png', 'selected': false},
      {'name': 'Tassili airlines', 'code': 'SF', 'logo': 'assets/tassili_airlines.png', 'selected': false},
      {'name': 'Lufthansa', 'code': 'LH', 'logo': 'assets/lufthansa.png', 'selected': false},
    ],
    'prix': {
      'min': 0,
      'max': 50000,
      'currency': 'DZD',
    },
    'escale': ['Tous', 'Direct', 'Jusqu\'à 1 escale', 'Jusqu\'à 2 escale'],
    'aeroports': {
      'depart': {
        'city': 'Paris',
        'airports': [
          {'name': 'Paris Charles de Gaulle Apt.', 'code': 'CDG', 'selected': false},
          {'name': 'Paris Orly Apt.', 'code': 'ORY', 'selected': false},
        ],
      },
      'arrivee': {
        'city': 'Algiers',
        'airports': [
          {'name': 'Houari Boumediene.', 'code': 'ALG', 'selected': false},
        ],
      },
    },
  };

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
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Filtrer',
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
                  ),

                  const Divider(height: 1, color: kBorderColorTextField),

                  // Content
                  Expanded(
                    child: Row(
                      children: [
                        // Left side menu
                        Container(
                          width: 110,
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
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected ? const Color(0xFFF5F5F5) : Colors.transparent,
                                  ),
                                  child: Text(
                                    filterCategories[index],
                                    style: GoogleFonts.poppins(
                                      color: isSelected ? kTitleColor : kSubTitleColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      height: 30 / 12,
                                    ),
                                  ),
                                ),
                              );
                            }),
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
                          // Reset button
                          GestureDetector(
                            onTap: () {
                              setModalState(() {
                                tempEscaleOption = 'Tous';
                                tempSelectedCategory = 2;
                                tempSelectedTab = 0;
                                for (var c in tempCompagnies) {
                                  c['selected'] = false;
                                }
                                for (var a in tempAeroports['depart']['airports']) {
                                  a['selected'] = false;
                                }
                                for (var a in tempAeroports['arrivee']['airports']) {
                                  a['selected'] = false;
                                }
                              });
                            },
                            child: Container(
                              width: 126,
                              height: 30,
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
                              });
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
            // Airline logo
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Image.asset(
                  logo,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 40,
                      height: 40,
                      color: const Color(0xFFF5F5F5),
                      child: Center(
                        child: Text(
                          name.isNotEmpty ? name[0].toUpperCase() : 'A',
                          style: GoogleFonts.poppins(
                            color: kSubTitleColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  },
                ),
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

  // Dynamic filter chips data - can be loaded from API/JSON
  List<Map<String, dynamic>> get filterChips => [
    {
      'logo': 'assets/turkish_airlines2.png',
      'text': '10408 DZD',
      'type': 'price',
    },
    {
      'logo': 'assets/turkish_airlines.png',
      'text': '10408 DZD',
      'type': 'price',
    },
    {
      'logo': 'assets/TU.png',
      'text': 'Tunisiair',
      'type': 'airline',
    },
  ];

  Widget _buildPriceChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: filterChips.map((chip) {
          return Container(
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: kBorderColorTextField, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Airline logo
                ClipOval(
                  child: Image.asset(
                    chip['logo'],
                    width: 20,
                    height: 20,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: kPrimaryColor.withOpacity(0.1),
                        ),
                        child: Icon(
                          Icons.flight,
                          size: 12,
                          color: kPrimaryColor,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                // Text (price or airline name)
                Text(
                  chip['text'],
                  style: kTextStyle.copyWith(
                    color: kTitleColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_offer, color: kPrimaryColor, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Trouvez les offres aux meilleurs prix!',
              style: kTextStyle.copyWith(
                color: kTitleColor,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            'Cliquez ici',
            style: kTextStyle.copyWith(
              color: kPrimaryColor,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlightCard(
      FakeFlight f, int index, String fromCode, String toCode) {
    final flightNumber = 'TK ${123456 + index}';
    final outboundDate = _formatFlightDate(widget.dateRange?.start);
    final returnDate = _formatFlightDate(widget.dateRange?.end);
    final isOutboundExpanded = expandedOutbound.contains(index);
    final isReturnExpanded = expandedReturn.contains(index);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kBorderColorTextField),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recommandé badge
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(221, 225, 255, 1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Recommandé',
                style: kTextStyle.copyWith(
                  color: const Color.fromRGBO(147, 133, 245, 1),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
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

                const SizedBox(height: 12),
                const Divider(height: 1, color: kBorderColorTextField),
                const SizedBox(height: 12),

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

                const SizedBox(height: 20),

                // Price and Reserve button
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Price with dropdown
                    Row(
                      children: [
                        Text(
                          '${f.price} $currencySign',
                          style: GoogleFonts.poppins(
                            color: kTitleColor,
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                            height: 30 / 18,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.keyboard_arrow_down,
                            color: kTitleColor, size: 22),
                      ],
                    ),

                    const SizedBox(width: 16),

                    // Reserve button
                    GestureDetector(
                      onTap: () => const FlightDetails().launch(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 28, vertical: 12),
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Réservez',
                          style: kTextStyle.copyWith(
                            color: kWhite,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
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
  }) {
    // Colors from design
    const Color textGray = Color.fromRGBO(130, 130, 130, 1);
    const Color textBlack = Color.fromRGBO(51, 51, 51, 1);
    const Color textOrange = Color.fromRGBO(255, 87, 34, 1);
    const Color directGreen = Color.fromRGBO(76, 175, 80, 1);
    const Color detailsBlue = Color.fromRGBO(0, 118, 209, 1);
    const Color lineGray = Color.fromRGBO(200, 200, 200, 1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Airline info row
        Row(
          children: [
            Container(
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(airlineLogo),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              airlineName,
              style: GoogleFonts.poppins(
                color: textBlack,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

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
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    height: 30 / 13,
                  ),
                ),
                Text(
                  departureTime,
                  style: GoogleFonts.poppins(
                    color: textBlack,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    height: 30 / 16,
                  ),
                ),
                Text(
                  fromCode,
                  style: GoogleFonts.poppins(
                    color: textGray,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    height: 30 / 13,
                  ),
                ),
              ],
            ),

            // Left connecting line
            Expanded(
              child: Container(
                height: 1,
                color: lineGray,
                margin: const EdgeInsets.only(left: 8, right: 0),
              ),
            ),

            // Duration and Direct badge - centered
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(241, 241, 241, 1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.poppins(
                    color: textGray,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                  children: [
                    TextSpan(text: '$duration . '),
                    TextSpan(
                      text: isDirect ? 'Direct' : '${1} escale',
                      style: GoogleFonts.poppins(
                        color: isDirect ? directGreen : textOrange,
                        fontSize: 12,
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
                margin: const EdgeInsets.only(left: 0, right: 8),
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
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    height: 30 / 13,
                  ),
                ),
                Text(
                  arrivalTime,
                  style: GoogleFonts.poppins(
                    color: textBlack,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    height: 30 / 16,
                  ),
                ),
                Text(
                  toCode,
                  style: GoogleFonts.poppins(
                    color: textGray,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    height: 30 / 13,
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 10),

        // Baggage info and Details row
        Row(
          children: [
            // Baggage icons
            Row(
              children: [
                Image.asset(
                  'assets/cabin_bag.png',
                  width: 20,
                  height: 20,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.work_outline, color: textGray, size: 18);
                  },
                ),
                const SizedBox(width: 4),
                Text(
                  '7Kg',
                  style: GoogleFonts.poppins(
                    color: textGray,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(width: 10),
                Image.asset(
                  'assets/luggage.png',
                  width: 20,
                  height: 20,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.luggage_outlined, color: textGray, size: 18);
                  },
                ),
                const SizedBox(width: 4),
                Text(
                  '24Kg',
                  style: GoogleFonts.poppins(
                    color: textGray,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.keyboard_arrow_down, color: textGray, size: 18),
              ],
            ),

            const Spacer(),

            // Details dropdown
            GestureDetector(
              onTap: onToggleExpand,
              child: Row(
                children: [
                  Text(
                    'Détails vol',
                    style: GoogleFonts.poppins(
                      color: detailsBlue,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: detailsBlue,
                    size: 18,
                  ),
                ],
              ),
            ),
          ],
        ),

        // Expanded details
        if (isExpanded) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: kWebsiteGreyBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Informations du vol',
                  style: GoogleFonts.poppins(
                    color: textBlack,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: kTextStyle.copyWith(
              color: kSubTitleColor,
              fontSize: 12,
            ),
          ),
          Text(
            value,
            style: kTextStyle.copyWith(
              color: kTitleColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
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
