
import 'package:customer/data/models/chat_model.dart';
import 'package:customer/presentation/providers/chat_provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProvider>().loadUserChats();
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('المحادثات'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
        ],
      ),
      body: chatProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : chatProvider.chats.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 80,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'لا توجد محادثات',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'سيظهر هنا محادثات الطلبات الخاصة بك',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: chatProvider.chats.length,
                  itemBuilder: (context, index) {
                    final chat = chatProvider.chats[index];
                    return _ChatListItem(
                      chat: chat,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              chatId: chat.id,
                              orderId: chat.orderId,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}

class _ChatListItem extends StatelessWidget {
  final ChatModel chat;
  final VoidCallback onTap;

  const _ChatListItem({
    required this.chat,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 25,
        backgroundImage: NetworkImage(
          'https://via.placeholder.com/150',
        ),
      ),
      title: Text(
        'طلب #${chat.orderId.substring(0, 8)}...',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        _getLastMessageText(chat.lastMessage),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (chat.unreadCount['customer']! > 0)
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: Text(
                chat.unreadCount['customer'].toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          SizedBox(height: 4),
          Text(
            _formatTime(chat.updatedAt),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      onTap: onTap,
    );
  }

  String _getLastMessageText(Map<String, dynamic>? lastMessage) {
    if (lastMessage == null) return 'بدء المحادثة';
    
    final type = lastMessage['type'] ?? 'text';
    switch (type) {
      case 'text':
        return lastMessage['content']?['text'] ?? 'رسالة';
      case 'image':
        return '📷 صورة';
      case 'voice':
        return '🎤 رسالة صوتية';
      case 'video':
        return '🎥 فيديو';
      case 'file':
        return '📄 ملف';
      case 'call':
        return '📞 مكالمة';
      default:
        return 'رسالة';
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'الآن';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} د';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} س';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ي';
    } else {
      return '${dateTime.day}/${dateTime.month}';
    }
  }
}