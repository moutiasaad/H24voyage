// Flight Bound Model
class FlightBound {
  final String origin;
  final String destination;
  final String departureDate;
  final String? departureTime;

  FlightBound({
    required this.origin,
    required this.destination,
    required this.departureDate,
    this.departureTime,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'origin': origin,
      'destination': destination,
      'departureDate': departureDate,
    };
    if (departureTime != null) {
      map['departureTime'] = departureTime;
    }
    return map;
  }
}
