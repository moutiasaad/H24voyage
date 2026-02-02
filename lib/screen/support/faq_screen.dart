import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/constant.dart';
import 'create_ticket.dart';
import 'package:nb_utils/nb_utils.dart';

/// Model for FAQ category
class FaqCategory {
  final String id;
  final String title;
  final IconData icon;
  final Color color;
  final List<FaqItem> items;

  FaqCategory({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
    required this.items,
  });
}

/// Model for FAQ item
class FaqItem {
  final String id;
  final String question;
  final String answer;
  bool isExpanded;

  FaqItem({
    required this.id,
    required this.question,
    required this.answer,
    this.isExpanded = false,
  });
}

class FaqScreen extends StatefulWidget {
  const FaqScreen({Key? key}) : super(key: key);

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedCategoryId;
  List<FaqCategory> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadFaqData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadFaqData() {
    _categories = [
      FaqCategory(
        id: 'reservation',
        title: 'Réservation',
        icon: CupertinoIcons.airplane,
        color: kPrimaryColor,
        items: [
          FaqItem(
            id: '1',
            question: 'Comment réserver un vol ?',
            answer: 'Pour réserver un vol, suivez ces étapes :\n\n1. Recherchez votre vol en entrant votre ville de départ, destination et dates\n2. Sélectionnez le vol qui vous convient\n3. Choisissez votre classe de voyage (Classic ou Flex)\n4. Remplissez les informations des passagers\n5. Procédez au paiement\n\nVous recevrez votre confirmation par email.',
          ),
          FaqItem(
            id: '2',
            question: 'Puis-je réserver pour plusieurs passagers ?',
            answer: 'Oui, vous pouvez réserver jusqu\'à 9 passagers par réservation (adultes, enfants et bébés combinés). Les informations de chaque passager devront être renseignées lors de la réservation.',
          ),
          FaqItem(
            id: '3',
            question: 'Comment ajouter des bagages à ma réservation ?',
            answer: 'Vous pouvez ajouter des bagages supplémentaires :\n\n• Lors de la réservation, à l\'étape des options\n• Après la réservation, dans la section "Gérer ma réservation"\n\nNote : L\'ajout de bagages est moins cher lors de la réservation initiale.',
          ),
        ],
      ),
      FaqCategory(
        id: 'payment',
        title: 'Paiement',
        icon: CupertinoIcons.creditcard,
        color: const Color(0xFF4CAF50),
        items: [
          FaqItem(
            id: '4',
            question: 'Quels modes de paiement sont acceptés ?',
            answer: 'Nous acceptons les modes de paiement suivants :\n\n• Cartes bancaires (Visa, Mastercard)\n• Carte CIB / EDAHABIA\n• Virement bancaire\n• Paiement en agence\n\nTous les paiements sont sécurisés et cryptés.',
          ),
          FaqItem(
            id: '5',
            question: 'Ma transaction a échoué, que faire ?',
            answer: 'Si votre transaction a échoué :\n\n1. Vérifiez que les informations de votre carte sont correctes\n2. Assurez-vous que votre carte est activée pour les paiements en ligne\n3. Vérifiez votre plafond de paiement\n4. Essayez un autre mode de paiement\n\nSi le problème persiste, contactez notre support.',
          ),
          FaqItem(
            id: '6',
            question: 'Comment obtenir une facture ?',
            answer: 'Votre facture est automatiquement envoyée par email après confirmation de la réservation. Vous pouvez également la télécharger depuis la section "Mes réservations" dans votre espace personnel.',
          ),
        ],
      ),
      FaqCategory(
        id: 'modification',
        title: 'Modification',
        icon: CupertinoIcons.pencil,
        color: const Color(0xFF2196F3),
        items: [
          FaqItem(
            id: '7',
            question: 'Comment modifier ma réservation ?',
            answer: 'Pour modifier votre réservation :\n\n1. Connectez-vous à votre compte\n2. Allez dans "Mes réservations"\n3. Sélectionnez la réservation à modifier\n4. Cliquez sur "Modifier"\n\nNote : Des frais peuvent s\'appliquer selon votre tarif (Classic ou Flex).',
          ),
          FaqItem(
            id: '8',
            question: 'Puis-je changer le nom sur ma réservation ?',
            answer: 'Le changement de nom n\'est possible que pour les corrections mineures (erreur de frappe). Pour un changement complet de passager, vous devez annuler et refaire une nouvelle réservation.',
          ),
          FaqItem(
            id: '9',
            question: 'Quels sont les frais de modification ?',
            answer: 'Les frais dépendent de votre tarif :\n\n• Tarif Flex : Modifications gratuites\n• Tarif Classic : Frais de 7000 DZD par passager\n\n+ Différence tarifaire éventuelle si le nouveau vol est plus cher.',
          ),
        ],
      ),
      FaqCategory(
        id: 'refund',
        title: 'Annulation & Remboursement',
        icon: CupertinoIcons.arrow_counterclockwise,
        color: const Color(0xFFFF9800),
        items: [
          FaqItem(
            id: '10',
            question: 'Comment annuler ma réservation ?',
            answer: 'Pour annuler votre réservation :\n\n1. Connectez-vous à votre compte\n2. Allez dans "Mes réservations"\n3. Sélectionnez la réservation concernée\n4. Cliquez sur "Annuler"\n5. Confirmez l\'annulation\n\nUn email de confirmation vous sera envoyé.',
          ),
          FaqItem(
            id: '11',
            question: 'Quels sont les frais d\'annulation ?',
            answer: 'Les frais d\'annulation varient selon votre tarif :\n\n• Tarif Flex : Annulation gratuite\n• Tarif Classic : Frais de 5000 DZD par passager\n\nPour les annulations moins de 24h avant le départ, des conditions spéciales s\'appliquent.',
          ),
          FaqItem(
            id: '12',
            question: 'Quand vais-je recevoir mon remboursement ?',
            answer: 'Le délai de remboursement est de 7 à 14 jours ouvrables après validation de votre demande. Le montant sera crédité sur le même mode de paiement utilisé lors de la réservation.',
          ),
        ],
      ),
      FaqCategory(
        id: 'baggage',
        title: 'Bagages',
        icon: CupertinoIcons.bag,
        color: const Color(0xFF9C27B0),
        items: [
          FaqItem(
            id: '13',
            question: 'Quelle est la franchise bagages incluse ?',
            answer: 'La franchise bagages dépend de votre classe :\n\n• Économique : 1 bagage de 23kg en soute + 1 bagage cabine de 8kg\n• Business : 2 bagages de 32kg en soute + 1 bagage cabine de 12kg\n\nLes dimensions maximales varient selon les compagnies.',
          ),
          FaqItem(
            id: '14',
            question: 'Que faire si mon bagage est perdu ?',
            answer: 'Si votre bagage est perdu :\n\n1. Signalez-le immédiatement au comptoir bagages de l\'aéroport\n2. Remplissez un formulaire PIR (Property Irregularity Report)\n3. Conservez votre numéro de dossier\n4. Contactez notre support avec ces informations\n\nNous vous accompagnerons dans vos démarches.',
          ),
          FaqItem(
            id: '15',
            question: 'Puis-je transporter des objets spéciaux ?',
            answer: 'Certains objets nécessitent une déclaration préalable :\n\n• Équipements sportifs (vélo, ski, golf)\n• Instruments de musique\n• Animaux de compagnie\n• Équipements médicaux\n\nContactez-nous au moins 48h avant votre vol pour organiser le transport.',
          ),
        ],
      ),
    ];
  }

  List<FaqItem> get _filteredItems {
    List<FaqItem> items = [];

    if (_selectedCategoryId != null) {
      final category = _categories.firstWhere(
        (c) => c.id == _selectedCategoryId,
        orElse: () => _categories.first,
      );
      items = category.items;
    } else {
      for (var category in _categories) {
        items.addAll(category.items);
      }
    }

    if (_searchQuery.isNotEmpty) {
      items = items
          .where((item) =>
              item.question.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              item.answer.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Bar
                  _buildSearchBar(),
                  const SizedBox(height: 20),

                  // Category Pills
                  _buildCategoryPills(),
                  const SizedBox(height: 24),

                  // FAQ List Title
                  Text(
                    _selectedCategoryId != null
                        ? _categories
                            .firstWhere((c) => c.id == _selectedCategoryId)
                            .title
                        : 'Toutes les questions',
                    style: GoogleFonts.jost(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: kTitleColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_filteredItems.length} questions',
                    style: GoogleFonts.jost(
                      fontSize: 14,
                      color: kSubTitleColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // FAQ Items
          _filteredItems.isEmpty
              ? SliverToBoxAdapter(child: _buildEmptyState())
              : SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildFaqCard(_filteredItems[index]),
                        );
                      },
                      childCount: _filteredItems.length,
                    ),
                  ),
                ),

          // Contact Support Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _buildContactSection(),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 80,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      leadingWidth: 56,
      leading: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.white, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      title: Text(
        'FAQ',
        style: GoogleFonts.jost(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      centerTitle: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF2196F3),
                Color(0xFF1976D2),
                Color(0xFF1565C0),
              ],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
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
      child: TextField(
        controller: _searchController,
        onChanged: (value) => setState(() => _searchQuery = value),
        decoration: InputDecoration(
          hintText: 'Rechercher une question...',
          hintStyle: GoogleFonts.jost(color: kSubTitleColor),
          prefixIcon: const Icon(CupertinoIcons.search, color: kSubTitleColor),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(CupertinoIcons.xmark_circle_fill, color: kSubTitleColor),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        style: GoogleFonts.jost(color: kTitleColor),
      ),
    );
  }

  Widget _buildCategoryPills() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // All categories pill
          _buildCategoryPill(
            id: null,
            title: 'Tout',
            icon: CupertinoIcons.square_grid_2x2,
            color: kTitleColor,
          ),
          const SizedBox(width: 8),
          ..._categories.map((category) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _buildCategoryPill(
                id: category.id,
                title: category.title,
                icon: category.icon,
                color: category.color,
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildCategoryPill({
    required String? id,
    required String title,
    required IconData icon,
    required Color color,
  }) {
    final isSelected = _selectedCategoryId == id;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => setState(() => _selectedCategoryId = id),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? color : kBorderColorTextField,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : color,
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: GoogleFonts.jost(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : kTitleColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFaqCard(FaqItem item) {
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
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          leading: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: kPrimaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              CupertinoIcons.question_circle,
              color: kPrimaryColor,
              size: 20,
            ),
          ),
          title: Text(
            item.question,
            style: GoogleFonts.jost(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: kTitleColor,
            ),
          ),
          trailing: Icon(
            item.isExpanded
                ? CupertinoIcons.chevron_up
                : CupertinoIcons.chevron_down,
            color: kSubTitleColor,
            size: 18,
          ),
          onExpansionChanged: (expanded) {
            setState(() => item.isExpanded = expanded);
          },
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: kWebsiteGreyBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                item.answer,
                style: GoogleFonts.jost(
                  fontSize: 14,
                  color: kSubTitleColor,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.search,
              size: 60,
              color: kSubTitleColor.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'Aucun résultat',
              style: GoogleFonts.jost(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: kTitleColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Aucune question ne correspond à votre recherche.',
              style: GoogleFonts.jost(
                fontSize: 14,
                color: kSubTitleColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            kPrimaryColor.withOpacity(0.1),
            kPrimaryColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: kPrimaryColor.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: kPrimaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              CupertinoIcons.chat_bubble_2_fill,
              color: kPrimaryColor,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Vous n\'avez pas trouvé votre réponse ?',
            style: GoogleFonts.jost(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: kTitleColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Notre équipe support est disponible pour vous aider.',
            style: GoogleFonts.jost(
              fontSize: 14,
              color: kSubTitleColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => const CreateTicket().launch(context),
              style: TextButton.styleFrom(
                backgroundColor: kPrimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                'Contacter le support',
                style: GoogleFonts.jost(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
