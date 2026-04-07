import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/dashboard_service.dart';
import 'announcement_admin_page.dart';
import 'verify_admin_page.dart';
import 'users_admin_page.dart';
import 'report_admin_page.dart';
import 'chat_list_admin_page.dart';
import 'logout_admin_page.dart';

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

class DashboardAdminPage extends StatefulWidget {
  const DashboardAdminPage({super.key});

  @override
  State<DashboardAdminPage> createState() => _DashboardAdminPageState();
}

class _DashboardAdminPageState extends State<DashboardAdminPage> {
  int _selectedIndex = 0;
  bool _isLoading = true;
  String? _errorMessage;

  static const Color _green = Color(0xFF00C853);

  List<_StatCardData> _stats = [];
  List<_ActivityItem> _activities = [];

  final List<Map<String, dynamic>> _quickActions = const [
    {'label': 'อนุมัติงาน', 'icon': Icons.fact_check_outlined},
    {'label': 'ยืนยันตัวตน', 'icon': Icons.verified_user_outlined},
    {'label': 'ส่งประกาศ', 'icon': Icons.campaign_outlined},
    {'label': 'ดูรายงาน', 'icon': Icons.info_outline},
  ];

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final statsData = await DashboardService.getStats();
      final activitiesData = await DashboardService.getActivities();

      setState(() {
        _stats = [
          _StatCardData(
            title: 'ผู้ใช้งานทั้งหมด',
            value: statsData['users']['total'].toString(),
            subtitle:
                'เพิ่มขึ้น ${statsData['users']['new_this_month']} รายจากเดือนที่แล้ว',
            badge: '+${statsData['users']['growth_percent']}%',
            subtitleIcon: Icons.group_outlined,
          ),
          _StatCardData(
            title: 'งานที่เปิดอยู่',
            value: statsData['jobs']['open'].toString(),
            subtitle: 'งานใหม่ ${statsData['jobs']['new_today']} รายการวันนี้',
            badge: '+5%',
            subtitleIcon: Icons.work_outline,
          ),
          _StatCardData(
            title: 'รายได้รวม',
            value: '฿${statsData['earnings']['total']}',
            subtitle:
                'ค่าธรรมเนียมจากธุรกรรม ${statsData['earnings']['transaction_count']} รายการ',
            badge: '+8%',
            subtitleIcon: Icons.receipt_long_outlined,
          ),
        ];

        _activities = activitiesData.map<_ActivityItem>((item) {
          return _ActivityItem(
            title: item['title'] ?? '',
            subtitle: item['subtitle'] ?? '',
            iconBgColor: _getIconBgColor(item['icon_type'] ?? 'info'),
            icon: _getIcon(item['icon_type'] ?? 'info'),
          );
        }).toList();

        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  Color _getIconBgColor(String type) {
    switch (type) {
      case 'person':
        return const Color(0xFFE3F2FD);
      case 'work':
        return const Color(0xFFE8F5E9);
      case 'payment':
        return const Color(0xFFFFF9C4);
      case 'warning':
        return const Color(0xFFFFEBEE);
      default:
        return const Color(0xFFF5F5F5);
    }
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'person':
        return Icons.person_add_outlined;
      case 'work':
        return Icons.work_outline;
      case 'payment':
        return Icons.account_balance_wallet_outlined;
      case 'warning':
        return Icons.warning_amber_rounded;
      default:
        return Icons.info_outline;
    }
  }

  void _onNavTap(int index) {
    if (index == _selectedIndex) return;
    switch (index) {
      case 1:
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const VerifyPage()));
        break;
      case 2:
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const UsersPage()));
        break;
      case 3:
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const ChatListPage()));
        break;
      default:
        setState(() => _selectedIndex = index);
    }
  }

  void _onQuickActionTap(int index) {
    switch (index) {
      case 0:
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const VerifyPage()));
        break;
      case 1:
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const UsersPage()));
        break;
      case 2:
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const AnnouncementPage()));
        break;
      case 3:
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const ReportPage()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: _green),
                    )
                  : _errorMessage != null
                      ? _buildError()
                      : RefreshIndicator(
                          color: _green,
                          onRefresh: _loadDashboard,
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
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
                                ..._activities
                                    .map((a) => _buildActivityTile(a)),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
                        ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 56, color: Colors.redAccent),
          const SizedBox(height: 14),
          Text(
            _errorMessage ?? 'เกิดข้อผิดพลาด',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _loadDashboard,
            icon: const Icon(Icons.refresh),
            label: const Text('ลองใหม่'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _green,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

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
                color: _green, borderRadius: BorderRadius.circular(8)),
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
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LogoutPage()),
            ),
            child: const CircleAvatar(
              radius: 19,
              backgroundColor: Color(0xFFE0E0E0),
              child: Icon(Icons.person, color: Colors.grey, size: 22),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
      {required IconData icon, required String title, Widget? trailing}) {
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
