import 'package:flutter/material.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "โปรไฟล์ของฉัน",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 16),
            _buildAboutSection(),
            const SizedBox(height: 24),
            _buildPortfolioSection(context),
            const SizedBox(height: 24),
            _buildReviewSection(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 45,
          backgroundImage: const AssetImage('assets/alex_rivera.jpg'),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(4),
              child: const Icon(Icons.verified, color: Colors.white, size: 16),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Alex Rivera",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const Text(
          "ช่างไฟฟ้าผู้เชี่ยวชาญและช่างซ่อมทั่วไป",
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.star, color: Colors.amber, size: 20),
            SizedBox(width: 4),
            Text("4.9"),
            SizedBox(width: 8),
            Text("(120 รีวิว)", style: TextStyle(color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfilePage(),
                  ),
                );
              },
              icon: const Icon(Icons.edit, color: Colors.white),
              label: const Text(
                "แก้ไขโปรไฟล์",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(width: 16),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.camera_alt_outlined),
              label: const Text("ดูรายได้"),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person_outline, color: Colors.green),
              SizedBox(width: 8),
              Text(
                "เกี่ยวกับฉัน",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            "มีประสบการณ์มากกว่า 10 ปีในงานไฟฟ้าและงานซ่อมแซมบ้านทั่วไป "
            "ฉันมุ่งมั่นใจในฝีมือที่มีคุณภาพและการบริการที่เชื่อถือได้ "
            "มีใบอนุญาตและประกันครบถ้วน เชี่ยวชาญในการติดตั้งระบบสมาร์ทโฮม",
            style: TextStyle(color: Colors.black87, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildPortfolioSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.photo_library_outlined, color: Colors.green),
            const SizedBox(width: 8),
            const Text(
              "ผลงานของฉัน",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Spacer(),
            TextButton(onPressed: () {}, child: const Text("ดูผลงาน →")),
          ],
        ),
        const SizedBox(height: 8),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildImage('assets/work1.jpg'),
            _buildImage('assets/work2.jpg'),
            _buildImage('assets/work3.jpg'),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text("+12 เพิ่มเติม"),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImage(String path) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.asset(path, fit: BoxFit.cover),
    );
  }

  Widget _buildReviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.star_border, color: Colors.green),
            SizedBox(width: 8),
            Text(
              "รีวิว",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Spacer(),
            Text("4.9 (120)", style: TextStyle(color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 12),
        _buildReviewItem(
          "Sarah Jenkins",
          "5.0",
          "2 วันที่แล้ว",
          "อเล็กซ์ทำงานได้ยอดเยี่ยมมากในการติดตั้งไฟห้องครัวใหม่ของเรา เขาตรงต่อเวลา สะอาด และราคาคุ้มค่า",
        ),
        const SizedBox(height: 12),
        _buildReviewItem(
          "Michael Chen",
          "4.8",
          "1 สัปดาห์ที่แล้ว",
          "งานเปลี่ยนกล่องฟิวส์ยอดเยี่ยมมาก มีความรู้มากและอธิบายทุกอย่างได้ชัดเจน",
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () {},
          child: const Center(child: Text("ดูรีวิวทั้งหมด 120 รายการ")),
        ),
      ],
    );
  }

  Widget _buildReviewItem(
    String name,
    String rating,
    String time,
    String comment,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            backgroundImage: AssetImage('assets/avatar_placeholder.png'),
            radius: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    Text(rating),
                  ],
                ),
                Text(
                  time,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(comment, style: const TextStyle(height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
      currentIndex: 4,
      onTap: (index) {},
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: "หน้าหลัก",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.category_outlined),
          label: "หมวดหมู่",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment_outlined),
          label: "งานของฉัน",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          label: "ข้อความ",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: "โปรไฟล์",
        ),
      ],
    );
  }
}

