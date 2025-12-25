import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:nb_utils/nb_utils.dart';

import '../widgets/constant.dart';
import 'package:flight_booking/generated/l10n.dart' as lang;

class TicketStatus extends StatefulWidget {
  const TicketStatus({Key? key}) : super(key: key);

  @override
  State<TicketStatus> createState() => _TicketStatusState();
}

class _TicketStatusState extends State<TicketStatus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWebsiteGreyBg,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: kWebsiteGreyBg,
        title: Text(lang.S.of(context).ticketStatusTitle),
        iconTheme: const IconThemeData(color: kTitleColor),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(color: kDarkWhite),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          height: 90,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            color: kTitleColor,
            boxShadow: [
              BoxShadow(
                color: kDarkWhite,
                offset: Offset(
                  0,
                  -2,
                ),
                blurRadius: 7.0,
                spreadRadius: 2.0,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    elevation: 0.0,
                    backgroundColor: kPrimaryColor,
                  ),
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Télécharger',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: kWhite),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      FaIcon(
                        FeatherIcons.downloadCloud,
                        size: 25,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF9F9F9),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: kWhite, borderRadius: BorderRadius.circular(16.0)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 47,
                        width: 53,
                        decoration: const BoxDecoration(
                          shape: BoxShape.rectangle,
                          image: DecorationImage(
                              image: AssetImage('assets/logo.png'),
                            fit: BoxFit.contain,),
                        ),
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'E-billet',
                            style: kTextStyle.copyWith(
                                color: kTitleColor,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Réservation ID- EMT9456544',
                            style: kTextStyle.copyWith(
                                color: kSubTitleColor, fontSize: 12.0),
                          ),
                          Text(
                            'Réservation effectuée le mercredi 9 février 2023 à 14h27',
                            style: kTextStyle.copyWith(
                                color: kSubTitleColor, fontSize: 12.0),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: List.generate(
                        800 ~/ 10,
                        (index) => Expanded(
                              child: Container(
                                color: index % 2 == 0
                                    ? Colors.transparent
                                    : kPrimaryColor.withOpacity(0.5),
                                height: 1,
                              ),
                            )),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: kBorderColorTextField),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTileTheme(
                            contentPadding: const EdgeInsets.all(0),
                            dense: true,
                            horizontalTitleGap: 0.0,
                            minLeadingWidth: 0,
                            child: ListTile(
                              visualDensity: const VisualDensity(vertical: -4),
                              dense: true,
                              horizontalTitleGap: 10.0,
                              contentPadding: EdgeInsets.zero,
                              leading: Container(
                                height: 24.0,
                                width: 24.0,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: AssetImage('assets/TU.png'),
                                      fit: BoxFit.cover),
                                ),
                              ),
                              title: Text(
                                'Tunisair',
                                style: kTextStyle.copyWith(
                                    color: kTitleColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                '6E-376',
                                style:
                                    kTextStyle.copyWith(color: kSubTitleColor),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'ALG',
                                        style: kTextStyle.copyWith(
                                            color: kTitleColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                      const SizedBox(width: 5.0),
                                      Text(
                                        '15:45',
                                        style: kTextStyle.copyWith(
                                            color: kTitleColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5.0),
                                  Text(
                                    'Dim. 6 janv. 2023',
                                    style: kTextStyle.copyWith(
                                        color: kSubTitleColor, fontSize: 12),
                                  ),
                                  const SizedBox(height: 5.0),
                                  Text(
                                    'Terminal 3',
                                    style: kTextStyle.copyWith(
                                        color: kSubTitleColor, fontSize: 12),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 5.0),
                              Column(
                                children: [
                                  Text(
                                    '3h 40m',
                                    style: kTextStyle.copyWith(
                                        color: kTitleColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                  const SizedBox(height: 2.0),
                                  Row(
                                    children: [
                                      Container(
                                        height: 10.0,
                                        width: 10.0,
                                        decoration: const BoxDecoration(
                                            color: kPrimaryColor,
                                            shape: BoxShape.circle),
                                      ),
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            height: 2.0,
                                            width: 80,
                                            decoration: const BoxDecoration(
                                              color: kPrimaryColor,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(5.0),
                                            decoration: const BoxDecoration(
                                              color: kPrimaryColor,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.arrow_right_alt_outlined,
                                              size: 16,
                                              color: kWhite,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        height: 10.0,
                                        width: 10.0,
                                        decoration: BoxDecoration(
                                          color: kWhite,
                                          shape: BoxShape.circle,
                                          border:
                                              Border.all(color: kPrimaryColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2.0),
                                  Text(
                                    'Économie',
                                    style: kTextStyle.copyWith(
                                        color: kSubTitleColor, fontSize: 12),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 5.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'ALG',
                                        style: kTextStyle.copyWith(
                                            color: kTitleColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                      const SizedBox(width: 5.0),
                                      Text(
                                        '15:45',
                                        style: kTextStyle.copyWith(
                                            color: kTitleColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5.0),
                                  Text(
                                    'Dim. 6 janv. 2023',
                                    style: kTextStyle.copyWith(
                                        color: kSubTitleColor, fontSize: 12),
                                  ),
                                  const SizedBox(height: 5.0),
                                  Text(
                                    'Terminal 3',
                                    style: kTextStyle.copyWith(
                                        color: kSubTitleColor, fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(5.0),
                          decoration: const BoxDecoration(
                            color: kSecondaryColor,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.luggage,
                                color: kTitleColor,
                                size: 18,
                              ),
                              const SizedBox(width: 4),

                              Text(
                                'Bagages:',
                                style: kTextStyle.copyWith(
                                  color: kTitleColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0,
                                ),
                              ),

                              const SizedBox(width: 6),

                              Expanded(
                                child: Text(
                                  'Cabine – Contacter la compagnie aérienne',
                                  style: kTextStyle.copyWith(
                                    color: kTitleColor,
                                    fontSize: 10.0,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),

                              const SizedBox(width: 6),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Enregistrement - 30 kg',
                                    style: kTextStyle.copyWith(
                                      color: kTitleColor,
                                      fontSize: 10.0,
                                    ),
                                  ),
                                  Text(
                                    'Vérifié 50 kg',
                                    style: kTextStyle.copyWith(
                                      color: kTitleColor,
                                      fontSize: 10.0,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: List.generate(
                        800 ~/ 10,
                        (index) => Expanded(
                              child: Container(
                                color: index % 2 == 0
                                    ? Colors.transparent
                                    : kPrimaryColor.withOpacity(0.5),
                                height: 1,
                              ),
                            )),
                  ),
                  const SizedBox(height: 15.0),
                  Text(
                    'Détails du voyageur',
                    style: kTextStyle.copyWith(
                        color: kTitleColor, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: kBorderColorTextField)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Nom du passager',
                                    style: kTextStyle.copyWith(
                                        color: kSubTitleColor, fontSize: 10.0),
                                  ),
                                  const SizedBox(height: 5.0),
                                  Text(
                                    'Mr.John Doe',
                                    style: kTextStyle.copyWith(
                                        color: kTitleColor,
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'PNR de la compagnie aérienne',
                                    style: kTextStyle.copyWith(
                                        color: kSubTitleColor, fontSize: 10.0),
                                  ),
                                  const SizedBox(height: 5.0),
                                  Text(
                                    'A70G26',
                                    style: kTextStyle.copyWith(
                                        color: kTitleColor,
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Numéro de billet',
                                    style: kTextStyle.copyWith(
                                        color: kSubTitleColor, fontSize: 10.0),
                                  ),
                                  const SizedBox(height: 5.0),
                                  Text(
                                    '999458154454',
                                    style: kTextStyle.copyWith(
                                        color: kTitleColor,
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5.0),
                        const Divider(
                          thickness: 1.0,
                          color: kBorderColorTextField,
                        ),
                        const SizedBox(height: 5.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Assurance voyage',
                                    style: kTextStyle.copyWith(
                                        color: kSubTitleColor, fontSize: 10.0),
                                  ),
                                  const SizedBox(height: 5.0),
                                  Text(
                                    'Non confirmé',
                                    style: kTextStyle.copyWith(
                                        color: kTitleColor,
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Class | Cabin',
                                    style: kTextStyle.copyWith(
                                        color: kSubTitleColor, fontSize: 10.0),
                                  ),
                                  const SizedBox(height: 5.0),
                                  Text(
                                    'V | Économie',
                                    style: kTextStyle.copyWith(
                                        color: kTitleColor,
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Statut',
                                    style: kTextStyle.copyWith(
                                        color: kSubTitleColor, fontSize: 10.0),
                                  ),
                                  const SizedBox(height: 5.0),
                                  Text(
                                    'Confirmer',
                                    style: kTextStyle.copyWith(
                                        color: Colors.green,
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: List.generate(
                        800 ~/ 10,
                        (index) => Expanded(
                              child: Container(
                                color: index % 2 == 0
                                    ? Colors.transparent
                                    : kPrimaryColor.withOpacity(0.5),
                                height: 1,
                              ),
                            )),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    width: context.width(),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: kBorderColorTextField)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Résumé des tarifs',
                          style: kTextStyle.copyWith(
                            color: kTitleColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                'Tarif de base',
                                style: kTextStyle.copyWith(
                                  color: kSubTitleColor,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  Text(
                                    ':',
                                    style: kTextStyle.copyWith(
                                      color: kSubTitleColor,
                                    ),
                                  ),
                                  const SizedBox(width: 20.0),
                                  Text(
                                    '${13000} $currencySign',
                                    style: kTextStyle.copyWith(
                                      color: kSubTitleColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                'Impôts',
                                style: kTextStyle.copyWith(
                                  color: kSubTitleColor,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  Text(
                                    ':',
                                    style: kTextStyle.copyWith(
                                      color: kSubTitleColor,
                                    ),
                                  ),
                                  const SizedBox(width: 20.0),
                                  Text(
                                    '${2000} $currencySign',
                                    style: kTextStyle.copyWith(
                                      color: kSubTitleColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                'Frais de report',
                                style: kTextStyle.copyWith(
                                  color: kSubTitleColor,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  Text(
                                    ':',
                                    style: kTextStyle.copyWith(
                                      color: kSubTitleColor,
                                    ),
                                  ),
                                  const SizedBox(width: 20.0),
                                  Text(
                                    '${0} $currencySign',
                                    style: kTextStyle.copyWith(
                                      color: kSubTitleColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                'K3',
                                style: kTextStyle.copyWith(
                                  color: kSubTitleColor,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  Text(
                                    ':',
                                    style: kTextStyle.copyWith(
                                      color: kSubTitleColor,
                                    ),
                                  ),
                                  const SizedBox(width: 20.0),
                                  Text(
                                    '${0} $currencySign',
                                    style: kTextStyle.copyWith(
                                      color: kSubTitleColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                'Offre de coupon',
                                style: kTextStyle.copyWith(
                                  color: kPrimaryColor,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  Text(
                                    ':',
                                    style: kTextStyle.copyWith(
                                      color: kSubTitleColor,
                                    ),
                                  ),
                                  const SizedBox(width: 20.0),
                                  Text(
                                    '${500} $currencySign',
                                    style: kTextStyle.copyWith(
                                      color: kSubTitleColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                'Totale',
                                style: kTextStyle.copyWith(
                                    color: kTitleColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Row(
                                children: [
                                  Text(
                                    ':',
                                    style: kTextStyle.copyWith(
                                      color: kSubTitleColor,
                                    ),
                                  ),
                                  const SizedBox(width: 20.0),
                                  Text(
                                    '${14500} $currencySign',
                                    style: kTextStyle.copyWith(
                                        color: kTitleColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              height: 52,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8.0),
                                ),
                                color: kSecondaryColor,
                                border:
                                    Border.all(color: kBorderColorTextField),
                              ),
                              child: Text(
                                'Algiers - Tunis',
                                textAlign: TextAlign.center,
                                style: kTextStyle.copyWith(
                                    color: kTitleColor, fontSize: 12),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: 52,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(8.0),
                                ),
                                color: kSecondaryColor,
                                border:
                                    Border.all(color: kBorderColorTextField),
                              ),
                              child: Text(
                                'Frais d\'annulation',
                                textAlign: TextAlign.center,
                                style: kTextStyle.copyWith(
                                    color: kTitleColor, fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    height: 52,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: kSecondaryColor,
                                      border: Border.all(
                                          color: kBorderColorTextField),
                                    ),
                                    child: Text(
                                      'Type',
                                      textAlign: TextAlign.center,
                                      style: kTextStyle.copyWith(
                                          color: kTitleColor, fontSize: 12),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    height: 52,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: kSecondaryColor,
                                      border: Border.all(
                                          color: kBorderColorTextField),
                                    ),
                                    child: Text(
                                      'Délai d''annulation',
                                      textAlign: TextAlign.center,
                                      style: kTextStyle.copyWith(
                                          color: kSubTitleColor, fontSize: 12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: 52,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: kSecondaryColor,
                                border:
                                    Border.all(color: kBorderColorTextField),
                              ),
                              child: Text(
                                'Compagnie aérienne',
                                textAlign: TextAlign.center,
                                style: kTextStyle.copyWith(
                                    color: kSubTitleColor, fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    height: 52,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: kWhite,
                                      border: Border.all(
                                          color: kBorderColorTextField),
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(8.0),
                                      ),
                                    ),
                                    child: Text(
                                      'ADT',
                                      textAlign: TextAlign.center,
                                      style: kTextStyle.copyWith(
                                          color: kTitleColor, fontSize: 12),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    height: 52,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: kWhite,
                                      border: Border.all(
                                          color: kBorderColorTextField),
                                    ),
                                    child: Text(
                                      'Quatre heures avant le départ du vol',
                                      textAlign: TextAlign.center,
                                      style: kTextStyle.copyWith(
                                          color: kSubTitleColor, fontSize: 12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: 52,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: kWhite,
                                borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(8.0),
                                ),
                                border:
                                    Border.all(color: kBorderColorTextField),
                              ),
                              child: Text(
                                'Conformément aux conditions générales des compagnies aériennes',
                                textAlign: TextAlign.center,
                                style: kTextStyle.copyWith(
                                    color: kSubTitleColor, fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    width: context.width(),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: kBorderColorTextField)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Conditions générales',
                          style: kTextStyle.copyWith(
                            color: kTitleColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10.0),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(MdiIcons.circleMedium, color: kSubTitleColor, size: 20),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                'Description du service à venir.',
                                style: kTextStyle.copyWith(
                                  color: kSubTitleColor,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(MdiIcons.circleMedium, color: kSubTitleColor, size: 20),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                'Aucune information supplémentaire n’est disponible pour le moment.',
                                style: kTextStyle.copyWith(
                                  color: kSubTitleColor,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(MdiIcons.circleMedium, color: kSubTitleColor, size: 20),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                'Les informations peuvent varier selon la compagnie aérienne.',
                                style: kTextStyle.copyWith(
                                  color: kSubTitleColor,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(MdiIcons.circleMedium, color: kSubTitleColor, size: 20),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                'Veuillez vérifier les détails fournis avant de confirmer votre réservation.',
                                style: kTextStyle.copyWith(
                                  color: kSubTitleColor,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(MdiIcons.circleMedium, color: kSubTitleColor, size: 20),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                'Consultez les informations de votre vol et les services inclus avant de continuer.',
                                style: kTextStyle.copyWith(
                                  color: kSubTitleColor,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],

                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
