import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'chat_page.dart';
import '../services/chat_service.dart';
import 'voice_call_page.dart';

class ChatRoomUserPage extends StatefulWidget {
  final ChatListItem contact;

  const ChatRoomUserPage({super.key, required this.contact});

  @override
  State<ChatRoomUserPage> createState() => _ChatRoomUserPageState();
}

class _ChatRoomUserPageState extends State<ChatRoomUserPage> {
  static const Color _green = Color(0xFF00C853);
  static const Color _darkNavy = Color(0xFF1A1A2E);

  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = true;
  bool _isSending = false;
  String? _errorMessage;
  List<UserChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final msgs = await ChatRoomApiService.getMessages(widget.contact.id);

      setState(() {
        _messages = msgs;
        _isLoading = false;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
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

  Future<void> _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty || _isSending) return;

    setState(() => _isSending = true);

    try {
      await ChatRoomApiService.sendMessage(
        conversationId: widget.contact.id,
        text: text,
      );

      _textController.clear();
      await _loadMessages();

      if (!mounted) return;
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('ส่งข้อความไม่สำเร็จ: $e')));
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
      }
    }
  }

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
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 48,
                              color: Colors.redAccent,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _errorMessage!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.redAccent,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: _loadMessages,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _green,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('ลองใหม่'),
                            ),
                          ],
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () => FocusScope.of(context).unfocus(),
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        itemCount: _messages.length + 1,
                        itemBuilder: (_, i) {
                          if (i == 0) return _buildDateChip();
                          return _buildBubble(_messages[i - 1]);
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

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back, size: 24, color: _darkNavy),
          ),
          const SizedBox(width: 10),
          Stack(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFFE0E0E0),
                backgroundImage:
                    widget.contact.avatarUrl != null &&
                        widget.contact.avatarUrl!.isNotEmpty
                    ? NetworkImage(widget.contact.avatarUrl!)
                    : null,
                child:
                    (widget.contact.avatarUrl == null ||
                        widget.contact.avatarUrl!.isEmpty)
                    ? Text(
                        widget.contact.name.characters.first,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF555555),
                        ),
                      )
                    : null,
              ),
              if (widget.contact.isOnline)
                Positioned(
                  bottom: 1,
                  right: 1,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: _green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.contact.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: _darkNavy,
                  ),
                ),
                if (widget.contact.isOnline)
                  const Text(
                    'ออนไลน์อยู่',
                    style: TextStyle(
                      fontSize: 12,
                      color: _green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _openCallScreen(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.phone_outlined,
                size: 20,
                color: Color(0xFF555555),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateChip() {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xFFEEEEEE),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          'วันนี้',
          style: TextStyle(fontSize: 12, color: Color(0xFF9E9E9E)),
        ),
      ),
    );
  }

  Widget _buildBubble(UserChatMessage msg) {
    if (msg.isTyping) return _buildTypingIndicator();

    final isMe = msg.isMe;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          if (!isMe)
            Padding(
              padding: const EdgeInsets.only(left: 46, bottom: 4),
              child: Text(
                widget.contact.name,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF555555),
                ),
              ),
            ),
          Row(
            mainAxisAlignment: isMe
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isMe) ...[
                CircleAvatar(
                  radius: 18,
                  backgroundColor: const Color(0xFFE0E0E0),
                  backgroundImage:
                      widget.contact.avatarUrl != null &&
                          widget.contact.avatarUrl!.isNotEmpty
                      ? NetworkImage(widget.contact.avatarUrl!)
                      : null,
                  child:
                      (widget.contact.avatarUrl == null ||
                          widget.contact.avatarUrl!.isEmpty)
                      ? Text(
                          widget.contact.name.characters.first,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF555555),
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.70,
                  ),
                  decoration: BoxDecoration(
                    color: isMe ? _green : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isMe ? 18 : 4),
                      bottomRight: Radius.circular(isMe ? 4 : 18),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: msg.imageUrl != null && msg.imageUrl!.isNotEmpty
                      ? _buildImageBubble(msg, isMe)
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          child: Text(
                            msg.text,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.5,
                              color: isMe ? Colors.white : _darkNavy,
                            ),
                          ),
                        ),
                ),
              ),
              if (isMe) const SizedBox(width: 4),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 4,
              left: isMe ? 0 : 46,
              right: isMe ? 4 : 0,
            ),
            child: Row(
              mainAxisAlignment: isMe
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                Text(
                  msg.time,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF9E9E9E),
                  ),
                ),
                if (isMe) ...[
                  const SizedBox(width: 4),
                  Icon(
                    Icons.done_all,
                    size: 14,
                    color: msg.isRead
                        ? const Color(0xFF4FC3F7)
                        : const Color(0xFF9E9E9E),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageBubble(UserChatMessage msg, bool isMe) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (msg.text.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
            child: Text(
              msg.text,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: isMe ? Colors.white : _darkNavy,
              ),
            ),
          ),
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.network(
            msg.imageUrl!,
            width: 220,
            height: 160,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 220,
              height: 160,
              color: Colors.grey.shade200,
              child: const Icon(
                Icons.broken_image_outlined,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFFE0E0E0),
            child: Text(
              widget.contact.name.characters.first,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF555555),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomRight: Radius.circular(18),
                bottomLeft: Radius.circular(4),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(children: List.generate(3, (i) => _dot(i))),
          ),
        ],
      ),
    );
  }

  Widget _dot(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: 7,
      height: 7,
      decoration: const BoxDecoration(
        color: Color(0xFFBDBDBD),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildInputBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        12,
        10,
        12,
        MediaQuery.of(context).viewInsets.bottom + 10,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFF5F7FA),
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: Row(
        children: [
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
              child: const Icon(Icons.add, size: 20, color: Color(0xFF757575)),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _textController,
              maxLines: null,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'พิมพ์ข้อความ...',
                hintStyle: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFFBDBDBD),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: _green, width: 1.5),
                ),
                suffixIcon: GestureDetector(
                  onTap: () {},
                  child: const Icon(
                    Icons.camera_alt_outlined,
                    size: 20,
                    color: Color(0xFFBDBDBD),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
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
              child: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openCallScreen(BuildContext context) {
    final channelName = 'chat_call_${widget.contact.id}';
    const localUid = 3;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VoiceCallPage(
          contactName: widget.contact.name,
          avatarUrl: widget.contact.avatarUrl,
          channelName: channelName,
          localUid: localUid,
        ),
      ),
    );
  }
}

class UserChatMessage {
  final int id;
  final String text;
  final bool isMe;
  final String time;
  final bool isRead;
  final bool isTyping;
  final String? imageUrl;

  UserChatMessage({
    required this.id,
    required this.text,
    required this.isMe,
    required this.time,
    required this.isRead,
    this.isTyping = false,
    this.imageUrl,
  });

  factory UserChatMessage.fromJson(Map<String, dynamic> json) {
  return UserChatMessage(
    id: int.tryParse(json['id'].toString()) ?? 0,
    text: json['text']?.toString() ?? '',
    isMe: json['is_me'] == true,
    time: json['time_text']?.toString() ?? '',
    isRead: json['is_read'] == true || json['is_read'] == 1,
    imageUrl: json['image_url']?.toString(),
  );
}
}

class ChatRoomApiService {
  static const String baseUrl = 'http://localhost:3000/api/user-chat';

  static Future<List<UserChatMessage>> getMessages(int conversationId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final url = '$baseUrl/conversations/$conversationId/messages';
    print('GET URL: $url');
    print('GET TOKEN: $token');

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('GET messages status: ${response.statusCode}');
    print('GET messages body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('โหลดข้อความไม่สำเร็จ (${response.statusCode})');
    }

    final decoded = jsonDecode(response.body);
    print('GET decoded type: ${decoded.runtimeType}');

    if (decoded is List) {
      return decoded
          .map((e) => UserChatMessage.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    throw Exception('รูปแบบข้อมูลข้อความไม่ถูกต้อง');
  }

  static Future<UserChatMessage> sendMessage({
    required int conversationId,
    required String text,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final url = '$baseUrl/conversations/$conversationId/messages';
    print('POST URL: $url');
    print('POST TOKEN: $token');
    print('POST text: $text');

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'text': text}),
    );

    print('POST messages status: ${response.statusCode}');
    print('POST messages body: ${response.body}');

    if (response.statusCode != 201) {
      throw Exception('ส่งข้อความไม่สำเร็จ (${response.statusCode})');
    }

    final decoded = jsonDecode(response.body);
    print('POST decoded type: ${decoded.runtimeType}');

    if (decoded is Map<String, dynamic>) {
      return UserChatMessage.fromJson(decoded);
    }

    throw Exception('รูปแบบข้อมูลข้อความที่ส่งกลับไม่ถูกต้อง');
  }
}

int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString()) ?? 0;
}

bool _toBool(dynamic value) {
  if (value == null) return false;
  if (value is bool) return value;
  if (value is num) return value == 1;
  final text = value.toString().toLowerCase();
  return text == '1' || text == 'true';
}

class CallScreen extends StatefulWidget {
  final ChatListItem contact;
  const CallScreen({super.key, required this.contact});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  static const Color _green = Color(0xFF00C853);
  static const Color _darkNavy = Color(0xFF1A1A2E);
  static const Color _red = Color(0xFFEF5350);

  bool _isMuted = false;
  bool _isSpeaker = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 20,
                      color: _darkNavy,
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Local Job Hub',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: _darkNavy,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFF0F0F0)),
            const Spacer(),
            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE0E0E0), width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipOval(
                child:
                    widget.contact.avatarUrl != null &&
                        widget.contact.avatarUrl!.isNotEmpty
                    ? Image.network(
                        widget.contact.avatarUrl!,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: const Color(0xFFE8F5E9),
                        child: Center(
                          child: Text(
                            widget.contact.name.characters.first,
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.w800,
                              color: _green,
                            ),
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              widget.contact.name,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: _darkNavy,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: _green,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'กำลังโทร...',
                  style: TextStyle(
                    fontSize: 14,
                    color: _green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _callControl(
                    icon: _isMuted
                        ? Icons.mic_off_rounded
                        : Icons.mic_off_outlined,
                    label: 'ปิดเสียง',
                    active: _isMuted,
                    onTap: () => setState(() => _isMuted = !_isMuted),
                  ),
                  _callControl(
                    icon: Icons.dialpad_rounded,
                    label: 'ปุ่มกด',
                    onTap: () {},
                  ),
                  _callControl(
                    icon: _isSpeaker
                        ? Icons.volume_up_rounded
                        : Icons.volume_up_outlined,
                    label: 'สำโพง',
                    active: _isSpeaker,
                    onTap: () => setState(() => _isSpeaker = !_isSpeaker),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 36),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: _red,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _red.withOpacity(0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.call_end_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'วางสาย',
              style: TextStyle(
                fontSize: 13,
                color: _red,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _callControl({
    required IconData icon,
    required String label,
    bool active = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: active ? const Color(0xFFE8F5E9) : const Color(0xFFF5F5F5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 26,
              color: active ? _green : const Color(0xFF555555),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF757575)),
          ),
        ],
      ),
    );
  }
}

