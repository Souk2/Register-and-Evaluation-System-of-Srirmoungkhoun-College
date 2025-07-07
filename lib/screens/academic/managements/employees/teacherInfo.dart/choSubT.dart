import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';
import 'package:registration_evaluation_app/screens/academic/academicScreen.dart';
import 'package:registration_evaluation_app/screens/academic/managements/students/studentPage.dart';
import 'package:registration_evaluation_app/services/EmployeesService.dart';
import 'package:registration_evaluation_app/services/RegistrationService.dart';
import 'package:registration_evaluation_app/services/StudentService.dart';

class ChoSubTeacher extends StatefulWidget {
  final String staff_id;
  final String staff_Name;
  final String staff_Surname;
  final String image_url;
  const ChoSubTeacher({
    super.key,
    required this.staff_id,
    required this.staff_Name,
    required this.staff_Surname,
    required this.image_url,
  });

  @override
  State<ChoSubTeacher> createState() => _ChoSubTeacherState();
}

class _ChoSubTeacherState extends State<ChoSubTeacher> {
  final _formKey = GlobalKey<FormState>();

  File? _selectedImage; //Upload Images
  String? _imageUrl; // สำหรับ URL ที่รับมาจาก backend

  List<dynamic> studyyearData = [];
  int? _valueSyear;

  List<dynamic> subjectData = [];
  int? _valueSubject;

  List<dynamic> filteredSubjects = [];

  //ຫ້ອງຮຽນ
  List<dynamic> classData = [];
  int? _valueClass;

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _empID.text = widget.staff_id;
    _empName.text = widget.staff_Name;
    _empSurname.text = widget.staff_Surname;

    _imageUrl = widget.image_url;
    _fetchAllDropdownData();
  }

  final TextEditingController _empID = TextEditingController();
  final TextEditingController _empName = TextEditingController();
  final TextEditingController _empSurname = TextEditingController();

  // static const String baseUrl = "http://192.168.0.104:3000";

  static const String baseUrl = "http://10.34.90.133:3000";

  Future<void> _fetchAllDropdownData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 1. สร้าง List ของ Future สำหรับแต่ละ API call
      List<Future<http.Response>> futures = [
        http.get(Uri.parse("$baseUrl/subjects")),
        http.get(Uri.parse("$baseUrl/syear")),
        http.get(Uri.parse("$baseUrl/class")),
        // เพิ่ม API ตัวอื่นๆ ได้ตามต้องการ
      ];

      // 2. ใช้ Future.wait เพื่อรอให้ทุก API call เสร็จสิ้นพร้อมกัน
      List<http.Response> responses = await Future.wait(futures);

      // 3. ตรวจสอบและประมวลผลข้อมูลจากแต่ละ API

      //ສະຖານະການຮຽນ
      if (responses[0].statusCode == 200) {
        subjectData = jsonDecode(responses[0].body);
        print('ປີຮຽນ data loaded: ${subjectData.length} items');
      } else {
        throw Exception(
            'Failed to load provinces data: ${responses[0].statusCode}');
      }

      //ປີຮຽນ
      if (responses[1].statusCode == 200) {
        studyyearData = jsonDecode(responses[1].body);
        print('ປີຮຽນ data loaded: ${studyyearData.length} items');
      } else {
        throw Exception(
            'Failed to load provinces data: ${responses[1].statusCode}');
      }
      //ຫ້ອງສອນ
      if (responses[2].statusCode == 200) {
        classData = jsonDecode(responses[2].body);
        print('Districts data loaded: ${classData.length} items');
      } else {
        throw Exception(
            'Failed to load districts data: ${responses[2].statusCode}');
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

  Future<void> _submitNewTeachSub() async {
    if (_formKey.currentState!.validate()) {
      if (_valueSubject == null || _valueClass == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "ກະລຸນາປ້ອນຂໍ້ມູນໃຫ້ຄົບຖ້ວນ",
              style: TextStyle(
                fontFamily: 'Phetsarath',
              ),
            ), // Please select a province
            backgroundColor: Colors.orange,
          ),
        );
        return; // Stop submission if no province is selected
      }

      bool success = await Employeesservice.addTeachSub(
        _empID.text,
        _valueClass!,
        _valueSubject!,
        _valueSyear!, // 👈 รูปภาพที่ผู้ใช้เลือก
      );
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "ນັກຮຽນໃໝ່ຖືກບັນທຶກສຳເລັດແລ້ວ",
              style: TextStyle(
                fontFamily: 'Phetsarath',
              ),
            ),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.of(context).pop();
        showAlert();
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
      }
    }
  }

  void showAlert() {
    QuickAlert.show(
      context: context,
      title: "ບັນທຶກສຳເລັດ",
      type: QuickAlertType.success,
      confirmBtnTextStyle: TextStyle(
        fontFamily: 'Phetsarath',
        color: Colors.white, // Replace with your desired font
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      confirmBtnColor: Colors.green,
      confirmBtnText: "ຕົກລົງ",
    );
  }

  void ConfirmUpdate() async {
    print("ConfirmUpdate");
    if (!mounted) {
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            'ຢືນຍັນການບັນທຶກ',
            style: TextStyle(
              fontFamily: 'Phetsarath',
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'ທ່ານແນ່ໃຈວ່າຈະບັນທຶກຫຼືບໍ່?',
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'Phetsarath',
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: Size(
                  80,
                  50,
                ), // ປັບຂະໜາດ (ກວ້າງ x ສູງ)
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                'ຍົກເລີກ',
                style: TextStyle(
                  fontFamily: 'Phetsarath',
                  color: Colors.white,
                ),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: Size(
                  80,
                  50,
                ), // ປັບຂະໜາດ (ກວ້າງ x ສູງ)
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onPressed: () {
                if (_valueSubject == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "ກະລຸນາເລືອກວິຊາກ່ອນ",
                        style: TextStyle(
                          fontFamily: 'Phetsarath',
                        ),
                      ), // Please select a province
                      backgroundColor: Colors.orange,
                    ),
                  );
                  Navigator.of(context).pop();
                  return; // Stop submission if no province is selected
                } else {
                  _submitNewTeachSub();
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                'ຕົກລົງ',
                style: TextStyle(
                  fontFamily: 'Phetsarath',
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _empID.dispose();
    _empName.dispose();
    _empSurname.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.blueAccent,
        title: Text(
          "ຈັດການເລືອກວິຊາສອນ",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Phetsarath',
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  "ຂໍ້ມູນຄູ-ອາຈານ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'Phetsarath',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  child: CircleAvatar(
                    radius: 90,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!)
                        : (_imageUrl != null && _imageUrl!.isNotEmpty
                            ? NetworkImage(_imageUrl!)
                            : null),
                    child: _selectedImage == null && widget.image_url.isEmpty
                        ? Icon(Icons.camera_alt, size: 40, color: Colors.grey)
                        : null,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _empID,
                  readOnly: true,
                  // enabled: false,
                  decoration: InputDecoration(
                    labelText: 'ລະຫັດຄູ-ອາຈານ',
                    labelStyle: TextStyle(
                      fontFamily: 'Phetsarath',
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _empName,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'ຊື່',
                          labelStyle: TextStyle(
                            fontFamily: 'Phetsarath',
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'ກະລຸນາປ້ອນຊື່ເມືອງ';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _empSurname,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'ນາມສະກຸນ',
                          labelStyle: TextStyle(
                            fontFamily: 'Phetsarath',
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "ເລືອກປີສອນ ແລະ ວິຊາສອນ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'Phetsarath',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black, width: 1),
                        ),
                        child: DropdownButton(
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          borderRadius: BorderRadius.circular(10),
                          underline: SizedBox.shrink(),
                          isExpanded: true,
                          items: studyyearData.map((e) {
                            return DropdownMenuItem(
                              child: Text(
                                e["Syear"],
                                style: TextStyle(fontFamily: 'Phetsarath'),
                              ),
                              value: e["SyearID"],
                            );
                          }).toList(),
                          value: _valueSyear,
                          onChanged: (v) {
                            setState(() {
                              _valueSyear = v as int;

                              filteredSubjects = subjectData.where((subj) {
                                return subj["SyearID"] == _valueSyear;
                              }).toList();

                              _valueSubject = null; // ล้างค่าเดิมของวิชา
                            });
                          },
                          hint: Text(
                            "ປີທີ",
                            style: TextStyle(fontFamily: 'Phetsarath'),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black, width: 1),
                        ),
                        child: DropdownButton(
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          borderRadius: BorderRadius.circular(10),
                          underline: SizedBox.shrink(),
                          isExpanded: true,
                          items: filteredSubjects.map((e) {
                            return DropdownMenuItem(
                              child: Text(
                                e["sub_Name"],
                                style: TextStyle(fontFamily: 'Phetsarath'),
                              ),
                              value: e["sub_id"],
                            );
                          }).toList(),
                          value: _valueSubject,
                          onChanged: (v) {
                            setState(() {
                              _valueSubject = v as int;
                            });
                          },
                          hint: Text(
                            "ວິຊາ",
                            style: TextStyle(fontFamily: 'Phetsarath'),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "ເລືອກຫ້ອງສອນ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'Phetsarath',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black, width: 1), // Border
                  ),
                  child: DropdownButton(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    underline: SizedBox.shrink(),
                    borderRadius: BorderRadius.circular(20),
                    isExpanded: true,
                    items: classData.map((e) {
                      return DropdownMenuItem(
                        child: Text(
                          e["classroom"],
                          style: TextStyle(
                            fontFamily: 'Phetsarath',
                          ),
                        ),
                        value: e["classID"],
                      );
                    }).toList(),
                    value: _valueClass,
                    onChanged: (v) {
                      setState(() {
                        _valueClass = v as int;
                      });
                    },
                    hint: Text(
                      "ເລືອກຫ້ອງຮຽນ",
                      style: TextStyle(
                        fontFamily: 'Phetsarath',
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                        ),
                        onPressed: () {
                          ConfirmUpdate();
                          print("ບັນທຶກການຂໍ້ມູນນັກສຶກສາສຳເລັດ");
                        },
                        // onPressed: _submitDistrict,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.print,
                              color: Colors.white,
                            ),
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
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
