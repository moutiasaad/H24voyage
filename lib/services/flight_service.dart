import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/models.dart';

// Flight Service
class FlightService {
  // Search for flights
  static Future<FlightSearchResponse> searchFlights(
      FlightSearchRequest request) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.flightSearch}');
      final headers = ApiConfig.authHeaders;
      final body = jsonEncode(request.toJson());

      // Log request details
      debugPrint('╔══════════════════════════════════════════════════════════');
      debugPrint('║ API REQUEST - Flight Search');
      debugPrint('╠══════════════════════════════════════════════════════════');
      debugPrint('║ URL: $uri');
      debugPrint('║ Method: POST');
      debugPrint('╠══════════════════════════════════════════════════════════');
      debugPrint('║ HEADERS:');
      headers.forEach((key, value) {
        debugPrint('║   $key: $value');
      });
      debugPrint('╠══════════════════════════════════════════════════════════');
      debugPrint('║ BODY:');
      debugPrint('║ $body');
      debugPrint('╚══════════════════════════════════════════════════════════');

      final response = await http.post(
        uri,
        headers: headers,
        body: body,
      );

      // Log response details
      debugPrint('╔══════════════════════════════════════════════════════════');
      debugPrint('║ API RESPONSE - Flight Search');
      debugPrint('╠══════════════════════════════════════════════════════════');
      debugPrint('║ Status Code: ${response.statusCode}');
      debugPrint('║ Status: ${response.reasonPhrase}');
      debugPrint('╠══════════════════════════════════════════════════════════');
      debugPrint('║ RESPONSE HEADERS:');
      response.headers.forEach((key, value) {
        debugPrint('║   $key: $value');
      });
      debugPrint('╠══════════════════════════════════════════════════════════');
      debugPrint('║ RESPONSE BODY:');
      debugPrint('║ ${response.body}');
      debugPrint('╚══════════════════════════════════════════════════════════');

      // Accept 200 and 201 as success status codes
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        debugPrint('╔══════════════════════════════════════════════════════════');
        debugPrint('║ API SUCCESS - Flight Search');
        debugPrint('║ Found ${(jsonData['data']?['offers'] as List?)?.length ?? 0} offers');
        debugPrint('╚══════════════════════════════════════════════════════════');
        return FlightSearchResponse.fromJson(jsonData);
      } else {
        // Parse error response for better error message
        try {
          final errorJson = json.decode(response.body);
          final errorDetails = errorJson['errorDetails'];
          if (errorDetails != null) {
            final errorMessage = errorDetails['message'] ?? 'Unknown error';
            // Check for "no results" error
            if (errorMessage.contains('No results available')) {
              throw Exception('Aucun vol trouvé pour ces critères. Essayez d\'autres dates ou destinations.');
            }
            throw Exception(errorMessage);
          }
        } catch (parseError) {
          if (parseError.toString().contains('Aucun vol')) {
            rethrow;
          }
        }
        throw Exception('Failed to search flights: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint('╔══════════════════════════════════════════════════════════');
      debugPrint('║ API ERROR - Flight Search');
      debugPrint('╠══════════════════════════════════════════════════════════');
      debugPrint('║ Error: $e');
      debugPrint('╚══════════════════════════════════════════════════════════');
      throw Exception('Error searching flights: $e');
    }
  }

  // Get flight results with filters
  static Future<FlightResultsResponse> getResults(
      FlightResultsRequest request) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.flightResults}')
          .replace(queryParameters: request.toQueryParams());

      final response = await http.get(
        uri,
        headers: ApiConfig.authHeaders,
      );

      // Accept 200 and 201 as success status codes
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        return FlightResultsResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to get results: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting results: $e');
    }
  }

  // Convenience method for one-way search
  // Cabin class: F (First), B (Business), PE (Premium Economy), E (Economy)
  static Future<FlightSearchResponse> searchOneWay({
    required String origin,
    required String destination,
    required String departureDate,
    required CabinClass cabinClass,
    List<Passenger>? passengers,
    int? stops,
    bool? baggage,
    List<String>? airlines,
  }) {
    return searchFlights(FlightSearchRequest(
      distributorId: ApiConfig.distributorId,
      tripType: TripType.oneway,
      bounds: [
        FlightBound(
          origin: origin,
          destination: destination,
          departureDate: departureDate,
        ),
      ],
      passengers: passengers ?? [Passenger(id: '1', ptc: PassengerType.ADT)],
      cabinClass: cabinClass,
      stops: stops,
      baggage: baggage,
      airlines: airlines,
    ));
  }

  // Convenience method for round-trip search
  static Future<FlightSearchResponse> searchRoundTrip({
    required String origin,
    required String destination,
    required String departureDate,
    required String returnDate,
    List<Passenger>? passengers,
    CabinClass cabinClass = CabinClass.E,
    int? stops,
    bool? baggage,
    bool? refundable,
    List<String>? airlines,
  }) {
    return searchFlights(FlightSearchRequest(
      distributorId: ApiConfig.distributorId,
      tripType: TripType.roundtrip,
      bounds: [
        FlightBound(
          origin: origin,
          destination: destination,
          departureDate: departureDate,
        ),
        FlightBound(
          origin: destination,
          destination: origin,
          departureDate: returnDate,
        ),
      ],
      passengers: passengers ?? [Passenger(id: '1', ptc: PassengerType.ADT)],
      cabinClass: cabinClass,
      stops: stops,
      baggage: baggage,
      refundable: refundable,
      airlines: airlines,
    ));
  }

  // Convenience method for multi-destination search
  static Future<FlightSearchResponse> searchMultiDestination({
    required List<FlightBound> bounds,
    List<Passenger>? passengers,
    CabinClass cabinClass = CabinClass.E,
    int? stops,
    bool? baggage,
    List<String>? airlines,
  }) {
    return searchFlights(FlightSearchRequest(
      distributorId: ApiConfig.distributorId,
      tripType: TripType.multidestination,
      bounds: bounds,
      passengers: passengers ?? [Passenger(id: '1', ptc: PassengerType.ADT)],
      cabinClass: cabinClass,
      stops: stops,
      baggage: baggage,
      airlines: airlines,
    ));
  }
}
