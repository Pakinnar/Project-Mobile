import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  static const String baseUrl = 'https://pakin-mobile.app.chanakancloud.net/api/users';

  static Future<List<dynamic>> getUsers({
    String search = '',
    String status = 'all',
  }) async {
    final uri = Uri.parse(baseUrl).replace(queryParameters: {
      'search': search,
      'status': status,
    });

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('โหลดผู้ใช้ไม่สำเร็จ');
    }
  }

  static Future<void> deleteUser(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('ลบผู้ใช้ไม่สำเร็จ');
    }
  }

  static Future<void> updateUserStatus({
    required String id,
    required String status,
  }) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/$id/status'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'status': status}),
    );

    if (response.statusCode != 200) {
      throw Exception('อัปเดตสถานะไม่สำเร็จ');
    }
  }
}

