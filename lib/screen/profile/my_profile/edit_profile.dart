import 'package:country_code_picker/country_code_picker.dart';
import 'package:flight_booking/generated/l10n.dart' as lang;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../../../controllers/profile_controller.dart';
import '../../widgets/constant.dart';
import '../../widgets/button_global.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final ImagePicker _picker = ImagePicker();
  XFile? image;
  late final ProfileController _profileController;

  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _titleController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _countryController;
  late TextEditingController _postCodeController;
  late TextEditingController _birthDateController;
  late TextEditingController _photoController;

  String? _selectedTitle;

  // Responsive helpers
  bool get isSmallScreen => MediaQuery.of(context).size.width < 360;
  bool get isMediumScreen => MediaQuery.of(context).size.width < 400;

  /// Formats an ISO date string like "1990-01-15T00:00:00.000Z" to "1990-01-15"
  String _formatBirthDate(String raw) {
    if (raw.isEmpty) return '';
    final parsed = DateTime.tryParse(raw);
    if (parsed != null) {
      return '${parsed.year.toString().padLeft(4, "0")}-${parsed.month.toString().padLeft(2, "0")}-${parsed.day.toString().padLeft(2, "0")}';
    }
    return raw;
  }

  @override
  void initState() {
    super.initState();
    _profileController = context.read<ProfileController>();

    final customer = _profileController.customer;
    final first = customer != null ? (customer['firstName'] ?? '') : '';
    final last = customer != null ? (customer['lastName'] ?? '') : '';
    final email = customer != null ? (customer['email'] ?? '') : '';
    final title = customer != null ? (customer['title'] ?? '') : '';
    final address = customer != null ? (customer['address'] ?? '') : '';
    final city = customer != null ? (customer['city'] ?? '') : '';
    final country = customer != null ? (customer['country'] ?? '') : '';
    final postCode = customer != null ? (customer['postCode'] ?? '') : '';
    final birthDate = customer != null ? (customer['birthDate'] ?? '') : '';
    final photo = customer != null ? (customer['photo'] ?? '') : '';

    _fullNameController = TextEditingController(text: ('$first ${last ?? ''}').trim());
    _emailController = TextEditingController(text: email);
    _phoneController = TextEditingController(text: customer != null ? (customer['mobile'] ?? '') : '');
    // Only allow M. or Mme
    _selectedTitle = (title == 'M.' || title == 'Mme') ? title : 'M.';
    _titleController = TextEditingController(text: _selectedTitle);
    _addressController = TextEditingController(text: address);
    _cityController = TextEditingController(text: city);
    _countryController = TextEditingController(text: country);
    _postCodeController = TextEditingController(text: postCode);
    _birthDateController = TextEditingController(text: _formatBirthDate(birthDate));
    _photoController = TextEditingController(text: photo);

    _profileController.addListener(_onProfileChanged);
  }

  Future<void> getImage() async {
    image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  /// Build the user avatar widget showing API photo, local pick, or fallback
  Widget _buildAvatar() {
    final double avatarSize = isSmallScreen ? 76 : (isMediumScreen ? 84 : 90);
    final photoUrl = _photoController.text.trim();

    ImageProvider imageProvider;
    if (image != null) {
      imageProvider = FileImage(File(image!.path));
    } else if (photoUrl.isNotEmpty) {
      imageProvider = NetworkImage(photoUrl);
    } else {
      imageProvider = const AssetImage('images/man.png');
    }

    return Center(
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: kWhite,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: const Color.fromRGBO(0, 0, 0, 0.08), blurRadius: 8, offset: const Offset(0, 4))],
        ),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            Container(
              height: avatarSize,
              width: avatarSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                  onError: (_, __) {},
                ),
              ),
              // Fallback if network image fails
              child: photoUrl.isNotEmpty && image == null
                  ? ClipOval(
                      child: Image.network(
                        photoUrl,
                        fit: BoxFit.cover,
                        width: avatarSize,
                        height: avatarSize,
                        errorBuilder: (_, __, ___) => Image.asset('images/man.png', fit: BoxFit.cover, width: avatarSize, height: avatarSize),
                      ),
                    )
                  : null,
            ),
            GestureDetector(
              onTap: () => getImage(),
              child: Container(
                padding: EdgeInsets.all(isSmallScreen ? 4.0 : 5.0),
                decoration: BoxDecoration(color: kPrimaryColor, shape: BoxShape.circle, border: Border.all(color: kWhite, width: 1.0)),
                child: Icon(Icons.camera_alt_outlined, size: isSmallScreen ? 15 : 17, color: kWhite),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Show professional success snackbar
  void _showSuccessMessage(BuildContext context) {
    final t = lang.S.of(context);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                t.editProfileUpdated,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF2E7D32),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        duration: const Duration(seconds: 3),
        elevation: 4,
      ),
    );
  }

  /// Show professional error snackbar
  void _showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFC62828),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        duration: const Duration(seconds: 4),
        elevation: 4,
      ),
    );
  }

  /// Handle form submission
  Future<void> _onSubmit() async {
    final t = lang.S.of(context);
    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();

    if (_selectedTitle == null || _selectedTitle!.trim().isEmpty) {
      _showErrorMessage(context, t.editProfileSelectCivility);
      return;
    }

    if (fullName.isEmpty || email.isEmpty) {
      _showErrorMessage(context, t.editProfileFillNameEmail);
      return;
    }

    final parts = fullName.split(RegExp(r"\s+"));
    final first = parts.isNotEmpty ? parts.first : '';
    final last = parts.length > 1 ? parts.sublist(1).join(' ') : '';

    final body = <String, dynamic>{
      'title': (_selectedTitle ?? _titleController.text).trim(),
      'firstName': first,
      'lastName': last,
      'mobile': _phoneController.text.trim(),
      'address': _addressController.text.trim(),
      'city': _cityController.text.trim(),
      'country': _countryController.text.trim(),
      'postCode': _postCodeController.text.trim(),
      'birthDate': _birthDateController.text.trim(),
      'photo': _photoController.text.trim(),
    };

    String? uploadedUrl;
    if (image != null) {
      toast(t.editProfileUploadingImage);
      uploadedUrl = await _profileController.postImage(File(image!.path));
      if (uploadedUrl == null) {
        if (mounted) {
          _showErrorMessage(context, t.editProfileUploadFailed);
        }
        return;
      }
      body['photo'] = uploadedUrl;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final res = await _profileController.updateProfile(body);
      if (Navigator.of(context).canPop()) Navigator.of(context).pop();

      if (res != null && res['success'] == true) {
        _showSuccessMessage(context);
        // Refresh profile data and rebuild the page
        await _profileController.fetchProfile();
        if (mounted) setState(() {});
      } else {
        // API returned validation error — keep old data in fields
        final msg = res != null
            ? (res['message'] ?? t.editProfileUpdateError)
            : (_profileController.error ?? t.editProfileErrorGeneric);
        _showErrorMessage(context, msg.toString());
      }
    } catch (e) {
      if (Navigator.of(context).canPop()) Navigator.of(context).pop();
      _showErrorMessage(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final hPad = isSmallScreen ? 12.0 : (isMediumScreen ? 14.0 : 15.0);
    final fieldSpacing = isSmallScreen ? 10.0 : 12.0;
    final nameFontSize = isSmallScreen ? 16.0 : 18.0;
    final emailFontSize = isSmallScreen ? 12.0 : 13.0;

    return Scaffold(
      backgroundColor: kWhite,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(color: kWhite),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad, vertical: isSmallScreen ? 8 : 10),
            child: SizedBox(
              height: isSmallScreen ? 46 : 50,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                  elevation: 0.0,
                  backgroundColor: kPrimaryColor,
                ),
                onPressed: _onSubmit,
                child: Text(lang.S.of(context).editProfileUpdate, style: kTextStyle.copyWith(color: kWhite, fontSize: isSmallScreen ? 14 : 16)),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + (isSmallScreen ? 8 : 12),
              left: isSmallScreen ? 12 : 16,
              right: isSmallScreen ? 12 : 16,
              bottom: isSmallScreen ? 12 : 16,
            ),
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
            child: Row(
              children: [
                SmallTapEffect(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: isSmallScreen ? 22 : 24,
                  ),
                ),
                SizedBox(width: isSmallScreen ? 8 : 12),
                Text(
                  lang.S.of(context).editProfileTitle,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: isSmallScreen ? 16 : 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                width: double.infinity,
                color: kWhite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
                        boxShadow: [BoxShadow(color: kDarkWhite, offset: Offset(0, -2), blurRadius: 7.0, spreadRadius: 2.0)],
                        color: kWhite,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(hPad),
                        child: Column(
                          children: <Widget>[
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                lang.S.of(context).editProfilePersonalInfo,
                                style: kTextStyle.copyWith(fontSize: isSmallScreen ? 14 : 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(height: fieldSpacing),

                            // Avatar with user photo
                            _buildAvatar(),
                            SizedBox(height: fieldSpacing),

                            // User name and email
                            Text(
                              _profileController.firstName.isNotEmpty || _profileController.lastName.isNotEmpty
                                  ? '${_profileController.firstName} ${_profileController.lastName}'.trim()
                                  : _fullNameController.text,
                              style: kTextStyle.copyWith(fontSize: nameFontSize, fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _profileController.email.isNotEmpty ? _profileController.email : _emailController.text,
                              style: kTextStyle.copyWith(fontSize: emailFontSize, color: kSubTitleColor),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: isSmallScreen ? 12 : 16),
                            const Divider(),
                            const SizedBox(height: 8),

                            // Civilité dropdown - without "Pro"
                            DropdownButtonFormField<String>(
                              value: _selectedTitle,
                              decoration: kInputDecoration.copyWith(
                                labelText: lang.S.of(context).editProfileCivility,
                                hintText: lang.S.of(context).editProfileSelectOption,
                              ),
                              items: ['M.', 'Mme'].map((e) => DropdownMenuItem<String>(value: e, child: Text(e))).toList(),
                              onChanged: (val) {
                                setState(() {
                                  _selectedTitle = val;
                                  _titleController.text = val ?? '';
                                });
                              },
                            ),

                            SizedBox(height: fieldSpacing),

                            AppTextField(
                              controller: _fullNameController,
                              cursorColor: kTitleColor,
                              textFieldType: TextFieldType.NAME,
                              decoration: kInputDecoration.copyWith(
                                hintText: lang.S.of(context).editProfileFullNameHint,
                                labelText: lang.S.of(context).editProfileFullNameLabel,
                                prefixIcon: const Icon(Icons.person),
                              ),
                            ),

                            SizedBox(height: fieldSpacing),

                            AppTextField(
                              controller: _emailController,
                              cursorColor: kTitleColor,
                              textFieldType: TextFieldType.EMAIL,
                              decoration: kInputDecoration.copyWith(
                                hintText: lang.S.of(context).editProfileEmailHint,
                                labelText: lang.S.of(context).editProfileEmailLabel,
                                prefixIcon: const Icon(Icons.email),
                              ),
                            ),

                            SizedBox(height: fieldSpacing),

                            // Phone + PostCode row
                            LayoutBuilder(
                              builder: (context, constraints) {
                                if (constraints.maxWidth < 340) {
                                  // Stack vertically on very small screens
                                  return Column(
                                    children: [
                                      AppTextField(
                                        controller: _phoneController,
                                        cursorColor: kTitleColor,
                                        textFieldType: TextFieldType.PHONE,
                                        decoration: kInputDecoration.copyWith(
                                          hintText: '+33612345678',
                                          labelText: lang.S.of(context).editProfilePhoneLabel,
                                          prefixIcon: CountryCodePicker(
                                            showFlag: true,
                                            initialSelection: 'DZ',
                                            padding: EdgeInsets.zero,
                                            showFlagDialog: true,
                                            textStyle: kTextStyle.copyWith(fontSize: 13),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: fieldSpacing),
                                      AppTextField(
                                        controller: _postCodeController,
                                        cursorColor: kTitleColor,
                                        textFieldType: TextFieldType.NUMBER,
                                        decoration: kInputDecoration.copyWith(
                                          hintText: '75001',
                                          labelText: lang.S.of(context).editProfilePostCodeLabel,
                                          prefixIcon: const Icon(Icons.location_on),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                                return Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 2,
                                      child: AppTextField(
                                        controller: _phoneController,
                                        cursorColor: kTitleColor,
                                        textFieldType: TextFieldType.PHONE,
                                        decoration: kInputDecoration.copyWith(
                                          hintText: '+33612345678',
                                          labelText: lang.S.of(context).editProfilePhoneLabel,
                                          prefixIcon: CountryCodePicker(
                                            showFlag: true,
                                            initialSelection: 'DZ',
                                            padding: EdgeInsets.zero,
                                            showFlagDialog: true,
                                            textStyle: kTextStyle.copyWith(fontSize: isSmallScreen ? 11 : 13),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: isSmallScreen ? 8 : 12),
                                    Expanded(
                                      flex: 1,
                                      child: AppTextField(
                                        controller: _postCodeController,
                                        cursorColor: kTitleColor,
                                        textFieldType: TextFieldType.NUMBER,
                                        decoration: kInputDecoration.copyWith(
                                          hintText: '75001',
                                          labelText: lang.S.of(context).editProfilePostCodeLabel,
                                          prefixIcon: const Icon(Icons.location_on),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),

                            SizedBox(height: fieldSpacing),

                            AppTextField(
                              controller: _addressController,
                              cursorColor: kTitleColor,
                              textFieldType: TextFieldType.MULTILINE,
                              decoration: kInputDecoration.copyWith(
                                hintText: lang.S.of(context).editProfileAddressHint,
                                labelText: lang.S.of(context).editProfileAddressLabel,
                                prefixIcon: const Icon(Icons.home),
                              ),
                            ),

                            SizedBox(height: fieldSpacing),

                            // City + Country row
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: AppTextField(
                                    controller: _cityController,
                                    cursorColor: kTitleColor,
                                    textFieldType: TextFieldType.NAME,
                                    decoration: kInputDecoration.copyWith(
                                      hintText: 'Paris',
                                      labelText: lang.S.of(context).editProfileCityLabel,
                                      prefixIcon: const Icon(Icons.location_city),
                                    ),
                                  ),
                                ),
                                SizedBox(width: isSmallScreen ? 8 : 12),
                                Expanded(
                                  child: AppTextField(
                                    controller: _countryController,
                                    cursorColor: kTitleColor,
                                    textFieldType: TextFieldType.NAME,
                                    decoration: kInputDecoration.copyWith(
                                      hintText: 'France',
                                      labelText: lang.S.of(context).editProfileCountryLabel,
                                      prefixIcon: const Icon(Icons.flag),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: fieldSpacing),

                            GestureDetector(
                              onTap: () async {
                                DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.tryParse(_birthDateController.text) ?? DateTime(1990, 1, 1),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now(),
                                );
                                if (picked != null) {
                                  _birthDateController.text = '${picked.year.toString().padLeft(4, "0")}-${picked.month.toString().padLeft(2, "0")}-${picked.day.toString().padLeft(2, "0")}';
                                  setState(() {});
                                }
                              },
                              child: AbsorbPointer(
                                child: AppTextField(
                                  controller: _birthDateController,
                                  cursorColor: kTitleColor,
                                  textFieldType: TextFieldType.NAME,
                                  decoration: kInputDecoration.copyWith(
                                    hintText: lang.S.of(context).editProfileBirthDateHint,
                                    labelText: lang.S.of(context).editProfileBirthDateLabel,
                                    prefixIcon: const Icon(Icons.calendar_today),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: fieldSpacing),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onProfileChanged() {
    final customer = _profileController.customer;
    if (customer != null) {
      final first = customer['firstName'] ?? '';
      final last = customer['lastName'] ?? '';
      final email = customer['email'] ?? '';
      final title = customer['title'] ?? '';
      _fullNameController.text = ('$first ${last ?? ''}').trim();
      _emailController.text = email;
      _phoneController.text = customer['mobile'] ?? '';
      _titleController.text = title;
      _selectedTitle = (title == 'M.' || title == 'Mme') ? title : 'M.';
      _addressController.text = customer['address'] ?? '';
      _cityController.text = customer['city'] ?? '';
      _countryController.text = customer['country'] ?? '';
      _postCodeController.text = customer['postCode'] ?? '';
      _birthDateController.text = _formatBirthDate(customer['birthDate'] ?? '');
      _photoController.text = customer['photo'] ?? '';
      setState(() {});
    }
  }

  @override
  void dispose() {
    _profileController.removeListener(_onProfileChanged);
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _titleController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _postCodeController.dispose();
    _birthDateController.dispose();
    _photoController.dispose();
    super.dispose();
  }
}
