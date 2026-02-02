import 'package:flight_booking/screen/Authentication/sign_up_screen.dart';
import 'package:flight_booking/screen/widgets/constant.dart';
import 'package:flutter/material.dart';
import 'package:flight_booking/generated/l10n.dart' as lang;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nb_utils/nb_utils.dart';

import '../home/home.dart';
import '../widgets/button_global.dart';
import '../widgets/icon.dart';
import 'forgot_password.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  bool hidePassword = true;
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardOpen = keyboardHeight > 0;
    final isSmallScreen = screenHeight < 700;
    final isVerySmallScreen = screenHeight < 600;

    // Responsive sizes
    final logoHeight = isKeyboardOpen ? 0.0 : (isVerySmallScreen ? 50.0 : (isSmallScreen ? 60.0 : 70.0));
    final logoWidth = isKeyboardOpen ? 0.0 : (isVerySmallScreen ? 110.0 : (isSmallScreen ? 130.0 : 150.0));
    final titleSize = isVerySmallScreen ? 16.0 : 18.0;
    final inputVerticalPadding = isVerySmallScreen ? 12.0 : 16.0;
    final buttonRadius = 30.0;

    return Scaffold(
      backgroundColor: kWebsiteGreyBg,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kWebsiteGreyBg,
        centerTitle: true,
        title: Text(lang.S.of(context).loginButton),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: kTitleColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            // Logo - hide when keyboard is open
            if (!isKeyboardOpen) ...[
              SizedBox(height: isVerySmallScreen ? 6 : 10),
              Center(
                child: Container(
                  height: logoHeight,
                  width: logoWidth,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/logo.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              SizedBox(height: isVerySmallScreen ? 12 : 20),
            ],

            // Main content container
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: isVerySmallScreen ? 12 : 16,
                ),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: kWhite,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: Column(
                  children: [
                    // Title
                    if (!isKeyboardOpen || isVerySmallScreen) ...[
                      SizedBox(height: isVerySmallScreen ? 4 : 8),
                      Text(
                        lang.S.of(context).loginTitle,
                        style: kTextStyle.copyWith(
                          color: kTitleColor,
                          fontWeight: FontWeight.bold,
                          fontSize: titleSize,
                        ),
                      ),
                      SizedBox(height: isVerySmallScreen ? 16 : 30),
                    ],

                    // Email field
                    TextFormField(
                      focusNode: _emailFocusNode,
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: kTitleColor,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_passwordFocusNode);
                      },
                      decoration: kInputDecoration.copyWith(
                        labelText: lang.S.of(context).emailLabel,
                        labelStyle: kTextStyle.copyWith(color: kTitleColor),
                        hintText: lang.S.of(context).emailHint,
                        hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                        focusColor: kTitleColor,
                        border: const OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: inputVerticalPadding,
                        ),
                      ),
                    ),

                    SizedBox(height: isVerySmallScreen ? 12 : 18),

                    // Password field
                    TextFormField(
                      focusNode: _passwordFocusNode,
                      cursorColor: kTitleColor,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: hidePassword,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).unfocus();
                      },
                      decoration: kInputDecoration.copyWith(
                        border: const OutlineInputBorder(),
                        labelText: lang.S.of(context).passwordLabel,
                        labelStyle: kTextStyle.copyWith(color: kTitleColor),
                        hintText: lang.S.of(context).passwordHint,
                        hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: inputVerticalPadding,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              hidePassword = !hidePassword;
                            });
                          },
                          icon: Icon(
                            hidePassword ? Icons.visibility_off : Icons.visibility,
                            color: kSubTitleColor,
                            size: 22,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: isVerySmallScreen ? 6 : 10),

                    // Forgot password
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () => const ForgotPassword().launch(context),
                          child: Text(
                            lang.S.of(context).forgotPassword,
                            style: kTextStyle.copyWith(
                              color: kPrimaryColor,
                              fontSize: isVerySmallScreen ? 13.0 : 14.0,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: isVerySmallScreen ? 14 : 20),

                    // Login button
                    ButtonGlobalWithoutIcon(
                      buttontext: lang.S.of(context).loginButton,
                      buttonDecoration: kButtonDecoration.copyWith(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(buttonRadius),
                      ),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        const Home().launch(context);
                      },
                      buttonTextColor: kWhite,
                    ),

                    // Flexible space
                    Flexible(flex: 1, child: const SizedBox()),

                    // Social login section - hide when keyboard is open
                    if (!isKeyboardOpen) ...[
                      Row(
                        children: [
                          const Expanded(
                            child: Divider(thickness: 1.0, color: kBorderColorTextField),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              lang.S.of(context).orSignUpTitle,
                              style: kTextStyle.copyWith(
                                color: kSubTitleColor,
                                fontSize: isVerySmallScreen ? 12.0 : 14.0,
                              ),
                            ),
                          ),
                          const Expanded(
                            child: Divider(thickness: 1.0, color: kBorderColorTextField),
                          ),
                        ],
                      ),

                      SizedBox(height: isVerySmallScreen ? 14 : 20),

                      // Social icons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SocialIcon(
                            bgColor: kTitleColor,
                            iconColor: kWhite,
                            icon: FontAwesomeIcons.facebookF,
                            borderColor: Colors.transparent,
                          ),
                          const SizedBox(width: 20.0),
                          SocialIcon(
                            bgColor: kWhite,
                            iconColor: kTitleColor,
                            icon: FontAwesomeIcons.google,
                            borderColor: kBorderColorTextField,
                          ),
                        ],
                      ),

                      SizedBox(height: isVerySmallScreen ? 8 : 12),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(color: kWhite),
        child: SafeArea(
          child: SizedBox(
            height: isVerySmallScreen ? 44 : 50,
            child: GestureDetector(
              onTap: () => const SignUp().launch(context),
              child: Center(
                child: RichText(
                  text: TextSpan(
                    text: lang.S.of(context).noAccTitle1,
                    style: kTextStyle.copyWith(
                      color: kSubTitleColor,
                      fontSize: isVerySmallScreen ? 13.0 : 14.0,
                    ),
                    children: [
                      TextSpan(
                        text: lang.S.of(context).noAccTitle2,
                        style: kTextStyle.copyWith(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: isVerySmallScreen ? 13.0 : 14.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
