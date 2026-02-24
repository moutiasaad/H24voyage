import 'package:flight_booking/Model/Airport.dart';
import 'package:flight_booking/screen/widgets/SearchBottomSheet.dart';
import 'package:flight_booking/screen/widgets/CustomDatePicker.dart';
import 'package:flight_booking/screen/widgets/constant.dart';
import 'package:flight_booking/screen/widgets/button_global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:intl/intl.dart';
import '../../generated/l10n.dart' as lang;
import '../home/models/multi_destination_leg.dart';

class EditSearchBottomSheet extends StatefulWidget {
  final Airport fromAirport;
  final Airport toAirport;
  final int adultCount;
  final int childCount;
  final int infantCount;
  final DateTimeRange? dateRange;
  final bool isOneWay;
  final bool isMultiDestination;
  final List<MultiDestinationLeg>? multiDestinationLegs;

  const EditSearchBottomSheet({
    Key? key,
    required this.fromAirport,
    required this.toAirport,
    required this.adultCount,
    required this.childCount,
    required this.infantCount,
    this.dateRange,
    this.isOneWay = false,
    this.isMultiDestination = false,
    this.multiDestinationLegs,
  }) : super(key: key);

  @override
  State<EditSearchBottomSheet> createState() => _EditSearchBottomSheetState();
}

class _EditSearchBottomSheetState extends State<EditSearchBottomSheet> with SingleTickerProviderStateMixin {
  late Airport fromAirport;
  late Airport toAirport;
  late int adultCount;
  late int childCount;
  late int infantCount;
  DateTime? departureDate;
  DateTime? returnDate;
  bool isDirectFlight = false;
  bool withBaggage = false;
  String selectedClass = 'economy';

  // Multi-destination legs
  List<MultiDestinationLeg> multiDestinationLegs = [];

  // 0 = Aller-retour (round-trip), 1 = Aller simple (one-way), 2 = Multi-destinations
  late int selectedIndex;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    fromAirport = widget.fromAirport;
    toAirport = widget.toAirport;
    adultCount = widget.adultCount;
    childCount = widget.childCount;
    infantCount = widget.infantCount;
    departureDate = widget.dateRange?.start;
    returnDate = widget.isOneWay ? null : widget.dateRange?.end;

    // Determine initial tab
    if (widget.isMultiDestination) {
      selectedIndex = 2;
      // Copy multi-destination legs if provided
      if (widget.multiDestinationLegs != null) {
        multiDestinationLegs = widget.multiDestinationLegs!.map((leg) =>
          MultiDestinationLeg(
            fromAirport: leg.fromAirport,
            toAirport: leg.toAirport,
            departureDate: leg.departureDate,
          )
        ).toList();
      }
    } else if (widget.isOneWay) {
      selectedIndex = 1;
    } else {
      selectedIndex = 0;
    }

    _tabController = TabController(length: 3, vsync: this, initialIndex: selectedIndex);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          selectedIndex = _tabController.index;
          if (selectedIndex == 1) {
            returnDate = null;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _getClassDisplayName(String classCode) {
    final t = lang.S.of(context);
    switch (classCode) {
      case 'first':
        return t.homeClassFirstShort;
      case 'business':
        return t.homeClassBusinessShort;
      case 'premium':
        return t.homeClassPremiumEconomyShort;
      case 'economy':
      default:
        return t.homeClassEconomyShort;
    }
  }

  void _swapAirports() {
    setState(() {
      final temp = fromAirport;
      fromAirport = toAirport;
      toAirport = temp;
    });
  }

  Future<void> _selectFromAirport() async {
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
      setState(() {
        fromAirport = result;
      });
    }
  }

  Future<void> _selectToAirport() async {
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
      setState(() {
        toAirport = result;
      });
    }
  }

  Future<void> _showCustomDatePicker() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CustomDatePicker(
        initialStartDate: departureDate,
        initialEndDate: returnDate,
        isRoundTrip: selectedIndex == 0,
      ),
    );

    if (result != null) {
      setState(() {
        departureDate = result['departure'] as DateTime?;
        if (selectedIndex == 0) {
          returnDate = result['return'] as DateTime?;
        } else {
          returnDate = null;
        }
      });
    }
  }

  // Show date picker for a specific multi-destination leg
  Future<void> _showLegDatePicker(int legIndex) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CustomDatePicker(
        initialStartDate: multiDestinationLegs[legIndex].departureDate,
        initialEndDate: null,
        isRoundTrip: false,
      ),
    );

    if (result != null) {
      setState(() {
        multiDestinationLegs[legIndex].departureDate = result['departure'] as DateTime?;
      });
    }
  }

  void _showPassengerSelector() {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setStated) {
            final bottomNav = MediaQuery.of(context).viewPadding.bottom;
            return Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.75,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header (fixed)
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              lang.S.of(context).travellerTitle,
                              style: kTextStyle.copyWith(
                                color: kTitleColor,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            const Icon(
                              FeatherIcons.x,
                              size: 18.0,
                              color: kTitleColor,
                            ).onTap(() => finish(context)),
                          ],
                        ),
                        Text(
                          lang.S.of(context).editRouteInfo(fromAirport.city, toAirport.city),
                          style: kTextStyle.copyWith(color: kSubTitleColor),
                        ),
                      ],
                    ),
                  ),
                  // Scrollable content
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.all(20.0),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(30.0),
                            topLeft: Radius.circular(30.0),
                          ),
                          color: kWhite,
                          boxShadow: [
                            BoxShadow(
                              color: kDarkWhite,
                              spreadRadius: 5.0,
                              blurRadius: 7.0,
                              offset: Offset(0, -5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Adults
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(lang.S.of(context).adults,
                                        style: kTextStyle.copyWith(
                                            color: kTitleColor,
                                            fontWeight: FontWeight.bold)),
                                    Text(lang.S.of(context).homeAdultsAge,
                                        style: kTextStyle.copyWith(
                                            color: kSubTitleColor)),
                                  ],
                                ),
                                const Spacer(),
                                _counterButton(
                                  icon: FeatherIcons.minus,
                                  enabled: adultCount > 1,
                                  onTap: () {
                                    setStated(() {
                                      if (adultCount > 1) {
                                        setState(() => adultCount--);
                                      }
                                    });
                                  },
                                ),
                                const SizedBox(width: 10),
                                Text(adultCount.toString()),
                                const SizedBox(width: 10),
                                _counterButton(
                                  icon: FeatherIcons.plus,
                                  enabled: (adultCount + childCount + infantCount) < 9,
                                  onTap: () {
                                    setStated(() {
                                      if ((adultCount + childCount + infantCount) < 9) {
                                        setState(() => adultCount++);
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                            const Divider(thickness: 1.0, color: kBorderColorTextField),
                            const SizedBox(height: 15),

                            // Children
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(lang.S.of(context).child,
                                        style: kTextStyle.copyWith(
                                            color: kTitleColor,
                                            fontWeight: FontWeight.bold)),
                                    Text(lang.S.of(context).homeChildAge,
                                        style: kTextStyle.copyWith(
                                            color: kSubTitleColor)),
                                  ],
                                ),
                                const Spacer(),
                                _counterButton(
                                  icon: FeatherIcons.minus,
                                  enabled: childCount > 0,
                                  onTap: () {
                                    setStated(() {
                                      if (childCount > 0) {
                                        setState(() => childCount--);
                                      }
                                    });
                                  },
                                ),
                                const SizedBox(width: 10),
                                Text(childCount.toString()),
                                const SizedBox(width: 10),
                                _counterButton(
                                  icon: FeatherIcons.plus,
                                  enabled: (adultCount + childCount + infantCount) < 9,
                                  onTap: () {
                                    setStated(() {
                                      if ((adultCount + childCount + infantCount) < 9) {
                                        setState(() => childCount++);
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                            const Divider(thickness: 1.0, color: kBorderColorTextField),
                            const SizedBox(height: 15),

                            // Infants
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(lang.S.of(context).infants,
                                        style: kTextStyle.copyWith(
                                            color: kTitleColor,
                                            fontWeight: FontWeight.bold)),
                                    Text(lang.S.of(context).homeInfantAge,
                                        style: kTextStyle.copyWith(
                                            color: kSubTitleColor)),
                                  ],
                                ),
                                const Spacer(),
                                _counterButton(
                                  icon: FeatherIcons.minus,
                                  enabled: infantCount > 0,
                                  onTap: () {
                                    setStated(() {
                                      if (infantCount > 0) {
                                        setState(() => infantCount--);
                                      }
                                    });
                                  },
                                ),
                                const SizedBox(width: 10),
                                Text(infantCount.toString()),
                                const SizedBox(width: 10),
                                _counterButton(
                                  icon: FeatherIcons.plus,
                                  enabled: infantCount < adultCount && (adultCount + childCount + infantCount) < 9,
                                  onTap: () {
                                    setStated(() {
                                      if (infantCount < adultCount && (adultCount + childCount + infantCount) < 9) {
                                        setState(() => infantCount++);
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                            const Divider(thickness: 1.0, color: kBorderColorTextField),
                            const SizedBox(height: 15),

                            // Class selection
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(lang.S.of(context).homeClassLabel,
                                        style: kTextStyle.copyWith(
                                            color: kTitleColor,
                                            fontWeight: FontWeight.bold)),
                                    Text(lang.S.of(context).editSelectClass,
                                        style: kTextStyle.copyWith(
                                            color: kSubTitleColor)),
                                  ],
                                ),
                                const Spacer(),
                                DropdownButton<String>(
                                  value: selectedClass,
                                  underline: const SizedBox(),
                                  items: [
                                    DropdownMenuItem(value: 'economy', child: Text(lang.S.of(context).homeClassEconomyShort)),
                                    DropdownMenuItem(value: 'premium', child: Text(lang.S.of(context).homeClassPremiumEconomyShort)),
                                    DropdownMenuItem(value: 'business', child: Text(lang.S.of(context).homeClassBusinessShort)),
                                    DropdownMenuItem(value: 'first', child: Text(lang.S.of(context).homeClassFirstShort)),
                                  ],
                                  onChanged: (value) {
                                    if (value != null) {
                                      setStated(() {
                                        setState(() => selectedClass = value);
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Fixed Done Button at bottom
                  Container(
                    padding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, bottomNav > 0 ? bottomNav : 20.0),
                    decoration: const BoxDecoration(
                      color: kWhite,
                      boxShadow: [
                        BoxShadow(
                          color: kDarkWhite,
                          spreadRadius: 2.0,
                          blurRadius: 5.0,
                          offset: Offset(0, -2),
                        ),
                      ],
                    ),
                    child: ButtonGlobal(
                      buttontext: lang.S.of(context).homeDone,
                      buttonDecoration: kButtonDecoration.copyWith(
                        color: kPrimaryColor,
                      ),
                      onPressed: () {
                        finish(context);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _counterButton({
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: enabled ? kPrimaryColor : kBorderColorTextField,
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          size: 16,
          color: enabled ? kPrimaryColor : kBorderColorTextField,
        ),
      ),
    );
  }

  // Build widget for a multi-destination leg
  Widget _buildMultiDestinationLegWidget(MultiDestinationLeg leg, int index) {
    return Container(
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Column(
        children: [
          const SizedBox(height: 5.0),
          // From/To airports with swap button
          Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                children: [
                  // From airport
                  TappableCard(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(8.0),
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
                        setState(() {
                          multiDestinationLegs[index].fromAirport = result;
                        });
                      }
                    },
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
                                    : lang.S.of(context).editSelect,
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
                  const SizedBox(height: 12),
                  // To airport
                  TappableCard(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(8.0),
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
                        setState(() {
                          multiDestinationLegs[index].toAirport = result;
                        });
                      }
                    },
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
                                    : lang.S.of(context).editSelect,
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
              // Swap button
              Positioned(
                right: 12,
                top: 0,
                bottom: 0,
                child: Center(
                  child: SmallTapEffect(
                    onTap: () {
                      setState(() {
                        final temp = multiDestinationLegs[index].fromAirport;
                        multiDestinationLegs[index].fromAirport = multiDestinationLegs[index].toAirport;
                        multiDestinationLegs[index].toAirport = temp;
                      });
                    },
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
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.swap_vert,
                            color: kWhite,
                            size: 22,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5.0),
          // Date picker for this leg
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: InkWell(
              onTap: () => _showLegDatePicker(index),
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
                                : lang.S.of(context).editSelectDate,
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

  void _onSearch() {
    // Validation for round-trip and one-way
    if (selectedIndex != 2) {
      if (departureDate == null) {
        toast(lang.S.of(context).homeSelectDepartureDate);
        return;
      }

      if (selectedIndex == 0 && returnDate == null) {
        toast(lang.S.of(context).homeSelectReturnDate);
        return;
      }
    }

    // Validation for multi-destination
    if (selectedIndex == 2) {
      if (departureDate == null) {
        toast(lang.S.of(context).homeSelectDateFlight1);
        return;
      }

      for (int i = 0; i < multiDestinationLegs.length; i++) {
        final leg = multiDestinationLegs[i];
        if (leg.fromAirport == null || leg.toAirport == null) {
          toast(lang.S.of(context).homeSelectAirportsFlightN((i + 2).toString()));
          return;
        }
        if (leg.departureDate == null) {
          toast(lang.S.of(context).homeSelectDateFlightN((i + 2).toString()));
          return;
        }
      }
    }

    Navigator.pop(context, {
      'fromAirport': fromAirport,
      'toAirport': toAirport,
      'adultCount': adultCount,
      'childCount': childCount,
      'infantCount': infantCount,
      'departureDate': departureDate,
      'returnDate': returnDate,
      'isOneWay': selectedIndex == 1,
      'isMultiDestination': selectedIndex == 2,
      'multiDestinationLegs': multiDestinationLegs,
      'isDirectFlight': isDirectFlight,
      'withBaggage': withBaggage,
      'cabinClass': selectedClass,
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    final isSmallScreen = screenHeight < 700;

    // Use max available height, capped sensibly
    final double sheetMaxHeight = selectedIndex == 2
        ? screenHeight * 0.90
        : screenHeight * (isSmallScreen ? 0.85 : 0.75);

    return Container(
      constraints: BoxConstraints(maxHeight: sheetMaxHeight),
      decoration: const BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with drag handle
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 8),
            child: Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: kBorderColorTextField,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),

          // Title and close button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                Text(
                  lang.S.of(context).searchEditSearch,
                  style: kTextStyle.copyWith(
                    fontSize: isSmallScreen ? 16 : 18,
                    fontWeight: FontWeight.bold,
                    color: kTitleColor,
                  ),
                ),
                const Spacer(),
                SmallTapEffect(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(FeatherIcons.x, color: kTitleColor, size: 20),
                ),
              ],
            ),
          ),
          SizedBox(height: isSmallScreen ? 10 : 16),

          // Scrollable content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                bottom: 10.0,
              ),
              child: Column(
                children: [
                  // Tab bar for trip type
                  TabBar(
                    controller: _tabController,
                    labelColor: kTitleColor,
                    unselectedLabelColor: kSubTitleColor,
                    labelStyle: kTextStyle.copyWith(fontWeight: FontWeight.bold, fontSize: isSmallScreen ? 12 : 14),
                    unselectedLabelStyle: kTextStyle.copyWith(fontSize: isSmallScreen ? 12 : 14),
                    dividerColor: const Color(0xFFE2E2E2),
                    indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(
                        color: kPrimaryColor,
                        width: 4.0,
                      ),
                      borderRadius: BorderRadius.circular(3.0),
                      insets: const EdgeInsets.only(bottom: 8.0),
                    ),
                    onTap: (index) {
                      setState(() {
                        selectedIndex = index;
                        if (index == 1) {
                          returnDate = null;
                        }
                      });
                    },
                    tabs: [
                      Tab(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          alignment: Alignment.center,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              lang.S.of(context).tab2,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          alignment: Alignment.center,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              lang.S.of(context).tab1,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          alignment: Alignment.center,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              lang.S.of(context).tab3,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isSmallScreen ? 12.0 : 20.0),

                  // Content based on selected tab
                  if (selectedIndex != 2) ...[
                    // Round-trip or One-way content
                    _buildStandardTripContent(),
                  ] else ...[
                    // Multi-destination content
                    _buildMultiDestinationContent(),
                  ],
                ],
              ),
            ),
          ),

          // Fixed search button at bottom
          Container(
            padding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, bottomPadding > 0 ? bottomPadding : 12.0),
            child: ButtonGlobalWithoutIcon(
              buttontext: lang.S.of(context).homeSearchFlights,
              buttonDecoration: kButtonDecoration.copyWith(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(100.0),
              ),
              buttonTextColor: kWhite,
              onPressed: _onSearch,
            ),
          ),
        ],
      ),
    );
  }

  // Standard trip content (round-trip and one-way)
  Widget _buildStandardTripContent() {
    return Column(
      children: [
        // From/To airports with swap button
        Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              children: [
                // From airport
                TappableCard(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  onTap: _selectFromAirport,
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
                              lang.S.of(context).editAirportAll(fromAirport.city, fromAirport.code),
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
                const SizedBox(height: 12),
                // To airport
                TappableCard(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  onTap: _selectToAirport,
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
                              lang.S.of(context).editAirportSingle(toAirport.city, toAirport.code),
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
            // Swap button
            Positioned(
              right: 12,
              top: 0,
              bottom: 0,
              child: Center(
                child: SmallTapEffect(
                  onTap: _swapAirports,
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
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.swap_vert,
                          color: kWhite,
                          size: 22,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10.0),

        // Date fields
        Row(
          children: [
            Expanded(
              child: TappableCard(
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                onTap: _showCustomDatePicker,
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
                            departureDate != null
                                ? DateFormat('dd MMM yyyy', 'fr').format(departureDate!)
                                : lang.S.of(context).editSelect,
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
            if (selectedIndex == 0) ...[
              const SizedBox(width: 10.0),
              Expanded(
                child: TappableCard(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  onTap: _showCustomDatePicker,
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
                              lang.S.of(context).homeReturn,
                              style: kTextStyle.copyWith(
                                color: Colors.grey.shade600,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              returnDate != null
                                  ? DateFormat('dd MMM yyyy', 'fr').format(returnDate!)
                                  : lang.S.of(context).editSelect,
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
            ],
          ],
        ),
        const SizedBox(height: 10.0),

        // Passengers & Class
        _buildPassengerClassField(),
        const SizedBox(height: 15.0),

        // Direct flight & baggage toggles
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  SizedBox(
                    height: 24,
                    child: Switch(
                      value: isDirectFlight,
                      onChanged: (value) {
                        setState(() {
                          isDirectFlight = value;
                        });
                      },
                      activeColor: kPrimaryColor,
                      activeTrackColor: kPrimaryColor.withOpacity(0.3),
                      inactiveThumbColor: kWhite,
                      inactiveTrackColor: const Color(0xFFE0E0E0),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
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
                      onChanged: (value) {
                        setState(() {
                          withBaggage = value;
                        });
                      },
                      activeColor: kPrimaryColor,
                      activeTrackColor: kPrimaryColor.withOpacity(0.3),
                      inactiveThumbColor: kWhite,
                      inactiveTrackColor: const Color(0xFFE0E0E0),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
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
        ),
      ],
    );
  }

  // Multi-destination content
  Widget _buildMultiDestinationContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Vol 1 header
        Row(
          children: [
            Text(
              '${lang.S.of(context).flight} 1',
              style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 5.0),

        // Vol 1 - From/To airports
        Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              children: [
                // From airport
                TappableCard(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  onTap: _selectFromAirport,
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
                              '${fromAirport.city} (${fromAirport.code})',
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
                const SizedBox(height: 12),
                // To airport
                TappableCard(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  onTap: _selectToAirport,
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
                              '${toAirport.city} (${toAirport.code})',
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
            // Swap button
            Positioned(
              right: 12,
              top: 0,
              bottom: 0,
              child: Center(
                child: SmallTapEffect(
                  onTap: _swapAirports,
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
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.swap_vert,
                          color: kWhite,
                          size: 22,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5.0),

        // Vol 1 - Date picker
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: InkWell(
            onTap: _showCustomDatePicker,
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
                          departureDate != null
                              ? DateFormat('dd MMM yyyy', 'fr').format(departureDate!)
                              : lang.S.of(context).editSelectDate,
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

        // Multi-destination legs list
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: multiDestinationLegs.length,
          itemBuilder: (_, i) {
            final leg = multiDestinationLegs[i];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    Text(
                      '${lang.S.of(context).flight} ${i + 2}',
                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    GestureDetector(
                      child: const Icon(
                        FeatherIcons.x,
                        color: kSubTitleColor,
                      ),
                      onTap: () {
                        setState(() {
                          multiDestinationLegs.removeAt(i);
                        });
                      },
                    ),
                  ],
                ),
                _buildMultiDestinationLegWidget(leg, i),
              ],
            );
          },
        ),
        const SizedBox(height: 10.0),

        // Add flight button (max 4 flights total = 3 extra legs)
        if (multiDestinationLegs.length < 3)
          ButtonGlobalWithoutIcon(
            buttontext: lang.S.of(context).addFightButton,
            buttonDecoration: kButtonDecoration.copyWith(
              color: kWhite,
              border: Border.all(color: kPrimaryColor),
              borderRadius: BorderRadius.circular(30.0),
            ),
            onPressed: () {
              if (multiDestinationLegs.length >= 3) return;
              setState(() {
                Airport? newFromAirport;
                if (multiDestinationLegs.isNotEmpty) {
                  newFromAirport = multiDestinationLegs.last.toAirport;
                } else {
                  newFromAirport = toAirport;
                }
                multiDestinationLegs.add(MultiDestinationLeg(
                  fromAirport: newFromAirport,
                  toAirport: null,
                  departureDate: null,
                ));
              });
            },
            buttonTextColor: kPrimaryColor,
          ),
        const SizedBox(height: 10.0),

        // Passengers & Class
        _buildPassengerClassField(),
        const SizedBox(height: 15.0),

        // Direct flight & baggage toggles
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  SizedBox(
                    height: 24,
                    child: Switch(
                      value: isDirectFlight,
                      onChanged: (value) {
                        setState(() {
                          isDirectFlight = value;
                        });
                      },
                      activeColor: kPrimaryColor,
                      activeTrackColor: kPrimaryColor.withOpacity(0.3),
                      inactiveThumbColor: kWhite,
                      inactiveTrackColor: const Color(0xFFE0E0E0),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
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
                      onChanged: (value) {
                        setState(() {
                          withBaggage = value;
                        });
                      },
                      activeColor: kPrimaryColor,
                      activeTrackColor: kPrimaryColor.withOpacity(0.3),
                      inactiveThumbColor: kWhite,
                      inactiveTrackColor: const Color(0xFFE0E0E0),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
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
        ),
      ],
    );
  }

  // Passengers & Class field
  Widget _buildPassengerClassField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        onTap: _showPassengerSelector,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
          child: Row(
            children: [
              const Icon(
                Icons.person_outline,
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
                      lang.S.of(context).homePassengerClass,
                      style: kTextStyle.copyWith(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      lang.S.of(context).editPassengerSummary((adultCount + childCount + infantCount).toString(), _getClassDisplayName(selectedClass)),
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
    );
  }

  // Baggage toggle
  // Widget _buildBaggageToggle() {
  //   return Row(
  //     children: [
  //       SizedBox(
  //         height: 24,
  //         child: Switch(
  //           value: withBaggage,
  //           onChanged: (value) {
  //             setState(() {
  //               withBaggage = value;
  //             });
  //           },
  //           activeColor: kPrimaryColor,
  //           activeTrackColor: kPrimaryColor.withOpacity(0.3),
  //           inactiveThumbColor: kWhite,
  //           inactiveTrackColor: const Color(0xFFE0E0E0),
  //           materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  //           trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
  //         ),
  //       ),
  //       const SizedBox(width: 8),
  //       Text(
  //         'Avec bagages',
  //         style: kTextStyle.copyWith(
  //           color: kTitleColor,
  //           fontSize: 14,
  //           fontWeight: FontWeight.w500,
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
