import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/booking_flight.dart';

class BookingService {
  static const String _bookingsBaseUrl = 'https://api.boosterbc.com';

  /// Fetch flight bookings for a customer.
  static Future<BookingFlightResponse> fetchFlightBookings({
    required int customerId,
    String? firstName,
    String? lastName,
    String? startDate,
    String? endDate,
    String? pnr,
    int? bookingId,
    int? statusId,
  }) async {
    try {
      final queryParams = <String, String>{
        'customerId': customerId.toString(),
        if (firstName != null) 'firstName': firstName,
        if (lastName != null) 'lastName': lastName,
        if (startDate != null) 'startDate': startDate,
        if (endDate != null) 'endDate': endDate,
        if (pnr != null) 'PNR': pnr,
        if (bookingId != null) 'bookingId': bookingId.toString(),
        if (statusId != null) 'statusId': statusId.toString(),
      };

      final uri = Uri.parse('$_bookingsBaseUrl/bookings/v2/flights')
          .replace(queryParameters: queryParams);

      final headers = ApiConfig.authHeaders;

      debugPrint('╔══════════════════════════════════════════════════════════');
      debugPrint('║ API REQUEST - Fetch Flight Bookings');
      debugPrint('╠══════════════════════════════════════════════════════════');
      debugPrint('║ URL: $uri');
      debugPrint('║ Method: GET');
      debugPrint('╠══════════════════════════════════════════════════════════');
      debugPrint('║ HEADERS:');
      headers.forEach((key, value) {
        debugPrint('║   $key: $value');
      });
      debugPrint('╚══════════════════════════════════════════════════════════');

      final response = await http.get(uri, headers: headers);

      debugPrint('╔══════════════════════════════════════════════════════════');
      debugPrint('║ API RESPONSE - Fetch Flight Bookings');
      debugPrint('╠══════════════════════════════════════════════════════════');
      debugPrint('║ Status Code: ${response.statusCode}');
      debugPrint('╠══════════════════════════════════════════════════════════');
      debugPrint('║ RESPONSE BODY (first 500 chars):');
      debugPrint('║ ${response.body.length > 500 ? response.body.substring(0, 500) : response.body}');
      debugPrint('╚══════════════════════════════════════════════════════════');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        final result = BookingFlightResponse.fromJson(jsonData);
        debugPrint('║ Parsed ${result.flights.length} flight bookings');
        return result;
      } else {
        throw Exception('Failed to fetch bookings: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('║ ERROR fetching flight bookings: $e');
      rethrow;
    }
  }
}
