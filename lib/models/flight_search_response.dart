import 'flight_offer.dart';

// Flight Search Response - matches actual API response
class FlightSearchResponse {
  final bool success;
  final String? statusMessage;
  final String? searchCode;
  final List<String> warningDetails;
  final FlightSearchData? data;

  FlightSearchResponse({
    required this.success,
    this.statusMessage,
    this.searchCode,
    this.warningDetails = const [],
    this.data,
  });

  // Convenience getter for offers
  List<FlightOffer> get offers => data?.offers ?? [];

  factory FlightSearchResponse.fromJson(Map<String, dynamic> json) {
    return FlightSearchResponse(
      success: json['success'] ?? false,
      statusMessage: json['statusMessage'],
      searchCode: json['searchCode'],
      warningDetails: (json['warningDetails'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      data: json['data'] != null
          ? FlightSearchData.fromJson(json['data'])
          : null,
    );
  }
}

// Flight Search Data
class FlightSearchData {
  final List<FlightOffer> offers;
  final bool? isDomestic;
  final String? currency;
  final FilterDependencies? filterDependencies;
  final int? total;

  FlightSearchData({
    this.offers = const [],
    this.isDomestic,
    this.currency,
    this.filterDependencies,
    this.total,
  });

  factory FlightSearchData.fromJson(Map<String, dynamic> json) {
    return FlightSearchData(
      offers: (json['offers'] as List<dynamic>?)
              ?.map((e) => FlightOffer.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      isDomestic: json['isDomestic'],
      currency: json['currency'],
      filterDependencies: json['filterDependencies'] != null
          ? FilterDependencies.fromJson(json['filterDependencies'])
          : null,
      total: json['total'],
    );
  }
}

// Stop Info for filtering (per bound)
class BoundStopInfo {
  final int? stops;
  final int? count;
  final String? code;

  BoundStopInfo({this.stops, this.count, this.code});

  factory BoundStopInfo.fromJson(Map<String, dynamic> json) {
    return BoundStopInfo(
      stops: json['stops'],
      count: json['count'],
      code: json['code'],
    );
  }

  String get displayName {
    if (stops == 0) return 'Vol direct';
    if (stops == 1) return '1 escale';
    return '$stops escales';
  }
}

// Time Filter Info (per bound)
class BoundTimeFilter {
  final String? from;
  final String? to;
  final String? code;

  BoundTimeFilter({this.from, this.to, this.code});

  factory BoundTimeFilter.fromJson(Map<String, dynamic> json) {
    return BoundTimeFilter(
      from: json['from'],
      to: json['to'],
      code: json['code'],
    );
  }

  String get displayName {
    return '$from - $to';
  }
}

// Filter Dependencies
class FilterDependencies {
  final int? isRefundable;
  final double? minRate;
  final double? maxRate;
  // Stops per bound: List of bounds, each containing list of stop options
  final List<List<BoundStopInfo>> stops;
  // Times per bound: List of bounds, each containing list of time filters
  final List<List<BoundTimeFilter>> times;
  final List<AirportFilter> airportsFilter;
  final List<AirportInfo> airports;
  final List<AirlineInfo> airlines;

  FilterDependencies({
    this.isRefundable,
    this.minRate,
    this.maxRate,
    this.stops = const [],
    this.times = const [],
    this.airportsFilter = const [],
    this.airports = const [],
    this.airlines = const [],
  });

  // Check if direct flights are available for any bound
  bool get hasDirectFlights {
    for (final boundStops in stops) {
      if (boundStops.any((s) => s.stops == 0 && (s.count ?? 0) > 0)) {
        return true;
      }
    }
    return false;
  }

  // Check if direct flights are available for a specific bound
  bool hasDirectFlightsForBound(int boundIndex) {
    if (boundIndex >= stops.length) return false;
    return stops[boundIndex].any((s) => s.stops == 0 && (s.count ?? 0) > 0);
  }

  // Get all stop options flattened
  List<BoundStopInfo> get allStops {
    return stops.expand((boundStops) => boundStops).toList();
  }

  // Get stop options for a specific bound
  List<BoundStopInfo> getStopsForBound(int boundIndex) {
    if (boundIndex >= stops.length) return [];
    return stops[boundIndex];
  }

  // Get time options for a specific bound
  List<BoundTimeFilter> getTimesForBound(int boundIndex) {
    if (boundIndex >= times.length) return [];
    return times[boundIndex];
  }

  factory FilterDependencies.fromJson(Map<String, dynamic> json) {
    // Parse stops - can be array of arrays (multi-destination) or array of objects
    List<List<BoundStopInfo>> parseStops(dynamic stopsJson) {
      if (stopsJson == null) return [];
      final stopsList = stopsJson as List<dynamic>;
      if (stopsList.isEmpty) return [];

      // Check if first element is a list (multi-destination format)
      if (stopsList.first is List) {
        return stopsList.map((boundStops) {
          return (boundStops as List<dynamic>)
              .map((e) => BoundStopInfo.fromJson(e as Map<String, dynamic>))
              .toList();
        }).toList();
      } else {
        // Single bound format - wrap in list
        return [
          stopsList
              .map((e) => BoundStopInfo.fromJson(e as Map<String, dynamic>))
              .toList()
        ];
      }
    }

    // Parse times - can be array of arrays (multi-destination) or array of objects
    List<List<BoundTimeFilter>> parseTimes(dynamic timesJson) {
      if (timesJson == null) return [];
      final timesList = timesJson as List<dynamic>;
      if (timesList.isEmpty) return [];

      // Check if first element is a list (multi-destination format)
      if (timesList.first is List) {
        return timesList.map((boundTimes) {
          return (boundTimes as List<dynamic>)
              .map((e) => BoundTimeFilter.fromJson(e as Map<String, dynamic>))
              .toList();
        }).toList();
      } else {
        // Single bound format - wrap in list
        return [
          timesList
              .map((e) => BoundTimeFilter.fromJson(e as Map<String, dynamic>))
              .toList()
        ];
      }
    }

    return FilterDependencies(
      isRefundable: json['isRefundable'],
      minRate: (json['minRate'] as num?)?.toDouble(),
      maxRate: (json['maxRate'] as num?)?.toDouble(),
      stops: parseStops(json['stops']),
      times: parseTimes(json['times']),
      airportsFilter: (json['airportsFilter'] as List<dynamic>?)
              ?.map((e) => AirportFilter.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      airports: (json['airports'] as List<dynamic>?)
              ?.map((e) => AirportInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      airlines: (json['airlines'] as List<dynamic>?)
              ?.map((e) => AirlineInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

// Airport Filter
class AirportFilter {
  final List<String> departureAirports;
  final List<String> arrivalAirports;

  AirportFilter({
    this.departureAirports = const [],
    this.arrivalAirports = const [],
  });

  factory AirportFilter.fromJson(Map<String, dynamic> json) {
    return AirportFilter(
      departureAirports: (json['departureAirports'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      arrivalAirports: (json['arrivalAirports'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}

// Airport Info
class AirportInfo {
  final String? iataCode;
  final String? city;
  final String? country;
  final String? name;

  AirportInfo({this.iataCode, this.city, this.country, this.name});

  factory AirportInfo.fromJson(Map<String, dynamic> json) {
    return AirportInfo(
      iataCode: json['IataCode'],
      city: json['City'],
      country: json['Country'],
      name: json['Name'],
    );
  }
}

// Airline Info
class AirlineInfo {
  final String? name;
  final String? iataCode;
  final String? country;
  final double? price;

  AirlineInfo({this.name, this.iataCode, this.country, this.price});

  factory AirlineInfo.fromJson(Map<String, dynamic> json) {
    return AirlineInfo(
      name: json['Name'],
      iataCode: json['IataCode'],
      country: json['Country'],
      price: (json['price'] as num?)?.toDouble(),
    );
  }
}
