import 'package:flutter/material.dart';
import '../services/auth_service.dart';

// ─────────────────────────────────────────────
// DATA MODELS
// ─────────────────────────────────────────────

enum VerifyTab { user, portfolio, job }

enum VerifyStatus { pending, approved, rejected }

class VerifyItem {
  final String id;
  final String badge; // PENDING
  final String timeAgo;
  final String name;
  final String description;
  final String? idNumber; // เลขบัตร
  final String? location;
  final String? salary;
  final List<String> tags;
  final String? imageUrl; // null = show placeholder
  final VerifyItemType type;
  VerifyStatus status;

  VerifyItem({
    required this.id,
    required this.badge,
    required this.timeAgo,
    required this.name,
    required this.description,
    this.idNumber,
    this.location,
    this.salary,
    this.tags = const [],
    this.imageUrl,
    required this.type,
    this.status = VerifyStatus.pending,
  });
}

enum VerifyItemType { person, portfolio, company }

// ─────────────────────────────────────────────
// VERIFY PAGE
// ─────────────────────────────────────────────

class VerifyPage extends StatefulWidget {
  const VerifyPage({super.key});

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage>
    with SingleTickerProviderStateMixin {
  static const Color _green = Color(0xFF00C853);
  static const Color _red = Color(0xFFE53935);

  late TabController _tabController;

  // ── Sample Data ──
  final List<VerifyItem> _userItems = [
    VerifyItem(
      id: '1',
      badge: 'PENDING',
      timeAgo: '2 ชม. ที่แล้ว',
      name: 'นายสมชาย เข็มกลัด',
      description: 'การตรวจสอบตัวตน (ID Verification)',
      idNumber: '1-10xx-xxxx-xx-x',
      type: VerifyItemType.person,
    ),
    VerifyItem(
      id: '2',
      badge: 'PENDING',
      timeAgo: '5 ชม. ที่แล้ว',
      name: 'นางสาววิไล พรหมสร',
      description: 'ตรวจสอบพอร์ตโฟลิโอ: กราฟิกดีไซน์',
      tags: ['Logo Design', 'Branding'],
      type: VerifyItemType.portfolio,
    ),
    VerifyItem(
      id: '3',
      badge: 'PENDING',
      timeAgo: '1 วันที่แล้ว',
      name: 'บริษัท เอบีซี จำกัด',
      description: 'ประกาศงาน: พนักงานธุรการชั่วคราว',
      location: 'กรุงเทพมหานคร',
      salary: '฿15,000 / เดือน',
      type: VerifyItemType.company,
    ),
  ];

  final List<VerifyItem> _portfolioItems = [
    VerifyItem(
      id: 'p1',
      badge: 'PENDING',
      timeAgo: '3 ชม. ที่แล้ว',
      name: 'นายกิตติพงษ์ มณีรัตน์',
      description: 'พอร์ตโฟลิโอ: Web Development',
      tags: ['React', 'Flutter', 'Node.js'],
      type: VerifyItemType.portfolio,
    ),
    VerifyItem(
      id: 'p2',
      badge: 'PENDING',
      timeAgo: '8 ชม. ที่แล้ว',
      name: 'นางสาวปวีณา สุขสมบูรณ์',
      description: 'พอร์ตโฟลิโอ: ถ่ายภาพสินค้า',
      tags: ['Photography', 'Editing'],
      type: VerifyItemType.portfolio,
    ),
  ];

  final List<VerifyItem> _jobItems = [
    VerifyItem(
      id: 'j1',
      badge: 'PENDING',
      timeAgo: '1 ชม. ที่แล้ว',
      name: 'บริษัท เทคสตาร์ท จำกัด',
      description: 'ประกาศงาน: นักพัฒนา Flutter',
      location: 'เชียงใหม่',
      salary: '฿40,000 / เดือน',
      type: VerifyItemType.company,
    ),
    VerifyItem(
      id: 'j2',
      badge: 'PENDING',
      timeAgo: '4 ชม. ที่แล้ว',
      name: 'ร้าน ครัวคุณแม่',
      description: 'ประกาศงาน: พ่อครัว / แม่ครัว',
      location: 'นนทบุรี',
      salary: '฿18,000 / เดือน',
      type: VerifyItemType.company,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<VerifyItem> get _currentItems {
    switch (_tabController.index) {
      case 0:
        return _userItems;
      case 1:
        return _portfolioItems;
      case 2:
        return _jobItems;
      default:
        return _userItems;
    }
  }

  int get _pendingCount => _currentItems
      .where((e) => e.status == VerifyStatus.pending)
      .length;

  // ─────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAppBar(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTabs(),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildTabContent(_userItems, 12),
                        _buildTabContent(_portfolioItems, 5),
                        _buildTabContent(_jobItems, 8),
                      ],
                    ),
                  ),
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

  Widget _buildAppBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.local_activity_outlined, color: _green, size: 22),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Local Job Hub Admin',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              Text(
                'ระบบจัดการข้อมูลหลังบ้าน',
                style: TextStyle(fontSize: 11, color: Color(0xFF9E9E9E)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // TABS
  // ─────────────────────────────────────────────

  Widget _buildTabs() {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: const Text(
              'ตรวจสอบข้อมูล',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A2E),
              ),
            ),
          ),
          TabBar(
            controller: _tabController,
            labelColor: _green,
            unselectedLabelColor: const Color(0xFF757575),
            indicatorColor: _green,
            indicatorWeight: 2.5,
            labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            tabs: const [
              Tab(text: 'ผู้ใช้งาน (12)'),
              Tab(text: 'พอร์ตโฟลิโอ (5)'),
              Tab(text: 'งาน (8)'),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // TAB CONTENT
  // ─────────────────────────────────────────────

  Widget _buildTabContent(List<VerifyItem> items, int totalCount) {
    final pending = items.where((e) => e.status == VerifyStatus.pending).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'รายการที่รอการตรวจสอบ',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF9C4),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'รอดำเนินการ ${pending.length} รายการ',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFF57F17),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...items.map((item) => _buildVerifyCard(item)),
          const SizedBox(height: 8),
          // Load more
          GestureDetector(
            onTap: () {},
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'ดูรายการเพิ่มเติม',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF555555),
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.keyboard_arrow_down, color: Color(0xFF555555), size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // VERIFY CARD
  // ─────────────────────────────────────────────

  Widget _buildVerifyCard(VerifyItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: badge + time + image
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badge + time
                    Row(
                      children: [
                        _buildPendingBadge(item.badge),
                        const SizedBox(width: 8),
                        const Icon(Icons.circle, size: 5, color: Color(0xFF9E9E9E)),
                        const SizedBox(width: 6),
                        Text(
                          item.timeAgo,
                          style: const TextStyle(fontSize: 12, color: Color(0xFF9E9E9E)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Name
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(height: 2),
                    // Description
                    Text(
                      item.description,
                      style: const TextStyle(fontSize: 13, color: Color(0xFF757575)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Thumbnail
              _buildThumbnail(item.type),
            ],
          ),

          const SizedBox(height: 10),

          // Extra info
          if (item.idNumber != null) ...[
            Row(
              children: [
                const Icon(Icons.badge_outlined, size: 16, color: Color(0xFF9E9E9E)),
                const SizedBox(width: 6),
                Text(
                  'เลขบัตร: ${item.idNumber}',
                  style: const TextStyle(fontSize: 13, color: Color(0xFF555555)),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],

          if (item.location != null) ...[
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 16, color: Color(0xFF9E9E9E)),
                const SizedBox(width: 4),
                Text(
                  item.location!,
                  style: const TextStyle(fontSize: 13, color: Color(0xFF555555)),
                ),
                if (item.salary != null) ...[
                  const SizedBox(width: 8),
                  Container(width: 1, height: 14, color: const Color(0xFFE0E0E0)),
                  const SizedBox(width: 8),
                  Text(
                    item.salary!,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E)),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
          ],

          if (item.tags.isNotEmpty) ...[
            Wrap(
              spacing: 6,
              children: item.tags
                  .map((tag) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFE0E0E0)),
                        ),
                        child: Text(
                          tag,
                          style: const TextStyle(fontSize: 12, color: Color(0xFF555555)),
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 10),
          ],

          // Action buttons
          Row(
            children: [
              // อนุมัติ
              Expanded(
                child: GestureDetector(
                  onTap: () => _handleApprove(item),
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                      color: _green,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
                        SizedBox(width: 6),
                        Text('อนุมัติ',
                            style: TextStyle(
                                color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // ปฏิเสธ
              Expanded(
                child: GestureDetector(
                  onTap: () => _handleReject(item),
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEBEE),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.cancel_outlined, color: _red, size: 18),
                        SizedBox(width: 6),
                        Text('ปฏิเสธ',
                            style: TextStyle(
                                color: _red, fontWeight: FontWeight.w700, fontSize: 14)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // View
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                  child: const Icon(Icons.remove_red_eye_outlined,
                      color: Color(0xFF757575), size: 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // THUMBNAIL
  // ─────────────────────────────────────────────

  Widget _buildThumbnail(VerifyItemType type) {
    IconData icon;
    Color bgColor;

    switch (type) {
      case VerifyItemType.person:
        icon = Icons.person;
        bgColor = const Color(0xFFE3F2FD);
        break;
      case VerifyItemType.portfolio:
        icon = Icons.image_outlined;
        bgColor = const Color(0xFFF3E5F5);
        break;
      case VerifyItemType.company:
        icon = Icons.business_outlined;
        bgColor = const Color(0xFFF5F5F5);
        break;
    }

    return Container(
      width: 72,
      height: 80,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: Colors.grey.shade500, size: 32),
    );
  }

  // ─────────────────────────────────────────────
  // PENDING BADGE
  // ─────────────────────────────────────────────

  Widget _buildPendingBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9C4),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Color(0xFFF57F17),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // ACTIONS
  // ─────────────────────────────────────────────

  void _handleApprove(VerifyItem item) {
    setState(() => item.status = VerifyStatus.approved);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('อนุมัติ "${item.name}" แล้ว'),
        backgroundColor: _green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleReject(VerifyItem item) {
    setState(() => item.status = VerifyStatus.rejected);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('ปฏิเสธ "${item.name}" แล้ว'),
        backgroundColor: _red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // BOTTOM NAV
  // ─────────────────────────────────────────────

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: 1, // ตรวจสอบ active
      onTap: (_) {},
      type: BottomNavigationBarType.fixed,
      selectedItemColor: _green,
      unselectedItemColor: const Color(0xFF9E9E9E),
      backgroundColor: Colors.white,
      elevation: 8,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
      unselectedLabelStyle: const TextStyle(fontSize: 12),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'แดชบอร์ด'),
        BottomNavigationBarItem(icon: Icon(Icons.shield_outlined), label: 'ตรวจสอบ'),
        BottomNavigationBarItem(icon: Icon(Icons.group_outlined), label: 'ผู้ใช้'),
        BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'แชท'),
      ],
    );
  }
}