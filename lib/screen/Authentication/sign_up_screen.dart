import 'package:flight_booking/screen/widgets/constant.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'otp_verication.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // Main image
              Center(
                child: Image.asset(
                  'assets/login.png',
                  height: 280,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
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
                  'Se connecter ou créer un compte',
                  style: GoogleFonts.poppins(
                    color: kTitleColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Subtitle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Connectez-vous à l\'aide de votre compte h24voyages et accédez à nos services.',
                  style: GoogleFonts.poppins(
                    color: kSubTitleColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Email label
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Adresse e-mail',
                  style: GoogleFonts.poppins(
                    color: kTitleColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Email input field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: kTitleColor,
                  style: GoogleFonts.poppins(
                    color: kTitleColor,
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    hintText: 'jihen@boosterbc.com',
                    hintStyle: GoogleFonts.poppins(
                      color: kSubTitleColor,
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: kWhite,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
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
              ),

              const SizedBox(height: 24),

              // Continue button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const OtpVerification()),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'Continuer',
                        style: GoogleFonts.poppins(
                          color: kWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Footer
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: GoogleFonts.poppins(
                          color: kSubTitleColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        ),
                        children: [
                          const TextSpan(
                            text: 'En créant ou en vous connectant à un compte, vous acceptez\nnos ',
                          ),
                          TextSpan(
                            text: 'conditions générales',
                            style: GoogleFonts.poppins(
                              color: kPrimaryColor,
                              fontSize: 12,
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
                              fontSize: 12,
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
                    const SizedBox(height: 12),
                    Text(
                      'Tous droits réservés. Copyright- h24voyages',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: kSubTitleColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
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
