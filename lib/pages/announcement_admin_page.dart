import 'package:flutter/material.dart';
import '../services/announcement_service.dart';
import 'dashboard_admin_page.dart';
import 'verify_admin_page.dart';

class AnnouncementPage extends StatefulWidget {
  const AnnouncementPage({super.key});

  @override
  State<AnnouncementPage> createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {
  static const Color _green = Color(0xFF00C853);

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  int _selectedTarget = 0; // 0=ทั้งหมด, 1=Freelancers, 2=Employers

  final List<Map<String, String>> _targets = const [
    {'label': 'ทั้งหมด', 'sub': 'ส่งถึงผู้ใช้ GigFindr ทุกคน'},
    {
      'label': 'เฉพาะผู้รับงาน (Freelancers)',
      'sub': 'ส่งถึงผู้ที่ลงทะเบียนรับงานเท่านั้น',
    },
    {
      'label': 'เฉพาะผู้จ้างงาน (Employers)',
      'sub': 'ส่งถึงผู้ที่ลงทะเบียนจ้างงานเท่านั้น',
    },
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle('รายละเอียดประกาศ'),
                    const SizedBox(height: 14),

                    // Image Upload
                    _buildLabel('รูปภาพหน้าปกประกาศ'),
                    const SizedBox(height: 8),
                    _buildImageUpload(),
                    const SizedBox(height: 16),

                    // Title Field
                    _buildLabel('หัวข้อประกาศ'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _titleController,
                      hint: 'ระบุหัวข้อประกาศ',
                      maxLines: 1,
                    ),
                    const SizedBox(height: 16),

                    // Content Field
                    _buildLabel('เนื้อหาประกาศ'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _contentController,
                      hint: 'พิมพ์ข้อความที่คุณต้องการประกาศ...',
                      maxLines: 6,
                    ),
                    const SizedBox(height: 28),

                    // Target Group
                    _sectionTitle('กลุ่มเป้าหมาย'),
                    const SizedBox(height: 14),
                    ..._targets.asMap().entries.map(
                      (e) => _buildTargetOption(index: e.key, data: e.value),
                    ),
                    const SizedBox(height: 32),

                    // Buttons
                    _buildActionButtons(context),
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
  // APP BAR
  // ─────────────────────────────────────────────

  Widget _buildAppBar(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A2E)),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Text(
              'ส่งประกาศ',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
              ),
            ),
          ),
          const SizedBox(width: 48), // balance back button
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // SECTION TITLE
  // ─────────────────────────────────────────────

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: Color(0xFF1A1A2E),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Color(0xFF1A1A2E),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // IMAGE UPLOAD BOX
  // ─────────────────────────────────────────────

  Widget _buildImageUpload() {
    return GestureDetector(
      onTap: () {
        // TODO: implement image picker
      },
      child: Container(
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFCCCCCC),
            width: 1.5,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.image_outlined,
                size: 30,
                color: Color(0xFF9E9E9E),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'คลิกเพื่ออัปโหลดรูปภาพ',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF555555),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              '1200×600 px',
              style: TextStyle(fontSize: 12, color: Color(0xFF9E9E9E)),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // TEXT FIELD
  // ─────────────────────────────────────────────

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required int maxLines,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A2E)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 14, color: Color(0xFFBDBDBD)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _green, width: 1.5),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // TARGET GROUP OPTION
  // ─────────────────────────────────────────────

  Widget _buildTargetOption({
    required int index,
    required Map<String, String> data,
  }) {
    final bool selected = _selectedTarget == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTarget = index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? _green : const Color(0xFFE0E0E0),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? _green : const Color(0xFFBDBDBD),
                  width: 2,
                ),
                color: selected ? _green : Colors.transparent,
              ),
              child: selected
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['label']!,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: selected ? _green : const Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  data['sub']!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9E9E9E),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // ACTION BUTTONS
  // ─────────────────────────────────────────────

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        // ยกเลิก
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: const Center(
                child: Text(
                  'ยกเลิก',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // ส่งประกาศ
        Expanded(
          flex: 2,
          child: GestureDetector(
            onTap: _handleSend,
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: _green,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Center(
                child: Text(
                  'ส่งประกาศ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleSend() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('กรุณากรอกหัวข้อและเนื้อหาประกาศ'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    String targetGroup;
    switch (_selectedTarget) {
      case 1:
        targetGroup = 'freelancers';
        break;
      case 2:
        targetGroup = 'employers';
        break;
      default:
        targetGroup = 'all';
    }

    try {
      await AnnouncementService.createAnnouncement(
        title: title,
        content: content,
        targetGroup: targetGroup,
        imageUrl: null,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ส่งประกาศเรียบร้อยแล้ว'),
          backgroundColor: Color(0xFF00C853),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  // ─────────────────────────────────────────────
  // BOTTOM NAV
  // ─────────────────────────────────────────────

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: 0,
      onTap: (_) {},
      type: BottomNavigationBarType.fixed,
      selectedItemColor: _green,
      unselectedItemColor: const Color(0xFF9E9E9E),
      backgroundColor: Colors.white,
      elevation: 8,
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
      unselectedLabelStyle: const TextStyle(fontSize: 12),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.grid_view_rounded),
          label: 'แดชบอร์ด',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shield_outlined),
          label: 'ตรวจสอบ',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.group_outlined),
          label: 'ผู้ใช้',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          label: 'แชท',
        ),
      ],
    );
  }
}
