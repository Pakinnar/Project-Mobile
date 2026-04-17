import 'dart:convert';
import 'package:http/http.dart' as http;

class VerifyService {
  static const String baseUrl = 'https://pakin-mobile.app.chanakancloud.net/api/verify';

  static Future<List<dynamic>> getVerifyItems(String type) async {
    final response = await http.get(
      Uri.parse('$baseUrl?type=$type'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('โหลดข้อมูลตรวจสอบไม่สำเร็จ');
    }
  }

  static Future<void> updateStatus({
    required String type,
    required String id,
    required String status,
  }) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/$type/$id/status'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'status': status}),
    );

    if (response.statusCode != 200) {
      throw Exception('อัปเดตสถานะไม่สำเร็จ');
    }
  }
}

