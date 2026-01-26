import 'dart:convert';
import 'package:crypto/crypto.dart';

class ApiConfig {
  // Base URLs
  static const String baseUrl = 'https://api.flights.aqc.boosterbc.net';
  static const String airportBaseUrl = 'http://n03.boosterbc.com:8138';

  // API Credentials
  static const String apiKey = 'a24ce438-2fcc-4941-a5a0-e4595f43a9f4';
  static const String privateKey = 'HKQLVn4EaSiLeJlZ';
  static const int distributorId = 58657;

  // Headers for API requests (simple requests without signature)
  static Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'apikey': apiKey,
      };

  // Generate timestamp (Unix timestamp in seconds)
  static int get timestamp => DateTime.now().millisecondsSinceEpoch ~/ 1000;

  // Generate signature (SHA256 hash of apiKey + privateKey + timestamp)
  static String generateSignature(int ts) {
    final data = '$apiKey$privateKey$ts';
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Headers for authenticated API requests (with signature)
  static Map<String, String> get authHeaders {
    final ts = timestamp;
    return {
      'Content-Type': 'application/json',
      'apikey': apiKey,
      'timestamp': ts.toString(),
      'signature': generateSignature(ts),
    };
  }

  // Endpoints
  static const String suggestAirports = '/v1/suggest/airports';
  static const String flightSearch = '/flights/search';
  static const String flightResults = '/flights/results';
}
