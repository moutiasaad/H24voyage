import 'package:community_material_icon/community_material_icon.dart';
import 'package:flight_booking/screen/profile/Privacy_Policy/privicy_policy.dart';
import 'package:flight_booking/screen/profile/my_profile/my_profile.dart';
import 'package:flight_booking/screen/profile/payments/paymetns.dart';
import 'package:flight_booking/screen/profile/setting/setting.dart';
import 'package:flutter/material.dart';
// import 'package:flight_booking/generated/l10n.dart' as lang;
import 'package:nb_utils/nb_utils.dart';

import '../../generated/l10n.dart' as lang;
import '../Authentication/welcome_screen.dart';
import '../widgets/constant.dart';



class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    // final t = lang.S.of(context);

    return Scaffold(
      backgroundColor: kWebsiteGreyBg,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: kWhite),
        title: Text(
          lang.S.of(context).profileTitle,
          style: kTextStyle.copyWith(color: kTitleColor ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          width: double.infinity,
          decoration: const BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              topLeft: Radius.circular(30),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // 👤 Avatar
              Center(
                child: Container(
                  height: 80.0,
                  width: 80.0,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('images/profile1.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              const Center(
                child: Text(
                  'Johen Doe',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              const SizedBox(height: 5),
              Center(
                child: Text(
                  'johendoe@gmail.com',
                  style: kTextStyle.copyWith(fontSize: 14, color: kSubTitleColor),
                ),
              ),
              const SizedBox(height: 30),

              // 👤 My Profile
              _profileTile(
                context,
                icon: Icons.person,
                color: kPrimaryColor,
                bg: kPrimaryColor.withOpacity(0.2),
                title: lang.S.of(context).profileMyProfile,
                onTap: () => const MyProfile().launch(context),
              ),

              // ⚙ Setting
              _profileTile(
                context,
                icon: Icons.settings,
                color: const Color(0xff00CD46),
                bg: const Color(0xff009F5E).withOpacity(0.2),
                title: lang.S.of(context).profileSetting,
                onTap: () => const Setting().launch(context),
              ),

              // 💳 Payments
              _profileTile(
                context,
                icon: Icons.payment_rounded,
                color: kPrimaryColor,
                bg: kPrimaryColor.withOpacity(0.2),
                title: lang.S.of(context).profilePayments,
                onTap: () => const ProfilePayments().launch(context),
              ),

              // 🔐 Privacy Policy
              _profileTile(
                context,
                icon: CommunityMaterialIcons.alert_circle,
                color: const Color(0xff00CD46),
                bg: const Color(0xff009F5E).withOpacity(0.1),
                title: lang.S.of(context).profilePrivacy,
                onTap: () => const PrivacyPolicy().launch(context),
              ),

              // 📤 Share App
              _profileTile(
                context,
                icon: Icons.share,
                color: const Color(0xffFF3B30),
                bg: const Color(0xffFF3B30).withOpacity(0.1),
                title: lang.S.of(context).profileShare,
                onTap: () {},
              ),

              // 🚪 Log Out
              _profileTile(
                context,
                icon: Icons.logout,
                color: kPrimaryColor,
                bg: kPrimaryColor.withOpacity(0.2),
                title: lang.S.of(context).profileLogout,
                onTap: () {
                  const WelcomeScreen().launch(context, isNewTask: true);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileTile(
      BuildContext context, {
        required IconData icon,
        required Color color,
        required Color bg,
        required String title,
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
            child: Icon(icon, color: color),
          ),
          title: Text(title, style: kTextStyle.copyWith(color: kTitleColor)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: kSubTitleColor),
        ),
      ),
    );
  }
}

