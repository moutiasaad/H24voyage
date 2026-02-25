import 'package:flight_booking/generated/l10n.dart' as lang;
import 'package:flight_booking/models/booking_flight.dart';
import 'package:flight_booking/screen/widgets/constant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../widgets/button_global.dart';

class BookingDetailScreen extends StatelessWidget {
  final BookingFlight flight;

  const BookingDetailScreen({Key? key, required this.flight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = lang.S.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(context, t),
          SliverToBoxAdapter(child: _buildBody(context, t)),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════
  //  APP BAR
  // ══════════════════════════════════════════════════
  Widget _buildSliverAppBar(BuildContext context, lang.S t) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: kPrimaryColor,
      leading: SmallTapEffect(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [Color(0xFFFF8C42), kAccentOrange, kPrimaryColor],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.bookingDetailTitle, style: GoogleFonts.poppins(
                    color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 16),
                  // Route summary
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(flight.originCode, style: GoogleFonts.inter(
                            color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700)),
                          Text(flight.originCity, style: GoogleFonts.inter(
                            color: Colors.white.withValues(alpha: 0.8), fontSize: 13)),
                        ],
                      ),
                      Expanded(child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(children: [
                          Icon(Icons.flight, color: Colors.white.withValues(alpha: 0.7), size: 20),
                          const SizedBox(height: 4),
                          Container(height: 1, color: Colors.white.withValues(alpha: 0.3)),
                          const SizedBox(height: 4),
                          Text(
                            _getTripTypeLabel(t),
                            style: GoogleFonts.inter(color: Colors.white.withValues(alpha: 0.8), fontSize: 11),
                          ),
                        ]),
                      )),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(flight.destinationCode, style: GoogleFonts.inter(
                            color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700)),
                          Text(flight.destinationCity, style: GoogleFonts.inter(
                            color: Colors.white.withValues(alpha: 0.8), fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════
  //  BODY
  // ══════════════════════════════════════════════════
  Widget _buildBody(BuildContext context, lang.S t) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Booking info card
          _buildInfoCard(t),
          const SizedBox(height: 16),
          // Passenger info card
          _buildPassengerCard(t),
          const SizedBox(height: 16),
          // Segments card
          _buildSegmentsCard(t),
          const SizedBox(height: 16),
          // Price card
          _buildPriceCard(t),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════
  //  BOOKING INFO CARD
  // ══════════════════════════════════════════════════
  Widget _buildInfoCard(lang.S t) {
    final statusLabel = _getStatusLabel(flight.statusId, t);
    final statusBg = _getStatusBgColor(flight.statusId);
    final statusFg = _getStatusTextColor(flight.statusId);
    final bookingDate = flight.bookingDate != null
        ? DateFormat('dd MMM yyyy, HH:mm', 'fr_FR').format(flight.bookingDate!)
        : '-';

    return _card(
      child: Column(
        children: [
          _infoRow(t.bookingDetailBookingId, '#${flight.bookingId}'),
          _divider,
          _infoRow(t.bookingDetailBookingDate, bookingDate),
          _divider,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(t.bookingDetailStatus, style: _labelStyle),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBg, borderRadius: BorderRadius.circular(8)),
                child: Text(statusLabel, style: GoogleFonts.inter(
                  fontSize: 12, fontWeight: FontWeight.w600, color: statusFg)),
              ),
            ],
          ),
          _divider,
          _infoRow(t.bookingDetailTripType, _getTripTypeLabel(t)),
          if (flight.pnr.isNotEmpty) ...[
            _divider,
            _infoRow(t.bookingPnr, flight.pnr),
          ],
          _divider,
          _infoRow(t.bookingDetailClass,
            flight.segments.isNotEmpty ? flight.segments.first.cabinClass : '-'),
          if (flight.lastTicketDate != null) ...[
            _divider,
            _infoRow(t.bookingDetailLastTicketDate,
              DateFormat('dd MMM yyyy, HH:mm', 'fr_FR').format(flight.lastTicketDate!)),
          ],
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════
  //  PASSENGER CARD
  // ══════════════════════════════════════════════════
  Widget _buildPassengerCard(lang.S t) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: kPrimaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.person_outline_rounded, color: kPrimaryColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.bookingDetailPassenger, style: _sectionTitleStyle),
                  Text(flight.customer, style: GoogleFonts.inter(
                    fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF111111))),
                ],
              )),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _passengerChip('${flight.adults} ${t.bookingDetailAdults}', Icons.person),
              if (flight.children > 0) ...[
                const SizedBox(width: 8),
                _passengerChip('${flight.children} ${t.bookingDetailChildren}', Icons.child_care),
              ],
              if (flight.infants > 0) ...[
                const SizedBox(width: 8),
                _passengerChip('${flight.infants} ${t.bookingDetailInfants}', Icons.baby_changing_station),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _passengerChip(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3), borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF666666)),
          const SizedBox(width: 6),
          Text(text, style: GoogleFonts.inter(
            fontSize: 12, fontWeight: FontWeight.w500, color: const Color(0xFF666666))),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════
  //  SEGMENTS CARD
  // ══════════════════════════════════════════════════
  Widget _buildSegmentsCard(lang.S t) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: kPrimaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.route_rounded, color: kPrimaryColor, size: 20),
              ),
              const SizedBox(width: 12),
              Text(t.bookingDetailSegments, style: _sectionTitleStyle),
            ],
          ),
          const SizedBox(height: 16),
          ...flight.segments.asMap().entries.map((entry) {
            final idx = entry.key;
            final seg = entry.value;
            return Column(
              children: [
                if (idx > 0) Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(children: [
                    Expanded(child: Container(height: 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.transparent, Colors.grey.shade300, Colors.transparent],
                        ),
                      ),
                    )),
                  ]),
                ),
                _buildSegmentItem(seg, idx + 1, t),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSegmentItem(BookingSegment seg, int number, lang.S t) {
    final depDate = seg.depDate.isNotEmpty
        ? DateFormat('EEE d MMM yyyy', 'fr_FR').format(DateTime.parse(seg.depDate))
        : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Segment header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: kPrimaryColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text('${t.bookingDetailSegment} $number — $depDate',
            style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: kPrimaryColor)),
        ),
        const SizedBox(height: 12),
        // Airline
        Row(
          children: [
            ClipOval(child: Image.network(flight.airlineLogo, width: 28, height: 28, fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Container(
                width: 28, height: 28,
                decoration: BoxDecoration(shape: BoxShape.circle, color: kPrimaryColor.withValues(alpha: 0.1)),
                child: Center(child: Text(flight.airline.isNotEmpty ? flight.airline[0] : 'A',
                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: kPrimaryColor))),
              ),
            )),
            const SizedBox(width: 8),
            Text(flight.airline, style: GoogleFonts.inter(
              fontSize: 12, fontWeight: FontWeight.w500, color: const Color(0xFF666666))),
          ],
        ),
        const SizedBox(height: 12),
        // Route timeline
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline dots
            Column(
              children: [
                Container(width: 10, height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: kPrimaryColor, width: 2),
                  ),
                ),
                Container(width: 2, height: 50, color: kPrimaryColor.withValues(alpha: 0.3)),
                Container(width: 10, height: 10,
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: kPrimaryColor),
                ),
              ],
            ),
            const SizedBox(width: 14),
            // Departure + Arrival
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Departure
                Text(seg.depTimeFormatted, style: GoogleFonts.inter(
                  fontSize: 16, fontWeight: FontWeight.w700, color: const Color(0xFF111111))),
                Text(seg.departureAirportCode, style: GoogleFonts.inter(
                  fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF444444))),
                Text(_extractCity(seg.departureAirport), style: GoogleFonts.inter(
                  fontSize: 11, color: const Color(0xFF999999))),
                const SizedBox(height: 20),
                // Arrival
                Text(seg.arrTimeFormatted, style: GoogleFonts.inter(
                  fontSize: 16, fontWeight: FontWeight.w700, color: const Color(0xFF111111))),
                Text(seg.arrivalAirportCode, style: GoogleFonts.inter(
                  fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF444444))),
                Text(_extractCity(seg.arrivalAirport), style: GoogleFonts.inter(
                  fontSize: 11, color: const Color(0xFF999999))),
              ],
            )),
          ],
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════
  //  PRICE CARD
  // ══════════════════════════════════════════════════
  Widget _buildPriceCard(lang.S t) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [Color(0xFFFF8C42), kAccentOrange, kPrimaryColor],
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: kPrimaryColor.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t.bookingDetailTotalPrice, style: GoogleFonts.inter(
                color: Colors.white.withValues(alpha: 0.8), fontSize: 12, fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Text('${_formatPrice(flight.salePrice)} ${flight.currency}',
                style: GoogleFonts.inter(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
            ],
          ),
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.receipt_long_rounded, color: Colors.white, size: 22),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════
  //  SHARED HELPERS
  // ══════════════════════════════════════════════════
  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8E8E8)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: child,
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: _labelStyle),
          Flexible(child: Text(value, style: _valueStyle, textAlign: TextAlign.end)),
        ],
      ),
    );
  }

  static final _divider = Container(height: 1, color: const Color(0xFFF1F1F1));

  static final _labelStyle = GoogleFonts.inter(
    fontSize: 13, fontWeight: FontWeight.w400, color: const Color(0xFF999999));
  static final _valueStyle = GoogleFonts.inter(
    fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF111111));
  static final _sectionTitleStyle = GoogleFonts.inter(
    fontSize: 11, fontWeight: FontWeight.w500, color: const Color(0xFF999999));

  String _getTripTypeLabel(lang.S t) {
    switch (flight.tripType) {
      case 'roundtrip': return t.bookingDetailRoundtrip;
      case 'oneway': return t.bookingDetailOneway;
      case 'multidesti': return t.bookingDetailMulti;
      default: return flight.tripType;
    }
  }

  String _getStatusLabel(int statusId, lang.S t) {
    switch (statusId) {
      case 0: return t.statusPending;
      case 4: return t.statusCancelled;
      case 8: return t.statusPnrPending;
      case 12: return t.statusFailureTicket;
      default: return t.statusInProgress;
    }
  }

  Color _getStatusBgColor(int statusId) {
    switch (statusId) {
      case 0: return const Color(0xFFFFF0E8);
      case 4: return const Color(0xFFFFEBEE);
      case 8: return const Color(0xFFE3F2FD);
      case 12: return const Color(0xFFFFEBEE);
      default: return const Color(0xFFE8F5E9);
    }
  }

  Color _getStatusTextColor(int statusId) {
    switch (statusId) {
      case 0: return const Color(0xFFFF6A00);
      case 4: return const Color(0xFFF44336);
      case 8: return const Color(0xFF2196F3);
      case 12: return const Color(0xFFF44336);
      default: return const Color(0xFF4CAF50);
    }
  }

  String _formatPrice(double price) {
    return price.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]} ');
  }

  static String _extractCity(String airportName) {
    final parts = airportName.split(' ');
    for (int i = parts.length - 1; i >= 0; i--) {
      if (parts[i].contains('-')) {
        return parts[i].split('-').first;
      }
    }
    return airportName;
  }
}
