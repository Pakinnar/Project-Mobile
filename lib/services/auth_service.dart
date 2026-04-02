import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Android Emulator ใช้ 10.0.2.2
  // Chrome ใช้ localhost
  static const String baseUrl = 'http://localhost:3000/api/auth';
  // ถ้าใช้ Android emulator:
  // static const String baseUrl = '[10.0.2.2](http://10.0.2.2:3000/api/auth)';

  static Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'full_name': fullName,
        'email': email,
        'password': password,
        'confirm_password': confirmPassword,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      await prefs.setString('role', data['user']['role']);
      await prefs.setString('full_name', data['user']['full_name']);
      await prefs.setString('email', data['user']['email']);
      return data;
    } else {
      throw Exception(data['message'] ?? 'สมัครสมาชิกไม่สำเร็จ');
    }
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    required String role,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'role': role,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      await prefs.setString('role', data['user']['role']);
      await prefs.setString('full_name', data['user']['full_name']);
      await prefs.setString('email', data['user']['email']);
      return data;
    } else {
      throw Exception(data['message'] ?? 'เข้าสู่ระบบไม่สำเร็จ');
    }
  }

  static Future<Map<String, dynamic>> getMe() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    } else {
      throw Exception(data['message'] ?? 'โหลดข้อมูลผู้ใช้ไม่สำเร็จ');
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
