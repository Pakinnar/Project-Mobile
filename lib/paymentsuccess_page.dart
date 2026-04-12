import 'package:flutter/material.dart';
import 'home_page.dart';
import 'job_tracking_page.dart';

class PaymentSuccessPage extends StatelessWidget {
  const PaymentSuccessPage({super.key});

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
              
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Color(0xFF00E676),
                  size: 80,
                ),
              ),
              const SizedBox(height: 30),
              
              
              const Text(
                'ชำระเงินเสร็จสิ้น',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'ขอบคุณที่ใช้บริการ',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 40),

              
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey.shade100),
                ),
                child: Column(
                  children: [
                    _buildInfoRow('หมายเลขรายการ', '#GF-992834'),
                    const SizedBox(height: 15),
                    _buildInfoRow('ช่องทางชำระเงิน', 'บัตรเครดิต', isIcon: true),
                    const Divider(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('ยอดชำระทั้งหมด', 
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const Text('1,800 บาท', 
                          style: TextStyle(color: Color(0xFF00E676), fontWeight: FontWeight.bold, fontSize: 18)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),

              
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                   
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => JobTrackingPage(job: {
                        'title': 'รับจ้างล้างแอร์',
                        'price': '฿1,800',
                        'desc': 'บริการล้างเครื่องปรับอากาศแบบติดผนัง รวมเติมน้ำยา...',
                        'dist': '2.5 กม.',
                        'cate': 'บริการช่าง',
                        'img': 'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?w=400',
                      })),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00E676),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 0,
                  ),
                  child: const Text('ดูสถานะงาน',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 15),

              
              SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton(
                  onPressed: () {
                    
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.shade100),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text('กลับหน้าหลัก',
                      style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                ),
              ),
              
              const SizedBox(height: 25),
              
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.file_download_outlined, size: 18, color: Colors.grey),
                label: const Text('บันทึกใบเสร็จรับเงิน', style: TextStyle(color: Colors.grey, fontSize: 14)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isIcon = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        Row(
          children: [
            if (isIcon) const Icon(Icons.credit_card, size: 16, color: Colors.grey),
            if (isIcon) const SizedBox(width: 5),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          ],
        ),
      ],
    );
  }
}