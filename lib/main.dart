import 'package:flutter/material.dart';
import 'home_page.dart';

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
        useMaterial3: false, 
      ),
      home: const HomePage(),
    );
  }
}