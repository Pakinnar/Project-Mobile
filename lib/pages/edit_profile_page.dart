import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/profile_api_service.dart';

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

  bool _isLoading = true;
  bool _isSaving  = false;

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userId = (ModalRoute.of(context)?.settings.arguments as int?) ?? 3;
    _fetchProfile();
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

  Future<void> _fetchProfile() async {
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

  void _showImageSourceSelector() {
    showModalBottomSheet(
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
              onTap: () { Navigator.pop(ctx); _pickImage(ImageSource.camera); },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('เลือกรูปจากอัลบั้ม'),
              onTap: () { Navigator.pop(ctx); _pickImage(ImageSource.gallery); },
            ),
          ]),
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final file = await _picker.pickImage(
          source: source, maxWidth: 800, maxHeight: 800, imageQuality: 85);
      if (file == null) return;
      final bytes = await file.readAsBytes();
      if (!mounted) return;
      setState(() { _imageBytes = bytes; _imageName = file.name; });
    } catch (e) {
      _showSnack('เลือกรูปไม่สำเร็จ: $e', isError: true);
    }
  }

  // ─── Skill selector ───────────────────────────
  // ✅ ใช้ _SkillSelectorDialog (StatefulWidget แยก) → setState ของ chip ทำงานทันที

  Future<void> _showSkillSelector() async {
    final result = await showDialog<List<String>>(
      context: context,
      builder: (_) => _SkillSelectorDialog(
        available: _availableSkills,
        selected:  List<String>.from(_selectedSkills),
      ),
    );
    if (result != null && mounted) setState(() => _selectedSkills = result);
  }

  void _removeSkill(String s) => setState(() => _selectedSkills.remove(s));

  // ─── Save ─────────────────────────────────────

  Future<void> _save() async {
    if (_profile == null) return;
    setState(() => _isSaving = true);
    try {
      await ProfileApiService.updateProfile(
        userId:               userId,
        fullName:             nameController.text.trim(),
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
      _showSnack('บันทึกไม่สำเร็จ: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _confirmCancel() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('ยืนยันการยกเลิก'),
        content: const Text('ข้อมูลที่แก้ไขไว้จะไม่ถูกบันทึก'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('กลับไปแก้ไขต่อ')),
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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: isError ? Colors.red : Colors.green,
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
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
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
                ? const SizedBox(width: 18, height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('บันทึก',
                    style: TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const SizedBox(height: 8),

          // ── Avatar ──
          Center(child: Column(children: [
            Stack(children: [
              CircleAvatar(
                  radius: 46,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: _avatarProvider()),
              Positioned(
                right: 0, bottom: 0,
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.green, shape: BoxShape.circle),
                  child: IconButton(
                    onPressed: _showImageSourceSelector,
                    icon: const Icon(Icons.camera_alt,
                        color: Colors.white, size: 18),
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _showImageSourceSelector,
              child: const Text('เปลี่ยนรูปโปรไฟล์',
                  style: TextStyle(color: Colors.black87)),
            ),
          ])),
          const SizedBox(height: 16),

          _sectionTitle('ข้อมูลส่วนตัว'),
          _field('ชื่อ-นามสกุล', nameController),
          _field('ตำแหน่ง/อาชีพ', titleController),
          _field('คำอธิบาย', aboutController, maxLines: 4),
          const SizedBox(height: 8),
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
        ]),
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
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        const Text('ทักษะและความเชี่ยวชาญ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const Spacer(),
        InkWell(
          onTap: _showSkillSelector,
          borderRadius: BorderRadius.circular(8),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: Row(children: [
              Icon(Icons.add, color: Colors.green, size: 18),
              SizedBox(width: 4),
              Text('เพิ่ม', style: TextStyle(color: Colors.green)),
            ]),
          ),
        ),
      ]),
      const SizedBox(height: 8),
      if (_selectedSkills.isEmpty)
        const Text('ยังไม่มีทักษะ กด "เพิ่ม" เพื่อเลือก',
            style: TextStyle(color: Colors.grey, fontSize: 13))
      else
        Wrap(
          spacing: 8, runSpacing: 8,
          children: _selectedSkills.map((s) => Chip(
            label: Text(s),
            deleteIcon: const Icon(Icons.close, size: 18),
            onDeleted: () => _removeSkill(s),
            backgroundColor: const Color(0xFFEFFAF1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: Color(0xFFD7F5DF)),
            ),
          )).toList(),
        ),
    ]);
  }
}

// ─────────────────────────────────────────────
// SKILL SELECTOR DIALOG
// แยกเป็น StatefulWidget → setState ของ chip
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
                    color: isSelected ? Colors.green : const Color(0xFFE5E7EB)),
                // ✅ setState ของ widget นี้เอง → rebuild chip ทันที
                onSelected: (val) => setState(() {
                  if (val) { if (!_temp.contains(skill)) _temp.add(skill); }
                  else { _temp.remove(skill); }
                }),
              );
            }).toList(),
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: [Row(children: [
        Expanded(child: OutlinedButton(
          onPressed: () => Navigator.pop(context, null), // ยกเลิก
          child: const Text('ยกเลิก'),
        )),
        const SizedBox(width: 10),
        Expanded(child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          onPressed: () => Navigator.pop(context, _temp), // ✅ ส่ง list กลับ
          child: const Text('ยืนยัน', style: TextStyle(color: Colors.white)),
        )),
      ])],
    );
  }
}