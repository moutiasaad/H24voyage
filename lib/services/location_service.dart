import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  static LocationService get instance => _instance;

  String? lastError;
  Position? lastPosition;

  /// Request location permission - shows system dialog
  Future<bool> requestPermission() async {
    try {
      // Check if location service is enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        lastError = 'Les services de localisation sont désactivés. Veuillez les activer.';
        // Open location settings
        await Geolocator.openLocationSettings();
        return false;
      }

      // Check current permission status
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        // Request permission - this shows the system dialog
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          lastError = 'Permission de localisation refusée';
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        lastError = 'Permission refusée définitivement. Activez-la dans les paramètres.';
        // Open app settings
        await openAppSettings();
        return false;
      }

      lastError = null;
      return true;
    } catch (e) {
      print('Error requesting permission: $e');
      lastError = 'Erreur lors de la demande de permission';
      return false;
    }
  }

  /// Get current GPS position
  Future<Position?> getCurrentPosition() async {
    try {
      // Request permission first
      bool hasPermission = await requestPermission();
      if (!hasPermission) {
        return null;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );

      lastPosition = position;
      lastError = null;
      return position;
    } catch (e) {
      print('Error getting position: $e');
      lastError = 'Impossible d\'obtenir votre position GPS';
      return null;
    }
  }

  /// Get city name from GPS coordinates using OpenStreetMap Nominatim (free)
  Future<String?> getCityFromCoordinates(double latitude, double longitude) async {
    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude&zoom=10&addressdetails=1',
      );

      final response = await http.get(
        url,
        headers: {
          'User-Agent': 'H24VoyagesApp/1.0',
          'Accept-Language': 'fr',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final address = data['address'];

        if (address != null) {
          // Try to get city name in order of preference
          String? city = address['city'] ??
              address['town'] ??
              address['village'] ??
              address['municipality'] ??
              address['county'] ??
              address['state'];

          return city;
        }
      }

      lastError = 'Impossible de déterminer votre ville';
      return null;
    } catch (e) {
      print('Error getting city from coordinates: $e');
      lastError = 'Erreur de connexion au service de géolocalisation';
      return null;
    }
  }

  /// Main method: Get current city name from GPS
  Future<String?> getCurrentCityName() async {
    try {
      // Get GPS position
      Position? position = await getCurrentPosition();
      if (position == null) {
        return null;
      }

      // Convert coordinates to city name
      String? city = await getCityFromCoordinates(
        position.latitude,
        position.longitude,
      );

      return city;
    } catch (e) {
      print('Error getting current city: $e');
      lastError = 'Erreur lors de la récupération de votre position';
      return null;
    }
  }

  /// Check if permission is granted (without requesting)
  Future<bool> isPermissionGranted() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      return permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;
    } catch (e) {
      return false;
    }
  }

  /// Check if location service is enabled
  Future<bool> isLocationServiceEnabled() async {
    try {
      return await Geolocator.isLocationServiceEnabled();
    } catch (e) {
      return false;
    }
  }
}
