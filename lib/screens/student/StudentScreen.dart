import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:registration_evaluation_app/screens/student/footers.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

// ----------------------
// Student Model
// ----------------------
class Student {
  final String studentId;
  final String name;
  final String homeAddress;
  final String homeProvince;
  final String currentProvince;
  final String phone;
  final int semester;
  final int studyYear;
  final String term;
  final String session;
  final String imageUrl;

  Student({
    required this.studentId,
    required this.name,
    required this.homeAddress,
    required this.homeProvince,
    required this.currentProvince,
    required this.phone,
    required this.semester,
    required this.studyYear,
    required this.term,
    required this.session,
    required this.imageUrl,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      studentId: json['student_id'],
      name: json['name'],
      homeAddress: json['home_address'],
      homeProvince: json['home_province'],
      currentProvince: json['current_province'],
      phone: json['phone'],
      semester: json['semester'],
      studyYear: json['study_year'],
      term: json['term'],
      session: json['session'],
      imageUrl: json['image_url'],
    );
  }
}

// ----------------------
// API Fetch Function
// ----------------------
Future<Student> fetchStudent() async {
  final response = await http.get(
    Uri.parse('https://your-api.com/student/10012345'),
  );

  if (response.statusCode == 200) {
    return Student.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load student data');
  }
}

class _StudentScreenState extends State<StudentScreen> {
  // final _formSignInKey = GlobalKey<FormState>();
  Future<void> _refreshData() async {
    // จำลองการโหลดข้อมูลใหม่ เช่นจาก API
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (a, b, c) => Footers(), // โหลดหน้าใหม่ทับ
          transitionDuration: Duration.zero,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        color: Colors.green,
        onRefresh: _refreshData,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 16),
                        // รูปภาพนักศึกษา
                        CircleAvatar(
                          radius: 90,
                          // backgroundImage: AssetImage(
                          //     'assets/student.jpg'), // เพิ่มรูปภาพในโฟลเดอร์ assets
                        ),
                        SizedBox(height: 16),

                        // กล่องข้อมูล
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                _buildInfoRow("ລະຫັດນັກສຶກສາ", "SRI00032"),
                                Divider(),
                                _buildInfoRow("ຊື່", "Chansamai"),
                                Divider(),
                                _buildInfoRow("ນາມສະກຸນ", "koratasu"),
                                Divider(),
                                _buildInfoRow("ເພດ", "ຊາຍ"),
                                Divider(),
                                _buildInfoRow("ເບີໂທ", "020-1236-4567"),
                                Divider(),
                                _buildInfoRow("ຫ້ອງຮຽນ", "3D"),
                                Divider(),
                                _buildInfoRow("ພາກຮຽນ", "ພາກບ່າຍ"),
                                Divider(),
                                _buildInfoRow("ສຶກສາປີທີ", "3"),
                                Divider(),
                                _buildInfoRow("ວັນເດືອນປີເກີດ", "12-12-2008"),
                                Divider(),
                                _buildInfoRow("ທີ່ຢູ່ບ້ານເກີດ", "123 Main St"),
                                Divider(),
                                _buildInfoRow(
                                    "ທີ່ຢູ່ບ້ານປັດຈຸບັນ", "Vientiane"),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: TextStyle(
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
