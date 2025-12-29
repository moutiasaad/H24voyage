import 'package:country_code_picker/country_code_picker.dart';
import 'package:flight_booking/screen/profile/my_profile/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'dart:io';
import '../../widgets/constant.dart';
import 'package:flight_booking/generated/l10n.dart' as lang;

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final ImagePicker _picker = ImagePicker();
  XFile? image;

  // 🔁 Dynamic user data (later you can load from backend)
  String fullName = 'John Doe';
  String email = 'johendoe@gmail.com';
  String phone = '017XXXXXXXX';

  Future<void> getImage() async {
    image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final t = lang.S.of(context);

    return Scaffold(
      backgroundColor: kWebsiteGreyBg,

      // 🔘 Bottom button
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 90,
        color: kWhite,
        child: Center(
          child: SizedBox(
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                elevation: 0,
                backgroundColor: kWebsiteGreyBg,
              ),
              onPressed: () {
                const EditProfile().launch(context);
              },
              child: Text(
                t.editButton, // ✅ translated
                style: kTextStyle.copyWith(color: kWhite),
              ),
            ),
          ),
        ),
      ),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: kWhite),
        title: Text(
          t.myProfileTitle, // ✅ translated
          style: kTextStyle.copyWith(color: kTitleColor),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          height: context.height(),
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
              const SizedBox(height: 25),

              // 👤 Avatar
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      image: image == null
                          ? const DecorationImage(
                        image: AssetImage('assets/logo.png'),
                        fit: BoxFit.cover,
                      )
                          : DecorationImage(
                        image: FileImage(File(image!.path)),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: kWhite),
                    ),
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      size: 17,
                      color: kWhite,
                    ).onTap(getImage),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // 👤 Name
              Text(
                fullName,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),

              const SizedBox(height: 5),

              // 📧 Email
              Text(
                email,
                style: kTextStyle.copyWith(fontSize: 14, color: kSubTitleColor),
              ),

              const SizedBox(height: 25),

              // 📋 Info form
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  ),
                  color: kWhite,
                  boxShadow: [
                    BoxShadow(
                      color: kDarkWhite,
                      offset: Offset(0, -2),
                      blurRadius: 7,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      AppTextField(
                        cursorColor: kTitleColor,
                        textFieldType: TextFieldType.NAME,
                        initialValue: fullName,
                        decoration: kInputDecoration.copyWith(
                          labelText: t.fullNameLabel, // ✅ translated
                        ),
                      ),

                      const SizedBox(height: 20),

                      AppTextField(
                        cursorColor: kTitleColor,
                        textFieldType: TextFieldType.EMAIL,
                        initialValue: email,
                        decoration: kInputDecoration.copyWith(
                          labelText: t.emailLabel, // ✅ translated
                        ),
                      ),

                      const SizedBox(height: 20),

                      AppTextField(
                        cursorColor: kTitleColor,
                        textFieldType: TextFieldType.PHONE,
                        initialValue: phone,
                        decoration: kInputDecoration.copyWith(
                          labelText: t.phoneLabel, // ✅ translated
                          prefixIcon: const CountryCodePicker(
                            showFlag: true,
                            initialSelection: 'DZ',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
