import 'package:flutter/material.dart';

class ReviewsPage extends StatelessWidget {
  const ReviewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final reviews = [
      {
        'name': 'Sarah Jenkins',
        'rating': '5.0',
        'time': '2 วันที่แล้ว',
        'comment':
            'อเล็กซ์ทำงานได้ยอดเยี่ยมมากในการติดตั้งไฟห้องครัวใหม่ของเรา เขาตรงต่อเวลา สะอาด และราคาคุ้มค่า แนะนำเลย!',
      },
      {
        'name': 'Michael Chen',
        'rating': '4.8',
        'time': '1 สัปดาห์ที่แล้ว',
        'comment':
            'งานเปลี่ยนกล่องฟิวส์ยอดเยี่ยมมาก มีความรู้มากและอธิบายทุกอย่างได้ชัดเจน',
      },
      {
        'name': 'Emma Wilson',
        'rating': '5.0',
        'time': '2 สัปดาห์ที่แล้ว',
        'comment':
            'บริการดีมาก มาตรงเวลา ทำงานเรียบร้อย และให้คำแนะนำเกี่ยวกับระบบไฟในบ้านได้ดีมาก',
      },
      {
        'name': 'David Brown',
        'rating': '4.9',
        'time': '3 สัปดาห์ที่แล้ว',
        'comment':
            'ติดตั้งสมาร์ทโฮมได้รวดเร็วและเป็นมืออาชีพมาก ใช้งานได้จริงทุกจุด ประทับใจมาก',
      },
      {
        'name': 'Sophia Taylor',
        'rating': '4.7',
        'time': '1 เดือนที่แล้ว',
        'comment':
            'ช่วยซ่อมไฟภายในบ้านได้อย่างรวดเร็ว ราคาเหมาะสม และอธิบายปัญหาเข้าใจง่าย',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'รีวิวทั้งหมด',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: const Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 22),
                SizedBox(width: 6),
                Text(
                  '4.9',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  '(120 รีวิว)',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: reviews.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final review = reviews[index];
                return _buildReviewCard(
                  name: review['name']!,
                  rating: review['rating']!,
                  time: review['time']!,
                  comment: review['comment']!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard({
    required String name,
    required String rating,
    required String time,
    required String comment,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEFEFEF)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 22,
            backgroundImage: AssetImage('assets/avatar_placeholder.png'),
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
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7E6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star,
                              color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            rating,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  comment,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Color(0xFF374151),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
