import 'package:flight_booking/screen/widgets/constant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../ticket status/ticket_status.dart';
import '../widgets/button_global.dart';

class MyBooking extends StatefulWidget {
  final VoidCallback? onBack;

  const MyBooking({Key? key, this.onBack}) : super(key: key);

  @override
  State<MyBooking> createState() => _MyBookingState();
}

class _MyBookingState extends State<MyBooking> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;

  // Sample reservation data
  final List<Reservation> _activeReservations = [
    Reservation(
      id: '#123456',
      status: ReservationStatus.enCours,
      departureTime: '17:35',
      departureCity: 'Tunis',
      departureCode: 'TUN',
      departureDate: 'Sam. 17 Janv.',
      arrivalTime: '20:25',
      arrivalCity: 'Istanbul',
      arrivalCode: 'IST',
      airlineName: 'Turkish Airlines',
      airlineLogo: 'https://pics.avs.io/70/70/TK.png',
      flightNumber: 'TK 123456',
      duration: '2h50min',
      price: 16316,
      currency: 'DZD',
    ),
    Reservation(
      id: '#789012',
      status: ReservationStatus.confirme,
      departureTime: '08:15',
      departureCity: 'Alger',
      departureCode: 'ALG',
      departureDate: 'Lun. 20 Janv.',
      arrivalTime: '12:45',
      arrivalCity: 'Paris',
      arrivalCode: 'CDG',
      airlineName: 'Air Algérie',
      airlineLogo: 'https://pics.avs.io/70/70/AH.png',
      flightNumber: 'AH 1024',
      duration: '2h30min',
      price: 45200,
      currency: 'DZD',
    ),
  ];

  final List<Reservation> _pastReservations = [
    Reservation(
      id: '#654321',
      status: ReservationStatus.termine,
      departureTime: '14:00',
      departureCity: 'Oran',
      departureCode: 'ORN',
      departureDate: 'Ven. 10 Janv.',
      arrivalTime: '16:30',
      arrivalCity: 'Casablanca',
      arrivalCode: 'CMN',
      airlineName: 'Royal Air Maroc',
      airlineLogo: 'https://pics.avs.io/70/70/AT.png',
      flightNumber: 'AT 456',
      duration: '2h30min',
      price: 28500,
      currency: 'DZD',
    ),
  ];

  final List<Reservation> _cancelledReservations = [
    Reservation(
      id: '#111222',
      status: ReservationStatus.annule,
      departureTime: '09:00',
      departureCity: 'Alger',
      departureCode: 'ALG',
      departureDate: 'Mer. 5 Janv.',
      arrivalTime: '11:30',
      arrivalCity: 'Tunis',
      arrivalCode: 'TUN',
      airlineName: 'Tunisair',
      airlineLogo: 'https://pics.avs.io/70/70/TU.png',
      flightNumber: 'TU 789',
      duration: '1h30min',
      price: 12800,
      currency: 'DZD',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _selectedTabIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Reservation> get _currentReservations {
    switch (_selectedTabIndex) {
      case 0:
        return _activeReservations;
      case 1:
        return _pastReservations;
      case 2:
        return _cancelledReservations;
      default:
        return _activeReservations;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: kWhite,
      body: Column(
        children: [
          // Custom Header
          _buildHeader(statusBarHeight),

          // Tab Selector
          _buildTabSelector(),

          // Reservation List
          Expanded(
            child: _currentReservations.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 20),
                    physics: const BouncingScrollPhysics(),
                    itemCount: _currentReservations.length,
                    itemBuilder: (context, index) {
                      return _buildReservationCard(_currentReservations[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(double statusBarHeight) {
    return Container(
      padding: EdgeInsets.only(
        top: statusBarHeight + 16,
        left: 16,
        right: 16,
        bottom: 20,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFF8C42),
            Color(0xFFFF6B35),
            kPrimaryColor,
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          // Back button -> go to home screen
          SmallTapEffect(
            onTap: () {
              if (widget.onBack != null) {
                widget.onBack!();
              } else {
                Navigator.pop(context);
              }
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          // Title
          Text(
            'Réservations',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          // Add button in circle
          SmallTapEffect(
            onTap: () {
              // Navigate to add reservation
            },
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: const Icon(
                Icons.add,
                size: 18,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSelector() {
    final tabs = ['Actifs', 'Passés', 'Annulés'];

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFF1F1F1), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(tabs.length, (index) {
          final isSelected = _selectedTabIndex == index;
          return SmallTapEffect(
            onTap: () {
              setState(() {
                _selectedTabIndex = index;
                _tabController.animateTo(index);
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    child: Text(
                      tabs[index],
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? const Color(0xFFFF6A00) : const Color(0xFF999999),
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 3,
                    width: 40,
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFFF6A00) : Colors.transparent,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildEmptyState() {
    String message;
    IconData icon;

    switch (_selectedTabIndex) {
      case 0:
        message = 'Aucune réservation active';
        icon = Icons.flight_takeoff;
        break;
      case 1:
        message = 'Aucun voyage passé';
        icon = Icons.history;
        break;
      case 2:
        message = 'Aucune réservation annulée';
        icon = Icons.cancel_outlined;
        break;
      default:
        message = 'Aucune réservation';
        icon = Icons.flight;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: const Color(0xFFCCCCCC),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF999999),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReservationCard(Reservation reservation) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: TappableCard(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TicketStatus(),
            ),
          );
        },
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE8E8E8)),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Header Row
            _buildCardHeader(reservation),
            const SizedBox(height: 14),

            // Flight Info Row
            _buildFlightInfo(reservation),
            const SizedBox(height: 14),

            // Divider
            Container(
              height: 1,
              color: const Color(0xFFF1F1F1),
            ),
            const SizedBox(height: 12),

            // Price Row
            _buildPriceRow(reservation),
          ],
        ),
      ),
    );
  }

  Widget _buildCardHeader(Reservation reservation) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Booking ID Badge with border
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF3FF),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF1D6FFF).withOpacity(0.3)),
          ),
          child: Text(
            reservation.id,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1D6FFF),
            ),
          ),
        ),
        // Status as plain text
        Text(
          reservation.status.label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: reservation.status.textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildFlightInfo(Reservation reservation) {
    return Row(
      children: [
        // Departure Block
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                reservation.departureTime,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF111111),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                reservation.departureCity,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF111111),
                ),
              ),
              Text(
                reservation.departureCode,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF999999),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                reservation.departureDate,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF666666),
                ),
              ),
            ],
          ),
        ),

        // Center Block (Airline & Duration)
        Expanded(
          child: Column(
            children: [
              // Airline Logo
              ClipOval(
                child: Image.network(
                  reservation.airlineLogo,
                  width: 36,
                  height: 36,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFFF6A00).withOpacity(0.1),
                      ),
                      child: Center(
                        child: Text(
                          reservation.airlineName.isNotEmpty
                              ? reservation.airlineName[0]
                              : 'A',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFFF6A00),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 4),
              Text(
                reservation.flightNumber,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF666666),
                ),
              ),
              const SizedBox(height: 4),
              // Arrow with duration
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 20,
                    height: 1,
                    color: const Color(0xFFCCCCCC),
                  ),
                  Transform.rotate(
                    angle: 1.5708, // 90 degrees in radians
                    child: const Icon(
                      Icons.flight,
                      size: 14,
                      color: Color(0xFFFF6A00),
                    ),
                  ),
                  Container(
                    width: 20,
                    height: 1,
                    color: const Color(0xFFCCCCCC),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                reservation.duration,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF999999),
                ),
              ),
            ],
          ),
        ),

        // Arrival Block
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                reservation.arrivalTime,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF111111),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                reservation.arrivalCity,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF111111),
                ),
              ),
              Text(
                reservation.arrivalCode,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF999999),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(Reservation reservation) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Price
        Text(
          '${_formatPrice(reservation.price)} ${reservation.currency}',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF111111),
          ),
        ),
        // Details link
        SmallTapEffect(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TicketStatus(),
              ),
            );
          },
          child: Row(
            children: [
              Text(
                'Détails',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1D6FFF),
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.keyboard_arrow_right,
                size: 18,
                color: Color(0xFF1D6FFF),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatPrice(double price) {
    return price.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]} ',
        );
  }
}

// Reservation Status Enum
enum ReservationStatus {
  enCours,
  confirme,
  termine,
  annule,
}

extension ReservationStatusExtension on ReservationStatus {
  String get label {
    switch (this) {
      case ReservationStatus.enCours:
        return 'en cours';
      case ReservationStatus.confirme:
        return 'confirmé';
      case ReservationStatus.termine:
        return 'terminé';
      case ReservationStatus.annule:
        return 'annulé';
    }
  }

  Color get backgroundColor {
    switch (this) {
      case ReservationStatus.enCours:
        return const Color(0xFFFFF0E8);
      case ReservationStatus.confirme:
        return const Color(0xFFE8F5E9);
      case ReservationStatus.termine:
        return const Color(0xFFE3F2FD);
      case ReservationStatus.annule:
        return const Color(0xFFFFEBEE);
    }
  }

  Color get textColor {
    switch (this) {
      case ReservationStatus.enCours:
        return const Color(0xFFFF6A00);
      case ReservationStatus.confirme:
        return const Color(0xFF4CAF50);
      case ReservationStatus.termine:
        return const Color(0xFF2196F3);
      case ReservationStatus.annule:
        return const Color(0xFFF44336);
    }
  }
}

// Reservation Model
class Reservation {
  final String id;
  final ReservationStatus status;
  final String departureTime;
  final String departureCity;
  final String departureCode;
  final String departureDate;
  final String arrivalTime;
  final String arrivalCity;
  final String arrivalCode;
  final String airlineName;
  final String airlineLogo;
  final String flightNumber;
  final String duration;
  final double price;
  final String currency;

  Reservation({
    required this.id,
    required this.status,
    required this.departureTime,
    required this.departureCity,
    required this.departureCode,
    required this.departureDate,
    required this.arrivalTime,
    required this.arrivalCity,
    required this.arrivalCode,
    required this.airlineName,
    required this.airlineLogo,
    required this.flightNumber,
    required this.duration,
    required this.price,
    required this.currency,
  });
}
