import 'package:flutter/material.dart';
import 'home_page.dart';
import 'addjob_page.dart';
import 'job_status_page.dart'; 
import 'category_page.dart'; 
import 'dart:io';

class MyJobsPage extends StatefulWidget {
  final Map<String, String>? newJob;
  const MyJobsPage({super.key, this.newJob});

  @override
  State<MyJobsPage> createState() => _MyJobsPageState();
}

class _MyJobsPageState extends State<MyJobsPage> {
  
  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> myHiringJobs = HomePageState.jobList;      
    final List<Map<String, String>> myAcceptedJobs = HomePageState.acceptedJobList; 

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'งานของฉัน',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: Color(0xFF00E676),
            labelColor: Color(0xFF00E676),
            unselectedLabelColor: Colors.black54,
            indicatorWeight: 3,
            tabs: [
              Tab(text: 'งานที่ฉันจ้าง'),
              Tab(text: 'งานที่ฉันรับ'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            myHiringJobs.isEmpty 
                ? _buildEmptyState('ยังไม่มีงานที่จ้าง') 
                : _buildJobTabContent(context, myHiringJobs),

            myAcceptedJobs.isEmpty 
                ? _buildEmptyState('ยังไม่มีงานที่รับ') 
                : _buildJobTabContent(context, myAcceptedJobs),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF00E676),
          child: const Icon(Icons.add, color: Colors.white, size: 35),
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddJobPage()),
            );
            setState(() {}); 
          },
        ),
        bottomNavigationBar: _buildBottomNav(context),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_outlined, size: 80, color: Colors.grey[200]),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(fontSize: 18, color: Color(0xFF94A3B8), fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildJobTabContent(BuildContext context, List<Map<String, String>> jobs) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: jobs.length,
      itemBuilder: (context, index) {
        return _buildJobCard(context, jobs[index]);
      },
    );
  }

  Widget _buildJobCard(BuildContext context, Map<String, String> job) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  job['price'] ?? '฿0', 
                  style: const TextStyle(color: Color(0xFF00E676), fontWeight: FontWeight.bold, fontSize: 18)
                ),
                const SizedBox(height: 5),
                Text(
                  job['title'] ?? 'ไม่มีหัวข้อ', 
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.circle, size: 8, color: Colors.orange),
                    const SizedBox(width: 8),
                    const Text('สถานะ: รอดำเนินการ', style: TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: 140,
                  height: 38,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF1F5F9),
                      foregroundColor: Colors.black87,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JobStatusPage(job: job),
                        ),
                      );
                    },
                    child: const Text('ดูรายละเอียด', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 15),
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: _buildJobImage(job['img']),
          ),
        ],
      ),
    );
  }

  Widget _buildJobImage(String? imgPath) {
    if (imgPath == null || imgPath.isEmpty) return _imagePlaceholder();
    if (imgPath.startsWith('http')) {
      return Image.network(imgPath, width: 85, height: 85, fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _imagePlaceholder());
    }
    final file = File(imgPath);
    if (file.existsSync()) {
      return Image.file(file, width: 85, height: 85, fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _imagePlaceholder());
    }
    return _imagePlaceholder();
  }

  Widget _imagePlaceholder() {
    return Container(
      width: 85, height: 85, color: Colors.grey[100], 
      child: Icon(Icons.image_outlined, color: Colors.grey[300]), 
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      height: 85,
      decoration: BoxDecoration(
        color: Colors.white, 
        border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1))
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
          _navItem(context, Icons.grid_view_outlined, 'หมวดหมู่', false, onTap: () {
             Navigator.push(context, MaterialPageRoute(builder: (context) => const CategoryPage()));
          }),
          _navItem(context, Icons.assignment, 'งานของฉัน', true, onTap: () {}),
          _navItem(context, Icons.chat_bubble_outline, 'แชท', false, onTap: () {}),
          _navItem(context, Icons.person_outline, 'โปรไฟล์', false, onTap: () {}),
        ],
      ),
    );
  }

  Widget _navItem(BuildContext context, IconData icon, String label, bool isSelected, {VoidCallback? onTap}) {
    final Color color = isSelected ? const Color(0xFF00E676) : const Color(0xFF94A3B8);
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 65, 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 5),
            Text(label, style: TextStyle(fontSize: 10, color: color, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}