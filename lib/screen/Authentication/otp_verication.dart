import 'package:flight_booking/screen/home/home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import '../widgets/constant.dart';
import '../widgets/button_global.dart';
import '../../controllers/register_controller.dart';
import 'sign_up_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpVerification extends StatefulWidget {
  final String? email;
  final bool isLogin;
  final int? customerId;

  const OtpVerification({Key? key, this.email, this.isLogin = false, this.customerId}) : super(key: key);

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _otpFocusNode = FocusNode();

  @override
  void dispose() {
    _otpController.dispose();
    _otpFocusNode.dispose();
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
        : (screenHeight * 0.28).clamp(120.0, 280.0);
    final titleSize = isVerySmallScreen ? 16.0 : (isSmallScreen ? 18.0 : 20.0);
    final subtitleSize = isVerySmallScreen ? 12.0 : (isSmallScreen ? 13.0 : 14.0);
    final pinSize = isVerySmallScreen ? 42.0 : (isSmallScreen ? 46.0 : 50.0);
    final pinFontSize = isVerySmallScreen ? 16.0 : 18.0;
    final buttonHeight = isVerySmallScreen ? 46.0 : (isSmallScreen ? 48.0 : 52.0);
    final buttonTextSize = isVerySmallScreen ? 13.0 : (isSmallScreen ? 14.0 : 15.0);

    return Scaffold(
      backgroundColor: kWhite,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: kWhite,
        elevation: 0,
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
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
            child: Column(
              children: [
                // Top flexible space
                if (!isKeyboardOpen)
                  Flexible(flex: 1, child: const SizedBox()),

                // Main image - hide when keyboard is open
                if (!isKeyboardOpen)
                  Center(
                    child: Image.asset(
                      'assets/onBorder0.png',
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

                if (!isKeyboardOpen)
                  Flexible(flex: 1, child: const SizedBox()),

                // Title
                Text(
                  isVerySmallScreen
                      ? 'Vérifiez votre adresse e-mail'
                      : 'Vérifiez votre adresse e-mail pour vous connecter',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: kTitleColor,
                    fontSize: titleSize,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                SizedBox(height: isVerySmallScreen ? 10 : 14),

                // Subtitle
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.poppins(
                      color: kSubTitleColor,
                      fontSize: subtitleSize,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
                    children: [
                      TextSpan(
                        text: isVerySmallScreen
                            ? 'Code envoyé à : '
                            : 'Nous avons envoyé un code de vérification à :\n',
                      ),
                      TextSpan(
                        text: widget.email ?? 'adresse e-mail',
                        style: GoogleFonts.poppins(
                          color: kTitleColor,
                          fontSize: subtitleSize,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (!isVerySmallScreen)
                        const TextSpan(text: '\nVeuillez le saisir pour continuer.'),
                    ],
                  ),
                ),

                SizedBox(height: isKeyboardOpen ? 20 : (isVerySmallScreen ? 20 : 28)),

                // OTP Input boxes
                Pinput(
                  controller: _otpController,
                  focusNode: _otpFocusNode,
                  length: 6,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  defaultPinTheme: PinTheme(
                    height: pinSize,
                    width: pinSize,
                    textStyle: GoogleFonts.poppins(
                      color: kTitleColor,
                      fontSize: pinFontSize,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: BoxDecoration(
                      color: kWhite,
                      border: Border.all(color: kBorderColorTextField, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  focusedPinTheme: PinTheme(
                    height: pinSize,
                    width: pinSize,
                    textStyle: GoogleFonts.poppins(
                      color: kTitleColor,
                      fontSize: pinFontSize,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: BoxDecoration(
                      color: kWhite,
                      border: Border.all(color: kPrimaryColor, width: 1.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  submittedPinTheme: PinTheme(
                    height: pinSize,
                    width: pinSize,
                    textStyle: GoogleFonts.poppins(
                      color: kTitleColor,
                      fontSize: pinFontSize,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: BoxDecoration(
                      color: kWhite,
                      border: Border.all(color: kBorderColorTextField, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                SizedBox(height: isVerySmallScreen ? 24 : 32),

                // Verify button
                TappableCard(
                  onTap: () async {
                    FocusScope.of(context).unfocus();

                    final otp = _otpController.text.trim();
                    if (otp.length < 4) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Entrez le code OTP valide')),
                      );
                      return;
                    }

                    final controller = RegisterController();

                    // show loading
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => const Center(child: CircularProgressIndicator()),
                    );

                    try {
                      if (widget.isLogin) {
                        // Login OTP flow requires customerId
                        if (widget.customerId == null) {
                          if (Navigator.of(context).canPop()) Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('ID client manquant pour la vérification')),
                          );
                          return;
                        }

                        final response = await controller.verifyLoginOtp(
                          customerId: widget.customerId!,
                          otp: otp,
                        );

                        // hide loading
                        if (Navigator.of(context).canPop()) Navigator.of(context).pop();

                        if (response == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(controller.message ?? 'Erreur de vérification')),
                          );
                          return;
                        }

                        if (response.success) {

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const Home()),
                            (route) => false,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(response.message ?? 'Erreur')),
                          );
                        }
                      } else {
                        final response = await controller.verifyOtp(
                          email: widget.email ?? '',
                          otp: otp,
                        );

                        // hide loading
                        if (Navigator.of(context).canPop()) Navigator.of(context).pop();

                        if (response == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(controller.message ?? 'Erreur de vérification')),
                          );
                          return;
                        }

                        if (response.success) {
                          // Registration successful - navigate back to SignUp page to login
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Inscription réussie! Veuillez vous connecter.'),
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 3),
                            ),
                          );

                          // Navigate back to SignUp/Login page
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const SignUp()),
                            (route) => false,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(response.message ?? response.error ?? 'Erreur')),
                          );
                        }
                      }
                    } catch (e) {
                      if (Navigator.of(context).canPop()) Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString())),
                      );
                    }
                  },
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAEAEA),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    width: double.infinity,
                    height: buttonHeight,
                    child: Center(
                      child: Text(
                        'Vérifier l\'adresse e-mail',
                        style: GoogleFonts.poppins(
                          color: kTitleColor,
                          fontSize: buttonTextSize,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: isVerySmallScreen ? 10 : 14),

                // Resend code button
                TappableCard(
                  onTap: () {
                    // Resend code logic
                  },
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    width: double.infinity,
                    height: buttonHeight,
                    child: Center(
                      child: Text(
                        'Recevoir un nouveau code',
                        style: GoogleFonts.poppins(
                          color: kTitleColor,
                          fontSize: buttonTextSize,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),

                // Bottom flexible space
                Flexible(flex: isKeyboardOpen ? 1 : 2, child: const SizedBox()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
