import 'package:flight_booking/screen/widgets/constant.dart';
import 'package:flight_booking/controllers/airport_controller.dart';
import 'package:flight_booking/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import '../../generated/l10n.dart' as lang;

class SearchBottomSheet extends StatefulWidget {
  const SearchBottomSheet({Key? key}) : super(key: key);

  @override
  State<SearchBottomSheet> createState() => _SearchBottomSheetState();
}

class _SearchBottomSheetState extends State<SearchBottomSheet> {
  final AirportController _controller = AirportController.instance;
  final LocationService _locationService = LocationService.instance;
  final TextEditingController _textController = TextEditingController();

  String? _currentLocationName;
  bool _permissionGranted = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onControllerUpdate);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializePage();
    });
  }

  Future<void> _initializePage() async {
    // Check if permission is already granted
    _permissionGranted = await _locationService.isPermissionGranted();
    if (mounted) setState(() {});

    // If permission is granted, automatically get nearby airports
    if (_permissionGranted) {
      await _loadNearbyAirports();
    } else {
      // Fall back to loading initial airports
      _loadInitialAirportsInBackground();
    }
  }

  /// Load airports near the user's current location (silently in background)
  Future<void> _loadNearbyAirports() async {
    try {
      final cityName = await _locationService.getCurrentCityName();

      if (cityName != null && mounted) {
        setState(() {
          _currentLocationName = cityName;
        });

        // Search for airports near user's city
        _controller.searchAirports(cityName);
      } else if (mounted) {
        // Fall back to initial airports if location fails
        _loadInitialAirportsInBackground();
      }
    } catch (e) {
      // Fall back to initial airports on error
      if (mounted) {
        _loadInitialAirportsInBackground();
      }
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
  Future<void> _useCurrentLocation() async {
    try {
      // This will request permission and show dialog if needed
      final cityName = await _locationService.getCurrentCityName();

      if (cityName != null && mounted) {
        setState(() {
          _currentLocationName = cityName;
          _permissionGranted = true;
        });

        // Search for airports in that city
        _controller.searchAirports(cityName);
      } else if (mounted) {
        // Update permission status
        _permissionGranted = await _locationService.isPermissionGranted();
        if (mounted) setState(() {});
      }
    } catch (e) {
      // Silently fail
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayAirports = _controller.hasSearchQuery
        ? _controller.suggestions
        : _controller.initialAirports;

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
                hintText: 'Pays, ville ou aéroport',
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
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                onTap: _useCurrentLocation,
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
              const Divider(thickness: 1.0, color: kBorderColorTextField),
            ],

            const SizedBox(height: 10.0),
            Text(
              _currentLocationName != null
                  ? 'Aéroports à proximité'
                  : (_controller.hasSearchQuery
                      ? 'Résultats de recherche'
                      : lang.S.of(context).recentPlaceTitle),
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
                      ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: const SizedBox(
                          width: 40,
                          height: 40,
                          child: Icon(
                            Icons.flight_takeoff,
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
                        onTap: () {
                          Navigator.pop(context, airport);
                        },
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
