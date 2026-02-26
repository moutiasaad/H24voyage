import 'package:flag/flag_widget.dart';
import 'package:flight_booking/generated/l10n.dart' as lang;
import 'package:flight_booking/screen/widgets/constant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Currency extends StatefulWidget {
  const Currency({Key? key}) : super(key: key);

  @override
  State<Currency> createState() => _CurrencyState();
}

class _CurrencyState extends State<Currency> {
  List<Map<String, String>> currencies = [
    {
      'key': 'currencyAlgeria',
      'code': 'DZD',
      'symbol': 'دج',
      'flag': 'dz',
    },
  ];

  late Map<String, String> selected;

  @override
  void initState() {
    super.initState();
    selected = currencies.first;
    _loadCurrency();
  }

  Future<void> _loadCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString('currency_code');

    if (code != null) {
      setState(() {
        selected = currencies.firstWhere(
              (e) => e['code'] == code,
          orElse: () => currencies.first,
        );
      });
    }
  }

  Future<void> _saveCurrency(Map<String, String> cur) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currency_code', cur['code']!);
    await prefs.setString('currency_symbol', cur['symbol']!);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = lang.S.of(context);

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
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.profileCurrencies,
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
              itemCount: currencies.length,
              itemBuilder: (_, index) {
                final item = currencies[index];
                final isSelected = selected['code'] == item['code'];

                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      onTap: () async {
                        setState(() => selected = item);
                        await _saveCurrency(item);
                        Navigator.pop(context, item);
                      },
                      leading: Flag.fromString(
                        item['flag']!,
                        height: 25,
                        width: 30,
                      ),
                      title: Text(
                        '${_getLocalizedCurrencyName(item['key']!, l10n)} '
                            '(${item['code']}) - ${item['symbol']}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: isSelected ? kPrimaryColor : kTitleColor,
                        ),
                      ),
                      trailing: Icon(
                        isSelected
                            ? Icons.radio_button_checked
                            : Icons.circle_outlined,
                        color:
                        isSelected ? kPrimaryColor : kSubTitleColor,
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

  String _getLocalizedCurrencyName(String key, lang.S l10n) {
    switch (key) {
      case 'currencyAlgeria':
        return l10n.currencyAlgeria;
      case 'currencyFrance':
        return l10n.currencyFrance;
      case 'currencyTunisia':
        return l10n.currencyTunisia;
      default:
        return '';
    }
  }
}
