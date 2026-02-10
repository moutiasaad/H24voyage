import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/constant.dart';
import '../widgets/button_global.dart';

/// Model for ticket message
class TicketMessage {
  final String id;
  final String content;
  final String senderType; // 'user' or 'agent'
  final String senderName;
  final DateTime timestamp;

  TicketMessage({
    required this.id,
    required this.content,
    required this.senderType,
    required this.senderName,
    required this.timestamp,
  });

  bool get isUser => senderType == 'user';
}

/// Model for ticket details
class TicketDetails {
  final String id;
  final String subject;
  final String service;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<TicketMessage> messages;

  TicketDetails({
    required this.id,
    required this.subject,
    required this.service,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.messages,
  });

  bool get isUrgent => status == 'urgent';
  bool get isClosed => status == 'closed';

  String get statusLabel {
    switch (status) {
      case 'urgent':
        return 'Urgent';
      case 'open':
        return 'Ouvert';
      case 'pending':
        return 'En attente';
      case 'resolved':
        return 'Résolu';
      case 'closed':
        return 'Fermé';
      default:
        return status;
    }
  }
}

class TicketDetail extends StatefulWidget {
  final String ticketId;

  const TicketDetail({Key? key, required this.ticketId}) : super(key: key);

  @override
  State<TicketDetail> createState() => _TicketDetailState();
}

class _TicketDetailState extends State<TicketDetail> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isLoading = false;
  bool _isSending = false;
  TicketDetails? _ticket;

  @override
  void initState() {
    super.initState();
    _loadTicketDetails();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadTicketDetails() async {
    setState(() => _isLoading = true);

    // Mock data - replace with API call
    await Future.delayed(const Duration(milliseconds: 500));

    _ticket = TicketDetails(
      id: widget.ticketId,
      subject: 'Demande de devis vol',
      service: 'Service Billetterie',
      status: 'urgent',
      createdAt: DateTime(2026, 1, 25),
      updatedAt: DateTime(2026, 1, 27),
      messages: [
        TicketMessage(
          id: '1',
          content: 'Bonjour,\n\nJe souhaite obtenir un devis pour un vol Alger-Paris pour 2 adultes du 15 au 22 février 2026.\n\nMerci de votre aide.',
          senderType: 'user',
          senderName: 'Jihen Belhadj',
          timestamp: DateTime(2026, 1, 25, 10, 30),
        ),
        TicketMessage(
          id: '2',
          content: 'Bonjour Jihen,\n\nMerci pour votre demande. Nous avons bien pris en compte votre requête et nous reviendrons vers vous dans les plus brefs délais avec un devis détaillé.\n\nCordialement,\nL\'équipe H24 Voyages',
          senderType: 'agent',
          senderName: 'Support H24',
          timestamp: DateTime(2026, 1, 25, 14, 15),
        ),
        TicketMessage(
          id: '3',
          content: 'Merci pour votre réponse rapide. J\'attends le devis.',
          senderType: 'user',
          senderName: 'Jihen Belhadj',
          timestamp: DateTime(2026, 1, 26, 9, 0),
        ),
      ],
    );

    setState(() => _isLoading = false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    setState(() => _isSending = true);

    await Future.delayed(const Duration(seconds: 1));

    _ticket!.messages.add(
      TicketMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: message,
        senderType: 'user',
        senderName: 'Jihen Belhadj',
        timestamp: DateTime.now(),
      ),
    );

    _messageController.clear();
    setState(() => _isSending = false);

    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 100,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: Column(
        children: [
          // Orange Header
          _buildHeader(),

          // Content
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: kPrimaryColor))
                : Column(
                    children: [
                      // Ticket Info Card
                      _buildTicketInfoCard(),

                      // Messages List
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.all(16),
                          itemCount: _ticket!.messages.length,
                          itemBuilder: (context, index) {
                            return _buildMessageBubble(_ticket!.messages[index]);
                          },
                        ),
                      ),

                      // Message Input
                      _buildMessageInput(),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Détail du ticket',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (_ticket != null)
                  Text(
                    _ticket!.id,
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          if (_ticket != null && !_ticket!.isClosed)
            SmallTapEffect(
              onTap: _showCloseTicketDialog,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Fermer',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTicketInfoCard() {
    if (_ticket == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBorderColorTextField),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _ticket!.subject,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: kTitleColor,
                  ),
                ),
              ),
              if (_ticket!.isUrgent)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: kPrimaryColor, width: 1.5),
                  ),
                  child: Text(
                    'Urgent',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _ticket!.service,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: kSubTitleColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Créé le ${_formatDate(_ticket!.createdAt)} · Mis à jour ${_formatDate(_ticket!.updatedAt)}',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: kSubTitleColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(TicketMessage message) {
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Sender info
          Padding(
            padding: EdgeInsets.only(
              left: isUser ? 50 : 0,
              right: isUser ? 0 : 50,
              bottom: 6,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isUser) ...[
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF4EE),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.headset_mic,
                      size: 16,
                      color: kPrimaryColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  message.senderName,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: kTitleColor,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _formatTime(message.timestamp),
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: kSubTitleColor,
                  ),
                ),
              ],
            ),
          ),

          // Message bubble
          Container(
            margin: EdgeInsets.only(
              left: isUser ? 50 : 0,
              right: isUser ? 0 : 50,
            ),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isUser ? kPrimaryColor : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(12),
                topRight: const Radius.circular(12),
                bottomLeft: Radius.circular(isUser ? 12 : 4),
                bottomRight: Radius.circular(isUser ? 4 : 12),
              ),
              border: isUser ? null : Border.all(color: kBorderColorTextField),
            ),
            child: Text(
              message.content,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: isUser ? Colors.white : kTitleColor,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    if (_ticket?.isClosed ?? false) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: kBorderColorTextField)),
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F7),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, size: 16, color: kSubTitleColor),
              const SizedBox(width: 8),
              Text(
                'Ce ticket est fermé',
                style: GoogleFonts.poppins(color: kSubTitleColor, fontSize: 13),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: kBorderColorTextField)),
      ),
      child: Row(
        children: [
          // Attachment button
          SmallTapEffect(
            onTap: () {},
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.attach_file,
                color: kSubTitleColor,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Text field
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Écrire un message...',
                  hintStyle: GoogleFonts.poppins(color: kSubTitleColor, fontSize: 14),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                ),
                style: GoogleFonts.poppins(color: kTitleColor, fontSize: 14),
                maxLines: 3,
                minLines: 1,
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Send button
          SmallTapEffect(
            onTap: _isSending ? null : _sendMessage,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: _isSending
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 20,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCloseTicketDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          'Fermer le ticket ?',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        content: Text(
          'Vous ne pourrez plus envoyer de messages une fois le ticket fermé.',
          style: GoogleFonts.poppins(color: kSubTitleColor, fontSize: 14),
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: TappableCard(
                  onTap: () => Navigator.pop(context),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: kBorderColorTextField),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Center(
                    child: Text(
                      'Annuler',
                      style: GoogleFonts.poppins(color: kTitleColor, fontSize: 14),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TappableCard(
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _ticket = TicketDetails(
                        id: _ticket!.id,
                        subject: _ticket!.subject,
                        service: _ticket!.service,
                        status: 'closed',
                        createdAt: _ticket!.createdAt,
                        updatedAt: DateTime.now(),
                        messages: _ticket!.messages,
                      );
                    });
                  },
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Center(
                    child: Text(
                      'Fermer',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
