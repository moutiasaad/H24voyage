import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/constant.dart';
import '../widgets/button_global.dart';

class CreateTicket extends StatefulWidget {
  const CreateTicket({Key? key}) : super(key: key);

  @override
  State<CreateTicket> createState() => _CreateTicketState();
}

class _CreateTicketState extends State<CreateTicket> {
  final _messageController = TextEditingController();

  String _selectedStatus = 'Ouvert';
  String _selectedPriority = 'Urgent';

  final List<String> _statusOptions = ['Ouvert', 'En cours', 'Résolu', 'Fermé'];
  final List<String> _priorityOptions = ['Faible', 'Normale', 'Urgent'];

  // Sample conversation messages
  final List<Map<String, dynamic>> _messages = [
    {
      'name': 'Jihen Belhadj',
      'initials': 'JB',
      'message': 'Ceci est un faux texte',
      'isAgent': false,
    },
  ];


  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: Column(
        children: [
          // Orange Header with Helpdesk chip and Ticket Card
          _buildHeaderWithTicketCard(),

          // Content
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Détails du ticket
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Détails du ticket',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF111111),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Status Dropdown
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildSimpleDropdownField(
                      label: 'Statut',
                      value: _selectedStatus,
                      options: _statusOptions,
                      onChanged: (value) {
                        setState(() => _selectedStatus = value!);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Priority Dropdown
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildSimpleDropdownField(
                      label: 'Priorité',
                      value: _selectedPriority,
                      options: _priorityOptions,
                      onChanged: (value) {
                        setState(() => _selectedPriority = value!);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Créé par field
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildSimpleTextField('Crée par'),
                  ),

                  const SizedBox(height: 20),

                  // Info Rows
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        _buildInfoRowWithImage('assets/calandreIcon.png', 'Créé le', '28/01/2026'),
                        const SizedBox(height: 12),
                        _buildInfoRowWithImage('assets/horlogeIcon.png', 'Mise à jour', '28/01/2026'),
                        const SizedBox(height: 12),
                        _buildInfoRowWithImage('assets/servicesIcon.png', 'Services', 'Billetterie'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Close Ticket Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildCloseTicketButton(),
                  ),
                  const SizedBox(height: 24),

                  // Conversation Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Conversation',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF222222),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Messages
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: _messages.map((msg) => _buildMessageBubble(msg)).toList(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Reply Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Rédiger une réponse',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF333333),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Message Input
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildMessageInput(),
                  ),
                  const SizedBox(height: 16),

                  // Bottom Action Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildBottomActions(),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderWithTicketCard() {
    return Column(
      children: [
        // Orange Header Background
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFF6A00),
                Color(0xFFFF8F3A),
              ],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Status bar space + Header
              Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 12,
                  left: 16,
                  right: 16,
                  bottom: 12,
                ),
                child: Row(
                  children: [
                    SmallTapEffect(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 44,
                        height: 44,
                        alignment: Alignment.centerLeft,
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                    Text(
                      'Support client',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              // Helpdesk Chip
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 40),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: _buildHelpdeskChip(),
                ),
              ),
            ],
          ),
        ),
        // Ticket Title Card (below header with overlap effect)
        Transform.translate(
          offset: const Offset(0, -15),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildTicketTitleCard(),
          ),
        ),
      ],
    );
  }

  Widget _buildHelpdeskChip() {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Hamburger menu icon (three horizontal lines)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 16,
                height: 2.5,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6A00),
                  borderRadius: BorderRadius.circular(1.5),
                ),
              ),
              const SizedBox(height: 3),
              Container(
                width: 16,
                height: 2.5,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6A00),
                  borderRadius: BorderRadius.circular(1.5),
                ),
              ),
              const SizedBox(height: 3),
              Container(
                width: 16,
                height: 2.5,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6A00),
                  borderRadius: BorderRadius.circular(1.5),
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          Text(
            'Helpdesk',
            style: GoogleFonts.poppins(
              color: const Color(0xFFFF6A00),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketTitleCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5EE),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFFE0CC), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Demande de devis vol',
            style: GoogleFonts.poppins(
              color: const Color(0xFFFF6A00),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '#123456',
            style: GoogleFonts.poppins(
              color: const Color(0xFF2196F3),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard({required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEFEFEF)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSimpleDropdownField({
    required String label,
    required String value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: const Color(0xFF666666),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: const Color(0xFFE8E8E8)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF666666), size: 24),
              style: GoogleFonts.poppins(
                color: const Color(0xFF111111),
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
              items: options.map((option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSimpleTextField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: const Color(0xFF666666),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: const Color(0xFFE8E8E8)),
          ),
          child: TextField(
            style: GoogleFonts.poppins(
              color: const Color(0xFF111111),
              fontSize: 15,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              hintText: '',
              hintStyle: GoogleFonts.poppins(
                color: const Color(0xFF999999),
                fontSize: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
    bool showIndicator = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: const Color(0xFF888888),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            if (showIndicator) ...[
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF6A00),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: value,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF888888), size: 24),
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF111111),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  items: options.map((option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: onChanged,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextFieldWithLabel(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: const Color(0xFF888888),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFEFEFEF)),
          ),
          child: TextField(
            style: GoogleFonts.poppins(
              color: const Color(0xFF111111),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
              hintText: '',
              hintStyle: GoogleFonts.poppins(
                color: const Color(0xFF888888),
                fontSize: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: const Color(0xFFFFF4EE),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFFFF6A00), size: 18),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: GoogleFonts.poppins(
            color: const Color(0xFF666666),
            fontSize: 14,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.poppins(
            color: const Color(0xFF333333),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRowWithImage(String imagePath, String label, String value) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: Color(0xFFF0F0F0),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Image.asset(
              imagePath,
              width: 18,
              height: 18,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: GoogleFonts.poppins(
            color: const Color(0xFF666666),
            fontSize: 14,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.poppins(
            color: const Color(0xFF333333),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCloseTicketButton() {
    return TappableCard(
      onTap: () {
        // Handle close ticket
        Navigator.pop(context);
      },
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFF4D4F), width: 2),
      ),
      child: Container(
        width: double.infinity,
        height: 48,
        child: Center(
          child: Text(
            'Fermer le ticket',
            style: GoogleFonts.poppins(
              color: const Color(0xFFFF4D4F),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFFFEEE6),
            ),
            child: Center(
              child: Text(
                message['initials'],
                style: GoogleFonts.poppins(
                  color: const Color(0xFFFF6A00),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Message Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message['name'],
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF222222),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message['message'],
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF555555),
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: TextField(
        controller: _messageController,
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        style: GoogleFonts.poppins(
          color: kTitleColor,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          hintText: 'Écrivez votre message ici...',
          hintStyle: GoogleFonts.poppins(
            color: const Color(0xFF999999),
            fontSize: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFFF7A18), width: 1),
          ),
          contentPadding: const EdgeInsets.all(14),
        ),
      ),
    );
  }

  Widget _buildBottomActions() {
    return Row(
      children: [
        // Pièces jointes button
        Expanded(
          child: TappableCard(
            onTap: () {
              // Handle attachment
            },
            decoration: BoxDecoration(
              color: const Color(0xFFF1F3F5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              height: 42,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.attach_file, color: Color(0xFF444444), size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Pièces jointes',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF444444),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Envoyer button
        Expanded(
          child: TappableCard(
            onTap: () {
              if (_messageController.text.isNotEmpty) {
                setState(() {
                  _messages.add({
                    'name': 'Vous',
                    'initials': 'V',
                    'message': _messageController.text,
                    'isAgent': false,
                  });
                  _messageController.clear();
                });
              }
            },
            decoration: BoxDecoration(
              color: const Color(0xFFFF7A18),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              height: 42,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.send, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Envoyer',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
