import 'package:flight_booking/generated/l10n.dart' as lang;
import 'package:flight_booking/screen/support/support.dart';
import 'package:flight_booking/screen/widgets/constant.dart';
import 'package:flutter/material.dart';
import '../../controllers/profile_controller.dart';
import '../Authentication/sign_up_screen.dart';
import '../my_boking_screen/my_boking.dart';
import '../profile/profile_screen.dart';
import 'home_screen.dart';

class Home extends StatefulWidget {
  final int initialIndex;
  final String? userName;
  final String? userProfileImage;

  const Home({
    Key? key,
    this.initialIndex = 0,
    this.userName,
    this.userProfileImage,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late int _currentPage;

  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialIndex;

    // Listen to profile changes to update UI
    ProfileController.instance.addListener(_onProfileChanged);

    _widgetOptions = <Widget>[
      const HomeScreen(),
      MyBooking(onBack: () => setState(() => _currentPage = 0)),
      SupportMain(onBack: () => setState(() => _currentPage = 0)),
      Profile(onBack: () => setState(() => _currentPage = 0)),
    ];
  }

  @override
  void dispose() {
    ProfileController.instance.removeListener(_onProfileChanged);
    super.dispose();
  }

  void _onProfileChanged() {
    if (mounted) setState(() {});
  }

  String get _userName {
    final profile = ProfileController.instance;
    if (profile.customer != null) {
      final first = profile.firstName;
      final last = profile.lastName;
      if (first.isNotEmpty || last.isNotEmpty) {
        return '$first $last'.trim();
      }
    }
    return '';
  }

  String? get _userProfileImage {
    final customer = ProfileController.instance.customer;
    if (customer != null) {
      final image = customer['profileImage'] ?? customer['profileImageUrl'] ?? customer['avatar'];
      if (image is String && image.isNotEmpty) return image;
    }
    return null;
  }

  bool get _isLoggedIn => ProfileController.instance.customer != null;

  void _onNavTap(int index) {
    // Tabs 1 (Réservations), 2 (Support), 3 (Profile) require login
    if (index != 0 && !_isLoggedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SignUp()),
      );
      return;
    }
    setState(() => _currentPage = index);
  }

  String _getUserInitial() {
    if (_userName.isNotEmpty) {
      return _userName[0].toUpperCase();
    }
    return 'U';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_currentPage),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
            child: Builder(
              builder: (context) {
                final t = lang.S.of(context);
                return Row(
                  children: [
                    _buildNavItem(
                      index: 0,
                      iconPath: 'assets/rechercher.png',
                      label: t.navSearch,
                    ),
                    _buildNavItem(
                      index: 1,
                      iconPath: 'assets/valise.png',
                      label: t.navBookings,
                    ),
                    _buildNavItem(
                      index: 2,
                      iconPath: 'assets/assistance-telephonique.png',
                      label: t.navSupport,
                    ),
                    _buildProfileNavItem(
                      index: 3,
                      label: _isLoggedIn && _userName.isNotEmpty ? _userName : t.navMyAccount,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String iconPath,
    required String label,
  }) {
    final bool isSelected = _currentPage == index;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _onNavTap(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              iconPath,
              width: 24,
              height: 24,
              color: isSelected ? kPrimaryColor : kSubTitleColor,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? kPrimaryColor : kSubTitleColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileNavItem({
    required int index,
    required String label,
  }) {
    final bool isSelected = _currentPage == index;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _onNavTap(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Profile avatar with orange background
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B35), // Orange color
                shape: BoxShape.circle,
                image: _userProfileImage != null
                    ? DecorationImage(
                        image: NetworkImage(_userProfileImage!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: _userProfileImage == null
                  ? Center(
                      child: Text(
                        _getUserInitial(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? kPrimaryColor : kSubTitleColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

