import 'package:flutter/material.dart';
import 'payment_success_page.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int _selectedMethod = 0;

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
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Text('ยอดชำระทั้งหมด', style: TextStyle(color: Colors.grey, fontSize: 16)),
            const SizedBox(height: 10),
            const Text('฿ 1,800.00', 
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
            const SizedBox(height: 8),
            _buildStatusBadge(),
            
            const SizedBox(height: 30),
            _buildJobSummaryCard(),
            
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('วิธีการชำระเงิน', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(onPressed: () {}, child: const Text('เพิ่มใหม่', style: TextStyle(color: Colors.grey))),
              ],
            ),
            const SizedBox(height: 10),
            _buildPaymentMethodItem(0, Icons.credit_card, 'บัตรเครดิต/เดบิต', 'Visa ลงท้ายด้วย 4242'),
            _buildPaymentMethodItem(1, Icons.qr_code_scanner, 'พร้อมเพย์', 'โอนเงินผ่านธนาคารทันที'),
            _buildPaymentMethodItem(2, Icons.account_balance_wallet_outlined, 'อี-วอลเล็ต', 'PayPal, GrabPay, TrueMoney'),
            
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_outline, size: 16, color: Colors.grey[400]),
                const SizedBox(width: 5),
                Text('การชำระเงินของคุณปลอดภัยและได้รับการเข้ารหัส', 
                  style: TextStyle(color: Colors.grey[400], fontSize: 12)),
              ],
            ),
            const SizedBox(height: 20),
            
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentSuccessPage(
                        job: {
                          'title': 'รับจ้างล้างแอร์ 3 เครื่อง',
                          'price': '1,800', 
                        },
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00E676),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text('ดำเนินการต่อ', 
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified_user_outlined, size: 14, color: Color(0xFF00E676)),
          SizedBox(width: 4),
          Text('ตรวจสอบแล้ว', style: TextStyle(color: Color(0xFF00E676), fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildJobSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.shopping_bag_outlined, color: Color(0xFF00E676)),
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('รับจ้างล้างแอร์ 3 เครื่อง', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text('หมายเลขประกาศ: #23081', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          const Text('รายละเอียด', style: TextStyle(color: Color(0xFF00E676), fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodItem(int index, IconData icon, String title, String subtitle) {
    bool isSelected = _selectedMethod == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? const Color(0xFF00E676) : Colors.grey.shade200,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: const Color(0xFF64748B)),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFF00E676) : Colors.grey.shade300,
                  width: 2,
                ),
                color: isSelected ? const Color(0xFF00E676) : Colors.transparent,
              ),
              child: isSelected ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
            ),
          ],
        ),
      ),
    );
  }
}