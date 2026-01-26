import 'enums/cabin_class.dart';
import 'enums/trip_type.dart';
import 'flight_bound.dart';
import 'passenger.dart';

// Flight Search Request
class FlightSearchRequest {
  final int distributorId;
  final TripType tripType;
  final List<FlightBound> bounds;
  final List<Passenger> passengers;
  final CabinClass cabinClass;
  final int? stops;
  final bool? baggage;
  final bool? refundable;
  final List<String>? airlines;

  FlightSearchRequest({
    required this.distributorId,
    required this.tripType,
    required this.bounds,
    required this.passengers,
    this.cabinClass = CabinClass.E,
    this.stops,
    this.baggage,
    this.refundable,
    this.airlines,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'distributorId': distributorId,
      'tripType': tripType.name,
      'bounds': bounds.map((b) => b.toJson()).toList(),
      'passengers': passengers.map((p) => p.toJson()).toList(),
      'cabinClass': cabinClass.name,
    };
    if (stops != null) map['stops'] = stops;
    if (baggage != null) map['baggage'] = baggage;
    if (refundable != null) map['refundable'] = refundable;
    if (airlines != null && airlines!.isNotEmpty) map['airlines'] = airlines;
    return map;
  }
}
