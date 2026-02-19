import 'package:flight_booking/Model/ReservationStatus.dart';

class Reservation {
  final String id;
  final ReservationStatus status;

  final DateTime departureDate;
  final String departureTime;
  final String departureCity;
  final String departureCode;

  DateTime? arrivalDate;
  final String arrivalTime;
  final String arrivalCity;
  final String arrivalCode;

  final String airlineName;
  final String airlineLogo;
  final String flightNumber;

  final Duration duration;
  final double price;
  final String currency;

  Reservation({
    required this.id,
    required this.status,
    required this.departureDate,
    required this.departureTime,
    required this.departureCity,
    required this.departureCode,
     this.arrivalDate,
    required this.arrivalTime,
    required this.arrivalCity,
    required this.arrivalCode,
    required this.airlineName,
    required this.airlineLogo,
    required this.flightNumber,
    required this.duration,
    required this.price,
    required this.currency,
  });
}
