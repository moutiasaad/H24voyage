import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import '../services/auth_service.dart';
import '../services/post_images_service.dart';

class ProfileController extends ChangeNotifier {
  ProfileController._internal();

  static final ProfileController instance = ProfileController._internal();

  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _customer;

  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, dynamic>? get customer => _customer;

  String get firstName => _customer != null ? (_customer!['firstName'] ?? '') : '';
  String get lastName => _customer != null ? (_customer!['lastName'] ?? '') : '';
  String get email => _customer != null ? (_customer!['email'] ?? '') : '';

  Future<void> fetchProfile() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final json = await AuthService.getProfile();

      if (json['success'] == true && json['customer'] is Map<String, dynamic>) {
        _customer = Map<String, dynamic>.from(json['customer']);
        _error = null;
      } else {
        // Attempt to refresh token if message indicates auth issue
        final attempted = await _attemptRefreshAndRetry();
        if (!attempted) {
          _customer = null;
          _error = json['message']?.toString() ?? 'Failed to load profile';
        }
      }
    } catch (e) {
      // On network/auth error, try refreshing the token and retrying the request
      final attempted = await _attemptRefreshAndRetry();
      if (!attempted) {
        _customer = null;
        _error = e.toString();
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> _attemptRefreshAndRetry() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString('refreshToken') ?? '';
      if (refreshToken.isEmpty) return false;

      // Call refresh token endpoint
      final refreshRes = await AuthService.refreshToken(refreshToken: refreshToken);
      if (refreshRes['success'] == true) {
        // access_token should have been saved by refreshToken(); now retry getProfile
        try {
          final json2 = await AuthService.getProfile();
          if (json2['success'] == true && json2['customer'] is Map<String, dynamic>) {
            _customer = Map<String, dynamic>.from(json2['customer']);
            _error = null;
            return true;
          } else {
            return false;
          }
        } catch (e) {
          return false;
        }
      }

      return false;
    } catch (e) {
      debugPrint('❌ Error during refresh+retry: $e');
      return false;
    }
  }

  /// Local update helper (used by edit profile screen after success)
  void updateLocalCustomer(Map<String, dynamic> newData) {
    _customer = {...?_customer, ...newData};
    notifyListeners();
  }

  /// Clear all customer data (used on logout)
  void clearCustomer() {
    _customer = null;
    _error = null;
    notifyListeners();
  }

  /// Update profile on server using provided body data.
  /// Returns the server response map (contains 'success' and 'message').
  Future<Map<String, dynamic>?> updateProfile(Map<String, dynamic> body) async {
    _isLoading = true;
    notifyListeners();

    try {
      final res = await AuthService.updateProfile(bodyData: body);
      if (res['success'] == true) {
        // either update local customer directly or re-fetch profile
        if (res['customer'] is Map<String, dynamic>) {
          _customer = Map<String, dynamic>.from(res['customer']);
        } else {
          // try to refresh local copy from server
          try {
            final profile = await AuthService.getProfile();
            if (profile['success'] == true && profile['customer'] is Map<String, dynamic>) {
              _customer = Map<String, dynamic>.from(profile['customer']);
            }
          } catch (_) {
            // ignore
          }
        }
        _error = null;
      } else {
        _error = res['message']?.toString() ?? 'Update failed';
      }

      _isLoading = false;
      notifyListeners();
      return res;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  /// Upload a single image file and return the public URL or null on failure.
  /// This uses PostImagesService with automatic fallback to multiple hosts.
  /// Default: catbox.moe (most reliable), fallback: 0x0.st
  Future<String?> postImage(File file, {String? apiKey, String? host}) async {
    try {
      // If a specific host is provided, use it directly
      final res = host != null
          ? await PostImagesService.upload(file, host: host, apiKey: apiKey)
          : await PostImagesService.uploadWithFallback(file, apiKey: apiKey);

      if (res['success'] == true && res['url'] is String) {
        return res['url'] as String;
      }

      _error = res['message']?.toString() ?? 'Image upload failed';
      notifyListeners();
      return null;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  /// Upload multiple images and return the list of URLs (or null entries for failures).
  Future<List<String?>> postImages(List<File> files, {String? apiKey, String? host}) async {
    final results = <String?>[];
    for (final f in files) {
      final url = await postImage(f, apiKey: apiKey, host: host);
      results.add(url);
    }
    return results;
  }
}
