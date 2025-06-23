import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:registration_evaluation_app/screens/student/Settings.dart';
import 'package:registration_evaluation_app/screens/student/timetable.dart';
import 'package:http/http.dart' as http;

List<Widget> itmpage = [StudentScreen(), Timetable(), Settings()];

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
  bool rememberPassword = true;
  int idx = 0;

  void ontabpPed(BuildContext context, int indx) {
    setState(() {
      idx = indx;
    });

    // ນຳທາງໄປໜ້າໃໝ່
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => itmpage[indx]),
    );
  }

  Widget BottomBar() {
    return BottomNavigationBar(
      backgroundColor: Color(0xFF345FB4),
      selectedIconTheme: IconThemeData(color: Colors.white, size: 35),
      selectedLabelStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      selectedFontSize: 15,
      selectedItemColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      currentIndex: idx,
      onTap: (index) {
        ontabpPed(context, index); // ປ່ຽນ index ຂອງໜ້າປະຈຸບັນ
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "ໜ້າຫຼັກ",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.microwave_outlined),
          label: "ຕາຕະລາງຮຽນ",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_rounded),
          label: "ຕັ້ງຄ່າ",
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Expanded(flex: 1, child: SizedBox(height: 10)),
          Expanded(
            flex: 166,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // รูปภาพนักศึกษา
                  CircleAvatar(
                    radius: 90,
                    backgroundImage: AssetImage(
                        'assets/student.jpg'), // เพิ่มรูปภาพในโฟลเดอร์ assets
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
                          _buildInfoRow("ທີ່ຢູ່ບ້ານປັດຈຸບັນ", "Vientiane"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          BottomBar(),
        ],
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
