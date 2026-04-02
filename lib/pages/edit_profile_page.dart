import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final ImagePicker _picker = ImagePicker();

  final TextEditingController nameController =
      TextEditingController(text: 'Alex Mitchell');
  final TextEditingController titleController =
      TextEditingController(text: 'ช่างไฟฟ้าผู้เชี่ยวชาญและช่างซ่อมทั่วไป');
  final TextEditingController aboutController = TextEditingController(
    text:
        'ช่างไฟที่ได้รับใบอนุญาต มีประสบการณ์กว่า 12 ปีในงานซ่อมไฟฟ้า งานเดินสายไฟ และงานซ่อมทั่วไปภายในบ้าน',
  );
  final TextEditingController phoneController =
      TextEditingController(text: '(555) 123-4567');
  final TextEditingController emailController =
      TextEditingController(text: 'alex.mitchell@servicepro.com');

  File? _profileImage;

  final List<String> _availableSkills = [
    'การเดินสายไฟ',
    'การติดโคมไฟ',
    'การซ่อมระบบไฟ',
    'สมาร์ทโฮม',
    'การติดตั้งเต้ารับ',
    'การติดตั้งสวิตช์',
    'เครื่องปรับอากาศ',
    'งานซ่อมบำรุง',
    'ระบบรักษาความปลอดภัย',
    'ติดตั้งกล้องวงจรปิด',
  ];

  final List<String> _selectedSkills = [
    'การเดินสายไฟ',
    'การติดโคมไฟ',
    'การซ่อมระบบไฟ',
    'งานซ่อมบำรุง',
  ];

  final List<File> _portfolioImages = [];

  @override
  void dispose() {
    nameController.dispose();
    titleController.dispose();
    aboutController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> _showImageSourceSelector({
    required bool isProfileImage,
  }) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                const Text(
                  'เลือกรูปภาพ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Icon(Icons.camera_alt_outlined),
                  title: const Text('ถ่ายรูป'),
                  onTap: () async {
                    Navigator.pop(context);
                    await _pickImage(
                      source: ImageSource.camera,
                      isProfileImage: isProfileImage,
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library_outlined),
                  title: const Text('เลือกรูปจากอัลบั้ม'),
                  onTap: () async {
                    Navigator.pop(context);
                    await _pickImage(
                      source: ImageSource.gallery,
                      isProfileImage: isProfileImage,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImage({
    required ImageSource source,
    required bool isProfileImage,
  }) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile == null) return;

    setState(() {
      if (isProfileImage) {
        _profileImage = File(pickedFile.path);
      } else {
        _portfolioImages.add(File(pickedFile.path));
      }
    });
  }

  Future<void> _showSkillSelector() async {
    final tempSelected = List<String>.from(_selectedSkills);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('เลือกทักษะและความเชี่ยวชาญ'),
          content: StatefulBuilder(
            builder: (context, setDialogState) {
              return SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _availableSkills.map((skill) {
                      final isSelected = tempSelected.contains(skill);
                      return FilterChip(
                        label: Text(skill),
                        selected: isSelected,
                        onSelected: (selected) {
                          setDialogState(() {
                            if (selected) {
                              tempSelected.add(skill);
                            } else {
                              tempSelected.remove(skill);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('กลับไปแก้ไขต่อ'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedSkills
                    ..clear()
                    ..addAll(tempSelected);
                });
                Navigator.pop(context);
              },
              child: const Text('ยืนยัน'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmCancelEdit() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('ยืนยันการยกเลิก'),
          content: const Text(
            'หากยกเลิกตอนนี้ ข้อมูลที่แก้ไขไว้จะไม่ถูกบันทึก',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('กลับไปแก้ไขต่อ'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('ยืนยันการยกเลิก'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmSave() async {
  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('ยืนยันการบันทึก'),
        content: const Text('คุณต้องการบันทึกข้อมูลโปรไฟล์ที่แก้ไขใช่หรือไม่'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('กลับไปแก้ไขต่อ'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.pop(context, true);
            },
            child: const Text('ยืนยันการบันทึก'),
          ),
        ],
      );
    },
  );
}


  void _removeSkill(String skill) {
    setState(() {
      _selectedSkills.remove(skill);
    });
  }

  void _removePortfolioImage(int index) {
    setState(() {
      _portfolioImages.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: _confirmCancelEdit,
        ),
        title: const Text(
          'แก้ไขโปรไฟล์',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _confirmSave,
            child: const Text(
              'บันทึก',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 8),
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 46,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : const AssetImage('assets/alex_rivera.jpg')
                                as ImageProvider,
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () {
                              _showImageSourceSelector(isProfileImage: true);
                            },
                            icon: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      _showImageSourceSelector(isProfileImage: true);
                    },
                    child: const Text(
                      'เปลี่ยนรูปโปรไฟล์',
                      style: TextStyle(color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            _buildSectionTitle('ข้อมูลส่วนตัว'),
            _buildTextField('ชื่อ-นามสกุล', nameController),
            _buildTextField('ตำแหน่ง/อาชีพ', titleController),
            _buildTextField('คำอธิบาย', aboutController, maxLines: 4),

            const SizedBox(height: 8),
            _buildSkillsSection(),

            const SizedBox(height: 20),
            _buildPortfolioSection(),

            const SizedBox(height: 20),
            _buildSectionTitle('ข้อมูลการติดต่อ'),
            _buildTextField('เบอร์โทรศัพท์', phoneController),
            _buildTextField('อีเมล', emailController),

            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _confirmCancelEdit,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Color(0xFFFFCACA)),
                  backgroundColor: const Color(0xFFFFF5F5),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'ยกเลิกการปรับปรุงโปรไฟล์',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: const Color(0xFFF2F4F7),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.green),
          ),
        ),
      ),
    );
  }

  Widget _buildSkillsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'ทักษะและความเชี่ยวชาญ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: _showSkillSelector,
              icon: const Icon(Icons.add, color: Colors.green, size: 18),
              label: const Text(
                'เพิ่ม',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _selectedSkills.map((skill) {
            return Chip(
              label: Text(skill),
              deleteIcon: const Icon(Icons.close, size: 18),
              onDeleted: () => _removeSkill(skill),
              backgroundColor: const Color(0xFFEFFAF1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Color(0xFFD7F5DF)),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPortfolioSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'ผลงาน',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: () {
                _showImageSourceSelector(isProfileImage: false);
              },
              icon: const Icon(Icons.add, color: Colors.green, size: 18),
              label: const Text(
                'เพิ่มภาพผลงาน',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        GridView.builder(
          itemCount: _portfolioImages.length + 1,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            if (index == _portfolioImages.length) {
              return GestureDetector(
                onTap: () {
                  _showImageSourceSelector(isProfileImage: false);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.green.shade200,
                      style: BorderStyle.solid,
                    ),
                    color: const Color(0xFFF6FFF8),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: Colors.green, size: 28),
                      SizedBox(height: 6),
                      Text(
                        'เพิ่มรูปภาพ',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    image: DecorationImage(
                      image: FileImage(_portfolioImages[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () => _removePortfolioImage(index),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
