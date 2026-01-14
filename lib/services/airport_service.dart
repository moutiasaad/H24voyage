import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../Model/Airport.dart';

class AirportSuggestResponse {
  final bool success;
  final List<Airport> suggestions;
  final int total;

  AirportSuggestResponse({
    required this.success,
    required this.suggestions,
    required this.total,
  });

  factory AirportSuggestResponse.fromJson(Map<String, dynamic> json) {
    return AirportSuggestResponse(
      success: json['success'] ?? false,
      suggestions: (json['suggestions'] as List<dynamic>?)
              ?.map((e) => Airport.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      total: json['total'] ?? 0,
    );
  }
}

class AirportService {
  static Future<AirportSuggestResponse> suggestAirports(String keyword) async {
    try {
      final uri = Uri.parse(
        '${ApiConfig.baseUrl}${ApiConfig.suggestAirports}?keyWord=$keyword',
      );

      final response = await http.get(
        uri,
        headers: ApiConfig.headers,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return AirportSuggestResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to load airports: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching airports: $e');
    }
  }
}
