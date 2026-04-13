import 'package:flutter/material.dart';
import 'home_page.dart';
import 'category_page.dart';
import 'myjobs_page.dart';
import 'job_status_page.dart'; 
import 'worker_profile_page.dart';

class JobDetailHiringPage extends StatelessWidget {
  final Map<String, dynamic> job;

  const JobDetailHiringPage({super.key, required this.job});

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
              (job['img'] != null && job['img'].isNotEmpty) 
                  ? job['img'] 
                  : 'https://picsum.photos/id/119/600/300', 
              width: double.infinity, 
              height: 250, 
              fit: BoxFit.cover,
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
                    job['desc'] ?? job['description'] ?? 'ไม่มีรายละเอียดงานเพิ่มเติม',
                    style: const TextStyle(color: Colors.black87, height: 1.6, fontSize: 15),
                  ),
                  const SizedBox(height: 30),
                  _buildWorkerCard(context),
                  const SizedBox(height: 30),
                  _buildActionButtons(context),
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

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                job['title'] ?? 'รับจ้างล้างแอร์ 3 เครื่อง', 
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)
              ),
            ),
            _badge(job['status'] ?? 'จ้างงานแล้ว', const Color(0xFFE8F5E9), const Color(0xFF00E676)),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          job['price'] != null && job['price'].toString().contains('฿') 
              ? '${job['price']}' 
              : '${job['price'] ?? '1,800'} บาท', 
          style: const TextStyle(fontSize: 26, color: Color(0xFF00E676), fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildWorkerCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=alex'),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Alex Rivers', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Row(
                  children: const [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    Text(' 4.8 (24 รีวิว)', style: TextStyle(fontSize: 13, color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const WorkerProfilePage())
              );
            },
            child: const Text('ดูโปรไฟล์', 
              style: TextStyle(color: Color(0xFF00E676), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
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
                MaterialPageRoute(builder: (context) => JobStatusPage(job: job))
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00E676),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: const Text('ดูสถานะ', 
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          width: double.infinity,
          height: 55,
          child: OutlinedButton(
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const WorkerProfilePage())
              );
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: const Text('ดูโปรไฟล์ผู้รับจ้าง', 
              style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold, fontSize: 16)),
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
          child: Icon(icon, size: 22, color: const Color(0xFF64748B)),
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

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      height: 85,
      decoration: BoxDecoration(
        color: Colors.white, 
        border: Border(top: BorderSide(color: Colors.grey.shade200))
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(context, Icons.home_outlined, 'หน้าหลัก', false, onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()))),
          _navItem(context, Icons.grid_view_outlined, 'หมวดหมู่', false, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CategoryPage()))),
          _navItem(context, Icons.assignment, 'งานของฉัน', true, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MyJobsPage()))), 
          _navItem(context, Icons.chat_bubble_outline, 'ข้อความ', false, onTap: () {}),
          _navItem(context, Icons.person_outline, 'โปรไฟล์', false, onTap: () {}),
        ],
      ),
    );
  }

  Widget _navItem(BuildContext context, IconData icon, String label, bool isSelected, {VoidCallback? onTap}) {
    final Color color = isSelected ? const Color(0xFF00E676) : const Color(0xFF94A3B8);
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 65,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 10, color: color, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}