import 'package:flutter/material.dart';
import 'review_page.dart';
import 'home_page.dart';
import 'myjobs_page.dart';
import 'category_page.dart';
import 'dart:io';
import 'services/job_api_service.dart';

class JobProgressPage extends StatefulWidget {
  final int jobId;
  final int workerUserId;
  final Map<String, dynamic> job;

  const JobProgressPage({
    super.key,
    required this.jobId,
    required this.workerUserId,
    required this.job,
  });

  @override
  State<JobProgressPage> createState() => _JobProgressPageState();
}

class _JobProgressPageState extends State<JobProgressPage> {
  late Future<PaymentSummaryResponse> _futureSummary;

  @override
  void initState() {
    super.initState();
    _futureSummary = JobApiService.getPaymentSummary(
      jobId: widget.jobId,
      workerUserId: widget.workerUserId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PaymentSummaryResponse>(
      future: _futureSummary,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
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
                'ความคืบหน้างาน',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'โหลดสถานะงานไม่สำเร็จ\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        final data = snapshot.data!;
        final job = data.job;
        final worker = data.worker;
        final priceText = data.payment != null
            ? data.payment!.amount.toStringAsFixed(2)
            : job.budget.toStringAsFixed(2);

        final jobMap = {
          'id': job.id.toString(),
          'title': job.title,
          'price': '฿$priceText',
          'desc': job.description,
          'img': job.imageUrl,
          'cate': job.category,
          'location': job.location,
          'date': job.workDate.isNotEmpty || job.workTime.isNotEmpty
              ? '${job.workDate}${job.workTime.isNotEmpty ? ' | ${job.workTime}' : ''}'
              : '',
          'status': job.status,
          'payment_status': job.paymentStatus,
        };

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
              'ความคืบหน้างาน',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.more_horiz, color: Colors.black),
                onPressed: () {},
              ),
            ],
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildWorkerHeader(worker),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      _buildTimelineStep(
                        title: 'กำลังดำเนินการ',
                        subtitle: 'ชำระเงินแล้ว',
                        isCompleted: true,
                        isLast: false,
                      ),
                      _buildTimelineStep(
                        title: 'เริ่มงานแล้ว',
                        subtitle: job.workDate.isNotEmpty ? job.workDate : 'รอดำเนินการ',
                        isCompleted: true,
                        isLast: false,
                      ),
                      _buildTimelineStep(
                        title: 'เสร็จสิ้น',
                        subtitle: job.workTime.isNotEmpty
                            ? 'คาดว่าเสร็จสิ้นเวลา: ${job.workTime}'
                            : 'คาดว่าเสร็จสิ้นเร็ว ๆ นี้',
                        isCompleted: true,
                        isLast: false,
                        showExtraCard: true,
                      ),
                      _buildTimelineStep(
                        title: 'Completed',
                        subtitle: 'Estimated: ${job.workTime.isNotEmpty ? job.workTime : '-'}',
                        isCompleted: false,
                        isLast: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                _buildPriceSummary(priceText),
                const SizedBox(height: 20),
              ],
            ),
          ),
          bottomNavigationBar: _buildBottomNav(context),
        );
      },
    );
  }

  Widget _buildWorkerHeader(PaymentWorkerInfo worker) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5)),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: worker.img.isNotEmpty ? NetworkImage(worker.img) : null,
            child: worker.img.isEmpty
                ? Text(
                    worker.name.isNotEmpty ? worker.name.characters.first : '?',
                  )
                : null,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  worker.name.isNotEmpty ? worker.name : 'ผู้รับจ้าง',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  '${worker.jobTitle.isNotEmpty ? worker.jobTitle : 'ผู้รับจ้าง'} • ชำระเงินแล้ว',
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ],
            ),
          ),
          _circleIconButton(Icons.phone, Colors.green[50]!, Colors.green),
          const SizedBox(width: 10),
          _circleIconButton(Icons.chat_bubble_outline, Colors.green[50]!, Colors.green),
        ],
      ),
    );
  }

  Widget _buildTimelineStep({
    required String title,
    required String subtitle,
    required bool isCompleted,
    required bool isLast,
    bool showExtraCard = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: isCompleted ? const Color(0xFF00E676) : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: isCompleted ? Colors.transparent : Colors.grey.shade300, width: 2),
              ),
              child: isCompleted ? const Icon(Icons.check, color: Colors.white, size: 20) : null,
            ),
            if (!isLast)
              Container(width: 2, height: showExtraCard ? 130 : 50, color: Colors.grey.shade200),
          ],
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isCompleted ? Colors.black87 : Colors.grey,
                ),
              ),
              Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              if (showExtraCard) ...[
                const SizedBox(height: 10),
                _buildTaskDetailCard(subtitle),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTaskDetailCard(String subtitle) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(8)),
          child: Text(
            subtitle,
            style: const TextStyle(color: Color(0xFF00E676), fontSize: 12),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(12)),
          child: const Text('เสร็จสิ้น', style: TextStyle(color: Colors.grey)),
        ),
      ],
    );
  }

  Widget _buildPriceSummary(String priceText) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF1FDF6),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('ยอดรวมทั้งหมด', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text('ติดตามอัตราค่าบริการรายชั่วโมง', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            ],
          ),
          Text(
            '\$$priceText',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _circleIconButton(IconData icon, Color bg, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: Icon(icon, color: iconColor, size: 20),
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
          _navItem(context, Icons.home_outlined, 'หน้าหลัก', false, onTap: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
              (route) => false,
            );
          }),
          _navItem(context, Icons.grid_view_outlined, 'หมวดหมู่', false, onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CategoryPage()),
            );
          }),
          _navItem(context, Icons.assignment, 'งาน', true, onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MyJobsPage()),
            );
          }),
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
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: SizedBox(
        width: 65,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}