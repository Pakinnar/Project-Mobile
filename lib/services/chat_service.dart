import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  static const String baseUrl = 'http://localhost:3000/api/chat';

  static Future<List<dynamic>> getConversations() async {
    final response = await http.get(
      Uri.parse('$baseUrl/conversations'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('โหลดรายการแชทไม่สำเร็จ');
    }
  }

  static Future<Map<String, dynamic>> getMessages(String conversationId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/conversations/$conversationId/messages'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('โหลดข้อความไม่สำเร็จ');
    }
  }

  static Future<void> sendMessage({
    required String conversationId,
    required String text,
    required bool isAdmin,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/conversations/$conversationId/messages'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'text': text,
        'is_admin': isAdmin,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('ส่งข้อความไม่สำเร็จ');
    }
  }
}

