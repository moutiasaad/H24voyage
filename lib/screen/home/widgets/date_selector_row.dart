import 'package:flight_booking/screen/widgets/constant.dart';
import 'package:flight_booking/screen/widgets/button_global.dart';
import 'package:flight_booking/generated/l10n.dart' as lang;
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:intl/intl.dart';

/// A row of date selectors for departure and optionally return dates.
/// Shows one or two TappableCard date fields depending on [showReturnDate].
class DateSelectorRow extends StatelessWidget {
  final DateTime? departureDate;
  final DateTime? returnDate;
  final bool showReturnDate;
  final VoidCallback onTap;
  final bool departureError;
  final bool returnError;

  const DateSelectorRow({
    Key? key,
    required this.departureDate,
    required this.returnDate,
    required this.showReturnDate,
    required this.onTap,
    this.departureError = false,
    this.returnError = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TappableCard(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8.0),
              border: departureError
                  ? Border.all(color: Colors.red, width: 1.2)
                  : null,
            ),
            onTap: onTap,
            padding:
                const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
            child: Row(
              children: [
                Icon(
                  IconlyLight.calendar,
                  color: departureError ? Colors.red : kPrimaryColor,
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
                          color: departureError ? Colors.red : Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        departureDate != null
                            ? DateFormat('dd MMM yyyy', 'fr')
                                .format(departureDate!)
                            : 'jj/mm/aaaa',
                        style: kTextStyle.copyWith(
                          color: departureDate != null
                              ? kTitleColor
                              : departureError
                                  ? Colors.red.shade300
                                  : kSubTitleColor,
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
        if (showReturnDate) ...[
          const SizedBox(width: 10.0),
          Expanded(
            child: TappableCard(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(8.0),
                border: returnError
                    ? Border.all(color: Colors.red, width: 1.2)
                    : null,
              ),
              onTap: onTap,
              padding:
                  const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
              child: Row(
                children: [
                  Icon(
                    IconlyLight.calendar,
                    color: returnError ? Colors.red : kPrimaryColor,
                    size: 26,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          lang.S.of(context).homeReturn,
                          style: kTextStyle.copyWith(
                            color: returnError ? Colors.red : Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          returnDate != null
                              ? DateFormat('dd MMM yyyy', 'fr')
                                  .format(returnDate!)
                              : 'jj/mm/aaaa',
                          style: kTextStyle.copyWith(
                            color: returnDate != null
                                ? kTitleColor
                                : returnError
                                    ? Colors.red.shade300
                                    : kSubTitleColor,
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
        ],
      ],
    );
  }
}
