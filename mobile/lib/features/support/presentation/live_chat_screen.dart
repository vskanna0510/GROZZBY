import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final String time;
  final String? attachmentType; // 'order', 'image', 'location'

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.time,
    this.attachmentType,
  });
}

class LiveChatScreen extends StatefulWidget {
  const LiveChatScreen({super.key});

  @override
  State<LiveChatScreen> createState() => _LiveChatScreenState();
}

class _LiveChatScreenState extends State<LiveChatScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isAgentTyping = false;
  bool _showQuickReplies = true;

  final List<ChatMessage> _messages = [
    ChatMessage(
      text: "Hello! Welcome to Aura Shop Support. I'm Alex. How can I assist you with your order today?",
      isUser: false,
      time: '10:46 AM',
    ),
    ChatMessage(
      text: "Hi Alex, I'm checking on the status of order #AS-9821. It was supposed to arrive yesterday but I haven't seen an update yet.",
      isUser: true,
      time: '10:47 AM',
    ),
  ];

  final List<String> _quickReplies = [
    'Track Order #AS-9821 📦',
    'Change delivery address 📍',
    'Need invoice / refund 💳',
    'Connect to phone call 📞',
  ];

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage({String? customText, String? attachment}) {
    final text = (customText ?? _textController.text).trim();
    if (text.isEmpty && attachment == null) return;

    if (customText == null) {
      _textController.clear();
    }

    final now = DateTime.now();
    final timeStr = '${now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour)}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}';

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        time: timeStr,
        attachmentType: attachment,
      ));
      _showQuickReplies = false;
      _isAgentTyping = true;
    });

    _scrollToBottom();

    // Intelligent Simulated Concierge Response
    Timer(const Duration(milliseconds: 1500), () {
      if (!mounted) return;

      String reply;
      final lower = text.toLowerCase();

      if (lower.contains('as-9821') || lower.contains('track') || lower.contains('order')) {
        reply = "I've pulled up order #AS-9821. Our courier is on Route 4 approaching Soho. Estimated arrival is in 18 minutes. You can also view live GPS tracking on your active delivery map!";
      } else if (lower.contains('address') || lower.contains('location')) {
        reply = "Your delivery address has been updated to 720 Broadway, Fl 4. Our driver has received the updated pin!";
      } else if (lower.contains('refund') || lower.contains('invoice') || lower.contains('money')) {
        reply = "A full refund of ₹450.00 for order #AS-9821 has been processed to your original payment method. The credit should reflect in 1-2 business days.";
      } else if (lower.contains('call') || lower.contains('phone')) {
        reply = "You can tap the phone icon in the top right header to start an instant encrypted voice call with me!";
      } else {
        reply = "Thanks for reaching out! I've noted down your request and am updating your account details right away. Is there anything else I can help you with today?";
      }

      setState(() {
        _isAgentTyping = false;
        _messages.add(ChatMessage(
          text: reply,
          isUser: false,
          time: timeStr,
        ));
      });

      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 120,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showAttachmentSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Share Attachment',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF191C1D),
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildAttachOption(
                      icon: Icons.receipt_long_rounded,
                      color: const Color(0xFF00288E),
                      label: 'Order #AS-9821',
                      onTap: () {
                        Navigator.pop(ctx);
                        _sendMessage(
                          customText: 'Attaching invoice and receipt for Order #AS-9821',
                          attachment: 'order',
                        );
                      },
                    ),
                    _buildAttachOption(
                      icon: Icons.photo_library_rounded,
                      color: const Color(0xFF006C4B),
                      label: 'Photos',
                      onTap: () {
                        Navigator.pop(ctx);
                        _sendMessage(
                          customText: 'Attaching photo of delivered grocery package',
                          attachment: 'image',
                        );
                      },
                    ),
                    _buildAttachOption(
                      icon: Icons.location_on_rounded,
                      color: const Color(0xFFDC2626),
                      label: 'Live Location',
                      onTap: () {
                        Navigator.pop(ctx);
                        _sendMessage(
                          customText: 'Sharing current delivery dropoff location',
                          attachment: 'location',
                        );
                      },
                    ),
                    _buildAttachOption(
                      icon: Icons.camera_alt_rounded,
                      color: const Color(0xFF8B5CF6),
                      label: 'Camera',
                      onTap: () {
                        Navigator.pop(ctx);
                        _sendMessage(
                          customText: 'Taking photo of item receipt',
                          attachment: 'image',
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAttachOption({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(icon, color: color, size: 24),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF191C1D),
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showVoiceCallDialog() {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00288E).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: 70,
                    height: 70,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&auto=format&fit=crop&q=80'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Alex Rivera',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF191C1D), fontFamily: 'Inter'),
              ),
              const SizedBox(height: 4),
              const Text(
                'Aura Concierge • Connected 00:14',
                style: TextStyle(fontSize: 12, color: Color(0xFF006C4B), fontWeight: FontWeight.w600, fontFamily: 'Inter'),
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: 44,
                    icon: const CircleAvatar(
                      radius: 22,
                      backgroundColor: Color(0xFFF1F5F9),
                      child: Icon(Icons.mic_off_rounded, color: Color(0xFF64748B), size: 20),
                    ),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 24),
                  IconButton(
                    iconSize: 52,
                    icon: const CircleAvatar(
                      radius: 26,
                      backgroundColor: Color(0xFFDC2626),
                      child: Icon(Icons.call_end_rounded, color: Colors.white, size: 24),
                    ),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                  const SizedBox(width: 24),
                  IconButton(
                    iconSize: 44,
                    icon: const CircleAvatar(
                      radius: 22,
                      backgroundColor: Color(0xFFF1F5F9),
                      child: Icon(Icons.volume_up_rounded, color: Color(0xFF64748B), size: 20),
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Top App Bar with Agent Header matching Figma Node 277:4890 & Screenshot
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 1,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go('/support');
                      }
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(Icons.arrow_back_rounded, size: 22, color: Color(0xFF191C1D)),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Agent Avatar with Online Green Dot
                  Stack(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&auto=format&fit=crop&q=80'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 11,
                          height: 11,
                          decoration: BoxDecoration(
                            color: const Color(0xFF006C4B),
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFF8F9FA), width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 12),

                  // Agent Name & Status
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Alex Rivera',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF191C1D),
                          letterSpacing: -0.3,
                          fontFamily: 'Inter',
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Online',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF006C4B),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Phone Receiver Icon for Voice Concierge
                  IconButton(
                    icon: const Icon(Icons.phone_outlined, size: 20, color: Color(0xFF191C1D)),
                    onPressed: _showVoiceCallDialog,
                  ),

                  // More 3-dots Menu
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert_rounded, size: 20, color: Color(0xFF191C1D)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    onSelected: (val) {
                      if (val == 'clear') {
                        setState(() {
                          _messages.clear();
                        });
                      } else if (val == 'transcript') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Chat transcript sent to your registered email.')),
                        );
                      }
                    },
                    itemBuilder: (ctx) => [
                      const PopupMenuItem(value: 'transcript', child: Text('Email Transcript')),
                      const PopupMenuItem(value: 'clear', child: Text('Clear History')),
                    ],
                  ),
                ],
              ),
            ),

            // 2. Chat Thread with System Timestamps and Bubbles
            Expanded(
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                children: [
                  // System Timestamp Pill matching Figma Screenshot
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE1E3E4).withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: const Text(
                        'TODAY, 10:45 AM',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF505050),
                          letterSpacing: 0.6,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Chat Message List
                  ..._messages.map((msg) {
                    if (msg.isUser) {
                      return _buildUserBubble(msg);
                    } else {
                      return _buildAgentBubble(msg);
                    }
                  }),

                  // Typing Indicator Bubble
                  if (_isAgentTyping) ...[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&auto=format&fit=crop&q=80'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 12,
                                  height: 12,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF00288E)),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Alex is typing...',
                                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B), fontFamily: 'Inter'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Quick Reply Chips
            if (_showQuickReplies) ...[
              Container(
                height: 38,
                margin: const EdgeInsets.only(bottom: 8),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _quickReplies.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                  itemBuilder: (ctx, idx) {
                    final text = _quickReplies[idx];
                    return ActionChip(
                      label: Text(
                        text,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF00288E),
                          fontFamily: 'Inter',
                        ),
                      ),
                      backgroundColor: const Color(0xFFD0E1FB).withValues(alpha: 0.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      side: BorderSide.none,
                      onPressed: () => _sendMessage(customText: text),
                    );
                  },
                ),
              ),
            ],

            // 3. Bottom Chat Input Bar matching uploaded screenshot 100%
            Container(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              decoration: const BoxDecoration(
                color: Color(0xFFF8F9FA),
                border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
              ),
              child: Row(
                children: [
                  // Plus in circle button (⊕)
                  IconButton(
                    icon: const Icon(
                      Icons.add_circle_outline_rounded,
                      size: 26,
                      color: Color(0xFF505050),
                    ),
                    onPressed: _showAttachmentSheet,
                  ),

                  const SizedBox(width: 4),

                  // Center Message Capsule
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _textController,
                              onSubmitted: (_) => _sendMessage(),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF191C1D),
                                fontFamily: 'Inter',
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Type a message...',
                                hintStyle: TextStyle(
                                  fontSize: 13.5,
                                  color: Color(0xFF94A3B8),
                                  fontFamily: 'Inter',
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              _textController.text = '${_textController.text} 😊';
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(4),
                              child: Icon(
                                Icons.sentiment_satisfied_alt_outlined,
                                size: 20,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Solid Blue Send Button with Airplane Icon
                  InkWell(
                    onTap: () => _sendMessage(),
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: Color(0xFF00288E),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAgentBubble(ChatMessage msg) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&auto=format&fit=crop&q=80'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    msg.text,
                    style: const TextStyle(
                      fontSize: 13.5,
                      color: Color(0xFF191C1D),
                      height: 1.45,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    msg.time,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF505050),
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildUserBubble(ChatMessage msg) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(width: 40),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBDAEF),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(4),
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (msg.attachmentType != null) ...[
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              msg.attachmentType == 'order'
                                  ? Icons.receipt_long_rounded
                                  : msg.attachmentType == 'location'
                                      ? Icons.location_on_rounded
                                      : Icons.image_rounded,
                              size: 16,
                              color: const Color(0xFF00288E),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              msg.attachmentType == 'order' ? 'Attached Order Details' : 'Shared Media',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF00288E),
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                      ],
                      Text(
                        msg.text,
                        style: const TextStyle(
                          fontSize: 13.5,
                          color: Color(0xFF191C1D),
                          height: 1.45,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Text(
                    msg.time,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF505050),
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
