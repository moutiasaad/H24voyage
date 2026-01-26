import 'enums/passenger_type.dart';

// Passenger Model
class Passenger {
  final String id;
  final PassengerType ptc;

  Passenger({
    required this.id,
    required this.ptc,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'ptc': ptc.name,
      };
}
