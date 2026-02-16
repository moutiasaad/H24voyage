import 'package:flight_booking/Model/FakeFlight.dart';
import 'package:flight_booking/models/flight_offer.dart';
import 'package:flight_booking/screen/widgets/constant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../controllers/search_result_controller.dart';

// ─────────────────────────────────────────────────────────────────────────────
// 1. FlightDetailRow
// ─────────────────────────────────────────────────────────────────────────────

class FlightDetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isSmallScreen;

  const FlightDetailRow({
    Key? key,
    required this.label,
    required this.value,
    required this.isSmallScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fontSize = isSmallScreen ? 9.0 : 10.0;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 1 : 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              style: kTextStyle.copyWith(
                color: kSubTitleColor,
                fontSize: fontSize,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              style: kTextStyle.copyWith(
                color: kTitleColor,
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 2. FlightSegmentRow
// ─────────────────────────────────────────────────────────────────────────────

class FlightSegmentRow extends StatelessWidget {
  final String airlineLogo;
  final String airlineName;
  final String departureDate;
  final String arrivalDate;
  final String departureTime;
  final String arrivalTime;
  final String fromCode;
  final String toCode;
  final String duration;
  final bool isDirect;
  final bool isExpanded;
  final VoidCallback onToggleExpand;
  final int? stops;
  final List<dynamic>? segments;
  final BaggageAllowance? baggageAllowance;
  final bool isSmallScreen;
  final VoidCallback? onBaggageTap;

  const FlightSegmentRow({
    Key? key,
    required this.airlineLogo,
    required this.airlineName,
    required this.departureDate,
    required this.arrivalDate,
    required this.departureTime,
    required this.arrivalTime,
    required this.fromCode,
    required this.toCode,
    required this.duration,
    required this.isDirect,
    required this.isExpanded,
    required this.onToggleExpand,
    this.stops,
    this.segments,
    this.baggageAllowance,
    required this.isSmallScreen,
    this.onBaggageTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Colors from design
    const Color textGray = Color.fromRGBO(130, 130, 130, 1);
    const Color textBlack = Color.fromRGBO(51, 51, 51, 1);
    const Color textOrange = Color.fromRGBO(255, 87, 34, 1);
    const Color directGreen = Color.fromRGBO(76, 175, 80, 1);
    const Color detailsBlue = Color.fromRGBO(0, 118, 209, 1);

    // Responsive values
    final dateFontSize = isSmallScreen ? 9.0 : 11.0;
    final timeFontSize = isSmallScreen ? 12.0 : 14.0;
    final badgeFontSize = isSmallScreen ? 8.0 : 10.0;
    final badgePaddingH = isSmallScreen ? 6.0 : 10.0;
    final badgePaddingV = isSmallScreen ? 3.0 : 5.0;
    final airlineLogoSize = isSmallScreen ? 16.0 : 20.0;
    final baggageIconSize = isSmallScreen ? 12.0 : 16.0;
    final baggageFontSize = isSmallScreen ? 8.0 : 10.0;

    // Get baggage info from baggageAllowance or segments
    BaggageAllowance? baggage = baggageAllowance;
    String cabinWeight = '7Kg';
    String checkedWeight = '24Kg';

    if (baggage == null && segments != null && segments!.isNotEmpty) {
      // Try to get baggage from first segment
      final firstSeg = segments!.first;
      if (firstSeg is FlightSegmentDetail) {
        baggage = firstSeg.baggageAllowance;
      }
    }

    if (baggage != null) {
      if (baggage.cabinBaggage.isNotEmpty) {
        final cabin = baggage.cabinBaggage.first;
        cabinWeight = '${cabin.value ?? 7}${cabin.unit ?? 'Kg'}';
      }
      if (baggage.checkedInBaggage.isNotEmpty) {
        final checked = baggage.checkedInBaggage.first;
        final unit = checked.unit ?? 'Kg';
        if (unit.toUpperCase() == 'PC' || unit.toUpperCase() == 'PIECE' || unit.toUpperCase() == 'PIECES') {
          checkedWeight = '${checked.value ?? 1}PC';
        } else {
          checkedWeight = '${checked.value ?? 24}$unit';
        }
      }
    }
    const Color lineGray = Color.fromRGBO(200, 200, 200, 1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Airline info row
        Row(
          children: [
            ClipOval(
              child: Image.network(
                airlineLogo,
                height: airlineLogoSize,
                width: airlineLogoSize,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback to airline code initials if image fails to load
                  final code = airlineName.split(' ').length > 1
                      ? airlineName.split(' ')[1]
                      : airlineName.substring(0, 2);
                  return Container(
                    height: airlineLogoSize,
                    width: airlineLogoSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: kPrimaryColor.withOpacity(0.1),
                    ),
                    child: Center(
                      child: Text(
                        code.substring(0, code.length > 2 ? 2 : code.length),
                        style: GoogleFonts.poppins(
                          color: kPrimaryColor,
                          fontSize: isSmallScreen ? 6 : 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: airlineLogoSize,
                    width: airlineLogoSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: kPrimaryColor.withOpacity(0.1),
                    ),
                  );
                },
              ),
            ),
            SizedBox(width: isSmallScreen ? 4 : 8),
            Expanded(
              child: Text(
                airlineName,
                style: GoogleFonts.poppins(
                  color: textBlack,
                  fontWeight: FontWeight.w500,
                  fontSize: isSmallScreen ? 10 : 12,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),

        SizedBox(height: isSmallScreen ? 4 : 6),

        // Flight times row with connecting lines
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Departure column
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  departureDate,
                  style: GoogleFonts.poppins(
                    color: textGray,
                    fontSize: dateFontSize,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
                Text(
                  departureTime,
                  style: GoogleFonts.poppins(
                    color: textBlack,
                    fontWeight: FontWeight.w500,
                    fontSize: timeFontSize,
                    height: 1.4,
                  ),
                ),
                Text(
                  fromCode,
                  style: GoogleFonts.poppins(
                    color: textGray,
                    fontSize: dateFontSize,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ],
            ),

            // Left connecting line
            Expanded(
              child: Container(
                height: 1,
                color: lineGray,
                margin: EdgeInsets.only(left: isSmallScreen ? 3 : 6, right: 0),
              ),
            ),

            // Duration and Direct badge - centered
            Container(
              padding: EdgeInsets.symmetric(horizontal: badgePaddingH, vertical: badgePaddingV),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(241, 241, 241, 1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: isSmallScreen
                  // Compact badge for small screens
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          duration,
                          style: GoogleFonts.poppins(
                            color: textGray,
                            fontSize: badgeFontSize,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          isDirect ? 'Direct' : '${stops ?? 1} esc.',
                          style: GoogleFonts.poppins(
                            color: isDirect ? directGreen : textOrange,
                            fontSize: badgeFontSize,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )
                  : RichText(
                      text: TextSpan(
                        style: GoogleFonts.poppins(
                          color: textGray,
                          fontSize: badgeFontSize,
                          fontWeight: FontWeight.w400,
                        ),
                        children: [
                          TextSpan(text: '$duration . '),
                          TextSpan(
                            text: isDirect ? 'Direct' : '${stops ?? 1} escale',
                            style: GoogleFonts.poppins(
                              color: isDirect ? directGreen : textOrange,
                              fontSize: badgeFontSize,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),

            // Right connecting line
            Expanded(
              child: Container(
                height: 1,
                color: lineGray,
                margin: EdgeInsets.only(left: 0, right: isSmallScreen ? 3 : 6),
              ),
            ),

            // Arrival column
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  arrivalDate,
                  style: GoogleFonts.poppins(
                    color: textGray,
                    fontSize: dateFontSize,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
                Text(
                  arrivalTime,
                  style: GoogleFonts.poppins(
                    color: textBlack,
                    fontWeight: FontWeight.w500,
                    fontSize: timeFontSize,
                    height: 1.4,
                  ),
                ),
                Text(
                  toCode,
                  style: GoogleFonts.poppins(
                    color: textGray,
                    fontSize: dateFontSize,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ],
        ),

        SizedBox(height: isSmallScreen ? 4 : 6),

        // Baggage info and Details row
        Row(
          children: [
            // Baggage icons - clickable to show details
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onBaggageTap?.call(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/cabin_bag.png',
                        width: baggageIconSize,
                        height: baggageIconSize,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.work_outline, color: textGray, size: baggageIconSize - 2);
                        },
                      ),
                      SizedBox(width: isSmallScreen ? 2 : 3),
                      Text(
                        cabinWeight,
                        style: GoogleFonts.poppins(
                          color: textGray,
                          fontSize: baggageFontSize,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(width: isSmallScreen ? 4 : 8),
                      Image.asset(
                        'assets/luggage.png',
                        width: baggageIconSize,
                        height: baggageIconSize,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.luggage_outlined, color: textGray, size: baggageIconSize - 2);
                        },
                      ),
                      SizedBox(width: isSmallScreen ? 2 : 3),
                      Flexible(
                        child: Text(
                          checkedWeight,
                          style: GoogleFonts.poppins(
                            color: textGray,
                            fontSize: baggageFontSize,
                            fontWeight: FontWeight.w400,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(Icons.keyboard_arrow_down, color: textGray, size: isSmallScreen ? 12 : 14),
                    ],
                  ),
                ),
              ),
            ),

            // Details dropdown
            GestureDetector(
              onTap: onToggleExpand,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isSmallScreen ? 'Détails' : 'Détails vol',
                    style: GoogleFonts.poppins(
                      color: detailsBlue,
                      fontSize: baggageFontSize,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: detailsBlue,
                    size: isSmallScreen ? 12 : 14,
                  ),
                ],
              ),
            ),
          ],
        ),

        // Expanded details
        if (isExpanded) ...[
          SizedBox(height: isSmallScreen ? 6 : 8),
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
            decoration: BoxDecoration(
              color: kWebsiteGreyBg,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Informations du vol',
                  style: GoogleFonts.poppins(
                    color: textBlack,
                    fontWeight: FontWeight.w600,
                    fontSize: isSmallScreen ? 10 : 11,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 4 : 6),
                FlightDetailRow(label: 'Compagnie', value: airlineName.split(' ').first, isSmallScreen: isSmallScreen),
                FlightDetailRow(label: 'Numéro de vol', value: airlineName.split(' ').last, isSmallScreen: isSmallScreen),
                FlightDetailRow(label: 'Classe', value: 'Économique', isSmallScreen: isSmallScreen),
                FlightDetailRow(label: 'Bagage cabine', value: '7 Kg inclus', isSmallScreen: isSmallScreen),
                FlightDetailRow(label: 'Bagage soute', value: '24 Kg inclus', isSmallScreen: isSmallScreen),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 3. FakeFlightCard
// ─────────────────────────────────────────────────────────────────────────────

class FakeFlightCard extends StatelessWidget {
  final FakeFlight flight;
  final int index;
  final String fromCode;
  final String toCode;
  final SearchResultController ctrl;
  final bool isSmallScreen;
  final DateTimeRange? dateRange;
  final VoidCallback onToggleOutbound;
  final VoidCallback onToggleReturn;
  final VoidCallback onReserve;

  const FakeFlightCard({
    Key? key,
    required this.flight,
    required this.index,
    required this.fromCode,
    required this.toCode,
    required this.ctrl,
    required this.isSmallScreen,
    this.dateRange,
    required this.onToggleOutbound,
    required this.onToggleReturn,
    required this.onReserve,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final flightNumber = 'TK ${123456 + index}';
    final outboundDate = SearchResultController.formatFlightDate(dateRange?.start);
    final returnDate = SearchResultController.formatFlightDate(dateRange?.end);
    final isOutboundExpanded = ctrl.expandedOutbound.contains(index);
    final isReturnExpanded = ctrl.expandedReturn.contains(index);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBorderColorTextField),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recommandé badge
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(221, 225, 255, 1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'Recommandé',
                style: kTextStyle.copyWith(
                  color: const Color.fromRGBO(147, 133, 245, 1),
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                // Outbound Flight
                FlightSegmentRow(
                  airlineLogo: 'assets/turkish_airlines.png',
                  airlineName: '${flight.airline} $flightNumber',
                  departureDate: outboundDate,
                  arrivalDate: outboundDate,
                  departureTime: flight.departureTime,
                  arrivalTime: flight.arrivalTime,
                  fromCode: fromCode,
                  toCode: toCode,
                  duration: flight.duration,
                  isDirect: flight.stops == 0,
                  isExpanded: isOutboundExpanded,
                  onToggleExpand: onToggleOutbound,
                  isSmallScreen: isSmallScreen,
                  onBaggageTap: null,
                ),

                const SizedBox(height: 8),
                const Divider(height: 1, color: kBorderColorTextField),
                const SizedBox(height: 8),

                // Return Flight
                FlightSegmentRow(
                  airlineLogo: 'assets/turkish_airlines.png',
                  airlineName: '${flight.airline} $flightNumber',
                  departureDate: returnDate,
                  arrivalDate: returnDate,
                  departureTime: flight.departureTime,
                  arrivalTime: flight.arrivalTime,
                  fromCode: toCode,
                  toCode: fromCode,
                  duration: flight.duration,
                  isDirect: flight.stops == 0,
                  isExpanded: isReturnExpanded,
                  onToggleExpand: onToggleReturn,
                  isSmallScreen: isSmallScreen,
                  onBaggageTap: null,
                ),

                const SizedBox(height: 12),

                // Price and Reserve button
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Price with dropdown



                    const SizedBox(width: 12),

                    // Reserve button
                    GestureDetector(
                      onTap: onReserve,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Réservez',
                          style: kTextStyle.copyWith(
                            color: kWhite,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 4. ApiFlightCard
// ─────────────────────────────────────────────────────────────────────────────

class ApiFlightCard extends StatelessWidget {
  final FlightOffer offer;
  final int index;
  final String fromCode;
  final String toCode;
  final SearchResultController ctrl;
  final bool isSmallScreen;
  final bool isMediumScreen;
  final bool isOneWay;
  final bool isMultiDestination;
  final VoidCallback onReserve;
  final void Function(int journeyIndex) onFlightDetailsTap;
  final void Function(BuildContext, FlightOffer) onPriceDetailsTap;
  final void Function(BuildContext, BaggageAllowance?) onBaggageDetailsTap;

  const ApiFlightCard({
    Key? key,
    required this.offer,
    required this.index,
    required this.fromCode,
    required this.toCode,
    required this.ctrl,
    required this.isSmallScreen,
    required this.isMediumScreen,
    required this.isOneWay,
    required this.isMultiDestination,
    required this.onReserve,
    required this.onFlightDetailsTap,
    required this.onPriceDetailsTap,
    required this.onBaggageDetailsTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isOutboundExpanded = ctrl.expandedOutbound.contains(index);
    final isReturnExpanded = ctrl.expandedReturn.contains(index);

    // Use convenience getters from FlightOffer
    final price = offer.totalPrice;
    final currency = offer.currency;
    final isRefundable = offer.isRefundable;
    final airlineName = offer.airlineName;
    final airlineCode = offer.airlineCode;

    // Get journey data safely
    final journeyList = offer.journey;
    final hasJourney = journeyList.isNotEmpty;
    final isMultiDest = isMultiDestination && journeyList.length > 2;

    // Baggage info
    final hasBaggage = offer.detail?.checkedBaggageIncluded ?? false;

    // For multi-destination, delegate to MultiDestinationCard
    if (isMultiDest) {
      return MultiDestinationCard(
        offer: offer,
        index: index,
        hasBaggage: hasBaggage,
        isRefundable: isRefundable,
        price: price,
        currency: currency,
        ctrl: ctrl,
        isSmallScreen: isSmallScreen,
        onReserve: onReserve,
        onPriceDetailsTap: onPriceDetailsTap,
        onBaggageDetailsTap: onBaggageDetailsTap,
      );
    }

    // Original logic for one-way and round-trip
    // Outbound flight details
    String outboundAirline = airlineName;
    String outboundAirlineCode = airlineCode;
    String outboundFlightNumber = '';
    String outboundDepartureTime = '--:--';
    String outboundArrivalTime = '--:--';
    String outboundDuration = '--';
    int outboundStops = 0;
    String outboundFromCode = fromCode;
    String outboundToCode = toCode;
    List<FlightSegmentDetail> outboundSegments = [];

    if (hasJourney) {
      final outboundJourney = journeyList.first;
      final outboundFlight = outboundJourney.flight;
      outboundSegments = outboundJourney.flightSegments;

      if (outboundSegments.isNotEmpty) {
        final firstSegment = outboundSegments.first;
        final lastSegment = outboundSegments.last;

        outboundAirline = firstSegment.marketingAirlineName ?? airlineName;
        outboundAirlineCode = firstSegment.marketingAirline ?? airlineCode;
        outboundFlightNumber = firstSegment.flightNumber?.toString() ?? '';
        outboundDepartureTime = firstSegment.departureDateTime ?? '--:--';
        outboundArrivalTime = lastSegment.arrivalDateTime ?? '--:--';
        outboundFromCode = firstSegment.departureAirportCode ?? fromCode;
        outboundToCode = lastSegment.arrivalAirportCode ?? toCode;
      }

      outboundDuration = outboundFlight?.flightInfo?.duration ?? '--';
      outboundStops = outboundFlight?.stopQuantity ?? 0;
    }

    // Check for return journey (for round-trip)
    final hasReturnJourney = journeyList.length > 1 && !isOneWay;

    String returnAirline = outboundAirline;
    String returnAirlineCode = outboundAirlineCode;
    String returnFlightNumber = '';
    String returnDepartureTime = '--:--';
    String returnArrivalTime = '--:--';
    String returnDuration = '--';
    int returnStops = 0;
    String returnFromCode = toCode;
    String returnToCode = fromCode;
    List<FlightSegmentDetail> returnSegments = [];

    if (hasReturnJourney) {
      final returnJourney = journeyList[1];
      final returnFlight = returnJourney.flight;
      returnSegments = returnJourney.flightSegments;

      if (returnSegments.isNotEmpty) {
        final returnFirstSegment = returnSegments.first;
        final returnLastSegment = returnSegments.last;

        returnAirline = returnFirstSegment.marketingAirlineName ?? outboundAirline;
        returnAirlineCode = returnFirstSegment.marketingAirline ?? outboundAirlineCode;
        returnFlightNumber = returnFirstSegment.flightNumber?.toString() ?? '';
        returnDepartureTime = returnFirstSegment.departureDateTime ?? '--:--';
        returnArrivalTime = returnLastSegment.arrivalDateTime ?? '--:--';
        returnFromCode = returnFirstSegment.departureAirportCode ?? toCode;
        returnToCode = returnLastSegment.arrivalAirportCode ?? fromCode;
      }

      returnDuration = returnFlight?.flightInfo?.duration ?? '--';
      returnStops = returnFlight?.stopQuantity ?? 0;
    }

    // Responsive values for card
    final cardPadding = isSmallScreen ? 8.0 : 12.0;
    final badgeFontSize = isSmallScreen ? 8.0 : 10.0;
    final badgeIconSize = isSmallScreen ? 12.0 : 14.0;
    final badgePaddingH = isSmallScreen ? 6.0 : 8.0;
    final badgePaddingV = isSmallScreen ? 3.0 : 4.0;

    return Container(
      margin: EdgeInsets.only(bottom: isSmallScreen ? 8 : 10),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBorderColorTextField),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recommandé badge
          if (index == 0)
            Padding(
              padding: EdgeInsets.only(left: cardPadding, top: isSmallScreen ? 8 : 10),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: badgePaddingH, vertical: badgePaddingV),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(221, 225, 255, 1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Recommandé',
                  style: kTextStyle.copyWith(
                    color: const Color.fromRGBO(147, 133, 245, 1),
                    fontSize: badgeFontSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

          Padding(
            padding: EdgeInsets.all(cardPadding),
            child: Column(
              children: [
                // Baggage and refund badges
                Wrap(
                  spacing: isSmallScreen ? 4 : 8,
                  runSpacing: 4,
                  children: [
                    if (hasBaggage == true)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: badgePaddingH, vertical: badgePaddingV),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.luggage, size: badgeIconSize, color: Colors.green[700]),
                            SizedBox(width: isSmallScreen ? 2 : 4),
                            Text(
                              isSmallScreen ? 'Bagages' : 'Bagages inclus',
                              style: kTextStyle.copyWith(
                                color: Colors.green[700],
                                fontSize: badgeFontSize,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (isRefundable == true)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: badgePaddingH, vertical: badgePaddingV),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle_outline, size: badgeIconSize, color: Colors.blue[700]),
                            SizedBox(width: isSmallScreen ? 2 : 4),
                            Text(
                              'Remboursable',
                              style: kTextStyle.copyWith(
                                color: Colors.blue[700],
                                fontSize: badgeFontSize,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                if (hasBaggage == true || isRefundable == true) SizedBox(height: isSmallScreen ? 8 : 10),

                // Outbound Flight Segment
                FlightSegmentRow(
                  airlineLogo: SearchResultController.getAirlineLogoUrl(outboundAirlineCode),
                  airlineName: '$outboundAirline ${outboundAirlineCode}$outboundFlightNumber',
                  departureDate: ctrl.formatDateTimeString(outboundDepartureTime),
                  arrivalDate: ctrl.formatDateTimeString(outboundArrivalTime),
                  departureTime: SearchResultController.formatTimeFromDateTime(outboundDepartureTime),
                  arrivalTime: SearchResultController.formatTimeFromDateTime(outboundArrivalTime),
                  fromCode: outboundFromCode,
                  toCode: outboundToCode,
                  duration: outboundDuration,
                  isDirect: outboundStops == 0,
                  isExpanded: isOutboundExpanded,
                  onToggleExpand: () => onFlightDetailsTap(0),
                  stops: outboundStops,
                  segments: outboundSegments,
                  isSmallScreen: isSmallScreen,
                  onBaggageTap: () {
                    final baggage = outboundSegments.isNotEmpty
                        ? outboundSegments.first.baggageAllowance
                        : null;
                    onBaggageDetailsTap(context, baggage);
                  },
                ),

                // Return Flight Segment (for round-trip)
                if (hasReturnJourney) ...[
                  const SizedBox(height: 8),
                  const Divider(height: 1, color: kBorderColorTextField),
                  const SizedBox(height: 8),
                  FlightSegmentRow(
                    airlineLogo: SearchResultController.getAirlineLogoUrl(returnAirlineCode),
                    airlineName: '$returnAirline ${returnAirlineCode}$returnFlightNumber',
                    departureDate: ctrl.formatDateTimeString(returnDepartureTime),
                    arrivalDate: ctrl.formatDateTimeString(returnArrivalTime),
                    departureTime: SearchResultController.formatTimeFromDateTime(returnDepartureTime),
                    arrivalTime: SearchResultController.formatTimeFromDateTime(returnArrivalTime),
                    fromCode: returnFromCode,
                    toCode: returnToCode,
                    duration: returnDuration,
                    isDirect: returnStops == 0,
                    isExpanded: isReturnExpanded,
                    onToggleExpand: () => onFlightDetailsTap(1),
                    stops: returnStops,
                    segments: returnSegments,
                    isSmallScreen: isSmallScreen,
                    onBaggageTap: () {
                      final baggage = returnSegments.isNotEmpty
                          ? returnSegments.first.baggageAllowance
                          : null;
                      onBaggageDetailsTap(context, baggage);
                    },
                  ),
                ],

                SizedBox(height: isSmallScreen ? 8 : 12),

                // Price and Reserve button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Stops info
                    if (outboundStops > 0)
                      Flexible(
                        child: Text(
                          '$outboundStops escale${outboundStops > 1 ? 's' : ''}',
                          style: kTextStyle.copyWith(
                            color: kPrimaryColor,
                            fontSize: isSmallScreen ? 10 : 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    else
                      Flexible(
                        child: Text(
                          'Vol direct',
                          style: kTextStyle.copyWith(
                            color: Colors.green[700],
                            fontSize: isSmallScreen ? 10 : 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Price - clickable to show details
                        GestureDetector(
                          onTap: () => onPriceDetailsTap(context, offer),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${price.toStringAsFixed(0)} $currency',
                                    style: GoogleFonts.poppins(
                                      color: kTitleColor,
                                      fontWeight: FontWeight.w800,
                                      fontSize: isSmallScreen ? 13 : 16,
                                      height: 24 / 16,
                                    ),
                                  ),
                                  Text(
                                    isSmallScreen ? '/pers.' : 'par personne',
                                    style: kTextStyle.copyWith(
                                      color: kSubTitleColor,
                                      fontSize: isSmallScreen ? 8 : 10,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 2),
                              Icon(Icons.keyboard_arrow_down, color: kTitleColor, size: isSmallScreen ? 14 : 18),
                            ],
                          ),
                        ),

                        SizedBox(width: isSmallScreen ? 6 : 12),

                        // Reserve button
                        GestureDetector(
                          onTap: onReserve,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isSmallScreen ? 12 : 20,
                              vertical: isSmallScreen ? 6 : 8,
                            ),
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              isSmallScreen ? 'Réserver' : 'Réservez',
                              style: kTextStyle.copyWith(
                                color: kWhite,
                                fontWeight: FontWeight.w600,
                                fontSize: isSmallScreen ? 11 : 13,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 5. MultiDestinationCard
// ─────────────────────────────────────────────────────────────────────────────

class MultiDestinationCard extends StatelessWidget {
  final FlightOffer offer;
  final int index;
  final bool hasBaggage;
  final bool isRefundable;
  final double price;
  final String currency;
  final SearchResultController ctrl;
  final bool isSmallScreen;
  final VoidCallback onReserve;
  final void Function(BuildContext, FlightOffer) onPriceDetailsTap;
  final void Function(BuildContext, BaggageAllowance?) onBaggageDetailsTap;

  const MultiDestinationCard({
    Key? key,
    required this.offer,
    required this.index,
    required this.hasBaggage,
    required this.isRefundable,
    required this.price,
    required this.currency,
    required this.ctrl,
    required this.isSmallScreen,
    required this.onReserve,
    required this.onPriceDetailsTap,
    required this.onBaggageDetailsTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final journeyList = offer.journey;
    final airlineName = offer.airlineName;
    final airlineCode = offer.airlineCode;

    // Initialize expanded journeys set for this offer if not exists
    if (!ctrl.expandedJourneys.containsKey(index)) {
      ctrl.expandedJourneys[index] = {};
    }

    // Calculate total stops across all journeys
    int totalStops = 0;
    for (final journey in journeyList) {
      totalStops += journey.flight?.stopQuantity ?? 0;
    }

    // Responsive values for multi-destination card
    final cardPadding = isSmallScreen ? 8.0 : 12.0;
    final badgeFontSize = isSmallScreen ? 8.0 : 10.0;
    final badgeIconSize = isSmallScreen ? 12.0 : 14.0;
    final badgePaddingH = isSmallScreen ? 6.0 : 8.0;
    final badgePaddingV = isSmallScreen ? 3.0 : 4.0;

    return Container(
      margin: EdgeInsets.only(bottom: isSmallScreen ? 8 : 10),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBorderColorTextField),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recommandé badge
          if (index == 0)
            Padding(
              padding: EdgeInsets.only(left: cardPadding, top: isSmallScreen ? 8 : 10),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: badgePaddingH, vertical: badgePaddingV),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(221, 225, 255, 1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Recommandé',
                  style: kTextStyle.copyWith(
                    color: const Color.fromRGBO(147, 133, 245, 1),
                    fontSize: badgeFontSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

          // Multi-destination badge
          Padding(
            padding: EdgeInsets.only(left: cardPadding, top: index == 0 ? (isSmallScreen ? 4 : 6) : (isSmallScreen ? 8 : 10)),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: badgePaddingH, vertical: badgePaddingV),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                isSmallScreen
                    ? 'Multi-dest. (${journeyList.length})'
                    : 'Multi-destination (${journeyList.length} trajets)',
                style: kTextStyle.copyWith(
                  color: Colors.purple[700],
                  fontSize: badgeFontSize,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(cardPadding),
            child: Column(
              children: [
                // Baggage and refund badges
                Wrap(
                  spacing: isSmallScreen ? 4 : 8,
                  runSpacing: 4,
                  children: [
                    if (hasBaggage == true)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: badgePaddingH, vertical: badgePaddingV),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.luggage, size: badgeIconSize, color: Colors.green[700]),
                            SizedBox(width: isSmallScreen ? 2 : 4),
                            Text(
                              isSmallScreen ? 'Bagages' : 'Bagages inclus',
                              style: kTextStyle.copyWith(
                                color: Colors.green[700],
                                fontSize: badgeFontSize,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (isRefundable == true)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: badgePaddingH, vertical: badgePaddingV),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle_outline, size: badgeIconSize, color: Colors.blue[700]),
                            SizedBox(width: isSmallScreen ? 2 : 4),
                            Text(
                              'Remboursable',
                              style: kTextStyle.copyWith(
                                color: Colors.blue[700],
                                fontSize: badgeFontSize,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                if (hasBaggage == true || isRefundable == true) SizedBox(height: isSmallScreen ? 8 : 10),

                // Build all journey segments dynamically
                ...journeyList.asMap().entries.map((entry) {
                  final journeyIndex = entry.key;
                  final journey = entry.value;
                  final flight = journey.flight;
                  final segments = journey.flightSegments;

                  // Get journey details
                  String journeyAirline = airlineName;
                  String journeyAirlineCode = airlineCode;
                  String journeyFlightNumber = '';
                  String journeyDepartureTime = '--:--';
                  String journeyArrivalTime = '--:--';
                  String journeyFromCode = '--';
                  String journeyToCode = '--';

                  if (segments.isNotEmpty) {
                    final firstSegment = segments.first;
                    final lastSegment = segments.last;

                    journeyAirline = firstSegment.marketingAirlineName ?? airlineName;
                    journeyAirlineCode = firstSegment.marketingAirline ?? airlineCode;
                    journeyFlightNumber = firstSegment.flightNumber?.toString() ?? '';
                    journeyDepartureTime = firstSegment.departureDateTime ?? '--:--';
                    journeyArrivalTime = lastSegment.arrivalDateTime ?? '--:--';
                    journeyFromCode = firstSegment.departureAirportCode ?? '--';
                    journeyToCode = lastSegment.arrivalAirportCode ?? '--';
                  }

                  final journeyDuration = flight?.flightInfo?.duration ?? '--';
                  final journeyStops = flight?.stopQuantity ?? 0;
                  final isExpanded = ctrl.expandedJourneys[index]?.contains(journeyIndex) ?? false;

                  return Column(
                    children: [
                      if (journeyIndex > 0) ...[
                        const SizedBox(height: 8),
                        const Divider(height: 1, color: kBorderColorTextField),
                        const SizedBox(height: 8),
                      ],
                      // Journey label
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Trajet ${journeyIndex + 1}',
                          style: kTextStyle.copyWith(
                            color: kPrimaryColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      FlightSegmentRow(
                        airlineLogo: SearchResultController.getAirlineLogoUrl(journeyAirlineCode),
                        airlineName: '$journeyAirline ${journeyAirlineCode}$journeyFlightNumber',
                        departureDate: ctrl.formatDateTimeString(journeyDepartureTime),
                        arrivalDate: ctrl.formatDateTimeString(journeyArrivalTime),
                        departureTime: SearchResultController.formatTimeFromDateTime(journeyDepartureTime),
                        arrivalTime: SearchResultController.formatTimeFromDateTime(journeyArrivalTime),
                        fromCode: journeyFromCode,
                        toCode: journeyToCode,
                        duration: journeyDuration,
                        isDirect: journeyStops == 0,
                        isExpanded: isExpanded,
                        onToggleExpand: () {
                          ctrl.toggleExpandedJourney(index, journeyIndex);
                        },
                        stops: journeyStops,
                        segments: segments,
                        isSmallScreen: isSmallScreen,
                        onBaggageTap: () {
                          final baggage = segments.isNotEmpty
                              ? segments.first.baggageAllowance
                              : null;
                          onBaggageDetailsTap(context, baggage);
                        },
                      ),
                    ],
                  );
                }).toList(),

                SizedBox(height: isSmallScreen ? 8 : 12),

                // Price and Reserve button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Stops info
                    if (totalStops > 0)
                      Flexible(
                        child: Text(
                          isSmallScreen
                              ? '$totalStops esc.'
                              : '$totalStops escale${totalStops > 1 ? 's' : ''} au total',
                          style: kTextStyle.copyWith(
                            color: kPrimaryColor,
                            fontSize: isSmallScreen ? 10 : 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    else
                      Flexible(
                        child: Text(
                          'Vols directs',
                          style: kTextStyle.copyWith(
                            color: Colors.green[700],
                            fontSize: isSmallScreen ? 10 : 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Price - clickable to show details
                        GestureDetector(
                          onTap: () => onPriceDetailsTap(context, offer),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${price.toStringAsFixed(0)} $currency',
                                    style: GoogleFonts.poppins(
                                      color: kTitleColor,
                                      fontWeight: FontWeight.w800,
                                      fontSize: isSmallScreen ? 13 : 16,
                                      height: 24 / 16,
                                    ),
                                  ),
                                  Text(
                                    isSmallScreen ? '/pers.' : 'par personne',
                                    style: kTextStyle.copyWith(
                                      color: kSubTitleColor,
                                      fontSize: isSmallScreen ? 8 : 10,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 2),
                              Icon(Icons.keyboard_arrow_down, color: kTitleColor, size: isSmallScreen ? 14 : 18),
                            ],
                          ),
                        ),

                        SizedBox(width: isSmallScreen ? 6 : 12),

                        // Reserve button
                        GestureDetector(
                          onTap: onReserve,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isSmallScreen ? 12 : 20,
                              vertical: isSmallScreen ? 6 : 8,
                            ),
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              isSmallScreen ? 'Réserver' : 'Réservez',
                              style: kTextStyle.copyWith(
                                color: kWhite,
                                fontWeight: FontWeight.w600,
                                fontSize: isSmallScreen ? 11 : 13,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
