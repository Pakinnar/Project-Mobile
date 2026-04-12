import 'package:flutter/material.dart';
import 'payment_page.dart'; 

class ContractorProfilePage extends StatelessWidget {
  const ContractorProfilePage({super.key});

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
            
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }


  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage('https://i.pravatar.cc/300?u=alex'),
            ),
            Positioned(
              bottom: 5,
              right: 5,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                child: const Icon(Icons.check, color: Colors.white, size: 15),
              ),
            )
          ],
        ),
        const SizedBox(height: 15),
        const Text('Alex Rivera',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        const Text('ช่างไฟฟ้าผู้เชี่ยวชาญและช่างซ่อมทั่วไป',
            style: TextStyle(color: Colors.grey, fontSize: 16)),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(20)),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star, color: Colors.orange, size: 18),
              Text(' 4.9', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(' • 120 งาน', style: TextStyle(color: Colors.grey)),
            ],
          ),
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
            child: ElevatedButton.icon(
              onPressed: () {
                
              },
              icon: const Icon(Icons.chat_outlined, color: Colors.black87),
              label: const Text('ข้อความ', style: TextStyle(color: Colors.black87)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[100],
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: ElevatedButton.icon(
              
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PaymentPage()),
                );
              },
              icon: const Icon(Icons.bolt, color: Colors.white),
              label: const Text('จ้างตอนนี้', 
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00E676),
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
          const Row(
            children: [
              Icon(Icons.person_outline, color: Color(0xFF00E676)),
              SizedBox(width: 8),
              Text('เกี่ยวกับฉัน', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'มีประสบการณ์มากกว่า 10 ปีในงานไฟฟ้าและงานซ่อมแซมบ้านทั่วไป ฉันภูมิใจในฝีมือที่มีคุณภาพและการบริการที่เชื่อถือได้ มีใบอนุญาตและประกันครบถ้วน เชี่ยวชาญด้านการติดตั้งระบบสมาร์ทโฮม',
            style: TextStyle(color: Colors.grey[700], height: 1.6),
          ),
        ],
      ),
    );
  }

  Widget _buildPortfolioSection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.image_outlined, color: Color(0xFF00E676)),
                  SizedBox(width: 8),
                  Text('ผลงาน', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              TextButton(onPressed: () {}, child: const Text('ดูทั้งหมด', style: TextStyle(color: Color(0xFF00E676)))),
            ],
          ),
        ),
        GridView.count(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: [
            _portfolioImage('https://images.unsplash.com/photo-1558402529-d2638a7023e9?w=400'),
            _portfolioImage('https://images.unsplash.com/photo-1613545325278-f24b0cae1224?w=400'),
            _portfolioImage('https://images.unsplash.com/photo-1556911220-e15b29be8c8f?w=400'),
            Container(
              decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(15)),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate_outlined, color: Colors.grey),
                  Text('+12 เพิ่มเติม', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _portfolioImage(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Image.network(url, fit: BoxFit.cover),
    );
  }

  Widget _buildReviewSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.star_outline, color: Color(0xFF00E676)),
                  SizedBox(width: 8),
                  Text('รีวิว', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              Row(
                children: [
                  Text('4.9', style: TextStyle(fontWeight: FontWeight.bold)),
                  Icon(Icons.star, color: Colors.orange, size: 16),
                  Text(' (120)', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          _reviewItem('Sarah Jenkins', 'อเล็กซ์ทำงานได้ยอดเยี่ยมมากในการติดตั้งไฟห้องครัวใหม่ของเราเขาตรงต่อเวลาและสะอาดมาก...', 5.0),
          const SizedBox(height: 15),
          _reviewItem('Michael Chen', 'งานเปลี่ยนกล่องฟิวส์ยอดเยี่ยมมาก มีความรู้มากและอธิบายทุกอย่างได้ชัดเจน', 4.8),
          const SizedBox(height: 20),
          TextButton(onPressed: () {}, child: const Text('ดูรีวิวทั้งหมด 120 รายการ', style: TextStyle(color: Colors.grey))),
        ],
      ),
    );
  }

  Widget _reviewItem(String name, String comment, double rating) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                child: Row(children: [const Icon(Icons.star, color: Colors.orange, size: 14), Text(' $rating', style: const TextStyle(fontSize: 12))]),
              )
            ],
          ),
          const SizedBox(height: 8),
          Text(comment, style: TextStyle(color: Colors.grey[700], fontSize: 13, height: 1.5)),
        ],
      ),
    );
  }
}