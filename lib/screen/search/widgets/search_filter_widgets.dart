import 'package:flight_booking/generated/l10n.dart' as lang;
import 'package:flight_booking/screen/widgets/constant.dart';
import 'package:flutter/material.dart';

import '../../../controllers/search_result_controller.dart';
import '../../widgets/button_global.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Widget 1: SearchResultHeader
// Extracted from _buildHeader in search_result.dart
// ─────────────────────────────────────────────────────────────────────────────

class SearchResultHeader extends StatelessWidget {
  final String fromCity;
  final String toCity;
  final int totalPassengers;
  final int infantCount;
  final DateTimeRange? dateRange;
  final bool isSmallScreen;
  final bool isMediumScreen;
  final VoidCallback onBack;
  final VoidCallback onEdit;

  const SearchResultHeader({
    Key? key,
    required this.fromCity,
    required this.toCity,
    required this.totalPassengers,
    required this.infantCount,
    this.dateRange,
    required this.isSmallScreen,
    required this.isMediumScreen,
    required this.onBack,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final startDate = SearchResultController.formatDate(dateRange?.start);
    final endDate = SearchResultController.formatDate(dateRange?.end);
    final statusBarHeight = MediaQuery.of(context).padding.top;

    // Responsive values
    final horizontalPadding = isSmallScreen ? 10.0 : 16.0;
    final containerPadding = isSmallScreen ? 8.0 : 12.0;
    final titleFontSize = isSmallScreen ? 13.0 : (isMediumScreen ? 14.0 : 16.0);
    final subTitleFontSize = isSmallScreen ? 10.0 : 12.0;
    final iconSize = isSmallScreen ? 20.0 : 24.0;
    final smallIconSize = isSmallScreen ? 12.0 : 14.0;

    return Container(
      decoration: const BoxDecoration(
        color: Color.fromRGBO(255, 81, 0, 1),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        child: Stack(
          children: [
            // Background image on top of gradient
            Positioned.fill(
              child: Image.asset(
                'assets/backgroundAppBar.png',
                fit: BoxFit.cover,
              ),
            ),
          // Main content
          Padding(
            padding: EdgeInsets.only(
              top: statusBarHeight + 16,
              left: horizontalPadding,
              right: horizontalPadding,
              bottom: 20,
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: containerPadding, vertical: containerPadding),
              decoration: BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Back button
                  SmallTapEffect(
                    onTap: onBack,
                    child: Icon(Icons.arrow_back, color: kTitleColor, size: iconSize),
                  ),
                  SizedBox(width: isSmallScreen ? 8 : 12),

                  // Route info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              flex: 1,
                              child: Text(
                                fromCity,
                                style: kTextStyle.copyWith(
                                  color: kTitleColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: titleFontSize,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: isSmallScreen ? 4 : 6),
                            Text(
                              '\u21C6',
                              style: kTextStyle.copyWith(
                                color: kTitleColor,
                                fontWeight: FontWeight.bold,
                                fontSize: titleFontSize,
                              ),
                            ),
                            SizedBox(width: isSmallScreen ? 4 : 6),
                            Flexible(
                              flex: 1,
                              child: Text(
                                toCity,
                                style: kTextStyle.copyWith(
                                  color: kTitleColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: titleFontSize,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        // Use Wrap for small screens to allow text to flow
                        isSmallScreen
                            ? Wrap(
                                spacing: 4,
                                runSpacing: 2,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    '$startDate - $endDate',
                                    style: kTextStyle.copyWith(
                                      color: kTitleColor,
                                      fontSize: subTitleFontSize,
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.person_outline,
                                          color: kTitleColor.withOpacity(0.8), size: smallIconSize),
                                      const SizedBox(width: 2),
                                      Text(
                                        '$totalPassengers',
                                        style: kTextStyle.copyWith(
                                          color: kTitleColor,
                                          fontSize: subTitleFontSize,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      '$startDate \u00e0 $endDate',
                                      style: kTextStyle.copyWith(
                                        color: kTitleColor,
                                        fontSize: subTitleFontSize,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    ' \u00b7 ',
                                    style: kTextStyle.copyWith(
                                      color: kTitleColor,
                                      fontSize: subTitleFontSize,
                                    ),
                                  ),
                                  Icon(Icons.person_outline,
                                      color: kTitleColor.withOpacity(0.8), size: smallIconSize),
                                  const SizedBox(width: 2),
                                  Text(
                                    '$totalPassengers',
                                    style: kTextStyle.copyWith(
                                      color: kTitleColor,
                                      fontSize: subTitleFontSize,
                                    ),
                                  ),
                                  Text(
                                    ' \u00b7 ',
                                    style: kTextStyle.copyWith(
                                      color: kTitleColor,
                                      fontSize: subTitleFontSize,
                                    ),
                                  ),
                                  Icon(Icons.luggage_outlined,
                                      color: kTitleColor.withOpacity(0.8), size: smallIconSize),
                                  const SizedBox(width: 2),
                                  Text(
                                    '$infantCount',
                                    style: kTextStyle.copyWith(
                                      color: kSubTitleColor,
                                      fontSize: subTitleFontSize,
                                    ),
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),

                  // Edit button - shows bottom sheet to modify search parameters
                  SmallTapEffect(
                    onTap: onEdit,
                    child: Container(
                      padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
                      decoration: BoxDecoration(
                        color: kWhite.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.asset(
                        'assets/editer 1.png',
                        width: isSmallScreen ? 16 : 20,
                        height: isSmallScreen ? 16 : 20,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.edit,
                            color: kWhite,
                            size: isSmallScreen ? 16 : 20,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Widget 2: FilterSection
// Extracted from _buildFilterSection + _buildCompactFilterButton +
//            _buildCompactSortButton in search_result.dart
// ─────────────────────────────────────────────────────────────────────────────

class FilterSection extends StatelessWidget {
  final SearchResultController ctrl;
  final bool isSmallScreen;

  const FilterSection({
    Key? key,
    required this.ctrl,
    required this.isSmallScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = isSmallScreen ? 10.0 : 16.0;
    final fontSize = isSmallScreen ? 12.0 : 14.0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Row(
        children: [
          Text(
            lang.S.of(context).cardDirectFlight,
            style: kTextStyle.copyWith(
              color: kTitleColor,
              fontSize: fontSize,
            ),
          ),
          if (ctrl.hasApiFlights && ctrl.directFlightsCount > 0) ...[
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${ctrl.directFlightsCount}',
                style: kTextStyle.copyWith(
                  color: kPrimaryColor,
                  fontSize: isSmallScreen ? 10 : 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
          const SizedBox(width: 4),
          SizedBox(
            height: isSmallScreen ? 22 : 24,
            child: Switch(
              value: ctrl.isDirectOnly,
              onChanged: ctrl.directFlightsCount > 0
                  ? (val) { ctrl.setDirectOnly(val); }
                  : null,
              activeColor: kPrimaryColor,
              activeTrackColor: kPrimaryColor.withOpacity(0.3),
              inactiveThumbColor: ctrl.directFlightsCount > 0 ? kWhite : kSubTitleColor,
              inactiveTrackColor: const Color(0xFFE0E0E0),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Widget 3: PriceChipsRow
// Extracted from _buildPriceChips in search_result.dart
// ─────────────────────────────────────────────────────────────────────────────

class PriceChipsRow extends StatelessWidget {
  final SearchResultController ctrl;
  final bool isSmallScreen;

  const PriceChipsRow({
    Key? key,
    required this.ctrl,
    required this.isSmallScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chips = ctrl.filterChips;

    if (chips.isEmpty) {
      return const SizedBox.shrink();
    }

    // Responsive values
    final chipHeight = isSmallScreen ? 38.0 : 42.0;
    final chipPaddingH = isSmallScreen ? 10.0 : 14.0;
    final chipFontSize = isSmallScreen ? 11.0 : 12.0;
    final chipMargin = isSmallScreen ? 5.0 : 8.0;
    final logoSize = isSmallScreen ? 28.0 : 32.0;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 5 : 7),
      child: Row(
        children: [
          // "All" chip to clear filter
          SmallTapEffect(
            onTap: () {
              ctrl.selectAirlineChip(null);
            },
            child: Container(
              height: chipHeight,
              margin: EdgeInsets.only(right: chipMargin),
              padding: EdgeInsets.symmetric(horizontal: chipPaddingH),
              decoration: BoxDecoration(
                color: ctrl.selectedAirlineCode == null ? kPrimaryColor.withOpacity(0.1) : kWhite,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: ctrl.selectedAirlineCode == null ? kPrimaryColor : kBorderColorTextField,
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  lang.S.of(context).chipAll,
                  style: kTextStyle.copyWith(
                    color: ctrl.selectedAirlineCode == null ? kPrimaryColor : kTitleColor,
                    fontSize: chipFontSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          // Airline chips
          ...chips.map((chip) {
            final airlineName = chip['airlineName'] as String? ?? '';
            final airlineCode = chip['airlineCode'] as String? ?? '';
            final isSelected = ctrl.selectedAirlineCode == airlineCode;

            return SmallTapEffect(
              onTap: () {
                ctrl.selectAirlineChip(airlineCode);
              },
              child: Tooltip(
                message: '${airlineName.isNotEmpty ? airlineName : airlineCode} - ${chip['text']}',
                child: Container(
                  height: chipHeight,
                  margin: EdgeInsets.only(right: chipMargin),
                  padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 10 : 14),
                  decoration: BoxDecoration(
                    color: isSelected ? kPrimaryColor.withOpacity(0.1) : kWhite,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? kPrimaryColor : kBorderColorTextField,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Airline logo from API
                      ClipOval(
                        child: Image.network(
                          SearchResultController.getAirlineLogoUrl(airlineCode),
                          width: logoSize,
                          height: logoSize,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: logoSize,
                              height: logoSize,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: kPrimaryColor.withOpacity(0.1),
                              ),
                              child: Center(
                                child: Text(
                                  airlineCode.isNotEmpty ? airlineCode : 'A',
                                  style: kTextStyle.copyWith(
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
                              width: logoSize,
                              height: logoSize,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: kPrimaryColor.withOpacity(0.05),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(width: isSmallScreen ? 4 : 8),
                      // Airline name
                      Text(
                        chip['airlineName'] as String? ?? chip['text'],
                        style: kTextStyle.copyWith(
                          color: kTitleColor,
                          fontSize: chipFontSize,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
