import 'package:flutter/material.dart';
import '../services/auth_service.dart';

// ─────────────────────────────────────────────
// DATA MODELS
// ─────────────────────────────────────────────

enum ReportStatus { newReport, inProgress, resolved }

class ReportItem {
  final String id;
  final String reporterName;
  final String? thumbnailUrl;
  final String dateTime;
  final String jobTitle;
  final String jobId;
  final String reason;
  final ReportStatus status;

  const ReportItem({
    required this.id,
    required this.reporterName,
    this.thumbnailUrl,
    required this.dateTime,
    required this.jobTitle,
    required this.jobId,
    required this.reason,
    required this.status,
  });
}

// ─────────────────────────────────────────────
// REPORT PAGE
// ─────────────────────────────────────────────

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage>
    with SingleTickerProviderStateMixin {
  static const Color _green = Color(0xFF00C853);
  static const Color _darkNavy = Color(0xFF1A1A2E);
  static const Color _orange = Color(0xFFE65100);

  late TabController _tabController;

  final List<ReportItem> _reports = const [
    ReportItem(
      id: '1',
      reporterName: 'สมชาย เข็มกลัด',
      dateTime: '12 ต.ค. 2023, 14:30 น.',
      jobTitle: 'ซ่อมเครื่องปรับอากาศ',
      jobId: '#4421',
      reason: 'งานซ่อมไม่เรียบร้อย',
      status: ReportStatus.newReport,
    ),
    ReportItem(
      id: '2',
      reporterName: 'นภาพร ฟ้าใส',
      dateTime: '10 ต.ค. 2023, 09:15 น.',
      jobTitle: 'ทาสีบ้าน',
      jobId: '#4198',
      reason: 'ผู้รับงานไม่มาตามนัด',
      status: ReportStatus.inProgress,
    ),
    ReportItem(
      id: '3',
      reporterName: 'วิชัย รัตนวงศ์',
      dateTime: '8 ต.ค. 2023, 16:00 น.',
      jobTitle: 'ติดตั้งกล้องวงจรปิด',
      jobId: '#4075',
      reason: 'ชำระเงินแล้วแต่งานไม่เสร็จ',
      status: ReportStatus.resolved,
    ),
    ReportItem(
      id: '4',
      reporterName: 'กัญญา จิตดี',
      dateTime: '5 ต.ค. 2023, 11:30 น.',
      jobTitle: 'รับสมัครงานกราฟิก',
      jobId: '#3990',
      reason: 'ข้อมูลงานไม่ตรงกับความเป็นจริง',
      status: ReportStatus.newReport,
    ),
  ];

  List<ReportItem> _getByStatus(ReportStatus? status) {
    if (status == null) return _reports;
    return _reports.where((r) => r.status == status).toList();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildReportList(_getByStatus(ReportStatus.newReport)),
                  _buildReportList(_getByStatus(ReportStatus.inProgress)),
                  _buildReportList(_getByStatus(ReportStatus.resolved)),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ─────────────────────────────────────────────
  // APP BAR
  // ─────────────────────────────────────────────

  Widget _buildAppBar(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back,
                size: 24, color: _darkNavy),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'ดูรายงาน',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: _darkNavy,
                ),
              ),
            ),
          ),
          // Filter button
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FA),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: const Icon(Icons.tune_rounded,
                  size: 18, color: Color(0xFF555555)),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // TAB BAR
  // ─────────────────────────────────────────────

  Widget _buildTabBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TabBar(
          controller: _tabController,
          labelColor: _green,
          unselectedLabelColor: const Color(0xFF9E9E9E),
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          indicatorColor: _green,
          indicatorWeight: 3,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: [
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('ใหม่'),
                  const SizedBox(width: 6),
                  _tabBadge(
                      _getByStatus(ReportStatus.newReport).length,
                      _green),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('กำลังดำเนินการ'),
                  const SizedBox(width: 6),
                  _tabBadge(
                      _getByStatus(ReportStatus.inProgress).length,
                      const Color(0xFFF57C00)),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('เสร็จสิ้น'),
                  const SizedBox(width: 6),
                  _tabBadge(
                      _getByStatus(ReportStatus.resolved).length,
                      const Color(0xFF757575)),
                ],
              ),
            ),
          ],
        ),
        const Divider(height: 1, color: Color(0xFFF0F0F0)),
      ],
    );
  }

  Widget _tabBadge(int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$count',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // REPORT LIST
  // ─────────────────────────────────────────────

  Widget _buildReportList(List<ReportItem> items) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined,
                size: 56, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            const Text(
              'ไม่มีรายงานในขณะนี้',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF9E9E9E),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      itemCount: items.length,
      itemBuilder: (_, i) => _buildReportCard(items[i]),
    );
  }

  // ─────────────────────────────────────────────
  // REPORT CARD
  // ─────────────────────────────────────────────

  Widget _buildReportCard(ReportItem report) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header row ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail / Avatar
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                ),
                child: report.thumbnailUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(report.thumbnailUrl!,
                            fit: BoxFit.cover))
                    : const Icon(Icons.image_outlined,
                        size: 28, color: Color(0xFFBDBDBD)),
              ),
              const SizedBox(width: 12),
              // Name + date + badge
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            report.reporterName,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: _darkNavy,
                            ),
                          ),
                        ),
                        _buildStatusBadge(report.status),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      report.dateTime,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9E9E9E),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ── Job title ──
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 13, color: _darkNavy),
              children: [
                const TextSpan(
                  text: 'รายงาน: ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text: '${report.jobTitle} (Job ID: ${report.jobId})',
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),

          // ── Reason ──
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 13),
              children: [
                const TextSpan(
                  text: 'เหตุผล: ',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: _orange,
                  ),
                ),
                TextSpan(
                  text: report.reason,
                  style: const TextStyle(color: _orange),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // ── Action buttons ──
          Row(
            children: [
              // ดูรายละเอียด
              Expanded(
                child: GestureDetector(
                  onTap: () => _showReportDetail(report),
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border:
                          Border.all(color: const Color(0xFFDDDDDD)),
                    ),
                    child: const Center(
                      child: Text(
                        'ดูรายละเอียด',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _darkNavy,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // จัดการ
              Expanded(
                child: GestureDetector(
                  onTap: () => _handleReport(report),
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                      color: _orange,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: _orange.withOpacity(0.35),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'จัดการ',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // STATUS BADGE
  // ─────────────────────────────────────────────

  Widget _buildStatusBadge(ReportStatus status) {
    late String label;
    late Color bg;
    late Color dot;
    late Color textColor;

    switch (status) {
      case ReportStatus.newReport:
        label = 'ใหม่';
        bg = const Color(0xFFE8F5E9);
        dot = _green;
        textColor = const Color(0xFF2E7D32);
        break;
      case ReportStatus.inProgress:
        label = 'ดำเนินการ';
        bg = const Color(0xFFFFF3E0);
        dot = const Color(0xFFF57C00);
        textColor = const Color(0xFFE65100);
        break;
      case ReportStatus.resolved:
        label = 'เสร็จสิ้น';
        bg = const Color(0xFFF5F5F5);
        dot = const Color(0xFF9E9E9E);
        textColor = const Color(0xFF757575);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // ACTIONS
  // ─────────────────────────────────────────────

  void _showReportDetail(ReportItem report) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.92,
        expand: false,
        builder: (_, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                'รายละเอียดรายงาน',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: _darkNavy,
                ),
              ),
              const SizedBox(height: 16),
              _detailRow('ผู้รายงาน', report.reporterName),
              _detailRow('วันที่รายงาน', report.dateTime),
              _detailRow(
                  'งาน', '${report.jobTitle} (${report.jobId})'),
              _detailRow('เหตุผล', report.reason),
              _detailRow(
                  'สถานะ',
                  report.status == ReportStatus.newReport
                      ? 'ใหม่'
                      : report.status == ReportStatus.inProgress
                          ? 'กำลังดำเนินการ'
                          : 'เสร็จสิ้น'),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _green,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('ปิด',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                  fontSize: 13, color: Color(0xFF9E9E9E)),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _darkNavy,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleReport(ReportItem report) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'จัดการรายงาน',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
        ),
        content: Text(
          'เลือกการดำเนินการสำหรับรายงานของ "${report.reporterName}"',
          style: const TextStyle(fontSize: 14, color: Color(0xFF555555)),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _dialogActionBtn(
                label: 'รับเรื่องและดำเนินการ',
                color: _orange,
                onTap: () {
                  Navigator.pop(context);
                  _showSnack('รับเรื่อง "${report.reporterName}" แล้ว',
                      _orange);
                },
              ),
              const SizedBox(height: 8),
              _dialogActionBtn(
                label: 'ปิดรายงาน (เสร็จสิ้น)',
                color: _green,
                onTap: () {
                  Navigator.pop(context);
                  _showSnack('ปิดรายงานของ "${report.reporterName}" แล้ว',
                      _green);
                },
              ),
              const SizedBox(height: 8),
              _dialogActionBtn(
                label: 'ยกเลิก',
                color: const Color(0xFF757575),
                outlined: true,
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dialogActionBtn({
    required String label,
    required Color color,
    required VoidCallback onTap,
    bool outlined = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: outlined ? Colors.white : color,
          borderRadius: BorderRadius.circular(12),
          border: outlined
              ? Border.all(color: const Color(0xFFE0E0E0))
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: outlined ? color : Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // BOTTOM NAV
  // ─────────────────────────────────────────────

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: 0, // แดชบอร์ด active (มาจาก dashboard)
      onTap: (_) {},
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