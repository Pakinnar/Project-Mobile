import 'package:flutter/material.dart';
import 'home_page.dart';
import 'job_progress_page.dart'; 

class PaymentSuccessPage extends StatelessWidget {
  final Map<String, dynamic> job;

  const PaymentSuccessPage({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8F5E9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Color(0xFF00E676),
                    size: 100,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'ชำระเงินเสร็จสิ้น',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'ขอบคุณที่ใช้บริการ',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 40),

              _buildReceiptCard(),

              const SizedBox(height: 40),

              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.file_download_outlined, size: 18, color: Colors.grey),
                label: const Text('บันทึกใบเสร็จรับเงิน', style: TextStyle(color: Colors.grey)),
              ),

              const Spacer(),

              _buildButton(
                label: 'ดูสถานะงาน',
                color: const Color(0xFF00E676),
                textColor: Colors.white,
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JobProgressPage(job: job),
                    ),
                  );
                },
              ),
              const SizedBox(height: 15),

              _buildButton(
                label: 'กลับหน้าหลัก',
                color: Colors.white,
                textColor: Colors.black87,
                isOutlined: true,
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                    (route) => false,
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          _receiptRow('หมายเลขรายการ', '#GF-992834'),
          const Divider(height: 30),
          _receiptRow('ช่องทางชำระเงิน', 'บัตรเครดิต', icon: Icons.credit_card),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('ยอดชำระทั้งหมด', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                '${job['price'] ?? '1,800'} บาท',
                style: const TextStyle(color: Color(0xFF00E676), fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _receiptRow(String label, String value, {IconData? icon}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Row(
          children: [
            if (icon != null) Icon(icon, size: 16, color: Colors.grey),
            if (icon != null) const SizedBox(width: 5),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }

  Widget _buildButton({
    required String label,
    required Color color,
    required Color textColor,
    required VoidCallback onPressed,
    bool isOutlined = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          elevation: 0,
          side: isOutlined ? BorderSide(color: Colors.grey.shade200) : null,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}