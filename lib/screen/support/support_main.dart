import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import '../widgets/constant.dart';
import '../widgets/button_global.dart';
import 'create_ticket.dart';
import 'ticket_detail.dart';
import 'faq_screen.dart';

/// Model for support ticket
class SupportTicket {
  final String id;
  final String subject;
  final String service;
  final String status;
  final String assignedTo;
  final String assignedInitials;
  final DateTime date;

  SupportTicket({
    required this.id,
    required this.subject,
    required this.service,
    required this.status,
    required this.assignedTo,
    required this.assignedInitials,
    required this.date,
  });

  String get statusLabel {
    switch (status) {
      case 'en_cours':
        return 'en cours';
      case 'actif':
        return 'Actif';
      case 'resolu':
        return 'Résolu';
      case 'ferme':
        return 'Fermé';
      default:
        return status;
    }
  }
}

class SupportMain extends StatefulWidget {
  final VoidCallback? onBack;

  const SupportMain({Key? key, this.onBack}) : super(key: key);

  @override
  State<SupportMain> createState() => _SupportMainState();
}

class _SupportMainState extends State<SupportMain> {
  int _selectedTabIndex = 0;
  List<SupportTicket> _tickets = [];

  final List<String> _tabs = ['Toutes', 'Actifs', 'Résolus', 'Fermés'];

  // Responsive breakpoints
  bool get isSmallScreen => MediaQuery.of(context).size.width < 360;
  bool get isMediumScreen => MediaQuery.of(context).size.width < 400;
  double get screenWidth => MediaQuery.of(context).size.width;

  @override
  void initState() {
    super.initState();
    _loadTickets();
  }

  void _loadTickets() {
    _tickets = [
      SupportTicket(
        id: '#123456',
        subject: 'Demande de devis vol',
        service: 'Service Billetterie',
        status: 'en_cours',
        assignedTo: 'Jihen Belhadj',
        assignedInitials: 'JB',
        date: DateTime(2026, 12, 28),
      ),
      SupportTicket(
        id: '#123456',
        subject: 'Demande de devis vol',
        service: 'Service Billetterie',
        status: 'en_cours',
        assignedTo: 'Jihen Belhadj',
        assignedInitials: 'JB',
        date: DateTime(2026, 12, 28),
      ),
      SupportTicket(
        id: '#123456',
        subject: 'Demande de devis vol',
        service: 'Service Billetterie',
        status: 'en_cours',
        assignedTo: 'Jihen Belhadj',
        assignedInitials: 'JB',
        date: DateTime(2026, 12, 28),
      ),
    ];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: Column(
        children: [
          // Orange Header + overlapping banner
          _buildHeaderWithBanner(),

          // Content
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 12 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: isSmallScreen ? 12 : 16),

                    // Stats Tabs
                    _buildStatsTabs(),
                    SizedBox(height: isSmallScreen ? 16 : 20),

                    // Ticket Cards
                    ..._tickets.map((ticket) => _buildTicketCard(ticket)).toList(),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderWithBanner() {
    const double bannerHeight = 46;
    const double overlap = bannerHeight / 2;

    return Container(
      margin: const EdgeInsets.only(bottom: overlap),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Orange header
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 12,
              left: 16,
              right: 16,
              bottom: overlap + 12,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title row
                Row(
                  children: [
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
                    Text(
                      'Support client',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Filter Chips
                _buildFilterChips(),
              ],
            ),
          ),

          // Overlapping banner - half inside header, half outside
          Positioned(
            left: 24,
            right: 24,
            bottom: -overlap,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 12 : 16,
                vertical: isSmallScreen ? 10 : 14,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF4EE),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                'Gérez et suivez vos demandes en temps réel',
                style: GoogleFonts.poppins(
                  color: kPrimaryColor,
                  fontSize: isSmallScreen ? 11 : 13,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final chipPaddingH = isSmallScreen ? 10.0 : 14.0;
    final chipPaddingV = isSmallScreen ? 8.0 : 10.0;
    final fontSize = isSmallScreen ? 12.0 : 13.0;
    final iconSize = isSmallScreen ? 16.0 : 18.0;
    final spacing = isSmallScreen ? 6.0 : 10.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
          // Helpdesk Chip (selected)
          SmallTapEffect(
            onTap: () => const FaqScreen().launch(context),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: chipPaddingH, vertical: chipPaddingV),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: kPrimaryColor, width: 1.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.menu, color: kPrimaryColor, size: iconSize),
                  SizedBox(width: isSmallScreen ? 4 : 8),
                  Text(
                    'Helpdesk',
                    style: GoogleFonts.poppins(
                      color: kPrimaryColor,
                      fontSize: fontSize,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: spacing),

          // Filter Chip
          SmallTapEffect(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: chipPaddingH, vertical: chipPaddingV),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.tune, color: kSubTitleColor, size: iconSize),
                  SizedBox(width: isSmallScreen ? 4 : 8),
                  Text(
                    'Filtrer',
                    style: GoogleFonts.poppins(
                      color: kSubTitleColor,
                      fontSize: fontSize,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: spacing),

          // Ticket Chip
          SmallTapEffect(
            onTap: () => const CreateTicket().launch(context),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: chipPaddingH, vertical: chipPaddingV),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_circle_outline, color: kSubTitleColor, size: iconSize),
                  SizedBox(width: isSmallScreen ? 4 : 8),
                  Text(
                    'Ticket',
                    style: GoogleFonts.poppins(
                      color: kSubTitleColor,
                      fontSize: fontSize,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 12 : 16,
        vertical: isSmallScreen ? 10 : 14,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4EE),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Gérez et suivez vos demandes en temps réel',
        style: GoogleFonts.poppins(
          color: kPrimaryColor,
          fontSize: isSmallScreen ? 11 : 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildStatsTabs() {
    final verticalPadding = isSmallScreen ? 8.0 : 10.0;
    final horizontalPadding = isSmallScreen ? 4.0 : 8.0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 2 : 4, vertical: isSmallScreen ? 4 : 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: List.generate(_tabs.length, (index) {
          final isSelected = _selectedTabIndex == index;
          return Expanded(
            child: SmallTapEffect(
              onTap: () {
                setState(() => _selectedTabIndex = index);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: verticalPadding, horizontal: horizontalPadding),
                decoration: BoxDecoration(
                  color: isSelected ? kPrimaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '03',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        height: 16 / 12,
                        color: isSelected ? Colors.white : kTitleColor,
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        _tabs[index],
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          height: 16 / 12,
                          color: isSelected ? Colors.white : kSubTitleColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTicketCard(SupportTicket ticket) {
    // Responsive values
    final cardPadding = isSmallScreen ? 12.0 : 16.0;
    final idFontSize = isSmallScreen ? 12.0 : 13.0;
    final statusFontSize = isSmallScreen ? 10.0 : 12.0;
    final subjectFontSize = isSmallScreen ? 14.0 : 16.0;
    final infoFontSize = isSmallScreen ? 11.0 : 12.0;
    final smallFontSize = isSmallScreen ? 10.0 : 11.0;
    final avatarSize = isSmallScreen ? 28.0 : 32.0;
    final iconSize = isSmallScreen ? 14.0 : 16.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: TappableCard(
        onTap: () => TicketDetail(ticketId: ticket.id).launch(context),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFFE8E8E8),
            width: 1,
          ),
        ),
        padding: EdgeInsets.all(cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ID and Status Row
            Row(
              children: [
                // ID badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF3FF),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFD0E3FF),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    ticket.id,
                    style: GoogleFonts.poppins(
                      fontSize: idFontSize,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2196F3),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Status badge
                Text(
                  ticket.statusLabel,
                  style: GoogleFonts.poppins(
                    fontSize: statusFontSize,
                    fontWeight: FontWeight.w500,
                    color: kPrimaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Subject
            Text(
              ticket.subject,
              style: GoogleFonts.poppins(
                fontSize: subjectFontSize,
                fontWeight: FontWeight.w600,
                color: kTitleColor,
              ),
            ),
            const SizedBox(height: 14),

            // Info Row
            _buildInfoRow(ticket, avatarSize, infoFontSize, iconSize, smallFontSize),

            // Details Button at bottom right
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: _buildDetailsLink(infoFontSize),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(SupportTicket ticket, double avatarSize, double infoFontSize, double iconSize, double smallFontSize) {
    // For small screens, use two rows layout
    if (isSmallScreen || screenWidth < 400) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // First row: Avatar + Name
          Row(
            children: [
              _buildAvatar(ticket, avatarSize),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  ticket.assignedTo,
                  style: GoogleFonts.poppins(
                    fontSize: infoFontSize,
                    fontWeight: FontWeight.w500,
                    color: kTitleColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Second row: Date + Service
          Row(
            children: [
              _buildDateChip(ticket, iconSize, smallFontSize),
              const SizedBox(width: 10),
              Expanded(
                child: _buildServiceChip(ticket, iconSize, smallFontSize),
              ),
            ],
          ),
        ],
      );
    }

    // For larger screens, use single row
    return Row(
      children: [
        // Avatar
        _buildAvatar(ticket, avatarSize),
        const SizedBox(width: 8),
        // Name
        Text(
          ticket.assignedTo,
          style: GoogleFonts.poppins(
            fontSize: infoFontSize,
            fontWeight: FontWeight.w500,
            color: kTitleColor,
          ),
        ),
        const SizedBox(width: 12),

        // Date with calendar icon
        _buildDateChip(ticket, iconSize, smallFontSize),
        const SizedBox(width: 10),

        // Service with tag icon
        Expanded(
          child: _buildServiceChip(ticket, iconSize, smallFontSize),
        ),
      ],
    );
  }

  Widget _buildAvatar(SupportTicket ticket, double size) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFFFFEEE6),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          ticket.assignedInitials,
          style: GoogleFonts.poppins(
            fontSize: size * 0.4,
            fontWeight: FontWeight.w700,
            color: kPrimaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildDateChip(SupportTicket ticket, double iconSize, double fontSize) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: iconSize + 10,
          height: iconSize + 10,
          decoration: BoxDecoration(
            color: const Color(0xFFF0F0F0),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: Image.asset(
              'assets/calandreIcon.png',
              width: iconSize,
              height: iconSize,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          _formatDateShort(ticket.date),
          style: GoogleFonts.poppins(
            fontSize: fontSize,
            color: kSubTitleColor,
          ),
        ),
      ],
    );
  }

  Widget _buildServiceChip(SupportTicket ticket, double iconSize, double fontSize) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: iconSize + 10,
          height: iconSize + 10,
          decoration: BoxDecoration(
            color: const Color(0xFFFFF4EE),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: Image.asset(
              'assets/servicesIcon.png',
              width: iconSize,
              height: iconSize,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            ticket.service,
            style: GoogleFonts.poppins(
              fontSize: fontSize,
              color: kSubTitleColor,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsLink(double fontSize) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Détails',
          style: GoogleFonts.poppins(
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF0076D1),
          ),
        ),
        const SizedBox(width: 2),
        Icon(
          Icons.keyboard_arrow_down,
          size: fontSize + 6,
          color: const Color(0xFF0076D1),
        ),
      ],
    );
  }

  String _formatDateShort(DateTime date) {
    final months = ['jan', 'fév', 'mar', 'avr', 'mai', 'juin', 'juil', 'aoû', 'sep', 'oct', 'nov', 'dec'];
    return '${date.day} ${months[date.month - 1]}';
  }
}
