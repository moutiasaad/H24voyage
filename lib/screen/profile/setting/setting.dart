import 'package:community_material_icon/community_material_icon.dart';
import 'package:flight_booking/screen/profile/setting/currency.dart';
import 'package:flight_booking/screen/profile/setting/languase.dart';
import 'package:flight_booking/screen/profile/setting/notification.dart';
import 'package:flight_booking/screen/provider/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flight_booking/generated/l10n.dart' as lang;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/constant.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  bool notificationEnabled = true;

  String currencyCode = 'DZD';
  String currencySymbol = 'دج';

  @override
  void initState() {
    super.initState();
    _loadCurrency();
  }

  Future<void> _loadCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currencyCode = prefs.getString('currency_code') ?? 'DZD';
      currencySymbol = prefs.getString('currency_symbol') ?? 'دج';
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = lang.S.of(context);
    final langProvider = Provider.of<LanguageChangeProvider>(context);

    final currentLangCode = langProvider.currentLocale.languageCode;
    final currentLanguageName =
    currentLangCode == 'fr' ? 'Français' : 'English';

    return Scaffold(
      backgroundColor: kWebsiteGreyBg,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: kTitleColor),
        title: Text(
          t.settingTitle,
          style: kTextStyle.copyWith(color: kTitleColor),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: const BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // 🌐 Language
            _settingTile(
              icon: CommunityMaterialIcons.translate,
              iconColor: kPrimaryColor,
              bg: kPrimaryColor.withOpacity(0.2),
              title: t.language,
              value: currentLanguageName,
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const Language()),
                );
                setState(() {}); // refresh after change
              },
            ),

            // 💱 Currency
            _settingTile(
              icon: CommunityMaterialIcons.currency_usd,
              iconColor: const Color(0xff00CD46),
              bg: const Color(0xff009F5E).withOpacity(0.1),
              title: t.currencyTitle,
              value: '($currencyCode) - $currencySymbol',
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const Currency()),
                );
                _loadCurrency();
              },
            ),

            // 🔔 Notification
            Card(
              elevation: 1.3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: kBorderColorTextField, width: 0.5),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.only(left: 10),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const NotificationSc()),
                  );
                },
                leading: Container(
                  height: 34,
                  width: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xffFF3B30).withOpacity(0.1),
                  ),
                  child: const Icon(
                    IconlyBold.notification,
                    color: Color(0xffFF3B30),
                  ),
                ),
                title: Text(t.notificationTitle),
                trailing: Switch(
                  activeColor: kPrimaryColor,
                  value: notificationEnabled,
                  onChanged: (val) {
                    setState(() => notificationEnabled = val);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _settingTile({
    required IconData icon,
    required Color iconColor,
    required Color bg,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        elevation: 1.3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: kBorderColorTextField, width: 0.5),
        ),
        child: ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          leading: Container(
            height: 34,
            width: 34,
            decoration: BoxDecoration(shape: BoxShape.circle, color: bg),
            child: Icon(icon, color: iconColor),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: kTextStyle.copyWith(color: kTitleColor)),
              Text(
                value,
                style: kTextStyle.copyWith(color: kSubTitleColor, fontSize: 12),
              ),
            ],
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: kSubTitleColor),
        ),
      ),
    );
  }
}
