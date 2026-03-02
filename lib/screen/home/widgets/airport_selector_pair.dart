import 'package:flight_booking/Model/Airport.dart';
import 'package:flight_booking/screen/widgets/SearchBottomSheet.dart';
import 'package:flight_booking/screen/widgets/constant.dart';
import 'package:flight_booking/screen/widgets/button_global.dart';
import 'package:flight_booking/generated/l10n.dart' as lang;
import 'package:flutter/material.dart';

/// A pair of airport selector cards (from/to) with a swap button overlay.
///
/// Each card opens a [SearchBottomSheet] to pick an airport.
/// The swap button uses the double-fleche icon and calls [onSwap].
class AirportSelectorPair extends StatelessWidget {
  final Airport? fromAirport;
  final Airport? toAirport;
  final ValueChanged<Airport> onFromChanged;
  final ValueChanged<Airport> onToChanged;
  final VoidCallback onSwap;
  final bool fromError;
  final bool toError;

  const AirportSelectorPair({
    Key? key,
    required this.fromAirport,
    required this.toAirport,
    required this.onFromChanged,
    required this.onToChanged,
    required this.onSwap,
    this.fromError = false,
    this.toError = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Column(
          children: [
            TappableCard(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(8.0),
                border: fromError
                    ? Border.all(color: Colors.red, width: 1.2)
                    : null,
              ),
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
              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
              child: Row(
                children: [
                  Icon(
                    Icons.flight_takeoff,
                    color: fromError ? Colors.red : kPrimaryColor,
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
                          fromAirport != null
                              ? '${fromAirport!.city} (${fromAirport!.code})'
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
            const SizedBox(height: 12), // Space between the two inputs
            TappableCard(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(8.0),
                border: toError
                    ? Border.all(color: Colors.red, width: 1.2)
                    : null,
              ),
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
              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
              child: Row(
                children: [
                  Icon(
                    Icons.flight_land,
                    color: toError ? Colors.red : kPrimaryColor,
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
                          toAirport != null
                              ? '${toAirport!.city} (${toAirport!.code})'
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
          ],
        ),
        // Positioned swap button - overlapping both inputs
        Positioned(
          right: 12,
          top: 0,
          bottom: 0,
          child: Center(
            child: SmallTapEffect(
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
    );
  }
}
