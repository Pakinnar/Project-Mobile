import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class JobApiService {
  static const String baseUrl = 'http://localhost:3000/api';
  // Android Emulator:
  // static const String baseUrl = 'http://10.0.2.2:3000/api';
  static Future<JobApplicantsResponse> getApplicants(int jobId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/jobs/$jobId/applicants'),
    );

    if (response.statusCode != 200) {
      throw Exception('โหลดผู้สมัครไม่สำเร็จ: ${response.body}');
    }

    return JobApplicantsResponse.fromJson(jsonDecode(response.body));
  }

  static Future<JobApplicantItem> getHiredWorker(int jobId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/jobs/$jobId/hired-worker'),
    );

    if (response.statusCode != 200) {
      throw Exception('โหลดข้อมูลผู้รับจ้างไม่สำเร็จ: ${response.body}');
    }

    return JobApplicantItem.fromJson(jsonDecode(response.body));
  }

  static Future<PaymentSummaryResponse> getPaymentSummary({
    required int jobId,
    required int workerUserId,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/jobs/$jobId/payment-summary/$workerUserId'),
    );

    if (response.statusCode != 200) {
      throw Exception('โหลดข้อมูลการชำระเงินไม่สำเร็จ: ${response.body}');
    }

    return PaymentSummaryResponse.fromJson(jsonDecode(response.body));
  }

  static Future<PaymentRecord> payNow({
    required int jobId,
    required int workerUserId,
    required double amount,
    String paymentMethod = 'manual',
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/jobs/$jobId/pay'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'worker_user_id': workerUserId,
        'amount': amount,
        'payment_method': paymentMethod,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('ชำระเงินไม่สำเร็จ: ${response.body}');
    }

    return PaymentRecord.fromJson(jsonDecode(response.body));
  }

  static Future<JobItem> hireApplicant({
    required int jobId,
    required int applicantId,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/jobs/$jobId/hire/$applicantId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('จ้างผู้สมัครไม่สำเร็จ: ${response.body}');
    }

    return JobItem.fromJson(jsonDecode(response.body));
  }

  static Future<void> cancelJob(int jobId) async {
    final response = await http.put(
      Uri.parse('$baseUrl/jobs/$jobId/cancel'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('ยกเลิกงานไม่สำเร็จ: ${response.body}');
    }
  }

  static Future<List<JobItem>> getJobs() async {
    final response = await http.get(Uri.parse('$baseUrl/jobs'));

    if (response.statusCode != 200) {
      throw Exception('โหลดงานไม่สำเร็จ: ${response.body}');
    }

    final data = jsonDecode(response.body) as List;
    return data.map((e) => JobItem.fromJson(e)).toList();
  }

  static Future<JobItem> getJobById(int jobId) async {
    final response = await http.get(Uri.parse('$baseUrl/jobs/$jobId'));

    if (response.statusCode != 200) {
      throw Exception('โหลดรายละเอียดงานไม่สำเร็จ: ${response.body}');
    }

    return JobItem.fromJson(jsonDecode(response.body));
  }

  static Future<JobItem> createJob({
    required int userId,
    required String title,
    required String category,
    required String description,
    required String budget,
    required String location,
    required String workDate,
    required String workTime,
    Uint8List? imageBytes,
    String? imageFileName,
  }) async {
    final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/jobs'));

    request.fields['user_id'] = userId.toString();
    request.fields['title'] = title;
    request.fields['category'] = category;
    request.fields['description'] = description;
    request.fields['budget'] = budget;
    request.fields['location'] = location;
    request.fields['work_date'] = workDate;
    request.fields['work_time'] = workTime;

    if (imageBytes != null && imageBytes.isNotEmpty) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename: imageFileName ?? 'job.jpg',
        ),
      );
    }

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode != 201) {
      throw Exception('สร้างงานไม่สำเร็จ: ${response.body}');
    }

    return JobItem.fromJson(jsonDecode(response.body));
  }

  static Future<List<JobItem>> getMyHiringJobs(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/jobs/user/$userId/hiring'),
    );

    if (response.statusCode != 200) {
      throw Exception('โหลดงานที่ฉันจ้างไม่สำเร็จ: ${response.body}');
    }

    final data = jsonDecode(response.body) as List;
    return data.map((e) => JobItem.fromJson(e)).toList();
  }

  static Future<List<JobItem>> getMyAcceptedJobs(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/jobs/user/$userId/accepted'),
    );

    if (response.statusCode != 200) {
      throw Exception('โหลดงานที่ฉันรับไม่สำเร็จ: ${response.body}');
    }

    final data = jsonDecode(response.body) as List;
    return data.map((e) => JobItem.fromJson(e)).toList();
  }

  static Future<JobItem> applyJob({
    required int jobId,
    required int workerUserId,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/jobs/$jobId/apply'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'worker_user_id': workerUserId}),
    );

    if (response.statusCode != 200) {
      throw Exception('สมัครงานไม่สำเร็จ: ${response.body}');
    }

    return JobItem.fromJson(jsonDecode(response.body));
  }
}

class JobItem {
  final int id;
  final String title;
  final String category;
  final String description;
  final String imageUrl;
  final double budget;
  final String location;
  final String workDate;
  final String workTime;
  final String status;
  final int? userId;
  final int? assignedWorkerId;

  JobItem({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.budget,
    required this.location,
    required this.workDate,
    required this.workTime,
    required this.status,
    required this.userId,
    required this.assignedWorkerId,
  });

  factory JobItem.fromJson(Map<String, dynamic> json) {
    return JobItem(
      id: _toInt(json['id']),
      title: json['title']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      imageUrl: json['image_url']?.toString() ?? '',
      budget: _toDouble(json['budget']),
      location: json['location']?.toString() ?? '',
      workDate: json['work_date']?.toString() ?? '',
      workTime: json['work_time']?.toString() ?? '',
      status: json['status']?.toString() ?? 'open',
      userId: json['user_id'] == null ? null : _toInt(json['user_id']),
      assignedWorkerId: json['assigned_worker_id'] == null
          ? null
          : _toInt(json['assigned_worker_id']),
    );
  }

  Map<String, String> toUiMap() {
    return {
      'id': id.toString(),
      'title': title,
      'price': '฿${budget.toStringAsFixed(0)}',
      'desc': description,
      'img': imageUrl,
      'cate': category,
      'dist': '',
      'location': location,
      'date': workDate.isNotEmpty || workTime.isNotEmpty
          ? '$workDate ${workTime.isNotEmpty ? '| $workTime' : ''}'.trim()
          : '',
      'status': status,
    };
  }
}

int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString()) ?? 0;
}

double _toDouble(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0;
}

class JobApplicantItem {
  final int id;
  final int jobId;
  final int workerUserId;
  final String status;
  final String name;
  final String email;
  final String phone;
  final String img;
  final String jobTitle;
  final String desc;
  final String skills;

  JobApplicantItem({
    required this.id,
    required this.jobId,
    required this.workerUserId,
    required this.status,
    required this.name,
    required this.email,
    required this.phone,
    required this.img,
    required this.jobTitle,
    required this.desc,
    required this.skills,
  });

  factory JobApplicantItem.fromJson(Map<String, dynamic> json) {
    return JobApplicantItem(
      id: _toInt(json['id']),
      jobId: _toInt(json['job_id']),
      workerUserId: _toInt(json['worker_user_id']),
      status: json['status']?.toString() ?? 'applied',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      img: json['img']?.toString() ?? '',
      jobTitle: json['job_title']?.toString() ?? '',
      desc: json['desc']?.toString() ?? '',
      skills: json['skills']?.toString() ?? '',
    );
  }
}

class JobApplicantsResponse {
  final JobItem job;
  final List<JobApplicantItem> applicants;

  JobApplicantsResponse({required this.job, required this.applicants});

  factory JobApplicantsResponse.fromJson(Map<String, dynamic> json) {
    final applicantsJson = (json['applicants'] as List?) ?? [];

    return JobApplicantsResponse(
      job: JobItem.fromJson(Map<String, dynamic>.from(json['job'])),
      applicants: applicantsJson
          .map((e) => JobApplicantItem.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}

class PaymentWorkerInfo {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String img;
  final String jobTitle;
  final String desc;
  final String skills;

  PaymentWorkerInfo({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.img,
    required this.jobTitle,
    required this.desc,
    required this.skills,
  });

  factory PaymentWorkerInfo.fromJson(Map<String, dynamic> json) {
    return PaymentWorkerInfo(
      id: _toInt(json['id']),
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      img: json['img']?.toString() ?? '',
      jobTitle: json['job_title']?.toString() ?? '',
      desc: json['desc']?.toString() ?? '',
      skills: json['skills']?.toString() ?? '',
    );
  }
}

class PaymentRecord {
  final int id;
  final int jobId;
  final int workerUserId;
  final double amount;
  final String status;
  final String paymentMethod;
  final String paidAt;

  PaymentRecord({
    required this.id,
    required this.jobId,
    required this.workerUserId,
    required this.amount,
    required this.status,
    required this.paymentMethod,
    required this.paidAt,
  });

  factory PaymentRecord.fromJson(Map<String, dynamic> json) {
    return PaymentRecord(
      id: _toInt(json['id']),
      jobId: _toInt(json['job_id']),
      workerUserId: _toInt(json['worker_user_id']),
      amount: _toDouble(json['amount']),
      status: json['status']?.toString() ?? 'pending',
      paymentMethod: json['payment_method']?.toString() ?? 'manual',
      paidAt: json['paid_at']?.toString() ?? '',
    );
  }
}

class PaymentSummaryResponse {
  final JobItem job;
  final PaymentWorkerInfo worker;
  final PaymentRecord? payment;

  PaymentSummaryResponse({
    required this.job,
    required this.worker,
    required this.payment,
  });

  factory PaymentSummaryResponse.fromJson(Map<String, dynamic> json) {
    return PaymentSummaryResponse(
      job: JobItem.fromJson(Map<String, dynamic>.from(json['job'])),
      worker: PaymentWorkerInfo.fromJson(
        Map<String, dynamic>.from(json['worker']),
      ),
      payment: json['payment'] == null
          ? null
          : PaymentRecord.fromJson(
              Map<String, dynamic>.from(json['payment']),
            ),
    );
  }
}


