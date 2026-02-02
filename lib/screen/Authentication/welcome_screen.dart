import 'package:flight_booking/screen/Authentication/sign_up_screen.dart';
import 'package:flight_booking/screen/widgets/constant.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import '../home/home.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _isEmailPressed = false;
  bool _isGooglePressed = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final safeAreaTop = MediaQuery.of(context).padding.top;
    final safeAreaBottom = MediaQuery.of(context).padding.bottom;
    final availableHeight = screenHeight - safeAreaTop - safeAreaBottom;

    final isVerySmallScreen = availableHeight < 550;
    final isSmallScreen = availableHeight < 650;

    // Responsive sizes based on available height
    final imageHeight = (availableHeight * 0.22).clamp(100.0, 200.0);
    final titleSize = isVerySmallScreen ? 16.0 : (isSmallScreen ? 18.0 : 22.0);
    final subtitleSize = isVerySmallScreen ? 11.0 : (isSmallScreen ? 12.0 : 14.0);
    final buttonHeight = isVerySmallScreen ? 44.0 : (isSmallScreen ? 48.0 : 52.0);
    final buttonTextSize = isVerySmallScreen ? 13.0 : (isSmallScreen ? 14.0 : 15.0);
    final footerTextSize = isVerySmallScreen ? 9.0 : (isSmallScreen ? 10.0 : 12.0);
    final copyrightSize = isVerySmallScreen ? 8.0 : (isSmallScreen ? 9.0 : 11.0);
    final horizontalPadding = screenWidth * 0.06;

    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
        child: SizedBox(
          height: availableHeight,
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top section with image and text
                Expanded(
                  flex: 6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Main image - responsive height
                      Image.asset(
                        'assets/auth.png',
                        height: imageHeight,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: imageHeight,
                            color: kSecondaryColor,
                            child: Center(
                              child: Icon(
                                Icons.image,
                                size: imageHeight * 0.4,
                                color: kSubTitleColor,
                              ),
                            ),
                          );
                        },
                      ),

                      SizedBox(height: isVerySmallScreen ? 12 : 20),

                      // Title
                      Text(
                        'Connectez-vous pour économiser',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: kTitleColor,
                          fontSize: titleSize,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      SizedBox(height: isVerySmallScreen ? 6 : 10),

                      // Subtitle
                      Text(
                        isVerySmallScreen
                            ? 'Économisez au moins 10% avec h24voyages'
                            : 'Connectez-vous pour économiser au moins\n10 % grâce à une adhésion gratuite à h24voyages',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: kTitleColor,
                          fontSize: subtitleSize,
                          fontWeight: FontWeight.w700,
                          height: 1.3,

                        ),
                      ),
                    ],
                  ),
                ),

                // Buttons section
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Primary Button - Email Login
                      GestureDetector(
                        onTapDown: (_) {
                          setState(() => _isEmailPressed = true);
                          HapticFeedback.lightImpact();
                        },
                        onTapUp: (_) {
                          setState(() => _isEmailPressed = false);
                          const SignUp().launch(context);
                        },
                        onTapCancel: () => setState(() => _isEmailPressed = false),
                        child: AnimatedScale(
                          scale: _isEmailPressed ? 0.97 : 1.0,
                          duration: const Duration(milliseconds: 100),
                          child: Container(
                            width: double.infinity,
                            height: buttonHeight,
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
                            child: Padding(
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
                        ),
                      ),

                      SizedBox(height: isVerySmallScreen ? 10 : 14),

                      // Secondary Button - Google Login
                      GestureDetector(
                        onTapDown: (_) {
                          setState(() => _isGooglePressed = true);
                          HapticFeedback.lightImpact();
                        },
                        onTapUp: (_) {
                          setState(() => _isGooglePressed = false);
                          const Home().launch(context);
                        },
                        onTapCancel: () => setState(() => _isGooglePressed = false),
                        child: AnimatedScale(
                          scale: _isGooglePressed ? 0.97 : 1.0,
                          duration: const Duration(milliseconds: 100),
                          child: Container(
                            width: double.infinity,
                            height: buttonHeight,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2F2F2),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Padding(
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
                        ),
                      ),
                    ],
                  ),
                ),

                // Footer section - centered between buttons and bottom
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Footer - Terms & Privacy (first line right-aligned, second centered)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // First line - right aligned
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              isVerySmallScreen
                                  ? 'En vous connectant, vous acceptez'
                                  : 'En créant ou en vous connectant à un compte, vous acceptez',
                              style: GoogleFonts.poppins(
                                color: kSubTitleColor,
                                fontSize: footerTextSize,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          // Second line - centered with links
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: GoogleFonts.poppins(
                                color: kSubTitleColor,
                                fontSize: footerTextSize,
                                fontWeight: FontWeight.w400,
                              ),
                              children: [
                                const TextSpan(text: 'nos '),
                                TextSpan(
                                  text: 'conditions générales',
                                  style: GoogleFonts.poppins(
                                    color: kPrimaryColor,
                                    fontSize: footerTextSize,
                                    fontWeight: FontWeight.w400,
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
                                    fontSize: footerTextSize,
                                    fontWeight: FontWeight.w400,
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
                        ],
                      ),

                      SizedBox(height: isVerySmallScreen ? 6 : 10),

                      // Copyright - centered
                      Text(
                        'Tous droits réservés. Copyright- h24voyages',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: kSubTitleColor,
                          fontSize: copyrightSize,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
