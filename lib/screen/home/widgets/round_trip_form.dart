import 'package:flight_booking/Model/Airport.dart';
import 'package:flight_booking/screen/widgets/constant.dart';
import 'package:flight_booking/screen/widgets/button_global.dart';
import 'package:flight_booking/generated/l10n.dart' as lang;
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import 'airport_selector_pair.dart';
import 'date_selector_row.dart';
import 'passenger_class_selector.dart';
import 'flight_option_toggles.dart';

/// Form for Round-trip (index 0) and One-way (index 1) search.
/// Hidden when selectedIndex == 2 (multi-destination).
class RoundTripForm extends StatelessWidget {
  final int selectedIndex;
  final Airport? fromAirport;
  final Airport? toAirport;
  final DateTime? departureDate;
  final DateTime? returnDate;
  final int totalPassengers;
  final String classDisplayName;
  final bool isDirectFlight;
  final bool withBaggage;
  final bool isSearching;
  final ValueChanged<Airport> onFromChanged;
  final ValueChanged<Airport> onToChanged;
  final VoidCallback onSwap;
  final VoidCallback onDateTap;
  final VoidCallback onPassengerTap;
  final ValueChanged<bool> onDirectFlightChanged;
  final ValueChanged<bool> onBaggageChanged;
  final VoidCallback onSearch;

  const RoundTripForm({
    Key? key,
    required this.selectedIndex,
    required this.fromAirport,
    required this.toAirport,
    required this.departureDate,
    required this.returnDate,
    required this.totalPassengers,
    required this.classDisplayName,
    required this.isDirectFlight,
    required this.withBaggage,
    required this.isSearching,
    required this.onFromChanged,
    required this.onToChanged,
    required this.onSwap,
    required this.onDateTap,
    required this.onPassengerTap,
    required this.onDirectFlightChanged,
    required this.onBaggageChanged,
    required this.onSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AirportSelectorPair(
          fromAirport: fromAirport,
          toAirport: toAirport,
          onFromChanged: onFromChanged,
          onToChanged: onToChanged,
          onSwap: onSwap,
        ),
        const SizedBox(height: 10.0),
        DateSelectorRow(
          departureDate: departureDate,
          returnDate: returnDate,
          showReturnDate: selectedIndex == 0,
          onTap: onDateTap,
        ),
        const SizedBox(height: 10.0),
        PassengerClassSelector(
          totalPassengers: totalPassengers,
          classDisplayName: classDisplayName,
          onTap: onPassengerTap,
        ),
        const SizedBox(height: 15.0),
        FlightOptionToggles(
          isDirectFlight: isDirectFlight,
          withBaggage: withBaggage,
          onDirectFlightChanged: onDirectFlightChanged,
          onBaggageChanged: onBaggageChanged,
        ),
        const SizedBox(height: 15.0),
        ButtonGlobalWithoutIcon(
          buttontext: isSearching
              ? lang.S.of(context).homeSearching
              : lang.S.of(context).homeSearchFlights,
          buttonDecoration: kButtonDecoration.copyWith(
            color: isSearching ? kPrimaryColor.withOpacity(0.7) : kPrimaryColor,
            borderRadius: BorderRadius.circular(100.0),
          ),
          onPressed: onSearch,
          buttonTextColor: kWhite,
        ),
      ],
    ).visible(selectedIndex != 2);
  }
}
