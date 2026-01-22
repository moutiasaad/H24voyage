import 'package:flight_booking/screen/home/home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import '../widgets/constant.dart';

class OtpVerification extends StatefulWidget {
  const OtpVerification({Key? key}) : super(key: key);

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  final TextEditingController _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),

              // Main image
              Center(
                child: Image.asset(
                  'assets/onBorder0.png',
                  height: 280,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 220,
                      color: kSecondaryColor,
                      child: const Center(
                        child: Icon(Icons.image, size: 80, color: kSubTitleColor),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 30),

              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Vérifiez votre adresse e-mail pour vous connecter',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: kTitleColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Subtitle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.poppins(
                      color: kSubTitleColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                    children: [
                      const TextSpan(
                        text: 'Nous avons envoyé un code de vérification à cette adresse :\n',
                      ),
                      TextSpan(
                        text: 'jihen@boosterbc.com',
                        style: GoogleFonts.poppins(
                          color: kTitleColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const TextSpan(
                        text: '.\nVeuillez le saisir pour continuer.',
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // OTP Input boxes
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Pinput(
                  controller: _otpController,
                  length: 6,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  defaultPinTheme: PinTheme(
                    height: 50,
                    width: 50,
                    textStyle: GoogleFonts.poppins(
                      color: kTitleColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: BoxDecoration(
                      color: kWhite,
                      border: Border.all(
                        color: kBorderColorTextField,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  focusedPinTheme: PinTheme(
                    height: 50,
                    width: 50,
                    textStyle: GoogleFonts.poppins(
                      color: kTitleColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: BoxDecoration(
                      color: kWhite,
                      border: Border.all(
                        color: kPrimaryColor,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  submittedPinTheme: PinTheme(
                    height: 50,
                    width: 50,
                    textStyle: GoogleFonts.poppins(
                      color: kTitleColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: BoxDecoration(
                      color: kWhite,
                      border: Border.all(
                        color: kBorderColorTextField,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Verify button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Home()),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'Vérifier l\'adresse e-mail',
                        style: GoogleFonts.poppins(
                          color: kTitleColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Resend code button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GestureDetector(
                  onTap: () {
                    // Resend code logic
                  },
                  child: Container(
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'Recevoir un nouveau code',
                        style: GoogleFonts.poppins(
                          color: kTitleColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
