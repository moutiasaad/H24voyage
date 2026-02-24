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
    return AnimatedBuilder(
      animation: tabController.animation!,
      builder: (context, child) {
        final labels = [
          lang.S.of(context).tab2,
          lang.S.of(context).tab1,
          lang.S.of(context).tab3,
        ];
        final animValue = tabController.animation!.value;
        return LayoutBuilder(
          builder: (context, constraints) {
            final tabWidth = constraints.maxWidth / labels.length;
            return Stack(
              children: [
                // Tab buttons
                Row(
                  children: List.generate(labels.length, (index) {
                    final isSelected = tabController.index == index;
                    return Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          surfaceTintColor: Colors.transparent,
                          padding: const EdgeInsets.only(top: 16.0, bottom: 22.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () => onTabChanged(index),
                        child: Text(
                          labels[index],
                          textAlign: TextAlign.center,
                          style: kTextStyle.copyWith(
                            color: kTitleColor,
                            fontSize: 15,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                // Sliding indicator at bottom of buttons
                Positioned(
                  bottom: 4,
                  left: animValue * tabWidth + 12,
                  child: Container(
                    width: tabWidth - 24,
                    height: 4.0,
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(3.0),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
