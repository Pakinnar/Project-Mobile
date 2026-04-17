import 'package:flutter/material.dart';
import 'review_page.dart'; 
import 'home_page.dart'; 
import 'myjobs_page.dart'; 
import 'category_page.dart'; 
import 'dart:io';

class JobTrackingPage extends StatelessWidget {
  final Map<String, dynamic> job;

  const JobTrackingPage({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('รายละเอียดงาน', 
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildJobHeaderCard(),
            const SizedBox(height: 20),
            _buildEmployerCard(),
            const SizedBox(height: 20),
            _buildLocationCard(),
            const SizedBox(height: 20),
            _buildJobDetailCard(),
            const SizedBox(height: 30),
            _buildActionButtons(context),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildJobHeaderCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        image: DecorationImage(
          image: job['img'] != null && job['img'].startsWith('http') 
            ? NetworkImage(job['img']) 
            : (job['img'] != null && job['img'].isNotEmpty)
                ? FileImage(File(job['img'])) as ImageProvider
                : const NetworkImage('https://picsum.photos/400/200'), 
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 100),
            Row(
              children: [
                _badge('ยืนยันแล้ว', const Color(0xFF00E676)),
                const SizedBox(width: 10),
                _badge('GIG-29410', Colors.white.withOpacity(0.3)),
              ],
            ),
            const SizedBox(height: 10),
            Text(job['title'] ?? 'รับจ้างล้างแอร์ 3 เครื่อง', 
              style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text('${job['price'] ?? '฿0'} ราคาเหมา', 
              style: const TextStyle(color: Color(0xFF00E676), fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 12)),
    );
  }

  Widget _buildEmployerCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=worker'),
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('ผู้จ้าง', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  Text('คุณสมชาย สุขุมวิท', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.chat_bubble_outline, size: 18),
              label: const Text('คุยกับผู้จ้าง'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black87,
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('สถานที่', style: TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 5),
          Row(
            children: const [
              Icon(Icons.location_on, color: Color(0xFF00E676), size: 20),
              SizedBox(width: 10),
              Expanded(child: Text('คอนโดหรู ย่านอโศก-รัชดา ชั้น 12 กม.', style: TextStyle(fontWeight: FontWeight.w500))),
            ],
          ),
          TextButton(
            onPressed: () {},
            child: const Text('ดูแผนที่ ↗', style: TextStyle(color: Color(0xFF00E676))),
          ),
        ],
      ),
    );
  }

  Widget _buildJobDetailCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.description_outlined, color: Color(0xFF00E676), size: 18),
              SizedBox(width: 10),
              Text('รายละเอียดงาน', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 15),
          _buildCheckItem('ล้างแอร์แบบติดผนัง จำนวน 3 เครื่อง (9,000 - 12,000 BTU)'),
          _buildCheckItem('เช็คระดับน้ำยาแอร์ และเติมน้ำยาแอร์ (ถ้าจำเป็น)'),
          _buildCheckItem('ล้างทำความสะอาดแผ่นกรองและคอยล์ร้อน'),
          _buildCheckItem('หน้างานเริ่มได้ตั้งแต่เวลา 10:00 น. เป็นต้นไป'),
        ],
      ),
    );
  }

  Widget _buildCheckItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF00E676), size: 18),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13, color: Colors.black87))),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.refresh),
            label: const Text('อัปเดตงาน'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              foregroundColor: Colors.black87,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          flex: 6,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReviewPage(job: job)),
              );
            },
            icon: const Icon(Icons.check_circle_outline),
            label: const Text('งานเสร็จสิ้น'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              backgroundColor: const Color(0xFF00E676),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      height: 85,
      decoration: BoxDecoration(
        color: Colors.white, 
        border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1))
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(context, Icons.home_outlined, 'หน้าหลัก', false, onTap: () {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomePage()), (route) => false);
          }),
          _navItem(context, Icons.grid_view_outlined, 'หมวดหมู่', false, onTap: () {
             Navigator.push(context, MaterialPageRoute(builder: (context) => const CategoryPage()));
          }),
          _navItem(context, Icons.assignment, 'งาน', true, onTap: () {
             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MyJobsPage()));
          }),
          _navItem(context, Icons.chat_bubble_outline, 'แชท', false, onTap: () {}),
          _navItem(context, Icons.person_outline, 'โปรไฟล์', false, onTap: () {}),
        ],
      ),
    );
  }

  Widget _navItem(BuildContext context, IconData icon, String label, bool isSelected, {VoidCallback? onTap}) {
    final Color color = isSelected ? const Color(0xFF00E676) : const Color(0xFF94A3B8);
    return InkWell(
      onTap: onTap,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: SizedBox(
        width: 65, 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 5),
            Text(
              label, 
              style: TextStyle(
                fontSize: 11, 
                color: color, 
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500
              )
            ),
          ],
        ),
      ),
    );
  }
}