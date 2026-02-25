/// Model for the Bookings API: GET /bookings/v2/flights
class BookingFlightResponse {
  final bool success;
  final List<BookingFlight> flights;

  BookingFlightResponse({required this.success, required this.flights});

  factory BookingFlightResponse.fromJson(Map<String, dynamic> json) {
    return BookingFlightResponse(
      success: json['success'] ?? false,
      flights: (json['flights'] as List<dynamic>?)
              ?.map((e) => BookingFlight.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class BookingFlight {
  final int bookingId;
  final String pnr;
  final DateTime? bookingDate;
  final int statusId;
  final String status;
  final double purchasePrice;
  final double salePrice;
  final double agencyFee;
  final String currency;
  final String itinerary;
  final String tripType;
  final DateTime? depDate;
  final DateTime? returnDate;
  final String airline;
  final String airlineCode;
  final int adults;
  final int children;
  final int infants;
  final int partnerId;
  final int customerId;
  final String user;
  final String customer;
  final int isTicketAllowed;
  final int isHold;
  final DateTime? lastTicketDate;
  final String issueDate;
  final List<BookingSegment> segments;

  BookingFlight({
    required this.bookingId,
    required this.pnr,
    this.bookingDate,
    required this.statusId,
    required this.status,
    required this.purchasePrice,
    required this.salePrice,
    required this.agencyFee,
    required this.currency,
    required this.itinerary,
    required this.tripType,
    this.depDate,
    this.returnDate,
    required this.airline,
    required this.airlineCode,
    required this.adults,
    required this.children,
    required this.infants,
    required this.partnerId,
    required this.customerId,
    required this.user,
    required this.customer,
    required this.isTicketAllowed,
    required this.isHold,
    this.lastTicketDate,
    required this.issueDate,
    required this.segments,
  });

  factory BookingFlight.fromJson(Map<String, dynamic> json) {
    return BookingFlight(
      bookingId: json['bookingId'] ?? 0,
      pnr: json['PNR'] ?? '',
      bookingDate: _parseDate(json['bookingDate']),
      statusId: json['statusId'] ?? 0,
      status: json['status'] ?? '',
      purchasePrice: (json['purchasePrice'] ?? 0).toDouble(),
      salePrice: (json['salePrice'] ?? 0).toDouble(),
      agencyFee: (json['agencyFee'] ?? 0).toDouble(),
      currency: json['currency'] ?? '',
      itinerary: json['itinerary'] ?? '',
      tripType: json['tripType'] ?? '',
      depDate: _parseDate(json['depDate']),
      returnDate: _parseDate(json['returnDate']),
      airline: json['airline'] ?? '',
      airlineCode: json['airlineCode'] ?? '',
      adults: json['adults'] ?? 0,
      children: json['children'] ?? 0,
      infants: json['infants'] ?? 0,
      partnerId: json['partnerId'] ?? 0,
      customerId: json['customerId'] ?? 0,
      user: json['user'] ?? '',
      customer: json['customer'] ?? '',
      isTicketAllowed: json['isTicketAllowed'] ?? 0,
      isHold: json['isHold'] ?? 0,
      lastTicketDate: _parseDate(json['lastTicketDate']),
      issueDate: json['issueDate'] ?? '',
      segments: (json['segments'] as List<dynamic>?)
              ?.map((e) => BookingSegment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  /// Airline logo URL from avs.io
  String get airlineLogo => 'https://pics.avs.io/70/70/$airlineCode.png';

  /// First departure airport code
  String get originCode => segments.isNotEmpty ? segments.first.departureAirportCode : '';

  /// Last arrival airport code
  String get destinationCode => segments.isNotEmpty ? segments.last.arrivalAirportCode : '';

  /// First departure city (extracted from airport name)
  String get originCity => segments.isNotEmpty ? _extractCity(segments.first.departureAirport) : '';

  /// Last arrival city (extracted from airport name)
  String get destinationCity => segments.isNotEmpty ? _extractCity(segments.last.arrivalAirport) : '';

  /// Total passengers
  int get totalPassengers => adults + children + infants;

  static DateTime? _parseDate(dynamic value) {
    if (value == null || value == '') return null;
    try {
      return DateTime.parse(value as String);
    } catch (_) {
      return null;
    }
  }

  static String _extractCity(String airportName) {
    // Format: "Airport Name City-Country" → extract city
    final parts = airportName.split(' ');
    for (int i = parts.length - 1; i >= 0; i--) {
      if (parts[i].contains('-')) {
        return parts[i].split('-').first;
      }
    }
    return airportName;
  }
}

class BookingSegment {
  final String departureAirportCode;
  final String departureAirport;
  final String arrivalAirportCode;
  final String arrivalAirport;
  final String depDate;
  final String depTime;
  final String arrDate;
  final String arrTime;
  final String cabinClass;

  BookingSegment({
    required this.departureAirportCode,
    required this.departureAirport,
    required this.arrivalAirportCode,
    required this.arrivalAirport,
    required this.depDate,
    required this.depTime,
    required this.arrDate,
    required this.arrTime,
    required this.cabinClass,
  });

  factory BookingSegment.fromJson(Map<String, dynamic> json) {
    return BookingSegment(
      departureAirportCode: json['departureAirportCode'] ?? '',
      departureAirport: json['departureAirport'] ?? '',
      arrivalAirportCode: json['arrivalAirportCode'] ?? '',
      arrivalAirport: json['arrivalAirport'] ?? '',
      depDate: json['depDate'] ?? '',
      depTime: json['depTime'] ?? '',
      arrDate: json['arrDate'] ?? '',
      arrTime: json['arrTime'] ?? '',
      cabinClass: json['class'] ?? '',
    );
  }

  /// Departure time formatted (HH:mm)
  String get depTimeFormatted => depTime.length >= 5 ? depTime.substring(0, 5) : depTime;

  /// Arrival time formatted (HH:mm)
  String get arrTimeFormatted => arrTime.length >= 5 ? arrTime.substring(0, 5) : arrTime;
}
