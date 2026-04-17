import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class AppConfig {
  static const String baseUrl = 'http://localhost:3000/api';
  // Android Emulator:
  // static const String baseUrl = 'http://10.0.2.2:3000/api';
}

// ── type helpers ──────────────────────────────
double _toDouble(dynamic v) {
  if (v == null) return 0.0;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString()) ?? 0.0;
}

int _toInt(dynamic v) {
  if (v == null) return 0;
  if (v is int) return v;
  if (v is num) return v.toInt();
  return int.tryParse(v.toString()) ?? 0;
}

bool _toBool(dynamic v) {
  if (v == null) return false;
  if (v is bool) return v;
  if (v is num) return v == 1;
  final t = v.toString().toLowerCase();
  return t == '1' || t == 'true';
}

// ─────────────────────────────────────────────
// UserProfile — ตรงกับ users table หลัง migrate
// ─────────────────────────────────────────────
class UserProfile {
  final int id;
  final String fullName;          // full_name
  final String email;
  final String? phone;
  final String? bio;
  final String? jobTitle;         // job_title  ← migrate เพิ่ม
  final double rating;
  final int totalJobs;            // total_jobs
  final bool isVerified;          // is_verified
  final String? profileImageUrl;  // profile_image_url ← migrate เพิ่ม
  final List<String> skills;      // skills (comma-string ใน DB) ← migrate เพิ่ม

  UserProfile({
    required this.id,
    required this.fullName,
    required this.email,
    this.phone,
    this.bio,
    this.jobTitle,
    required this.rating,
    required this.totalJobs,
    required this.isVerified,
    this.profileImageUrl,
    required this.skills,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    // skills: backend ส่งเป็น List<String> แล้ว (parse ไว้ใน route)
    List<String> parsedSkills = [];
    final raw = json['skills'];
    if (raw is List) {
      parsedSkills = raw.map((e) => e.toString()).toList();
    } else if (raw is String && raw.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(raw);
        parsedSkills = decoded is List
            ? decoded.map((e) => e.toString()).toList()
            : raw.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      } catch (_) {
        parsedSkills = raw.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      }
    }

    return UserProfile(
      id:              _toInt(json['id']),
      fullName:        json['full_name']?.toString() ?? '',
      email:           json['email']?.toString() ?? '',
      phone:           json['phone']?.toString(),
      bio:             json['bio']?.toString(),
      jobTitle:        json['job_title']?.toString(),
      rating:          _toDouble(json['rating']),
      totalJobs:       _toInt(json['total_jobs']),
      isVerified:      _toBool(json['is_verified']),
      profileImageUrl: json['profile_image_url']?.toString(),
      skills:          parsedSkills,
    );
  }
}

// ─────────────────────────────────────────────
// PortfolioItem — portfolios table หลัง migrate
// ─────────────────────────────────────────────
class PortfolioItem {
  final int id;
  final int? userId;      // user_id ← migrate เพิ่ม
  final String? userName; // user_name (เดิม)
  final String description;
  final String? tags;
  final String? imageUrl; // image_url
  final String verifyStatus;

  PortfolioItem({
    required this.id,
    this.userId,
    this.userName,
    required this.description,
    this.tags,
    this.imageUrl,
    required this.verifyStatus,
  });

  factory PortfolioItem.fromJson(Map<String, dynamic> json) {
    return PortfolioItem(
      id:           _toInt(json['id']),
      userId:       json['user_id'] == null ? null : _toInt(json['user_id']),
      userName:     json['user_name']?.toString(),
      description:  json['description']?.toString() ?? '',
      tags:         json['tags']?.toString(),
      imageUrl:     json['image_url']?.toString(),
      verifyStatus: json['verify_status']?.toString() ?? 'pending',
    );
  }
}

// ─────────────────────────────────────────────
// EarningItem — earnings table หลัง migrate
// ─────────────────────────────────────────────
class EarningItem {
  final int id;
  final int? userId;       // user_id ← migrate เพิ่ม
  final double amount;
  final String? title;     // title ← migrate เพิ่ม
  final String? description;
  final String? workDate;  // work_date ← migrate เพิ่ม
  final String status;     // status ← migrate เพิ่ม

  EarningItem({
    required this.id,
    this.userId,
    required this.amount,
    this.title,
    this.description,
    this.workDate,
    required this.status,
  });

  factory EarningItem.fromJson(Map<String, dynamic> json) {
    return EarningItem(
      id:          _toInt(json['id']),
      userId:      json['user_id'] == null ? null : _toInt(json['user_id']),
      amount:      _toDouble(json['amount']),
      title:       json['title']?.toString(),
      description: json['description']?.toString(),
      workDate:    json['work_date']?.toString(),
      status:      json['status']?.toString() ?? 'paid',
    );
  }
}

class EarningsSummary {
  final double totalMonth;
  final double previousMonth;
  final double availableBalance;
  final List<EarningItem> recentItems;

  EarningsSummary({
    required this.totalMonth,
    required this.previousMonth,
    required this.availableBalance,
    required this.recentItems,
  });

  factory EarningsSummary.fromJson(Map<String, dynamic> json) {
    final items = (json['recent_items'] as List? ?? [])
        .map((e) => EarningItem.fromJson(e as Map<String, dynamic>))
        .toList();
    return EarningsSummary(
      totalMonth:        _toDouble(json['total_month']),
      previousMonth:     _toDouble(json['previous_month']),
      availableBalance:  _toDouble(json['available_balance']),
      recentItems:       items,
    );
  }

  /// % เปลี่ยนแปลงเทียบเดือนที่แล้ว
  double get changePercent {
    if (previousMonth == 0) return 0;
    return ((totalMonth - previousMonth) / previousMonth) * 100;
  }
}

// ─────────────────────────────────────────────
// ProfileApiService
// ─────────────────────────────────────────────
class ProfileApiService {

  // GET /api/users/:id/profile
  static Future<UserProfile> getProfile(int userId) async {
    final res = await http.get(
      Uri.parse('${AppConfig.baseUrl}/users/$userId/profile'),
      headers: {'Content-Type': 'application/json'},
    ).timeout(const Duration(seconds: 10));

    if (res.statusCode != 200) {
      throw Exception('โหลดโปรไฟล์ไม่สำเร็จ (${res.statusCode}): ${res.body}');
    }
    return UserProfile.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  // PUT /api/users/:id/profile  (multipart)
  static Future<UserProfile> updateProfile({
    required int userId,
    required String fullName,
    required String email,
    required String phone,
    required String bio,
    required String jobTitle,
    required List<String> skills,
    Uint8List? profileImageBytes,
    String? profileImageFileName,
  }) async {
    final uri     = Uri.parse('${AppConfig.baseUrl}/users/$userId/profile');
    final request = http.MultipartRequest('PUT', uri);

    request.fields['full_name'] = fullName;
    request.fields['email']     = email;
    request.fields['phone']     = phone;
    request.fields['bio']       = bio;
    request.fields['job_title'] = jobTitle;
    request.fields['skills']    = jsonEncode(skills); // ส่งเป็น ["A","B"]

    if (profileImageBytes != null && profileImageBytes.isNotEmpty) {
      request.files.add(http.MultipartFile.fromBytes(
        'profile_image',
        profileImageBytes,
        filename: profileImageFileName ?? 'profile.jpg',
      ));
    }

    final streamed = await request.send().timeout(const Duration(seconds: 20));
    final res      = await http.Response.fromStream(streamed);

    if (res.statusCode != 200) {
      throw Exception('อัปเดตโปรไฟล์ไม่สำเร็จ (${res.statusCode}): ${res.body}');
    }
    return UserProfile.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  // GET /api/users/:id/portfolios
  static Future<List<PortfolioItem>> getPortfolios(int userId) async {
    final res = await http.get(
      Uri.parse('${AppConfig.baseUrl}/users/$userId/portfolios'),
      headers: {'Content-Type': 'application/json'},
    ).timeout(const Duration(seconds: 10));

    if (res.statusCode != 200) {
      throw Exception('โหลดผลงานไม่สำเร็จ (${res.statusCode}): ${res.body}');
    }
    final data = jsonDecode(res.body) as List;
    return data.map((e) => PortfolioItem.fromJson(e as Map<String, dynamic>)).toList();
  }

  // GET /api/users/:id/earnings
  static Future<EarningsSummary> getEarnings(int userId) async {
    final res = await http.get(
      Uri.parse('${AppConfig.baseUrl}/users/$userId/earnings'),
      headers: {'Content-Type': 'application/json'},
    ).timeout(const Duration(seconds: 10));

    if (res.statusCode != 200) {
      throw Exception('โหลดรายได้ไม่สำเร็จ (${res.statusCode}): ${res.body}');
    }
    return EarningsSummary.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }
}