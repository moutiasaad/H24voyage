import 'package:flight_booking/generated/l10n.dart' as lang;
import 'package:flight_booking/screen/Authentication/sign_up_screen.dart';
import 'package:flight_booking/screen/widgets/button_global.dart';
import 'package:flight_booking/screen/widgets/constant.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import '../home/home.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive sizes based on Figma: 377x786
    final ratioW = screenWidth / 377;
    final ratioH = screenHeight / 786;
    final imageWidth = 320 * ratioW;
    final imageHeight = 300 * ratioH;
    final titleSize = (18 * ratioW).clamp(14.0, 22.0);
    final subtitleSize = (13 * ratioW).clamp(11.0, 14.0);
    final buttonHeight = (50 * ratioH).clamp(42.0, 54.0);
    final buttonTextSize = (15 * ratioW).clamp(13.0, 15.0);
    final horizontalPadding = screenWidth * 0.06;
    final isVerySmallScreen = screenHeight < 640;

    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 8 * ratioH),
                        // Top section: Image + Title + Subtitle
                        Column(
                        children: [
                          Center(
                            child: Image.asset(
                              'assets/auth.png',
                              width: imageWidth,
                              height: imageHeight,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: imageWidth,
                                  height: imageHeight * 0.7,
                                  color: kSecondaryColor,
                                  child: Center(
                                    child: Icon(
                                      Icons.image,
                                      size: imageHeight * 0.3,
                                      color: kSubTitleColor,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          SizedBox(height: 12 * ratioH),

                          // Title
                          Center(
                            child: Text(
                              lang.S.of(context).welcomeTitle,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: kTitleColor,
                                fontSize: titleSize,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),

                          SizedBox(height: 6 * ratioH),

                          // Subtitle
                          Text(
                            lang.S.of(context).welcomeSubtitle,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: kTitleColor,
                              fontSize: subtitleSize,
                              fontWeight: FontWeight.w700,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 24 * ratioH),

                      // Middle section: Buttons
                      Column(
                        children: [
                          // Skip Button - Continue without login (top)
                          TappableCard(
                            onTap: () async {
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.setBool('has_opened_before', true);
                              if (!context.mounted) return;
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => const Home()),
                                (route) => false,
                              );
                            },
                            scaleFactor: 0.97,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2F2F2),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Container(
                              width: double.infinity,
                              height: buttonHeight,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.arrow_forward_rounded,
                                    color: Color(0xFF333333),
                                    size: 22,
                                  ),
                                  const SizedBox(width: 10),
                                  Flexible(
                                    child: Text(
                                      lang.S.of(context).welcomeSkipLogin,
                                      style: GoogleFonts.poppins(
                                        color: const Color(0xFF333333),
                                        fontSize: buttonTextSize,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 12 * ratioH),

                          // Primary Button - Email Login
                          TappableCard(
                            onTap: () async {
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.setBool('has_opened_before', true);
                              if (!context.mounted) return;
                              const SignUp().launch(context);
                            },
                            scaleFactor: 0.97,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF6A00),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 14,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Container(
                              width: double.infinity,
                              height: buttonHeight,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/e-mail 2.png',
                                    width: 22,
                                    height: 22,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.email_outlined,
                                        color: kWhite,
                                        size: 22,
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 10),
                                  Flexible(
                                    child: Text(
                                      lang.S.of(context).welcomeContinueEmail,
                                      style: GoogleFonts.poppins(
                                        color: kWhite,
                                        fontSize: buttonTextSize,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 12 * ratioH),

                          // Secondary Button - Google Login
                          TappableCard(
                            onTap: () async {
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.setBool('has_opened_before', true);
                              if (!context.mounted) return;
                              const Home().launch(context);
                            },
                            scaleFactor: 0.97,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2F2F2),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Container(
                              width: double.infinity,
                              height: buttonHeight,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/gmail 2.png',
                                    width: 22,
                                    height: 22,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Text(
                                        'G',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 10),
                                  Flexible(
                                    child: Text(
                                      lang.S.of(context).welcomeContinueGoogle,
                                      style: GoogleFonts.poppins(
                                        color: const Color(0xFF333333),
                                        fontSize: buttonTextSize,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        ],
                      ),

                      const Spacer(),

                      // Bottom section: "Pas de compte?" + Terms + Copyright
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                lang.S.of(context).noAccTitle1,
                                style: GoogleFonts.lato(
                                  color: kSubTitleColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  height: 22 / 14,
                                ),
                              ),
                              TapEffect(
                                onTap: () => const SignUp().launch(context),
                                child: Text(
                                  lang.S.of(context).signUpRegister,
                                  style: GoogleFonts.lato(
                                    color: kPrimaryColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    height: 22 / 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8 * ratioH),
                          Text(
                            isVerySmallScreen
                                ? lang.S.of(context).signUpTermsShort
                                : lang.S.of(context).welcomeTermsIntro,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: kSubTitleColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              height: 20 / 11,
                            ),
                          ),
                          const SizedBox(height: 2),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: GoogleFonts.poppins(
                                color: kSubTitleColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                height: 20 / 11,
                              ),
                              children: [
                                TextSpan(text: lang.S.of(context).welcomeTermsOur),
                                TextSpan(
                                  text: lang.S.of(context).welcomeTermsConditions,
                                  style: GoogleFonts.poppins(
                                    color: kPrimaryColor,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400,
                                    height: 20 / 11,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      // Open terms and conditions
                                    },
                                ),
                                TextSpan(text: lang.S.of(context).welcomeTermsAnd),
                                TextSpan(
                                  text: lang.S.of(context).welcomePrivacyPolicy,
                                  style: GoogleFonts.poppins(
                                    color: kPrimaryColor,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400,
                                    height: 20 / 11,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      // Open privacy policy
                                    },
                                ),
                                TextSpan(text: '.'),
                              ],
                            ),
                          ),
                          SizedBox(height: 6 * ratioH),
                          Text(
                            lang.S.of(context).welcomeCopyright,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: kSubTitleColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              height: 20 / 11,
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),
                    ],
                  ),
                ),
              ),
              )
            );
          },
        ),
      ),
    );
  }
}
