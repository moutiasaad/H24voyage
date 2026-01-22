import 'package:flight_booking/screen/Authentication/sign_up_screen.dart';
import 'package:flight_booking/screen/widgets/constant.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import '../home/home.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 40),

                    // Main image
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Image.asset(
                        'assets/auth.png',
                        height: 230,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 280,
                            color: kSecondaryColor,
                            child: const Center(
                              child: Icon(Icons.image, size: 100, color: kSubTitleColor),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Title
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'Connectez-vous pour économiser',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: kTitleColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Subtitle
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        'Connectez-vous pour économiser au moins\n10 % grâce à une\nadhésion gratuite à h24voyages',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: kSubTitleColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Email button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: GestureDetector(
                        onTap: () {
                          const SignUp().launch(context);
                        },
                        child: Container(
                          width: double.infinity,
                          height: 52,
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/e-mail 2.png',
                                width: 24,
                                height: 24,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.email_outlined,
                                    color: kWhite,
                                    size: 24,
                                  );
                                },
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Continuer via l\'adresse e-mail',
                                style: GoogleFonts.poppins(
                                  color: kWhite,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Google button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: GestureDetector(
                        onTap: () {
                          // Google sign in
                          const Home().launch(context);
                        },
                        child: Container(
                          width: double.infinity,
                          height: 52,
                          decoration: BoxDecoration(
                            color: kWhite,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: kBorderColorTextField, width: 1),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/gmail 2.png',
                                width: 24,
                                height: 24,
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
                              const SizedBox(width: 12),
                              Text(
                                'Continuer avec google',
                                style: GoogleFonts.poppins(
                                  color: kTitleColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Footer
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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
          ],
        ),
      ),
    );
  }
}
