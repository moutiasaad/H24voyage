import 'flight_offer.dart';

// Flight Results Response
class FlightResultsResponse {
  final bool success;
  final List<FlightOffer> offers;
  final int? totalPages;
  final int? currentPage;
  final String? message;

  FlightResultsResponse({
    required this.success,
    this.offers = const [],
    this.totalPages,
    this.currentPage,
    this.message,
  });

  factory FlightResultsResponse.fromJson(Map<String, dynamic> json) {
    List<FlightOffer> allOffers = [];

    // Handle different response structures
    if (json['data'] != null) {
      final data = json['data'];
      if (data is List) {
        for (var item in data) {
          if (item['offers'] != null && item['offers'] is List) {
            allOffers.addAll(
              (item['offers'] as List)
                  .map((e) => FlightOffer.fromJson(e as Map<String, dynamic>)),
            );
          }
        }
      }
    } else if (json['offers'] != null && json['offers'] is List) {
      allOffers = (json['offers'] as List)
          .map((e) => FlightOffer.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return FlightResultsResponse(
      success: json['success'] ?? true,
      offers: allOffers,
      totalPages: json['totalPages'],
      currentPage: json['currentPage'],
      message: json['message'],
    );
  }
}
