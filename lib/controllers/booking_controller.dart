import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/booking_flight.dart';
import '../services/booking_service.dart';

class BookingController extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  List<BookingFlight> _flights = [];
  List<BookingFlight> get flights => _flights;

  /// Active bookings: statusId not cancelled (4) and not failure (12),
  /// and depDate is today or in the future.
  List<BookingFlight> get activeFlights => _flights.where((f) {
        final isCancelled = f.statusId == 4;
        final isFailure = f.statusId == 12;
        return !isCancelled && !isFailure;
      }).toList();

  /// Past/completed bookings: departure date is in the past and not cancelled.
  List<BookingFlight> get pastFlights => _flights.where((f) {
        final isCancelled = f.statusId == 4;
        final isFailure = f.statusId == 12;
        if (isCancelled || isFailure) return false;
        if (f.depDate == null) return false;
        return f.depDate!.isBefore(DateTime.now());
      }).toList();

  /// Cancelled bookings: statusId == 4 or statusId == 12 (Failure Ticket).
  List<BookingFlight> get cancelledFlights =>
      _flights.where((f) => f.statusId == 4 || f.statusId == 12).toList();

  /// Fetch flight bookings from API.
  Future<void> fetchFlightBookings({
    String? startDate,
    String? endDate,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final customerId = prefs.getInt('customer_id');

      if (customerId == null) {
        _errorMessage = 'User not logged in';
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Default date range: 6 months back to today
      final now = DateTime.now();
      final defaultStart = DateTime(now.year, now.month - 6, now.day);
      final sDate = startDate ?? _formatDate(defaultStart);
      final eDate = endDate ?? _formatDate(now);

      final response = await BookingService.fetchFlightBookings(
        customerId: customerId,
        startDate: sDate,
        endDate: eDate,
      );

      if (response.success) {
        _flights = response.flights;
        // Sort by booking date descending (newest first)
        _flights.sort((a, b) {
          if (a.bookingDate == null && b.bookingDate == null) return 0;
          if (a.bookingDate == null) return 1;
          if (b.bookingDate == null) return -1;
          return b.bookingDate!.compareTo(a.bookingDate!);
        });
      } else {
        _errorMessage = 'Failed to load bookings';
      }
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('BookingController error: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Refresh bookings.
  Future<void> refresh() => fetchFlightBookings();

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
