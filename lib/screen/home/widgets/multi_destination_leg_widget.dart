import 'package:flight_booking/Model/Airport.dart';
import 'package:flight_booking/screen/widgets/SearchBottomSheet.dart';
import 'package:flight_booking/screen/widgets/constant.dart';
import 'package:flight_booking/generated/l10n.dart' as lang;
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:intl/intl.dart';
import '../models/multi_destination_leg.dart';

/// Widget for a single multi-destination flight leg.
///
/// Shows from/to airport selectors with a swap button, plus a date picker row.
class MultiDestinationLegWidget extends StatelessWidget {
  final MultiDestinationLeg leg;
  final int index;
  final ValueChanged<Airport> onFromChanged;
  final ValueChanged<Airport> onToChanged;
  final VoidCallback onSwap;
  final VoidCallback onDateTap;

  const MultiDestinationLegWidget({
    Key? key,
    required this.leg,
    required this.index,
    required this.onFromChanged,
    required this.onToChanged,
    required this.onSwap,
    required this.onDateTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                children: [
                  // From airport
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: InkWell(
                      onTap: () async {
                        final result = await showModalBottomSheet<Airport>(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                          ),
                          builder: (_) => const SearchBottomSheet(isDestination: false),
                        );

                        if (result != null) {
                          onFromChanged(result);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.flight_takeoff,
                              color: kPrimaryColor,
                              size: 26,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    lang.S.of(context).homeDeparturePlace,
                                    style: kTextStyle.copyWith(
                                      color: Colors.grey.shade600,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    leg.fromAirport != null
                                        ? '${leg.fromAirport!.city} (${leg.fromAirport!.code})'
                                        : lang.S.of(context).homeSelectAirport,
                                    style: kTextStyle.copyWith(
                                      color: kTitleColor,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // To airport
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: InkWell(
                      onTap: () async {
                        final result = await showModalBottomSheet<Airport>(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                          ),
                          builder: (_) => const SearchBottomSheet(isDestination: true),
                        );

                        if (result != null) {
                          onToChanged(result);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.flight_land,
                              color: kPrimaryColor,
                              size: 26,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    lang.S.of(context).homeDestination,
                                    style: kTextStyle.copyWith(
                                      color: Colors.grey.shade600,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    leg.toAirport != null
                                        ? '${leg.toAirport!.city} (${leg.toAirport!.code})'
                                        : lang.S.of(context).homeSelectAirport,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: kTextStyle.copyWith(
                                      color: kTitleColor,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Positioned swap button
              Positioned(
                right: 12,
                top: 0,
                bottom: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: onSwap,
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: kPrimaryColor,
                      ),
                      child: Image.asset(
                        'images/double-fleche.png',
                        width: 22,
                        height: 22,
                        color: kWhite,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          // Date picker for this leg
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: InkWell(
              onTap: onDateTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                child: Row(
                  children: [
                    const Icon(
                      IconlyLight.calendar,
                      color: kPrimaryColor,
                      size: 26,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            lang.S.of(context).homeDeparture,
                            style: kTextStyle.copyWith(
                              color: Colors.grey.shade600,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            leg.departureDate != null
                                ? DateFormat('dd MMM yyyy', 'fr').format(leg.departureDate!)
                                : DateFormat('dd MMM yyyy', 'fr').format(DateTime.now()),
                            style: kTextStyle.copyWith(
                              color: kTitleColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
