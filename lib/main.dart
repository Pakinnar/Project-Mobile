import 'package:flutter/material.dart';
import 'home_page.dart'; // Import หน้าหลักมาใช้ที่นี่

void main() {
  runApp(const LocalJobHubApp());
}

class LocalJobHubApp extends StatelessWidget {
  const LocalJobHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Local Job Hub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF00E676),
        useMaterial3: false, // ปิดเพื่อให้ UI ดูเหมือนในรูปที่คุณส่งมา
      ),
      home: const HomePage(), // เรียกใช้ HomePage จากไฟล์ที่แยกไป
    );
  }
}