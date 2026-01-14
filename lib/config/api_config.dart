class ApiConfig {
  static const String baseUrl = 'http://n03.boosterbc.com:8138';
  static const String apiKey = '37ef0adf-837a-49c2-853b-448dddf96c3b';

  // Headers for API requests
  static Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'apikey': apiKey,
      };

  // Endpoints
  static const String suggestAirports = '/v1/suggest/airports';
}
