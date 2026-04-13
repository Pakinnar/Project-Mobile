import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'home_page.dart'; 
import 'myjobs_page.dart'; 

class AddJobPage extends StatefulWidget {
  const AddJobPage({super.key});

  @override
  State<AddJobPage> createState() => _AddJobPageState();
}

class _AddJobPageState extends State<AddJobPage> {
  final _formKey = GlobalKey<FormState>();
  File? _image;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  String? _selectedCategory;
  final List<String> _categories = ['บริการช่าง', 'งานปรับปรุง', 'งานซ่อมบำรุง', 'ยานยนต์', 'งานบ้านและสวน'];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF00E676)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF00E676)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _timeController.text = picked.format(context);
      });
    }
  }

  Future<void> _pickImage() async {
    final XFile? selectedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      setState(() { _image = File(selectedImage.path); });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('ลงประกาศงาน', 
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('ชื่อหัวข้องาน'),
              _buildTextField(_titleController, 'ระบุชื่อหัวข้องานที่ต้องการจ้าง'),

              const SizedBox(height: 20),
              _buildLabel('เลือกหมวดหมู่'),
              _buildDropdown(),

              const SizedBox(height: 20),
              _buildLabel('รูปภาพประกอบงาน'),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 180, width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: _image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(_image!, fit: BoxFit.cover),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo_outlined, size: 40, color: Colors.grey[300]),
                            const SizedBox(height: 10),
                            const Text('คลิกเพื่อเลือกรูปภาพจากแกลเลอรี่', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 20),
              _buildLabel('รายละเอียดงาน'),
              _buildTextField(_descController, 'อธิบายรายละเอียดงาน...', maxLines: 4),

              const SizedBox(height: 20),
              _buildLabel('งบประมาณ (บาท)'),
              _buildTextField(_priceController, '0.00', suffix: '฿', keyboardType: TextInputType.number),

              const SizedBox(height: 20),
              _buildLabel('วันที่และเวลาที่ต้องการ'),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectDate(context),
                      child: AbsorbPointer(
                        child: _buildTextField(_dateController, 'เลือกวันที่', prefixIcon: Icons.calendar_today_outlined),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectTime(context),
                      child: AbsorbPointer(
                        child: _buildTextField(_timeController, 'เลือกเวลา', prefixIcon: Icons.access_time_outlined),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00E676),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 0,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final newData = {
                        'title': _titleController.text,
                        'price': '฿${_priceController.text}',
                        'desc': _descController.text,
                        'img': _image?.path ?? '',
                        'cate': _selectedCategory ?? 'ทั่วไป',
                        'dist': '0.1 กม.',
                        'date': _dateController.text,
                        'time': _timeController.text,
                      };

                      HomePageState.jobList.insert(0, newData);

                      Navigator.pop(context); 
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MyJobsPage()),
                      );
                    }
                  },
                  child: const Text('ลงประกาศงาน', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)));
  }

  Widget _buildTextField(TextEditingController controller, String hint, {int maxLines = 1, String? suffix, IconData? prefixIcon, TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.grey, size: 20) : null,
        suffixText: suffix,
        filled: true, fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF00E676), width: 1.5)),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCategory,
          hint: const Text('เลือกประเภทงาน', style: TextStyle(color: Colors.grey, fontSize: 14)),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: _categories.map((String value) => DropdownMenuItem<String>(value: value, child: Text(value))).toList(),
          onChanged: (newValue) { setState(() { _selectedCategory = newValue; }); },
        ),
      ),
    );
  }
}