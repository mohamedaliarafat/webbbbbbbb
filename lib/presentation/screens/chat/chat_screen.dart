import 'dart:math';

import 'package:customer/data/models/message_model.dart';
import 'package:customer/presentation/providers/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'call_screen.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String orderId;

  const ChatScreen({
    Key? key,
    required this.chatId,
    required this.orderId,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProvider>().loadMessages(chatId: widget.chatId);
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    final chatProvider = context.read<ChatProvider>();
    chatProvider.sendMessage(
      chatId: widget.chatId,
      receiverId: 'customer_service', // التواصل مع خدمة العملاء
      content: message,
    );

    _messageController.clear();
    _scrollToBottom();
  }

  void _startCall(String callType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CallScreen(
          callId: 'call_${DateTime.now().millisecondsSinceEpoch}',
          chatId: widget.chatId,
          isIncoming: false,
          callType: callType,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Padding(
          padding: const EdgeInsets.only(right: 55),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'خدمة العملاء',
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'طلب #${widget.orderId.substring(0, min(8, widget.orderId.length))}...',
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.green.withOpacity(0.3)),
            ),
            child: IconButton(
              icon: const Icon(Icons.phone, color: Colors.green),
              onPressed: () => _startCall('audio'),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blue.withOpacity(0.3)),
            ),
            child: IconButton(
              icon: const Icon(Icons.videocam, color: Colors.blue),
              onPressed: () => _startCall('video'),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              Color(0xFF1a1a1a),
              Colors.black,
            ],
          ),
        ),
        child: Column(
          children: [
            // Messages List
            Expanded(
              child: chatProvider.isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: chatProvider.messages.length,
                      itemBuilder: (context, index) {
                        final message = chatProvider.messages[index];
                        return _GlassMessageBubble(message: message);
                      },
                    ),
            ),

            // Typing Indicator
            if (chatProvider.isTyping)
              Container(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.support_agent, size: 16, color: Colors.blue),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'فريق الدعم يكتب...',
                        style: GoogleFonts.cairo(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Message Input
            _buildGlassMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.8),
            Colors.black,
          ],
        ),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
      ),
      child: Row(
        children: [
          // Attachment Button
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: IconButton(
              icon: const Icon(Icons.attach_file, color: Colors.white70),
              onPressed: () {
                _showGlassAttachmentOptions();
              },
            ),
          ),
          const SizedBox(width: 8),

          // Message Input Field
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: TextField(
                controller: _messageController,
                style: GoogleFonts.cairo(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'اكتب رسالة لخدمة العملاء...',
                  hintStyle: GoogleFonts.cairo(color: Colors.white54),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Send Button
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.withOpacity(0.3),
                  Colors.green.withOpacity(0.3),
                ],
              ),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  void _showGlassAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.black.withOpacity(0.8),
                Colors.black.withOpacity(0.6),
              ],
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'إرفاق ملف',
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                _buildGlassAttachmentOption(
                  icon: Icons.image,
                  title: 'صورة',
                  color: Colors.blue,
                  onTap: () {
                    Navigator.pop(context);
                    // Implement image picker
                  },
                ),
                _buildGlassAttachmentOption(
                  icon: Icons.audiotrack,
                  title: 'رسالة صوتية',
                  color: Colors.green,
                  onTap: () {
                    Navigator.pop(context);
                    // Implement audio recorder
                  },
                ),
                _buildGlassAttachmentOption(
                  icon: Icons.video_library,
                  title: 'فيديو',
                  color: Colors.purple,
                  onTap: () {
                    Navigator.pop(context);
                    // Implement video picker
                  },
                ),
                _buildGlassAttachmentOption(
                  icon: Icons.insert_drive_file,
                  title: 'ملف',
                  color: Colors.orange,
                  onTap: () {
                    Navigator.pop(context);
                    // Implement file picker
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGlassAttachmentOption({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: color.withOpacity(0.3)),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: GoogleFonts.cairo(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlassMessageBubble extends StatelessWidget {
  final MessageModel message;

  const _GlassMessageBubble({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final isMe = message.senderId == 'current_user_id';
    final isCustomerService = message.senderId == 'customer_service';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMe)
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.withOpacity(0.3),
                    Colors.green.withOpacity(0.3),
                  ],
                ),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Icon(
                isCustomerService ? Icons.support_agent : Icons.person,
                color: Colors.white,
                size: 16,
              ),
            ),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isMe
                      ? [
                          Colors.blue.withOpacity(0.3),
                          Colors.green.withOpacity(0.3),
                        ]
                      : [
                          Colors.black.withOpacity(0.6),
                          Colors.black.withOpacity(0.4),
                        ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isMe 
                      ? Colors.blue.withOpacity(0.2)
                      : Colors.white.withOpacity(0.1),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: _buildMessageContent(isMe),
            ),
          ),
          const SizedBox(width: 8),
          if (isMe)
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.withOpacity(0.3),
                    Colors.green.withOpacity(0.3),
                  ],
                ),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 16),
            ),
        ],
      ),
    );
  }

  Widget _buildMessageContent(bool isMe) {
    switch (message.type) {
      case 'text':
        return Text(
          message.content.text,
          style: GoogleFonts.cairo(
            color: Colors.white,
            fontSize: 14,
          ),
        );
      
      case 'image':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                message.content.mediaUrl,
                width: 200,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            if (message.content.text.isNotEmpty)
              const SizedBox(height: 8),
            if (message.content.text.isNotEmpty)
              Text(
                message.content.text,
                style: GoogleFonts.cairo(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
          ],
        );
      
      case 'voice':
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.play_arrow, color: Colors.green, size: 16),
            ),
            const SizedBox(width: 8),
            Text(
              '${message.content.duration} ثانية',
              style: GoogleFonts.cairo(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        );
      
      case 'call':
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                message.callInfo?.type == 'video' 
                    ? Icons.videocam 
                    : Icons.call,
                color: Colors.blue,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'مكالمة ${message.callInfo?.type == 'video' ? 'فيديو' : 'صوتية'}',
              style: GoogleFonts.cairo(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        );
      
      default:
        return Text(
          'رسالة غير معروفة',
          style: GoogleFonts.cairo(
            color: Colors.white,
            fontSize: 14,
          ),
        );
    }
  }
}