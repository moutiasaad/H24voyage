import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../widgets/button_global.dart';
import '../../widgets/constant.dart';

class VoyageurDetailScreen extends StatefulWidget {
  final bool isEdit;
  final Map<String, String>? initialData;

  const VoyageurDetailScreen({
    super.key,
    this.isEdit = false,
    this.initialData,
  });

  @override
  State<VoyageurDetailScreen> createState() => _VoyageurDetailScreenState();
}

class _VoyageurDetailScreenState extends State<VoyageurDetailScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _prenomCtrl;
  late final TextEditingController _nomCtrl;
  late final TextEditingController _dateNaissanceCtrl;
  late final TextEditingController _nationaliteCtrl;
  late final TextEditingController _numPasseportCtrl;
  late final TextEditingController _dateExpirationCtrl;
  late final TextEditingController _paysDelivranceCtrl;
  late final TextEditingController _nomArabeCtrl;
  late final TextEditingController _nomMereCtrl;

  String _selectedTitre = 'M.';
  bool _addedToOtherPassport = false;

  final ImagePicker _picker = ImagePicker();
  File? _passportPhoto;

  @override
  void initState() {
    super.initState();
    final d = widget.initialData;
    _prenomCtrl = TextEditingController(text: d?['prenom'] ?? '');
    _nomCtrl = TextEditingController(text: d?['nom'] ?? '');
    _dateNaissanceCtrl =
        TextEditingController(text: d?['dateNaissance'] ?? '');
    _nationaliteCtrl = TextEditingController(text: d?['nationalite'] ?? '');
    _numPasseportCtrl = TextEditingController(text: d?['numPasseport'] ?? '');
    _dateExpirationCtrl =
        TextEditingController(text: d?['dateExpiration'] ?? '');
    _paysDelivranceCtrl =
        TextEditingController(text: d?['paysDelivrance'] ?? '');
    _nomArabeCtrl = TextEditingController(text: d?['nomArabe'] ?? '');
    _nomMereCtrl = TextEditingController(text: d?['nomMere'] ?? '');
    _selectedTitre = d?['titre'] ?? 'M.';
  }

  @override
  void dispose() {
    _prenomCtrl.dispose();
    _nomCtrl.dispose();
    _dateNaissanceCtrl.dispose();
    _nationaliteCtrl.dispose();
    _numPasseportCtrl.dispose();
    _dateExpirationCtrl.dispose();
    _paysDelivranceCtrl.dispose();
    _nomArabeCtrl.dispose();
    _nomMereCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  const SizedBox(height: 16),
                  _buildScannerCard(),
                  const SizedBox(height: 12),
                  _buildPassportToggle(),
                  const SizedBox(height: 24),
                  _buildUnderlineField(
                    controller: _prenomCtrl,
                    label: 'Prénom en anglais',
                  ),
                  _buildUnderlineField(
                    controller: _nomCtrl,
                    label: 'Nom en anglais',
                  ),
                  _buildDateField(
                    controller: _dateNaissanceCtrl,
                    label: 'Date de naissance',
                    hint: 'dd-MM-yyyy',
                  ),
                  _buildTitreDropdown(),
                  _buildUnderlineField(
                    controller: _nationaliteCtrl,
                    label: 'Nationalité',
                    hintText: 'Nationalité',
                  ),
                  _buildUnderlineField(
                    controller: _numPasseportCtrl,
                    label: 'Numéro de passeport',
                  ),
                  _buildDateField(
                    controller: _dateExpirationCtrl,
                    label: "Date d'expiration du passeport",
                    hint: 'dd-MM-yyyy',
                  ),
                  _buildUnderlineField(
                    controller: _paysDelivranceCtrl,
                    label: 'Pays de délivrance',
                    hintText: 'Pays de délivrance',
                  ),
                  _buildUnderlineField(
                    controller: _nomArabeCtrl,
                    label: 'Nom complet en arabe',
                  ),
                  _buildUnderlineField(
                    controller: _nomMereCtrl,
                    label: 'Nom complet de la mère',
                  ),
                  const SizedBox(height: 16),
                  _buildPassportPhotoCard(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildSaveButton(),
    );
  }

  // ── HEADER ──
  Widget _buildHeader() {
    final title = widget.isEdit
        ? 'Modifier les détails du passager'
        : 'Ajouter un passager';
    return Container(
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
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // ── SCANNER CARD ──
  Widget _buildScannerCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Scanner le passeport',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: kPrimaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Vous pouvez remplir automatiquement vos détails à partir de la numérisation de votre passeport',
                  style: GoogleFonts.jost(
                    fontSize: 13,
                    color: kSubTitleColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Icon(Icons.document_scanner_outlined,
              size: 40, color: kSubTitleColor.withValues(alpha: 0.6)),
        ],
      ),
    );
  }

  // ── PASSPORT TOGGLE ──
  Widget _buildPassportToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Passager ajouté à un autre passeport',
              style: GoogleFonts.jost(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: kTitleColor,
              ),
            ),
          ),
          Switch(
            value: _addedToOtherPassport,
            onChanged: (v) => setState(() => _addedToOtherPassport = v),
            activeTrackColor: kPrimaryColor,
          ),
        ],
      ),
    );
  }

  // ── UNDERLINE TEXT FIELD ──
  Widget _buildUnderlineField({
    required TextEditingController controller,
    required String label,
    String? hintText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextField(
        controller: controller,
        style: GoogleFonts.jost(fontSize: 15, color: kTitleColor),
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          labelStyle: GoogleFonts.jost(fontSize: 14, color: kSubTitleColor),
          hintStyle: GoogleFonts.jost(fontSize: 15, color: kTitleColor),
          filled: false,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFE0E0E0)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: kPrimaryColor.withValues(alpha: 0.5)),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  // ── DATE FIELD ──
  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextField(
        controller: controller,
        readOnly: true,
        onTap: () => _pickDate(controller),
        style: GoogleFonts.jost(fontSize: 15, color: kTitleColor),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: GoogleFonts.jost(fontSize: 14, color: kSubTitleColor),
          hintStyle: GoogleFonts.jost(fontSize: 15, color: kSubTitleColor),
          filled: false,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFE0E0E0)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: kPrimaryColor.withValues(alpha: 0.5)),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          suffixIcon: Icon(Icons.calendar_today_outlined,
              size: 20, color: kSubTitleColor.withValues(alpha: 0.7)),
        ),
      ),
    );
  }

  // ── TITRE DROPDOWN ──
  Widget _buildTitreDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Titre',
          labelStyle: GoogleFonts.jost(fontSize: 14, color: kSubTitleColor),
          filled: false,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFE0E0E0)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: kPrimaryColor.withValues(alpha: 0.5)),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _selectedTitre,
            isDense: true,
            icon: const Icon(Icons.keyboard_arrow_down, color: kSubTitleColor),
            style: GoogleFonts.jost(fontSize: 15, color: kTitleColor),
            items: const [
              DropdownMenuItem(value: 'M.', child: Text('M.')),
              DropdownMenuItem(value: 'Mme', child: Text('Mme')),
            ],
            onChanged: (v) {
              if (v != null) setState(() => _selectedTitre = v);
            },
          ),
        ),
      ),
    );
  }

  // ── PASSPORT PHOTO CARD ──
  Widget _buildPassportPhotoCard() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Photo de passeport',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: kTitleColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Certaines compagnies aériennes exigent une photo de passeport pour compléter les procédures',
                style: GoogleFonts.jost(
                  fontSize: 13,
                  color: kSubTitleColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: _showImageSourceSheet,
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: kPrimaryColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              image: _passportPhoto != null
                  ? DecorationImage(
                      image: FileImage(_passportPhoto!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: _passportPhoto == null
                ? Icon(Icons.add_photo_alternate_outlined,
                    size: 28, color: kPrimaryColor.withValues(alpha: 0.6))
                : null,
          ),
        ),
      ],
    );
  }

  // ── IMAGE SOURCE BOTTOM SHEET ──
  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Photo de passeport',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: kTitleColor,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: kPrimaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.camera_alt_outlined,
                        color: kPrimaryColor, size: 22),
                  ),
                  title: Text('Prendre une photo',
                      style: GoogleFonts.jost(fontSize: 15, color: kTitleColor)),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: kPrimaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.photo_library_outlined,
                        color: kPrimaryColor, size: 22),
                  ),
                  title: Text('Choisir depuis la galerie',
                      style: GoogleFonts.jost(fontSize: 15, color: kTitleColor)),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                if (_passportPhoto != null)
                  ListTile(
                    leading: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.delete_outline,
                          color: Colors.red, size: 22),
                    ),
                    title: Text('Supprimer la photo',
                        style: GoogleFonts.jost(
                            fontSize: 15, color: Colors.red)),
                    onTap: () {
                      Navigator.pop(ctx);
                      setState(() => _passportPhoto = null);
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );
      if (picked != null) {
        setState(() => _passportPhoto = File(picked.path));
      }
    } catch (_) {
      // Permission denied or picker cancelled
    }
  }

  // ── SAVE BUTTON ──
  Widget _buildSaveButton() {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).padding.bottom + 12,
        top: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SmallTapEffect(
        onTap: _onSave,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.arrow_circle_right_outlined,
                  color: Colors.white, size: 22),
              const SizedBox(width: 8),
              Text(
                'Enregistrer',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate(TextEditingController ctrl) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(1920),
      lastDate: DateTime(2040),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: kPrimaryColor),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      ctrl.text =
          '${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}';
    }
  }

  void _onSave() {
    // TODO: implement save logic
    Navigator.pop(context);
  }
}
