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

const _allCountries = [
  'Afghanistan', 'Afrique du Sud', 'Albanie', 'Algérie', 'Allemagne', 'Andorre',
  'Angola', 'Antigua-et-Barbuda', 'Arabie saoudite', 'Argentine', 'Arménie',
  'Australie', 'Autriche', 'Azerbaïdjan', 'Bahamas', 'Bahreïn', 'Bangladesh',
  'Barbade', 'Belgique', 'Belize', 'Bénin', 'Bhoutan', 'Biélorussie', 'Birmanie',
  'Bolivie', 'Bosnie-Herzégovine', 'Botswana', 'Brésil', 'Brunei', 'Bulgarie',
  'Burkina Faso', 'Burundi', 'Cambodge', 'Cameroun', 'Canada', 'Cap-Vert',
  'Centrafrique', 'Chili', 'Chine', 'Chypre', 'Colombie', 'Comores',
  'Corée du Nord', 'Corée du Sud', 'Costa Rica', 'Côte d\'Ivoire', 'Croatie',
  'Cuba', 'Danemark', 'Djibouti', 'Dominique', 'Égypte', 'Émirats arabes unis',
  'Équateur', 'Érythrée', 'Espagne', 'Estonie', 'Eswatini', 'États-Unis',
  'Éthiopie', 'Fidji', 'Finlande', 'France', 'Gabon', 'Gambie', 'Géorgie',
  'Ghana', 'Grèce', 'Grenade', 'Guatemala', 'Guinée', 'Guinée équatoriale',
  'Guinée-Bissau', 'Guyana', 'Haïti', 'Honduras', 'Hongrie', 'Inde', 'Indonésie',
  'Irak', 'Iran', 'Irlande', 'Islande', 'Israël', 'Italie', 'Jamaïque', 'Japon',
  'Jordanie', 'Kazakhstan', 'Kenya', 'Kirghizistan', 'Kiribati', 'Koweït', 'Laos',
  'Lesotho', 'Lettonie', 'Liban', 'Liberia', 'Libye', 'Liechtenstein', 'Lituanie',
  'Luxembourg', 'Macédoine du Nord', 'Madagascar', 'Malaisie', 'Malawi', 'Maldives',
  'Mali', 'Malte', 'Maroc', 'Maurice', 'Mauritanie', 'Mexique', 'Micronésie',
  'Moldavie', 'Monaco', 'Mongolie', 'Monténégro', 'Mozambique', 'Namibie', 'Nauru',
  'Népal', 'Nicaragua', 'Niger', 'Nigeria', 'Norvège', 'Nouvelle-Zélande', 'Oman',
  'Ouganda', 'Ouzbékistan', 'Pakistan', 'Palaos', 'Palestine', 'Panama',
  'Papouasie-Nouvelle-Guinée', 'Paraguay', 'Pays-Bas', 'Pérou', 'Philippines',
  'Pologne', 'Portugal', 'Qatar', 'République démocratique du Congo',
  'République dominicaine', 'République du Congo', 'République tchèque', 'Roumanie',
  'Royaume-Uni', 'Russie', 'Rwanda', 'Saint-Kitts-et-Nevis', 'Saint-Vincent-et-les-Grenadines',
  'Sainte-Lucie', 'Salomon', 'Salvador', 'Samoa', 'São Tomé-et-Príncipe',
  'Sénégal', 'Serbie', 'Seychelles', 'Sierra Leone', 'Singapour', 'Slovaquie',
  'Slovénie', 'Somalie', 'Soudan', 'Soudan du Sud', 'Sri Lanka', 'Suède', 'Suisse',
  'Suriname', 'Syrie', 'Tadjikistan', 'Tanzanie', 'Tchad', 'Thaïlande',
  'Timor oriental', 'Togo', 'Tonga', 'Trinité-et-Tobago', 'Tunisie', 'Turkménistan',
  'Turquie', 'Tuvalu', 'Ukraine', 'Uruguay', 'Vanuatu', 'Vatican', 'Venezuela',
  'Viêt Nam', 'Yémen', 'Zambie', 'Zimbabwe',
];

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final ImagePicker _picker = ImagePicker();
  XFile? image;
  late final ProfileController _profileController;

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
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

  // Per-field API validation errors
  Map<String, String?> _fieldErrors = {};

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

    _firstNameController = TextEditingController(text: first);
    _lastNameController = TextEditingController(text: last);
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
    if (image != null) _fieldErrors.remove('photo');
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

  /// Show searchable country picker bottom sheet
  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        String search = '';
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            final filtered = _allCountries
                .where((c) => c.toLowerCase().contains(search.toLowerCase()))
                .toList();
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40, height: 4,
                    decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Rechercher un pays...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      onChanged: (v) => setSheetState(() => search = v),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final isSelected = filtered[i] == _countryController.text;
                        return ListTile(
                          title: Text(
                            filtered[i],
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                              color: isSelected ? kPrimaryColor : kTitleColor,
                            ),
                          ),
                          trailing: isSelected ? Icon(Icons.check, color: kPrimaryColor, size: 20) : null,
                          onTap: () {
                            _countryController.text = filtered[i];
                            setState(() => _fieldErrors.remove('country'));
                            Navigator.pop(ctx);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// Map API field name to our internal field key
  String _mapFieldKey(String apiField) {
    switch (apiField) {
      case 'firstName': return 'firstName';
      case 'lastName': return 'lastName';
      case 'email': return 'email';
      case 'mobile': case 'phone': return 'phone';
      case 'address': return 'address';
      case 'city': return 'city';
      case 'country': return 'country';
      case 'postCode': case 'zipCode': return 'postCode';
      case 'birthDate': return 'birthDate';
      case 'title': return 'title';
      case 'photo': return 'photo';
      default: return apiField;
    }
  }

  /// Translate a Joi validation message to a user-friendly localized string
  String _translateError(String message) {
    final t = lang.S.of(context);
    final lower = message.toLowerCase();
    if (lower.contains('is required')) return t.editProfileErrorRequired;
    if (lower.contains('not allowed to be empty')) return t.editProfileErrorEmpty;
    if (lower.contains('length must be at least')) return t.editProfileErrorMinLength;
    if (lower.contains('must be a valid email')) return t.editProfileErrorInvalidEmail;
    if (lower.contains('must be a valid')) return t.editProfileErrorInvalidValue;
    if (lower.contains('is not allowed')) return t.editProfileErrorInvalidValue;
    if (lower.contains('phone') || lower.contains('mobile')) return t.editProfileErrorInvalidPhone;
    if (lower.contains('date')) return t.editProfileErrorInvalidDate;
    return message;
  }

  /// Parse API error response and map to specific fields
  Map<String, String> _parseApiErrors(dynamic res) {
    final errors = <String, String>{};

    // Handle structured field errors: { errors: { fieldName: "message" } }
    if (res is Map && res['errors'] is Map) {
      final apiErrors = res['errors'] as Map;
      apiErrors.forEach((key, value) {
        final msg = value is List ? value.first.toString() : value.toString();
        errors[_mapFieldKey(key.toString())] = _translateError(msg);
      });
      return errors;
    }

    // Parse Joi-style message: "fieldName" error description
    final message = (res is Map ? (res['message'] ?? '') : res ?? '').toString();
    final fieldMatch = RegExp(r'"([^"]+)"').firstMatch(message);
    if (fieldMatch != null) {
      final apiField = fieldMatch.group(1)!;
      errors[_mapFieldKey(apiField)] = _translateError(message);
      return errors;
    }

    // Fallback: keyword matching in raw message
    final lower = message.toLowerCase();
    final fieldKeywords = <String, List<String>>{
      'firstName': ['firstname', 'first name', 'prénom'],
      'lastName': ['lastname', 'last name', 'nom de famille'],
      'email': ['email', 'e-mail'],
      'phone': ['mobile', 'phone', 'téléphone'],
      'address': ['address', 'adresse'],
      'city': ['city', 'ville'],
      'country': ['country', 'pays'],
      'postCode': ['postcode', 'postal', 'zip'],
      'birthDate': ['birthdate', 'birth', 'naissance'],
      'title': ['title', 'civilit'],
    };
    for (final entry in fieldKeywords.entries) {
      if (entry.value.any((kw) => lower.contains(kw))) {
        errors[entry.key] = _translateError(message);
      }
    }

    return errors;
  }

  /// Handle form submission
  Future<void> _onSubmit() async {
    final t = lang.S.of(context);
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final email = _emailController.text.trim();

    // Clear previous field errors
    setState(() => _fieldErrors = {});

    // Client-side validation with per-field errors
    bool hasError = false;
    final phone = _phoneController.text.trim();
    final address = _addressController.text.trim();
    final city = _cityController.text.trim();
    final country = _countryController.text.trim();
    final postCode = _postCodeController.text.trim();
    final birthDate = _birthDateController.text.trim();

    if (_selectedTitle == null || _selectedTitle!.trim().isEmpty) {
      _fieldErrors['title'] = t.editProfileSelectCivility;
      hasError = true;
    }
    if (firstName.isEmpty) {
      _fieldErrors['firstName'] = t.editProfileErrorRequired;
      hasError = true;
    } else if (firstName.length < 2) {
      _fieldErrors['firstName'] = t.editProfileErrorMinLength;
      hasError = true;
    }
    if (lastName.isEmpty) {
      _fieldErrors['lastName'] = t.editProfileErrorRequired;
      hasError = true;
    } else if (lastName.length < 2) {
      _fieldErrors['lastName'] = t.editProfileErrorMinLength;
      hasError = true;
    }
    if (email.isEmpty) {
      _fieldErrors['email'] = t.editProfileErrorRequired;
      hasError = true;
    } else if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      _fieldErrors['email'] = t.editProfileErrorInvalidEmail;
      hasError = true;
    }
    if (phone.isEmpty) {
      _fieldErrors['phone'] = t.editProfileErrorRequired;
      hasError = true;
    } else if (!RegExp(r'^\+?\d{8,15}$').hasMatch(phone)) {
      _fieldErrors['phone'] = t.editProfileErrorInvalidPhone;
      hasError = true;
    }
    if (country.isEmpty) {
      _fieldErrors['country'] = t.editProfileErrorRequired;
      hasError = true;
    }
    if (city.isEmpty) {
      _fieldErrors['city'] = t.editProfileErrorRequired;
      hasError = true;
    }
    if (address.isEmpty) {
      _fieldErrors['address'] = t.editProfileErrorRequired;
      hasError = true;
    }
    if (postCode.isEmpty) {
      _fieldErrors['postCode'] = t.editProfileErrorRequired;
      hasError = true;
    }
    if (birthDate.isEmpty) {
      _fieldErrors['birthDate'] = t.editProfileErrorRequired;
      hasError = true;
    } else if (DateTime.tryParse(birthDate) == null) {
      _fieldErrors['birthDate'] = t.editProfileErrorInvalidDate;
      hasError = true;
    }
    if (image == null && _photoController.text.trim().isEmpty) {
      _fieldErrors['photo'] = t.editProfileErrorRequired;
      hasError = true;
    }
    if (hasError) {
      setState(() {});
      _showErrorMessage(context, t.editProfileValidationError);
      return;
    }

    final body = <String, dynamic>{
      'title': (_selectedTitle ?? _titleController.text).trim(),
      'firstName': firstName,
      'lastName': lastName,
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
        await _profileController.fetchProfile();
        if (mounted) setState(() {});
      } else {
        // Map API errors to specific fields
        final parsed = _parseApiErrors(res);
        if (parsed.isNotEmpty) {
          setState(() => _fieldErrors = parsed);
        } else {
          final msg = res != null
              ? (res['message'] ?? t.editProfileUpdateError)
              : (_profileController.error ?? t.editProfileErrorGeneric);
          _showErrorMessage(context, msg.toString());
        }
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
                            if (_fieldErrors['photo'] != null) ...[
                              const SizedBox(height: 6),
                              Text(
                                _fieldErrors['photo']!,
                                style: GoogleFonts.poppins(
                                  color: const Color(0xFFD32F2F),
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                            SizedBox(height: fieldSpacing),

                            // User name and email
                            Text(
                              _profileController.lastName.isNotEmpty || _profileController.firstName.isNotEmpty
                                  ? '${_profileController.lastName} ${_profileController.firstName}'.trim()
                                  : '${_lastNameController.text} ${_firstNameController.text}'.trim(),
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

                            // Civilité dropdown
                            DropdownButtonFormField<String>(
                              value: _selectedTitle,
                              decoration: kInputDecoration.copyWith(
                                labelText: lang.S.of(context).editProfileCivility,
                                hintText: lang.S.of(context).editProfileSelectOption,
                                errorText: _fieldErrors['title'],
                              ),
                              items: ['M.', 'Mme'].map((e) => DropdownMenuItem<String>(value: e, child: Text(e))).toList(),
                              onChanged: (val) {
                                setState(() {
                                  _selectedTitle = val;
                                  _titleController.text = val ?? '';
                                  _fieldErrors.remove('title');
                                });
                              },
                            ),

                            SizedBox(height: fieldSpacing),

                            // Nom + Prénom row
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: AppTextField(
                                    controller: _lastNameController,
                                    cursorColor: kTitleColor,
                                    textFieldType: TextFieldType.NAME,
                                    onChanged: (_) => setState(() => _fieldErrors.remove('lastName')),
                                    decoration: kInputDecoration.copyWith(
                                      hintText: lang.S.of(context).editProfileLastNameHint,
                                      labelText: lang.S.of(context).editProfileLastNameLabel,
                                      prefixIcon: const Icon(Icons.person),
                                      errorText: _fieldErrors['lastName'],
                                    ),
                                  ),
                                ),
                                SizedBox(width: isSmallScreen ? 8 : 12),
                                Expanded(
                                  child: AppTextField(
                                    controller: _firstNameController,
                                    cursorColor: kTitleColor,
                                    textFieldType: TextFieldType.NAME,
                                    onChanged: (_) => setState(() => _fieldErrors.remove('firstName')),
                                    decoration: kInputDecoration.copyWith(
                                      hintText: lang.S.of(context).editProfileFirstNameHint,
                                      labelText: lang.S.of(context).editProfileFirstNameLabel,
                                      prefixIcon: const Icon(Icons.person_outline),
                                      errorText: _fieldErrors['firstName'],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: fieldSpacing),

                            // Email
                            AppTextField(
                              controller: _emailController,
                              cursorColor: kTitleColor,
                              textFieldType: TextFieldType.EMAIL,
                              onChanged: (_) => setState(() => _fieldErrors.remove('email')),
                              decoration: kInputDecoration.copyWith(
                                hintText: lang.S.of(context).editProfileEmailHint,
                                labelText: lang.S.of(context).editProfileEmailLabel,
                                prefixIcon: const Icon(Icons.email),
                                errorText: _fieldErrors['email'],
                              ),
                            ),

                            SizedBox(height: fieldSpacing),

                            // Phone (full width)
                            AppTextField(
                              controller: _phoneController,
                              cursorColor: kTitleColor,
                              textFieldType: TextFieldType.PHONE,
                              onChanged: (_) => setState(() => _fieldErrors.remove('phone')),
                              decoration: kInputDecoration.copyWith(
                                hintText: '+213612345678',
                                labelText: lang.S.of(context).editProfilePhoneLabel,
                                prefixIcon: CountryCodePicker(
                                  showFlag: true,
                                  initialSelection: 'DZ',
                                  padding: EdgeInsets.zero,
                                  showFlagDialog: true,
                                  textStyle: kTextStyle.copyWith(fontSize: isSmallScreen ? 11 : 13),
                                ),
                                errorText: _fieldErrors['phone'],
                              ),
                            ),

                            SizedBox(height: fieldSpacing),

                            // Pays (Country) - searchable picker
                            GestureDetector(
                              onTap: () => _showCountryPicker(),
                              child: AbsorbPointer(
                                child: AppTextField(
                                  controller: _countryController,
                                  cursorColor: kTitleColor,
                                  textFieldType: TextFieldType.NAME,
                                  decoration: kInputDecoration.copyWith(
                                    hintText: 'Sélectionnez un pays',
                                    labelText: lang.S.of(context).editProfileCountryLabel,
                                    prefixIcon: const Icon(Icons.flag),
                                    suffixIcon: const Icon(Icons.arrow_drop_down),
                                    errorText: _fieldErrors['country'],
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: fieldSpacing),

                            // Ville (City)
                            AppTextField(
                              controller: _cityController,
                              cursorColor: kTitleColor,
                              textFieldType: TextFieldType.NAME,
                              onChanged: (_) => setState(() => _fieldErrors.remove('city')),
                              decoration: kInputDecoration.copyWith(
                                hintText: 'Alger',
                                labelText: lang.S.of(context).editProfileCityLabel,
                                prefixIcon: const Icon(Icons.location_city),
                                errorText: _fieldErrors['city'],
                              ),
                            ),

                            SizedBox(height: fieldSpacing),

                            // Adresse (Address)
                            AppTextField(
                              controller: _addressController,
                              cursorColor: kTitleColor,
                              textFieldType: TextFieldType.MULTILINE,
                              onChanged: (_) => setState(() => _fieldErrors.remove('address')),
                              decoration: kInputDecoration.copyWith(
                                hintText: lang.S.of(context).editProfileAddressHint,
                                labelText: lang.S.of(context).editProfileAddressLabel,
                                prefixIcon: const Icon(Icons.home),
                                errorText: _fieldErrors['address'],
                              ),
                            ),

                            SizedBox(height: fieldSpacing),

                            // Code Postal
                            AppTextField(
                              controller: _postCodeController,
                              cursorColor: kTitleColor,
                              textFieldType: TextFieldType.NUMBER,
                              onChanged: (_) => setState(() => _fieldErrors.remove('postCode')),
                              decoration: kInputDecoration.copyWith(
                                hintText: '16000',
                                labelText: lang.S.of(context).editProfilePostCodeLabel,
                                prefixIcon: const Icon(Icons.markunread_mailbox_outlined),
                                errorText: _fieldErrors['postCode'],
                              ),
                            ),

                            SizedBox(height: fieldSpacing),

                            // Birth date
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
                                  setState(() => _fieldErrors.remove('birthDate'));
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
                                    errorText: _fieldErrors['birthDate'],
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
      final title = customer['title'] ?? '';
      _firstNameController.text = customer['firstName'] ?? '';
      _lastNameController.text = customer['lastName'] ?? '';
      _emailController.text = customer['email'] ?? '';
      _phoneController.text = customer['mobile'] ?? '';
      _titleController.text = title;
      _selectedTitle = (title == 'M.' || title == 'Mme') ? title : 'M.';
      _addressController.text = customer['address'] ?? '';
      _cityController.text = customer['city'] ?? '';
      _countryController.text = customer['country'] ?? '';
      _postCodeController.text = customer['postCode'] ?? '';
      _birthDateController.text = _formatBirthDate(customer['birthDate'] ?? '');
      _photoController.text = customer['photo'] ?? '';
      _fieldErrors = {};
      setState(() {});
    }
  }

  @override
  void dispose() {
    _profileController.removeListener(_onProfileChanged);
    _firstNameController.dispose();
    _lastNameController.dispose();
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
