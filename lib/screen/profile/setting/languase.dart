import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import '../../widgets/constant.dart';
import 'package:flight_booking/generated/l10n.dart' as lang;
import 'package:flight_booking/screen/provider/providers.dart';

class Language extends StatefulWidget {
  const Language({Key? key}) : super(key: key);

  @override
  State<Language> createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  final List<Map<String, String>> languages = [
    {"name": "English", "code": "en"},
    {"name": "Français", "code": "fr"},
  ];

  late String selectedCode;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    selectedCode =
        Provider.of<LanguageChangeProvider>(context, listen: false)
            .currentLocale
            .languageCode;
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider =
    Provider.of<LanguageChangeProvider>(context);

    return Scaffold(
      backgroundColor: kWebsiteGreyBg,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: kTitleColor),
        title: Text(
          lang.S.of(context).language,
          style: const TextStyle(fontSize: 18, color: kTitleColor),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        height: context.height(),
        width: double.infinity,
        decoration: const BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 10.0),
          itemCount: languages.length,
          itemBuilder: (context, index) {
            final item = languages[index];
            final bool isSelected = selectedCode == item["code"];

            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Card(
                elevation: 1.3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(
                      color: kBorderColorTextField, width: 0.5),
                ),
                child: ListTile(
                  onTap: () {
                    setState(() {
                      selectedCode = item["code"]!;
                    });

                    languageProvider
                        .changeLocale(item["code"]!);
                  },
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                  title: Text(
                    item["name"]!,
                    style: kTextStyle.copyWith(
                      color: isSelected
                          ? kTitleColor
                          : kSubTitleColor,
                    ),
                  ),
                  trailing: Icon(
                    isSelected
                        ? Icons.radio_button_checked
                        : Icons.circle_outlined,
                    color: isSelected
                        ? kPrimaryColor
                        : kSubTitleColor,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
