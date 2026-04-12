import 'package:flutter/material.dart';
import 'contractorprofile_page.dart';
import 'payment_page.dart'; 

class JobApplicantsPage extends StatelessWidget {
  const JobApplicantsPage({super.key});

  final List<Map<String, dynamic>> applicants = const [
    {
      'name': 'Alex Rivera',
      'rating': '4.9',
      'reviews': '120 รีวิว',
      'price': '\$25',
      'bio': 'พนักงานทำความสะอาดที่มีประสบการณ์...',
      'img': 'https://i.pravatar.cc/150?u=alex',
      'isVerified': true,
    },
    {
      'name': 'Michael Chen',
      'rating': '4.7',
      'reviews': '92 รีวิว',
      'price': '\$22',
      'bio': 'ช่างแอร์มืออาชีพ พร้อมเครื่องมือครบชุด...',
      'img': 'https://i.pravatar.cc/150?u=michael',
      'isVerified': false,
    },
    {
      'name': 'Jessica Wright',
      'rating': '4.5',
      'reviews': '11 รีวิว',
      'price': '\$20',
      'bio': 'บริการทำความสะอาดรวดเร็วและเป็นกันเอง...',
      'img': 'https://i.pravatar.cc/150?u=jessica',
      'isVerified': false,
    },
  ];

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
        title: const Text('ผู้สมัคร',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('รับจ้างล้างแอร์ 3 เครื่อง',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text('โพสต์เมื่อ 2 วันที่แล้ว • ผู้สมัคร 12 คน',
                    style: TextStyle(color: Colors.grey[600], fontSize: 13)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: applicants.length,
              itemBuilder: (context, index) {
                return _buildApplicantCard(context, applicants[index]);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildApplicantCard(BuildContext context, Map<String, dynamic> person) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CircleAvatar(radius: 30, backgroundImage: NetworkImage(person['img'])),
                  if (person['isVerified'])
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00E676),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Text('Verified',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(person['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orange, size: 14),
                        Text(' ${person['rating']} ', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        Text('| ${person['reviews']}', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(person['bio'],
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  ],
                ),
              ),
              Text('${person['price']}/ชม.',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ContractorProfilePage()));
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.shade100),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('ดูโปรไฟล์', style: TextStyle(color: Colors.black54)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  // ✨ 2. แก้ไขปุ่ม "จ้างตอนนี้" ให้ไปหน้า PaymentPage
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PaymentPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00E676),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('จ้างตอนนี้', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          )
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
          _navItem(Icons.home, "หน้าหลัก", false, onTap: () => Navigator.popUntil(context, (route) => route.isFirst)),
          _navItem(Icons.grid_view, 'หมวดหมู่', false),
          _navItem(Icons.assignment_outlined, 'งานของฉัน', true),
          _navItem(Icons.chat_bubble_outline, 'ข้อความ', false),
          _navItem(Icons.person_outline, 'โปรไฟล์', false),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, bool isSelected, {VoidCallback? onTap}) {
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