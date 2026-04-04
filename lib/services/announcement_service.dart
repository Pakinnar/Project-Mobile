import 'dart:convert';
import 'package:http/http.dart' as http;

class AnnouncementService {
  static const String baseUrl = 'http://localhost:3000/api/announcements';

  static Future<Map<String, dynamic>> createAnnouncement({
    required String title,
    required String content,
    required String targetGroup,
    String? imageUrl,
  }) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'title': title,
        'content': content,
        'target_group': targetGroup,
        'image_url': imageUrl,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return data;
    } else {
      throw Exception(data['message'] ?? 'สร้างประกาศไม่สำเร็จ');
    }
  }
}

