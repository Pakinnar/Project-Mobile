import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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

  List<String> selectedSkills = [];
  final List<String> commonSkills = [
    'ล้างแอร์',
    'เติมน้ำยา',
    'เช็คระบบไฟ',
    'ล้างรถ',
    'ซ่อมประปา',
    'ทำความสะอาด',
    'ซ่อมเครื่องใช้ไฟฟ้า',
  ];

  File? _image;
  final ImagePicker _picker = ImagePicker();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final descController = TextEditingController();

  // ฟังก์ชันเลือกวันที่
  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  // ฟังก์ชันเลือกเวลา
  Future<void> _pickTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => selectedTime = picked);
  }

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
              'ทักษะที่จำเป็น (เลือกได้มากกว่า 1)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: commonSkills.map((skill) {
                final isSelected = selectedSkills.contains(skill);
                return FilterChip(
                  label: Text(skill),
                  selected: isSelected,
                  onSelected: (bool value) {
                    setState(() {
                      if (value) {
                        selectedSkills.add(skill);
                      } else {
                        selectedSkills.remove(skill);
                      }
                    });
                  },
                  selectedColor: const Color(0xFF00E676).withOpacity(0.2),
                  checkmarkColor: const Color(0xFF00E676),
                  labelStyle: TextStyle(
                    color: isSelected
                        ? const Color(0xFF00E676)
                        : Colors.black54,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                  backgroundColor: Colors.grey[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: isSelected
                          ? const Color(0xFF00E676)
                          : Colors.transparent,
                    ),
                  ),
                );
              }).toList(),
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

            const Text(
              'รูปภาพประกอบงาน',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: _image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(_image!, fit: BoxFit.cover),
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                          SizedBox(height: 8),
                          Text(
                            'คลิกเพื่อเลือกรูปภาพ',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'วันที่และเวลาที่ต้องการ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                // ช่องวันที่
                Expanded(
                  child: InkWell(
                    onTap:
                        _pickDate, // เชื่อมกับฟังก์ชันที่มีเส้นเหลืองก่อนหน้านี้
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 15,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 20,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            selectedDate == null
                                ? 'mm/dd/yyyy'
                                : "${selectedDate!.month}/${selectedDate!.day}/${selectedDate!.year}",
                            style: TextStyle(
                              color: selectedDate == null
                                  ? Colors.grey
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // ช่องเวลา
                Expanded(
                  child: InkWell(
                    onTap:
                        _pickTime, // เชื่อมกับฟังก์ชันที่มีเส้นเหลืองก่อนหน้านี้
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 15,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 20,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            selectedTime == null
                                ? '--:-- --'
                                : selectedTime!.format(context),
                            style: TextStyle(
                              color: selectedTime == null
                                  ? Colors.grey
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

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
                  Navigator.pop(context, {
                    'title': titleController.text,
                    'price': '฿${priceController.text}',
                    'desc': descController.text,
                    'skills': selectedSkills.join(','),
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
