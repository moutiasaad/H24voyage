import 'package:country_code_picker/country_code_picker.dart';
import 'package:flight_booking/generated/l10n.dart' as lang;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'dart:io';
import '../../../controllers/profile_controller.dart';
import '../../widgets/constant.dart';
import '../../widgets/button_global.dart';
import 'my_profile.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final ImagePicker _picker = ImagePicker();
  XFile? image;
  final ProfileController _profileController = ProfileController.instance;

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
    _selectedTitle = (title.isNotEmpty) ? title : 'Pro';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(color: kWhite),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
            child: SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                  elevation: 0.0,
                  backgroundColor: kPrimaryColor,
                ),
                onPressed: () async {
                  final fullName = _fullNameController.text.trim();
                  final email = _emailController.text.trim();

                  if (_selectedTitle == null || _selectedTitle!.trim().isEmpty) {
                    final bodyMsg = 'Body: {"success":false,"message":"\\"title\\" is not allowed to be empty"}';
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(bodyMsg)));
                    return;
                  }

                  if (fullName.isEmpty || email.isEmpty) {
                    toast(lang.S.of(context).editProfileFillNameEmail);
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
                    toast(lang.S.of(context).editProfileUploadingImage);
                    uploadedUrl = await _profileController.postImage(File(image!.path));
                    if (uploadedUrl == null) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(lang.S.of(context).editProfileUploadFailed)));
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
                      toast(lang.S.of(context).editProfileUpdated);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MyProfile()));
                    } else {
                      final msg = res != null ? (res['message'] ?? lang.S.of(context).editProfileUpdateError) : (_profileController.error ?? lang.S.of(context).editProfileErrorGeneric);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
                    }
                  } catch (e) {
                    if (Navigator.of(context).canPop()) Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                },
                child: Text(lang.S.of(context).editProfileUpdate, style: kTextStyle.copyWith(color: kWhite)),
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
              top: MediaQuery.of(context).padding.top + 12,
              left: 16,
              right: 16,
              bottom: 16,
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
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  lang.S.of(context).editProfileTitle,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
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
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(lang.S.of(context).editProfilePersonalInfo, style: kTextStyle.copyWith(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 12),
                      Center(
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
                                height: 90,
                                width: 90,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  image: image == null
                                      ? const DecorationImage(image: AssetImage('images/man.png'), fit: BoxFit.cover)
                                      : DecorationImage(image: FileImage(File(image!.path)), fit: BoxFit.cover),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => getImage(),
                                child: Container(
                                  padding: const EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(color: kPrimaryColor, shape: BoxShape.circle, border: Border.all(color: kWhite, width: 1.0)),
                                  child: const Icon(Icons.camera_alt_outlined, size: 17, color: kWhite),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _profileController.firstName.isNotEmpty || _profileController.lastName.isNotEmpty
                            ? '${_profileController.firstName} ${_profileController.lastName}'.trim()
                            : _fullNameController.text,
                        style: kTextStyle.copyWith(fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _profileController.email.isNotEmpty ? _profileController.email : _emailController.text,
                        style: kTextStyle.copyWith(fontSize: 13, color: kSubTitleColor),
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 8),

                      DropdownButtonFormField<String>(
                        initialValue: _selectedTitle,
                        decoration: kInputDecoration.copyWith(labelText: lang.S.of(context).editProfileCivility, hintText: lang.S.of(context).editProfileSelectOption),
                        items: ['M.', 'Mme', 'Pro'].map((e) => DropdownMenuItem<String>(value: e, child: Text(e))).toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedTitle = val;
                            _titleController.text = val ?? '';
                          });
                        },
                      ),

                      const SizedBox(height: 12),

                      AppTextField(
                        controller: _fullNameController,
                        cursorColor: kTitleColor,
                        textFieldType: TextFieldType.NAME,
                        decoration: kInputDecoration.copyWith(hintText: lang.S.of(context).editProfileFullNameHint, labelText: lang.S.of(context).editProfileFullNameLabel, prefixIcon: const Icon(Icons.person)),
                      ),

                      const SizedBox(height: 12),

                      AppTextField(
                        controller: _emailController,
                        cursorColor: kTitleColor,
                        textFieldType: TextFieldType.EMAIL,
                        decoration: kInputDecoration.copyWith(hintText: lang.S.of(context).editProfileEmailHint, labelText: lang.S.of(context).editProfileEmailLabel, prefixIcon: const Icon(Icons.email)),
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: AppTextField(
                              controller: _phoneController,
                              cursorColor: kTitleColor,
                              textFieldType: TextFieldType.PHONE,
                              decoration: kInputDecoration.copyWith(hintText: '+33612345678', labelText: lang.S.of(context).editProfilePhoneLabel, prefixIcon: CountryCodePicker(showFlag: true, initialSelection: 'FR')),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 1,
                            child: AppTextField(
                              controller: _postCodeController,
                              cursorColor: kTitleColor,
                              textFieldType: TextFieldType.NUMBER,
                              decoration: kInputDecoration.copyWith(hintText: '75001', labelText: lang.S.of(context).editProfilePostCodeLabel, prefixIcon: const Icon(Icons.location_on)),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      AppTextField(
                        controller: _addressController,
                        cursorColor: kTitleColor,
                        textFieldType: TextFieldType.MULTILINE,
                        decoration: kInputDecoration.copyWith(hintText: lang.S.of(context).editProfileAddressHint, labelText: lang.S.of(context).editProfileAddressLabel, prefixIcon: const Icon(Icons.home)),
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: <Widget>[
                          Expanded(
                            child: AppTextField(
                              controller: _cityController,
                              cursorColor: kTitleColor,
                              textFieldType: TextFieldType.NAME,
                              decoration: kInputDecoration.copyWith(hintText: 'Paris', labelText: lang.S.of(context).editProfileCityLabel, prefixIcon: const Icon(Icons.location_city)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AppTextField(
                              controller: _countryController,
                              cursorColor: kTitleColor,
                              textFieldType: TextFieldType.NAME,
                              decoration: kInputDecoration.copyWith(hintText: 'France', labelText: lang.S.of(context).editProfileCountryLabel, prefixIcon: const Icon(Icons.flag)),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

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
                            decoration: kInputDecoration.copyWith(hintText: lang.S.of(context).editProfileBirthDateHint, labelText: lang.S.of(context).editProfileBirthDateLabel, prefixIcon: const Icon(Icons.calendar_today)),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),
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
      _fullNameController.text = ('$first ${last ?? ''}').trim();
      _emailController.text = email;
      _phoneController.text = customer['mobile'] ?? '';
      _titleController.text = customer['title'] ?? '';
      _selectedTitle = customer['title'] ?? 'Pro';
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
