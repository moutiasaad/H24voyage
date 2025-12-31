import 'package:flight_booking/screen/home/home.dart';
import 'package:flight_booking/screen/my_boking_screen/my_boking.dart';
import 'package:flight_booking/screen/widgets/button_global.dart';
import 'package:flight_booking/screen/widgets/constant.dart';
import 'package:flutter/material.dart';
import 'package:flight_booking/generated/l10n.dart' as lang;
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../ticket status/ticket_status.dart';

class PaymentMethod extends StatefulWidget {
  const PaymentMethod({Key? key}) : super(key: key);

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String cardNumber = '546787667938746';
  String expiryDate = '05/31';
  String cardHolderName = 'Johen Doe';
  String cvvCode = '736';
  bool isCvvFocused = false;
  bool isChecked = false;

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNumber = creditCardModel!.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  void showSuccessPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 118.0,
                  width: 133.0,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/success_orange.png'),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Text(
                  'Paiement réussi!',
                  style: kTextStyle.copyWith(
                    color: kTitleColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 21,
                  ),
                ),
                Text(
                  'Merci d''avoir acheté le billet!',
                  textAlign: TextAlign.center,
                  style: kTextStyle.copyWith(color: kSubTitleColor),
                ),
                const SizedBox(height: 10.0),
                ButtonGlobalWithoutIcon(
                  buttontext: 'Voir le billet ',
                  buttonDecoration: kButtonDecoration.copyWith(color: kPrimaryColor),
                  onPressed: () {
                    setState(() {
                      finish(context);
                      const TicketStatus().launch(context);
                    });
                  },
                  buttonTextColor: kTitleColor,
                ),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const Home(initialIndex: 1), // ✅ MyBooking
                        ),
                            (route) => false,
                      );
                      // const Home().launch(context);
                      // finish(context);
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        FeatherIcons.arrowLeft,
                        color: kSubTitleColor,
                      ),
                      Text(
                        'Retour à l''accueil',
                        textAlign: TextAlign.center,
                        style: kTextStyle.copyWith(color: kSubTitleColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWebsiteGreyBg,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: kWebsiteGreyBg,
        title: Text(lang.S.of(context).paymentMethod),
        iconTheme: const IconThemeData(color: kTitleColor),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: const BoxDecoration(
          color: kTitleColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10.0),
            Text(
              lang.S.of(context).paymentCardTitle,
              style: kTextStyle.copyWith(color: kTitleColor, fontWeight: FontWeight.bold),
            ),
            CreditCardWidget(
              // padding: AppConstants.creditCardPadding,
              backgroundImage: 'images/card1.png',
              textStyle: kTextStyle.copyWith(fontSize: 10.0, color: Colors.white),
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              showBackView: isCvvFocused,
              obscureCardNumber: true,
              obscureCardCvv: true,
              isHolderNameVisible: true,
              cardBgColor: Colors.deepOrangeAccent,
              isSwipeGestureEnabled: true,
              onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
            ),
            Row(
              children: [
                Checkbox(
                  activeColor: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                  value: isChecked,
                  onChanged: (val) {
                    setState(
                      () {
                        isChecked = val!;
                      },
                    );
                  },
                ),
                Text(
                  'Utiliser comme moyen de paiement',
                  style: kTextStyle.copyWith(color: kTitleColor),
                ),
              ],
            ),
            CreditCardWidget(
              padding: 5,
              backgroundImage: 'images/card1.png',
              textStyle: kTextStyle.copyWith(fontSize: 10.0, color: Colors.white),
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              showBackView: isCvvFocused,
              obscureCardNumber: true,
              obscureCardCvv: true,
              isHolderNameVisible: true,
              cardBgColor: Colors.deepOrangeAccent,
              isSwipeGestureEnabled: true,
              onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
            ),
            Row(
              children: [
                Checkbox(
                  activeColor: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                  value: isChecked,
                  onChanged: (val) {
                    setState(
                      () {
                        isChecked = val!;
                      },
                    );
                  },
                ),
                Text(
                  'Utiliser comme moyen de paiement',
                  style: kTextStyle.copyWith(color: kTitleColor),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: kWhite,
        ),
        child: ButtonGlobalWithoutIcon(
          buttontext: 'Payer',
          buttonDecoration: kButtonDecoration.copyWith(
            color: kWebsiteGreyBg,
            borderRadius: BorderRadius.circular(30.0),
          ),
          onPressed: () {
            setState(() {
              showSuccessPopup();
            });
          },
          buttonTextColor: kTitleColor,
        ),
      ),
    );
  }
}
