// Flight Segment
class FlightSegment {
  final String? origin;
  final String? destination;
  final String? departureTime;
  final String? arrivalTime;
  final String? airline;
  final String? flightNumber;
  final String? duration;
  final int? stops;
  final String? aircraft;
  final String? cabinClass;

  FlightSegment({
    this.origin,
    this.destination,
    this.departureTime,
    this.arrivalTime,
    this.airline,
    this.flightNumber,
    this.duration,
    this.stops,
    this.aircraft,
    this.cabinClass,
  });

  factory FlightSegment.fromJson(Map<String, dynamic> json) {
    return FlightSegment(
      origin: json['origin'] ?? json['departure']?['airport'],
      destination: json['destination'] ?? json['arrival']?['airport'],
      departureTime: json['departureTime'] ?? json['departure']?['time'],
      arrivalTime: json['arrivalTime'] ?? json['arrival']?['time'],
      airline: json['airline'] ?? json['marketingCarrier'],
      flightNumber: json['flightNumber'],
      duration: json['duration'],
      stops: json['stops'],
      aircraft: json['aircraft'],
      cabinClass: json['cabinClass'],
    );
  }
}
