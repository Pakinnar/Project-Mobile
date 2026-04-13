import 'package:flutter/material.dart';
import 'worker_profile_page.dart';
import 'payment_page.dart'; 

class ApplicantsPage extends StatelessWidget {
  const ApplicantsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> applicants = [
      {
        'name': 'Alex Rivera',
        'rating': '4.9',
        'reviews': '128',
        'price': '25',
        'desc': 'พนักงานทำความสะอาดที่มีประสบการณ์...',
        'img': 'https://i.pravatar.cc/150?u=alex',
        'tag': 'แนะนํา',
      },
      {
        'name': 'Michael Chen',
        'rating': '4.7',
        'reviews': '42',
        'price': '22',
        'desc': 'ว่างช่วงเสาร์-อาทิตย์ พร้อมเครื่องดูดฝุ่น...',
        'img': 'https://i.pravatar.cc/150?u=michael',
        'tag': '',
      },
      {
        'name': 'Jessica Wright',
        'rating': '4.5',
        'reviews': '15',
        'price': '20',
        'desc': 'บริการทำความสะอาดที่รวดเร็วและมี...',
        'img': 'https://i.pravatar.cc/150?u=jessica',
        'tag': '',
      },
      {
        'name': 'David Kim',
        'rating': 'ใหม่',
        'reviews': '0',
        'price': '18',
        'desc': 'นักศึกษาที่ขยันกำลังหางานพิเศษ',
        'img': 'https://i.pravatar.cc/150?u=david',
        'tag': '',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('ผู้สมัคร', 
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 14, color: Colors.grey[400]),
                    Text(' โพสต์เมื่อ 2 วันที่แล้ว  •  ', 
                      style: TextStyle(color: Colors.grey[400], fontSize: 13)),
                    Text('ผู้สมัคร 12 คน', 
                      style: TextStyle(color: Colors.grey[600], fontSize: 13, fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: applicants.length,
              itemBuilder: (context, index) {
                return _buildApplicantCard(context, applicants[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicantCard(BuildContext context, Map<String, dynamic> person) {
    bool isNew = person['rating'] == 'ใหม่';

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  CircleAvatar(radius: 30, backgroundImage: NetworkImage(person['img'])),
                  if (person['tag'] != '')
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: const Color(0xFF00E676), borderRadius: BorderRadius.circular(5)),
                      child: Text(person['tag'], style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                ],
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(person['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('\$${person['price']}/ชม.', 
                          style: const TextStyle(color: Color(0xFF00E676), fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        Text(' ${person['rating']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        if (!isNew)
                          Text(' (${person['reviews']} รีวิว)', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(person['desc'], 
                      style: const TextStyle(color: Colors.grey, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const WorkerProfilePage()));
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    side: BorderSide(color: Colors.grey.shade100),
                  ),
                  child: Text(isNew ? 'ใหม่' : 'ดูโปรไฟล์', style: const TextStyle(color: Colors.black87)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (!isNew) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PaymentPage()),
                      );
                    } else {
                      debugPrint('Selected backup list');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isNew ? const Color(0xFFF1F5F9) : const Color(0xFF00E676),
                    foregroundColor: isNew ? Colors.grey : Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(isNew ? 'รายชื่อสำรอง' : 'จ้างตอนนี้', style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}