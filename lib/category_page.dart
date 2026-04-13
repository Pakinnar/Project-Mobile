import 'package:flutter/material.dart';
import 'home_page.dart';
import 'myjobs_page.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

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
        title: const Text(
          'หมวดหมู่',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            _buildSearchBar(),
            const SizedBox(height: 25),
            const Text('ยอดนิยม', 
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
            const SizedBox(height: 15),
            Row(
              children: [
                _buildPopularCard('ทำความสะอาด', 'https://picsum.photos/id/1/200/200'),
                const SizedBox(width: 15),
                _buildPopularCard('ช่างเทคนิค', 'https://picsum.photos/id/2/200/200'),
              ],
            ),
            const SizedBox(height: 30),
            const Text('หมวดหมู่ทั้งหมด', 
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
            const SizedBox(height: 15),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              childAspectRatio: 1.1,
              children: [
                _buildCategoryCard('ช่างเทคนิค', Icons.build_outlined, const Color(0xFFE8F5E9), Colors.green),
                _buildCategoryCard('ทำความสะอาด', Icons.clean_hands_outlined, const Color(0xFFF3E5F5), Colors.purple),
                _buildCategoryCard('งานฝีมือ', Icons.content_cut_outlined, const Color(0xFFFFF3E0), Colors.orange),
                _buildCategoryCard('การจัดส่ง', Icons.local_shipping_outlined, const Color(0xFFE3F2FD), Colors.blue),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F0).withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: const TextField(
        decoration: InputDecoration(
          icon: Icon(Icons.search, color: Colors.grey),
          hintText: 'ค้นหาบริการ',
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildPopularCard(String title, String imageUrl) {
    return Expanded(
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken),
          ),
        ),
        alignment: Alignment.bottomLeft,
        padding: const EdgeInsets.all(15),
        child: Text(
          title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String title, IconData icon, Color bgColor, Color iconColor) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF334155)),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      height: 85,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(context, Icons.home_outlined, 'หน้าแรก', false, onTap: () {
            Navigator.pushAndRemoveUntil(
              context, 
              MaterialPageRoute(builder: (context) => const HomePage()), 
              (route) => false
            );
          }),
          _navItem(context, Icons.grid_view_rounded, 'หมวดหมู่', true, onTap: () {}),
          _navItem(context, Icons.assignment_outlined, 'งานของฉัน', false, onTap: () {
            Navigator.pushReplacement(
              context, 
              MaterialPageRoute(builder: (context) => const MyJobsPage())
            );
          }),
          _navItem(context, Icons.chat_bubble_outline, 'ข้อความ', false, onTap: () {}),
          _navItem(context, Icons.person_outline, 'โปรไฟล์', false, onTap: () {}),
        ],
      ),
    );
  }

  Widget _navItem(BuildContext context, IconData icon, String label, bool isSelected, {VoidCallback? onTap}) {
    final Color color = isSelected ? const Color(0xFF00E676) : const Color(0xFF94A3B8);
    return InkWell(
      onTap: onTap,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: SizedBox(
        width: 65,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 4),
            Text(
              label, 
              style: TextStyle(
                fontSize: 10, 
                color: color, 
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500
              )
            ),
          ],
        ),
      ),
    );
  }
}