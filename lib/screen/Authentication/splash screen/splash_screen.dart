import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'onboard.dart';
import '../../home/home.dart';
import '../../../services/auth_service.dart';
import '../../../services/push_notification_service.dart';
import '../../../controllers/profile_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Wait for the full GIF duration (5 seconds) then navigate
    Future.delayed(const Duration(milliseconds: 5000), () => _onAnimationFinished());
  }

  Future<void> _onAnimationFinished() async {
    if (!mounted) return;

    final destination = await _determineDestination();

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => destination),
      );
    }
  }

  /// Checks auth state after splash animation and decides where to go
  Future<Widget> _determineDestination() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString('refreshToken') ?? '';
      final accessToken = prefs.getString('accessToken') ?? '';

      debugPrint('╔══════════════════════════════════════════════════════════');
      debugPrint('║ APP STARTUP - Authentication Check');
      debugPrint('║ accessToken present: ${accessToken.isNotEmpty}');
      debugPrint('║ refreshToken present: ${refreshToken.isNotEmpty}');
      debugPrint('╚══════════════════════════════════════════════════════════');

      // No tokens means user is not logged in
      if (refreshToken.isEmpty && accessToken.isEmpty) {
        debugPrint('No token found - redirecting to onboard');
        await _clearAuthData();
        return const OnBoard();
      }

      // Try to refresh the token
      debugPrint('Attempting to refresh token...');
      final refreshResult = await AuthService.refreshToken(refreshToken: refreshToken);

      if (refreshResult['success'] == true && refreshResult['accessToken'] != null) {
        debugPrint('Token refresh successful');

        // Fetch user profile to verify authentication
        debugPrint('Fetching user profile...');
        await context.read<ProfileController>().fetchProfile();

        if (context.read<ProfileController>().customer != null) {
          debugPrint('Profile loaded - user authenticated');
          await prefs.setBool('is_logged_in', true);

          // Get FCM token after successful authentication
          await PushNotificationService().getToken();

          return const Home();
        } else {
          debugPrint('Profile fetch failed after token refresh');
        }
      } else {
        debugPrint('Token refresh failed: ${refreshResult['message'] ?? 'Unknown error'}');
      }

      // Authentication failed
      await _clearAuthData();
      return const OnBoard();
    } catch (e, stackTrace) {
      debugPrint('Authentication check failed: $e');
      debugPrint('Stack trace: $stackTrace');
      await _clearAuthData();
      return const OnBoard();
    }
  }

  /// Clears all authentication data from local storage
  Future<void> _clearAuthData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('accessToken');
      await prefs.remove('refreshToken');
      await prefs.remove('token');
      await prefs.setBool('is_logged_in', false);
      debugPrint('Cleared authentication data');
    } catch (e) {
      debugPrint('Failed to clear auth data: $e');
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF6A00),
      body: SizedBox.expand(
        child: Image.asset(
          'assets/splash_screen.gif',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
