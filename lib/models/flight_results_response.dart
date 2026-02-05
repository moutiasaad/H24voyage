import 'flight_offer.dart';

// Flight Results Response
class FlightResultsResponse {
  final bool success;
  final List<FlightOffer> offers;
  final int? totalPages;
  final int? currentPage;
  final int? total;
  final int? perPage;
  final String? message;

  FlightResultsResponse({
    required this.success,
    this.offers = const [],
    this.totalPages,
    this.currentPage,
    this.total,
    this.perPage,
    this.message,
  });

  factory FlightResultsResponse.fromJson(Map<String, dynamic> json) {
    List<FlightOffer> allOffers = [];
    int? currentPage;
    int? totalPages;
    int? total;
    int? perPage;

    // Handle different response structures
    if (json['data'] != null) {
      final data = json['data'];
      if (data is Map<String, dynamic>) {
        // Parse offers from data.offers (pagination API response)
        if (data['offers'] != null && data['offers'] is List) {
          allOffers = (data['offers'] as List)
              .map((e) => FlightOffer.fromJson(e as Map<String, dynamic>))
              .toList();
        }

        // Parse pagination info from data
        // currentPage can be string or int
        if (data['currentPage'] != null) {
          currentPage = data['currentPage'] is String
              ? int.tryParse(data['currentPage'])
              : data['currentPage'] as int?;
        }

        // Parse total and perPage to calculate totalPages
        if (data['total'] != null) {
          total = data['total'] is String
              ? int.tryParse(data['total'])
              : data['total'] as int?;
        }

        if (data['perPage'] != null) {
          perPage = data['perPage'] is String
              ? int.tryParse(data['perPage'])
              : data['perPage'] as int?;
        }

        // Calculate totalPages from total and perPage
        if (total != null && perPage != null && perPage > 0) {
          totalPages = (total / perPage).ceil();
        }
      } else if (data is List) {
        // Handle array response structure
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

    // Also check root level pagination (fallback)
    currentPage ??= json['currentPage'] is String
        ? int.tryParse(json['currentPage'])
        : json['currentPage'] as int?;
    totalPages ??= json['totalPages'] as int?;

    return FlightResultsResponse(
      success: json['success'] ?? true,
      offers: allOffers,
      totalPages: totalPages,
      currentPage: currentPage,
      total: total,
      perPage: perPage,
      message: json['message'],
    );
  }
}
