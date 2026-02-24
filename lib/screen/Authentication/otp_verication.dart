import 'dart:async';
import 'package:flight_booking/generated/l10n.dart' as lang;
import 'package:flight_booking/screen/home/home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import '../widgets/constant.dart';
import '../widgets/button_global.dart';
import '../../controllers/register_controller.dart';
import '../../controllers/profile_controller.dart';
import '../../services/auth_service.dart';
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
  bool _isLoading = false;
  bool _isResending = false;
  String? _errorMessage;

  // Resend timer
  int _resendSeconds = 60;
  Timer? _resendTimer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _otpController.dispose();
    _otpFocusNode.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _resendSeconds = 60;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_resendSeconds > 0) {
          _resendSeconds--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  bool get _canResend => _resendSeconds == 0 && !_isResending;

  Future<void> _resendOtp() async {
    if (!_canResend) return;
    if (widget.email == null || widget.email!.isEmpty) return;

    setState(() {
      _isResending = true;
      _errorMessage = null;
    });

    try {
      final success = await AuthService.resendLoginOtp(email: widget.email!);

      if (!mounted) return;

      final t = lang.S.of(context);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              t.otpCodeSent(widget.email ?? ''),
              style: GoogleFonts.poppins(color: kWhite, fontSize: 13),
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
        _startResendTimer();
      } else {
        setState(() {
          _errorMessage = t.otpResendFailed;
        });
      }
    } catch (e) {
      if (!mounted) return;
      final t = lang.S.of(context);
      setState(() {
        _errorMessage = t.otpResendError;
      });
    } finally {
      if (mounted) {
        setState(() => _isResending = false);
      }
    }
  }

  Future<void> _verifyOtp(String otp) async {
    if (otp.length < 6) return;
    if (_isLoading) return;

    FocusScope.of(context).unfocus();
    final t = lang.S.of(context);

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final controller = context.read<RegisterController>();

    try {
      if (widget.isLogin) {
        if (widget.customerId == null) {
          setState(() {
            _isLoading = false;
            _errorMessage = t.otpWrongCode;
          });
          return;
        }

        final response = await controller.verifyLoginOtp(
          customerId: widget.customerId!,
          otp: otp,
        );

        if (!mounted) return;

        if (response == null || !response.success) {
          setState(() {
            _isLoading = false;
            _errorMessage = t.otpWrongCode;
          });
          _clearOtpAfterError();
          return;
        }

        // Fetch user profile (same as app startup in splash screen)
        await context.read<ProfileController>().fetchProfile();

        if (!mounted) return;

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
          (route) => false,
        );
      } else {
        final response = await controller.verifyOtp(
          email: widget.email ?? '',
          otp: otp,
        );

        if (!mounted) return;

        if (response == null || !response.success) {
          setState(() {
            _isLoading = false;
            _errorMessage = t.otpWrongCode;
          });
          _clearOtpAfterError();
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.otpRegistrationSuccess),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const SignUp()),
          (route) => false,
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = t.otpWrongCode;
      });
      _clearOtpAfterError();
    }
  }

  void _clearOtpAfterError() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        _otpController.clear();
        _otpFocusNode.requestFocus();
      }
    });
  }

  String get _timerText {
    final minutes = (_resendSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_resendSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
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

    final t = lang.S.of(context);
    final hasError = _errorMessage != null;

    final defaultTheme = PinTheme(
      height: pinSize,
      width: pinSize,
      textStyle: GoogleFonts.poppins(
        color: kTitleColor,
        fontSize: pinFontSize,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: kWhite,
        border: Border.all(color: hasError ? Colors.red : kBorderColorTextField, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
    );

    final focusedTheme = PinTheme(
      height: pinSize,
      width: pinSize,
      textStyle: GoogleFonts.poppins(
        color: kTitleColor,
        fontSize: pinFontSize,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: kWhite,
        border: Border.all(color: hasError ? Colors.red : kPrimaryColor, width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
    );

    final submittedTheme = PinTheme(
      height: pinSize,
      width: pinSize,
      textStyle: GoogleFonts.poppins(
        color: hasError ? Colors.red : kTitleColor,
        fontSize: pinFontSize,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: hasError ? Colors.red.withOpacity(0.05) : kWhite,
        border: Border.all(color: hasError ? Colors.red : kBorderColorTextField, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
    );

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
                      ? t.otpVerifyTitleShort
                      : t.otpVerifyTitle,
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
                            ? t.otpCodeSentToShort
                            : t.otpCodeSentTo,
                      ),
                      TextSpan(
                        text: widget.email ?? t.otpEmailFallback,
                        style: GoogleFonts.poppins(
                          color: kTitleColor,
                          fontSize: subtitleSize,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (!isVerySmallScreen)
                        TextSpan(text: t.otpEnterToContinue),
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
                  defaultPinTheme: defaultTheme,
                  focusedPinTheme: focusedTheme,
                  submittedPinTheme: submittedTheme,
                  onChanged: (_) {
                    if (_errorMessage != null) {
                      setState(() => _errorMessage = null);
                    }
                  },
                  onCompleted: (pin) => _verifyOtp(pin),
                ),

                const SizedBox(height: 8),

                // Timer + resend row below OTP input
                Align(
                  alignment: Alignment.centerRight,
                  child: _resendSeconds > 0
                      ? Text(
                          _timerText,
                          style: GoogleFonts.poppins(
                            color: kSubTitleColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      : SmallTapEffect(
                          onTap: _canResend ? _resendOtp : null,
                          child: _isResending
                              ? const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: kPrimaryColor,
                                  ),
                                )
                              : Text(
                                  t.otpResendTitle2,
                                  style: GoogleFonts.poppins(
                                    color: kPrimaryColor,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                ),

                // Error message
                AnimatedSize(
                  duration: const Duration(milliseconds: 200),
                  child: hasError
                      ? Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error_outline, color: Colors.red, size: 18),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  _errorMessage!,
                                  style: GoogleFonts.poppins(
                                    color: Colors.red,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                ),

                // Loading indicator
                if (_isLoading)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: kPrimaryColor,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          t.otpVerifying,
                          style: GoogleFonts.poppins(
                            color: kSubTitleColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),

                SizedBox(height: isVerySmallScreen ? 24 : 32),

                // Verify button
                TappableCard(
                  onTap: _isLoading ? null : () => _verifyOtp(_otpController.text.trim()),
                  decoration: BoxDecoration(
                    color: _isLoading ? const Color(0xFFD5D5D5) : const Color(0xFFEAEAEA),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    width: double.infinity,
                    height: buttonHeight,
                    child: Center(
                      child: Text(
                        t.otpVerifyEmail,
                        style: GoogleFonts.poppins(
                          color: _isLoading ? kSubTitleColor : kTitleColor,
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
