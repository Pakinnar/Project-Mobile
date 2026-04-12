import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  // ตัวแปรเก็บวิธีชำระเงินที่เลือก (0: บัตร, 1: พร้อมเพย์, 2: อี-วอลเล็ท)
  int selectedMethod = 0;

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
        title: const Text('ชำระเงินอย่างปลอดภัย',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            // 1. ยอดรวมทั้งหมด
            const Text('ยอดรวมทั้งหมด', style: TextStyle(color: Colors.grey, fontSize: 16)),
            const SizedBox(height: 5),
            const Text('\$ 125.00',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
            const SizedBox(height: 10),
            _buildVerifiedBadge(),

            const SizedBox(height: 30),
            // 2. รายละเอียดงานย่อย
            _buildJobSummaryCard(),

            const SizedBox(height: 30),
            // 3. ส่วนเลือกวิธีชำระเงิน
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('วิธีการชำระเงิน',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(onPressed: () {}, child: const Text('เพิ่มใหม่', style: TextStyle(color: Colors.grey))),
              ],
            ),
            const SizedBox(height: 15),
            
            _buildPaymentOption(0, Icons.credit_card, 'บัตรเครดิต/เดบิต', 'Visa ลงท้ายด้วย 4242'),
            _buildPaymentOption(1, Icons.qr_code_scanner, 'พร้อมเพย์', 'โอนเงินผ่านธนาคารทันที'),
            _buildPaymentOption(2, Icons.account_balance_wallet_outlined, 'อี-วอลเล็ท', 'PayPal, GrabPay, TrueMoney'),

            const SizedBox(height: 40),
            // 4. ข้อความความปลอดภัย
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_outline, size: 16, color: Colors.grey[400]),
                const SizedBox(width: 5),
                Text('การชำระเงินปลอดภัยและได้รับการเข้ารหัส',
                    style: TextStyle(color: Colors.grey[400], fontSize: 12)),
              ],
            ),
            const SizedBox(height: 15),
            
            // 5. ปุ่มดำเนินการต่อ
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  print("ดำเนินการชำระเงินวิธีที่: $selectedMethod");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00E676),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 0,
                ),
                child: const Text('ดำเนินการต่อ',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Widget ย่อย ---

  Widget _buildVerifiedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(20)),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified_user_outlined, size: 14, color: Colors.green),
          SizedBox(width: 5),
          Text('ตรวจสอบแล้ว', style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildJobSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.green[100], borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.shopping_bag_outlined, color: Colors.green),
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('รับจ้างล้างแอร์ 3 เครื่อง', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('หมายเลขรายการ #26981', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          const Text('รายละเอียด', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(int index, IconData icon, String title, String subtitle) {
    bool isSelected = selectedMethod == index;
    return GestureDetector(
      onTap: () => setState(() => selectedMethod = index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? const Color(0xFF00E676) : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: Colors.grey[700]),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected ? const Color(0xFF00E676) : Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }
}