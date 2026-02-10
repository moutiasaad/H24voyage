import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import '../../../services/auth_service.dart';
import '../../widgets/constant.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    // Check if new password matches confirmation
    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Les nouveaux mots de passe ne correspondent pas'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await AuthService.changePassword(
        oldPassword: _oldPasswordController.text,
        newPassword: _newPasswordController.text,
      );

      setState(() => _isLoading = false);

      if (result['success'] == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Mot de passe mis à jour avec succès'),
              backgroundColor: kSuccessGreen,
            ),
          );
          Navigator.pop(context);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Échec de la mise à jour du mot de passe'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWebsiteGreyBg,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: kTitleColor),
        title: Text(
          'Changer le mot de passe',
          style: kTextStyle.copyWith(color: kTitleColor),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: const BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              topLeft: Radius.circular(30),
            ),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Info Card
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: kPrimaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: kPrimaryColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        IconlyBold.infoSquare,
                        color: kPrimaryColor,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Votre nouveau mot de passe doit comporter au moins 8 caractères',
                          style: kTextStyle.copyWith(
                            fontSize: 13,
                            color: kTitleColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Old Password
                Text(
                  'Mot de passe actuel',
                  style: kTextStyle.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                AppTextField(
                  controller: _oldPasswordController,
                  textFieldType: TextFieldType.PASSWORD,
                  cursorColor: kTitleColor,
                  isPassword: !_isOldPasswordVisible,
                  decoration: kInputDecoration.copyWith(
                    hintText: 'Entrez votre mot de passe actuel',
                    prefixIcon: const Icon(IconlyLight.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isOldPasswordVisible ? IconlyLight.show : IconlyLight.hide,
                        color: kSubTitleColor,
                      ),
                      onPressed: () {
                        setState(() => _isOldPasswordVisible = !_isOldPasswordVisible);
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre mot de passe actuel';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // New Password
                Text(
                  'Nouveau mot de passe',
                  style: kTextStyle.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                AppTextField(
                  controller: _newPasswordController,
                  textFieldType: TextFieldType.PASSWORD,
                  cursorColor: kTitleColor,
                  isPassword: !_isNewPasswordVisible,
                  decoration: kInputDecoration.copyWith(
                    hintText: 'Entrez votre nouveau mot de passe',
                    prefixIcon: const Icon(IconlyLight.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isNewPasswordVisible ? IconlyLight.show : IconlyLight.hide,
                        color: kSubTitleColor,
                      ),
                      onPressed: () {
                        setState(() => _isNewPasswordVisible = !_isNewPasswordVisible);
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un nouveau mot de passe';
                    }
                    if (value.length < 8) {
                      return 'Le mot de passe doit comporter au moins 8 caractères';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Confirm New Password
                Text(
                  'Confirmer le nouveau mot de passe',
                  style: kTextStyle.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                AppTextField(
                  controller: _confirmPasswordController,
                  textFieldType: TextFieldType.PASSWORD,
                  cursorColor: kTitleColor,
                  isPassword: !_isConfirmPasswordVisible,
                  decoration: kInputDecoration.copyWith(
                    hintText: 'Confirmez votre nouveau mot de passe',
                    prefixIcon: const Icon(IconlyLight.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible ? IconlyLight.show : IconlyLight.hide,
                        color: kSubTitleColor,
                      ),
                      onPressed: () {
                        setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible);
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez confirmer votre mot de passe';
                    }
                    if (value != _newPasswordController.text) {
                      return 'Les mots de passe ne correspondent pas';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 40),

                // Submit Button
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      elevation: 0.0,
                      backgroundColor: kPrimaryColor,
                    ),
                    onPressed: _isLoading ? null : _changePassword,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: kWhite,
                            ),
                          )
                        : Text(
                            'Mettre à jour',
                            style: kTextStyle.copyWith(
                              color: kWhite,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
