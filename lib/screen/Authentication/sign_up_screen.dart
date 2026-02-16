import 'package:flight_booking/screen/Authentication/register_screen.dart';
import 'package:flight_booking/screen/widgets/constant.dart';
import 'package:flight_booking/screen/widgets/button_global.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import 'otp_verication.dart';
import '../../controllers/register_controller.dart';
import '../home/home.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  bool _isButtonPressed = false;
  String? _emailError;
  final RegisterController _controller = RegisterController();

  bool _validateEmail() {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() => _emailError = 'Veuillez saisir votre adresse e-mail');
      return false;
    }
    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$');
    if (!emailRegex.hasMatch(email)) {
      setState(() => _emailError = 'Veuillez saisir une adresse e-mail valide');
      return false;
    }
    setState(() => _emailError = null);
    return true;
  }

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

    // Responsive sizes based on Figma: 377x786
    final ratioW = screenWidth / 377;
    final ratioH = screenHeight / 786;
    final imageWidth = 320 * ratioW;
    final imageHeight = isKeyboardOpen ? 0.0 : 300 * ratioH;
    final titleSize = (18 * ratioW).clamp(14.0, 20.0);
    final subtitleSize = (13 * ratioW).clamp(11.0, 14.0);
    final labelSize = (13 * ratioW).clamp(11.0, 14.0);
    final inputSize = (14 * ratioW).clamp(12.0, 14.0);
    final buttonHeight = (50 * ratioH).clamp(42.0, 54.0);
    final buttonTextSize = (16 * ratioW).clamp(13.0, 16.0);

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
                    minHeight: isKeyboardOpen ? 0 : constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.06,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Top section with image
                          if (!isKeyboardOpen) ...[
                            Center(
                              child: Image.asset(
                                'assets/login.png',
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
                          ],

                          // Title
                          Center(
                            child: Text(
                              'Se connecter ou créer un compte',
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
                            'Connectez-vous à l\'aide de votre compte h24voyages\net accédez à nos services.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: kSubTitleColor,
                              fontSize: subtitleSize,
                              fontWeight: FontWeight.w400,
                              height: 1.4,
                            ),
                          ),

                          SizedBox(height: 16 * ratioH),

                          // Email label
                          Text(
                            'Adresse e-mail',
                            style: GoogleFonts.poppins(
                              color: kTitleColor,
                              fontSize: labelSize,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          SizedBox(height: 8 * ratioH),

                          // Email input field
                          TextFormField(
                            key: const ValueKey('email_field'),
                            controller: _emailController,
                            focusNode: _emailFocusNode,
                            keyboardType: TextInputType.emailAddress,
                            cursorColor: kTitleColor,
                            style: GoogleFonts.poppins(
                              color: kTitleColor,
                              fontSize: inputSize,
                            ),
                            decoration: InputDecoration(
                              hintText: 'email@email.com',
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
                                borderSide: BorderSide(
                                  color: _emailError != null ? Colors.red : kBorderColorTextField,
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: _emailError != null ? Colors.red : kPrimaryColor,
                                  width: 1,
                                ),
                              ),
                            ),
                            onChanged: (_) {
                              if (_emailError != null) {
                                setState(() => _emailError = null);
                              }
                            },
                          ),

                          if (_emailError != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 6, left: 4),
                              child: Text(
                                _emailError!,
                                style: GoogleFonts.poppins(
                                  color: Colors.red,
                                  fontSize: isVerySmallScreen ? 10.0 : 12.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),

                          SizedBox(height: 16 * ratioH),

                          // Continue button
                          GestureDetector(
                            onTapDown: (_) {
                              setState(() => _isButtonPressed = true);
                              HapticFeedback.lightImpact();
                            },
                            onTapUp: (_) async {
                              setState(() => _isButtonPressed = false);
                              FocusScope.of(context).unfocus();

                              if (!_validateEmail()) return;

                              // Show loading
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => const Center(child: CircularProgressIndicator()),
                              );

                              try {
                                final response = await _controller.login(
                                  email: _emailController.text.trim(),
                                );

                                // hide loading
                                if (Navigator.of(context).canPop()) Navigator.of(context).pop();

                                if (response == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(_controller.message ?? 'Erreur lors de la connexion')),
                                  );
                                  return;
                                }

                                if (response.success && response.requiresOTP && response.customerId != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OtpVerification(
                                        email: _emailController.text.trim(),
                                        isLogin: true,
                                        customerId: response.customerId,
                                      ),
                                    ),
                                  );
                                } else if (response.success && !response.requiresOTP) {
                                  // login succeeded without OTP -> navigate to Home
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
                              } catch (e) {
                                if (Navigator.of(context).canPop()) Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())),
                                );
                              }
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
                                      color: const Color.fromRGBO(0, 0, 0, 0.15),
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
                          SizedBox(height: 16 * ratioH),

                          // Footer - Terms & Privacy
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Vous n'avez pas de compte ? ",
                                      style: GoogleFonts.lato(
                                        color: kSubTitleColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        height: 22 / 14,
                                      ),
                                    ),
                                    TapEffect(
                                      onTap: () => const RegisterScreen().launch(context),
                                      child: Text(
                                        "Inscrivez vous",
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
                                // First line
                                Text(
                                  isVerySmallScreen
                                      ? 'En vous connectant, vous acceptez'
                                      : 'En créant ou en vous connectant à un compte, vous acceptez',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    color: kSubTitleColor,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400,
                                    height: 20 / 11,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                // Second line - with links
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

                                // Copyright - centered
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
