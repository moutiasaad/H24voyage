import 'package:flight_booking/Model/Airport.dart';

class MultiDestinationLeg {
  Airport? fromAirport;
  Airport? toAirport;
  DateTime? departureDate;

  MultiDestinationLeg({
    this.fromAirport,
    this.toAirport,
    this.departureDate,
  });
}
