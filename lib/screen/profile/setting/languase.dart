import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import '../../widgets/constant.dart';
import '../../widgets/button_global.dart';
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
      backgroundColor: kWhite,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 12,
              left: 16,
              right: 16,
              bottom: 16,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFF8C42),
                  Color(0xFFFF6B35),
                  kPrimaryColor,
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                SmallTapEffect(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  lang.S.of(context).language,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10.0),
          itemCount: languages.length,
          itemBuilder: (context, index) {
            final item = languages[index];
            final bool isSelected = selectedCode == item["code"];

            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: TappableCard(
                onTap: () {
                  setState(() {
                    selectedCode = item["code"]!;
                  });

                  languageProvider.changeLocale(item["code"]!);
                },
                child: Card(
                  elevation: 1.3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(
                        color: kBorderColorTextField, width: 0.5),
                  ),
                  child: ListTile(
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
              ),
            );
          },
        ),
          ),
        ],
      ),
    );
  }
}
