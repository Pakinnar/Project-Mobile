import 'package:flutter/material.dart';
import 'services/job_api_service.dart';

class WorkerProfilePage extends StatelessWidget {
  final JobApplicantItem applicant;

  const WorkerProfilePage({
    super.key,
    required this.applicant,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> skills = applicant.skills
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'โปรไฟล์ผู้สมัคร',
          style: TextStyle(
            color: Color(0xFF111827),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 52,
                    backgroundColor: const Color(0xFFE8F5E9),
                    backgroundImage: applicant.img.isNotEmpty
                        ? NetworkImage(applicant.img)
                        : null,
                    child: applicant.img.isEmpty
                        ? Text(
                            applicant.name.isNotEmpty
                                ? applicant.name.characters.first
                                : '?',
                            style: const TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF00E676),
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    applicant.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    applicant.jobTitle.isNotEmpty
                        ? applicant.jobTitle
                        : 'ไม่ระบุตำแหน่ง/อาชีพ',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _statusText(applicant.status),
                      style: const TextStyle(
                        color: Color(0xFF00A63E),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            _sectionCard(
              title: 'เกี่ยวกับผู้สมัคร',
              child: Text(
                applicant.desc.isNotEmpty ? applicant.desc : 'ไม่มีคำอธิบาย',
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF374151),
                  height: 1.6,
                ),
              ),
            ),

            _sectionCard(
              title: 'ทักษะและความเชี่ยวชาญ',
              child: skills.isEmpty
                  ? const Text(
                      'ไม่มีข้อมูลทักษะ',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF6B7280),
                      ),
                    )
                  : Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: skills.map((skill) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0FDF4),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: const Color(0xFFCDEFD6),
                            ),
                          ),
                          child: Text(
                            skill,
                            style: const TextStyle(
                              color: Color(0xFF166534),
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
            ),

            _sectionCard(
              title: 'ข้อมูลติดต่อ',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow(
                    Icons.email_outlined,
                    applicant.email.isNotEmpty ? applicant.email : 'ไม่ระบุอีเมล',
                  ),
                  const SizedBox(height: 12),
                  _infoRow(
                    Icons.phone_outlined,
                    applicant.phone.isNotEmpty ? applicant.phone : 'ไม่ระบุเบอร์โทร',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  static String _statusText(String status) {
    switch (status) {
      case 'hired':
        return 'ถูกจ้างแล้ว';
      case 'rejected':
        return 'ถูกปฏิเสธ';
      case 'backup':
        return 'รายชื่อสำรอง';
      default:
        return 'สมัครแล้ว';
    }
  }

  Widget _sectionCard({
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF6B7280), size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF374151),
            ),
          ),
        ),
      ],
    );
  }
}