import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'onboard.dart';
import '../../home/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _onAnimationFinished() async {
    if (!mounted) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final logged = prefs.getBool('is_logged_in') ?? false;

      if (logged) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (BuildContext context) => const Home()),
          );
        }
      } else {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (BuildContext context) => const OnBoard()),
          );
        }
      }
    } catch (e) {
      // On error, fall back to OnBoard
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (BuildContext context) => const OnBoard()),
        );
      }
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFFFDDD3), // Light orange (20% orange mixed with white)
        body: Center(
          child: Lottie.asset(
            'assets/splash.json',
            controller: _animationController,
            repeat: false,
            onLoaded: (composition) {
              _animationController.duration = composition.duration;
              _animationController.forward().then((_) => _onAnimationFinished());
            },
          ),
        ),
      ),
    );
  }
}
