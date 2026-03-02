import 'package:flight_booking/screen/widgets/constant.dart';
import 'package:flight_booking/generated/l10n.dart' as lang;
import 'package:flutter/material.dart';

class FlightSearchTabs extends StatelessWidget {
  final TabController tabController;
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;

  const FlightSearchTabs({
    Key? key,
    required this.tabController,
    required this.selectedIndex,
    required this.onTabChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: tabController,
      labelColor: kTitleColor,
      unselectedLabelColor: kSubTitleColor,
      labelStyle: kTextStyle.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 15,
      ),
      unselectedLabelStyle: kTextStyle.copyWith(
        fontSize: 15,
      ),
      dividerColor: const Color(0xFFE2E2E2),
      indicator: UnderlineTabIndicator(
        borderSide: const BorderSide(
          color: kPrimaryColor,
          width: 4.0,
        ),
        borderRadius: BorderRadius.circular(3.0),
        insets: const EdgeInsets.only(bottom: 8.0),
      ),
      onTap: onTabChanged,
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
    );
  }
}
