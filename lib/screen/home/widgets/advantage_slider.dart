import 'package:flight_booking/screen/widgets/constant.dart';
import 'package:flight_booking/generated/l10n.dart' as lang;
import 'package:flutter/material.dart';
import '../models/advantage_slider_item.dart';

class AdvantageSlider extends StatelessWidget {
  final List<AdvantageSliderItem> items;
  final PageController pageController;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;

  const AdvantageSlider({
    Key? key,
    required this.items,
    required this.pageController,
    required this.currentIndex,
    required this.onPageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lang.S.of(context).homeAdvantagesSection,
            style: kTextStyle.copyWith(
              color: kTitleColor,
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          const SizedBox(height: 15.0),
          SizedBox(
            height: 100,
            child: Stack(
              children: [
                PageView.builder(
                  controller: pageController,
                  itemCount: items.length,
                  onPageChanged: onPageChanged,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Container(
                      margin: const EdgeInsets.only(right: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        image: DecorationImage(
                          image: AssetImage(item.backgroundImage),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                        child: Row(
                          children: [
                            if (item.iconImage != null)
                              Image.asset(
                                item.iconImage!,
                                width: 50,
                                height: 50,
                              ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    item.title,
                                    style: kTextStyle.copyWith(
                                      color: kTitleColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17.0,
                                    ),
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    item.subtitle,
                                    style: kTextStyle.copyWith(
                                      color: kTitleColor.withOpacity(0.8),
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                // Dots indicator inside image - bottom right
                Positioned(
                  bottom: 12,
                  right: 16,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      items.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 3.0),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: currentIndex == index
                              ? kPrimaryColor
                              : Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
