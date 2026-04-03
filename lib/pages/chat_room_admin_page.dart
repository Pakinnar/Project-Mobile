import 'package:flutter/material.dart';
import 'chat_list_admin_page.dart';

// ─────────────────────────────────────────────
// CHAT ROOM PAGE
// ─────────────────────────────────────────────

class ChatRoomPage extends StatefulWidget {
  final ChatConversation conversation;

  const ChatRoomPage({super.key, required this.conversation});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  static const Color _green = Color(0xFF00C853);
  static const Color _darkNavy = Color(0xFF1A1A2E);

  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  late List<ChatMessage> _messages;

  @override
  void initState() {
    super.initState();
    _messages = List.from(widget.conversation.messages);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    final now = TimeOfDay.now();
    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isAdmin: true,
        time: timeStr,
        isRead: false,
      ));
    });

    _textController.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  // ─────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            const Divider(height: 1, color: Color(0xFFF0F0F0)),
            Expanded(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 20),
                  itemCount: _messages.length + 1, // +1 for date header
                  itemBuilder: (_, i) {
                    if (i == 0) return _buildDateHeader('วันนี้');
                    final msg = _messages[i - 1];
                    return _buildMessageBubble(msg);
                  },
                ),
              ),
            ),
            _buildInputBar(context),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // APP BAR
  // ─────────────────────────────────────────────

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back,
                size: 24, color: _darkNavy),
          ),
          const SizedBox(width: 12),
          // Title + subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'แชทแจ้งปัญหา',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: _darkNavy,
                  ),
                ),
                Text(
                  'สนทนากับ คุณ${widget.conversation.userName.split(' ').first}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9E9E9E),
                  ),
                ),
              ],
            ),
          ),
          // Overflow menu
          GestureDetector(
            onTap: () => _showMoreOptions(context),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FA),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.more_vert,
                  size: 20, color: Color(0xFF555555)),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // DATE HEADER
  // ─────────────────────────────────────────────

  Widget _buildDateHeader(String date) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Center(
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F0F0),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            date,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF9E9E9E),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // MESSAGE BUBBLE
  // ─────────────────────────────────────────────

  Widget _buildMessageBubble(ChatMessage msg) {
    final isAdmin = msg.isAdmin;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment:
            isAdmin ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Sender name
          if (!isAdmin)
            Padding(
              padding: const EdgeInsets.only(left: 50, bottom: 4),
              child: Text(
                'คุณ${widget.conversation.userName.split(' ').first}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF9E9E9E),
                ),
              ),
            ),
          if (isAdmin)
            const Padding(
              padding: EdgeInsets.only(right: 50, bottom: 4),
              child: Text(
                'Admin Support',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF9E9E9E),
                ),
              ),
            ),

          Row(
            mainAxisAlignment:
                isAdmin ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // User avatar (left side)
              if (!isAdmin) ...[
                _buildMiniAvatar(),
                const SizedBox(width: 8),
              ],

              // Bubble
              Flexible(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.72,
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isAdmin ? _green : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isAdmin ? 18 : 4),
                      bottomRight: Radius.circular(isAdmin ? 4 : 18),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    msg.text,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.55,
                      color:
                          isAdmin ? Colors.white : const Color(0xFF1A1A2E),
                    ),
                  ),
                ),
              ),

              // Admin avatar (right side)
              if (isAdmin) ...[
                const SizedBox(width: 8),
                _buildAdminAvatar(),
              ],
            ],
          ),

          // Time + read status
          Padding(
            padding: EdgeInsets.only(
              top: 5,
              left: isAdmin ? 0 : 50,
              right: isAdmin ? 50 : 0,
            ),
            child: Row(
              mainAxisAlignment:
                  isAdmin ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                if (isAdmin && msg.isRead)
                  const Icon(Icons.done_all,
                      size: 14, color: Color(0xFF4FC3F7)),
                if (isAdmin && !msg.isRead)
                  const Icon(Icons.done_all,
                      size: 14, color: Color(0xFF9E9E9E)),
                const SizedBox(width: 4),
                Text(
                  msg.time,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF9E9E9E),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniAvatar() {
    return CircleAvatar(
      radius: 18,
      backgroundColor: const Color(0xFFEEEEEE),
      child: Text(
        widget.conversation.userName.characters.first,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Color(0xFF757575),
        ),
      ),
    );
  }

  Widget _buildAdminAvatar() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: _green,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.support_agent_rounded,
          color: Colors.white, size: 20),
    );
  }

  // ─────────────────────────────────────────────
  // INPUT BAR
  // ─────────────────────────────────────────────

  Widget _buildInputBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          12, 10, 12, MediaQuery.of(context).viewInsets.bottom + 10),
      decoration: const BoxDecoration(
        color: Color(0xFFF5F7FA),
        border: Border(top: BorderSide(color: Color(0xFFE8E8E8))),
      ),
      child: Row(
        children: [
          // Attach
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: const Icon(Icons.add,
                  size: 20, color: Color(0xFF757575)),
            ),
          ),
          const SizedBox(width: 8),
          // Image
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: const Icon(Icons.image_outlined,
                  size: 20, color: Color(0xFF757575)),
            ),
          ),
          const SizedBox(width: 8),
          // Text field
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 100),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: TextField(
                controller: _textController,
                focusNode: _focusNode,
                maxLines: null,
                textInputAction: TextInputAction.newline,
                style: const TextStyle(fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'พิมพ์ข้อความตอบกลับ...',
                  hintStyle: TextStyle(
                    fontSize: 13,
                    color: Color(0xFFBDBDBD),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Send
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _green,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _green.withOpacity(0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.send_rounded,
                  color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // MORE OPTIONS
  // ─────────────────────────────────────────────

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            _buildOptionTile(
              icon: Icons.mark_chat_read_outlined,
              label: 'ทำเครื่องหมายว่าอ่านแล้ว',
              color: const Color(0xFF1565C0),
            ),
            _buildOptionTile(
              icon: Icons.priority_high_rounded,
              label: 'เปลี่ยนระดับความเร่งด่วน',
              color: const Color(0xFFF57C00),
            ),
            _buildOptionTile(
              icon: Icons.archive_outlined,
              label: 'เก็บเข้าคลัง',
              color: const Color(0xFF757575),
            ),
            _buildOptionTile(
              icon: Icons.delete_outline,
              label: 'ลบการสนทนา',
              color: const Color(0xFFE53935),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1A1A2E),
        ),
      ),
      onTap: () => Navigator.pop(context),
    );
  }
}