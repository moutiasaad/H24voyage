import 'dart:convert';
import '../Model/register_request.dart';
import '../Model/register_response.dart';
import '../Model/verify_otp_response.dart';
import '../Model/login_response.dart';
import '../Model/verify_login_response.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../config/api_config.dart';

class AuthService {
  static Future<RegisterResponse> registerCustomer(
      RegisterRequest request) async {
    try {
      final uri =
          Uri.parse('${ApiConfig.AuthbaseUrl}${ApiConfig.registerCustomer}');
      final headers = ApiConfig.authHeaders;
      final body = jsonEncode(request.toJson());

      debugPrint('╔══════════════════════════════════════════════════════════');
      debugPrint('║ API REQUEST - Register Customer');
      debugPrint('║ URL: $uri');
      debugPrint('║ BODY: $body');
      debugPrint('╚══════════════════════════════════════════════════════════');

      final response = await http.post(uri, headers: headers, body: body);

      debugPrint('╔══════════════════════════════════════════════════════════');
      debugPrint('║ API RESPONSE - Register Customer');
      debugPrint('║ Status Code: ${response.statusCode}');
      debugPrint('║ Body: ${response.body}');
      debugPrint('╚══════════════════════════════════════════════════════════');

      final jsonData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return RegisterResponse.fromJson(jsonData);
      }

      if (jsonData is Map<String, dynamic>) {
        return RegisterResponse.fromJson(jsonData);
      }

      throw Exception('Unexpected response from server');
    } catch (e) {
      debugPrint('❌ Register API Error: $e');
      throw Exception('Erreur lors de l\'inscription');
    }
  }

  static Future<VerifyOtpResponse> verifyRegisterOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final uri = Uri.parse('${ApiConfig.AuthbaseUrl}${ApiConfig.verifyRegisterOtp}');
      final headers = ApiConfig.authHeaders;
      final body = jsonEncode({'email': email, 'otp': otp});

      debugPrint('╔══════════════════════════════════════════════════════════');
      debugPrint('║ API REQUEST - Verify Register OTP');
      debugPrint('║ URL: $uri');
      debugPrint('║ BODY: $body');
      debugPrint('╚══════════════════════════════════════════════════════════');

      final response = await http.post(uri, headers: headers, body: body);

      debugPrint('╔══════════════════════════════════════════════════════════');
      debugPrint('║ API RESPONSE - Verify Register OTP');
      debugPrint('║ Status Code: ${response.statusCode}');
      debugPrint('║ Body: ${response.body}');
      debugPrint('╚══════════════════════════════════════════════════════════');

      final jsonData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return VerifyOtpResponse.fromJson(jsonData);
      }

      if (jsonData is Map<String, dynamic>) {
        return VerifyOtpResponse.fromJson(jsonData);
      }

      throw Exception('Unexpected response from server');
    } catch (e) {
      debugPrint('❌ Verify OTP API Error: $e');
      throw Exception('Erreur lors de la vérification OTP');
    }
  }

  static Future<LoginResponse> login({
    required String email,
  }) async {
    try {
      final uri = Uri.parse('${ApiConfig.AuthbaseUrl}${ApiConfig.login}');
      final headers = ApiConfig.authHeaders;
      final body = jsonEncode({'email': email});

      debugPrint('╔══════════════════════════════════════════════════════════');
      debugPrint('║ API REQUEST - Login');
      debugPrint('║ URL: $uri');
      debugPrint('║ BODY: $body');
      debugPrint('╚══════════════════════════════════════════════════════════');

      final response = await http.post(uri, headers: headers, body: body);

      debugPrint('╔══════════════════════════════════════════════════════════');
      debugPrint('║ API RESPONSE - Login');
      debugPrint('║ Status Code: ${response.statusCode}');
      debugPrint('║ Body: ${response.body}');
      debugPrint('╚══════════════════════════════════════════════════════════');

      final jsonData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return LoginResponse.fromJson(jsonData);
      }

      if (jsonData is Map<String, dynamic>) {
        return LoginResponse.fromJson(jsonData);
      }

      throw Exception('Unexpected response from server');
    } catch (e) {
      debugPrint('❌ Login API Error: $e');
      throw Exception('Erreur lors de la connexion');
    }
  }

  static Future<VerifyLoginResponse> verifyLoginOtp({
    required int customerId,
    required String otp,
  }) async {
    try {
      final uri = Uri.parse('${ApiConfig.AuthbaseUrl}${ApiConfig.verifyLoginOtp}');
      final headers = ApiConfig.authHeaders;
      final body = jsonEncode({'customerId': customerId, 'otp': otp});

      debugPrint('╔══════════════════════════════════════════════════════════');
      debugPrint('║ API REQUEST - Verify Login OTP');
      debugPrint('║ URL: $uri');
      debugPrint('║ BODY: $body');
      debugPrint('╚══════════════════════════════════════════════════════════');

      final response = await http.post(uri, headers: headers, body: body);

      debugPrint('╔══════════════════════════════════════════════════════════');
      debugPrint('║ API RESPONSE - Verify Login OTP');
      debugPrint('║ Status Code: ${response.statusCode}');
      debugPrint('║ Body: ${response.body}');
      debugPrint('╚══════════════════════════════════════════════════════════');

      final jsonData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final prefs = await SharedPreferences.getInstance();

        // Save token (prefer refreshToken, fallback to accessToken)
        if (jsonData['refreshToken'] != null && (jsonData['refreshToken'] as String).isNotEmpty) {
          await prefs.setString('token', jsonData['refreshToken']);
          await prefs.setBool('is_logged_in', true);
          debugPrint("✔ Saved refresh token from verify login OTP");
        } else if (jsonData['accessToken'] != null && (jsonData['accessToken'] as String).isNotEmpty) {
          await prefs.setString('token', jsonData['accessToken']);
          await prefs.setBool('is_logged_in', true);
          debugPrint("✔ Saved access token from verify login OTP");
        }

        return VerifyLoginResponse.fromJson(jsonData);
      }

      // if (jsonData is Map<String, dynamic>) {
      //   return VerifyLoginResponse.fromJson(jsonData);
      // }

      throw Exception('Unexpected response from server');
    } catch (e) {
      debugPrint('❌ Verify Login OTP API Error: $e');
      throw Exception('Erreur lors de la vérification OTP de connexion');
    }
  }

  // Unified getProfile that retries once when token expired
  static Future<Map<String, dynamic>> getProfile() async {
    try {
      final uri = Uri.parse('${ApiConfig.AuthbaseUrl}/auth/b2c/me');
      final headers = Map<String, String>.from(ApiConfig.authHeaders);

      // Attach Authorization header if access token is present in local storage
      try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');
        if (token != null && token.isNotEmpty) {
          headers['Authorization'] = 'Bearer $token';
        }
      } catch (e) {
        debugPrint('❌ Failed to read access token from prefs: $e');
      }

      debugPrint('╔══════════════════════════════════════════════════════════');
      debugPrint('║ API REQUEST - Get Profile (me)');
      debugPrint('║ URL: $uri');
      debugPrint('║ HEADERS: $headers');
      debugPrint('╚══════════════════════════════════════════════════════════');

      final response = await http.get(uri, headers: headers);

      debugPrint('╔══════════════════════════════════════════════════════════');
      debugPrint('║ API RESPONSE - Get Profile (me)');
      debugPrint('║ Status Code: ${response.statusCode}');
      debugPrint('║ Body: ${response.body}');
      debugPrint('╚══════════════════════════════════════════════════════════');

      var jsonData = json.decode(response.body);

      // Detect token expired response and try refresh+retry once
      if (jsonData is Map<String, dynamic> &&
          ((jsonData['error'] != null && jsonData['error'] == 'TOKEN_EXPIRED') ||
              (jsonData['message'] != null && jsonData['message'].toString().toLowerCase().contains('expired')))) {
        debugPrint('⚠️ Access token expired on getProfile, attempting refresh...');
        try {
          final prefs = await SharedPreferences.getInstance();
          final refreshTokenStored = prefs.getString('token');
          if (refreshTokenStored == null || refreshTokenStored.isEmpty) {
            throw Exception('No refresh token available');
          }

          await refreshToken(refreshToken: refreshTokenStored);

          final newPrefs = await SharedPreferences.getInstance();
          final newAccess = newPrefs.getString('token');
          if (newAccess != null && newAccess.isNotEmpty) {
            headers['Authorization'] = 'Bearer $newAccess';
            debugPrint('✔ Retrying Get Profile with new access token');
            final retryResponse = await http.get(uri, headers: headers);
            debugPrint('╔══════════════════════════════════════════════════════════');
            debugPrint('║ API RESPONSE - Get Profile (retry)');
            debugPrint('║ Status Code: ${retryResponse.statusCode}');
            debugPrint('║ Body: ${retryResponse.body}');
            debugPrint('╚══════════════════════════════════════════════════════════');
            jsonData = json.decode(retryResponse.body);
            if (jsonData is Map<String, dynamic>) return jsonData;
          } else {
            throw Exception('Failed to refresh access token');
          }
        } catch (e) {
          debugPrint('❌ Refresh attempt failed: $e');
          if (jsonData is Map<String, dynamic>) return jsonData;
          rethrow;
        }
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (jsonData is Map<String, dynamic>) return jsonData;
      }

      if (jsonData is Map<String, dynamic>) return jsonData;

      throw Exception('Unexpected response from server');
    } catch (e) {
      debugPrint('❌ Get Profile API Error: $e');
      rethrow;
    }
  }

  // Refresh token endpoint - saves returned tokens when present
  static Future<Map<String, dynamic>> refreshToken({
    required String refreshToken,
  }) async {
    try {
      final uri = Uri.parse('${ApiConfig.AuthbaseUrl}/auth/b2c/refresh-token');
      final headers = Map<String, String>.from(ApiConfig.authHeaders);
      // Send the actual refresh token in the body
      final body = jsonEncode({'refreshToken': refreshToken});

      debugPrint('╔══════════════════════════════════════════════════════════');
      debugPrint('║ API REQUEST - Refresh Token');
      debugPrint('║ URL: $uri');
      debugPrint('║ BODY: $body');
      debugPrint('║ HEADERS: $headers');
      debugPrint('╚══════════════════════════════════════════════════════════');

      final response = await http.post(uri, headers: headers, body: body);

      debugPrint('╔══════════════════════════════════════════════════════════');
      debugPrint('║ API RESPONSE - Refresh Token');
      debugPrint('║ Status Code: ${response.statusCode}');
      debugPrint('║ Body: ${response.body}');
      debugPrint('╚══════════════════════════════════════════════════════════');

      final jsonData = json.decode(response.body);

      if (jsonData is Map<String, dynamic>) {
        // Save the new token (prefer refreshToken, fallback to accessToken)
        try {
          final prefs = await SharedPreferences.getInstance();

          // Save new refresh token (one-time use, so we need the new one)
          if (jsonData['refreshToken'] != null && (jsonData['refreshToken'] as String).isNotEmpty) {
            await prefs.setString('token', jsonData['refreshToken']);
            debugPrint('✔ Saved new refresh token from refresh endpoint');
          } else if (jsonData['accessToken'] != null && (jsonData['accessToken'] as String).isNotEmpty) {
            await prefs.setString('token', jsonData['accessToken']);
            debugPrint('✔ Saved new access token from refresh endpoint');
          }
        } catch (e) {
          debugPrint('❌ Failed to save token from refresh endpoint: $e');
        }

        return jsonData;
      }

      throw Exception('Unexpected response from server');
    } catch (e) {
      debugPrint('❌ Refresh Token API Error: $e');
      rethrow;
    }
  }

  // Change password endpoint
  static Future<Map<String, dynamic>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final uri = Uri.parse('${ApiConfig.AuthbaseUrl}/auth/b2c/set-password');
      final headers = Map<String, String>.from(ApiConfig.authHeaders);

      // Attach Authorization header
      try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');
        if (token != null && token.isNotEmpty) {
          headers['Authorization'] = 'Bearer $token';
        }
      } catch (e) {
        debugPrint('❌ Failed to read access token from prefs: $e');
      }

      final body = jsonEncode({
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      });

      debugPrint('╔══════════════════════════════════════════════════════════');
      debugPrint('║ API REQUEST - Change Password');
      debugPrint('║ URL: $uri');
      debugPrint('║ HEADERS: $headers');
      debugPrint('╚══════════════════════════════════════════════════════════');

      final response = await http.post(uri, headers: headers, body: body);

      debugPrint('╔══════════════════════════════════════════════════════════');
      debugPrint('║ API RESPONSE - Change Password');
      debugPrint('║ Status Code: ${response.statusCode}');
      debugPrint('║ Body: ${response.body}');
      debugPrint('╚══════════════════════════════════════════════════════════');

      final jsonData = json.decode(response.body);

      if (jsonData is Map<String, dynamic>) {
        return jsonData;
      }

      throw Exception('Unexpected response from server');
    } catch (e) {
      debugPrint('❌ Change Password API Error: $e');
      rethrow;
    }
  }

  // Logout endpoint
  static Future<Map<String, dynamic>> logout() async {
    try {
      final uri = Uri.parse('${ApiConfig.AuthbaseUrl}/auth/b2c/logout');
      final headers = Map<String, String>.from(ApiConfig.authHeaders);

      // Attach Authorization header
      try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');
        if (token != null && token.isNotEmpty) {
          headers['Authorization'] = 'Bearer $token';
        }
      } catch (e) {
        debugPrint('❌ Failed to read access token from prefs: $e');
      }

      debugPrint('╔══════════════════════════════════════════════════════════');
      debugPrint('║ API REQUEST - Logout');
      debugPrint('║ URL: $uri');
      debugPrint('║ HEADERS: $headers');
      debugPrint('╚══════════════════════════════════════════════════════════');

      final response = await http.post(uri, headers: headers);

      debugPrint('╔══════════════════════════════════════════════════════════');
      debugPrint('║ API RESPONSE - Logout');
      debugPrint('║ Status Code: ${response.statusCode}');
      debugPrint('║ Body: ${response.body}');
      debugPrint('╚══════════════════════════════════════════════════════════');

      final jsonData = json.decode(response.body);

      if (jsonData is Map<String, dynamic>) {
        // Clear local auth data after logout
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');
        await prefs.setBool('is_logged_in', false);
        debugPrint('✔ Cleared local auth data after logout');

        return jsonData;
      }

      throw Exception('Unexpected response from server');
    } catch (e) {
      debugPrint('❌ Logout API Error: $e');

      // Even if API fails, clear local data for security
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');
        await prefs.setBool('is_logged_in', false);
        debugPrint('✔ Cleared local auth data (fallback)');
      } catch (_) {}

      rethrow;
    }
  }

  // Disable account endpoint
  static Future<Map<String, dynamic>> disableAccount() async {
    try {
      final uri = Uri.parse('${ApiConfig.AuthbaseUrl}/auth/b2c/disable-account');
      final headers = Map<String, String>.from(ApiConfig.authHeaders);

      // Attach Authorization header
      try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');
        if (token != null && token.isNotEmpty) {
          headers['Authorization'] = 'Bearer $token';
        }
      } catch (e) {
        debugPrint('❌ Failed to read access token from prefs: $e');
      }

      debugPrint('╔══════════════════════════════════════════════════════════');
      debugPrint('║ API REQUEST - Disable Account');
      debugPrint('║ URL: $uri');
      debugPrint('║ HEADERS: $headers');
      debugPrint('╚══════════════════════════════════════════════════════════');

      final response = await http.post(uri, headers: headers);

      debugPrint('╔══════════════════════════════════════════════════════════');
      debugPrint('║ API RESPONSE - Disable Account');
      debugPrint('║ Status Code: ${response.statusCode}');
      debugPrint('║ Body: ${response.body}');
      debugPrint('╚══════════════════════════════════════════════════════════');

      final jsonData = json.decode(response.body);

      if (jsonData is Map<String, dynamic>) {
        // If account disabled successfully, clear local data
        if (jsonData['success'] == true) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove('token');
          await prefs.setBool('is_logged_in', false);
          debugPrint('✔ Cleared local auth data after account disable');
        }
        return jsonData;
      }

      throw Exception('Unexpected response from server');
    } catch (e) {
      debugPrint('❌ Disable Account API Error: $e');
      rethrow;
    }
  }

  // Update profile with refresh+retry support
  static Future<Map<String, dynamic>> updateProfile({
    required Map<String, dynamic> bodyData,
  }) async {
    try {
      final uri = Uri.parse('${ApiConfig.AuthbaseUrl}/auth/b2c/me');
      final headers = Map<String, String>.from(ApiConfig.authHeaders);

      // Attach Authorization header if access token is present in local storage
      try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');
        if (token != null && token.isNotEmpty) {
          headers['Authorization'] = 'Bearer $token';
        }
      } catch (e) {
        debugPrint('❌ Failed to read access token from prefs: $e');
      }

      final body = jsonEncode(bodyData);

      debugPrint('╔══════════════════════════════════════════════════════════');
      debugPrint('║ API REQUEST - Update Profile (me)');
      debugPrint('║ URL: $uri');
      debugPrint('║ HEADERS: $headers');
      debugPrint('║ BODY: $body');
      debugPrint('╚══════════════════════════════════════════════════════════');

      // Use PUT for update; some APIs accept POST as well — adjust if needed
      final response = await http.put(uri, headers: headers, body: body);

      debugPrint('╔══════════════════════════════════════════════════════════');
      debugPrint('║ API RESPONSE - Update Profile (me)');
      debugPrint('║ Status Code: ${response.statusCode}');
      debugPrint('║ Body: ${response.body}');
      debugPrint('╚══════════════════════════════════════════════════════════');

      var jsonData = json.decode(response.body);

      // If token expired response detected, try to refresh token and retry once
      if (jsonData is Map<String, dynamic> &&
          ((jsonData['error'] != null && jsonData['error'] == 'TOKEN_EXPIRED') ||
              (jsonData['message'] != null && jsonData['message'].toString().toLowerCase().contains('expired')))) {
        debugPrint('⚠️ Access token expired, attempting refresh...');
        try {
          final prefs = await SharedPreferences.getInstance();
          final refreshTokenStored = prefs.getString('token');
          if (refreshTokenStored == null || refreshTokenStored.isEmpty) {
            throw Exception('No refresh token available');
          }

          await refreshToken(refreshToken: refreshTokenStored);
          // After refresh, update Authorization header and retry
          final newPrefs = await SharedPreferences.getInstance();
          final newAccess = newPrefs.getString('token');
          if (newAccess != null && newAccess.isNotEmpty) {
            headers['Authorization'] = 'Bearer $newAccess';
            debugPrint('✔ Retrying Update Profile with new access token');
            final retryResponse = await http.put(uri, headers: headers, body: body);
            debugPrint('╔══════════════════════════════════════════════════════════');
            debugPrint('║ API RESPONSE - Update Profile (retry)');
            debugPrint('║ Status Code: ${retryResponse.statusCode}');
            debugPrint('║ Body: ${retryResponse.body}');
            debugPrint('╚══════════════════════════════════════════════════════════');
            jsonData = json.decode(retryResponse.body);
            if (jsonData is Map<String, dynamic>) return jsonData;
          } else {
            throw Exception('Failed to refresh access token');
          }
        } catch (e) {
          debugPrint('❌ Refresh attempt failed: $e');
          // Return the original token expired response to caller if possible
          if (jsonData is Map<String, dynamic>) return jsonData;
          rethrow;
        }
      }

      if (jsonData is Map<String, dynamic>) return jsonData;

      throw Exception('Unexpected response from server');
    } catch (e) {
      debugPrint('❌ Update Profile API Error: $e');
      rethrow;
    }
  }
}
