import 'package:flight_booking/Model/login_response.dart';
import 'package:flight_booking/Model/register_request.dart';
import 'package:flight_booking/Model/register_response.dart';
import 'package:flight_booking/Model/verify_login_response.dart';
import 'package:flight_booking/Model/verify_otp_response.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/auth_service.dart';
import '../services/push_notification_service.dart';

enum RegisterState {
  idle,
  loading,
  otpSent,
  pendingOtp,
  error,
}

class RegisterController extends ChangeNotifier {
  RegisterState state = RegisterState.idle;
  String? message;
  String? expiresIn;
  DateTime? pendingExpiration;
  // For login flow
  int? pendingCustomerId;
  String? pendingEmailForLogin;

  bool get isLoading => state == RegisterState.loading;

  Future<RegisterResponse?> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    state = RegisterState.loading;
    message = null;
    notifyListeners();

    try {
      final request = RegisterRequest(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );

      final response = await AuthService.registerCustomer(request);

      message = response.message;
      expiresIn = response.expiresIn;
      pendingExpiration = response.pendingExpiration;

      if (response.isOtpSent) {
        state = RegisterState.otpSent;
      } else if (response.isPendingRegistration) {
        state = RegisterState.pendingOtp;
      } else {
        state = RegisterState.error;
      }

      notifyListeners();
      return response;
    } catch (e) {
      state = RegisterState.error;
      message = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<VerifyOtpResponse?> verifyOtp({
    required String email,
    required String otp,
  }) async {
    state = RegisterState.loading;
    message = null;
    notifyListeners();

    try {
      final response = await AuthService.verifyRegisterOtp(email: email, otp: otp);

      // response contains success/message/error/customerId/tokens
      message = response.message ?? response.error;

      if (response.success) {
        debugPrint('✅ Registration OTP verified successfully');

        // Save basic info
        try {
          final prefs = await SharedPreferences.getInstance();
          if (response.customerId != null) {
            await prefs.setInt('customer_id', response.customerId!);
          }
          await prefs.setString('user_email', email);
        } catch (e) {
          debugPrint('❌ Failed to save basic info: $e');
        }

        message = 'Registration successful! Please login to continue.';
        state = RegisterState.idle;
      } else {
        state = RegisterState.error;
      }

      notifyListeners();
      return response;
    } catch (e) {
      state = RegisterState.error;
      message = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<LoginResponse?> login({
    required String email,
  }) async {
    state = RegisterState.loading;
    message = null;
    notifyListeners();

    try {
      final response = await AuthService.login(email: email);

      message = response.message;

      if (response.success && response.requiresOTP && response.customerId != null) {
        // Save pending customer id for OTP verification
        pendingCustomerId = response.customerId;
        pendingEmailForLogin = email;
        state = RegisterState.pendingOtp;
      } else if (response.success && !response.requiresOTP) {
        // success without OTP (edge case) -> mark as logged in (store minimal info)
        try {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('is_logged_in', true);
          if (response.customerId != null) await prefs.setInt('customer_id', response.customerId!);
          await prefs.setString('user_email', email);
          // Get FCM token after successful login
          await PushNotificationService().getToken();
        } catch (e) {
          debugPrint('❌ Failed to save session after login: $e');
        }
        state = RegisterState.idle;
      } else {
        state = RegisterState.error;
      }

      notifyListeners();
      return response;
    } catch (e) {
      state = RegisterState.error;
      message = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<VerifyLoginResponse?> verifyLoginOtp({
    required int customerId,
    required String otp,
  }) async {
    state = RegisterState.loading;
    message = null;
    notifyListeners();

    try {
      final response = await AuthService.verifyLoginOtp(customerId: customerId, otp: otp);

      message = response.message;

      if (response.success) {
        // Save session and tokens
        try {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('is_logged_in', true);

          if (response.customer != null && response.customer!['customerId'] != null) {
            await prefs.setInt('customer_id', response.customer!['customerId']);
            await prefs.setString('user_email', response.customer!['email'] ?? '');
          } else {
            // fallback to earlier pending data
            if (pendingCustomerId != null) await prefs.setInt('customer_id', pendingCustomerId!);
            if (pendingEmailForLogin != null) await prefs.setString('user_email', pendingEmailForLogin!);
          }

          // Save accessToken
          if (response.accessToken != null && response.accessToken!.isNotEmpty) {
            await prefs.setString('accessToken', response.accessToken!);
            debugPrint('✅ Saved accessToken from login');
          }
          // Save refreshToken
          if (response.refreshToken != null && response.refreshToken!.isNotEmpty) {
            await prefs.setString('refreshToken', response.refreshToken!);
            debugPrint('✅ Saved refreshToken from login');
          }
          // Get FCM token after successful OTP verification
          await PushNotificationService().getToken();
        } catch (e) {
          debugPrint('❌ Failed to save session after login OTP: $e');
        }

        state = RegisterState.idle;
      } else {
        state = RegisterState.error;
      }

      notifyListeners();
      return response;
    } catch (e) {
      state = RegisterState.error;
      message = e.toString();
      notifyListeners();
      return null;
    }
  }
}
