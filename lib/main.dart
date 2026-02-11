import 'package:flight_booking/config/utils/AppTheme.dart';
import 'package:flight_booking/screen/Authentication/splash%20screen/splash_screen.dart';
import 'package:flight_booking/screen/Authentication/welcome_screen.dart';
import 'package:flight_booking/screen/provider/providers.dart';
import 'package:flight_booking/services/auth_service.dart';
import 'package:flight_booking/controllers/profile_controller.dart';
import 'package:flight_booking/screen/home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'generated/l10n.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Determine initial screen by checking authentication state
  Widget initialScreen = await _determineInitialScreen();

  runApp(MyApp(initialScreen: initialScreen));
}

/// Determines the initial screen based on authentication state
/// Returns Home if authenticated, SplashScreen if not
Future<Widget> _determineInitialScreen() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('refreshToken') ?? '';
    final accessToken = prefs.getString('accessToken') ?? '';

    debugPrint('╔══════════════════════════════════════════════════════════');
    debugPrint('║ 🚀 APP STARTUP - Authentication Check');
    debugPrint('║ accessToken present: ${accessToken.isNotEmpty}');
    debugPrint('║ refreshToken present: ${refreshToken.isNotEmpty}');
    debugPrint('╚══════════════════════════════════════════════════════════');

    // No refresh token means user is not logged in
    if (refreshToken.isEmpty && accessToken.isEmpty) {
      debugPrint('❌ No token found - redirecting to splash/welcome');
      await _clearAuthData();
      return const SplashScreen();
    }

    // Try to refresh the token using the refreshToken
    debugPrint('🔄 Attempting to refresh token...');
    final refreshResult = await AuthService.refreshToken(refreshToken: refreshToken);

    if (refreshResult['success'] == true && refreshResult['accessToken'] != null) {
      debugPrint('✅ Token refresh successful');

      // Fetch user profile to verify authentication
      debugPrint('📥 Fetching user profile...');
      await ProfileController.instance.fetchProfile();

      if (ProfileController.instance.customer != null) {
        debugPrint('✅ Profile loaded successfully - user authenticated');
        await prefs.setBool('is_logged_in', true);
        return const Home();
      } else {
        debugPrint('⚠️ Profile fetch failed after token refresh');
      }
    } else {
      debugPrint('❌ Token refresh failed: ${refreshResult['message'] ?? 'Unknown error'}');
    }

    // If we reach here, authentication failed - clear data and show splash
    await _clearAuthData();
    return const SplashScreen();

  } catch (e, stackTrace) {
    debugPrint('❌ Authentication check failed: $e');
    debugPrint('Stack trace: $stackTrace');

    // On error, clear auth data and show splash screen
    await _clearAuthData();
    return const SplashScreen();
  }
}

/// Clears all authentication data from local storage
Future<void> _clearAuthData() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
    await prefs.remove('token'); // legacy key cleanup
    await prefs.setBool('is_logged_in', false);
    debugPrint('🧹 Cleared authentication data');
  } catch (e) {
    debugPrint('❌ Failed to clear auth data: $e');
  }
}

class MyApp extends StatelessWidget {
  final Widget initialScreen;

  const MyApp({Key? key, required this.initialScreen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LanguageChangeProvider>(
      create: (context) => LanguageChangeProvider(),
      child: Builder(
        builder: (context) => MaterialApp(
          locale: Provider.of<LanguageChangeProvider>(context, listen: true).currentLocale,
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          title: 'Flight Booking',
          theme: AppTheme.lightTheme,
          home: initialScreen,

        )


      ),
    );
  }
}
