import 'package:flight_booking/screen/widgets/constant.dart';
import 'package:flight_booking/generated/l10n.dart' as lang;
import 'package:flutter/material.dart';
import '../models/offer_slider_item.dart';

class OfferSlider extends StatelessWidget {
  final List<OfferSliderItem> items;
  final PageController pageController;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;

  const OfferSlider({
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
            lang.S.of(context).homeOffersSection,
            style: kTextStyle.copyWith(
              color: kTitleColor,
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          const SizedBox(height: 15.0),
          SizedBox(
            height: 160,
            child: Stack(
              children: [
                PageView.builder(
                  controller: pageController,
                  itemCount: items.length,
                  onPageChanged: onPageChanged,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return GestureDetector(
                      onTap: item.onTap,
                      child: Container(
                        margin: const EdgeInsets.only(right: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          image: DecorationImage(
                            image: AssetImage(item.backgroundImage),
                            fit: BoxFit.cover,
                          ),
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
