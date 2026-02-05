import 'package:flight_booking/screen/widgets/constant.dart';
import 'package:flight_booking/screen/widgets/button_global.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'otp_verication.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  bool _isButtonPressed = false;

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
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
    final imageHeight = isKeyboardOpen
        ? 0.0
        : (screenHeight * 0.22).clamp(100.0, 220.0);
    final titleSize = isVerySmallScreen ? 16.0 : (isSmallScreen ? 17.0 : 20.0);
    final subtitleSize = isVerySmallScreen ? 11.0 : (isSmallScreen ? 12.0 : 14.0);
    final labelSize = isVerySmallScreen ? 11.0 : (isSmallScreen ? 12.0 : 14.0);
    final inputSize = isVerySmallScreen ? 12.0 : 14.0;
    final buttonHeight = isVerySmallScreen ? 42.0 : (isSmallScreen ? 46.0 : 52.0);
    final buttonTextSize = isVerySmallScreen ? 13.0 : (isSmallScreen ? 14.0 : 16.0);
    final footerTextSize = isVerySmallScreen ? 9.0 : (isSmallScreen ? 10.0 : 12.0);
    final copyrightSize = isVerySmallScreen ? 8.0 : (isSmallScreen ? 9.0 : 11.0);

    return Scaffold(
      backgroundColor: kWhite,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: kWhite,
        elevation: 0,
        toolbarHeight: isVerySmallScreen ? 44 : 56,
        leading: SmallTapEffect(
          onTap: () => Navigator.pop(context),
          child: const Padding(
            padding: EdgeInsets.all(12.0),
            child: Icon(Icons.arrow_back_ios, color: kTitleColor, size: 20),
          ),
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
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
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.06,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top section with image
                          if (!isKeyboardOpen) ...[
                            SizedBox(height: isVerySmallScreen ? 8 : 16),
                            Center(
                              child: Image.asset(
                                'assets/login.png',
                                height: imageHeight,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
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
                            SizedBox(height: isVerySmallScreen ? 16 : 24),
                          ],

                          // Form section
                          // Title
                          Text(
                            'Se connecter ou créer un compte',
                            style: GoogleFonts.poppins(
                              color: kTitleColor,
                              fontSize: titleSize,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          SizedBox(height: isVerySmallScreen ? 4 : 8),

                          // Subtitle
                          Text(
                            isVerySmallScreen
                                ? 'Connectez-vous à l\'aide de votre compte h24voyages.'
                                : 'Connectez-vous à l\'aide de votre compte h24voyages et accédez à nos services.',
                            style: GoogleFonts.poppins(
                              color: kSubTitleColor,
                              fontSize: subtitleSize,
                              fontWeight: FontWeight.w400,
                              height: 1.3,
                            ),
                          ),

                          SizedBox(height: isKeyboardOpen ? 12 : (isVerySmallScreen ? 12 : 20)),

                          // Email label
                          Text(
                            'Adresse e-mail',
                            style: GoogleFonts.poppins(
                              color: kTitleColor,
                              fontSize: labelSize,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          SizedBox(height: isVerySmallScreen ? 4 : 8),

                          // Email input field
                          TextFormField(
                            controller: _emailController,
                            focusNode: _emailFocusNode,
                            keyboardType: TextInputType.emailAddress,
                            cursorColor: kTitleColor,
                            style: GoogleFonts.poppins(
                              color: kTitleColor,
                              fontSize: inputSize,
                            ),
                            decoration: InputDecoration(
                              hintText: 'jihen@boosterbc.com',
                              hintStyle: GoogleFonts.poppins(
                                color: kSubTitleColor,
                                fontSize: inputSize,
                              ),
                              filled: true,
                              fillColor: kWhite,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: isVerySmallScreen ? 10 : 14,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: kBorderColorTextField,
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: kPrimaryColor,
                                  width: 1,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: isVerySmallScreen ? 12 : 18),

                          // Continue button
                          GestureDetector(
                            onTapDown: (_) {
                              setState(() => _isButtonPressed = true);
                              HapticFeedback.lightImpact();
                            },
                            onTapUp: (_) {
                              setState(() => _isButtonPressed = false);
                              FocusScope.of(context).unfocus();
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const OtpVerification()),
                              );
                            },
                            onTapCancel: () => setState(() => _isButtonPressed = false),
                            child: AnimatedScale(
                              scale: _isButtonPressed ? 0.97 : 1.0,
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
                                child: Center(
                                  child: Text(
                                    'Continuer',
                                    style: GoogleFonts.poppins(
                                      color: kWhite,
                                      fontSize: buttonTextSize,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Footer section - centered between button and bottom
                          if (!isKeyboardOpen) ...[
                            // Spacer to center footer
                            const Spacer(),

                            // Footer - Terms & Privacy
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // First line
                                Text(
                                  isVerySmallScreen
                                      ? 'En vous connectant, vous acceptez'
                                      : 'En créant ou en vous connectant à un compte, vous acceptez',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    color: kSubTitleColor,
                                    fontSize: footerTextSize,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                // Second line - with links
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

                                SizedBox(height: isVerySmallScreen ? 4 : 8),

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

                            // Spacer to center footer
                            const Spacer(),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
