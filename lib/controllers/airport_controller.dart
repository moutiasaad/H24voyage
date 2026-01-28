import 'dart:async';
import 'package:flutter/foundation.dart';
import '../Model/Airport.dart';
import '../services/airport_service.dart';

class AirportController extends ChangeNotifier {
  // Singleton instance for preloading
  static final AirportController _instance = AirportController._internal();
  static AirportController get instance => _instance;

  // Factory constructor returns singleton
  factory AirportController() => _instance;

  // Private constructor
  AirportController._internal();

  List<Airport> _suggestions = [];
  List<Airport> _initialAirports = [];
  String _searchQuery = '';
  Timer? _debounceTimer;
  bool _isLoading = false;
  bool _initialLoaded = false;

  List<Airport> get suggestions => _suggestions;
  List<Airport> get initialAirports => _initialAirports;
  String get searchQuery => _searchQuery;
  bool get hasSearchQuery => _searchQuery.isNotEmpty;
  bool get isLoading => _isLoading;
  bool get initialLoaded => _initialLoaded;

  /// Preload Algerian airports - call this when home page loads
  static Future<void> preloadAirports() async {
    await _instance.fetchInitialAirports();
  }

  /// Fetch initial airports (Algerian airports)
  Future<void> fetchInitialAirports() async {
    if (_initialLoaded) return; // Already loaded

    _isLoading = true;
    // Don't notify - we want silent loading

    try {
      // Search for Algerian airports
      final response = await AirportService.suggestAirports('algerie');
      if (response.success && response.suggestions.isNotEmpty) {
        _initialAirports = response.suggestions;
      } else {
        // Fallback: try with 'alger'
        final fallbackResponse = await AirportService.suggestAirports('alger');
        if (fallbackResponse.success) {
          _initialAirports = fallbackResponse.suggestions;
        }
      }
      _initialLoaded = true;
    } catch (e) {
      debugPrint('Error fetching initial airports: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchAirports(String keyword) {
    _searchQuery = keyword;

    // Cancel previous timer
    _debounceTimer?.cancel();

    // If empty, clear suggestions and show default airports
    if (keyword.isEmpty) {
      _suggestions = [];
      notifyListeners();
      return;
    }

    // Debounce: wait 300ms after user stops typing
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _fetchAirports(keyword);
    });
  }

  Future<void> _fetchAirports(String keyword) async {
    try {
      final response = await AirportService.suggestAirports(keyword);
      if (response.success) {
        _suggestions = response.suggestions;
        notifyListeners();
      }
    } catch (e) {
      // Silently fail - keep current suggestions
      debugPrint('Error fetching airports: $e');
    }
  }

  void clear() {
    _searchQuery = '';
    _suggestions = [];
    _debounceTimer?.cancel();
    notifyListeners();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
