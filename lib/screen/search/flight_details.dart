import 'package:flight_booking/Model/FareOption.dart';
import 'package:flight_booking/screen/widgets/button_global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:nb_utils/nb_utils.dart';

import '../book proceed/book_proceed.dart';
import '../widgets/constant.dart';
import 'package:flight_booking/generated/l10n.dart' as lang;

class FlightDetails extends StatefulWidget {
  const FlightDetails({Key? key}) : super(key: key);

  @override
  State<FlightDetails> createState() => _FlightDetailsState();
}

class _FlightDetailsState extends State<FlightDetails>
    with TickerProviderStateMixin {
  TabController? tabController;
  late FareOption selectedFare;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    selectedFare = fareOptions[0]; // default = first option (Classic)
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        initialIndex: 1,
        child: Scaffold(
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(color: kWhite),
            child: ListTile(
              contentPadding: const EdgeInsets.only(left: 15.0, right: 15.0),
              visualDensity: const VisualDensity(vertical: 2),
              title: Text(
                'Prix ​​total',
                style: kTextStyle.copyWith(color: kSubTitleColor),
              ),
              subtitle: Text(
                ' ${45000.00} $currencySign',
                style: kTextStyle.copyWith(
                    color: kTitleColor, fontWeight: FontWeight.bold),
              ),
              trailing: SizedBox(
                height: 70,
                width: 200,
                child: ButtonGlobalWithoutIcon(
                  buttontext: lang.S.of(context).proceedToBook,
                  buttonDecoration: kButtonDecoration.copyWith(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  onPressed: () {
                    setState(() {
                      const BookProceed().launch(context);
                    });
                  },
                  buttonTextColor: kWhite,
                ),
              ),
            ),
          ),
          backgroundColor: kWebsiteGreyBg,
          body: Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Container(
              decoration: const BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                          Text(
                            lang.S.of(context).flightDetails,
                            style: kTextStyle.copyWith(
                                color: kTitleColor,
                                fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          SmallTapEffect(
                            onTap: () {
                              setState(() {
                                Navigator.pop(context);
                              });
                            },
                            child: const Icon(
                              FeatherIcons.x,
                              color: kSubTitleColor,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: kWhite,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30.0),
                          topLeft: Radius.circular(30.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: kDarkWhite,
                            spreadRadius: 2,
                            blurRadius: 7.0,
                            offset: Offset(0, -4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TabBar(
                            labelStyle: kTextStyle.copyWith(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.bold),
                            unselectedLabelColor: kSubTitleColor,
                            indicatorColor: kPrimaryColor,
                            labelColor: kPrimaryColor,
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicator: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30.0),
                                topLeft: Radius.circular(30.0),
                              ),
                              color: Color(0xFFEDF0FF),
                            ),
                            onTap: (index) {
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                            tabs: [
                              Tab(
                                text: lang.S.of(context).onwardTitle,
                              ),
                              Tab(
                                text: lang.S.of(context).returnTitle,
                              ),
                            ],
                          ),
                          const Divider(
                              height: 0,
                              thickness: 1.0,
                              color: kBorderColorTextField),
                          //_________________________________________________________________________Onward
                          ListView.builder(
                            itemCount: 1,
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (_, i) {
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    Container(
                                      width: context.width(),
                                      padding: const EdgeInsets.all(20.0),
                                      decoration: BoxDecoration(
                                        color: kSecondaryColor,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(8.0),
                                          topRight: Radius.circular(8.0),
                                        ),
                                        border:
                                        Border.all(color: kSecondaryColor),
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            'Algiers  - Tunis ',
                                            style: kTextStyle.copyWith(
                                              color: kTitleColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            '1 stop | 5 hrs 40 mins | Économique ',
                                            style: kTextStyle.copyWith(
                                                color: kSubTitleColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      height: 0,
                                      thickness: 1.0,
                                      color: const Color(0xFFE2E2E2),
                                    ),
                                    Container(
                                      width: context.width(),
                                      padding: const EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                        color: kWhite,
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(8.0),
                                          bottomRight: Radius.circular(8.0),
                                        ),
                                        border:
                                        Border.all(color: kSecondaryColor),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          ListTile(
                                            onTap: () {
                                              setState(() {});
                                            },
                                            dense: true,
                                            horizontalTitleGap: 10,
                                            contentPadding: EdgeInsets.zero,
                                            minVerticalPadding: 0,
                                            leading: Container(
                                              height: 34.0,
                                              width: 34.0,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        'assets/TU.png'),
                                                    fit: BoxFit.cover),
                                              ),
                                            ),
                                            title: Text(
                                              'Tunisair',
                                              style: kTextStyle.copyWith(
                                                  color: kTitleColor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: Text(
                                              '01h 10m en vol',
                                              style: kTextStyle.copyWith(
                                                  color: kSubTitleColor),
                                            ),
                                          ),
                                          const SizedBox(height: 10.0),
                                          Container(
                                            decoration: const BoxDecoration(
                                                color: Colors.transparent),
                                            child: Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Stack(
                                                      alignment:
                                                      Alignment.topCenter,
                                                      children: [
                                                        Container(
                                                          height: 100.0,
                                                          width: 2,
                                                          decoration:
                                                          BoxDecoration(
                                                            color: const Color(0xFFE2E2E2),
                                                          ),
                                                        ),
                                                        const Padding(
                                                          padding:
                                                          EdgeInsets.only(
                                                              right: 1.0,
                                                              bottom: 5),
                                                          child: RotatedBox(
                                                            quarterTurns: 2,
                                                            child: Icon(
                                                              Icons.flight,
                                                              color:
                                                              kPrimaryColor,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets.only(
                                                          left: 5.0),
                                                      child: Container(
                                                        height: 15.0,
                                                        width: 15.0,
                                                        decoration:
                                                        BoxDecoration(
                                                          color: kWhite,
                                                          shape:
                                                          BoxShape.circle,
                                                          border: Border.all(
                                                              color: const Color(0xFFE2E2E2),
                                                              width: 3),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(width: 25.0),
                                                Column(
                                                  mainAxisSize:
                                                  MainAxisSize.min,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '11:40 pm  -  Algiers ',
                                                      style:
                                                      kTextStyle.copyWith(
                                                          color:
                                                          kTitleColor,
                                                          fontWeight:
                                                          FontWeight
                                                              .bold),
                                                    ),
                                                    SizedBox(
                                                      width: 265,
                                                      child: Text(
                                                        'Thu 6 Jan - Algiers   Aéroport',
                                                        maxLines: 2,
                                                        style: kTextStyle.copyWith(
                                                            color:
                                                            kSubTitleColor),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                        height: 10.0),
                                                    Text(
                                                      '11:40 pm  -  Tunis ',
                                                      style:
                                                      kTextStyle.copyWith(
                                                          color:
                                                          kTitleColor,
                                                          fontWeight:
                                                          FontWeight
                                                              .bold),
                                                    ),
                                                    SizedBox(
                                                      width: 265,
                                                      child: Text(
                                                        'Thu 6 Jan - Algiers  Aéroport',
                                                        maxLines: 2,
                                                        style: kTextStyle.copyWith(
                                                            color:
                                                            kSubTitleColor),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 20.0),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFE3E7EA),
                                              borderRadius:
                                              BorderRadius.circular(6.0),
                                            ),
                                            child: ListTile(
                                              onTap: () {
                                                setState(() {});
                                              },
                                              dense: true,
                                              horizontalTitleGap: 0,
                                              contentPadding: EdgeInsets.zero,
                                              minVerticalPadding: 0,
                                              leading: Container(
                                                padding:
                                                const EdgeInsets.all(5.0),
                                                decoration: const BoxDecoration(
                                                    color: Colors.transparent),
                                                child: const Icon(
                                                  Icons
                                                      .directions_walk_outlined,
                                                  color: kSubTitleColor,
                                                ),
                                              ),
                                              title: Text(
                                                'Escale d''une nuit à Tunis ',
                                                style: kTextStyle.copyWith(
                                                    color: kTitleColor,
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ),
                                              subtitle: Text(
                                                '07h 05m',
                                                style: kTextStyle.copyWith(
                                                    color: kSubTitleColor),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10.0),
                                          Container(
                                            decoration: const BoxDecoration(
                                                color: Colors.transparent),
                                            child: Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets.only(
                                                          left: 5.0),
                                                      child: Container(
                                                        height: 15.0,
                                                        width: 15.0,
                                                        decoration:
                                                        BoxDecoration(
                                                          color: kWhite,
                                                          shape:
                                                          BoxShape.circle,
                                                          border: Border.all(
                                                              color: const Color(0xFFE2E2E2),
                                                              width: 3),
                                                        ),
                                                      ),
                                                    ),
                                                    Stack(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      children: [
                                                        Container(
                                                          height: 100.0,
                                                          width: 2,
                                                          decoration:
                                                          BoxDecoration(
                                                            color: const Color(0xFFE2E2E2),
                                                          ),
                                                        ),
                                                        const Padding(
                                                          padding:
                                                          EdgeInsets.only(
                                                              right: 1.0),
                                                          child: RotatedBox(
                                                            quarterTurns: 2,
                                                            child: Icon(
                                                              Icons.flight,
                                                              color:
                                                              kPrimaryColor,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(width: 25.0),
                                                Column(
                                                  mainAxisSize:
                                                  MainAxisSize.min,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '12:40 pm  -  Tunis ',
                                                      style:
                                                      kTextStyle.copyWith(
                                                          color:
                                                          kTitleColor,
                                                          fontWeight:
                                                          FontWeight
                                                              .bold),
                                                    ),
                                                    SizedBox(
                                                      width: 265,
                                                      child: Text(
                                                        'Jeu 6 janv. - Tunis Aéroport',
                                                        maxLines: 2,
                                                        style: kTextStyle.copyWith(
                                                            color:
                                                            kSubTitleColor),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                        height: 10.0),
                                                    Text(
                                                      '12:40 pm  -  Tunis',
                                                      style:
                                                      kTextStyle.copyWith(
                                                          color:
                                                          kTitleColor,
                                                          fontWeight:
                                                          FontWeight
                                                              .bold),
                                                    ),
                                                    SizedBox(
                                                      width: 265,
                                                      child: Text(
                                                        'Jeu 6 janv. - Tunis Aéroport',
                                                        maxLines: 2,
                                                        style: kTextStyle.copyWith(
                                                            color:
                                                            kSubTitleColor),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          //_________________________________________________________________________Return
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: context.width(),
                                  padding: const EdgeInsets.all(20.0),
                                  decoration: BoxDecoration(
                                    color: kSecondaryColor,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(8.0),
                                      topRight: Radius.circular(8.0),
                                    ),
                                    border: Border.all(color: kSecondaryColor),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Tunis  - Algiers ',
                                        style: kTextStyle.copyWith(
                                          color: kTitleColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Sans escale | 1 h 40 min | Économie',
                                        style: kTextStyle.copyWith(
                                            color: kSubTitleColor),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  height: 0,
                                  thickness: 1.0,
                                  color: const Color(0xFFE2E2E2),
                                ),
                                Container(
                                  width: context.width(),
                                  padding: const EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    color: kWhite,
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(8.0),
                                      bottomRight: Radius.circular(8.0),
                                    ),
                                    border: Border.all(color: kSecondaryColor),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      ListTile(
                                        onTap: () {
                                          setState(() {});
                                        },
                                        dense: true,
                                        horizontalTitleGap: 10,
                                        contentPadding: EdgeInsets.zero,
                                        minVerticalPadding: 0,
                                        leading: Container(
                                          height: 34.0,
                                          width: 34.0,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/TU.png'),
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                        title: Text(
                                          'Tunisair',
                                          style: kTextStyle.copyWith(
                                              color: kTitleColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Text(
                                          '1 h 25 min de vol',
                                          style: kTextStyle.copyWith(
                                              color: kSubTitleColor),
                                        ),
                                      ),
                                      Container(
                                        decoration: const BoxDecoration(
                                            color: Colors.transparent),
                                        child: Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.only(
                                                      left: 5.0),
                                                  child: Container(
                                                    height: 15.0,
                                                    width: 15.0,
                                                    decoration: BoxDecoration(
                                                      color: kWhite,
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                          color: const Color(0xFFE2E2E2),
                                                          width: 3),
                                                    ),
                                                  ),
                                                ),
                                                Stack(
                                                  alignment:
                                                  Alignment.bottomCenter,
                                                  children: [
                                                    Container(
                                                      height: 100.0,
                                                      width: 2,
                                                      decoration: const BoxDecoration(
                                                        color: Color(0xFFE2E2E2),
                                                      ),
                                                    ),
                                                    const Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 1.0),
                                                      child: Icon(
                                                        Icons.flight,
                                                        color: kPrimaryColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(width: 25.0),
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '11:40 pm  -  Algiers ',
                                                  style: kTextStyle.copyWith(
                                                      color: kTitleColor,
                                                      fontWeight:
                                                      FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  width: 265,
                                                  child: Text(
                                                    'Jeu 6 janv. - Algiers  Airport',
                                                    maxLines: 2,
                                                    style: kTextStyle.copyWith(
                                                        color: kSubTitleColor),
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                const SizedBox(height: 10.0),
                                                Text(
                                                  '11:40 pm  -  Algiers',
                                                  style: kTextStyle.copyWith(
                                                      color: kTitleColor,
                                                      fontWeight:
                                                      FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  width: 265,
                                                  child: Text(
                                                    'Jeu 6 janv. -Tunis Aéroport',
                                                    maxLines: 2,
                                                    style: kTextStyle.copyWith(
                                                        color: kSubTitleColor),
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ).visible(selectedIndex == 1),
                          //_________________________________________________________________________Select_Services
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lang.S.of(context).selectService,
                                  style: kTextStyle.copyWith(
                                      color: kTitleColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10.0),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: fareOptions.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (_, i) {
                                    return Padding(
                                      padding:
                                      const EdgeInsets.only(bottom: 10.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(8.0),
                                            color: kWhite,
                                            border: Border.all(
                                                color: kSecondaryColor)),
                                        child: Column(
                                          children: [
                                          ListTile(
                                          dense: true,
                                          horizontalTitleGap: 0,
                                          contentPadding: const EdgeInsets.only(right: 12.0),
                                          leading: Radio<FareOption>(
                                            value: fareOptions[i],
                                            groupValue: selectedFare,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedFare = value!;
                                              });
                                            },
                                          ),

                                          // ✅ TITLE ROW
                                          title: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Tarif proposé par la compagnie aérienne',
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis, // 🔧 prevent overflow
                                                  style: kTextStyle.copyWith(
                                                    color: kTitleColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                '${fareOptions[i].oldPrice} $currencySign',
                                                style: kTextStyle.copyWith(
                                                  color: kSubTitleColor,
                                                  decoration: TextDecoration.lineThrough,
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                            ],
                                          ),

                                          // ✅ SUBTITLE ROW
                                          subtitle: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  fareOptions[i].title,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis, // 🔧 prevent overflow
                                                  style: kTextStyle.copyWith(
                                                    color: kSubTitleColor,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                '${fareOptions[i].price} $currencySign',
                                                style: kTextStyle.copyWith(
                                                  color: kTitleColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                            const SizedBox(height: 10.0),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      ListTile(
                                                        dense: true,
                                                        visualDensity:
                                                        const VisualDensity(
                                                            vertical: -4),
                                                        horizontalTitleGap: 0,
                                                        contentPadding:
                                                        const EdgeInsets
                                                            .only(
                                                            left: 10.0),
                                                        leading: Container(
                                                          width: 24,
                                                          height: 24,
                                                          decoration:
                                                          const BoxDecoration(
                                                            shape: BoxShape
                                                                .rectangle,
                                                            image: DecorationImage(
                                                                image: AssetImage(
                                                                    'images/traveller_orange.png'),
                                                                fit: BoxFit
                                                                    .cover),
                                                          ),
                                                        ),
                                                        title: Text(
                                                          'bagage cabine',
                                                          style: kTextStyle
                                                              .copyWith(
                                                            color: kTitleColor,
                                                            fontWeight:
                                                            FontWeight.bold,
                                                          ),
                                                        ),
                                                        subtitle: Text(
                                                          '7Kg',
                                                          style: kTextStyle
                                                              .copyWith(
                                                            color:
                                                            kSubTitleColor,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 10.0),
                                                      ListTile(
                                                        dense: true,
                                                        visualDensity:
                                                        const VisualDensity(
                                                            vertical: -4),
                                                        horizontalTitleGap: 0,
                                                        contentPadding:
                                                        const EdgeInsets
                                                            .only(
                                                            left: 10.0),
                                                        leading: Container(
                                                          width: 24,
                                                          height: 24,
                                                          decoration:
                                                          const BoxDecoration(
                                                            shape: BoxShape
                                                                .rectangle,
                                                            image: DecorationImage(
                                                                image: AssetImage(
                                                                    'images/seat_orange.png'),
                                                                fit: BoxFit
                                                                    .cover),
                                                          ),
                                                        ),
                                                        title: Text(
                                                          'Sélection des sièges',
                                                          style: kTextStyle
                                                              .copyWith(
                                                            color: kTitleColor,
                                                            fontWeight:
                                                            FontWeight.bold,
                                                          ),
                                                        ),
                                                        subtitle: Text(
                                                          'Disponible',
                                                          style: kTextStyle
                                                              .copyWith(
                                                            color:
                                                            kSubTitleColor,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 10.0),
                                                      ListTile(
                                                        dense: true,
                                                        visualDensity:
                                                        const VisualDensity(
                                                            vertical: -4),
                                                        horizontalTitleGap: 0,
                                                        contentPadding:
                                                        const EdgeInsets
                                                            .only(
                                                            left: 10.0),
                                                        leading: Container(
                                                          width: 24,
                                                          height: 24,
                                                          decoration:
                                                          const BoxDecoration(
                                                            shape: BoxShape
                                                                .rectangle,
                                                            image: DecorationImage(
                                                                image: AssetImage(
                                                                    'images/dollar_orange.png'),
                                                                fit: BoxFit
                                                                    .cover),
                                                          ),
                                                        ),
                                                        title: Text(
                                                          'Cancellation',
                                                          style: kTextStyle
                                                              .copyWith(
                                                            color: kTitleColor,
                                                            fontWeight:
                                                            FontWeight.bold,
                                                          ),
                                                        ),
                                                        subtitle: Text(
                                                          'Frais d''annulation à partir de ${5000} $currencySign',
                                                          style: kTextStyle
                                                              .copyWith(
                                                            color:
                                                            kSubTitleColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  height: 140,
                                                  width: 2.0,
                                                  decoration:
                                                  const BoxDecoration(
                                                    color: kSecondaryColor,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      ListTile(
                                                        dense: true,
                                                        visualDensity:
                                                        const VisualDensity(
                                                            vertical: -4),
                                                        horizontalTitleGap: 0,
                                                        contentPadding:
                                                        const EdgeInsets
                                                            .only(
                                                            left: 10.0),
                                                        leading: Container(
                                                          width: 24,
                                                          height: 24,
                                                          decoration:
                                                          const BoxDecoration(
                                                            shape: BoxShape
                                                                .rectangle,
                                                            image: DecorationImage(
                                                                image: AssetImage(
                                                                    'images/bag_orange.png'),
                                                                fit: BoxFit
                                                                    .cover),
                                                          ),
                                                        ),
                                                        title: Text(
                                                          'bagages enregistrés',
                                                          style: kTextStyle
                                                              .copyWith(
                                                            color: kTitleColor,
                                                            fontWeight:
                                                            FontWeight.bold,
                                                          ),
                                                        ),
                                                        subtitle: Text(
                                                          '50Kg',
                                                          style: kTextStyle
                                                              .copyWith(
                                                            color:
                                                            kSubTitleColor,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 10.0),
                                                      ListTile(
                                                        dense: true,
                                                        visualDensity:
                                                        const VisualDensity(
                                                            vertical: -4),
                                                        horizontalTitleGap: 0,
                                                        contentPadding:
                                                        const EdgeInsets
                                                            .only(
                                                            left: 10.0),
                                                        leading: Container(
                                                          width: 24,
                                                          height: 24,
                                                          decoration:
                                                          const BoxDecoration(
                                                            shape: BoxShape
                                                                .rectangle,
                                                            image: DecorationImage(
                                                                image: AssetImage(
                                                                    'images/meal_orange.png'),
                                                                fit: BoxFit
                                                                    .cover),
                                                          ),
                                                        ),
                                                        title: Text(
                                                          'Repas',
                                                          style: kTextStyle
                                                              .copyWith(
                                                            color: kTitleColor,
                                                            fontWeight:
                                                            FontWeight.bold,
                                                          ),
                                                        ),
                                                        subtitle: Text(
                                                          'Disponiblee',
                                                          style: kTextStyle
                                                              .copyWith(
                                                            color:
                                                            kSubTitleColor,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 10.0),
                                                      ListTile(
                                                        dense: true,
                                                        visualDensity:
                                                        const VisualDensity(
                                                            vertical: -4),
                                                        horizontalTitleGap: 0,
                                                        contentPadding:
                                                        const EdgeInsets
                                                            .only(
                                                            left: 10.0),
                                                        leading: Container(
                                                          width: 24,
                                                          height: 24,
                                                          decoration:
                                                          const BoxDecoration(
                                                            shape: BoxShape
                                                                .rectangle,
                                                            image: DecorationImage(
                                                                image: AssetImage(
                                                                    'images/watch_orange.png'),
                                                                fit: BoxFit
                                                                    .cover),
                                                          ),
                                                        ),
                                                        title: Text(
                                                          'Date Change ',
                                                          style: kTextStyle
                                                              .copyWith(
                                                            color: kTitleColor,
                                                            fontWeight:
                                                            FontWeight.bold,
                                                          ),
                                                        ),
                                                        subtitle: Text(
                                                          'Frais de changement de date à partir de ${7000} $currencySign',
                                                          style: kTextStyle
                                                              .copyWith(
                                                            color:
                                                            kSubTitleColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
