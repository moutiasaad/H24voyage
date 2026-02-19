import 'package:flight_booking/generated/l10n.dart' as lang;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import '../../controllers/profile_controller.dart';
import '../../services/auth_service.dart';
import '../widgets/constant.dart';
import '../widgets/button_global.dart';
import '../Authentication/welcome_screen.dart';
import 'my_profile/my_profile.dart';
import 'my_profile/edit_profile.dart';
import 'setting/setting.dart';
import 'setting/change_password.dart';
import 'setting/currency.dart';
import 'setting/languase.dart';
import 'setting/notification.dart';
import 'Privacy_Policy/privicy_policy.dart';
import '../support/support_main.dart';
import '../support/faq_screen.dart';
import '../notification/notification_screen.dart';

/// Model for menu items - dynamic structure for future API integration
class ProfileMenuItem {
  final String id;
  final String title;
  final IconData? icon;
  final String? iconAsset; // Asset image path
  final Widget? destination;
  final VoidCallback? onTap;
  final String? badge;

  ProfileMenuItem({
    required this.id,
    required this.title,
    this.icon,
    this.iconAsset,
    this.destination,
    this.onTap,
    this.badge,
  }) : assert(icon != null || iconAsset != null, 'Either icon or iconAsset must be provided');

  /// Factory constructor for API response mapping
  factory ProfileMenuItem.fromJson(Map<String, dynamic> json) {
    return ProfileMenuItem(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      icon: _getIconFromString(json['icon'] ?? 'person'),
      badge: json['badge'],
    );
  }

  static IconData _getIconFromString(String iconName) {
    switch (iconName) {
      case 'person':
        return CupertinoIcons.person_fill;
      case 'group':
        return CupertinoIcons.person_2_fill;
      case 'gift':
        return CupertinoIcons.gift_fill;
      case 'lock':
        return CupertinoIcons.lock_fill;
      case 'wallet':
        return CupertinoIcons.creditcard_fill;
      case 'globe':
        return CupertinoIcons.globe;
      case 'bell':
        return CupertinoIcons.bell_fill;
      case 'doc':
        return CupertinoIcons.doc_text_fill;
      case 'logout':
        return CupertinoIcons.square_arrow_right;
      default:
        return CupertinoIcons.circle_fill;
    }
  }
}

/// Model for user profile - dynamic structure for future API integration
class UserProfile {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? avatarUrl;

  UserProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.avatarUrl,
  });

  String get fullName => '$firstName $lastName';

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      avatarUrl: json['avatar_url'],
    );
  }
}

class Profile extends StatefulWidget {
  final VoidCallback? onBack;
  const Profile({Key? key, this.onBack}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final ProfileController _profileController = ProfileController.instance;

  @override
  void initState() {
    super.initState();
    _profileController.addListener(_onProfileChanged);
  }

  List<ProfileMenuItem> _buildAccountMenuItems(BuildContext context) {
    final t = lang.S.of(context);
    return [
      ProfileMenuItem(
        id: 'personal_info',
        title: t.profilePersonalInfo,
        iconAsset: 'assets/profileIcon.png',
        destination: const EditProfile(),
      ),
      ProfileMenuItem(
        id: 'travelers',
        title: t.profileRegisteredTravelers,
        iconAsset: 'assets/voyageIcon.png',
      ),
      ProfileMenuItem(
        id: 'referral',
        title: t.profileReferFriend,
        iconAsset: 'assets/usersIcon.png',
        onTap: () => _handleReferral(),
      ),
      ProfileMenuItem(
        id: 'security',
        title: t.profileSecuritySettings,
        iconAsset: 'assets/paramIcon.png',
        destination: const ChangePassword(),
      ),
    ];
  }

  List<ProfileMenuItem> _buildSettingsMenuItems(BuildContext context) {
    final t = lang.S.of(context);
    return [
      ProfileMenuItem(
        id: 'currency',
        title: t.profileCurrencies,
        iconAsset: 'assets/walletIcon.png',
        destination: const Currency(),
      ),
      ProfileMenuItem(
        id: 'language',
        title: t.profileLanguages,
        iconAsset: 'assets/langIcon.png',
        destination: const Language(),
      ),
      ProfileMenuItem(
        id: 'notifications',
        title: t.profileNotifications,
        iconAsset: 'assets/notif.png',
        destination: const NotificationScreen(),
      ),
      ProfileMenuItem(
        id: 'terms',
        title: t.profileTerms,
        iconAsset: 'assets/cadeauIcon.png',
        destination: const PrivacyPolicy(),
      ),
    ];
  }

  List<ProfileMenuItem> _buildHelpMenuItems(BuildContext context) {
    final t = lang.S.of(context);
    return [
      ProfileMenuItem(
        id: 'contact',
        title: t.profileContactSupport,
        iconAsset: 'assets/assistIcon.png',
        destination: const SupportMain(),
      ),
      ProfileMenuItem(
        id: 'faq',
        title: t.profileFaq,
        iconAsset: 'assets/fqaIcon.png',
        destination: const FaqScreen(),
      ),
    ];
  }

  void _onProfileChanged() => setState(() {});

  void _handleReferral() {
    // TODO: Implement referral logic
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(lang.S.of(context).profileReferralTitle),
        content: Text(lang.S.of(context).profileReferralMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(lang.S.of(context).profileClose),
          ),
        ],
      ),
    );
  }

  Future<void> _showDisableAccountDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Row(
            children: [
              Icon(IconlyBold.danger, color: Colors.red, size: 28),
              const SizedBox(width: 10),
              Text(lang.S.of(context).profileDisableAccount),
            ],
          ),
          content: Text(
            lang.S.of(context).profileDisableConfirm,
            style: const TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                lang.S.of(context).profileCancel,
                style: kTextStyle.copyWith(color: kSubTitleColor),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () => Navigator.pop(context, true),
              child: Text(lang.S.of(context).profileDisable),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      _disableAccount();
    }
  }

  Future<void> _disableAccount() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final result = await AuthService.disableAccount();

      if (Navigator.of(context).canPop()) Navigator.of(context).pop();

      if (result['success'] == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? lang.S.of(context).profileDisableSuccess),
              backgroundColor: kSuccessGreen,
            ),
          );

          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const WelcomeScreen()),
            (route) => false,
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? lang.S.of(context).profileDisableFailed),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (Navigator.of(context).canPop()) Navigator.of(context).pop();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(lang.S.of(context).profileError(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _actionButton({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    Color? titleColor,
    required VoidCallback onTap,
  }) {
    return TappableCard(
      onTap: onTap,
      child: Card(
        elevation: 1.3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: kBorderColorTextField, width: 0.5),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          leading: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconBg,
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          title: Text(
            title,
            style: kTextStyle.copyWith(
              color: titleColor ?? kTitleColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: titleColor ?? kSubTitleColor,
          ),
        ),
      ),
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(lang.S.of(context).profileLogoutTitle),
        content: Text(lang.S.of(context).profileLogoutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(lang.S.of(context).profileCancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _performLogout();
            },
            child: Text(
              lang.S.of(context).profileLogoutAction,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _performLogout() async {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await AuthService.logout();
    } catch (_) {
      // AuthService.logout already clears local data even on failure
    }

    // Clear profile data in memory
    ProfileController.instance.clearCustomer();

    if (!mounted) return;

    // Dismiss loading
    if (Navigator.of(context).canPop()) Navigator.of(context).pop();

    // Navigate to welcome screen and clear stack
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Orange Gradient App Bar
                _buildAppBar(),

                // Content
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),

                        // User header (photo/name/email)
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 4),
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       Text(
                        //         '${_profileController.firstName} ${_profileController.lastName}'.trim(),
                        //         style: const TextStyle(
                        //           fontSize: 20,
                        //           fontWeight: FontWeight.bold,
                        //           color: Color(0xFF1C1C1E),
                        //         ),
                        //       ),
                        //       const SizedBox(height: 4),
                        //       Text(
                        //         _profileController.email,
                        //         style: const TextStyle(
                        //           fontSize: 14,
                        //           color: Color(0xFF6B6B6F),
                        //         ),
                        //       ),
                        //       const SizedBox(height: 16),
                        //     ],
                        //   ),
                        // ),

                        // Section: Gérer mon compte
                        _buildSectionTitle(lang.S.of(context).profileManageAccount),
                        const SizedBox(height: 12),
                        _buildMenuCard(_buildAccountMenuItems(context)),

                        const SizedBox(height: 24),

                        // Section: Paramètre
                        _buildSectionTitle(lang.S.of(context).profileSettingsSection),
                        const SizedBox(height: 12),
                        _buildMenuCard(_buildSettingsMenuItems(context)),

                        const SizedBox(height: 24),

                        // Section: Aide
                        _buildSectionTitle(lang.S.of(context).profileHelpSection),
                        const SizedBox(height: 12),
                        _buildMenuCard(_buildHelpMenuItems(context)),

                        const SizedBox(height: 24),

                        // Logout Button
                        _buildLogoutButton(),

                        const SizedBox(height: 16),

                        // Disable account button
                        _actionButton(
                          icon: IconlyLight.delete,
                          iconColor: Colors.red,
                          iconBg: Colors.red.withOpacity(0.1),
                          title: lang.S.of(context).profileDisableAccount,
                          titleColor: Colors.red,
                          onTap: () => _showDisableAccountDialog(),
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  /// Builds the orange gradient app bar with bottom border radius
  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 60,
      floating: true,
      snap: true,
      pinned: false,
      elevation: 0,
      backgroundColor: Colors.transparent,
      leadingWidth: 40,
      leading: SmallTapEffect(
        onTap: () {
          if (widget.onBack != null) {
            widget.onBack!();
          } else {
            Navigator.pop(context);
          }
        },
        child: const Padding(
          padding: EdgeInsets.all(12.0),
          child: Icon(
            CupertinoIcons.back,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
      title: Text(
        // Use fetched profile name fallback to empty
        '${_profileController.firstName} ${_profileController.lastName}'.trim(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      centerTitle: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFF8C42),
                Color(0xFFFF6B35),
                kPrimaryColor,
              ],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
    );
  }

  /// Builds a section title
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF3C3C43),
          letterSpacing: -0.3,
        ),
      ),
    );
  }

  /// Builds a menu card with items
  Widget _buildMenuCard(List<ProfileMenuItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == items.length - 1;

          return _buildMenuItem(item, showDivider: !isLast);
        }).toList(),
      ),
    );
  }

  /// Builds a single menu item row
  Widget _buildMenuItem(ProfileMenuItem item, {bool showDivider = true}) {
    return TappableCard(
      onTap: () {
        if (item.destination != null) {
          item.destination!.launch(context);
        } else if (item.onTap != null) {
          item.onTap!();
        }
      },
      scaleFactor: 0.98,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // Icon or Asset Image
                item.iconAsset != null
                    ? Image.asset(
                        item.iconAsset!,
                        width: 28,
                        height: 28,
                      )
                    : Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: kPrimaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          item.icon,
                          size: 18,
                          color: kPrimaryColor,
                        ),
                      ),
                const SizedBox(width: 14),

                // Title
                Expanded(
                  child: Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF1C1C1E),
                      letterSpacing: -0.3,
                    ),
                  ),
                ),

                // Badge (if any)
                if (item.badge != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      item.badge!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],

                // Chevron
                const Icon(
                  CupertinoIcons.chevron_right,
                  size: 16,
                  color: Color(0xFFC7C7CC),
                ),
              ],
            ),
          ),

          // Divider
          if (showDivider)
            Padding(
              padding: const EdgeInsets.only(left: 62),
              child: Container(
                height: 0.5,
                color: const Color(0xFFE5E5EA),
              ),
            ),
        ],
      ),
    );
  }

  /// Builds the logout button - Premium iOS style
  Widget _buildLogoutButton() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFCDD2).withOpacity(0.5),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TappableCard(
        onTap: _handleLogout,
        scaleFactor: 0.97,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFF0F0),
              Color(0xFFFFE8E8),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFFFCDD2).withOpacity(0.3),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Center(
          child: Text(
            lang.S.of(context).profileLogoutButton,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Color(0xFFE53935),
              letterSpacing: 0.2,
            ),
          ),
        ),
      ),
    );
  }
}
