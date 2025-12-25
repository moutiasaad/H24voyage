class Airport {
  final String name;
  final String city;
  final String code;

  Airport({
    required this.name,
    required this.city,
    required this.code,
  });
  factory Airport.fromJson(Map<String, dynamic> json) {
    return Airport(
      name: json['name'],
      city: json['city'],
      code: json['code'],
    );
  }
}

final List<Airport> airports = [
  Airport(name: "Houari Boumediene", city: "Algiers, Algeria", code: "ALG"),
  Airport(name: "Mohamed Boudiaf", city: "Constantine, Algeria", code: "CZL"),
  Airport(name: "Oran Es Senia", city: "Oran, Algeria", code: "ORN"),
  Airport(name: "Rabah Bitat", city: "Annaba, Algeria", code: "AAE"),
  Airport(name: "Charles de Gaulle", city: "Paris, France", code: "CDG"),
  Airport(name: "Orly", city: "Paris, France", code: "ORY"),
  Airport(name: "Istanbul Airport", city: "Istanbul, Turkey", code: "IST"),
  Airport(name: "Antalya", city: "Antalya, Turkey", code: "AYT"),
  Airport(name: "Cairo International", city: "Cairo, Egypt", code: "CAI"),
  Airport(name: "Sharm El Sheikh", city: "Sharm El Sheikh, Egypt", code: "SSH"),
  Airport(name: "Dubai International", city: "Dubai, UAE", code: "DXB"),
  Airport(name: "Barcelona", city: "Barcelona, Spain", code: "BCN"),
  Airport(name: "Madrid", city: "Madrid, Spain", code: "MAD"),
  Airport(name: "Tunis-Carthage", city: "Tunis, Tunisia", code: "TUN"),
];
