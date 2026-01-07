import 'package:flight_booking/Model/Airport.dart';
import 'package:flight_booking/screen/widgets/SearchBottomSheet.dart';
import 'package:flight_booking/screen/widgets/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flight_booking/generated/l10n.dart' as lang;
import 'package:intl/intl.dart';

import '../search/search.dart';
import '../search/search_result.dart';
import '../widgets/button_global.dart';
import '../widgets/CustomDatePicker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  TabController? tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this, initialIndex: 1);

    // ✅ Default airports (Dzyar 🇩🇿 -> Tunisia/France 🇹🇳🇫🇷)
    fromAirport = airports.firstWhere((a) => a.code == "ALG"); // Algiers
    toAirport   = airports.firstWhere((a) => a.code == "TUN"); // Tunis
    // or: CDG for Paris
    // toAirport = airports.firstWhere((a) => a.code == "CDG");
  }

  List<Widget> flights = [];
  Airport? fromAirport;
  Airport? toAirport;

  int adultCount = 1;
  int childCount = 0;
  int infantCount = 0;
  int flightNumber = 0;
  bool showCounter = false;
  int selectedIndex = 1; // Default to Aller-retour (Round-trip) at index 1

  List<String> classKeys = ['economy', 'business'];
  String selectedClass = 'economy';
  // String selectedClass = 'Economy';

  DateTime? departureDate;
  DateTime? returnDate;
  bool isFlexibleDates = false;
  DateTimeRange? _selectedDateRange;

  DateTime selectedDate = DateTime.now();

  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: selectedDate,
  //     lastDate: DateTime(2101),
  //   );
  //   if (picked != null && picked != selectedDate) {
  //     setState(() {
  //       selectedDate = picked;
  //       departureDateTitle = selectedDate.toString().substring(0, 10);
  //     });
  //   }
  // }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final locale = Localizations.localeOf(context).languageCode;
    return DateFormat('dd MMM', locale).format(date);
  }

  void _showCustomDatePicker() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CustomDatePicker(
        initialStartDate: departureDate,
        initialEndDate: returnDate,
        isRoundTrip: selectedIndex == 1,
      ),
    );

    if (result != null) {
      setState(() {
        departureDate = result['departure'] as DateTime?;
        returnDate = result['return'] as DateTime?;
        isFlexibleDates = result['flexible'] as bool? ?? false;

        // Update the DateTimeRange for compatibility with SearchResult
        if (departureDate != null && returnDate != null) {
          _selectedDateRange = DateTimeRange(
            start: departureDate!,
            end: returnDate!,
          );
        }
      });
    }
  }

  // void _showReturnDate() async {
  //   final DateTimeRange? result = await showDateRangePicker(
  //     context: context,
  //     firstDate: selectedDate,
  //     lastDate: DateTime(2030, 12, 31),
  //     currentDate: DateTime.now(),
  //     saveText: 'Done',
  //   );
  //   if (result != null && result != _selectedDateRange) {
  //     setState(
  //       () {
  //         _selectedDateRange = result;
  //         returnDateTitle = _selectedDateRange.toString().substring(26, 36);
  //       },
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        initialIndex: 1,
        length: 3,
        child: Scaffold(
          backgroundColor: kDarkWhite,
          body: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Column(
                children: [
          Stack(
          alignment: Alignment.topLeft,
            children: [
              Container(
                height: 260,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F4F6), // website-like grey background
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🖼 Logo
                    SizedBox(
                      height: 44,
                      child: Image.asset(
                        'assets/logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // 📝 Styled title with underline + orange dot
                    Builder(
                      builder: (context) {
                        final locale = Localizations.localeOf(context).languageCode;

                        if (locale == 'fr') {
                          return RichText(
                            text: TextSpan(
                              style: kTextStyle.copyWith(
                                color: kDarkBackground,
                                fontWeight: FontWeight.bold,
                                fontSize: 28.0,
                              ),
                              children: const [
                                TextSpan(text: 'Réservez votre vol  '),
                                TextSpan(
                                  text: '\nen toute',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    decorationThickness: 3,
                                  ),
                                ),
                                TextSpan(text: ' confiance'),
                                TextSpan(
                                  text: '.',
                                  style: TextStyle(
                                    color: Colors.deepOrange,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return RichText(
                            text: TextSpan(
                              style: kTextStyle.copyWith(
                                color: kDarkBackground,
                                fontWeight: FontWeight.bold,
                                fontSize: 28.0,
                              ),
                              children: const [
                                TextSpan(text: 'Book your flight '),
                                TextSpan(
                                  text: 'with',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    decorationThickness: 3,
                                  ),
                                ),
                                TextSpan(text: ' confidence'),
                                TextSpan(
                                  text: '.',
                                  style: TextStyle(color: Colors.deepOrange),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          )

          ],
              ),
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 200, left: 15.0, right: 15),
                      child: Material(
                        borderRadius: BorderRadius.circular(30.0),
                        elevation: 2,
                        shadowColor: kDarkWhite,
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: kWhite,
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.0),
                                  color: const Color(0xFFEDF0FF),
                                ),
                                child: TabBar(
                                  controller: tabController,
                                  labelStyle: kTextStyle.copyWith(color: Colors.white),
                                  unselectedLabelColor: kSubTitleColor,
                                  indicatorColor: kPrimaryColor,
                                  labelColor: Colors.white,
                                  indicatorSize: TabBarIndicatorSize.tab, // or .label
                                  indicatorPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                  indicator: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: kPrimaryColor,
                                  ),
                                  onTap: (index) {
                                    setState(() {
                                      selectedIndex = index;
                                    });
                                  },
                                  tabs: [
                                    Tab(
                                      text: lang.S.of(context).tab1,
                                    ),
                                    Tab(
                                      text: lang.S.of(context).tab2,
                                    ),
                                    Tab(
                                      text: lang.S.of(context).tab3,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              Column(
                                children: [
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                  Column(
                                    children: [
                                      InputDecorator(
                                        decoration: kInputDecoration.copyWith(
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                                          labelText: lang.S.of(context).fromTitle,
                                          floatingLabelBehavior: FloatingLabelBehavior.always,
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
                                              builder: (_) => const SearchBottomSheet(),
                                            );

                                            if (result != null) {
                                              setState(() {
                                                fromAirport = result;
                                              });
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.flight_takeoff,
                                                  color: kSubTitleColor,
                                                  size: 24,
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        fromAirport != null ? '(${fromAirport!.code})' : '(ALG)',
                                                        style: kTextStyle.copyWith(
                                                          color: kTitleColor,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Text(
                                                        fromAirport != null
                                                            ? fromAirport!.city
                                                            : 'Algerie , Algerie ',
                                                        style: kTextStyle.copyWith(
                                                          color: kSubTitleColor,
                                                          fontSize: 12,
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
                                      const SizedBox(height: 12), // Space between the two inputs
                                      InputDecorator(
                                        decoration: kInputDecoration.copyWith(
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                                          labelText: lang.S.of(context).toTitle,
                                          floatingLabelBehavior: FloatingLabelBehavior.always,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
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
                                              builder: (_) => const SearchBottomSheet(),
                                            );

                                            if (result != null) {
                                              setState(() {
                                                toAirport = result;
                                              });
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.flight_land,
                                                  color: kSubTitleColor,
                                                  size: 24,
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        toAirport != null ? '(${toAirport!.code})' : '(NYC)',
                                                        style: kTextStyle.copyWith(
                                                          color: kTitleColor,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Text(
                                                        toAirport != null
                                                            ? toAirport!.city
                                                            : 'New York, United States',
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: kTextStyle.copyWith(
                                                          color: kSubTitleColor,
                                                          fontSize: 12,
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
                                  // Positioned swap button - overlapping both inputs
                                  Positioned(
                                    right: 12,
                                    top: 0,
                                    bottom: 0,
                                    child: Center(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            // Swap the airports
                                            final temp = fromAirport;
                                            fromAirport = toAirport;
                                            toAirport = temp;
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: kPrimaryColor,
                                          ),
                                          child: const Icon(
                                            Icons.swap_vert,
                                            color: kWhite,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10.0),
                              // For Aller-retour: Show both dates side by side
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      readOnly: true,
                                      keyboardType: TextInputType.name,
                                      cursorColor: kTitleColor,
                                      showCursor: false,
                                      textInputAction: TextInputAction.next,
                                      onTap: () {
                                        _showCustomDatePicker();
                                      },
                                      controller: TextEditingController(
                                        text: _formatDate(departureDate),
                                      ),
                                      decoration: kInputDecoration.copyWith(
                                        labelText: lang.S.of(context).departDate,
                                        labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                        hintText: lang.S.of(context).departDateTitle,
                                        hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                                        focusColor: kTitleColor,
                                        border: const OutlineInputBorder(),
                                        floatingLabelBehavior: FloatingLabelBehavior.always,
                                        prefixIcon: const Icon(
                                          IconlyLight.calendar,
                                          color: kSubTitleColor,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10.0).visible(selectedIndex == 1),
                                  Expanded(
                                    child: TextFormField(
                                      readOnly: true,
                                      keyboardType: TextInputType.name,
                                      cursorColor: kTitleColor,
                                      showCursor: false,
                                      textInputAction: TextInputAction.next,
                                      onTap: () {
                                        _showCustomDatePicker();
                                      },
                                      controller: TextEditingController(
                                        text: _formatDate(returnDate),
                                      ),
                                      decoration: kInputDecoration.copyWith(
                                        labelText: lang.S.of(context).returnDate,
                                        labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                        hintText: lang.S.of(context).returnDateTitle,
                                        hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                                        focusColor: kTitleColor,
                                        border: const OutlineInputBorder(),
                                        floatingLabelBehavior: FloatingLabelBehavior.always,
                                        prefixIcon: const Icon(
                                          IconlyLight.calendar,
                                          color: kSubTitleColor,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                  ).visible(selectedIndex == 1),
                                ],
                              ),
                              const SizedBox(height: 10.0),
                        TextFormField(
                          readOnly: true,
                          keyboardType: TextInputType.name,
                          cursorColor: kTitleColor,
                          showCursor: false,
                          textInputAction: TextInputAction.next,

                          // ✅ Open bottom sheet when tapping anywhere
                          onTap: () {
                            showModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                  builder: (BuildContext context, setStated) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
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
                                                'Algerie  a Tunisie, Jeu. 6 janv. 2023',
                                                style: kTextStyle.copyWith(color: kSubTitleColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
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
                                              // 👨 Adults
                                              Row(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(lang.S.of(context).adults,
                                                          style: kTextStyle.copyWith(
                                                              color: kTitleColor,
                                                              fontWeight: FontWeight.bold)),
                                                      Text('12 ans et plus',
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
                                                        if (adultCount > 1) adultCount--;
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(adultCount.toString()),
                                                  const SizedBox(width: 10),
                                                  _counterButton(
                                                    icon: FeatherIcons.plus,
                                                    onTap: () {
                                                      setStated(() {
                                                        adultCount++;
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                              const Divider(thickness: 1.0, color: kBorderColorTextField),
                                              const SizedBox(height: 15),

                                              // 👶 Child
                                              Row(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(lang.S.of(context).child,
                                                          style: kTextStyle.copyWith(
                                                              color: kTitleColor,
                                                              fontWeight: FontWeight.bold)),
                                                      Text('2-12 ans',
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
                                                        if (childCount > 0) childCount--;
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(childCount.toString()),
                                                  const SizedBox(width: 10),
                                                  _counterButton(
                                                    icon: FeatherIcons.plus,
                                                    onTap: () {
                                                      setStated(() {
                                                        childCount++;
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                              const Divider(thickness: 1.0, color: kBorderColorTextField),
                                              const SizedBox(height: 15),

                                              // 🍼 Infants
                                              Row(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(lang.S.of(context).infants,
                                                          style: kTextStyle.copyWith(
                                                              color: kTitleColor,
                                                              fontWeight: FontWeight.bold)),
                                                      Text('Moins de 2 ans',
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
                                                        if (infantCount > 0) infantCount--;
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(infantCount.toString()),
                                                  const SizedBox(width: 10),
                                                  _counterButton(
                                                    icon: FeatherIcons.plus,
                                                    onTap: () {
                                                      setStated(() {
                                                        infantCount++;
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                              const Divider(thickness: 1.0, color: kBorderColorTextField),
                                              const SizedBox(height: 20),

                                              // ✅ Done Button
                                              ButtonGlobal(
                                                buttontext: lang.S.of(context).done,
                                                buttonDecoration: kButtonDecoration.copyWith(
                                                  color: kPrimaryColor,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    finish(context);
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          },

                          decoration: kInputDecoration.copyWith(
                            labelText: lang.S.of(context).travellerTitle,
                            labelStyle: kTextStyle.copyWith(color: kTitleColor),
                            hintText:
                            '$adultCount Adulte, $childCount enfant, $infantCount nourrissons',
                            hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                            border: const OutlineInputBorder(),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            suffixIcon: const Icon(
                              IconlyLight.arrowDown2,
                              color: kSubTitleColor,
                            ),
                          ),
                        ),

                                  const SizedBox(height: 20.0),
                                  TextFormField(
                                    readOnly: true,
                                    keyboardType: TextInputType.name,
                                    cursorColor: kTitleColor,
                                    showCursor: false,
                                    textInputAction: TextInputAction.next,
                                    onTap: () {
                                      showModalBottomSheet(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30.0),
                                        ),
                                        context: context,
                                        builder: (BuildContext context) {
                                          return StatefulBuilder(
                                            builder: (BuildContext context, setModalState) {
                                              final t = lang.S.of(context);
                                              return Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(20.0),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              t.classTitle,
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
                                                          '${fromAirport?.city ?? 'Algerie'} a ${toAirport?.city ?? 'Tunisie'}, ${_formatDate(departureDate)}',
                                                          style: kTextStyle.copyWith(color: kSubTitleColor),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
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
                                                        ListTile(
                                                          contentPadding: EdgeInsets.zero,
                                                          title: Text(
                                                            t.classEconomy,
                                                            style: kTextStyle.copyWith(
                                                              color: kTitleColor,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                          trailing: selectedClass == 'economy'
                                                              ? const Icon(Icons.check_circle, color: kPrimaryColor)
                                                              : const Icon(Icons.radio_button_unchecked, color: kSubTitleColor),
                                                          onTap: () {
                                                            setState(() {
                                                              selectedClass = 'economy';
                                                            });
                                                            Navigator.pop(context);
                                                          },
                                                        ),
                                                        const Divider(
                                                          thickness: 1.0,
                                                          color: kBorderColorTextField,
                                                        ),
                                                        ListTile(
                                                          contentPadding: EdgeInsets.zero,
                                                          title: Text(
                                                            t.classBusiness,
                                                            style: kTextStyle.copyWith(
                                                              color: kTitleColor,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                          trailing: selectedClass == 'business'
                                                              ? const Icon(Icons.check_circle, color: kPrimaryColor)
                                                              : const Icon(Icons.radio_button_unchecked, color: kSubTitleColor),
                                                          onTap: () {
                                                            setState(() {
                                                              selectedClass = 'business';
                                                            });
                                                            Navigator.pop(context);
                                                          },
                                                        ),
                                                        const Divider(
                                                          thickness: 1.0,
                                                          color: kBorderColorTextField,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      );
                                    },
                                    decoration: kInputDecoration.copyWith(
                                      labelText: lang.S.of(context).classTitle,
                                      labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                      hintText: selectedClass == 'economy'
                                          ? lang.S.of(context).classEconomy
                                          : lang.S.of(context).classBusiness,
                                      hintStyle: kTextStyle.copyWith(color: kTitleColor),
                                      border: const OutlineInputBorder(),
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                      suffixIcon: const Icon(
                                        IconlyLight.arrowDown2,
                                        color: kSubTitleColor,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10.0),
                                  ButtonGlobalWithoutIcon(
                                    buttontext: lang.S.of(context).searchFlight,
                                    buttonDecoration: kButtonDecoration.copyWith(
                                      color: kPrimaryColor,
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    onPressed: () {
                                      if (fromAirport == null || toAirport == null) {
                                        toast('Veuillez sélectionner les aéroports de départ et d''arrivée.');
                                        return;
                                      }

                                      SearchResult(
                                        fromAirport: fromAirport!,
                                        toAirport: toAirport!,
                                        adultCount: adultCount,
                                        childCount: childCount,
                                        infantCount: infantCount,
                                        dateRange: _selectedDateRange,
                                      ).launch(context);
                                    },

                                    buttonTextColor: kWhite,
                                  )
                                ],
                              ).visible(selectedIndex != 2),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(color: Colors.transparent),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              '${lang.S.of(context).flight} ${flightNumber + 1}',
                                              style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                            ),
                                            const Spacer(),
                                            const Icon(
                                              FeatherIcons.x,
                                              color: kSubTitleColor,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10.0),
                                        Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            Column(
                                              children: [
                                                InputDecorator(
                                                  decoration: kInputDecoration.copyWith(
                                                    contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                                                    labelText: lang.S.of(context).fromTitle,
                                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(8.0),
                                                    ),
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
                                                        builder: (_) => const SearchBottomSheet(),
                                                      );

                                                      if (result != null) {
                                                        setState(() {
                                                          fromAirport = result;
                                                        });
                                                      }
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                                                      child: Row(
                                                        children: [
                                                          const Icon(
                                                            Icons.flight_takeoff,
                                                            color: kSubTitleColor,
                                                            size: 24,
                                                          ),
                                                          const SizedBox(width: 12),
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                Text(
                                                                  fromAirport != null ? '(${fromAirport!.code})' : '(ALG)',
                                                                  style: kTextStyle.copyWith(
                                                                    color: kTitleColor,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 14,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  fromAirport != null ? fromAirport!.city : 'Algerie , Tunisie',
                                                                  style: kTextStyle.copyWith(
                                                                    color: kSubTitleColor,
                                                                    fontSize: 12,
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
                                                InputDecorator(
                                                  decoration: kInputDecoration.copyWith(
                                                    contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                                                    labelText: lang.S.of(context).toTitle,
                                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(8.0),
                                                    ),
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
                                                        builder: (_) => const SearchBottomSheet(),
                                                      );

                                                      if (result != null) {
                                                        setState(() {
                                                          toAirport = result;
                                                        });
                                                      }
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                                                      child: Row(
                                                        children: [
                                                          const Icon(
                                                            Icons.flight_land,
                                                            color: kSubTitleColor,
                                                            size: 24,
                                                          ),
                                                          const SizedBox(width: 12),
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                Text(
                                                                  toAirport != null ? '(${toAirport!.code})' : '(TUN)',
                                                                  style: kTextStyle.copyWith(
                                                                    color: kTitleColor,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 14,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  toAirport != null
                                                                      ? toAirport!.city
                                                                      : 'Tunisie, Tunisie',
                                                                  maxLines: 1,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: kTextStyle.copyWith(
                                                                    color: kSubTitleColor,
                                                                    fontSize: 12,
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
                                                  onTap: () {
                                                    setState(() {
                                                      final temp = fromAirport;
                                                      fromAirport = toAirport;
                                                      toAirport = temp;
                                                    });
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets.all(8.0),
                                                    decoration: const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: kPrimaryColor,
                                                    ),
                                                    child: const Icon(
                                                      Icons.swap_vert,
                                                      color: kWhite,
                                                      size: 18,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10.0),
                                        TextFormField(
                                          readOnly: true,
                                          keyboardType: TextInputType.name,
                                          cursorColor: kTitleColor,
                                          showCursor: false,
                                          textInputAction: TextInputAction.next,
                                          onTap: () {
                                            _showCustomDatePicker();
                                          },
                                          controller: TextEditingController(
                                            text: _formatDate(departureDate),
                                          ),
                                          decoration: kInputDecoration.copyWith(
                                            labelText: lang.S.of(context).dateTitle,
                                            labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                            hintText: lang.S.of(context).departDateTitle,
                                            hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                                            focusColor: kTitleColor,
                                            border: const OutlineInputBorder(),
                                            floatingLabelBehavior: FloatingLabelBehavior.always,
                                            prefixIcon: const Icon(
                                              IconlyLight.calendar,
                                              color: kSubTitleColor,
                                              size: 24,
                                            ),
                                          ),
                                        ),
                                        const Divider(
                                          thickness: 1.0,
                                          color: kBorderColorTextField,
                                        ),
                                      ],
                                    ),
                                  ),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: flights.length,
                                      itemBuilder: (_, i) {
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
                                                            child: const Icon(
                                                              FeatherIcons.x,
                                                              color: kSubTitleColor,
                                                            ),
                                                            onTap: () {
                                                              setState(() {
                                                                flights.remove(flights[i]);
                                                              });
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                      flights[i],
                                                    ],
                                        );
                                      }),
                                  ButtonGlobalWithoutIcon(
                                    buttontext: lang.S.of(context).addFightButton,
                                    buttonDecoration: kButtonDecoration.copyWith(
                                      color: kWhite,
                                      border: Border.all(color: kPrimaryColor),
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        flights.add(Container(
                                          decoration: const BoxDecoration(color: Colors.transparent),
                                          child: Column(
                                            children: [
                                              const SizedBox(height: 10.0),
                                              Stack(
                                                clipBehavior: Clip.none,
                                                children: [
                                                  Column(
                                                    children: [
                                                      InputDecorator(
                                                        decoration: kInputDecoration.copyWith(
                                                          contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                                                          labelText: lang.S.of(context).fromTitle,
                                                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                          floatingLabelBehavior: FloatingLabelBehavior.always,
                                                          border: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(8.0),
                                                          ),
                                                        ),
                                                        child: InkWell(
                                                          onTap: ()=>const Search().launch(context),
                                                          child: Padding(
                                                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                                                            child: Row(
                                                              children: [
                                                                const Icon(
                                                                  Icons.flight_takeoff,
                                                                  color: kSubTitleColor,
                                                                  size: 24,
                                                                ),
                                                                const SizedBox(width: 12),
                                                                Expanded(
                                                                  child: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    children: [
                                                                      Text(
                                                                        fromAirport != null ? '(${fromAirport!.code})' : '(ALG)',
                                                                        style: kTextStyle.copyWith(
                                                                          color: kTitleColor,
                                                                          fontWeight: FontWeight.bold,
                                                                          fontSize: 14,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        fromAirport != null
                                                                            ? fromAirport!.city
                                                                            : 'Algerie , Algerie ',
                                                                        style: kTextStyle.copyWith(
                                                                          color: kSubTitleColor,
                                                                          fontSize: 12,
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
                                                      InputDecorator(
                                                        decoration: kInputDecoration.copyWith(
                                                          contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                                                          labelText: lang.S.of(context).toTitle,
                                                          labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                          floatingLabelBehavior: FloatingLabelBehavior.always,
                                                          border: OutlineInputBorder(
                                                            borderRadius: BorderRadius.circular(8.0),
                                                          ),
                                                        ),
                                                        child: InkWell(
                                                          onTap: ()=>const Search().launch(context),
                                                          child: Padding(
                                                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                                                            child: Row(
                                                              children: [
                                                                const Icon(
                                                                  Icons.flight_land,
                                                                  color: kSubTitleColor,
                                                                  size: 24,
                                                                ),
                                                                const SizedBox(width: 12),
                                                                Expanded(
                                                                  child: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    children: [
                                                                      Text(
                                                                        toAirport != null ? '(${toAirport!.code})' : '(TUN)',
                                                                        style: kTextStyle.copyWith(
                                                                          color: kTitleColor,
                                                                          fontWeight: FontWeight.bold,
                                                                          fontSize: 14,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        toAirport != null
                                                                            ? toAirport!.city
                                                                            : 'Tunisie, Tunisie',
                                                                        maxLines: 1,
                                                                        overflow: TextOverflow.ellipsis,
                                                                        style: kTextStyle.copyWith(
                                                                          color: kSubTitleColor,
                                                                          fontSize: 12,
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
                                                        onTap: () {
                                                          setState(() {
                                                            final temp = fromAirport;
                                                            fromAirport = toAirport;
                                                            toAirport = temp;
                                                          });
                                                        },
                                                        child: Container(
                                                          padding: const EdgeInsets.all(8.0),
                                                          decoration: const BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color: kPrimaryColor,
                                                          ),
                                                          child: const Icon(
                                                            Icons.swap_vert,
                                                            color: kWhite,
                                                            size: 18,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              TextFormField(
                                                readOnly: true,
                                                keyboardType: TextInputType.name,
                                                cursorColor: kTitleColor,
                                                showCursor: false,
                                                textInputAction: TextInputAction.next,
                                                onTap: () {
                                                  _showCustomDatePicker();
                                                },
                                                controller: TextEditingController(
                                                  text: _formatDate(departureDate),
                                                ),
                                                decoration: kInputDecoration.copyWith(
                                                  labelText: lang.S.of(context).dateTitle,
                                                  labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                                  hintText: lang.S.of(context).departDateTitle,
                                                  hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                                                  focusColor: kTitleColor,
                                                  border: const OutlineInputBorder(),
                                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                                  prefixIcon: const Icon(
                                                    IconlyLight.calendar,
                                                    color: kSubTitleColor,
                                                    size: 24,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 10.0),
                                              const Divider(
                                                thickness: 1.0,
                                                color: kBorderColorTextField,
                                              ),
                                            ],
                                          ),
                                        ));
                                      });
                                    },
                                    buttonTextColor: kPrimaryColor,
                                  ),
                                  const SizedBox(height: 20.0),
                                  TextFormField(
            readOnly: true,
            keyboardType: TextInputType.name,
            cursorColor: kTitleColor,
            showCursor: false,
            textInputAction: TextInputAction.next,

            // ✅ NEW: tap anywhere opens the bottom sheet
            onTap: () => showModalBottomSheet(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(builder: (BuildContext context, setStated) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                              'Algerie a Tunisie, Jeu. 6 janv. 2023',
                              style: kTextStyle.copyWith(color: kSubTitleColor),
                            ),
                          ],
                        ),
                      ),
                      Container(
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
                            /// Adults
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      lang.S.of(context).adults,
                                      style: kTextStyle.copyWith(
                                          color: kTitleColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '12 ans et plus',
                                      style:
                                      kTextStyle.copyWith(color: kSubTitleColor),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: adultCount == 1
                                        ? kPrimaryColor.withOpacity(0.2)
                                        : kPrimaryColor,
                                  ),
                                  child: const Icon(
                                    FeatherIcons.minus,
                                    color: Colors.white,
                                    size: 14.0,
                                  ).onTap(() {
                                    setStated(() {
                                      adultCount > 1
                                          ? adultCount--
                                          : adultCount = 1;
                                    });
                                  }),
                                ),
                                const SizedBox(width: 10.0),
                                Text(adultCount.toString()),
                                const SizedBox(width: 10.0),
                                Container(
                                  padding: const EdgeInsets.all(5.0),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: kPrimaryColor,
                                  ),
                                  child: const Icon(
                                    FeatherIcons.plus,
                                    color: Colors.white,
                                    size: 14.0,
                                  ).onTap(() {
                                    setStated(() {
                                      adultCount++;
                                    });
                                  }),
                                ),
                              ],
                            ),

                            const Divider(color: kBorderColorTextField),
                            const SizedBox(height: 15.0),

                            /// Children
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      lang.S.of(context).child,
                                      style: kTextStyle.copyWith(
                                          color: kTitleColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '2-12 ans',
                                      style:
                                      kTextStyle.copyWith(color: kSubTitleColor),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: childCount == 0
                                        ? kPrimaryColor.withOpacity(0.2)
                                        : kPrimaryColor,
                                  ),
                                  child: const Icon(
                                    FeatherIcons.minus,
                                    color: Colors.white,
                                    size: 14.0,
                                  ).onTap(() {
                                    setStated(() {
                                      childCount > 0
                                          ? childCount--
                                          : childCount = 0;
                                    });
                                  }),
                                ),
                                const SizedBox(width: 10.0),
                                Text(childCount.toString()),
                                const SizedBox(width: 10.0),
                                Container(
                                  padding: const EdgeInsets.all(5.0),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: kPrimaryColor,
                                  ),
                                  child: const Icon(
                                    FeatherIcons.plus,
                                    color: Colors.white,
                                    size: 14.0,
                                  ).onTap(() {
                                    setStated(() {
                                      childCount++;
                                    });
                                  }),
                                ),
                              ],
                            ),

                            const Divider(color: kBorderColorTextField),
                            const SizedBox(height: 15.0),

                            /// Infants
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      lang.S.of(context).infants,
                                      style: kTextStyle.copyWith(
                                          color: kTitleColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Moins de 2 ans',
                                      style:
                                      kTextStyle.copyWith(color: kSubTitleColor),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: infantCount == 0
                                        ? kPrimaryColor.withOpacity(0.2)
                                        : kPrimaryColor,
                                  ),
                                  child: const Icon(
                                    FeatherIcons.minus,
                                    color: Colors.white,
                                    size: 14.0,
                                  ).onTap(() {
                                    setStated(() {
                                      infantCount > 0
                                          ? infantCount--
                                          : infantCount = 0;
                                    });
                                  }),
                                ),
                                const SizedBox(width: 10.0),
                                Text(infantCount.toString()),
                                const SizedBox(width: 10.0),
                                Container(
                                  padding: const EdgeInsets.all(5.0),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: kPrimaryColor,
                                  ),
                                  child: const Icon(
                                    FeatherIcons.plus,
                                    color: Colors.white,
                                    size: 14.0,
                                  ).onTap(() {
                                    setStated(() {
                                      infantCount++;
                                    });
                                  }),
                                ),
                              ],
                            ),

                            const Divider(color: kBorderColorTextField),
                            const SizedBox(height: 20.0),

                            ButtonGlobal(
                              buttontext: lang.S.of(context).done,
                              buttonDecoration:
                              kButtonDecoration.copyWith(color: kPrimaryColor),
                              onPressed: () {
                                setState(() {
                                  finish(context);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                });
              },
            ),

            decoration: kInputDecoration.copyWith(
              labelText: lang.S.of(context).travellerTitle,
              labelStyle: kTextStyle.copyWith(color: kTitleColor),
              hintText:
              '$adultCount Adult,$childCount enfant,$infantCount nourrissons',
              hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
              border: const OutlineInputBorder(),
              floatingLabelBehavior: FloatingLabelBehavior.always,

              // arrow still works
              suffixIcon: const Icon(
                IconlyLight.arrowDown2,
                color: kSubTitleColor,
              ),
            ),
          ),

                                  const SizedBox(height: 20.0),
                                  TextFormField(
                                    readOnly: true,
                                    keyboardType: TextInputType.name,
                                    cursorColor: kTitleColor,
                                    showCursor: false,
                                    textInputAction: TextInputAction.next,
                                    onTap: () {
                                      showModalBottomSheet(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30.0),
                                        ),
                                        context: context,
                                        builder: (BuildContext context) {
                                          return StatefulBuilder(
                                            builder: (BuildContext context, setModalState) {
                                              final t = lang.S.of(context);
                                              return Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(20.0),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              t.classTitle,
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
                                                          '${fromAirport?.city ?? 'Algerie'} a ${toAirport?.city ?? 'Tunisie'}, ${_formatDate(departureDate)}',
                                                          style: kTextStyle.copyWith(color: kSubTitleColor),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
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
                                                        ListTile(
                                                          contentPadding: EdgeInsets.zero,
                                                          title: Text(
                                                            t.classEconomy,
                                                            style: kTextStyle.copyWith(
                                                              color: kTitleColor,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                          trailing: selectedClass == 'economy'
                                                              ? const Icon(Icons.check_circle, color: kPrimaryColor)
                                                              : const Icon(Icons.radio_button_unchecked, color: kSubTitleColor),
                                                          onTap: () {
                                                            setState(() {
                                                              selectedClass = 'economy';
                                                            });
                                                            Navigator.pop(context);
                                                          },
                                                        ),
                                                        const Divider(
                                                          thickness: 1.0,
                                                          color: kBorderColorTextField,
                                                        ),
                                                        ListTile(
                                                          contentPadding: EdgeInsets.zero,
                                                          title: Text(
                                                            t.classBusiness,
                                                            style: kTextStyle.copyWith(
                                                              color: kTitleColor,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                          trailing: selectedClass == 'business'
                                                              ? const Icon(Icons.check_circle, color: kPrimaryColor)
                                                              : const Icon(Icons.radio_button_unchecked, color: kSubTitleColor),
                                                          onTap: () {
                                                            setState(() {
                                                              selectedClass = 'business';
                                                            });
                                                            Navigator.pop(context);
                                                          },
                                                        ),
                                                        const Divider(
                                                          thickness: 1.0,
                                                          color: kBorderColorTextField,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      );
                                    },
                                    decoration: kInputDecoration.copyWith(
                                      labelText: lang.S.of(context).classTitle,
                                      labelStyle: kTextStyle.copyWith(color: kTitleColor),
                                      hintText: selectedClass == 'economy'
                                          ? lang.S.of(context).classEconomy
                                          : lang.S.of(context).classBusiness,
                                      hintStyle: kTextStyle.copyWith(color: kTitleColor),
                                      border: const OutlineInputBorder(),
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                      suffixIcon: const Icon(
                                        IconlyLight.arrowDown2,
                                        color: kSubTitleColor,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10.0),
                                  ButtonGlobalWithoutIcon(
                                    buttontext: lang.S.of(context).searchFlight,
                                    buttonDecoration: kButtonDecoration.copyWith(
                                      color: kPrimaryColor,
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    onPressed: () {
                                      if (fromAirport == null || toAirport == null) {
                                        toast('Veuillez sélectionner les aéroports de départ et d''arrivée.');
                                        return;
                                      }

                                      SearchResult(
                                        fromAirport: fromAirport!,
                                        toAirport: toAirport!,
                                        adultCount: adultCount,
                                        childCount: childCount,
                                        infantCount: infantCount,
                                        dateRange: _selectedDateRange,
                                      ).launch(context);
                                    },

                                    buttonTextColor: kWhite,
                                  )
                                ],
                              ).visible(selectedIndex == 2),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Container(
                      width: context.width(),
                      decoration: const BoxDecoration(color: kDarkWhite),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                            child: Text(
                              lang.S.of(context).recentSearch,
                              style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                            ),
                          ),
                          HorizontalList(
                            padding: const EdgeInsets.only(left: 10.0, top: 15.0, bottom: 10.0),
                            itemCount: 10,
                            itemBuilder: (_, i) {
                              return Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6.0),
                                  color: const Color(0xFFEDF0FF),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Algerie  to Tunisie',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      '17 janvier - 18 janvier',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: kTextStyle.copyWith(color: kSubTitleColor),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 10.0),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                            child: Text(
                              lang.S.of(context).flightOfferTitle,
                              style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                            ),
                          ),
                          HorizontalList(
                            padding: const EdgeInsets.only(
                              left: 10.0,
                              top: 15.0,
                              bottom: 15.0,
                              right: 10.0,
                            ),
                            physics: const BouncingScrollPhysics(),
                            itemCount: 10,
                            itemBuilder: (_, i) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: const Color(0xFFEDF0FF),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 120,
                                      width: context.width() / 1.2,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8.0),
                                        color: kWhite,
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 120,
                                            width: 100,
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(8.0),
                                                bottomLeft: Radius.circular(8.0),
                                              ),
                                              image: DecorationImage(
                                                image: AssetImage('images/offer1.png'),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Algerie ',
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                                    ),
                                                    const SizedBox(width: 10.0),
                                                    const Icon(
                                                      Icons.flight_land,
                                                      color: kSubTitleColor,
                                                    ),
                                                    const SizedBox(width: 10.0),
                                                    Text(
                                                      'Tunisie',
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 5.0),
                                                Container(
                                                  height: 1.0,
                                                  width: 120,
                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.0), color: kBorderColorTextField),
                                                ),
                                                const SizedBox(height: 5.0),
                                                SizedBox(
                                                  width: 180,
                                                  child: Text(
                                                    'Ceci est un texte de remplissage utilisé pour illustrer la mise en page.',
                                                    maxLines: 3,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: kTextStyle.copyWith(color: kSubTitleColor),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget _counterButton({
    required IconData icon,
    bool enabled = true,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: enabled
            ? kPrimaryColor
            : kPrimaryColor.withOpacity(0.2),
      ),
      child: Icon(icon, color: Colors.white, size: 14.0)
          .onTap(enabled ? onTap : () {}),
    );
  }

}
