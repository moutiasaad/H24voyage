import 'package:flight_booking/Model/Airport.dart';
import 'package:flight_booking/screen/widgets/constant.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import '../../generated/l10n.dart' as lang;

class SearchBottomSheet extends StatelessWidget {
  const SearchBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.height() * 0.85,
      padding: const EdgeInsets.all(20.0),
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
            // 🔍 Search input
            TextFormField(
              showCursor: false,
              keyboardType: TextInputType.name,
              cursorColor: kTitleColor,
              decoration: kInputDecoration.copyWith(
                contentPadding: const EdgeInsets.only(left: 10, right: 10),
                hintText: 'Country, city or airport',
                hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                border: const OutlineInputBorder(),
                prefixIcon: Icon(
                  FeatherIcons.search,
                  color: kSubTitleColor,
                ),
              ),
            ),
            const SizedBox(height: 20.0),

            // 📍 Current location
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: Icon(IconlyBold.send, color: kSubTitleColor),
              title: Text(
                lang.S.of(context).currentLocation,
                style: kTextStyle.copyWith(color: kSubTitleColor),
              ),
              subtitle: Text(
                lang.S.of(context).useCurrentLocation,
                style: kTextStyle.copyWith(
                    color: kTitleColor, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(thickness: 1.0, color: kBorderColorTextField),

            const SizedBox(height: 10.0),
            Text(
              lang.S.of(context).recentPlaceTitle,
              style: kTextStyle.copyWith(
                  color: kSubTitleColor, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),

            // 🗺 Recent places
            // 🗺 Airports list
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: airports.length,
              itemBuilder: (_, i) {
                final airport = airports[i];
                return Column(
                  children: [
                    ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,

                      // 🔹 Leading icon NOT in a circle anymore
                      leading: SizedBox(
                        width: 40,
                        height: 40,
                        child: Icon(
                          Icons.flight_takeoff,
                          color: kPrimaryColor,
                          size: 28,
                        ),
                      ),

                      title: Text(
                        airport.name,
                        style: kTextStyle.copyWith(
                          color: kTitleColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        airport.city,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: kTextStyle.copyWith(color: kSubTitleColor),
                      ),

                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: kPrimaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          airport.code,
                          style: kTextStyle.copyWith(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      onTap: () {
                        Navigator.pop(context, airport); // ✅ return selected airport
                      },
                    ),
                    const Divider(thickness: 1.0, color: kBorderColorTextField),
                  ],
                );
              },
            ),

          ],
        ),
      ),
    );
  }
}
