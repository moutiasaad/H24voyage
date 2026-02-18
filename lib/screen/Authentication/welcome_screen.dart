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
                              'Connectez-vous pour économiser',
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
                            'Connectez-vous pour économiser au moins\n10 % grâce à une adhésion gratuite à h24voyages',
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
                          // Primary Button - Email Login
                          TappableCard(
                            onTap: () => const SignUp().launch(context),
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
                                      'Continuer via l\'adresse e-mail',
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
                            onTap: () => const Home().launch(context),
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
                                      'Continuer avec Google',
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

                          SizedBox(height: 24 * ratioH),

                          // Skip button
                          TextButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => const Home()),
                                (route) => false,
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              splashFactory: InkSparkle.splashFactory,
                              overlayColor: kPrimaryColor.withOpacity(0.08),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Continuer sans connexion',
                                  style: GoogleFonts.poppins(
                                    color: kSubTitleColor,
                                    fontSize: subtitleSize,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: kSubTitleColor,
                                  size: subtitleSize,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      // Bottom section: Footer
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'En créant ou en vous connectant à un compte, vous acceptez',
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
                                const TextSpan(text: 'nos '),
                                TextSpan(
                                  text: 'conditions générales',
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
                                const TextSpan(text: ' et notre '),
                                TextSpan(
                                  text: 'charte de confidentialité',
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
                                const TextSpan(text: '.'),
                              ],
                            ),
                          ),

                          SizedBox(height: 6 * ratioH),

                          // Copyright
                          Text(
                            'Tous droits réservés. Copyright- h24voyages',
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
