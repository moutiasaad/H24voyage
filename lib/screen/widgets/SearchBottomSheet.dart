import 'package:flight_booking/Model/Airport.dart';
import 'package:flight_booking/screen/widgets/constant.dart';
import 'package:flight_booking/controllers/airport_controller.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import '../../generated/l10n.dart' as lang;

class SearchBottomSheet extends StatefulWidget {
  const SearchBottomSheet({Key? key}) : super(key: key);

  @override
  State<SearchBottomSheet> createState() => _SearchBottomSheetState();
}

class _SearchBottomSheetState extends State<SearchBottomSheet> {
  // Use singleton controller - airports are preloaded from home page
  final AirportController _controller = AirportController.instance;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onControllerUpdate);
  }

  void _onControllerUpdate() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    // Don't dispose singleton controller
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Show API suggestions when searching, otherwise show initial airports from API
    final displayAirports = _controller.hasSearchQuery
        ? _controller.suggestions
        : _controller.initialAirports;

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
            // Search input
            TextFormField(
              controller: _textController,
              showCursor: true,
              keyboardType: TextInputType.name,
              cursorColor: kTitleColor,
              onChanged: (value) {
                _controller.searchAirports(value);
              },
              decoration: kInputDecoration.copyWith(
                contentPadding: const EdgeInsets.only(left: 10, right: 10),
                hintText: 'Pays, ville ou aéroport',
                hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                border: const OutlineInputBorder(),
                prefixIcon: Icon(
                  FeatherIcons.search,
                  color: kSubTitleColor,
                ),
                suffixIcon: _controller.hasSearchQuery
                    ? IconButton(
                        icon: Icon(Icons.clear, color: kSubTitleColor),
                        onPressed: () {
                          _textController.clear();
                          _controller.clear();
                        },
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 20.0),

            // Current location
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
              _controller.hasSearchQuery
                  ? lang.S.of(context).recentPlaceTitle
                  : lang.S.of(context).recentPlaceTitle,
              style: kTextStyle.copyWith(
                  color: kSubTitleColor, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),

            // Airports list - no loading indicator, data is preloaded
            if (displayAirports.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: Center(
                  child: Text(
                    _controller.hasSearchQuery
                        ? 'Aucun aéroport trouvé'
                        : 'Aucun aéroport disponible',
                    style: kTextStyle.copyWith(color: kSubTitleColor),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: displayAirports.length,
                itemBuilder: (_, i) {
                  final airport = displayAirports[i];
                  return Column(
                    children: [
                      ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
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
                          '${airport.city}, ${airport.country}',
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
                          Navigator.pop(context, airport);
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
