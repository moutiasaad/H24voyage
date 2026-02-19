import 'dart:convert';
import 'package:flight_booking/screen/widgets/constant.dart';
import 'package:flight_booking/screen/widgets/button_global.dart';
import 'package:flight_booking/controllers/airport_controller.dart';
import 'package:flight_booking/services/location_service.dart';
import 'package:flight_booking/Model/Airport.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../generated/l10n.dart' as lang;

class SearchBottomSheet extends StatefulWidget {
  /// If true, shows flight_land icon (for destination selection)
  /// If false, shows flight_takeoff icon (for departure selection)
  final bool isDestination;

  const SearchBottomSheet({
    Key? key,
    this.isDestination = false,
  }) : super(key: key);

  @override
  State<SearchBottomSheet> createState() => _SearchBottomSheetState();
}

class _SearchBottomSheetState extends State<SearchBottomSheet> {
  final AirportController _controller = AirportController.instance;
  final LocationService _locationService = LocationService.instance;
  final TextEditingController _textController = TextEditingController();

  String? _currentLocationName;
  bool _permissionGranted = false;

  // Recent airports from cache
  List<Airport> _recentAirports = [];
  static const String _recentDeparturesKey = 'recent_departure_airports';
  static const String _recentDestinationsKey = 'recent_destination_airports';
  static const int _maxRecentAirports = 5;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onControllerUpdate);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializePage();
    });
  }

  Future<void> _initializePage() async {
    // Load recent airports from cache first
    await _loadRecentAirports();

    // Check if permission is already granted
    _permissionGranted = await _locationService.isPermissionGranted();
    if (mounted) setState(() {});

    // If permission is granted, just get the location name (for future API use)
    // but keep showing the default airport list
    if (_permissionGranted) {
      await _getLocationOnly();
    }

    // Always load initial airports as default list
    _loadInitialAirportsInBackground();
  }

  /// Load recent airports from SharedPreferences
  Future<void> _loadRecentAirports() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = widget.isDestination ? _recentDestinationsKey : _recentDeparturesKey;
      final jsonString = prefs.getString(key);

      if (jsonString != null) {
        final List<dynamic> jsonList = json.decode(jsonString);
        _recentAirports = jsonList.map<Airport>((item) => Airport(
          iataCode: item['iataCode'] ?? '',
          airportName: item['airportName'] ?? '',
          cityName: item['cityName'] ?? '',
          country: item['country'] ?? '',
          countryCode: item['countryCode'] ?? '',
        )).toList();

        if (mounted) setState(() {});
      }
    } catch (e) {
      // Silently fail if cache read fails
    }
  }

  /// Save airport to recent selections
  static Future<void> saveRecentAirport(Airport airport, {required bool isDestination}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = isDestination ? _recentDestinationsKey : _recentDeparturesKey;

      // Load existing
      List<Map<String, String>> recentList = [];
      final jsonString = prefs.getString(key);
      if (jsonString != null) {
        final List<dynamic> jsonList = json.decode(jsonString);
        recentList = jsonList.map((item) => Map<String, String>.from(item)).toList();
      }

      // Remove if already exists (to move to top)
      recentList.removeWhere((item) => item['iataCode'] == airport.iataCode);

      // Add to beginning
      recentList.insert(0, {
        'iataCode': airport.iataCode,
        'airportName': airport.airportName,
        'cityName': airport.cityName,
        'country': airport.country,
        'countryCode': airport.countryCode,
      });

      // Keep only max items
      if (recentList.length > _maxRecentAirports) {
        recentList = recentList.sublist(0, _maxRecentAirports);
      }

      // Save
      await prefs.setString(key, json.encode(recentList));
    } catch (e) {
      // Silently fail
    }
  }

  /// Get user's location only (for future API use) without searching airports
  Future<void> _getLocationOnly() async {
    try {
      final cityName = await _locationService.getCurrentCityName();

      if (cityName != null && mounted) {
        setState(() {
          _currentLocationName = cityName;
        });
      }
    } catch (e) {
      // Silently fail - location is optional
    }
  }

  void _loadInitialAirportsInBackground() {
    if (_controller.initialAirports.isEmpty && !_controller.isLoading) {
      _controller.fetchInitialAirports();
    }
  }

  void _onControllerUpdate() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    _textController.dispose();
    super.dispose();
  }

  /// Get current location - requests permission if needed
  /// Stores location for future API use, hides the button, but keeps default list
  Future<void> _useCurrentLocation() async {
    try {
      // This will request permission and show dialog if needed
      final cityName = await _locationService.getCurrentCityName();

      if (cityName != null && mounted) {
        setState(() {
          _currentLocationName = cityName;
          _permissionGranted = true;
        });
        // Location stored for future API use
        // Keep showing the default airport list (don't search)
      } else if (mounted) {
        // Update permission status
        _permissionGranted = await _locationService.isPermissionGranted();
        if (mounted) setState(() {});
      }
    } catch (e) {
      // Silently fail
    }
  }

  /// Handle airport selection
  void _selectAirport(Airport airport) {
    // Save to recent
    saveRecentAirport(airport, isDestination: widget.isDestination);
    // Return selected airport
    Navigator.pop(context, airport);
  }

  @override
  Widget build(BuildContext context) {
    final displayAirports = _controller.hasSearchQuery
        ? _controller.suggestions
        : _controller.initialAirports;

    // Get the appropriate icon based on selection type
    final airportIcon = widget.isDestination
        ? Icons.flight_land
        : Icons.flight_takeoff;

    return Container(
      height: context.height() * 0.85,
      padding: const EdgeInsets.all(20.0),
      decoration: const BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: kBorderColorTextField,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Title
            Text(
              widget.isDestination ? lang.S.of(context).homeDestination : lang.S.of(context).homeDeparturePlace,
              style: kTextStyle.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: kTitleColor,
              ),
            ),
            const SizedBox(height: 16),

            // Search input
            TextFormField(
              controller: _textController,
              showCursor: true,
              keyboardType: TextInputType.name,
              cursorColor: kTitleColor,
              onChanged: (value) {
                _controller.searchAirports(value);
              },
              decoration: kInputDecoration.copyWith(
                contentPadding: const EdgeInsets.only(left: 10, right: 10),
                hintText: lang.S.of(context).searchSheetHint,
                hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                border: const OutlineInputBorder(),
                prefixIcon: Icon(
                  FeatherIcons.search,
                  color: kSubTitleColor,
                ),
                suffixIcon: _controller.hasSearchQuery || _textController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: kSubTitleColor),
                        onPressed: () {
                          _textController.clear();
                          _controller.clear();
                          // Reload nearby airports if location is available
                          if (_currentLocationName != null) {
                            _controller.searchAirports(_currentLocationName!);
                          }
                        },
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 20.0),

            // Current location tile - only show when location is not yet obtained
            if (_currentLocationName == null) ...[
              TappableCard(
                onTap: _useCurrentLocation,
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    IconlyBold.send,
                    color: _permissionGranted ? kPrimaryColor : kSubTitleColor,
                  ),
                  title: Text(
                    lang.S.of(context).currentLocation,
                    style: kTextStyle.copyWith(color: kSubTitleColor),
                  ),
                  subtitle: Text(
                    lang.S.of(context).useCurrentLocation,
                    style: kTextStyle.copyWith(
                      color: kTitleColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Icon(
                    _permissionGranted ? Icons.my_location : Icons.location_off,
                    color: _permissionGranted ? kPrimaryColor : kSubTitleColor,
                    size: 20,
                  ),
                ),
              ),
              const Divider(thickness: 1.0, color: kBorderColorTextField),
            ],

            // Recent airports section (only show for destination, not searching, and has recent)
            if (widget.isDestination && !_controller.hasSearchQuery && _recentAirports.isNotEmpty) ...[
              const SizedBox(height: 10.0),
              Text(
                lang.S.of(context).searchSheetRecent,
                style: kTextStyle.copyWith(
                  color: kSubTitleColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10.0),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _recentAirports.length,
                itemBuilder: (_, i) {
                  final airport = _recentAirports[i];
                  return Column(
                    children: [
                      TappableCard(
                        onTap: () => _selectAirport(airport),
                        child: ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          leading: SizedBox(
                            width: 40,
                            height: 40,
                            child: Icon(
                              Icons.history,
                              color: kSubTitleColor,
                              size: 24,
                            ),
                          ),
                          title: Text(
                            airport.name,
                            style: kTextStyle.copyWith(
                              color: kTitleColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            '${airport.city}, ${airport.country}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: kTextStyle.copyWith(color: kSubTitleColor),
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: kSubTitleColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              airport.code,
                              style: kTextStyle.copyWith(
                                color: kSubTitleColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Divider(thickness: 1.0, color: kBorderColorTextField),
                    ],
                  );
                },
              ),
              const SizedBox(height: 10.0),
            ],

            const SizedBox(height: 10.0),
            Text(
              _controller.hasSearchQuery
                  ? lang.S.of(context).searchSheetResults
                  : lang.S.of(context).recentPlaceTitle,
              style: kTextStyle.copyWith(
                  color: kSubTitleColor, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),

            // Airports list (no loading indicator)
            if (displayAirports.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: displayAirports.length,
                itemBuilder: (_, i) {
                  final airport = displayAirports[i];
                  return Column(
                    children: [
                      TappableCard(
                        onTap: () => _selectAirport(airport),
                        child: ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          leading: SizedBox(
                            width: 40,
                            height: 40,
                            child: Icon(
                              airportIcon,
                              color: kPrimaryColor,
                              size: 28,
                            ),
                          ),
                          title: Text(
                            airport.name,
                            style: kTextStyle.copyWith(
                              color: kTitleColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            '${airport.city}, ${airport.country}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: kTextStyle.copyWith(color: kSubTitleColor),
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: kPrimaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              airport.code,
                              style: kTextStyle.copyWith(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Divider(thickness: 1.0, color: kBorderColorTextField),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
