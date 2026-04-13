import 'package:flutter/material.dart';
import 'applicants_page.dart'; 

class JobStatusPage extends StatelessWidget {
  final Map<String, dynamic> job;

  const JobStatusPage({super.key, required this.job});

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
            icon: const Icon(Icons.share_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              (job['img'] != null && job['img'].toString().isNotEmpty)
                  ? job['img']
                  : 'https://picsum.photos/id/119/600/300', 
              width: double.infinity, height: 250, fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 250, color: Colors.grey[200], child: const Icon(Icons.image, size: 50),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderSection(),
                  const SizedBox(height: 25),
                  _buildInfoTile(Icons.location_on_outlined, 'สถานที่ปฏิบัติงาน', job['location'] ?? 'ไม่ระบุสถานที่'),
                  const SizedBox(height: 15),
                  _buildInfoTile(Icons.calendar_today_outlined, 'วันที่ทำงาน', job['date'] ?? 'ไม่ระบุวันเวลา'),
                  const SizedBox(height: 30),
                  const Text('รายละเอียดงาน', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(
                    job['desc'] ?? job['description'] ?? 'ไม่มีรายละเอียดเพิ่มเติม',
                    style: const TextStyle(color: Colors.black87, height: 1.6, fontSize: 15),
                  ),
                  const SizedBox(height: 40),
                  _buildActionButtons(context),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                job['title'] ?? 'ไม่มีชื่อประกาศ', 
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)
              ),
            ),
            _badge(job['status'] ?? 'กำลังรับสมัคร', const Color(0xFFE8F5E9), const Color(0xFF00E676)),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          job['price'] != null ? '${job['price']} บาท' : 'ไม่ระบุราคา', 
          style: const TextStyle(fontSize: 26, color: Color(0xFF00E676), fontWeight: FontWeight.bold)
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ApplicantsPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00E676),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: const Text('ดูผู้สมัครทั้งหมด (5 คน)', 
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          width: double.infinity,
          height: 55,
          child: OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.redAccent, width: 1.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: const Text('ยกเลิกงาน', 
              style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String sub) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, size: 24, color: const Color(0xFF64748B)),
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 13, color: Colors.grey)),
            Text(sub, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _badge(String text, Color bg, Color textCol) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(text, style: TextStyle(color: textCol, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }
}