import 'package:flutter/material.dart';
import 'chat_room_admin_page.dart';
import '../services/auth_service.dart';

// ─────────────────────────────────────────────
// DATA MODELS
// ─────────────────────────────────────────────

enum ChatPriority { urgent, pending, medium, normal }

class ChatMessage {
  final String text;
  final bool isAdmin;
  final String time;
  final bool isRead;

  const ChatMessage({
    required this.text,
    required this.isAdmin,
    required this.time,
    this.isRead = false,
  });
}

class ChatConversation {
  final String id;
  final String userName;
  final String? avatarUrl;
  final String lastMessage;
  final String time;
  final ChatPriority priority;
  final bool isOnline;
  final List<ChatMessage> messages;

  const ChatConversation({
    required this.id,
    required this.userName,
    this.avatarUrl,
    required this.lastMessage,
    required this.time,
    required this.priority,
    this.isOnline = false,
    required this.messages,
  });
}

// ─────────────────────────────────────────────
// CHAT LIST PAGE
// ─────────────────────────────────────────────

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  static const Color _green = Color(0xFF00C853);
  static const Color _darkNavy = Color(0xFF1A1A2E);

  final List<ChatConversation> _conversations = [
    ChatConversation(
      id: '1',
      userName: 'สมชาย เข็มกลัด',
      lastMessage: 'สอบถามเรื่องการชำระเงินครับ พอดีกดโอนแล้...',
      time: '10:45',
      priority: ChatPriority.urgent,
      isOnline: true,
      messages: [
        ChatMessage(
          text:
              'สวัสดีครับ แอปค้างตอนกดชำระเงินครับ ผมลองกดหลายครั้งแล้วยังไม่ได้เลยครับ',
          isAdmin: false,
          time: '10:45',
        ),
        ChatMessage(
          text:
              'สวัสดีครับคุณสมชาย ทีมงานรับทราบปัญหาแล้วครับ รบกวนขอรูปภาพหน้าจอตอนเกิดปัญหา (Screenshot) หน่อยครับ ทีมงานกำลังเร่งตรวจสอบให้ทันทีครับ',
          isAdmin: true,
          time: '10:47',
          isRead: true,
        ),
      ],
    ),
    ChatConversation(
      id: '2',
      userName: 'วิภาดา รักดี',
      lastMessage: 'ขอบคุณที่ช่วยเหลือเรื่องการสมัครสมาชิกนะค...',
      time: 'เมื่อวาน',
      priority: ChatPriority.pending,
      isOnline: false,
      messages: [
        ChatMessage(
          text: 'สวัสดีค่ะ ขอสมัครสมาชิกใหม่ต้องทำยังไงบ้างคะ?',
          isAdmin: false,
          time: '09:00',
        ),
        ChatMessage(
          text:
              'สวัสดีครับคุณวิภาดา สามารถสมัครได้โดยกดที่เมนู "สมัครสมาชิก" แล้วกรอกข้อมูลให้ครบถ้วนครับ',
          isAdmin: true,
          time: '09:05',
          isRead: true,
        ),
        ChatMessage(
          text: 'ขอบคุณที่ช่วยเหลือเรื่องการสมัครสมาชิกนะคะ',
          isAdmin: false,
          time: '09:10',
        ),
      ],
    ),
    ChatConversation(
      id: '3',
      userName: 'ธนากร นามสมมติ',
      lastMessage: 'ช่วยตรวจสอบสถานะการทำงานหน่อยครับ',
      time: 'จันทร์',
      priority: ChatPriority.medium,
      isOnline: false,
      messages: [
        ChatMessage(
          text: 'ช่วยตรวจสอบสถานะการทำงานหน่อยครับ งานผมยังไม่มีอัปเดตเลย',
          isAdmin: false,
          time: 'จันทร์',
        ),
      ],
    ),
    ChatConversation(
      id: '4',
      userName: 'มณีรัตน์ แสงทอง',
      lastMessage: 'งานที่ส่งไปได้รับหรือยังคะ?',
      time: 'อาทิตย์',
      priority: ChatPriority.normal,
      isOnline: false,
      messages: [
        ChatMessage(
          text: 'งานที่ส่งไปได้รับหรือยังคะ?',
          isAdmin: false,
          time: 'อาทิตย์',
        ),
      ],
    ),
  ];

  // ─────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildTabBar(),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.only(top: 8, bottom: 80),
                itemCount: _conversations.length,
                separatorBuilder: (_, __) => const Divider(
                  height: 1,
                  indent: 80,
                  endIndent: 20,
                  color: Color(0xFFF0F0F0),
                ),
                itemBuilder: (_, i) => _buildChatTile(_conversations[i]),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: _green,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add_comment_outlined,
          color: Colors.white,
          size: 24,
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ─────────────────────────────────────────────
  // HEADER
  // ─────────────────────────────────────────────

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Center(
        child: Text(
          'แชทลูกค้าสัมพันธ์',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: _darkNavy,
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // TAB BAR
  // ─────────────────────────────────────────────

  Widget _buildTabBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              const Text(
                'ทั้งหมด',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: _darkNavy,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_conversations.length}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          margin: const EdgeInsets.only(left: 20),
          width: 52,
          height: 3,
          decoration: BoxDecoration(
            color: _green,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const Divider(height: 1, color: Color(0xFFF0F0F0)),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // CHAT TILE
  // ─────────────────────────────────────────────

  Widget _buildChatTile(ChatConversation chat) {
    return InkWell(
      onTap: () => _openChat(chat),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            _buildAvatar(chat),
            const SizedBox(width: 14),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + Time
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chat.userName,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: _darkNavy,
                          ),
                        ),
                      ),
                      Text(
                        chat.time,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9E9E9E),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Last message
                  Text(
                    chat.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF757575),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Priority badge
                  _buildPriorityBadge(chat.priority),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(ChatConversation chat) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: const Color(0xFFEEEEEE),
          backgroundImage: chat.avatarUrl != null
              ? NetworkImage(chat.avatarUrl!)
              : null,
          child: chat.avatarUrl == null
              ? Text(
                  chat.userName.characters.first,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF757575),
                  ),
                )
              : null,
        ),
        if (chat.isOnline)
          Positioned(
            bottom: 2,
            right: 2,
            child: Container(
              width: 13,
              height: 13,
              decoration: BoxDecoration(
                color: _green,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPriorityBadge(ChatPriority priority) {
    late String label;
    late Color bg;
    late Color textColor;

    switch (priority) {
      case ChatPriority.urgent:
        label = 'เร่งด่วน';
        bg = const Color(0xFFFFEBEE);
        textColor = const Color(0xFFE53935);
        break;
      case ChatPriority.pending:
        label = 'รอดำเนินการ';
        bg = const Color(0xFFE3F2FD);
        textColor = const Color(0xFF1565C0);
        break;
      case ChatPriority.medium:
        label = 'ปานกลาง';
        bg = const Color(0xFFFFF9C4);
        textColor = const Color(0xFFF57F17);
        break;
      case ChatPriority.normal:
        label = 'ปกติ';
        bg = const Color(0xFFF5F5F5);
        textColor = const Color(0xFF757575);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // NAVIGATION
  // ─────────────────────────────────────────────

  void _openChat(ChatConversation chat) {
    void openChat(ChatConversation chat) {
      Navigator.pushNamed(
        context,
        '/chat-room',
        arguments: chat, // ✅ ถูก
      );
    }
  }

  // ─────────────────────────────────────────────
  // BOTTOM NAV
  // ─────────────────────────────────────────────

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: 3, // แชท active
      onTap: (_) {},
      type: BottomNavigationBarType.fixed,
      selectedItemColor: _green,
      unselectedItemColor: const Color(0xFF9E9E9E),
      backgroundColor: Colors.white,
      elevation: 8,
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
      unselectedLabelStyle: const TextStyle(fontSize: 12),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.grid_view_rounded),
          label: 'แดชบอร์ด',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shield_outlined),
          label: 'ตรวจสอบ',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.group_outlined),
          label: 'ผู้ใช้',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_rounded),
          label: 'แชท',
        ),
      ],
    );
  }
}
