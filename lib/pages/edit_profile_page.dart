import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/profile_api_service.dart';
import '../services/auth_service.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _picker = ImagePicker();

  final nameController  = TextEditingController();
  final titleController = TextEditingController();
  final aboutController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  bool _isLoading  = true;
  bool _isSaving   = false;
  bool _didInit    = false; // ✅ guard กัน didChangeDependencies เรียกซ้ำ

  late int userId;
  UserProfile? _profile;

  Uint8List? _imageBytes;
  String?    _imageName;

  final List<String> _availableSkills = [
    'การเดินสายไฟ', 'การติดโคมไฟ', 'การซ่อมระบบไฟ', 'สมาร์ทโฮม',
    'การติดตั้งเต้ารับ', 'การติดตั้งสวิตช์', 'เครื่องปรับอากาศ',
    'งานซ่อมบำรุง', 'ระบบรักษาความปลอดภัย', 'ติดตั้งกล้องวงจรปิด',
  ];
  List<String> _selectedSkills = [];

  // ✅ ใช้ didChangeDependencies ครั้งแรกเท่านั้น
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didInit) return;
    _didInit = true;
    _resolveUserIdAndFetchProfile();
  }

  @override
  void dispose() {
    nameController.dispose();
    titleController.dispose();
    aboutController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> _resolveUserIdAndFetchProfile() async {
    final routeUserId = ModalRoute.of(context)?.settings.arguments as int?;
    userId = routeUserId ?? await AuthService.getCurrentUserId();
    await _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    setState(() => _isLoading = true);
    try {
      final p = await ProfileApiService.getProfile(userId);
      if (!mounted) return;
      setState(() {
        _profile             = p;
        nameController.text  = p.fullName;
        titleController.text = p.jobTitle ?? '';
        aboutController.text = p.bio ?? '';
        phoneController.text = p.phone ?? '';
        emailController.text = p.email;
        _selectedSkills      = List<String>.from(p.skills);
        _isLoading           = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showSnack('โหลดข้อมูลไม่สำเร็จ: $e', isError: true);
    }
  }

  // ─── Image picker ─────────────────────────────

  // ✅ เปลี่ยนเป็น async + await เพื่อให้ bottom sheet ปิดก่อนเปิด picker
  Future<void> _showImageSourceSelector() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const SizedBox(height: 8),
            const Text('เลือกรูปภาพ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('ถ่ายรูป'),
              // ✅ return ImageSource แทน pop + call async
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('เลือกรูปจากอัลบั้ม'),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
          ]),
        ),
      ),
    );

    // ✅ เปิด picker หลัง bottom sheet ปิดสนิทแล้ว
    if (source != null && mounted) {
      await _pickImage(source);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final file = await _picker.pickImage(
        source:       source,
        maxWidth:     800,
        maxHeight:    800,
        imageQuality: 85,
      );
      if (file == null) return;

      final bytes = await file.readAsBytes();
      if (!mounted) return;

      setState(() {
        _imageBytes = bytes;
        _imageName  = file.name;
      });
    } catch (e) {
      if (!mounted) return;
      _showSnack('เลือกรูปไม่สำเร็จ: $e', isError: true);
    }
  }

  // ─── Skill selector ───────────────────────────

  // ✅ ใช้ _SkillSelectorDialog ที่เป็น StatefulWidget แยก
  Future<void> _showSkillSelector() async {
    final result = await showDialog<List<String>>(
      context: context,
      // barrierDismissible: false เพื่อกันปิด dialog โดยบังเอิญ
      barrierDismissible: false,
      builder: (dialogContext) => _SkillSelectorDialog(
        available: _availableSkills,
        selected:  List<String>.from(_selectedSkills),
      ),
    );
    // result == null → กด ยกเลิก → ไม่ต้อง update
    if (result != null && mounted) {
      setState(() => _selectedSkills = result);
    }
  }

  void _removeSkill(String s) => setState(() => _selectedSkills.remove(s));

  // ─── Save ─────────────────────────────────────

  Future<void> _save() async {
    if (_profile == null) return;

    // ✅ validate เบื้องต้น
    final name = nameController.text.trim();
    if (name.isEmpty) {
      _showSnack('กรุณากรอกชื่อ-นามสกุล', isError: true);
      return;
    }

    setState(() => _isSaving = true);
    try {
      await ProfileApiService.updateProfile(
        userId:               userId,
        fullName:             name,
        email:                emailController.text.trim(),
        phone:                phoneController.text.trim(),
        bio:                  aboutController.text.trim(),
        jobTitle:             titleController.text.trim(),
        skills:               _selectedSkills,
        profileImageBytes:    _imageBytes,
        profileImageFileName: _imageName,
      );
      if (!mounted) return;
      _showSnack('บันทึกข้อมูลสำเร็จ ✓');
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      _showSnack('บันทึกไม่สำเร็จ: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _confirmCancel() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('ยืนยันการยกเลิก'),
        content: const Text('ข้อมูลที่แก้ไขไว้จะไม่ถูกบันทึก'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('กลับไปแก้ไขต่อ'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('ยืนยันการยกเลิก',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (ok == true && mounted) Navigator.pop(context);
  }

  void _showSnack(String msg, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: isError ? Colors.red : Colors.green,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(12),
    ));
  }

  ImageProvider _avatarProvider() {
    if (_imageBytes != null) return MemoryImage(_imageBytes!);
    final url = _profile?.profileImageUrl;
    if (url != null && url.isNotEmpty) return NetworkImage(url);
    return const AssetImage('assets/alex_rivera.jpg');
  }

  // ─────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: _confirmCancel,
        ),
        title: const Text('แก้ไขโปรไฟล์',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _save,
            child: _isSaving
                ? const SizedBox(
                    width: 18, height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('บันทึก',
                    style: TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 8),

            // ── Avatar ──────────────────────────
            Center(
              child: Column(children: [
                Stack(children: [
                  CircleAvatar(
                    radius: 46,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _avatarProvider(),
                    // ✅ แสดง checkmark ถ้าเลือกรูปใหม่แล้ว
                    child: _imageBytes != null
                        ? Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                  color: Colors.green, shape: BoxShape.circle),
                              child: const Icon(Icons.check,
                                  color: Colors.white, size: 14),
                            ),
                          )
                        : null,
                  ),
                  Positioned(
                    right: 0, bottom: 0,
                    child: GestureDetector(
                      onTap: _showImageSourceSelector,
                      child: Container(
                        width: 32, height: 32,
                        decoration: const BoxDecoration(
                            color: Colors.green, shape: BoxShape.circle),
                        child: const Icon(Icons.camera_alt,
                            color: Colors.white, size: 18),
                      ),
                    ),
                  ),
                ]),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _showImageSourceSelector,
                  child: const Text('เปลี่ยนรูปโปรไฟล์',
                      style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                          fontSize: 14)),
                ),
              ]),
            ),
            const SizedBox(height: 20),

            _sectionTitle('ข้อมูลส่วนตัว'),
            _field('ชื่อ-นามสกุล', nameController),
            _field('ตำแหน่ง/อาชีพ', titleController),
            _field('คำอธิบาย', aboutController, maxLines: 4),
            const SizedBox(height: 12),
            _buildSkillsSection(),

            const SizedBox(height: 20),
            _sectionTitle('ข้อมูลการติดต่อ'),
            _field('เบอร์โทรศัพท์', phoneController),
            _field('อีเมล', emailController),

            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _confirmCancel,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Color(0xFFFFCACA)),
                  backgroundColor: const Color(0xFFFFF5F5),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('ยกเลิกการปรับปรุงโปรไฟล์',
                    style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String t) => Align(
    alignment: Alignment.centerLeft,
    child: Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(t,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
    ),
  );

  Widget _field(String label, TextEditingController ctrl, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: ctrl,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: const Color(0xFFF2F4F7),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.green)),
        ),
      ),
    );
  }

  Widget _buildSkillsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Text('ทักษะและความเชี่ยวชาญ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const Spacer(),
          // ✅ ใช้ GestureDetector + async call ตรงๆ
          GestureDetector(
            onTap: _showSkillSelector,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFEFFAF1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFD7F5DF)),
              ),
              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.add, color: Colors.green, size: 16),
                SizedBox(width: 4),
                Text('เพิ่ม',
                    style: TextStyle(
                        color: Colors.green, fontWeight: FontWeight.w600)),
              ]),
            ),
          ),
        ]),
        const SizedBox(height: 10),
        if (_selectedSkills.isEmpty)
          const Text('ยังไม่มีทักษะ กด "เพิ่ม" เพื่อเลือก',
              style: TextStyle(color: Colors.grey, fontSize: 13))
        else
          Wrap(
            spacing: 8, runSpacing: 8,
            children: _selectedSkills.map((s) => Chip(
              label: Text(s, style: const TextStyle(fontSize: 13)),
              deleteIcon: const Icon(Icons.close, size: 16),
              onDeleted: () => _removeSkill(s),
              backgroundColor: const Color(0xFFEFFAF1),
              padding: const EdgeInsets.symmetric(horizontal: 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Color(0xFFD7F5DF)),
              ),
            )).toList(),
          ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────
// SKILL SELECTOR DIALOG
// StatefulWidget แยกต่างหาก → setState ของ chip
// ทำงานทันที ไม่ต้องพึ่ง StatefulBuilder
// ─────────────────────────────────────────────

class _SkillSelectorDialog extends StatefulWidget {
  final List<String> available;
  final List<String> selected;

  const _SkillSelectorDialog({
    required this.available,
    required this.selected,
  });

  @override
  State<_SkillSelectorDialog> createState() => _SkillSelectorDialogState();
}

class _SkillSelectorDialogState extends State<_SkillSelectorDialog> {
  late List<String> _temp;

  @override
  void initState() {
    super.initState();
    // ✅ copy เพื่อไม่ให้กระทบ list เดิมระหว่าง dialog ยังเปิดอยู่
    _temp = List<String>.from(widget.selected);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('เลือกทักษะและความเชี่ยวชาญ',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Wrap(
            spacing: 8, runSpacing: 8,
            children: widget.available.map((skill) {
              final isSelected = _temp.contains(skill);
              return FilterChip(
                label: Text(skill),
                selected: isSelected,
                selectedColor: const Color(0xFFEFFAF1),
                checkmarkColor: Colors.green,
                side: BorderSide(
                  color: isSelected
                      ? Colors.green
                      : const Color(0xFFE5E7EB),
                ),
                // ✅ setState ของ dialog widget เอง → rebuild chip ทันที
                onSelected: (val) {
                  setState(() {
                    if (val) {
                      if (!_temp.contains(skill)) _temp.add(skill);
                    } else {
                      _temp.remove(skill);
                    }
                  });
                },
              );
            }).toList(),
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: [
        Row(children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context, null), // ยกเลิก → null
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('ยกเลิก'),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              // ✅ ส่ง _temp กลับ → EditProfilePage รับ result แล้ว setState
              onPressed: () => Navigator.pop(context, List<String>.from(_temp)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('ยืนยัน',
                  style: TextStyle(color: Colors.white,
                      fontWeight: FontWeight.w600)),
            ),
          ),
        ]),
      ],
    );
  }
}