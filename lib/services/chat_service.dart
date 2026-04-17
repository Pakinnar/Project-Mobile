import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChatService {
  static const String baseUrl = 'http://localhost:3000/api/chat';

  static Future<List<dynamic>> getConversations() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final response = await http.get(
      Uri.parse('$baseUrl/conversations'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is List) return decoded;
      throw Exception('รูปแบบข้อมูลรายการแชทไม่ถูกต้อง');
    } else {
      throw Exception('โหลดรายการแชทไม่สำเร็จ: ${response.body}');
    }
  }

  static Future<List<dynamic>> getMessages(int conversationId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final response = await http.get(
      Uri.parse('$baseUrl/conversations/$conversationId/messages'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      if (decoded is List) {
        return decoded;
      }

      throw Exception('รูปแบบข้อมูลข้อความไม่ถูกต้อง');
    } else {
      throw Exception('โหลดข้อความไม่สำเร็จ: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> sendMessage({
    required int conversationId,
    required String text,
    required bool isAdmin,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final response = await http.post(
      Uri.parse('$baseUrl/conversations/$conversationId/messages'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'text': text,
        'is_admin': isAdmin,
      }),
    );

    if (response.statusCode == 201) {
      final decoded = jsonDecode(response.body);

      if (decoded is Map<String, dynamic>) {
        return decoded;
      }

      throw Exception('รูปแบบข้อมูลข้อความที่ส่งกลับไม่ถูกต้อง');
    } else {
      throw Exception('ส่งข้อความไม่สำเร็จ: ${response.body}');
    }
  }
}