import 'package:flight_booking/generated/l10n.dart' as lang;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/constant.dart';
import '../widgets/button_global.dart';
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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadFaqData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadFaqData() {
    final t = lang.S.of(context);
    _categories = [
      FaqCategory(
        id: 'reservation',
        title: t.faqCatReservation,
        icon: CupertinoIcons.airplane,
        color: kPrimaryColor,
        items: [
          FaqItem(id: '1', question: t.faqQ1, answer: t.faqA1),
          FaqItem(id: '2', question: t.faqQ2, answer: t.faqA2),
          FaqItem(id: '3', question: t.faqQ3, answer: t.faqA3),
        ],
      ),
      FaqCategory(
        id: 'payment',
        title: t.faqCatPayment,
        icon: CupertinoIcons.creditcard,
        color: const Color(0xFF4CAF50),
        items: [
          FaqItem(id: '4', question: t.faqQ4, answer: t.faqA4),
          FaqItem(id: '5', question: t.faqQ5, answer: t.faqA5),
          FaqItem(id: '6', question: t.faqQ6, answer: t.faqA6),
        ],
      ),
      FaqCategory(
        id: 'modification',
        title: t.faqCatModification,
        icon: CupertinoIcons.pencil,
        color: const Color(0xFF2196F3),
        items: [
          FaqItem(id: '7', question: t.faqQ7, answer: t.faqA7),
          FaqItem(id: '8', question: t.faqQ8, answer: t.faqA8),
          FaqItem(id: '9', question: t.faqQ9, answer: t.faqA9),
        ],
      ),
      FaqCategory(
        id: 'refund',
        title: t.faqCatRefund,
        icon: CupertinoIcons.arrow_counterclockwise,
        color: const Color(0xFFFF9800),
        items: [
          FaqItem(id: '10', question: t.faqQ10, answer: t.faqA10),
          FaqItem(id: '11', question: t.faqQ11, answer: t.faqA11),
          FaqItem(id: '12', question: t.faqQ12, answer: t.faqA12),
        ],
      ),
      FaqCategory(
        id: 'baggage',
        title: t.faqCatBaggage,
        icon: CupertinoIcons.bag,
        color: const Color(0xFF9C27B0),
        items: [
          FaqItem(id: '13', question: t.faqQ13, answer: t.faqA13),
          FaqItem(id: '14', question: t.faqQ14, answer: t.faqA14),
          FaqItem(id: '15', question: t.faqQ15, answer: t.faqA15),
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
                        : lang.S.of(context).faqAllQuestions,
                    style: GoogleFonts.jost(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: kTitleColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    lang.S.of(context).faqQuestionCount(_filteredItems.length.toString()),
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
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 16,
          left: 16,
          right: 16,
          bottom: 20,
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
              lang.S.of(context).faqTitle,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
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
          hintText: lang.S.of(context).faqSearchHint,
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
            title: lang.S.of(context).faqAllCategory,
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

    return SmallTapEffect(
      onTap: () => setState(() => _selectedCategoryId = id),
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
              lang.S.of(context).faqNoResults,
              style: GoogleFonts.jost(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: kTitleColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              lang.S.of(context).faqNoResultsDesc,
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
            lang.S.of(context).faqNotFoundAnswer,
            style: GoogleFonts.jost(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: kTitleColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            lang.S.of(context).faqSupportAvailable,
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
                lang.S.of(context).faqContactSupport,
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
