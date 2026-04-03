import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'announcement_admin_page.dart';
import 'verify_admin_page.dart';
import 'users_admin_page.dart';
import 'report_admin_page.dart';       // ← เพิ่ม import หน้า report
import 'chat_list_admin_page.dart';   // ← เพิ่ม import หน้า chat

// ─────────────────────────────────────────────
// DATA MODELS
// ─────────────────────────────────────────────

class _StatCardData {
  final String title;
  final String value;
  final String subtitle;
  final String badge;
  final IconData subtitleIcon;

  const _StatCardData({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.badge,
    required this.subtitleIcon,
  });
}

class _ActivityItem {
  final String title;
  final String subtitle;
  final Color iconBgColor;
  final IconData icon;

  const _ActivityItem({
    required this.title,
    required this.subtitle,
    required this.iconBgColor,
    required this.icon,
  });
}

// ─────────────────────────────────────────────
// DASHBOARD ADMIN PAGE
// ─────────────────────────────────────────────

class DashboardAdminPage extends StatefulWidget {
  const DashboardAdminPage({super.key});

  @override
  State<DashboardAdminPage> createState() => _DashboardAdminPageState();
}

class _DashboardAdminPageState extends State<DashboardAdminPage> {
  int _selectedIndex = 0;

  static const Color _green = Color(0xFF00C853);

  final List<_StatCardData> _stats = const [
    _StatCardData(
      title: 'ผู้ใช้งานทั้งหมด',
      value: '12,450',
      subtitle: 'เพิ่มขึ้น 1,240 รายจากเดือนที่แล้ว',
      badge: '+12%',
      subtitleIcon: Icons.group_outlined,
    ),
    _StatCardData(
      title: 'งานที่เปิดอยู่',
      value: '856',
      subtitle: 'งานใหม่ 42 รายการวันนี้',
      badge: '+5%',
      subtitleIcon: Icons.work_outline,
    ),
    _StatCardData(
      title: 'รายได้รวม',
      value: '฿450,000',
      subtitle: 'ค่าธรรมเนียมจากธุรกรรม 2,410 รายการ',
      badge: '+8%',
      subtitleIcon: Icons.receipt_long_outlined,
    ),
  ];

  final List<Map<String, dynamic>> _quickActions = const [
    {'label': 'อนุมัติงาน',    'icon': Icons.fact_check_outlined},
    {'label': 'ยืนยันตัวตน',   'icon': Icons.verified_user_outlined},
    {'label': 'ส่งประกาศ',     'icon': Icons.campaign_outlined},
    {'label': 'ดูรายงาน',      'icon': Icons.info_outline},
  ];

  final List<_ActivityItem> _activities = const [
    _ActivityItem(
      title: 'สมชาย วิรุฬ สมัครสมาชิกใหม่',
      subtitle: '2 นาทีที่แล้ว',
      iconBgColor: Color(0xFFE3F2FD),
      icon: Icons.person_add_outlined,
    ),
    _ActivityItem(
      title: 'บริษัท ก้าวหน้า จำกัด ลงประกาศงานใหม่',
      subtitle: '15 นาทีที่แล้ว',
      iconBgColor: Color(0xFFE8F5E9),
      icon: Icons.work_outline,
    ),
    _ActivityItem(
      title: 'ไวไล รัตนา ชำระค่าบริการ ฿1,200',
      subtitle: '45 นาทีที่แล้ว',
      iconBgColor: Color(0xFFFFF9C4),
      icon: Icons.account_balance_wallet_outlined,
    ),
    _ActivityItem(
      title: 'มีผู้รายงานโพสต์งาน "รับสมัครงานกราฟิก"',
      subtitle: '1 ชั่วโมงที่แล้ว',
      iconBgColor: Color(0xFFFFEBEE),
      icon: Icons.warning_amber_rounded,
    ),
  ];

  // ─────────────────────────────────────────────
  // BOTTOM NAV ROUTING
  // ─────────────────────────────────────────────

  void _onNavTap(int index) {
    if (index == _selectedIndex) return;
    switch (index) {
      case 1: // ตรวจสอบ
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const VerifyPage()));
        break;
      case 2: // ผู้ใช้
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const UsersPage()));
        break;
      case 3: // แชท ← เชื่อมแล้ว
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const ChatListPage()));
        break;
      default:
        setState(() => _selectedIndex = index);
    }
  }

  // ─────────────────────────────────────────────
  // QUICK ACTION ROUTING
  // ─────────────────────────────────────────────

  void _onQuickActionTap(int index) {
    switch (index) {
      case 0: // อนุมัติงาน → VerifyPage
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const VerifyPage()));
        break;
      case 1: // ยืนยันตัวตน → UsersPage
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const UsersPage()));
        break;
      case 2: // ส่งประกาศ → AnnouncementPage
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const AnnouncementPage()));
        break;
      case 3: // ดูรายงาน → ReportPage ← เชื่อมแล้ว
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const ReportPage()));
        break;
    }
  }

  // ─────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ..._stats.map((s) => _buildStatCard(s)),
                    const SizedBox(height: 8),
                    _buildSectionHeader(
                        icon: Icons.bolt, title: 'จัดการด่วน'),
                    const SizedBox(height: 12),
                    _buildQuickActions(),
                    const SizedBox(height: 20),
                    _buildSectionHeader(
                      icon: Icons.history,
                      title: 'กิจกรรมล่าสุด',
                      trailing: TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ReportPage()),
                        ),
                        child: const Text(
                          'ดูทั้งหมด',
                          style: TextStyle(
                              color: _green,
                              fontWeight: FontWeight.w600,
                              fontSize: 13),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ..._activities.map((a) => _buildActivityTile(a)),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ─────────────────────────────────────────────
  // WIDGETS
  // ─────────────────────────────────────────────

  Widget _buildAppBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
                color: _green,
                borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.grid_view_rounded,
                color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          const Text(
            'แผงควบคุมระบบ',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E)),
          ),
          const Spacer(),
          const CircleAvatar(
            radius: 19,
            backgroundColor: Color(0xFFE0E0E0),
            child: Icon(Icons.person, color: Colors.grey, size: 22),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
      {required IconData icon,
      required String title,
      Widget? trailing}) {
    return Row(
      children: [
        Icon(icon, color: _green, size: 22),
        const SizedBox(width: 6),
        Text(title,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E))),
        const Spacer(),
        if (trailing != null) trailing,
      ],
    );
  }

  Widget _buildStatCard(_StatCardData data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(data.title,
                  style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF757575),
                      fontWeight: FontWeight.w500)),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(20)),
                child: Text(data.badge,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: _green)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(data.value,
              style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E))),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(data.subtitleIcon,
                  size: 15, color: const Color(0xFF9E9E9E)),
              const SizedBox(width: 4),
              Expanded(
                child: Text(data.subtitle,
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF9E9E9E)),
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _quickActions.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.6,
      ),
      itemBuilder: (context, i) {
        final action = _quickActions[i];
        return GestureDetector(
          onTap: () => _onQuickActionTap(i),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2))
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(12)),
                  child: Icon(action['icon'] as IconData,
                      color: _green, size: 24),
                ),
                const SizedBox(height: 8),
                Text(action['label'] as String,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A2E))),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActivityTile(_ActivityItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
                color: item.iconBgColor,
                borderRadius: BorderRadius.circular(12)),
            child: Icon(item.icon,
                size: 22,
                color: item.iconBgColor.computeLuminance() > 0.6
                    ? Colors.blueGrey.shade700
                    : Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A2E))),
                const SizedBox(height: 2),
                Text(item.subtitle,
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF9E9E9E))),
              ],
            ),
          ),
          const Icon(Icons.chevron_right,
              color: Color(0xFFBDBDBD), size: 20),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onNavTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: _green,
      unselectedItemColor: const Color(0xFF9E9E9E),
      backgroundColor: Colors.white,
      elevation: 8,
      selectedLabelStyle:
          const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
      unselectedLabelStyle: const TextStyle(fontSize: 12),
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded), label: 'แดชบอร์ด'),
        BottomNavigationBarItem(
            icon: Icon(Icons.shield_outlined), label: 'ตรวจสอบ'),
        BottomNavigationBarItem(
            icon: Icon(Icons.group_outlined), label: 'ผู้ใช้'),
        BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline), label: 'แชท'),
      ],
    );
  }
}