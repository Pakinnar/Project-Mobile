import 'package:flutter/material.dart';

class AddJobPage extends StatefulWidget {
  const AddJobPage({super.key});

  @override
  State<AddJobPage> createState() => _AddJobPageState();
}

class _AddJobPageState extends State<AddJobPage> {
  String selectedCate = 'เลือกประเภทงาน';
  final List<String> categories = [
    'เลือกประเภทงาน',
    'บริการช่าง',
    'งานปรับปรุง',
    'งานซ่อมบำรุง',
    'ยานยนต์',
    'งานบ้านและสวน',
  ];

  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'ลงประกาศงาน',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ชื่อหัวข้องาน',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'ระบุชื่อหัวข้องานที่ต้องการจ้าง',
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'เลือกหมวดหมู่',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            DropdownButtonFormField<String>(
              initialValue: selectedCate,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: categories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (val) => setState(() => selectedCate = val!),
            ),
            const SizedBox(height: 20),

            const Text(
              'รายละเอียดงาน',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: descController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText:
                    'อธิบายรายละเอียดของงานที่คุณต้องการเพื่อให้ผู้รับงานเข้าใจ...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'งบประมาณ (บาท)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(
                hintText: '0.00',
                suffixText: '฿',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00E676),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  // ส่งข้อมูลกลับไปหน้าหลัก
                  Navigator.pop(context, {
                    'title': titleController.text,
                    'price': '฿${priceController.text}',
                    'desc': descController.text,
                    'dist': '0.0 กม.',
                    'cate': selectedCate,
                    'img':
                        'https://images.unsplash.com/photo-1521791136064-7986c2923216?w=200',
                  });
                },
                child: const Text(
                  'ลงประกาศงาน',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
