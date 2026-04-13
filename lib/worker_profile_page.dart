import 'package:flutter/material.dart';
import 'payment_page.dart'; 

class WorkerProfilePage extends StatelessWidget {
  const WorkerProfilePage({super.key});

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
        title: const Text('โปรไฟล์ผู้รับเหมา', 
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildProfileHeader(),
            const SizedBox(height: 25),
            _buildActionButtons(context),
            const SizedBox(height: 30),
            _buildAboutSection(),
            const SizedBox(height: 30),
            _buildPortfolioSection(),
            const SizedBox(height: 30),
            _buildReviewSection(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage('https://i.pravatar.cc/300?u=alex_rivera'),
            ),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: const Icon(Icons.check_circle, color: Color(0xFF00E676), size: 28),
            ),
          ],
        ),
        const SizedBox(height: 15),
        const Text('Alex Rivera', 
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        const Text('ช่างไฟฟ้าผู้เชี่ยวชาญและช่างซ่อมทั่วไป', 
          style: TextStyle(color: Colors.grey, fontSize: 16)),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 20),
            const Text(' 4.9', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text('  •  120 งาน', style: TextStyle(color: Colors.grey[400], fontSize: 14)),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.chat_bubble_outline, size: 20),
                label: const Text('ข้อความ'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF1F5F9),
                  foregroundColor: Colors.black87,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: SizedBox(
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PaymentPage()),
                  );
                },
                icon: const Icon(Icons.flash_on, size: 20),
                label: const Text('จ้างตอนนี้'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00E676),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(Icons.person_outline, 'เกี่ยวกับฉัน'),
          const SizedBox(height: 12),
          const Text(
            'มีประสบการณ์มากกว่า 10 ปีในงานไฟฟ้าและงานซ่อมแซมบ้านทั่วไป ฉันภูมิใจในฝีมือที่มีคุณภาพและการบริการที่เชื่อถือได้ มีใบอนุญาตและประกันครบถ้วน เชี่ยวชาญด้านการติดตั้งระบบสมาร์ทโฮม',
            style: TextStyle(color: Colors.black87, fontSize: 15, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildPortfolioSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _sectionTitle(Icons.image_outlined, 'ผลงาน'),
              TextButton(onPressed: () {}, child: const Text('ดูทั้งหมด', style: TextStyle(color: Color(0xFF00E676)))),
            ],
          ),
        ),
        const SizedBox(height: 10),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: [
            _portfolioItem('https://picsum.photos/id/1/200/200'),
            _portfolioItem('https://picsum.photos/id/122/200/200'),
            _portfolioItem('https://picsum.photos/id/119/200/200'),
            _portfolioMoreItem(12),
          ],
        ),
      ],
    );
  }

  Widget _buildReviewSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _sectionTitle(Icons.star_outline, 'รีวิว'),
              const Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 18),
                  Text(' 4.9', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(' (120)', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          _reviewCard('Sarah Jenkins', '2 วันที่แล้ว', 'อเล็กซ์ทำงานได้ยอดเยี่ยมมากในการติดตั้งไฟในห้องครัวใหม่ของเราเขาตรงต่อเวลาสะอาดและราคาตรงตามที่เสนอราคาไว้เป๊ะ แนะนำเลย!', 5.0),
          const SizedBox(height: 12),
          _reviewCard('Michael Chen', '1 สัปดาห์ที่แล้ว', 'งานเปลี่ยนกล่องฟิวส์ยอดเยี่ยมมาก มีความรู้มากและอธิบายทุกขั้นตอนได้อย่างชัดเจน', 4.8),
          const SizedBox(height: 20),
          Center(
            child: TextButton(onPressed: () {}, child: const Text('ดูรีวิวทั้งหมด 120 รายการ', style: TextStyle(color: Colors.grey))),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF00E676), size: 24),
        const SizedBox(width: 10),
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _portfolioItem(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Image.network(url, fit: BoxFit.cover),
    );
  }

  Widget _portfolioMoreItem(int count) {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(15)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.image_outlined, color: Colors.grey, size: 30),
          Text('+$count เพิ่มเติม', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _reviewCard(String name, String time, String comment, double rating) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 18, backgroundImage: NetworkImage('https://i.pravatar.cc/100?u=$name')),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 14),
                    Text(' $rating', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(comment, style: const TextStyle(color: Colors.black87, fontSize: 14, height: 1.4)),
        ],
      ),
    );
  }
}