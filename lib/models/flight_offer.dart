// Flight Offer - matches actual API response
class FlightOffer {
  final String? offerId;
  final FlightOfferDetail? detail;
  final List<FlightJourney> journey;
  final FlightFare? fare;
  final bool? isUpsellOffer;

  FlightOffer({
    this.offerId,
    this.detail,
    this.journey = const [],
    this.fare,
    this.isUpsellOffer,
  });

  // Convenience getters
  double get totalPrice => fare?.totalFare ?? 0;
  String get currency => fare?.currencyCode ?? 'DZD';
  bool get isRefundable => fare?.fareType?.refundable ?? false;
  String get airlineName => journey.isNotEmpty
      ? journey.first.flightSegments.isNotEmpty
          ? journey.first.flightSegments.first.marketingAirlineName ?? 'Airline'
          : 'Airline'
      : 'Airline';
  String get airlineCode => journey.isNotEmpty
      ? journey.first.flightSegments.isNotEmpty
          ? journey.first.flightSegments.first.marketingAirline ?? ''
          : ''
      : '';

  factory FlightOffer.fromJson(Map<String, dynamic> json) {
    return FlightOffer(
      offerId: json['offerId']?.toString(),
      detail: json['detail'] != null
          ? FlightOfferDetail.fromJson(json['detail'])
          : null,
      journey: (json['journey'] as List<dynamic>?)
              ?.map((e) => FlightJourney.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      fare: json['fare'] != null
          ? FlightFare.fromJson(json['fare'])
          : null,
      isUpsellOffer: json['isUpsellOffer'],
    );
  }
}

// Flight Offer Detail
class FlightOfferDetail {
  final bool? hasCodeshare;
  final bool? checkedBaggageIncluded;
  final bool? cabinBaggageIncluded;
  final int? elapsedDurationTime;

  FlightOfferDetail({
    this.hasCodeshare,
    this.checkedBaggageIncluded,
    this.cabinBaggageIncluded,
    this.elapsedDurationTime,
  });

  factory FlightOfferDetail.fromJson(Map<String, dynamic> json) {
    return FlightOfferDetail(
      hasCodeshare: json['hasCodeshare'],
      checkedBaggageIncluded: json['checkedBaggageIncluded'],
      cabinBaggageIncluded: json['cabinBaggageIncluded'],
      elapsedDurationTime: json['elapsedDurationTime'],
    );
  }
}

// Flight Journey
class FlightJourney {
  final FlightInfo? flight;
  final List<FlightSegmentDetail> flightSegments;

  FlightJourney({
    this.flight,
    this.flightSegments = const [],
  });

  factory FlightJourney.fromJson(Map<String, dynamic> json) {
    return FlightJourney(
      flight: json['flight'] != null
          ? FlightInfo.fromJson(json['flight'])
          : null,
      flightSegments: (json['flightSegments'] as List<dynamic>?)
              ?.map((e) => FlightSegmentDetail.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

// Flight Info (within journey)
class FlightInfo {
  final String? flightKey;
  final FlightTimeInfo? flightInfo;
  final SegmentReference? segmentReference;
  final int? stopQuantity;

  FlightInfo({
    this.flightKey,
    this.flightInfo,
    this.segmentReference,
    this.stopQuantity,
  });

  factory FlightInfo.fromJson(Map<String, dynamic> json) {
    return FlightInfo(
      flightKey: json['flightKey'],
      flightInfo: json['flightInfo'] != null
          ? FlightTimeInfo.fromJson(json['flightInfo'])
          : null,
      segmentReference: json['segmentReference'] != null
          ? SegmentReference.fromJson(json['segmentReference'])
          : null,
      stopQuantity: json['stopQuantity'],
    );
  }
}

// Flight Time Info
class FlightTimeInfo {
  final String? duration;
  final String? departureDate;
  final String? arrivalDate;
  final String? departureTime;
  final String? arrivalTime;
  final int? durationTime;
  final int? dayOffset;

  FlightTimeInfo({
    this.duration,
    this.departureDate,
    this.arrivalDate,
    this.departureTime,
    this.arrivalTime,
    this.durationTime,
    this.dayOffset,
  });

  factory FlightTimeInfo.fromJson(Map<String, dynamic> json) {
    return FlightTimeInfo(
      duration: json['duration'],
      departureDate: json['departureDate'],
      arrivalDate: json['arrivalDate'],
      departureTime: json['departureTime'],
      arrivalTime: json['arrivalTime'],
      durationTime: json['durationTime'],
      dayOffset: json['dayOffset'],
    );
  }
}

// Segment Reference
class SegmentReference {
  final String? onPoint;
  final String? offPoint;

  SegmentReference({this.onPoint, this.offPoint});

  factory SegmentReference.fromJson(Map<String, dynamic> json) {
    return SegmentReference(
      onPoint: json['onPoint'],
      offPoint: json['offPoint'],
    );
  }
}

// Flight Segment Detail
class FlightSegmentDetail {
  final String? segmentKey;
  final String? segmentId;
  final String? departureAirportCode;
  final String? departureDateTime;
  final String? departureTerminal;
  final String? arrivalAirportCode;
  final String? arrivalDateTime;
  final String? arrivalTerminal;
  final String? duration;
  final int? flightNumber;
  final String? layoverTime;
  final String? operatingAirline;
  final String? marketingAirline;
  final int? seatsAvailable;
  final String? equipmentType;
  final String? equipmentName;
  final String? cabinClass;
  final String? operatingAirlineName;
  final String? marketingAirlineName;
  final BaggageAllowance? baggageAllowance;
  final AirportDetails? departureAirportDetails;
  final AirportDetails? arrivalAirportDetails;

  FlightSegmentDetail({
    this.segmentKey,
    this.segmentId,
    this.departureAirportCode,
    this.departureDateTime,
    this.departureTerminal,
    this.arrivalAirportCode,
    this.arrivalDateTime,
    this.arrivalTerminal,
    this.duration,
    this.flightNumber,
    this.layoverTime,
    this.operatingAirline,
    this.marketingAirline,
    this.seatsAvailable,
    this.equipmentType,
    this.equipmentName,
    this.cabinClass,
    this.operatingAirlineName,
    this.marketingAirlineName,
    this.baggageAllowance,
    this.departureAirportDetails,
    this.arrivalAirportDetails,
  });

  factory FlightSegmentDetail.fromJson(Map<String, dynamic> json) {
    return FlightSegmentDetail(
      segmentKey: json['segmentKey'],
      segmentId: json['segmentId'],
      departureAirportCode: json['departureAirportCode'],
      departureDateTime: json['departureDateTime'],
      departureTerminal: json['departureTerminal'],
      arrivalAirportCode: json['arrivalAirportCode'],
      arrivalDateTime: json['arrivalDateTime'],
      arrivalTerminal: json['arrivalTerminal'],
      duration: json['duration'],
      flightNumber: json['flightNumber'],
      layoverTime: json['layoverTime'],
      operatingAirline: json['operatingAirline'],
      marketingAirline: json['marketingAirline'],
      seatsAvailable: json['seatsAvailable'],
      equipmentType: json['equipmentType'],
      equipmentName: json['equipmentName'],
      cabinClass: json['cabinClass'],
      operatingAirlineName: json['operatingAirlineName'],
      marketingAirlineName: json['marketingAirlineName'],
      baggageAllowance: json['baggageAllowance'] != null
          ? BaggageAllowance.fromJson(json['baggageAllowance'])
          : null,
      departureAirportDetails: json['departureAirportDetails'] != null
          ? AirportDetails.fromJson(json['departureAirportDetails'])
          : null,
      arrivalAirportDetails: json['arrivalAirportDetails'] != null
          ? AirportDetails.fromJson(json['arrivalAirportDetails'])
          : null,
    );
  }
}

// Baggage Allowance
class BaggageAllowance {
  final List<BaggageInfo> checkedInBaggage;
  final List<BaggageInfo> cabinBaggage;

  BaggageAllowance({
    this.checkedInBaggage = const [],
    this.cabinBaggage = const [],
  });

  factory BaggageAllowance.fromJson(Map<String, dynamic> json) {
    return BaggageAllowance(
      checkedInBaggage: (json['checkedInBaggage'] as List<dynamic>?)
              ?.map((e) => BaggageInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      cabinBaggage: (json['cabinBaggage'] as List<dynamic>?)
              ?.map((e) => BaggageInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

// Baggage Info
class BaggageInfo {
  final String? paxType;
  final int? value;
  final String? unit;

  BaggageInfo({this.paxType, this.value, this.unit});

  factory BaggageInfo.fromJson(Map<String, dynamic> json) {
    return BaggageInfo(
      paxType: json['paxType'],
      value: json['value'],
      unit: json['unit'],
    );
  }
}

// Airport Details
class AirportDetails {
  final String? iataCode;
  final String? city;
  final String? country;
  final String? name;

  AirportDetails({this.iataCode, this.city, this.country, this.name});

  factory AirportDetails.fromJson(Map<String, dynamic> json) {
    return AirportDetails(
      iataCode: json['IataCode'],
      city: json['City'],
      country: json['Country'],
      name: json['Name'],
    );
  }
}

// Passenger Rate Details
class PaxRate {
  final String? currency;
  final double? baseFare;
  final double? totalTax;
  final double? totalFare;
  final double? serviceFees;

  PaxRate({
    this.currency,
    this.baseFare,
    this.totalTax,
    this.totalFare,
    this.serviceFees,
  });

  factory PaxRate.fromJson(Map<String, dynamic> json) {
    return PaxRate(
      currency: json['currency'],
      baseFare: (json['baseFare'] as num?)?.toDouble(),
      totalTax: (json['totalTax'] as num?)?.toDouble(),
      totalFare: (json['totalFare'] as num?)?.toDouble(),
      serviceFees: (json['serviceFees'] as num?)?.toDouble(),
    );
  }
}

// Fare Breakdown by Passenger Type
class FareBreakdown {
  final String? fareBreakdownKey;
  final String? fareType;
  final List<String> passengerKeys;
  final String? paxType;
  final PaxRate? paxRate;
  // Legacy fields for backward compatibility
  final double? baseFare;
  final double? totalTax;
  final double? totalFare;
  final int? quantity;

  FareBreakdown({
    this.fareBreakdownKey,
    this.fareType,
    this.passengerKeys = const [],
    this.paxType,
    this.paxRate,
    this.baseFare,
    this.totalTax,
    this.totalFare,
    this.quantity,
  });

  // Get fare values from paxRate or legacy fields
  double get effectiveBaseFare => paxRate?.baseFare ?? baseFare ?? 0;
  double get effectiveTotalTax => paxRate?.totalTax ?? totalTax ?? 0;
  double get effectiveTotalFare => paxRate?.totalFare ?? totalFare ?? 0;
  String get effectiveCurrency => paxRate?.currency ?? 'DZD';
  int get effectiveQuantity => quantity ?? passengerKeys.length;

  factory FareBreakdown.fromJson(Map<String, dynamic> json) {
    return FareBreakdown(
      fareBreakdownKey: json['fareBreakdownKey'],
      fareType: json['fareType'],
      passengerKeys: (json['passengerKeys'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      paxType: json['paxType'],
      paxRate: json['paxRate'] != null
          ? PaxRate.fromJson(json['paxRate'])
          : null,
      // Legacy fields
      baseFare: (json['baseFare'] as num?)?.toDouble(),
      totalTax: (json['totalTax'] as num?)?.toDouble(),
      totalFare: (json['totalFare'] as num?)?.toDouble(),
      quantity: json['quantity'],
    );
  }

  // Get passenger type display name
  String get passengerTypeDisplay {
    switch (paxType?.toUpperCase()) {
      case 'ADT':
        return 'Adulte';
      case 'CHD':
        return 'Enfant';
      case 'INF':
        return 'Bébé';
      case 'SNR':
        return 'Senior';
      case 'YNG':
        return 'Jeune';
      case 'STD':
        return 'Étudiant';
      default:
        return paxType ?? 'Passager';
    }
  }
}

// Flight Fare
class FlightFare {
  final String? fareKey;
  final String? currencyCode;
  final FareType? fareType;
  final double? baseFare;
  final double? totalTax;
  final double? totalFare;
  final String? platingAirlineCode;
  final AirlineDetails? platingAirlineDetails;
  final double? serviceFees;
  final List<FareBreakdown> fareBreakdown;

  FlightFare({
    this.fareKey,
    this.currencyCode,
    this.fareType,
    this.baseFare,
    this.totalTax,
    this.totalFare,
    this.platingAirlineCode,
    this.platingAirlineDetails,
    this.serviceFees,
    this.fareBreakdown = const [],
  });

  // Get fare breakdown for a specific passenger type
  FareBreakdown? getFareForPassengerType(String paxType) {
    try {
      return fareBreakdown.firstWhere(
        (fb) => fb.paxType?.toUpperCase() == paxType.toUpperCase(),
      );
    } catch (_) {
      return null;
    }
  }

  // Get adult fare
  FareBreakdown? get adultFare => getFareForPassengerType('ADT');

  // Get child fare
  FareBreakdown? get childFare => getFareForPassengerType('CHD');

  // Get infant fare
  FareBreakdown? get infantFare => getFareForPassengerType('INF');

  // Get total passengers count
  int get totalPassengers {
    return fareBreakdown.fold(0, (sum, fb) => sum + (fb.quantity ?? 0));
  }

  factory FlightFare.fromJson(Map<String, dynamic> json) {
    return FlightFare(
      fareKey: json['fareKey'],
      currencyCode: json['currencyCode'],
      fareType: json['fareType'] != null
          ? FareType.fromJson(json['fareType'])
          : null,
      baseFare: (json['baseFare'] as num?)?.toDouble(),
      totalTax: (json['totalTax'] as num?)?.toDouble(),
      totalFare: (json['totalFare'] as num?)?.toDouble(),
      platingAirlineCode: json['platingAirlineCode'],
      platingAirlineDetails: json['platingAirlineDetails'] != null
          ? AirlineDetails.fromJson(json['platingAirlineDetails'])
          : null,
      serviceFees: (json['serviceFees'] as num?)?.toDouble(),
      fareBreakdown: (json['fareBreakdown'] as List<dynamic>?)
              ?.map((e) => FareBreakdown.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

// Fare Type
class FareType {
  final String? fareCode;
  final String? farePreference;
  final bool? refundable;
  final bool? modifiable;

  FareType({this.fareCode, this.farePreference, this.refundable, this.modifiable});

  factory FareType.fromJson(Map<String, dynamic> json) {
    return FareType(
      fareCode: json['fareCode'],
      farePreference: json['farePreference'],
      refundable: json['refundable'],
      modifiable: json['modifiable'],
    );
  }
}

// Airline Details
class AirlineDetails {
  final String? name;
  final String? iataCode;
  final String? country;
  final double? price;

  AirlineDetails({this.name, this.iataCode, this.country, this.price});

  factory AirlineDetails.fromJson(Map<String, dynamic> json) {
    return AirlineDetails(
      name: json['Name'],
      iataCode: json['IataCode'],
      country: json['Country'],
      price: (json['price'] as num?)?.toDouble(),
    );
  }
}
