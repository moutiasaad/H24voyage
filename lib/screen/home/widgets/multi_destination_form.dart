import 'package:flight_booking/Model/Airport.dart';
import 'package:flight_booking/screen/widgets/constant.dart';
import 'package:flight_booking/screen/widgets/button_global.dart';
import 'package:flight_booking/generated/l10n.dart' as lang;
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:nb_utils/nb_utils.dart';

import '../models/multi_destination_leg.dart';
import 'airport_selector_pair.dart';
import 'date_selector_row.dart';
import 'passenger_class_selector.dart';
import 'flight_option_toggles.dart';
import 'multi_destination_leg_widget.dart';

/// Form for Multi-destination search (selectedIndex == 2).
class MultiDestinationForm extends StatelessWidget {
  final int selectedIndex;
  final Airport? fromAirport;
  final Airport? toAirport;
  final DateTime? departureDate;
  final DateTime? returnDate;
  final List<MultiDestinationLeg> multiDestinationLegs;
  final int totalPassengers;
  final String classDisplayName;
  final bool isDirectFlight;
  final bool withBaggage;
  final ValueChanged<Airport> onFromChanged;
  final ValueChanged<Airport> onToChanged;
  final VoidCallback onSwap;
  final VoidCallback onDateTap;
  final VoidCallback onPassengerTap;
  final ValueChanged<bool> onDirectFlightChanged;
  final ValueChanged<bool> onBaggageChanged;
  final VoidCallback onAddLeg;
  final ValueChanged<int> onRemoveLeg;
  final void Function(int, Airport) onLegFromChanged;
  final void Function(int, Airport) onLegToChanged;
  final ValueChanged<int> onLegSwap;
  final ValueChanged<int> onLegDateTap;
  final VoidCallback onSearch;

  const MultiDestinationForm({
    Key? key,
    required this.selectedIndex,
    required this.fromAirport,
    required this.toAirport,
    required this.departureDate,
    required this.returnDate,
    required this.multiDestinationLegs,
    required this.totalPassengers,
    required this.classDisplayName,
    required this.isDirectFlight,
    required this.withBaggage,
    required this.onFromChanged,
    required this.onToChanged,
    required this.onSwap,
    required this.onDateTap,
    required this.onPassengerTap,
    required this.onDirectFlightChanged,
    required this.onBaggageChanged,
    required this.onAddLeg,
    required this.onRemoveLeg,
    required this.onLegFromChanged,
    required this.onLegToChanged,
    required this.onLegSwap,
    required this.onLegDateTap,
    required this.onSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Flight 1 header
        Row(
          children: [
            Text(
              '${lang.S.of(context).flight} 1',
              style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 5.0),
        // Flight 1 - airports
        AirportSelectorPair(
          fromAirport: fromAirport,
          toAirport: toAirport,
          onFromChanged: onFromChanged,
          onToChanged: onToChanged,
          onSwap: onSwap,
        ),
        const SizedBox(height: 5.0),
        // Flight 1 - dates
        DateSelectorRow(
          departureDate: departureDate,
          returnDate: returnDate,
          showReturnDate: true,
          onTap: onDateTap,
        ),
        // Additional legs
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: multiDestinationLegs.length,
          itemBuilder: (_, i) {
            final leg = multiDestinationLegs[i];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${lang.S.of(context).flight} ${i + 2}',
                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    GestureDetector(
                      child: const Icon(FeatherIcons.x, color: kSubTitleColor),
                      onTap: () => onRemoveLeg(i),
                    ),
                  ],
                ),
                MultiDestinationLegWidget(
                  leg: leg,
                  index: i,
                  onFromChanged: (airport) => onLegFromChanged(i, airport),
                  onToChanged: (airport) => onLegToChanged(i, airport),
                  onSwap: () => onLegSwap(i),
                  onDateTap: () => onLegDateTap(i),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 10.0),
        // Add flight button (max 4 flights = 1 main + 3 additional)
        if (multiDestinationLegs.length < 3)
          ButtonGlobalWithoutIcon(
            buttontext: lang.S.of(context).addFightButton,
            buttonDecoration: kButtonDecoration.copyWith(
              color: kWhite,
              border: Border.all(color: kPrimaryColor),
              borderRadius: BorderRadius.circular(30.0),
            ),
            onPressed: onAddLeg,
            buttonTextColor: kPrimaryColor,
          ),
        const SizedBox(height: 10.0),
        // Passenger & class
        PassengerClassSelector(
          totalPassengers: totalPassengers,
          classDisplayName: classDisplayName,
          onTap: onPassengerTap,
        ),
        const SizedBox(height: 15.0),
        // Toggles
        FlightOptionToggles(
          isDirectFlight: isDirectFlight,
          withBaggage: withBaggage,
          onDirectFlightChanged: onDirectFlightChanged,
          onBaggageChanged: onBaggageChanged,
        ),
        const SizedBox(height: 15.0),
        // Search button
        ButtonGlobalWithoutIcon(
          buttontext: lang.S.of(context).searchFlight,
          buttonDecoration: kButtonDecoration.copyWith(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(30.0),
          ),
          onPressed: onSearch,
          buttonTextColor: kWhite,
        ),
      ],
    ).visible(selectedIndex == 2);
  }
}
