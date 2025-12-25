
/// 🔹 Fake Flight Model
class FakeFlight {
  final String airline;
  final String departureTime;
  final String arrivalTime;
  final String duration;
  final int stops;
  final int price;
  final int oldPrice;

  FakeFlight({
    required this.airline,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.stops,
    required this.price,
    required this.oldPrice,
  });

  factory FakeFlight.fromJson(Map<String, dynamic> json) {
    return FakeFlight(
      airline: json['airline'],
      departureTime: json['departureTime'],
      arrivalTime: json['arrivalTime'],
      duration: json['duration'],
      stops: json['stops'],
      price: json['price'],
      oldPrice: json['oldPrice'],
    );
  }
}
