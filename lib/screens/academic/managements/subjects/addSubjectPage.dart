// import 'package:flutter/foundation.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:registration_evaluation_app/services/SubjectsService.dart';
import 'package:http/http.dart' as http;

class AddSubjectPage extends StatefulWidget {
  const AddSubjectPage({super.key});

  @override
  State<AddSubjectPage> createState() => _AddSubjectPageState();
}

class _AddSubjectPageState extends State<AddSubjectPage> {
  final TextEditingController _tittlecontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List<dynamic> sYearData = []; // use from dropdownbutton
  int? _valueSyear; // use from dropdownbutton

  List<dynamic> majorData = []; // use from dropdownbutton
  int? _valueMajor; // use from dropdownbutton

  ////
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchAllDropdownData(); // Call the data fetching function when the widget is created
  }

  static const String baseUrl = "http://10.34.90.133:3000";

  Future<void> _fetchAllDropdownData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 1. สร้าง List ของ Future สำหรับแต่ละ API call
      List<Future<http.Response>> futures = [
        http.get(Uri.parse("$baseUrl/syear")),
        http.get(Uri.parse("$baseUrl/major")),
        // เพิ่ม API ตัวอื่นๆ ได้ตามต้องการ
      ];

      // 2. ใช้ Future.wait เพื่อรอให้ทุก API call เสร็จสิ้นพร้อมกัน
      List<http.Response> responses = await Future.wait(futures);

      // 3. ตรวจสอบและประมวลผลข้อมูลจากแต่ละ API

      if (responses[0].statusCode == 200) {
        sYearData = jsonDecode(responses[0].body);
        print('ປີຮຽນ data loaded: ${sYearData.length} items');
      } else {
        throw Exception(
            'Failed to load provinces data: ${responses[0].statusCode}');
      }

      if (responses[1].statusCode == 200) {
        majorData = jsonDecode(responses[1].body);
        print('ປີຮຽນ data loaded: ${majorData.length} items');
      } else {
        throw Exception(
            'Failed to load provinces data: ${responses[1].statusCode}');
      }

      // 4. อัปเดต UI หลังจากข้อมูลทั้งหมดโหลดเสร็จสมบูรณ์
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'An unexpected error occurred: $error';
      });
      print('Error fetching all dropdown data: $error');
    }
  }
  /////

  Future<void> _submitSubjects() async {
    if (_formKey.currentState!.validate()) {
      if (_valueSyear == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "ກະລຸນາເລືອກປີຮຽນ!",
              style: TextStyle(
                fontFamily: 'Phetsarath',
              ),
            ), // Please select a province
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 1),
          ),
        );
        return; // Stop submission if no province is selected
      }
      if (_valueMajor == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "ກະລຸນາເລືອກສາຮຽນ!",
              style: TextStyle(
                fontFamily: 'Phetsarath',
              ),
            ), // Please select a province
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 1),
          ),
        );
        return; // Stop submission if no province is selected
      }

      bool success = await Subjectsservice.addSubjects(
          _tittlecontroller.text, _valueSyear!, _valueMajor!);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "ຊື່ເມືອງຖືກບັນທຶກສຳເລັດແລ້ວ",
              style: TextStyle(
                fontFamily: 'Phetsarath',
              ),
            ),
            backgroundColor: Colors.green,
          ),
        );
        _tittlecontroller.clear();
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "ຂໍອະໄພ!ເກີດຂໍ້ຜິດພາດ",
              style: TextStyle(
                fontFamily: 'Phetsarath',
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );

        // _tittlecontroller.clear();
      }
    }
  }

  @override
  void dispose() {
    _tittlecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // getData(); // use from dropdownbutton
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          'ເພີ່ມວິຊາຮຽນ',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Phetsarath',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _tittlecontroller,
                decoration: InputDecoration(
                  labelText: 'ຊື່ວິຊາຮຽນ',
                  labelStyle: TextStyle(
                    fontFamily: 'Phetsarath',
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'ກະລຸນາປ້ອນຊື່ເມືອງ';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black, width: 1), // Border
                ),
                child: DropdownButton(
                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  isExpanded: true,
                  underline: SizedBox.shrink(),
                  borderRadius: BorderRadius.circular(20),
                  items: sYearData.map((e) {
                    return DropdownMenuItem(
                      child: Text(
                        e["Syear"],
                        style: TextStyle(
                          fontFamily: 'Phetsarath',
                        ),
                      ),
                      value: e["SyearID"],
                    );
                  }).toList(),
                  hint: Text(
                    'ເລືອກປີຮຽນ',
                    style: TextStyle(
                      fontFamily: 'Phetsarath',
                    ),
                  ),
                  value: _valueSyear,
                  onChanged: (v) {
                    setState(() {
                      _valueSyear = v as int;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black, width: 1), // Border
                ),
                child: DropdownButton(
                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  isExpanded: true,
                  underline: SizedBox.shrink(),
                  borderRadius: BorderRadius.circular(20),
                  items: majorData.map((e) {
                    return DropdownMenuItem(
                      child: Text(
                        e["m_name"],
                        style: TextStyle(
                          fontFamily: 'Phetsarath',
                        ),
                      ),
                      value: e["mid"],
                    );
                  }).toList(),
                  hint: Text(
                    'ເລືອກສາຮຽນ',
                    style: TextStyle(
                      fontFamily: 'Phetsarath',
                    ),
                  ),
                  value: _valueMajor,
                  onChanged: (v) {
                    setState(() {
                      _valueMajor = v as int;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                onPressed: _submitSubjects,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.print),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'ບັນທຶກ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: 'Phetsarath',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
