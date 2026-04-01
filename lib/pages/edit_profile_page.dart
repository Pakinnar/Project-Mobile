import 'package:flutter/material.dart';


class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("แก้ไขโปรไฟล์"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              "บันทึก",
              style: TextStyle(color: Colors.green),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAvatar(),
            const SizedBox(height: 20),
            _buildSectionTitle("ข้อมูลวิชาชีพ"),
            _buildTextField("ชื่อ-นามสกุล", "Alex Mitchell"),
            _buildTextField(
              "ตำแหน่งวิชาชีพ",
              "ช่างไฟฟ้าผู้เชี่ยวชาญและผู้เชี่ยวชาญด้านสมาร์ทโฮม",
            ),
            _buildTextField(
              "เกี่ยวกับฉัน",
              "ช่างไฟฟ้าที่มีประสบการณ์กว่า 12 ปี...",
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            _buildSectionTitle("ทักษะและความเชี่ยวชาญ"),
            Wrap(
              spacing: 8,
              children: [
                _chip("การเดินสายไฟ"),
                _chip("สมาร์ทโฮม"),
                _chip("การซ่อมแซมทั่วไป"),
                _chip("โทรทัศน์"),
                _chip("งานติดตั้ง"),
              ],
            ),
            const SizedBox(height: 20),
            _buildSectionTitle("ผลงาน"),
            Row(
              children: [
                _buildImage("assets/work1.jpg"),
                const SizedBox(width: 8),
                _buildImage("assets/work2.jpg"),
                const SizedBox(width: 8),
                _addImageBox(),
              ],
            ),
            const SizedBox(height: 20),
            _buildSectionTitle("ข้อมูลการติดต่อ"),
            _buildTextField("เบอร์โทรศัพท์", "(555) 123-4567"),
            _buildTextField("อีเมล", "alex.mitchell@servicepro.com"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[100],
                foregroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("ออกจากโปรไฟล์ช่าง"),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              const CircleAvatar(
                radius: 45,
                backgroundImage: AssetImage('assets/alex_rivera.jpg'),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(6),
                  child: const Icon(Icons.edit, color: Colors.white, size: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text("เปลี่ยนรูปโปรไฟล์",
              style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTextField(String label, String hint,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _chip(String text) {
    return Chip(
      label: Text(text),
      backgroundColor: Colors.green[50],
    );
  }

  Widget _buildImage(String path) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.asset(
        path,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _addImageBox() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(
        child: Icon(Icons.add, color: Colors.green),
      ),
    );
  }
}

