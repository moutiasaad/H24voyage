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
  // Algerie
  Airport(airportName: "Aeroport d'Alger - Houari Boumediene", cityName: "Alger", iataCode: "ALG", country: "Algerie", countryCode: "DZ"),
  Airport(airportName: "Aeroport d'Oran - Ahmed Ben Bella", cityName: "Oran", iataCode: "ORN", country: "Algerie", countryCode: "DZ"),
  Airport(airportName: "Aeroport de Constantine - Mohamed Boudiaf", cityName: "Constantine", iataCode: "CZL", country: "Algerie", countryCode: "DZ"),
  Airport(airportName: "Aeroport d'Annaba - Rabah Bitat", cityName: "Annaba", iataCode: "AAE", country: "Algerie", countryCode: "DZ"),
  Airport(airportName: "Aeroport de Setif - 8 Mai 1945", cityName: "Setif", iataCode: "QSF", country: "Algerie", countryCode: "DZ"),
  Airport(airportName: "Aeroport de Bejaia - Soummam", cityName: "Bejaia", iataCode: "BJA", country: "Algerie", countryCode: "DZ"),
  Airport(airportName: "Aeroport de Tlemcen - Zenata", cityName: "Tlemcen", iataCode: "TLM", country: "Algerie", countryCode: "DZ"),
  // Tunisie
  Airport(airportName: "Aeroport de Tunis-Carthage", cityName: "Tunis", iataCode: "TUN", country: "Tunisie", countryCode: "TN"),
  Airport(airportName: "Aeroport de Djerba-Zarzis", cityName: "Djerba", iataCode: "DJE", country: "Tunisie", countryCode: "TN"),
  Airport(airportName: "Aeroport de Monastir Habib Bourguiba", cityName: "Monastir", iataCode: "MIR", country: "Tunisie", countryCode: "TN"),
  Airport(airportName: "Aeroport de Sfax-Thyna", cityName: "Sfax", iataCode: "SFA", country: "Tunisie", countryCode: "TN"),
  // France
  Airport(airportName: "Aeroport Paris-Charles de Gaulle", cityName: "Paris", iataCode: "CDG", country: "France", countryCode: "FR"),
  Airport(airportName: "Aeroport Paris-Orly", cityName: "Paris", iataCode: "ORY", country: "France", countryCode: "FR"),
  Airport(airportName: "Aeroport de Marseille-Provence", cityName: "Marseille", iataCode: "MRS", country: "France", countryCode: "FR"),
  Airport(airportName: "Aeroport de Lyon-Saint Exupery", cityName: "Lyon", iataCode: "LYS", country: "France", countryCode: "FR"),
  Airport(airportName: "Aeroport de Nice-Cote d'Azur", cityName: "Nice", iataCode: "NCE", country: "France", countryCode: "FR"),
  Airport(airportName: "Aeroport de Toulouse-Blagnac", cityName: "Toulouse", iataCode: "TLS", country: "France", countryCode: "FR"),
  Airport(airportName: "Aeroport de Bordeaux-Merignac", cityName: "Bordeaux", iataCode: "BOD", country: "France", countryCode: "FR"),
  // Maroc
  Airport(airportName: "Aeroport Mohammed V", cityName: "Casablanca", iataCode: "CMN", country: "Maroc", countryCode: "MA"),
  Airport(airportName: "Aeroport de Marrakech-Menara", cityName: "Marrakech", iataCode: "RAK", country: "Maroc", countryCode: "MA"),
  Airport(airportName: "Aeroport de Rabat-Sale", cityName: "Rabat", iataCode: "RBA", country: "Maroc", countryCode: "MA"),
  Airport(airportName: "Aeroport de Tanger Ibn Battouta", cityName: "Tanger", iataCode: "TNG", country: "Maroc", countryCode: "MA"),
  // Turquie
  Airport(airportName: "Istanbul Airport", cityName: "Istanbul", iataCode: "IST", country: "Turquie", countryCode: "TR"),
  Airport(airportName: "Aeroport d'Antalya", cityName: "Antalya", iataCode: "AYT", country: "Turquie", countryCode: "TR"),
  // Autres destinations
  Airport(airportName: "Dubai International Airport", cityName: "Dubai", iataCode: "DXB", country: "Emirats Arabes Unis", countryCode: "AE"),
  Airport(airportName: "Cairo International Airport", cityName: "Le Caire", iataCode: "CAI", country: "Egypte", countryCode: "EG"),
  Airport(airportName: "Aeroport de Madrid-Barajas", cityName: "Madrid", iataCode: "MAD", country: "Espagne", countryCode: "ES"),
  Airport(airportName: "Aeroport de Barcelone-El Prat", cityName: "Barcelone", iataCode: "BCN", country: "Espagne", countryCode: "ES"),
  Airport(airportName: "Aeroport de Rome-Fiumicino", cityName: "Rome", iataCode: "FCO", country: "Italie", countryCode: "IT"),
  Airport(airportName: "Aeroport de Milan-Malpensa", cityName: "Milan", iataCode: "MXP", country: "Italie", countryCode: "IT"),
  Airport(airportName: "London Heathrow Airport", cityName: "Londres", iataCode: "LHR", country: "Royaume-Uni", countryCode: "GB"),
  Airport(airportName: "London Gatwick Airport", cityName: "Londres", iataCode: "LGW", country: "Royaume-Uni", countryCode: "GB"),
  Airport(airportName: "Frankfurt Airport", cityName: "Francfort", iataCode: "FRA", country: "Allemagne", countryCode: "DE"),
  Airport(airportName: "Amsterdam Schiphol Airport", cityName: "Amsterdam", iataCode: "AMS", country: "Pays-Bas", countryCode: "NL"),
  Airport(airportName: "Brussels Airport", cityName: "Bruxelles", iataCode: "BRU", country: "Belgique", countryCode: "BE"),
  Airport(airportName: "Aeroport de Geneve", cityName: "Geneve", iataCode: "GVA", country: "Suisse", countryCode: "CH"),
  Airport(airportName: "Montreal-Trudeau Airport", cityName: "Montreal", iataCode: "YUL", country: "Canada", countryCode: "CA"),
  Airport(airportName: "John F. Kennedy International Airport", cityName: "New York", iataCode: "JFK", country: "Etats-Unis", countryCode: "US"),
  Airport(airportName: "Jeddah King Abdulaziz Airport", cityName: "Jeddah", iataCode: "JED", country: "Arabie Saoudite", countryCode: "SA"),
  Airport(airportName: "Doha Hamad International Airport", cityName: "Doha", iataCode: "DOH", country: "Qatar", countryCode: "QA"),
];
