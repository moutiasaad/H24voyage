import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/button_global.dart';
import '../../widgets/constant.dart';
import 'voyageur_detail.dart';

/// Fake passenger model
class _Voyageur {
  final String id;
  final String prenom;
  final String nom;
  final String dateNaissance;
  final String titre; // M. / Mme
  final String? nationalite;
  final String? numPasseport;

  const _Voyageur({
    required this.id,
    required this.prenom,
    required this.nom,
    required this.dateNaissance,
    required this.titre,
    this.nationalite,
    this.numPasseport,
  });

  String get initials =>
      '${prenom.isNotEmpty ? prenom[0] : ''}${nom.isNotEmpty ? nom[0] : ''}'
          .toUpperCase();
}

/// Fake data
final List<_Voyageur> _fakeVoyageurs = [
  const _Voyageur(
    id: '1',
    prenom: 'Ahmed',
    nom: 'Benmoussa',
    dateNaissance: '15-03-1990',
    titre: 'M.',
    nationalite: 'Algérienne',
    numPasseport: 'A12345678',
  ),
  const _Voyageur(
    id: '2',
    prenom: 'Fatima',
    nom: 'Zerhouni',
    dateNaissance: '22-07-1985',
    titre: 'Mme',
    nationalite: 'Algérienne',
    numPasseport: 'B87654321',
  ),
  const _Voyageur(
    id: '3',
    prenom: 'Karim',
    nom: 'Hadj',
    dateNaissance: '10-11-2002',
    titre: 'M.',
    nationalite: 'Algérienne',
  ),
  const _Voyageur(
    id: '4',
    prenom: 'Nadia',
    nom: 'Belkacem',
    dateNaissance: '05-01-1998',
    titre: 'Mme',
    nationalite: 'Algérienne',
    numPasseport: 'C11223344',
  ),
];

class VoyageurListScreen extends StatefulWidget {
  const VoyageurListScreen({super.key});

  @override
  State<VoyageurListScreen> createState() => _VoyageurListScreenState();
}

class _VoyageurListScreenState extends State<VoyageurListScreen> {
  final _searchController = TextEditingController();
  List<_Voyageur> _filtered = [];

  @override
  void initState() {
    super.initState();
    _filtered = List.of(_fakeVoyageurs);
    _searchController.addListener(_onSearch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch() {
    final q = _searchController.text.toLowerCase().trim();
    setState(() {
      if (q.isEmpty) {
        _filtered = List.of(_fakeVoyageurs);
      } else {
        _filtered = _fakeVoyageurs.where((v) {
          return v.prenom.toLowerCase().contains(q) ||
              v.nom.toLowerCase().contains(q) ||
              '${v.prenom} ${v.nom}'.toLowerCase().contains(q);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          _buildHeader(),
          _buildSearchBar(),
          Expanded(
            child: _filtered.isEmpty ? _buildEmptyState() : _buildList(),
          ),
        ],
      ),
    );
  }

  // ── HEADER ──
  Widget _buildHeader() {
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
          Text(
            'Passagers',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          SmallTapEffect(
            onTap: () => _openDetail(null),
            child: Row(
              children: [
                const Icon(Icons.add, color: Colors.white, size: 20),
                const SizedBox(width: 4),
                Text(
                  'Ajouter',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── SEARCH BAR ──
  Widget _buildSearchBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: TextField(
        controller: _searchController,
        style: GoogleFonts.jost(fontSize: 15, color: kTitleColor),
        decoration: InputDecoration(
          hintText: 'Rechercher',
          hintStyle: GoogleFonts.jost(color: kSubTitleColor, fontSize: 15),
          prefixIcon: const Icon(Icons.search, color: kSubTitleColor, size: 22),
          filled: true,
          fillColor: const Color(0xFFF5F5F5),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: const BorderSide(color: kPrimaryColor),
          ),
        ),
      ),
    );
  }

  // ── EMPTY STATE ──
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              color: kPrimaryColor.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.people_outline_rounded,
              size: 80,
              color: kPrimaryColor.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Aucun passager trouvé!',
            style: GoogleFonts.jost(
              fontSize: 16,
              color: kSubTitleColor,
            ),
          ),
        ],
      ),
    );
  }

  // ── LIST ──
  Widget _buildList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _filtered.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final v = _filtered[index];
        return _buildCard(v);
      },
    );
  }

  Widget _buildCard(_Voyageur v) {
    return SmallTapEffect(
      onTap: () => _openDetail(v),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: kPrimaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                v.initials,
                style: GoogleFonts.poppins(
                  color: kPrimaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${v.titre} ${v.prenom} ${v.nom}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: kTitleColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    v.numPasseport != null
                        ? '${v.dateNaissance}  •  ${v.numPasseport}'
                        : v.dateNaissance,
                    style: GoogleFonts.jost(
                      fontSize: 12.5,
                      color: kSubTitleColor,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: kSubTitleColor, size: 22),
          ],
        ),
      ),
    );
  }

  void _openDetail(_Voyageur? v) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VoyageurDetailScreen(
          isEdit: v != null,
          initialData: v != null
              ? {
                  'prenom': v.prenom,
                  'nom': v.nom,
                  'dateNaissance': v.dateNaissance,
                  'titre': v.titre,
                  'nationalite': v.nationalite ?? '',
                  'numPasseport': v.numPasseport ?? '',
                }
              : null,
        ),
      ),
    );
  }
}
