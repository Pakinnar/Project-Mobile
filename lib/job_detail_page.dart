import 'package:flutter/material.dart';
import 'dart:io';
import 'home_page.dart'; 
import 'myjobs_page.dart';

class JobDetailPage extends StatelessWidget {
  final Map<String, String> job;

  const JobDetailPage({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderImage(),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMainInfo(),
                      const SizedBox(height: 20),
                      _buildQuickStats(),
                      const SizedBox(height: 25),
                      _buildJobDescription(),
                      const SizedBox(height: 25),
                      _buildLocationSection(),
                      const SizedBox(height: 100), 
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _circleButton(Icons.arrow_back, () => Navigator.pop(context)),
                _circleButton(Icons.bookmark_border, () {}),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomAction(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderImage() {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
        child: _buildImageWidget(job['img']),
      ),
    );
  }

  Widget _buildImageWidget(String? imgPath) {
    if (imgPath == null || imgPath.isEmpty) return _imagePlaceholder();
    if (imgPath.startsWith('http')) {
      return Image.network(imgPath, fit: BoxFit.cover, errorBuilder: (c, e, s) => _imagePlaceholder());
    }
    final file = File(imgPath);
    if (file.existsSync()) {
      return Image.file(file, fit: BoxFit.cover, errorBuilder: (c, e, s) => _imagePlaceholder());
    }
    return _imagePlaceholder();
  }

  Widget _imagePlaceholder() {
    return Container(color: Colors.grey[200], child: const Icon(Icons.image, size: 50, color: Colors.grey));
  }

  Widget _buildMainInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _badge('ยืนยันแล้ว', const Color(0xFF00E676)),
            const SizedBox(width: 8),
            _badge('2 วันที่แล้ว', Colors.grey.shade400),
          ],
        ),
        const SizedBox(height: 12),
        Text(job['title'] ?? 'ไม่มีหัวข้อ', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Text(job['cate'] ?? 'หมวดหมู่ทั่วไป', style: const TextStyle(color: Colors.grey, fontSize: 16)),
      ],
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildQuickStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _statItem(Icons.payments_outlined, job['price'] ?? '฿0', 'อัตราจ้าง'),
        _statItem(Icons.business_center_outlined, 'งานรายวัน', 'ประเภทงาน'),
        _statItem(Icons.calendar_month_outlined, 'ตามนัดหมาย', 'ความถี่'),
      ],
    );
  }

  Widget _statItem(IconData icon, String val, String sub) {
    return Container(
      width: 105,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF00E676), size: 20),
          const SizedBox(height: 8),
          Text(val, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), textAlign: TextAlign.center),
          Text(sub, style: const TextStyle(color: Colors.grey, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildJobDescription() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.description_outlined, color: Color(0xFF00E676), size: 20),
              SizedBox(width: 10),
              Text('รายละเอียดงาน', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            job['desc'] ?? 'ไม่มีรายละเอียดงานเพิ่มเติม',
            style: TextStyle(color: Colors.grey.shade700, height: 1.6),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _buildDynamicTags(),
          )
        ],
      ),
    );
  }

  List<Widget> _buildDynamicTags() {
    final String title = (job['title'] ?? '').toLowerCase();
    final String cate = (job['cate'] ?? '');

    if (cate == 'งานบ้านและสวน' || title.contains('สวน') || title.contains('หญ้า')) {
      return [_tag('ตัดหญ้า'), _tag('พรวนดิน'), _tag('จัดสวน')];
    } else if (cate == 'งานซ่อมบำรุง' || title.contains('ไฟฟ้า') || title.contains('ไฟ')) {
      return [_tag('ซ่อมไฟฟ้า'), _tag('เดินสายไฟ'), _tag('เช็คระบบไฟ')];
    } else if (title.contains('แอร์')) {
      return [_tag('ล้างแอร์ติดผนัง'), _tag('เติมน้ำยาแอร์'), _tag('เช็คระบบไฟฟ้า')];
    } else {
      return [_tag('บริการทั่วไป'), _tag('ตรวจสอบหน้างาน')];
    }
  }

  Widget _tag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: Colors.blue.withOpacity(0.05), borderRadius: BorderRadius.circular(10)),
      child: Text(text, style: const TextStyle(color: Colors.blue, fontSize: 12)),
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.location_on, color: Color(0xFF00E676), size: 20),
            SizedBox(width: 10),
            Text('สถานที่', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        const SizedBox(height: 10),
        Text(job['location'] ?? 'เขตวัฒนา, กรุงเทพมหานคร', style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 15),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(
            'https://media.wired.com/photos/59269cd37034dc5f91bec0f1/master/pass/GoogleMapsTA.jpg',
            height: 150, width: double.infinity, fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }

  Widget _circleButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: Icon(icon, color: Colors.black, size: 22),
      ),
    );
  }

  Widget _buildBottomAction(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 30),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: Row(
        children: [
          _circleButton(Icons.chat_bubble_outline, () {}),
          const SizedBox(width: 15),
          Expanded(
            child: SizedBox(
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00E676),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 0,
                ),
                onPressed: () {
                  bool isAlreadyAccepted = HomePageState.acceptedJobList.any(
                    (item) => item['title'] == job['title'] && item['price'] == job['price']
                  );
                  
                  if (!isAlreadyAccepted) {
                    HomePageState.acceptedJobList.insert(0, job);
                  }

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MyJobsPage()),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('สมัครงาน "${job['title']}" สำเร็จ!'),
                      backgroundColor: const Color(0xFF00E676),
                    ),
                  );
                },
                child: const Text('สมัครงานนี้', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}