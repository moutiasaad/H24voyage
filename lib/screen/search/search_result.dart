import 'dart:convert';

import 'package:flight_booking/Model/Airport.dart';
import 'package:flight_booking/Model/FakeFlight.dart';
import 'package:flight_booking/screen/search/flight_details.dart';
import 'package:flight_booking/screen/widgets/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../generated/l10n.dart' as lang;
import 'filter.dart';

class SearchResult extends StatefulWidget {
  final Airport fromAirport;
  final Airport toAirport;
  final int adultCount;
  final int childCount;
  final int infantCount;
  final DateTimeRange? dateRange;

  const SearchResult({
    Key? key,
    required this.fromAirport,
    required this.toAirport,
    required this.adultCount,
    required this.childCount,
    required this.infantCount,
    this.dateRange,
  }) : super(key: key);

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  List<String> filterTitleList = [
    'Filter',
    'Non Stop',
    '1 Stop',
    'Duration',
  ];

  List<String> selectedFilter = [];
  List<FakeFlight> flights = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFakeFlightsFromAirports();
    });
  }

  Future<void> _loadFakeFlightsFromAirports() async {
    final data = await DefaultAssetBundle.of(context)
        .loadString('assets/data/airports.json');

    final List decoded = json.decode(data);
    final airports = decoded.map((e) => Airport.fromJson(e)).toList();

    final fromCode = widget.fromAirport.code;

    final results = airports
        .where((a) => a.code != fromCode)
        .take(10)
        .map((a) {
      return FakeFlight(
        airline: 'Tunisair',
        departureTime: '0${a.code.codeUnitAt(0) % 9}:30',
        arrivalTime: '1${a.code.codeUnitAt(1) % 9}:45',
        duration: '3h ${a.code.codeUnitAt(2) % 50}m',
        stops: a.code.codeUnitAt(0) % 2,
        price: 120 + a.code.codeUnitAt(0),
        oldPrice: 160 + a.code.codeUnitAt(1),
      );
    }).toList();

    setState(() {
      flights = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    final fromCity = widget.fromAirport.city.split(',')[0];
    final toCity = widget.toAirport.city.split(',')[0];

    return Scaffold(
      backgroundColor: kWebsiteGreyBg,
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: kWebsiteGreyBg,
        iconTheme: const IconThemeData(color: kTitleColor),
        title: ListTile(
          dense: true,
          visualDensity: const VisualDensity(vertical: -2),
          contentPadding: const EdgeInsets.only(right: 15.0),
          title: Text(
            '$fromCity - $toCity',
            style: kTextStyle.copyWith(
              color: kTitleColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            '${widget.dateRange != null ? widget.dateRange!.start.toString().substring(0, 10) : ''}'
                ' | ${widget.adultCount} ${lang.S.of(context).adults}, ${widget.childCount} ${lang.S.of(context).child}, ${widget.infantCount} ${lang.S.of(context).infants}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: kTextStyle.copyWith(color: kTitleColor),
          ),
          trailing: Column(
            children: [
              const Icon(IconlyBold.edit, color: kTitleColor, size: 18.0),
              const SizedBox(height: 2.0),
              Text( lang.S.of(context).editButton, style: kTextStyle.copyWith(color: kTitleColor)),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          width: context.width(),
          decoration: const BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30.0),
              topLeft: Radius.circular(30.0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  'Flight to $toCity',
                  style: kTextStyle.copyWith(
                      color: kTitleColor, fontWeight: FontWeight.bold),
                ),
              ),

              /// 🔹 Filters
              const SizedBox(height: 10),
              HorizontalList(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                itemCount: filterTitleList.length,
                itemBuilder: (_, i) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedFilter.contains(filterTitleList[i])
                            ? selectedFilter.remove(filterTitleList[i])
                            : selectedFilter.add(filterTitleList[i]);
                        if (i == 0) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const Filter()),
                          );
                        }
                      });
                    },
                    child: Container(
                      height: 35,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      decoration: BoxDecoration(
                        color: selectedFilter.contains(filterTitleList[i])
                            ? kPrimaryColor.withOpacity(0.1)
                            : kWhite,
                        borderRadius: BorderRadius.circular(30.0),
                        border: Border.all(color: kBorderColorTextField),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.sort, color: kSubTitleColor)
                              .visible(i == 0),
                          const SizedBox(width: 5).visible(i == 0),
                          Text(
                            filterTitleList[i],
                            style:
                            kTextStyle.copyWith(color: kSubTitleColor),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              /// 🔹 Flights list
              const SizedBox(height: 10),
              ListView.builder(
                itemCount: flights.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 15.0),
                itemBuilder: (_, i) {
                  final f = flights[i];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _flightCard(f, fromCity, toCity),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _flightCard(FakeFlight f, String fromCity, String toCity) {
    final deal = f.oldPrice - f.price;

    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: kWhite,
        border: Border.all(color: kBorderColorTextField),
      ),
      child: Column(
        children: [
          /// 🔹 Top airline + price
          ListTileTheme(
            contentPadding: EdgeInsets.zero,
            dense: true,
            horizontalTitleGap: 0.0,
            minLeadingWidth: 0,
            child: ListTile(
              dense: true,
              visualDensity: const VisualDensity(vertical: -4),
              contentPadding: EdgeInsets.zero,
              leading: Container(
                height: 20.0,
                width: 20.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/TU.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Text(
                f.airline,
                style: kTextStyle.copyWith(
                  color: kTitleColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${f.oldPrice} $currencySign',
                        style: kTextStyle.copyWith(
                          color: kSubTitleColor,
                          decoration: TextDecoration.lineThrough,
                          fontSize: 11, // 🔽 smaller
                          height: 1.0, // 🔽 tighter line height
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${f.price} $currencySign',
                        style: kTextStyle.copyWith(
                          color: kTitleColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          height: 1.0,
                        ),
                      ),
                    ],
                  ),
                  if (deal > 0)
                    Text(
                      '$deal $currencySign Deal',
                      style: kTextStyle.copyWith(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 11, // 🔽 smaller
                        height: 1.0,
                      ),
                    ),
                ],
              ),

            ),
          ),

          const Divider(thickness: 1, height: 1, color: kBorderColorTextField),
          const SizedBox(height: 10),

          /// 🔹 Main flight card
          Material(
            elevation: 1.0,
            shadowColor: kDarkWhite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: const BorderSide(color: kBorderColorTextField),
            ),
            child: GestureDetector(
              onTap: () => const FlightDetails().launch(context),
              child: Container(
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  children: [
                    ListTile(
                      dense: true,
                      horizontalTitleGap: 10.0,
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        f.airline,
                        style: kTextStyle.copyWith(
                          color: kTitleColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Row(
                        children: [
                          const Icon(Icons.swap_horiz, color: kPrimaryColor),
                          const SizedBox(width: 5.0),
                          Text(
                            'Layover included',
                            style:
                            kTextStyle.copyWith(color: kSubTitleColor),
                          ),
                        ],
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        /// From
                        Column(
                          children: [
                            Text(
                              f.departureTime,
                              style: kTextStyle.copyWith(
                                color: kTitleColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              fromCity,
                              style: kTextStyle.copyWith(
                                color: kSubTitleColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),

                        /// Duration + stops
                        Column(
                          children: [
                            Text(
                              f.duration,
                              style: kTextStyle.copyWith(
                                color: kTitleColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 2.0),
                            Row(
                              children: [
                                Container(
                                  height: 10,
                                  width: 10,
                                  decoration: const BoxDecoration(
                                    color: kPrimaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      height: 2,
                                      width: 100,
                                      color: kPrimaryColor,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: const BoxDecoration(
                                        color: kPrimaryColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.flight_land_outlined,
                                        size: 16,
                                        color: kWhite,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 10,
                                  width: 10,
                                  decoration: BoxDecoration(
                                    color: kWhite,
                                    shape: BoxShape.circle,
                                    border:
                                    Border.all(color: kPrimaryColor),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2.0),
                            Text(
                              f.stops == 0 ? 'Non Stop' : '${f.stops} Stop',
                              style: kTextStyle.copyWith(
                                color: kSubTitleColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),

                        /// To
                        Column(
                          children: [
                            Text(
                              f.arrivalTime,
                              style: kTextStyle.copyWith(
                                color: kTitleColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              toCity,
                              style: kTextStyle.copyWith(
                                color: kSubTitleColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),

                        /// Options
                        Text(
                          '+ 2 Option',
                          style: kTextStyle.copyWith(
                            color: kPrimaryColor,
                            fontSize: 12.0,
                          ),
                        ),
                      ],
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
