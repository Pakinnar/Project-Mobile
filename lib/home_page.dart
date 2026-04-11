import 'package:flutter/material.dart';
import 'add_job_page.dart';
import 'category_page.dart';
import 'job_detail_page.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ข้อมูลเริ่มต้น
  final List<Map<String, String>> jobList = [
    {
      'title': 'รับจ้างล้างแอร์',
      'price': '฿1,800',
      'desc': 'บริการล้างเครื่องปรับอากาศแบบติดผนัง รวมเติมน้ำยา...',
      'dist': '2.5 กม.',
      'cate': 'บริการช่าง',
      'img': 'https://images.unsplash.com/photo-1581094288338-2314dddb7ecc?w=200',
    },
  ];

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
            child: ListView.builder(
              itemCount: jobList.length,
              itemBuilder: (context, index) {
                // ใช้การดึงข้อมูลที่ปลอดภัยขึ้น
                final Map<String, String> job = jobList[index];
                return _buildJobItem(job, context);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF00E676),
        child: const Icon(Icons.add, color: Colors.white, size: 35),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddJobPage()),
          );
          
          if (result != null && result is Map<String, String>) {
            setState(() {
              // เพิ่มข้อมูลใหม่ไว้บนสุด
              jobList.insert(0, result);
            });
          }
        },
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _filterChip('ใกล้ฉัน', Icons.map, true),
          _filterChip('รายได้สูง', Icons.attach_money, false),
          _filterChip('ใหม่ล่าสุด', Icons.access_time, false),
        ],
      ),
    );
  }

  Widget _filterChip(String label, IconData icon, bool selected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: selected,
        label: Text(label),
        avatar: Icon(
          icon,
          size: 18,
          color: selected ? Colors.white : Colors.black54,
        ),
        onSelected: (bool value) {},
        selectedColor: const Color(0xFF00E676),
        checkmarkColor: Colors.white,
        backgroundColor: Colors.grey[100],
        labelStyle: TextStyle(
          color: selected ? Colors.white : Colors.black54,
          fontWeight: FontWeight.bold,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.transparent),
        ),
      ),
    );
  }

  Widget _buildJobItem(Map<String, String> job, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => JobDetailPage(job: job)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey[100]!)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _buildJobImage(job['img']),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        job['title'] ?? 'ไม่มีชื่อหัวข้อ',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        job['price'] ?? '0',
                        style: const TextStyle(
                          color: Color(0xFF00E676),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    job['desc'] ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: Colors.grey[400]),
                      Text(
                        ' ${job['dist'] ?? '0.0 กม.'}',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(width: 10),
                      Icon(Icons.build, size: 14, color: Colors.grey[400]),
                      Text(
                        ' ${job['cate'] ?? 'ทั่วไป'}',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobImage(String? imgPath) {
    if (imgPath == null || imgPath.isEmpty) {
      return Container(
        width: 80, 
        height: 80, 
        color: Colors.grey[200], 
        child: const Icon(Icons.image, color: Colors.grey)
      );
    }

    try {
      if (imgPath.startsWith('http')) {
        return Image.network(
          imgPath, 
          width: 80, 
          height: 80, 
          fit: BoxFit.cover,
          // เพิ่มการเช็ค error ป้องกันแอปค้างเวลาเน็ตหลุด
          errorBuilder: (context, error, stackTrace) => _imageErrorPlaceholder(),
        );
      } else {
        // เช็คว่าไฟล์มีอยู่จริงไหมก่อนโหลด
        final file = File(imgPath);
        if (file.existsSync()) {
          return Image.file(
            file, 
            width: 80, 
            height: 80, 
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _imageErrorPlaceholder(),
          );
        } else {
          return _imageErrorPlaceholder();
        }
      }
    } catch (e) {
      return _imageErrorPlaceholder();
    }
  }

  Widget _imageErrorPlaceholder() {
    return Container(
      width: 80, 
      height: 80, 
      color: Colors.grey[200], 
      child: const Icon(Icons.broken_image, color: Colors.grey)
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.home, "หน้าหลัก", true),
          _navItem(
            Icons.grid_view,
            'หมวดหมู่',
            false,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CategoryPage()),
              );
            },
          ),
          _navItem(Icons.assignment_outlined, 'งานของฉัน', false),
          _navItem(Icons.chat_bubble_outline, 'ข้อความ', false),
          _navItem(Icons.person_outline, 'โปรไฟล์', false),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, bool isSelected, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF00E676) : Colors.grey[400],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? const Color(0xFF00E676) : Colors.grey[400],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}