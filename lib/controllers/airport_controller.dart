import 'dart:async';
import 'package:flutter/foundation.dart';
import '../Model/Airport.dart';
import '../services/airport_service.dart';

class AirportController extends ChangeNotifier {
  List<Airport> _suggestions = [];
  String _searchQuery = '';
  Timer? _debounceTimer;

  List<Airport> get suggestions => _suggestions;
  String get searchQuery => _searchQuery;
  bool get hasSearchQuery => _searchQuery.isNotEmpty;

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
