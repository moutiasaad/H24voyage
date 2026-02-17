import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flight_booking/generated/l10n.dart' as lang;
import '../../widgets/constant.dart';
import '../../widgets/button_global.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = lang.S.of(context);

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
                  t.privacyPolicyTitle,
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.privacyPolicyIntroduction,
                      style: kTextStyle.copyWith(color: kSubTitleColor, height: 1.5)),
                  const SizedBox(height: 20),

                  // Information Collection
                  Text(t.privacyInfoCollectionTitle,
                      style: kTextStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 8),
                  Text(
                    t.privacyInfoCollection,
                    style: kTextStyle.copyWith(color: kSubTitleColor, height: 1.5),
                  ),
                  const SizedBox(height: 20),

                  // Use of Information
                  Text(t.privacyUseTitle,
                      style: kTextStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 8),
                  Text(
                    t.privacyUse,
                    style: kTextStyle.copyWith(color: kSubTitleColor, height: 1.5),
                  ),
                  const SizedBox(height: 20),

                  // Sharing Data
                  Text(t.privacySharingTitle,
                      style: kTextStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 8),
                  Text(
                    t.privacySharing,
                    style: kTextStyle.copyWith(color: kSubTitleColor, height: 1.5),
                  ),
                  const SizedBox(height: 20),

                  // Security
                  Text(t.privacySecurityTitle,
                      style: kTextStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 8),
                  Text(
                    t.privacySecurity,
                    style: kTextStyle.copyWith(color: kSubTitleColor, height: 1.5),
                  ),
                  const SizedBox(height: 20),

                  // Contact
                  Text(t.privacyContactTitle,
                      style: kTextStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 8),
                  Text(
                    t.privacyContact,
                    style: kTextStyle.copyWith(color: kSubTitleColor, height: 1.5),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
