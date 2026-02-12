import 'package:flight_booking/screen/History_Screen/history_screen.dart';
import 'package:flight_booking/screen/support/support.dart';
import 'package:flight_booking/screen/widgets/button_global.dart';
import 'package:flight_booking/screen/widgets/constant.dart';
import 'package:flutter/material.dart';
import '../my_boking_screen/my_boking.dart';
import '../profile/profile_screen.dart';
import 'home_screen.dart';

class Home extends StatefulWidget {
  final int initialIndex;
  // User data - can be updated from API
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

  // Dynamic user data - can be updated from API
  String? _userName;
  String? _userProfileImage;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    MyBooking(),
    SupportMain(),
    Profile(),
  ];

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialIndex;
    _userName = widget.userName;
    _userProfileImage = widget.userProfileImage;
  }

  // Method to update user data from API
  void updateUserData({String? userName, String? profileImage}) {
    setState(() {
      _userName = userName;
      _userProfileImage = profileImage;
    });
  }

  // Get user initial for avatar
  String _getUserInitial() {
    if (_userName != null && _userName!.isNotEmpty) {
      return _userName![0].toUpperCase();
    }
    return 'U'; // Default letter if no username
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
            child: Row(
              children: [
                _buildNavItem(
                  index: 0,
                  iconPath: 'assets/rechercher.png',
                  label: 'Rechercher',
                ),
                _buildNavItem(
                  index: 1,
                  iconPath: 'assets/valise.png',
                  label: 'Réservations',
                ),
                _buildNavItem(
                  index: 2,
                  iconPath: 'assets/assistance-telephonique.png',
                  label: 'Support client',
                ),
                _buildProfileNavItem(
                  index: 3,
                  label: 'Mon compte',
                ),
              ],
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
        onTap: () => setState(() => _currentPage = index),
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
        onTap: () => setState(() => _currentPage = index),
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

