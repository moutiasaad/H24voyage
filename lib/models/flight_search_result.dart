import 'flight_offer.dart';

// Flight Search Result
class FlightSearchResult {
  final List<FlightOffer> offers;

  FlightSearchResult({
    required this.offers,
  });

  factory FlightSearchResult.fromJson(Map<String, dynamic> json) {
    return FlightSearchResult(
      offers: (json['offers'] as List<dynamic>?)
              ?.map((e) => FlightOffer.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
