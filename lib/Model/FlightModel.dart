class FlightModel {
  final String from;
  final String to;
  final String airline;
  final String airlineLogo;
  final String departureTime;
  final String arrivalTime;
  final String departureAirport;
  final String arrivalAirport;
  final String duration;
  final String stops;
  final double price;

  FlightModel({
    required this.from,
    required this.to,
    required this.airline,
    required this.airlineLogo,
    required this.departureTime,
    required this.arrivalTime,
    required this.departureAirport,
    required this.arrivalAirport,
    required this.duration,
    required this.stops,
    required this.price,
  });
}
