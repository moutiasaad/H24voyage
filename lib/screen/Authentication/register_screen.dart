import 'package:flight_booking/screen/widgets/button_global.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final RegisterController _controller = RegisterController();
  bool _isLogin = false;

  @override
  void dispose() {
    _lastNameController.dispose();
    _firstNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final registerController = _controller;

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      if (_isLogin) {
        final response = await registerController.login(
          email: _emailController.text.trim(),
          // password: _passwordController.text,
        );

        if (Navigator.of(context).canPop()) Navigator.of(context).pop();

        if (response == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erreur lors de la connexion')),
          );
          return;
        }

        if (registerController.state == RegisterState.pendingOtp) {
          // Navigate to OTP verification screen for login
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpVerification(
                email: _emailController.text.trim(),
                isLogin: true,
                customerId: registerController.pendingCustomerId,
              ),
            ),
          );
          return;
        }

        if (registerController.state == RegisterState.idle) {
          // login succeeded without OTP -> navigate to Home
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Home()),
          );
          return;
        }

        // else error
        final message = registerController.message ?? 'Erreur inconnue';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
        return;
      } else {
        final response = await registerController.register(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
        );

        // Hide loading
        if (Navigator.of(context).canPop()) Navigator.of(context).pop();

        if (response == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erreur lors de l\'inscription')),
          );
          return;
        }

        if (registerController.state == RegisterState.otpSent || registerController.state == RegisterState.pendingOtp) {
          // Navigate to OTP verification screen for registration
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OtpVerification(email: _emailController.text.trim(), isLogin: false)),
          );
          return;
        }

        final message = registerController.message ?? 'Erreur inconnue';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
        return;
      }
    } catch (e) {
      if (Navigator.of(context).canPop()) Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  String? _notEmptyValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'Ce champ est requis';
    return null;
  }

  String? _emailValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'E-mail requis';
    final email = v.trim();
    final emailRegex = RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+");
    if (!emailRegex.hasMatch(email)) return 'E-mail invalide';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),

                /// 🔹 Hero Illustration
                Image.asset(
                  'assets/register.png', // put your image here
                  height: 220,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 24),

                // Mode toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () => setState(() => _isLogin = false),
                      child: Text('Inscription', style: GoogleFonts.jost(color: !_isLogin ? kTitleColor : kSubTitleColor)),
                    ),
                    TextButton(
                      onPressed: () => setState(() => _isLogin = true),
                      child: Text('Connexion', style: GoogleFonts.jost(color: _isLogin ? kTitleColor : kSubTitleColor)),
                    ),
                  ],
                ),

                /// 🔹 Title
                Text(
                  _isLogin ? "Se connecter" : "S’inscrire",
                  style: GoogleFonts.jost(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: kTitleColor,
                  ),
                ),

                const SizedBox(height: 6),

                /// 🔹 Subtitle
                Text(
                  "Inscrivez-vous dès maintenant à h24voyages\net accédez à nos services.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.jost(
                    fontSize: 15,
                    color: kSubTitleColor,
                  ),
                ),

                const SizedBox(height: 28),

                if (!_isLogin) ...[
                  /// 🔹 Nom
                  TextFormField(
                    controller: _lastNameController,
                    decoration: kInputDecoration.copyWith(
                      hintText: "Nom",
                    ),
                    validator: _notEmptyValidator,
                  ),

                  const SizedBox(height: 14),

                  /// 🔹 Prénom
                  TextFormField(
                    controller: _firstNameController,
                    decoration: kInputDecoration.copyWith(
                      hintText: "Prénom",
                    ),
                    validator: _notEmptyValidator,
                  ),

                  const SizedBox(height: 14),
                ],

                /// 🔹 Email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: kInputDecoration.copyWith(
                    hintText: "E-mail",
                  ),
                  validator: _emailValidator,
                ),

                const SizedBox(height: 14),

                /// 🔹 Mot de passe
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: kInputDecoration.copyWith(
                    hintText: "Mot de passe",
                    suffixIcon: Icon(
                      Icons.lock_outline,
                      color: kSubTitleColor,
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Mot de passe requis';
                    if (v.length < 6) return 'Au moins 6 caractères';
                    return null;
                  },
                ),

                const SizedBox(height: 26),

                /// 🔹 Action Button
                ButtonGlobal(
                  buttontext: _isLogin ? "Se connecter" : "S’inscrire",
                  buttonDecoration: kGradientButtonDecoration,
                  onPressed: _submit,
                ),

                const SizedBox(height: 18),

                /// 🔹 Footer text
                Text.rich(
                  TextSpan(
                    text: "En créant ou en vous connectant un compte, vous acceptez\n",
                    style: GoogleFonts.jost(
                      fontSize: 13,
                      color: kSubTitleColor,
                    ),
                    children: [
                      TextSpan(
                        text: "nos conditions générales ",
                        style: kLinkTextStyle,
                      ),
                      const TextSpan(text: "et "),
                      TextSpan(
                        text: "notre charte de confidentialité",
                        style: kLinkTextStyle,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 10),

                /// 🔹 Copyright
                Text(
                  "Tous droits réservés. Copyright – h24voyages",
                  style: GoogleFonts.jost(
                    fontSize: 12,
                    color: kSubTitleColor,
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
