import 'package:flutter/material.dart';

class JobProgressPage extends StatelessWidget {
  final Map<String, dynamic> job;

  const JobProgressPage({super.key, required this.job});

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
        title: const Text('ความคืบหน้างาน',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
            _buildWorkerHeader(),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  _buildTimelineStep(
                    title: 'กำลังดำเนินการ',
                    subtitle: 'วันนี้, 10:30 AM',
                    isCompleted: true,
                    isLast: false,
                  ),
                  _buildTimelineStep(
                    title: 'เริ่มงานแล้ว',
                    subtitle: 'วันเสาร์, 10:30 AM',
                    isCompleted: true,
                    isLast: false,
                  ),
                  _buildTimelineStep(
                    title: 'เสร็จสิ้น',
                    subtitle: 'คาดว่าเสร็จสิ้นเวลา: 12:30 PM',
                    isCompleted: true,
                    isLast: false,
                    showExtraCard: true,
                  ),
                  _buildTimelineStep(
                    title: 'Completed',
                    subtitle: 'Estimated: 12:30 PM',
                    isCompleted: false,
                    isLast: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            _buildPriceSummary(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkerHeader() {
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
          const CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=alex'),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Alex Rivera', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Text('ช่างประปา • 4.9 ⭐', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
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
              Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isCompleted ? Colors.black87 : Colors.grey)),
              Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              if (showExtraCard) ...[
                const SizedBox(height: 10),
                _buildTaskDetailCard(),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTaskDetailCard() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(8)),
          child: const Text('คาดว่าเสร็จสิ้นเวลา: 12:30 PM', style: TextStyle(color: Color(0xFF00E676), fontSize: 12)),
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

  Widget _buildPriceSummary() {
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
          const Text('\$1,800.00', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
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
}