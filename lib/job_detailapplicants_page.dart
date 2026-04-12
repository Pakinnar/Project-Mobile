import 'package:flutter/material.dart';
import 'dart:io';
import 'category_page.dart';
import 'job_tracking_page.dart';
import 'jobapplicants_page.dart'; // ✨ 1. เพิ่มการ Import หน้าดูรายชื่อผู้สมัคร

class JobDetailApplicantsPage extends StatelessWidget {
  final Map<String, String> job;

  const JobDetailApplicantsPage({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('รายละเอียดงาน',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.share, color: Colors.black)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageHeader(job['img']),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(job['title'] ?? 'รับจ้างล้างแอร์ 3 เครื่อง',
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      ),
                      _buildStatusBadge('กำลังรับสมัคร'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(job['price'] ?? '1,800 บาท',
                      style: const TextStyle(fontSize: 22, color: Color(0xFF00E676), fontWeight: FontWeight.bold)),

                  const SizedBox(height: 25),

                  _buildIconDetail(Icons.location_on_outlined, 'สถานที่ปฏิบัติงาน', 'เขตวัฒนา, กรุงเทพมหานคร'),
                  const SizedBox(height: 15),
                  _buildIconDetail(Icons.calendar_today_outlined, 'วันที่ทำงาน', '25 พฤศจิกายน 2566 | 09:00 - 12:00 น.'),

                  const SizedBox(height: 25),

                  const Text('รายละเอียดงาน', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(
                    job['desc'] ?? 'ต้องการช่างล้างแอร์แบบติดผนัง จำนวน 3 เครื่อง (ขนาด 12,000 BTU 2 เครื่อง และ 18,000 BTU 1 เครื่อง) รวมเติมน้ำยาแอร์ (ถ้าจำเป็น) และเช็คระบบเบื้องต้น ช่างต้องนำอุปกรณ์มาเองทั้งหมด สถานที่คือคอนโดมิเนียม มีที่จอดรถให้ครับ',
                    style: TextStyle(color: Colors.grey[700], height: 1.5, fontSize: 14),
                  ),

                  const SizedBox(height: 40),

                  // ✨ 2. แก้ไขปุ่มดูผู้สมัครทั้งหมด ให้เชื่อมต่อไปหน้า JobApplicantsPage
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00E676),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 0,
                      ),
                      onPressed: () {
                        // ✨ นำทางไปยังหน้า JobApplicantsPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const JobApplicantsPage(),
                          ),
                        );
                      },
                      child: const Text('ดูผู้สมัครทั้งหมด (5 คน)',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),

                  const SizedBox(height: 15),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red, width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      onPressed: () {
                        _showCancelDialog(context);
                      },
                      child: const Text('ยกเลิกงาน',
                          style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildImageHeader(String? imgPath) {
    return SizedBox(
      height: 250,
      width: double.infinity,
      child: (imgPath != null && imgPath.startsWith('http'))
          ? Image.network(imgPath, fit: BoxFit.cover)
          : (imgPath != null && File(imgPath).existsSync())
              ? Image.file(File(imgPath), fit: BoxFit.cover)
              : Container(color: Colors.grey[200], child: const Icon(Icons.image, size: 50)),
    );
  }

  Widget _buildStatusBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(20)),
      child: Text(text, style: const TextStyle(color: Color(0xFF00E676), fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildIconDetail(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: Colors.blueGrey, size: 20),
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          ],
        )
      ],
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ยกเลิกงาน?'),
        content: const Text('คุณแน่ใจหรือไม่ว่าต้องการยกเลิกประกาศงานนี้?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('ไม่ยกเลิก')),
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('ยืนยันยกเลิก', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(context, Icons.home, "หน้าหลัก", false, onTap: () => Navigator.pop(context)),
          _navItem(context, Icons.grid_view, 'หมวดหมู่', false, onTap: () {
             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const CategoryPage()));
          }),
          _navItem(context, Icons.assignment_outlined, 'งานของฉัน', true, onTap: () {}),
          _navItem(context, Icons.chat_bubble_outline, 'ข้อความ', false),
          _navItem(context, Icons.person_outline, 'โปรไฟล์', false),
        ],
      ),
    );
  }

  Widget _navItem(BuildContext context, IconData icon, String label, bool isSelected, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? const Color(0xFF00E676) : Colors.grey[400]),
          Text(label, style: TextStyle(fontSize: 12, color: isSelected ? const Color(0xFF00E676) : Colors.grey[400])),
        ],
      ),
    );
  }
}