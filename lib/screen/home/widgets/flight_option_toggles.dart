import 'package:flight_booking/screen/widgets/constant.dart';
import 'package:flight_booking/generated/l10n.dart' as lang;
import 'package:flutter/material.dart';

/// A row of two toggle switches for direct flights and baggage options.
class FlightOptionToggles extends StatelessWidget {
  final bool isDirectFlight;
  final bool withBaggage;
  final ValueChanged<bool> onDirectFlightChanged;
  final ValueChanged<bool> onBaggageChanged;

  const FlightOptionToggles({
    Key? key,
    required this.isDirectFlight,
    required this.withBaggage,
    required this.onDirectFlightChanged,
    required this.onBaggageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              SizedBox(
                height: 24,
                child: Switch(
                  value: isDirectFlight,
                  onChanged: onDirectFlightChanged,
                  activeColor: kPrimaryColor,
                  activeTrackColor: kPrimaryColor.withOpacity(0.3),
                  inactiveThumbColor: kWhite,
                  inactiveTrackColor: const Color(0xFFE0E0E0),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  trackOutlineColor:
                      WidgetStateProperty.all(Colors.transparent),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  lang.S.of(context).homeDirectFlights,
                  style: kTextStyle.copyWith(
                    color: kTitleColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              SizedBox(
                height: 24,
                child: Switch(
                  value: withBaggage,
                  onChanged: onBaggageChanged,
                  activeColor: kPrimaryColor,
                  activeTrackColor: kPrimaryColor.withOpacity(0.3),
                  inactiveThumbColor: kWhite,
                  inactiveTrackColor: const Color(0xFFE0E0E0),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  trackOutlineColor:
                      WidgetStateProperty.all(Colors.transparent),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  lang.S.of(context).homeWithBaggage,
                  style: kTextStyle.copyWith(
                    color: kTitleColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
