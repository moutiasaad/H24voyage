class Airport {
  final String airportName;
  final String country;
  final String cityName;
  final String iataCode;
  final String countryCode;

  Airport({
    required this.airportName,
    required this.country,
    required this.cityName,
    required this.iataCode,
    required this.countryCode,
  });

  factory Airport.fromJson(Map<String, dynamic> json) {
    return Airport(
      airportName: json['airport_name'] ?? '',
      country: json['country'] ?? '',
      cityName: json['city_name'] ?? '',
      iataCode: json['iata_code'] ?? '',
      countryCode: json['country_code'] ?? '',
    );
  }

  // For backward compatibility
  String get name => airportName;
  String get city => cityName;
  String get code => iataCode;
}

final List<Airport> airports = [
  Airport(airportName: "Aéroport d'Alger - Houari Boumediene", cityName: "Alger", iataCode: "ALG", country: "Algérie", countryCode: "DZ"),
];
