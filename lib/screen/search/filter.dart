import 'package:flight_booking/screen/widgets/button_global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import '../widgets/constant.dart';
import 'package:flight_booking/generated/l10n.dart' as lang;

class Filter extends StatefulWidget {
  const Filter({Key? key}) : super(key: key);

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> with TickerProviderStateMixin {
  double price = 0.00;
  double priceAller = 0.00;
  double priceRetour = 0.00;
  int selectedPriceTab = 0; // 0 = Aller, 1 = Retour

  List<String> titleList = ['Non Stop', 'Up to 1 Stop', 'Any'];
  String gValue = 'Non Stop';

  // Time slot model: label, time range, SVG asset
  final List<Map<String, String>> _timeSlots = [
    {'label': 'Tôt le matin', 'range': '(00:00 - 07:59)', 'asset': 'assets/matin_tot.svg'},
    {'label': 'Matin', 'range': '(08:00 - 15:59)', 'asset': 'assets/matin.svg'},
    {'label': 'Soir', 'range': '(16:00 - 23:59)', 'asset': 'assets/soir.svg'},
  ];

  // Selected time slots per airport per journey (Aller / Retour)
  // Aller: departure airport time slots, arrival airport time slots
  // Retour: departure airport time slots, arrival airport time slots
  Set<int> selectedAllerDepartureSlots = {};
  Set<int> selectedAllerArrivalSlots = {};
  Set<int> selectedRetourDepartureSlots = {};
  Set<int> selectedRetourArrivalSlots = {};

  int selectedHoraireTab = 0; // 0 = Aller, 1 = Retour

  TabController? tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  List<String> flightNameList = [
    'Indigo',
    'Spice jet',
    'Air Asia',
    'Arab Emirates',
  ];

  List<String> selectedFlightNameList = [];

  bool isOn = false;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 2,
      child: Scaffold(
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: kWhite,
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: ButtonGlobalWithoutIcon(
                      buttontext: lang.S.of(context).cancelButton,
                      buttonDecoration: kButtonDecoration.copyWith(
                        color: kWhite,
                        border: Border.all(color: Colors.red),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      buttonTextColor: Colors.red,
                    ),
                  ),
                  Expanded(
                    child: ButtonGlobalWithoutIcon(
                      buttontext: lang.S.of(context).applyButton,
                      buttonDecoration: kButtonDecoration.copyWith(
                        color: kPrimaryColor,
                      ),
                      onPressed: () {
                        finish(context);
                      },
                      buttonTextColor: kWhite,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        backgroundColor: kPrimaryColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: kPrimaryColor,
          centerTitle: true,
          title: Text(lang.S.of(context).filter),
          leading: SmallTapEffect(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              FeatherIcons.x,
              color: kWhite,
            ),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: const BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30.0),
              topLeft: Radius.circular(30.0),
            ),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 10.0),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  width: context.width(),
                  decoration: BoxDecoration(
                    color: kWhite,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: kBorderColorTextField),
                    boxShadow: const [
                      BoxShadow(
                        color: kBorderColorTextField,
                        blurRadius: 5.0,
                        spreadRadius: 1.0,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Stops',
                        style: kTextStyle.copyWith(
                            color: kTitleColor, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8.0),
                      HorizontalList(
                        itemCount: titleList.length,
                        padding: EdgeInsets.zero,
                        itemBuilder: (_, i) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Radio(
                                visualDensity: const VisualDensity(
                                  horizontal: VisualDensity.minimumDensity,
                                  vertical: VisualDensity.minimumDensity,
                                ),
                                value: titleList[i],
                                groupValue: gValue,
                                onChanged: (value) {
                                  setState(() {
                                    gValue = value.toString();
                                  });
                                },
                              ),
                              Text(
                                titleList[i],
                                style:
                                    kTextStyle.copyWith(color: kSubTitleColor),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                // Horaires section with Aller / Retour tabs
                Container(
                  decoration: BoxDecoration(
                    color: kWhite,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: kBorderColorTextField),
                    boxShadow: const [
                      BoxShadow(
                        color: kBorderColorTextField,
                        blurRadius: 5.0,
                        spreadRadius: 1.0,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Aller / Retour tabs
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => selectedHoraireTab = 0),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: selectedHoraireTab == 0
                                      ? const Color(0xFFEDF0FF)
                                      : Colors.transparent,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8.0),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Transform.rotate(
                                      angle: 45,
                                      child: Icon(
                                        Icons.flight,
                                        color: selectedHoraireTab == 0
                                            ? kPrimaryColor
                                            : kSubTitleColor,
                                        size: 18,
                                      ),
                                    ),
                                    const SizedBox(width: 5.0),
                                    Text(
                                      lang.S.of(context).departure,
                                      style: kTextStyle.copyWith(
                                        color: selectedHoraireTab == 0
                                            ? kPrimaryColor
                                            : kSubTitleColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => selectedHoraireTab = 1),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: selectedHoraireTab == 1
                                      ? const Color(0xFFEDF0FF)
                                      : Colors.transparent,
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(8.0),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Transform.rotate(
                                      angle: 90,
                                      child: Icon(
                                        Icons.flight,
                                        color: selectedHoraireTab == 1
                                            ? kPrimaryColor
                                            : kSubTitleColor,
                                        size: 18,
                                      ),
                                    ),
                                    const SizedBox(width: 5.0),
                                    Text(
                                      lang.S.of(context).arrival,
                                      style: kTextStyle.copyWith(
                                        color: selectedHoraireTab == 1
                                            ? kPrimaryColor
                                            : kSubTitleColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 2,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                color: selectedHoraireTab == 0
                                    ? kPrimaryColor
                                    : kBorderColorTextField,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: selectedHoraireTab == 1
                                    ? kPrimaryColor
                                    : kBorderColorTextField,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Content for selected tab
                      if (selectedHoraireTab == 0)
                        _buildHoraireContent(
                          key: const ValueKey('horaire_aller'),
                          departureAirportName: 'Houari Boumediene',
                          arrivalAirportName: 'Aéroport d\'arrivée',
                          selectedDepartureSlots: selectedAllerDepartureSlots,
                          selectedArrivalSlots: selectedAllerArrivalSlots,
                        ),
                      if (selectedHoraireTab == 1)
                        _buildHoraireContent(
                          key: const ValueKey('horaire_retour'),
                          departureAirportName: 'Aéroport d\'arrivée',
                          arrivalAirportName: 'Houari Boumediene',
                          selectedDepartureSlots: selectedRetourDepartureSlots,
                          selectedArrivalSlots: selectedRetourArrivalSlots,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                Container(
                  decoration: BoxDecoration(
                    color: kWhite,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: kBorderColorTextField),
                    boxShadow: const [
                      BoxShadow(
                        color: kBorderColorTextField,
                        blurRadius: 5.0,
                        spreadRadius: 1.0,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Aller / Retour tabs for price
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => selectedPriceTab = 0),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: selectedPriceTab == 0
                                      ? const Color(0xFFEDF0FF)
                                      : Colors.transparent,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8.0),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Transform.rotate(
                                      angle: 45,
                                      child: Icon(
                                        Icons.flight,
                                        color: selectedPriceTab == 0
                                            ? kPrimaryColor
                                            : kSubTitleColor,
                                        size: 18,
                                      ),
                                    ),
                                    const SizedBox(width: 5.0),
                                    Text(
                                      lang.S.of(context).departure,
                                      style: kTextStyle.copyWith(
                                        color: selectedPriceTab == 0
                                            ? kPrimaryColor
                                            : kSubTitleColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => selectedPriceTab = 1),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: selectedPriceTab == 1
                                      ? const Color(0xFFEDF0FF)
                                      : Colors.transparent,
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(8.0),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Transform.rotate(
                                      angle: 90,
                                      child: Icon(
                                        Icons.flight,
                                        color: selectedPriceTab == 1
                                            ? kPrimaryColor
                                            : kSubTitleColor,
                                        size: 18,
                                      ),
                                    ),
                                    const SizedBox(width: 5.0),
                                    Text(
                                      lang.S.of(context).arrival,
                                      style: kTextStyle.copyWith(
                                        color: selectedPriceTab == 1
                                            ? kPrimaryColor
                                            : kSubTitleColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 2,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                color: selectedPriceTab == 0
                                    ? kPrimaryColor
                                    : kBorderColorTextField,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: selectedPriceTab == 1
                                    ? kPrimaryColor
                                    : kBorderColorTextField,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Aller price slider
                      if (selectedPriceTab == 0)
                        Padding(
                          key: const ValueKey('price_aller'),
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Prix Aller',
                                style: kTextStyle.copyWith(
                                    color: kTitleColor, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Center(
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Jusqu\'à ',
                                    style: kTextStyle.copyWith(color: kSubTitleColor),
                                    children: [
                                      TextSpan(
                                        text: '${priceAller.toStringAsFixed(0)} $currencySign',
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Slider(
                                activeColor: kPrimaryColor,
                                inactiveColor: kPrimaryColor.withOpacity(0.1),
                                max: 1500000.00,
                                value: priceAller,
                                onChanged: (double newVal) {
                                  setState(() {
                                    priceAller = newVal > 0.00 && newVal < 1499999.00
                                        ? newVal
                                        : 10.00;
                                  });
                                },
                              ),
                              Row(
                                children: [
                                  Text(
                                    '${priceAller.toStringAsFixed(0)} $currencySign',
                                    style: kTextStyle.copyWith(color: kSubTitleColor),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '1 500 000 $currencySign',
                                    style: kTextStyle.copyWith(color: kSubTitleColor),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      // Retour price slider
                      if (selectedPriceTab == 1)
                        Padding(
                          key: const ValueKey('price_retour'),
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Prix Retour',
                                style: kTextStyle.copyWith(
                                    color: kTitleColor, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Center(
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Jusqu\'à ',
                                    style: kTextStyle.copyWith(color: kSubTitleColor),
                                    children: [
                                      TextSpan(
                                        text: '${priceRetour.toStringAsFixed(0)} $currencySign',
                                        style: kTextStyle.copyWith(color: kTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Slider(
                                activeColor: kPrimaryColor,
                                inactiveColor: kPrimaryColor.withOpacity(0.1),
                                max: 1500000.00,
                                value: priceRetour,
                                onChanged: (double newVal) {
                                  setState(() {
                                    priceRetour = newVal > 0.00 && newVal < 1499999.00
                                        ? newVal
                                        : 10.00;
                                  });
                                },
                              ),
                              Row(
                                children: [
                                  Text(
                                    '${priceRetour.toStringAsFixed(0)} $currencySign',
                                    style: kTextStyle.copyWith(color: kSubTitleColor),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '1 500 000 $currencySign',
                                    style: kTextStyle.copyWith(color: kSubTitleColor),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: kWhite,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: kBorderColorTextField),
                    boxShadow: const [
                      BoxShadow(
                        color: kBorderColorTextField,
                        blurRadius: 5.0,
                        spreadRadius: 1.0,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Airlines',
                        style: kTextStyle.copyWith(
                            color: kTitleColor, fontWeight: FontWeight.bold),
                      ),
                      ListTileTheme(
                        minLeadingWidth: 10,
                        child: ListTile(
                          onTap: () {
                            setState(() {
                              for (var element in flightNameList) {
                                selectedFlightNameList.contains(element)
                                    ? selectedFlightNameList.remove(element)
                                    : selectedFlightNameList.add(element);
                              }
                            });
                          },
                          dense: true,
                          horizontalTitleGap: 10,
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            'Select All',
                            style: kTextStyle.copyWith(color: kSubTitleColor),
                          ),
                          leading: Icon(
                            selectedFlightNameList.length ==
                                    flightNameList.length
                                ? Icons.check_box_rounded
                                : Icons.check_box_outline_blank_rounded,
                            color: selectedFlightNameList.length ==
                                    flightNameList.length
                                ? kPrimaryColor
                                : kSubTitleColor,
                          ),
                        ),
                      ),
                      ListTile(
                        dense: true,
                        horizontalTitleGap: 10,
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'Show Alliances',
                          style: kTextStyle.copyWith(
                              color: kTitleColor, fontWeight: FontWeight.bold),
                        ),
                        trailing: Switch(
                          activeColor: kPrimaryColor,
                          inactiveThumbColor: kSubTitleColor,
                          onChanged: (bool value) {
                            setState(() {
                              isOn = value;
                            });
                          },
                          value: isOn,
                        ),
                      ),
                      const Divider(
                        thickness: 1.0,
                        height: 1,
                        color: kBorderColorTextField,
                      ),
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: flightNameList.length,
                        itemBuilder: (_, i) {
                          return Column(
                            children: [
                              ListTileTheme(
                                minLeadingWidth: 10,
                                child: ListTile(
                                  onTap: () {
                                    setState(() {
                                      selectedFlightNameList.contains(
                                        flightNameList[i],
                                      )
                                          ? selectedFlightNameList
                                              .remove(flightNameList[i])
                                          : selectedFlightNameList
                                              .add(flightNameList[i]);
                                    });
                                  },
                                  dense: true,
                                  horizontalTitleGap: 10,
                                  contentPadding: EdgeInsets.zero,
                                  leading: Icon(
                                      selectedFlightNameList.contains(
                                        flightNameList[i],
                                      )
                                          ? Icons.check_box_rounded
                                          : Icons
                                              .check_box_outline_blank_rounded,
                                      color: selectedFlightNameList.contains(
                                        flightNameList[i],
                                      )
                                          ? kPrimaryColor
                                          : kSubTitleColor),
                                  title: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 20.0,
                                        width: 20.0,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'images/indigo.png'),
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                      const SizedBox(width: 10.0),
                                      Text(
                                        flightNameList[i],
                                        style: kTextStyle.copyWith(
                                            color: kTitleColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Divider(
                                thickness: 1.0,
                                height: 1,
                                color: kBorderColorTextField,
                              ),
                            ],
                          );
                        },
                      ).visible(isOn == true)
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHoraireContent({
    required Key key,
    required String departureAirportName,
    required String arrivalAirportName,
    required Set<int> selectedDepartureSlots,
    required Set<int> selectedArrivalSlots,
  }) {
    return Padding(
      key: key,
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Departure airport
          Text(
            departureAirportName,
            style: kTextStyle.copyWith(
              color: kTitleColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...List.generate(_timeSlots.length, (i) {
            final isSelected = selectedDepartureSlots.contains(i);
            return _buildTimeSlotCard(
              slot: _timeSlots[i],
              isSelected: isSelected,
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedDepartureSlots.remove(i);
                  } else {
                    selectedDepartureSlots.add(i);
                  }
                });
              },
            );
          }),
          const SizedBox(height: 16),
          // Arrival airport
          Text(
            arrivalAirportName,
            style: kTextStyle.copyWith(
              color: kTitleColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...List.generate(_timeSlots.length, (i) {
            final isSelected = selectedArrivalSlots.contains(i);
            return _buildTimeSlotCard(
              slot: _timeSlots[i],
              isSelected: isSelected,
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedArrivalSlots.remove(i);
                  } else {
                    selectedArrivalSlots.add(i);
                  }
                });
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTimeSlotCard({
    required Map<String, String> slot,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? kPrimaryColor.withOpacity(0.08) : kWhite,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? kPrimaryColor : kBorderColorTextField,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                slot['asset']!,
                width: 32,
                height: 32,
              ),
              const SizedBox(width: 16),
              Text(
                slot['label']!,
                style: kTextStyle.copyWith(
                  color: isSelected ? kPrimaryColor : kTitleColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                slot['range']!,
                style: kTextStyle.copyWith(
                  color: kSubTitleColor,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
