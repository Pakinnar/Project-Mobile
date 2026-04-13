import 'package:flutter/material.dart';
import 'addjob_page.dart'; 
import 'myjobs_page.dart'; 
import 'job_detail_page.dart'; 
import 'category_page.dart'; 
import 'job_detail_hiring_page.dart'; 
import 'dart:io'; 

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState(); 
}

class HomePageState extends State<HomePage> {
  
  static List<Map<String, String>> jobList = [
    {
      'title': 'รับจ้างล้างแอร์ 3 เครื่อง', 
      'price': '฿1,800',                
      'desc': 'ต้องการช่างล้างแอร์แบบติดผนัง จำนวน 3 เครื่อง รวมเติมน้ำยาแอร์และเช็คระบบเบื้องต้น ช่างต้องนำอุปกรณ์มาเองทั้งหมดครับ',
      'img': 'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?q=80&w=500',
      'cate': 'บริการช่าง',
      'dist': '1.2 กม.',
      'location': 'เขตวัฒนา, กรุงเทพมหานคร',
      'date': '25 พฤศจิกายน 2566 | 09:00 - 12:00 น.',
    },
    {
      'title': 'หาคนช่วยจัดสวนหน้าบ้าน',
      'price': '฿850',
      'desc': 'ต้องการคนช่วยตัดหญ้าและพรวนดิน พื้นที่ประมาณ 15 ตร.ว. อุปกรณ์มีให้พร้อมครับ งานด่วนครับผม',
      'img': 'https://images.unsplash.com/photo-1558905611-1430919a7990?q=80&w=500',
      'cate': 'งานบ้านและสวน',
      'dist': '2.8 กม.',
    },
    {
      'title': 'ช่างซ่อมไฟฟ้าด่วน',
      'price': '฿600',
      'desc': 'ไฟดับบางจุดในบ้าน ต้องการช่างมาตรวจสอบและแก้ไขเดินสายไฟใหม่เฉพาะจุดครับ ติดต่อได้ตลอด 24 ชม.',
      'img': 'https://images.unsplash.com/photo-1621905252507-b354bcadc0d6?q=80&w=500',
      'cate': 'งานซ่อมบำรุง',
      'dist': '0.5 กม.',
    },
  ];

  static List<Map<String, String>> acceptedJobList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          'Local Job Hub',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterSection(),
          Expanded(
            child: jobList.isEmpty 
              ? _buildEmptyState() 
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80), 
                  itemCount: jobList.length,
                  itemBuilder: (context, index) {
                    return _buildJobItem(jobList[index]);
                  },
                ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF00E676),
        child: const Icon(Icons.add, color: Colors.white, size: 35),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddJobPage()),
          );
          setState(() {}); 
        },
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildEmptyState() {
    return const Center(child: Text('ยังไม่มีงานที่ลงประกาศ'));
  }

  Widget _buildFilterSection() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _filterChip('ใกล้ฉัน', true),
          _filterChip('งานด่วน', false),
          _filterChip('ยอดนิยม', false),
        ],
      ),
    );
  }

  Widget _filterChip(String label, bool selected) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: Chip(
        label: Text(label),
        backgroundColor: selected ? const Color(0xFF00E676) : Colors.grey[100],
        labelStyle: TextStyle(color: selected ? Colors.white : Colors.black),
      ),
    );
  }

  Widget _buildJobItem(Map<String, String> job) {
    return GestureDetector( 
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => JobDetailPage(job: job)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Colors.grey[100]!)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[200], 
                borderRadius: BorderRadius.circular(12)
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _buildImageWidget(job['img']),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(job['title'] ?? '', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                      ),
                      Text(job['price'] ?? '', style: const TextStyle(color: Color(0xFF00E676), fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(job['desc'] ?? '', maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageWidget(String? imgPath) {
    if (imgPath == null || imgPath.isEmpty) {
      return const Icon(Icons.image, color: Colors.grey, size: 30);
    }
    
    if (imgPath.startsWith('http')) {
      return Image.network(
        imgPath, 
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, color: Colors.grey),
      );
    }
    
    final file = File(imgPath);
    if (file.existsSync()) {
      return Image.file(
        file, 
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, color: Colors.grey),
      );
    }

    return const Icon(Icons.image, color: Colors.grey);
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(context, Icons.home_filled, 'หน้าหลัก', true, onTap: () {}),
          _navItem(context, Icons.grid_view_outlined, 'หมวดหมู่', false, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CategoryPage()))),
          _navItem(context, Icons.assignment_outlined, 'งานของฉัน', false, onTap: () {
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (context) => const MyJobsPage(),
              ),
            );
          }),
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
            Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}