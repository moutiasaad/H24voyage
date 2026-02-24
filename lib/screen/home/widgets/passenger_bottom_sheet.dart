import 'package:flight_booking/screen/widgets/constant.dart';
import 'package:flight_booking/screen/widgets/button_global.dart';
import 'package:flight_booking/generated/l10n.dart' as lang;
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:nb_utils/nb_utils.dart';

/// Bottom sheet for selecting passenger counts and cabin class.
///
/// Returns a [Map<String, dynamic>] with keys:
///   - `adultCount` (int)
///   - `childCount` (int)
///   - `infantCount` (int)
///   - `youngCount` (int)
///   - `seniorCount` (int)
///   - `selectedClass` (String)
///
/// Returns `null` if the sheet is dismissed without pressing Done.
class PassengerBottomSheet {
  static Future<Map<String, dynamic>?> show(
    BuildContext context, {
    required int adultCount,
    required int childCount,
    required int infantCount,
    required int youngCount,
    required int seniorCount,
    required String selectedClass,
    required List<String> classKeys,
    required String Function(String) getClassDisplayName,
    String? fromCity,
    String? toCity,
  }) async {
    // Local mutable copies
    int _adultCount = adultCount;
    int _childCount = childCount;
    int _infantCount = infantCount;
    int _youngCount = youngCount;
    int _seniorCount = seniorCount;
    String _selectedClass = selectedClass;

    int totalPassengers() =>
        _adultCount + _childCount + _infantCount + _youngCount + _seniorCount;

    bool didConfirm = false;

    await showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setStated) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
                    child: Row(
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
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: kBorderColorTextField),
                          ),
                          child: const Icon(
                            FeatherIcons.x,
                            size: 18.0,
                            color: kSubTitleColor,
                          ),
                        ).onTap(() => finish(context)),
                      ],
                    ),
                  ),
                  // Content
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
                    child: Column(
                      children: [
                        // Adults
                        _passengerRow(
                          title: lang.S.of(context).adults,
                          subtitle: lang.S.of(context).homeAdultsAge,
                          count: _adultCount,
                          minEnabled: _adultCount > 1,
                          maxEnabled: totalPassengers() < 9,
                          onMinus: () => setStated(() {
                            if (_adultCount > 1) _adultCount--;
                          }),
                          onPlus: () => setStated(() {
                            if (totalPassengers() < 9) _adultCount++;
                          }),
                        ),
                        const Divider(thickness: 1.0, color: kBorderColorTextField),
                        // Children
                        _passengerRow(
                          title: lang.S.of(context).child,
                          subtitle: lang.S.of(context).homeChildAge,
                          count: _childCount,
                          minEnabled: _childCount > 0,
                          maxEnabled: totalPassengers() < 9,
                          onMinus: () => setStated(() {
                            if (_childCount > 0) _childCount--;
                          }),
                          onPlus: () => setStated(() {
                            if (totalPassengers() < 9) _childCount++;
                          }),
                        ),
                        const Divider(thickness: 1.0, color: kBorderColorTextField),
                        // Infants
                        _passengerRow(
                          title: lang.S.of(context).infants,
                          subtitle: lang.S.of(context).homeInfantAge,
                          count: _infantCount,
                          minEnabled: _infantCount > 0,
                          maxEnabled: totalPassengers() < 9,
                          onMinus: () => setStated(() {
                            if (_infantCount > 0) _infantCount--;
                          }),
                          onPlus: () => setStated(() {
                            if (totalPassengers() < 9) _infantCount++;
                          }),
                        ),
                        const Divider(thickness: 1.0, color: kBorderColorTextField),
                        // Young
                        _passengerRow(
                          title: lang.S.of(context).homeYoung,
                          tooltip: lang.S.of(context).homeYoungTooltip,
                          count: _youngCount,
                          minEnabled: _youngCount > 0,
                          maxEnabled: totalPassengers() < 9,
                          onMinus: () => setStated(() {
                            if (_youngCount > 0) _youngCount--;
                          }),
                          onPlus: () => setStated(() {
                            if (totalPassengers() < 9) _youngCount++;
                          }),
                        ),
                        const Divider(thickness: 1.0, color: kBorderColorTextField),
                        // Senior
                        _passengerRow(
                          title: lang.S.of(context).homeSenior,
                          tooltip: lang.S.of(context).homeSeniorTooltip,
                          count: _seniorCount,
                          minEnabled: _seniorCount > 0,
                          maxEnabled: totalPassengers() < 9,
                          onMinus: () => setStated(() {
                            if (_seniorCount > 0) _seniorCount--;
                          }),
                          onPlus: () => setStated(() {
                            if (totalPassengers() < 9) _seniorCount++;
                          }),
                        ),
                        const Divider(thickness: 1.0, color: kBorderColorTextField),
                        const SizedBox(height: 12),
                        // Info note
                        Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(FeatherIcons.info, size: 16, color: kSubTitleColor),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  lang.S.of(context).homePassengerNote,
                                  style: kTextStyle.copyWith(
                                    color: kSubTitleColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Class Selection Dropdown
                        SmallTapEffect(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: kBorderColorTextField, width: 1.0),
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: DropdownButtonFormField<String>(
                              value: _selectedClass,
                              decoration: InputDecoration(
                                labelText: lang.S.of(context).homeClassLabel,
                                labelStyle: kTextStyle.copyWith(
                                  color: kSubTitleColor,
                                  fontSize: 12,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                isDense: true,
                              ),
                              icon: const Icon(Icons.keyboard_arrow_down, color: kSubTitleColor, size: 20),
                              isExpanded: true,
                              dropdownColor: kWhite,
                              menuMaxHeight: 250,
                              borderRadius: BorderRadius.circular(12.0),
                              style: kTextStyle.copyWith(
                                color: kTitleColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              selectedItemBuilder: (context) => [
                                Text(lang.S.of(context).homeClassEconomy, style: kTextStyle.copyWith(fontSize: 14, color: kTitleColor)),
                                Text(lang.S.of(context).homeClassPremiumEconomy, style: kTextStyle.copyWith(fontSize: 14, color: kTitleColor)),
                                Text(lang.S.of(context).homeClassBusiness, style: kTextStyle.copyWith(fontSize: 14, color: kTitleColor)),
                                Text(lang.S.of(context).homeClassFirst, style: kTextStyle.copyWith(fontSize: 14, color: kTitleColor)),
                              ],
                              items: [
                                DropdownMenuItem(value: 'economy', child: Text(lang.S.of(context).homeClassEconomy, style: kTextStyle.copyWith(fontSize: 14))),
                                DropdownMenuItem(value: 'premium_economy', child: Text(lang.S.of(context).homeClassPremiumEconomy, style: kTextStyle.copyWith(fontSize: 14))),
                                DropdownMenuItem(value: 'business', child: Text(lang.S.of(context).homeClassBusiness, style: kTextStyle.copyWith(fontSize: 14))),
                                DropdownMenuItem(value: 'first', child: Text(lang.S.of(context).homeClassFirst, style: kTextStyle.copyWith(fontSize: 14))),
                              ],
                              onChanged: (value) {
                                setStated(() {
                                  _selectedClass = value!;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Done button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              didConfirm = true;
                              finish(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: Text(
                              lang.S.of(context).homeDone,
                              style: kTextStyle.copyWith(
                                color: kWhite,
                                fontWeight: FontWeight.bold,
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
          },
        );
      },
    );

    if (didConfirm) {
      return {
        'adultCount': _adultCount,
        'childCount': _childCount,
        'infantCount': _infantCount,
        'youngCount': _youngCount,
        'seniorCount': _seniorCount,
        'selectedClass': _selectedClass,
      };
    }
    return null;
  }

  /// A single counter button (plus or minus) with enabled/disabled styling.
  static Widget _counterButton({
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

  /// A row for a single passenger type: label, optional subtitle/tooltip,
  /// and minus/count/plus controls.
  static Widget _passengerRow({
    required String title,
    String? subtitle,
    String? tooltip,
    required int count,
    required bool minEnabled,
    required bool maxEnabled,
    required VoidCallback onMinus,
    required VoidCallback onPlus,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: kTextStyle.copyWith(
                        color: kTitleColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    if (tooltip != null) ...[
                      const SizedBox(width: 6),
                      Tooltip(
                        message: tooltip,
                        triggerMode: TooltipTriggerMode.tap,
                        showDuration: const Duration(seconds: 3),
                        child: Icon(
                          FeatherIcons.info,
                          size: 16,
                          color: kSubTitleColor,
                        ),
                      ),
                    ],
                  ],
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: kTextStyle.copyWith(
                      color: kSubTitleColor,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          _counterButton(
            icon: FeatherIcons.minus,
            enabled: minEnabled,
            onTap: onMinus,
          ),
          SizedBox(
            width: 40,
            child: Text(
              count.toString(),
              textAlign: TextAlign.center,
              style: kTextStyle.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: kTitleColor,
              ),
            ),
          ),
          _counterButton(
            icon: FeatherIcons.plus,
            enabled: maxEnabled,
            onTap: onPlus,
          ),
        ],
      ),
    );
  }
}
