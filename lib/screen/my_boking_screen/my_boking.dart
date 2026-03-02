import 'package:flight_booking/controllers/booking_controller.dart';
import 'package:flight_booking/generated/l10n.dart' as lang;
import 'package:flight_booking/models/booking_flight.dart';
import 'package:flight_booking/screen/widgets/constant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'booking_detail_screen.dart';
import '../widgets/button_global.dart';

const _kBgColor = Color(0xFFF7F7F9);

class MyBooking extends StatefulWidget {
  final VoidCallback? onBack;

  const MyBooking({Key? key, this.onBack}) : super(key: key);

  @override
  State<MyBooking> createState() => _MyBookingState();
}

class _MyBookingState extends State<MyBooking>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedCategoryIndex = 0;
  int _selectedTabIndex = 0;
  bool _slideFromRight = true;

  // ── Hotel data (fake) ──
  final List<HotelBooking> _activeHotels = [
    HotelBooking(
      id: '#H-2041', status: ReservationStatus.confirme,
      hotelName: 'Sofitel Algiers Hamma Garden', city: 'Alger',
      checkIn: '20 Janv. 2025', checkOut: '24 Janv. 2025',
      nights: 4, rooms: 1, guests: 2,
      price: 72000, currency: 'DZD',
    ),
    HotelBooking(
      id: '#H-2055', status: ReservationStatus.enCours,
      hotelName: 'Hilton Istanbul Bosphorus', city: 'Istanbul',
      checkIn: '18 Fév. 2025', checkOut: '22 Fév. 2025',
      nights: 4, rooms: 1, guests: 2,
      price: 134500, currency: 'DZD',
    ),
  ];
  final List<HotelBooking> _pastHotels = [
    HotelBooking(
      id: '#H-1899', status: ReservationStatus.termine,
      hotelName: 'Sheraton Oran Hotel', city: 'Oran',
      checkIn: '5 Déc. 2024', checkOut: '8 Déc. 2024',
      nights: 3, rooms: 1, guests: 1,
      price: 45000, currency: 'DZD',
    ),
  ];
  final List<HotelBooking> _cancelledHotels = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() => _selectedTabIndex = _tabController.index);
      }
    });
    // Fetch flight bookings from API, then auto-select first non-empty tab
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctrl = context.read<BookingController>();
      ctrl.fetchFlightBookings().then((_) {
        if (!mounted) return;
        _autoSelectTab(ctrl);
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Auto-select the first non-empty tab when the current one is empty.
  void _autoSelectTab(BookingController ctrl) {
    if (_selectedCategoryIndex != 0) return;
    final lists = [ctrl.activeFlights, ctrl.pastFlights, ctrl.cancelledFlights];
    if (lists[_selectedTabIndex].isNotEmpty) return;
    for (int i = 0; i < lists.length; i++) {
      if (lists[i].isNotEmpty) {
        setState(() {
          _selectedTabIndex = i;
          _tabController.animateTo(i);
        });
        return;
      }
    }
  }

  List<dynamic> _currentItems(BookingController ctrl) {
    switch (_selectedCategoryIndex) {
      case 0: // Flights
        return [ctrl.activeFlights, ctrl.pastFlights, ctrl.cancelledFlights][_selectedTabIndex];
      case 1: // Hotels
        return [_activeHotels, _pastHotels, _cancelledHotels][_selectedTabIndex];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingController>(
      builder: (context, ctrl, _) {
        final items = _currentItems(ctrl);

        return Scaffold(
          backgroundColor: _kBgColor,
          body: Column(
            children: [
              _buildHeader(),
              _buildCategoryTabs(),
              _buildStatusTabs(),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  transitionBuilder: (child, animation) {
                    final offsetIn = _slideFromRight
                        ? const Offset(1.0, 0.0)
                        : const Offset(-1.0, 0.0);
                    final isIncoming = child.key == ValueKey('cat_${_selectedCategoryIndex}_tab_$_selectedTabIndex');
                    final offset = isIncoming ? offsetIn : Offset(-offsetIn.dx, 0.0);
                    return SlideTransition(
                      position: Tween<Offset>(begin: offset, end: Offset.zero)
                          .animate(animation),
                      child: FadeTransition(opacity: animation, child: child),
                    );
                  },
                  child: KeyedSubtree(
                    key: ValueKey('cat_${_selectedCategoryIndex}_tab_$_selectedTabIndex'),
                    child: _selectedCategoryIndex == 0 && ctrl.isLoading
                        ? _buildLoadingState()
                        : _selectedCategoryIndex == 0 && ctrl.hasError
                            ? _buildErrorState(ctrl)
                            : items.isEmpty
                                ? _buildEmptyState()
                                : RefreshIndicator(
                                    color: kPrimaryColor,
                                    onRefresh: () => ctrl.refresh(),
                                    child: ListView.builder(
                                      padding: const EdgeInsets.only(top: 8, bottom: 20),
                                      physics: const AlwaysScrollableScrollPhysics(
                                        parent: BouncingScrollPhysics(),
                                      ),
                                      itemCount: items.length,
                                      itemBuilder: (context, index) {
                                        final item = items[index];
                                        if (item is BookingFlight) return _buildApiFlightCard(item);
                                        if (item is HotelBooking) return _buildHotelCard(item);
                                        return const SizedBox.shrink();
                                      },
                                    ),
                                  ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ══════════════════════════════════════════════════
  //  LOADING STATE
  // ══════════════════════════════════════════════════
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 40, height: 40,
            child: CircularProgressIndicator(
              color: kPrimaryColor, strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            lang.S.of(context).bookingLoadError.split('.').first + '...',
            style: GoogleFonts.inter(
              fontSize: 14, color: kSubTitleColor,
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════
  //  ERROR STATE
  // ══════════════════════════════════════════════════
  Widget _buildErrorState(BookingController ctrl) {
    final t = lang.S.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64, height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFFFFEBEE), shape: BoxShape.circle,
              ),
              child: const Icon(Icons.error_outline_rounded,
                color: Color(0xFFF44336), size: 32),
            ),
            const SizedBox(height: 16),
            Text(t.bookingLoadError, textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14, color: kSubTitleColor, height: 1.5)),
            const SizedBox(height: 20),
            SmallTapEffect(
              onTap: () => ctrl.refresh(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [kPrimaryColor, kAccentOrange]),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(t.bookingRetry, style: GoogleFonts.poppins(
                  color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════
  //  HEADER (no balance)
  // ══════════════════════════════════════════════════
  Widget _buildHeader() {
    final t = lang.S.of(context);

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 16,
        right: 16,
        bottom: 16,
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
          SmallTapEffect(
            onTap: () {
              if (widget.onBack != null) { widget.onBack!(); }
              else { Navigator.pop(context); }
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            t.bookingTitle,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════
  //  CATEGORY TABS (Flights + Hotels only)
  // ══════════════════════════════════════════════════
  Widget _buildCategoryTabs() {
    final t = lang.S.of(context);
    final categories = [
      _CategoryItem(Icons.flight, t.bookingCategoryFlights),
      _CategoryItem(Icons.hotel, t.bookingCategoryHotels),
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(12),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final tabWidth = (constraints.maxWidth - 8) / categories.length;
            return Stack(
              children: [
                // Sliding highlight
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  left: _selectedCategoryIndex * tabWidth,
                  top: 0,
                  bottom: 0,
                  width: tabWidth,
                  child: Container(
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: kPrimaryColor.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
                // Tab labels
                Row(
                  children: List.generate(categories.length, (index) {
                    final isSelected = _selectedCategoryIndex == index;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() {
                          _slideFromRight = index > _selectedCategoryIndex;
                          _selectedCategoryIndex = index;
                          _selectedTabIndex = 0;
                          _tabController.animateTo(0);
                        }),
                        behavior: HitTestBehavior.opaque,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 250),
                                child: Icon(
                                  categories[index].icon,
                                  key: ValueKey('icon_${index}_$isSelected'),
                                  size: 18,
                                  color: isSelected ? Colors.white : const Color(0xFF999999),
                                ),
                              ),
                              const SizedBox(width: 6),
                              AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 250),
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected ? Colors.white : const Color(0xFF999999),
                                ),
                                child: Text(categories[index].label),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════
  //  STATUS TABS
  // ══════════════════════════════════════════════════
  Widget _buildStatusTabs() {
    final t = lang.S.of(context);
    final tabs = [t.bookingTabActive, t.bookingTabPast, t.bookingTabCancelled];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = _selectedTabIndex == index;
          return SmallTapEffect(
            onTap: () => setState(() {
              _slideFromRight = index > _selectedTabIndex;
              _selectedTabIndex = index;
              _tabController.animateTo(index);
            }),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    child: Text(tabs[index], style: GoogleFonts.inter(
                      fontSize: 13.5, fontWeight: FontWeight.w600,
                      color: isSelected ? kPrimaryColor : const Color(0xFF999999),
                    )),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 3, width: 40,
                    decoration: BoxDecoration(
                      color: isSelected ? kPrimaryColor : Colors.transparent,
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

  // ══════════════════════════════════════════════════
  //  EMPTY STATE
  // ══════════════════════════════════════════════════
  Widget _buildEmptyState() {
    final t = lang.S.of(context);
    final icons = [Icons.flight_takeoff_rounded, Icons.hotel_rounded];

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 180, height: 140,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(top: 20, child: Transform.rotate(angle: 0.08,
                    child: Container(width: 140, height: 90, decoration: BoxDecoration(
                      color: kLightNeutralColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: kLightNeutralColor.withValues(alpha: 0.2)),
                    )),
                  )),
                  Positioned(top: 10, child: Transform.rotate(angle: -0.05,
                    child: Container(width: 150, height: 95, decoration: BoxDecoration(
                      color: kLightNeutralColor.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: kLightNeutralColor.withValues(alpha: 0.3)),
                    )),
                  )),
                  Positioned(top: 0, child: Container(
                    width: 160, height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white, borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE0E0E0)),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 4))],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(icons[_selectedCategoryIndex], size: 32,
                          color: kPrimaryColor.withValues(alpha: 0.5)),
                        const SizedBox(height: 6),
                        Container(width: 60, height: 4, decoration: BoxDecoration(
                          color: const Color(0xFFE8E8E8), borderRadius: BorderRadius.circular(2))),
                        const SizedBox(height: 4),
                        Container(width: 40, height: 4, decoration: BoxDecoration(
                          color: const Color(0xFFF0F0F0), borderRadius: BorderRadius.circular(2))),
                      ],
                    ),
                  )),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Text(t.bookingEmptyStateTitle, style: GoogleFonts.poppins(
              fontSize: 18, fontWeight: FontWeight.w600, color: kTitleColor)),
            const SizedBox(height: 8),
            Text(t.bookingEmptyStateSubtitle, textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: kSubTitleColor, height: 1.5)),
            const SizedBox(height: 28),
            SmallTapEffect(
              onTap: () { if (widget.onBack != null) widget.onBack!(); },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [kPrimaryColor, kAccentOrange]),
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [BoxShadow(color: kPrimaryColor.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.search_rounded, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(t.bookingSearchFlights, style: GoogleFonts.poppins(
                      color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════
  //  FLIGHT CARD (API model)
  // ══════════════════════════════════════════════════
  Widget _buildApiFlightCard(BookingFlight f) {
    final t = lang.S.of(context);
    final statusLabel = _getStatusLabel(f.statusId, t);
    final statusBg = _getStatusBgColor(f.statusId);
    final statusFg = _getStatusTextColor(f.statusId);

    final depTime = f.segments.isNotEmpty ? f.segments.first.depTimeFormatted : '--:--';
    final arrTime = f.segments.isNotEmpty ? f.segments.last.arrTimeFormatted : '--:--';
    final depDate = f.depDate != null ? DateFormat('EEE d MMM', 'fr_FR').format(f.depDate!) : '';

    return _cardWrapper(
      onTap: () => Navigator.push(context,
        MaterialPageRoute(builder: (_) => BookingDetailScreen(flight: f))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: kPrimaryColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: kPrimaryColor.withValues(alpha: 0.2)),
                ),
                child: Text('#${f.bookingId}', style: GoogleFonts.inter(
                  fontSize: 12, fontWeight: FontWeight.w600, color: kPrimaryColor)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(8)),
                child: Text(statusLabel, style: GoogleFonts.inter(
                  fontSize: 12, fontWeight: FontWeight.w600, color: statusFg)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(depTime, style: _timeSt),
                  const SizedBox(height: 2),
                  Text(f.originCity, style: _citySt),
                  Text(f.originCode, style: _codeSt),
                  const SizedBox(height: 2),
                  Text(depDate, style: _dateSt),
                ],
              )),
              Expanded(child: Column(children: [
                ClipOval(child: Image.network(f.airlineLogo, width: 36, height: 36, fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => _airlineFallback(f.airline))),
                const SizedBox(height: 4),
                Text(f.airline, style: _smallSt, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                _routeArrow(Icons.flight),
                const SizedBox(height: 4),
                Text(f.tripType == 'roundtrip' ? 'A/R' : f.tripType == 'oneway' ? 'A/S' : 'Multi', style: _durationSt),
              ])),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(arrTime, style: _timeSt),
                  const SizedBox(height: 2),
                  Text(f.destinationCity, style: _citySt),
                  Text(f.destinationCode, style: _codeSt),
                ],
              )),
            ],
          ),
          const SizedBox(height: 10),
          Row(children: [
            if (f.pnr.isNotEmpty) ...[
              _infoChip('${t.bookingPnr}: ${f.pnr}'),
              const SizedBox(width: 8),
            ],
            _infoChip('${f.totalPassengers} ${t.bookingPassengers}'),
          ]),
          const SizedBox(height: 12),
          _divider,
          const SizedBox(height: 12),
          _priceDetailsRow(f.salePrice, f.currency, f),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════
  //  HOTEL CARD
  // ══════════════════════════════════════════════════
  Widget _buildHotelCard(HotelBooking h) {
    final t = lang.S.of(context);
    return _cardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _statusRow(h.id, h.status),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: kPrimaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.hotel_rounded, color: kPrimaryColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(h.hotelName, style: GoogleFonts.inter(
                    fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF111111)),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(h.city, style: _codeSt),
                ],
              )),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8F8), borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t.bookingHotelCheckIn, style: _labelSt),
                    const SizedBox(height: 2),
                    Text(h.checkIn, style: _valueSt),
                  ],
                )),
                Container(width: 1, height: 30, color: const Color(0xFFE0E0E0)),
                Expanded(child: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t.bookingHotelCheckOut, style: _labelSt),
                      const SizedBox(height: 2),
                      Text(h.checkOut, style: _valueSt),
                    ],
                  ),
                )),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(children: [
            _infoChip('${h.nights} ${t.bookingHotelNights}'),
            const SizedBox(width: 8),
            _infoChip('${h.rooms} ${t.bookingHotelRoom}'),
            const SizedBox(width: 8),
            _infoChip('${h.guests} ${t.bookingHotelGuests}'),
          ]),
          const SizedBox(height: 12),
          _divider,
          const SizedBox(height: 12),
          _priceDetailsRowSimple(h.price, h.currency),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════
  //  SHARED WIDGETS
  // ══════════════════════════════════════════════════
  Widget _cardWrapper({required Widget child, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: TappableCard(
        onTap: onTap ?? () {},
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE8E8E8)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        padding: const EdgeInsets.all(14),
        child: child,
      ),
    );
  }

  Widget _statusRow(String id, ReservationStatus status) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: kPrimaryColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: kPrimaryColor.withValues(alpha: 0.2)),
          ),
          child: Text(id, style: GoogleFonts.inter(
            fontSize: 12, fontWeight: FontWeight.w600, color: kPrimaryColor)),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: status.backgroundColor, borderRadius: BorderRadius.circular(8)),
          child: Text(status.labelTranslated(context), style: GoogleFonts.inter(
            fontSize: 12, fontWeight: FontWeight.w600, color: status.textColor)),
        ),
      ],
    );
  }

  Widget _routeArrow(IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(width: 20, height: 1, color: const Color(0xFFCCCCCC)),
        Transform.rotate(angle: 1.5708, child: Icon(icon, size: 14, color: kPrimaryColor)),
        Container(width: 20, height: 1, color: const Color(0xFFCCCCCC)),
      ],
    );
  }

  Widget _priceDetailsRow(double price, String currency, BookingFlight f) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('${_formatPrice(price)} $currency', style: GoogleFonts.inter(
          fontSize: 16, fontWeight: FontWeight.w700, color: const Color(0xFF111111))),
        SmallTapEffect(
          onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => BookingDetailScreen(flight: f))),
          child: Row(children: [
            Text(lang.S.of(context).bookingDetails, style: GoogleFonts.inter(
              fontSize: 13, fontWeight: FontWeight.w500, color: kPrimaryColor)),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_right, size: 18, color: kPrimaryColor),
          ]),
        ),
      ],
    );
  }

  Widget _priceDetailsRowSimple(double price, String currency) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('${_formatPrice(price)} $currency', style: GoogleFonts.inter(
          fontSize: 16, fontWeight: FontWeight.w700, color: const Color(0xFF111111))),
        Row(children: [
          Text(lang.S.of(context).bookingDetails, style: GoogleFonts.inter(
            fontSize: 13, fontWeight: FontWeight.w500, color: kPrimaryColor)),
          const SizedBox(width: 4),
          const Icon(Icons.keyboard_arrow_right, size: 18, color: kPrimaryColor),
        ]),
      ],
    );
  }

  Widget _airlineFallback(String name) {
    return Container(
      width: 36, height: 36,
      decoration: BoxDecoration(shape: BoxShape.circle, color: kPrimaryColor.withValues(alpha: 0.1)),
      child: Center(child: Text(
        name.isNotEmpty ? name[0] : 'A',
        style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: kPrimaryColor),
      )),
    );
  }

  Widget _infoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3), borderRadius: BorderRadius.circular(8)),
      child: Text(text, style: GoogleFonts.inter(
        fontSize: 11, fontWeight: FontWeight.w500, color: const Color(0xFF666666))),
    );
  }

  static const _divider = SizedBox(height: 1, child: ColoredBox(color: Color(0xFFF1F1F1)));

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

  static final _timeSt = GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: const Color(0xFF111111));
  static final _citySt = GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: const Color(0xFF111111));
  static final _codeSt = GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400, color: const Color(0xFF999999));
  static final _dateSt = GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w400, color: const Color(0xFF666666));
  static final _smallSt = GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w500, color: const Color(0xFF666666));
  static final _durationSt = GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w400, color: const Color(0xFF999999));
  static final _labelSt = GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, color: const Color(0xFF999999));
  static final _valueSt = GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF111111));

  String _formatPrice(double price) {
    return price.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]} ');
  }
}

// ══════════════════════════════════════════════════
//  HELPER CLASSES
// ══════════════════════════════════════════════════
class _CategoryItem {
  final IconData icon;
  final String label;
  const _CategoryItem(this.icon, this.label);
}

enum ReservationStatus { enCours, confirme, termine, annule }

extension ReservationStatusExtension on ReservationStatus {
  String labelTranslated(BuildContext context) {
    final t = lang.S.of(context);
    switch (this) {
      case ReservationStatus.enCours: return t.statusInProgress;
      case ReservationStatus.confirme: return t.statusConfirmed;
      case ReservationStatus.termine: return t.statusCompleted;
      case ReservationStatus.annule: return t.statusCancelled;
    }
  }

  Color get backgroundColor {
    switch (this) {
      case ReservationStatus.enCours: return const Color(0xFFFFF0E8);
      case ReservationStatus.confirme: return const Color(0xFFE8F5E9);
      case ReservationStatus.termine: return const Color(0xFFE3F2FD);
      case ReservationStatus.annule: return const Color(0xFFFFEBEE);
    }
  }

  Color get textColor {
    switch (this) {
      case ReservationStatus.enCours: return const Color(0xFFFF6A00);
      case ReservationStatus.confirme: return const Color(0xFF4CAF50);
      case ReservationStatus.termine: return const Color(0xFF2196F3);
      case ReservationStatus.annule: return const Color(0xFFF44336);
    }
  }
}

class HotelBooking {
  final String id;
  final ReservationStatus status;
  final String hotelName, city, checkIn, checkOut;
  final int nights, rooms, guests;
  final double price;
  final String currency;

  HotelBooking({
    required this.id, required this.status,
    required this.hotelName, required this.city,
    required this.checkIn, required this.checkOut,
    required this.nights, required this.rooms, required this.guests,
    required this.price, required this.currency,
  });
}
