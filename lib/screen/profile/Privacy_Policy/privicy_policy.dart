import 'package:flutter/material.dart';
import 'package:flight_booking/generated/l10n.dart' as lang;
import '../../widgets/constant.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = lang.S.of(context);

    return Scaffold(
      backgroundColor: kWebsiteGreyBg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: kTitleColor),
        title: Text(t.privacyPolicyTitle, style: kTextStyle.copyWith(color: kTitleColor)),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
          child: SingleChildScrollView(
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
      ),
    );
  }
}
