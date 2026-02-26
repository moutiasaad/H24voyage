import 'package:flight_booking/generated/l10n.dart' as lang;
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

  String statusLabelTranslated(BuildContext context) {
    final t = lang.S.of(context);
    switch (status) {
      case 'en_cours':
        return t.supportStatusInProgress;
      case 'actif':
        return t.supportStatusActive;
      case 'resolu':
        return t.supportStatusResolved;
      case 'ferme':
        return t.supportStatusClosed;
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

  List<String> _tabs(BuildContext context) {
    final t = lang.S.of(context);
    return [t.supportTabAll, t.supportTabActive, t.supportTabResolved, t.supportTabClosed];
  }

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
                    SizedBox(height: isSmallScreen ? 8 : (isMediumScreen ? 10 : 16)),

                    // Stats Tabs
                    _buildStatsTabs(),
                    SizedBox(height: isSmallScreen ? 10 : (isMediumScreen ? 14 : 20)),

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
    final bannerHeight = isSmallScreen ? 38.0 : (isMediumScreen ? 40.0 : 46.0);
    final overlap = bannerHeight / 2;
    final topPad = isSmallScreen ? 8.0 : (isMediumScreen ? 10.0 : 12.0);
    final hPad = isSmallScreen ? 12.0 : 16.0;
    final titleSize = isSmallScreen ? 16.0 : 18.0;

    return Container(
      margin: EdgeInsets.only(bottom: overlap),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Orange header
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + topPad,
              left: hPad,
              right: hPad,
              bottom: overlap + (isSmallScreen ? 8 : 12),
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
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: isSmallScreen ? 22 : 24,
                      ),
                    ),
                    SizedBox(width: isSmallScreen ? 8 : 12),
                    Text(
                      lang.S.of(context).supportTitle,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: titleSize,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isSmallScreen ? 10 : (isMediumScreen ? 12 : 16)),

                // Filter Chips
                _buildFilterChips(),
              ],
            ),
          ),

          // Overlapping banner
          Positioned(
            left: isSmallScreen ? 16 : 24,
            right: isSmallScreen ? 16 : 24,
            bottom: -overlap,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 10 : (isMediumScreen ? 12 : 16),
                vertical: isSmallScreen ? 6 : (isMediumScreen ? 8 : 14),
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
                lang.S.of(context).supportBanner,
                style: GoogleFonts.poppins(
                  color: kPrimaryColor,
                  fontSize: isSmallScreen ? 10 : (isMediumScreen ? 11 : 13),
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final chipPaddingH = isSmallScreen ? 8.0 : (isMediumScreen ? 10.0 : 14.0);
    final chipPaddingV = isSmallScreen ? 6.0 : (isMediumScreen ? 7.0 : 10.0);
    final fontSize = isSmallScreen ? 11.0 : (isMediumScreen ? 12.0 : 13.0);
    final iconSize = isSmallScreen ? 14.0 : (isMediumScreen ? 16.0 : 18.0);
    final spacing = isSmallScreen ? 6.0 : (isMediumScreen ? 8.0 : 10.0);

    Widget buildChip({
      required String label,
      required IconData icon,
      required VoidCallback? onTap,
      bool isActive = false,
    }) {
      return SmallTapEffect(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: chipPaddingH, vertical: chipPaddingV),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isActive ? kPrimaryColor : const Color(0xFFE0E0E0),
              width: isActive ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: isActive ? kPrimaryColor : kSubTitleColor, size: iconSize),
              SizedBox(width: isSmallScreen ? 4 : 6),
              Text(
                label,
                style: GoogleFonts.poppins(
                  color: isActive ? kPrimaryColor : kSubTitleColor,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          buildChip(
            label: lang.S.of(context).supportHelpdesk,
            icon: Icons.menu,
            onTap: () => const FaqScreen().launch(context),
            isActive: true,
          ),
          SizedBox(width: spacing),
          buildChip(
            label: lang.S.of(context).supportFilter,
            icon: Icons.tune,
            onTap: null,
          ),
          SizedBox(width: spacing),
          buildChip(
            label: lang.S.of(context).supportTicket,
            icon: Icons.add_circle_outline,
            onTap: () => const CreateTicket().launch(context),
          ),
        ],
      ),
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
        lang.S.of(context).supportBanner,
        style: GoogleFonts.poppins(
          color: kPrimaryColor,
          fontSize: isSmallScreen ? 11 : 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildStatsTabs() {
    final verticalPadding = isSmallScreen ? 6.0 : (isMediumScreen ? 7.0 : 10.0);
    final horizontalPadding = isSmallScreen ? 2.0 : (isMediumScreen ? 4.0 : 8.0);
    final countFontSize = isSmallScreen ? 11.0 : 12.0;
    final labelFontSize = isSmallScreen ? 10.0 : (isMediumScreen ? 11.0 : 12.0);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 2 : 4, vertical: isSmallScreen ? 3 : 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: List.generate(_tabs(context).length, (index) {
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
                        fontSize: countFontSize,
                        fontWeight: FontWeight.w500,
                        height: 1.2,
                        color: isSelected ? Colors.white : kTitleColor,
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        _tabs(context)[index],
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: labelFontSize,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
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
    final cardPadding = isSmallScreen ? 10.0 : (isMediumScreen ? 12.0 : 16.0);
    final idFontSize = isSmallScreen ? 11.0 : (isMediumScreen ? 12.0 : 13.0);
    final statusFontSize = isSmallScreen ? 10.0 : 12.0;
    final subjectFontSize = isSmallScreen ? 13.0 : (isMediumScreen ? 14.0 : 16.0);
    final infoFontSize = isSmallScreen ? 10.0 : (isMediumScreen ? 11.0 : 12.0);
    final smallFontSize = isSmallScreen ? 9.0 : (isMediumScreen ? 10.0 : 11.0);
    final avatarSize = isSmallScreen ? 26.0 : (isMediumScreen ? 28.0 : 32.0);
    final iconSize = isSmallScreen ? 13.0 : (isMediumScreen ? 14.0 : 16.0);
    final verticalGap = isSmallScreen ? 8.0 : (isMediumScreen ? 10.0 : 12.0);

    return Container(
      margin: EdgeInsets.only(bottom: isSmallScreen ? 8 : 12),
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
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 8 : 10,
                    vertical: isSmallScreen ? 3 : 4,
                  ),
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
                SizedBox(width: isSmallScreen ? 8 : 12),
                // Status badge
                Flexible(
                  child: Text(
                    ticket.statusLabelTranslated(context),
                    style: GoogleFonts.poppins(
                      fontSize: statusFontSize,
                      fontWeight: FontWeight.w500,
                      color: kPrimaryColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: verticalGap),

            // Subject
            Text(
              ticket.subject,
              style: GoogleFonts.poppins(
                fontSize: subjectFontSize,
                fontWeight: FontWeight.w600,
                color: kTitleColor,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: verticalGap),

            // Info Row
            _buildInfoRow(ticket, avatarSize, infoFontSize, iconSize, smallFontSize),

            // Details Button at bottom right
            SizedBox(height: isSmallScreen ? 6 : 10),
            Align(
              alignment: Alignment.centerRight,
              child: _buildDetailsLink(context, infoFontSize),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(SupportTicket ticket, double avatarSize, double infoFontSize, double iconSize, double smallFontSize) {
    // For small and medium screens, use two rows layout
    if (screenWidth < 420) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // First row: Avatar + Name
          Row(
            children: [
              _buildAvatar(ticket, avatarSize),
              SizedBox(width: isSmallScreen ? 6 : 8),
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
          SizedBox(height: isSmallScreen ? 6 : 10),
          // Second row: Date + Service
          Row(
            children: [
              _buildDateChip(ticket, iconSize, smallFontSize),
              SizedBox(width: isSmallScreen ? 6 : 10),
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
        _buildAvatar(ticket, avatarSize),
        const SizedBox(width: 8),
        Flexible(
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
        const SizedBox(width: 12),
        _buildDateChip(ticket, iconSize, smallFontSize),
        const SizedBox(width: 10),
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

  Widget _buildDetailsLink(BuildContext context, double fontSize) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          lang.S.of(context).supportDetails,
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
