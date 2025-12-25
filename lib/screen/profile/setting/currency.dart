import 'package:flag/flag_widget.dart';
import 'package:flight_booking/screen/widgets/constant.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Currency extends StatefulWidget {
  const Currency({Key? key}) : super(key: key);

  @override
  State<Currency> createState() => _CurrencyState();
}

class _CurrencyState extends State<Currency> {
  List<String> baseFlagsCode = ['dz'];

  List<Map<String, String>> currencies = [
    {
      'name': 'Algeria',
      'code': 'DZD',
      'symbol': 'دج',
      'flag': 'dz',
    }
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
    final symbol = prefs.getString('currency_symbol');

    if (code != null && symbol != null) {
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
    return Scaffold(
      backgroundColor: kWebsiteGreyBg,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: kWhite),
        title: const Text('Currency', style: TextStyle(color: kTitleColor)),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
        ),
        child: ListView.builder(
          itemCount: currencies.length,
          itemBuilder: (_, index) {
            final item = currencies[index];
            final isSelected = selected['code'] == item['code'];

            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListTile(
                onTap: () async {
                  setState(() => selected = item);
                  await _saveCurrency(item);
                  Navigator.pop(context, item); // 👈 return value
                },
                leading: Flag.fromString(item['flag']!, height: 25, width: 30),
                title: Text(
                  '${item['name']} (${item['code']}) - ${item['symbol']}',
                  style: TextStyle(
                    color: isSelected ? kTitleColor : kSubTitleColor,
                  ),
                ),
                trailing: Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.circle_outlined,
                  color: isSelected ? kPrimaryColor : kSubTitleColor,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
