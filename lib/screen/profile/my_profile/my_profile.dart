import 'package:country_code_picker/country_code_picker.dart';
import 'package:flight_booking/screen/profile/my_profile/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'dart:io';
import 'package:flutter_iconly/flutter_iconly.dart';
import '../../../controllers/profile_controller.dart';
import '../../../services/auth_service.dart';
import '../../widgets/constant.dart';
import '../../widgets/button_global.dart';
import '../../Authentication/welcome_screen.dart';
import '../setting/change_password.dart';
import 'package:flight_booking/generated/l10n.dart' as lang;

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final ImagePicker _picker = ImagePicker();
  XFile? image;

  // controller
  final ProfileController _profileController = ProfileController.instance;

  // local fallbacks
  String fullName = 'John Doe';
  String email = 'johendoe@gmail.com';
  String phone = '017XXXXXXXX';
  String? photoUrl;

  Future<void> getImage() async {
    image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // listen for changes and fetch profile
    _profileController.addListener(_onProfileChanged);
    _profileController.fetchProfile();
  }

  void _onProfileChanged() {
    final customer = _profileController.customer;
    if (customer != null) {
      final first = (customer['firstName'] ?? '') as String;
      final last = (customer['lastName'] ?? '') as String;
      fullName = '$first ${last ?? ''}'.trim();
      email = (customer['email'] ?? '') as String;
      phone = (customer['mobile'] ?? phone) as String? ?? phone;
      photoUrl = (customer['photo'] ?? '') as String?;
      if (photoUrl != null && photoUrl!.isEmpty) photoUrl = null;
    }
    setState(() {});
  }

  /// Helper to build the appropriate profile image widget
  /// Priority: local picked image > network URL > default asset
  Widget _buildProfileImage() {
    // If user picked a new image locally, show it
    if (image != null) {
      return Image.file(
        File(image!.path),
        fit: BoxFit.cover,
        width: 90,
        height: 90,
      );
    }

    // If profile has a photo URL, show network image
    if (photoUrl != null && photoUrl!.isNotEmpty) {
      return Image.network(
        photoUrl!,
        fit: BoxFit.cover,
        width: 90,
        height: 90,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                  : null,
              strokeWidth: 2,
              color: kPrimaryColor,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          // If network image fails, show default
          return Image.asset(
            'assets/logo.png',
            fit: BoxFit.cover,
            width: 90,
            height: 90,
          );
        },
      );
    }

    // Default fallback image
    return Image.asset(
      'assets/logo.png',
      fit: BoxFit.cover,
      width: 90,
      height: 90,
    );
  }

  /// Show confirmation dialog for logout
  Future<void> _showLogoutDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Row(
            children: [
              Icon(IconlyBold.logout, color: kPrimaryColor, size: 28),
              const SizedBox(width: 10),
              const Text('Se déconnecter'),
            ],
          ),
          content: const Text(
            'Êtes-vous sûr de vouloir vous déconnecter ?',
            style: TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'Annuler',
                style: kTextStyle.copyWith(color: kSubTitleColor),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Se déconnecter'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      _logout();
    }
  }

  /// Call API to logout
  Future<void> _logout() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final result = await AuthService.logout();

      if (Navigator.of(context).canPop()) Navigator.of(context).pop();

      if (result['success'] == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Déconnexion réussie'),
              backgroundColor: kSuccessGreen,
            ),
          );

          // Navigate to welcome screen and clear navigation stack
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const WelcomeScreen()),
            (route) => false,
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Échec de la déconnexion'),
              backgroundColor: Colors.orange,
            ),
          );

          // Even if API fails, still logout locally for security
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const WelcomeScreen()),
            (route) => false,
          );
        }
      }
    } catch (e) {
      if (Navigator.of(context).canPop()) Navigator.of(context).pop();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Déconnexion locale effectuée'),
            backgroundColor: Colors.orange,
          ),
        );

        // Even on error, logout locally for security
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const WelcomeScreen()),
          (route) => false,
        );
      }
    }
  }

  /// Show confirmation dialog for disabling account
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
              const Text('Désactiver le compte'),
            ],
          ),
          content: const Text(
            'Êtes-vous sûr de vouloir désactiver votre compte ? Cette action est irréversible et vous serez déconnecté.',
            style: TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'Annuler',
                style: kTextStyle.copyWith(color: kSubTitleColor),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Désactiver'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      _disableAccount();
    }
  }

  /// Call API to disable account
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
              content: Text(result['message'] ?? 'Compte désactivé avec succès'),
              backgroundColor: kSuccessGreen,
            ),
          );

          // Navigate to welcome screen and clear navigation stack
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const WelcomeScreen()),
            (route) => false,
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Échec de la désactivation du compte'),
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
            content: Text('Erreur: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Helper widget for action buttons
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

  @override
  void dispose() {
    _profileController.removeListener(_onProfileChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = lang.S.of(context);

    return Scaffold(
      backgroundColor: kWebsiteGreyBg,

      // 🔘 Bottom button
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 90,
        color: kWhite,
        child: Center(
          child: SizedBox(
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                elevation: 0,
                backgroundColor: kWebsiteGreyBg,
              ),
              onPressed: () {
                const EditProfile().launch(context);
              },
              child: Text(
                t.editButton, // ✅ translated
                style: kTextStyle.copyWith(color: kWhite),
              ),
            ),
          ),
        ),
      ),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: kWhite),
        title: Text(
          t.myProfileTitle, // ✅ translated
          style: kTextStyle.copyWith(color: kTitleColor),
        ),
        centerTitle: true,
      ),

      body: _profileController.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                height: context.height(),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: kWhite,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 25),

                    // 👤 Avatar
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          height: 90,
                          width: 90,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(color: kDarkWhite, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: _buildProfileImage(),
                          ),
                        ),
                        SmallTapEffect(
                          onTap: getImage,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: kWhite),
                            ),
                            child: const Icon(
                              Icons.camera_alt_outlined,
                              size: 17,
                              color: kWhite,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // 👤 Name
                    Text(
                      fullName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),

                    const SizedBox(height: 5),

                    // 📧 Email
                    Text(
                      email,
                      style: kTextStyle.copyWith(fontSize: 14, color: kSubTitleColor),
                    ),

                    const SizedBox(height: 25),

                    // 📋 Info form
                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          topLeft: Radius.circular(30),
                        ),
                        color: kWhite,
                        boxShadow: [
                          BoxShadow(
                            color: kDarkWhite,
                            offset: Offset(0, -2),
                            blurRadius: 7,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),

                            AppTextField(
                              cursorColor: kTitleColor,
                              textFieldType: TextFieldType.NAME,
                              initialValue: fullName,
                              decoration: kInputDecoration.copyWith(
                                labelText: t.fullNameLabel, // ✅ translated
                              ),
                            ),

                            const SizedBox(height: 20),

                            AppTextField(
                              cursorColor: kTitleColor,
                              textFieldType: TextFieldType.EMAIL,
                              initialValue: email,
                              decoration: kInputDecoration.copyWith(
                                labelText: t.emailLabel, // ✅ translated
                              ),
                            ),

                            const SizedBox(height: 20),

                            AppTextField(
                              cursorColor: kTitleColor,
                              textFieldType: TextFieldType.PHONE,
                              initialValue: phone,
                              decoration: kInputDecoration.copyWith(
                                labelText: t.phoneLabel, // ✅ translated
                                prefixIcon: const CountryCodePicker(
                                  showFlag: true,
                                  initialSelection: 'DZ',
                                ),
                              ),
                            ),

                            const SizedBox(height: 30),

                            // Security Section Header
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Sécurité',
                                style: kTextStyle.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            const SizedBox(height: 15),

                            // Change Password Button
                            _actionButton(
                              icon: IconlyLight.lock,
                              iconColor: kPrimaryColor,
                              iconBg: kPrimaryColor.withOpacity(0.1),
                              title: 'Changer le mot de passe',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const ChangePassword(),
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 10),

                            // Logout Button
                            _actionButton(
                              icon: IconlyLight.logout,
                              iconColor: const Color(0xFFFFA726),
                              iconBg: const Color(0xFFFFA726).withOpacity(0.1),
                              title: 'Se déconnecter',
                              onTap: () => _showLogoutDialog(),
                            ),

                            const SizedBox(height: 10),

                            // Disable Account Button
                            _actionButton(
                              icon: IconlyLight.delete,
                              iconColor: Colors.red,
                              iconBg: Colors.red.withOpacity(0.1),
                              title: 'Désactiver le compte',
                              titleColor: Colors.red,
                              onTap: () => _showDisableAccountDialog(),
                            ),

                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
