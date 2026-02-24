import 'package:flight_booking/generated/l10n.dart' as lang;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../widgets/constant.dart';
import '../../controllers/register_controller.dart';
import 'otp_verication.dart';
import '../home/home.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late final RegisterController _controller;
  bool _obscurePassword = true;
  bool _isButtonPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = context.read<RegisterController>();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final t = lang.S.of(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final response = await _controller.register(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
      );

      if (Navigator.of(context).canPop()) Navigator.of(context).pop();

      if (response == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_controller.message ?? t.registerError)),
        );
        return;
      }

      if (_controller.state == RegisterState.otpSent ||
          _controller.state == RegisterState.pendingOtp) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpVerification(
              email: _emailController.text.trim(),
              isLogin: false,
            ),
          ),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_controller.message ?? t.registerUnknownError)),
      );
    } catch (e) {
      if (Navigator.of(context).canPop()) Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  String? _notEmptyValidator(String? v, lang.S t) {
    if (v == null || v.trim().isEmpty) return t.registerFieldRequired;
    return null;
  }

  String? _emailValidator(String? v, lang.S t) {
    if (v == null || v.trim().isEmpty) return t.signUpEmailEmpty;
    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$');
    if (!emailRegex.hasMatch(v.trim())) return t.signUpEmailInvalid;
    return null;
  }

  String? _passwordValidator(String? v, lang.S t) {
    if (v == null || v.isEmpty) return t.registerPasswordRequired;
    if (v.length < 6) return t.registerPasswordMinLength;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardOpen = keyboardHeight > 0;

    // Responsive sizes based on Figma: 377x786
    final ratioW = screenWidth / 377;
    final ratioH = screenHeight / 786;
    final imageWidth = 320 * ratioW;
    final imageHeight = isKeyboardOpen ? 0.0 : 240 * ratioH;
    final titleSize = (22 * ratioW).clamp(18.0, 24.0);
    final subtitleSize = (13 * ratioW).clamp(11.0, 14.0);
    final inputSize = (14 * ratioW).clamp(12.0, 14.0);
    final buttonHeight = (50 * ratioH).clamp(42.0, 54.0);
    final buttonTextSize = (16 * ratioW).clamp(13.0, 16.0);
    final horizontalPadding = screenWidth * 0.06;
    final t = lang.S.of(context);

    return Scaffold(
      backgroundColor: kWhite,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: kWhite,
        elevation: 0,
        toolbarHeight: 56,
        leading: GestureDetector(
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
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Image
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
                            ],

                            SizedBox(height: 8 * ratioH),

                            // Title
                            Center(
                              child: Text(
                                t.registerTitle,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  color: kTitleColor,
                                  fontSize: titleSize,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),

                            SizedBox(height: 4 * ratioH),

                            // Subtitle
                            Text(
                              t.registerSubtitle,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.lato(
                                color: kSubTitleColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                height: 22 / 14,
                              ),
                            ),

                            SizedBox(height: 12 * ratioH),

                            // Prénom
                            TextFormField(
                              controller: _firstNameController,
                              cursorColor: kTitleColor,
                              style: GoogleFonts.poppins(color: kTitleColor, fontSize: inputSize),
                              decoration: _outlineDecoration(t.registerFirstName, inputSize),
                              validator: (v) => _notEmptyValidator(v, t),
                            ),

                            SizedBox(height: 12 * ratioH),

                            // Nom
                            TextFormField(
                              controller: _lastNameController,
                              cursorColor: kTitleColor,
                              style: GoogleFonts.poppins(color: kTitleColor, fontSize: inputSize),
                              decoration: _outlineDecoration(t.registerLastName, inputSize),
                              validator: (v) => _notEmptyValidator(v, t),
                            ),

                            SizedBox(height: 12 * ratioH),

                            // E-mail
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              cursorColor: kTitleColor,
                              style: GoogleFonts.poppins(color: kTitleColor, fontSize: inputSize),
                              decoration: _outlineDecoration(t.registerEmail, inputSize),
                              validator: (v) => _emailValidator(v, t),
                            ),

                            SizedBox(height: 12 * ratioH),

                            // Mot de passe
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              cursorColor: kTitleColor,
                              style: GoogleFonts.poppins(color: kTitleColor, fontSize: inputSize),
                              decoration: _outlineDecoration(t.registerPassword, inputSize).copyWith(
                                suffixIcon: GestureDetector(
                                  onTap: () => setState(() => _obscurePassword = !_obscurePassword),
                                  child: Icon(
                                    _obscurePassword ? Icons.lock_outline : Icons.lock_open_outlined,
                                    color: kSubTitleColor,
                                    size: 20,
                                  ),
                                ),
                                suffixIconConstraints: const BoxConstraints(minHeight: 20, minWidth: 20),
                              ),
                              validator: (v) => _passwordValidator(v, t),
                            ),

                            SizedBox(height: 16 * ratioH),

                            // S'inscrire button
                            GestureDetector(
                              onTapDown: (_) {
                                setState(() => _isButtonPressed = true);
                                HapticFeedback.lightImpact();
                              },
                              onTapUp: (_) {
                                setState(() => _isButtonPressed = false);
                                FocusScope.of(context).unfocus();
                                _submit();
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
                                      t.registerTitle,
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

                            // Push footer to bottom
                            const Spacer(),

                            // Footer
                            Padding(
                              padding: EdgeInsets.only(bottom: 12 * ratioH),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      style: GoogleFonts.poppins(
                                        color: kTitleColor,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400,
                                        height: 18 / 11,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: '${t.welcomeTermsIntro}\n',
                                        ),
                                        TextSpan(text: t.welcomeTermsOur),
                                        TextSpan(
                                          text: t.welcomeTermsConditions,
                                          style: GoogleFonts.poppins(
                                            color: kPrimaryColor,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w400,
                                            height: 18 / 11,
                                            decoration: TextDecoration.underline,
                                            decorationColor: kPrimaryColor,
                                          ),
                                          recognizer: TapGestureRecognizer()..onTap = () {},
                                        ),
                                        TextSpan(text: t.welcomeTermsAnd),
                                        TextSpan(
                                          text: t.welcomePrivacyPolicy,
                                          style: GoogleFonts.poppins(
                                            color: kPrimaryColor,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w400,
                                            height: 18 / 11,
                                            decoration: TextDecoration.underline,
                                            decorationColor: kPrimaryColor,
                                          ),
                                          recognizer: TapGestureRecognizer()..onTap = () {},
                                        ),
                                        TextSpan(text: '.'),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 4 * ratioH),
                                  Text(
                                    t.welcomeCopyright,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      color: kSubTitleColor,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w400,
                                      height: 18 / 11,
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
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  InputDecoration _outlineDecoration(String label, double fontSize) {
    return InputDecoration(
      labelText: label,
      hintText: label,
      labelStyle: GoogleFonts.poppins(
        color: kSubTitleColor,
        fontSize: fontSize,
        fontWeight: FontWeight.w400,
      ),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      floatingLabelStyle: GoogleFonts.poppins(
        color: kSubTitleColor,
        fontSize: 13,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: GoogleFonts.poppins(
        color: kSubTitleColor.withOpacity(0.5),
        fontSize: fontSize,
        fontWeight: FontWeight.w400,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: kBorderColorTextField, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: kBorderColorTextField, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: kPrimaryColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
      errorStyle: GoogleFonts.poppins(
        color: Colors.red,
        fontSize: 11,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
