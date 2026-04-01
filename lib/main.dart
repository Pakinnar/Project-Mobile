import 'package:flutter/material.dart';
import 'pages/profile_page.dart';
import 'pages/edit_profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Service App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const ProfilePage(),
    );
  }
}


