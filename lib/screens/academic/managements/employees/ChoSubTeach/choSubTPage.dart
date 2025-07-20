import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';
import 'package:registration_evaluation_app/screens/academic/managements/employees/ChoSubTeach/choSubT.dart';
import 'package:registration_evaluation_app/screens/academic/managements/employees/teacherInfo.dart/editTeacherInfoPage.dart';
import 'package:registration_evaluation_app/screens/academic/managements/employees/ChoSubTeach/editchoSubT.dart';
import 'package:registration_evaluation_app/screens/academic/payments/editPaymentPage.dart';
import 'package:registration_evaluation_app/services/EmployeesService.dart';
import 'package:registration_evaluation_app/services/StudentService.dart';

// สร้าง enum เพื่อใช้เป็นค่าใน Radio buttons
enum TeacherType { choSubTeacher, editSubTeach }

class ChoSubTPage extends StatefulWidget {
  const ChoSubTPage({super.key});

  @override
  State<ChoSubTPage> createState() => _ChoSubTPageState();
}

class _ChoSubTPageState extends State<ChoSubTPage> {
  // static const String baseUrl = "http://192.168.0.104:3000";

  List<dynamic> teachers = [];

  TextEditingController _searchController = TextEditingController();

  bool _isLoading = false;

  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // _fetchAllDropdownData(); // Call the data fetching function when the widget is created
    fetchTeachers();
  }

  void fetchSearchTeachers({String? searchQuery}) async {
    try {
      final fetchTeachers = searchQuery == null || searchQuery.isEmpty
          ? await Employeesservice.getChoTesch()
          : await Employeesservice.searchEmployees(searchQuery);
      print(searchQuery);
      setState(() {
        teachers = fetchTeachers;
      });
    } catch (e) {
      print("Error:$e");
    }
  }

  void fetchTeachers() async {
    try {
      final fetchTeachers = await Employeesservice.getChoTesch();
      setState(() {
        teachers = fetchTeachers;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  List<dynamic> get filteredTeachers {
    return teachers.where((teacher) {
      final matchesTeacher = teacher['roleID'] == 3;
      return matchesTeacher;
    }).toList();
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

  TeacherType? _selectedTeacherType;
  // รายการข้อความสำหรับ Radio buttons
  final List<String> opt = ["ເລືອກວິຊາສອນໃຫ້ອາຈານ", "ແກ້ໄຂວິຊາສອນ"];

  Future<void> _showTeacherSelectionDialog(Map<String, dynamic> teacher) async {
    setState(() {
      _selectedTeacherType = null;
    });

    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text(
            "ເຂົ້າສູ່ໜ້າ...",
            style: TextStyle(
                fontFamily: 'Phetsarath', fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RadioListTile<TeacherType>(
                title: Text(opt[0], style: TextStyle(fontFamily: 'Phetsarath')),
                value: TeacherType.choSubTeacher,
                groupValue: _selectedTeacherType,
                onChanged: (TeacherType? value) async {
                  setState(() {
                    _selectedTeacherType = value;
                  });
                  Navigator.of(dialogContext).pop();
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChoSubTeacher(
                        staff_id: teacher['staff_id'],
                        image_url: teacher['image_url'],
                        staff_Name: teacher['staff_Name'],
                        staff_Surname: teacher['staff_Surname'],
                      ),
                    ),
                  );

                  // ถ้าหน้าแก้ไขส่ง true กลับมา ให้ refresh
                  if (result == true) {
                    setState(() {
                      fetchTeachers();
                    });
                  }
                },
              ),
              RadioListTile<TeacherType>(
                title: Text(opt[1], style: TextStyle(fontFamily: 'Phetsarath')),
                value: TeacherType.choSubTeacher,
                groupValue: _selectedTeacherType,
                onChanged: (TeacherType? value) async {
                  setState(() {
                    _selectedTeacherType = value;
                  });
                  Navigator.of(dialogContext).pop();
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditChoSubTeacher(
                        teachSub_id: teacher['teachSub_id'],
                        staff_id: teacher['staff_id'],
                        image_url: teacher['image_url'],
                        staff_Name: teacher['staff_Name'],
                        staff_Surname: teacher['staff_Surname'],
                        classID: teacher['classID'],
                        sub_id: teacher['sub_id'],
                        SyearID: teacher['SyearID'],
                        mid: teacher['mid'],
                      ),
                    ),
                  );

                  // ถ้าหน้าแก้ไขส่ง true กลับมา ให้ refresh
                  if (result == true) {
                    setState(() {
                      fetchTeachers();
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
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
            fontFamily: 'Phetsarath',
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orangeAccent,
              shape: CircleBorder(),
              padding: EdgeInsets.all(10),
            ),
            onPressed: () {
              // TODO: Refresh action
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (a, b, c) => ChoSubTPage(), // โหลดหน้าใหม่ทับ
                  transitionDuration: Duration.zero,
                ),
              );
            },
            child: Icon(
              Icons.refresh,
              color: Colors.white,
              size: 25,
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Container(
            height: 40,
            width: MediaQuery.of(context).size.width * 1,
            margin: EdgeInsets.all(10),
            child: TextField(
              controller: _searchController,
              style: TextStyle(
                fontFamily: 'Phetsarath',
              ),
              decoration: InputDecoration(
                hintText: 'ຄົ້ນຫາຊື່...',
                hintStyle: TextStyle(
                  fontFamily: 'Phetsarath',
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.search,
                  ),
                  onPressed: () {
                    fetchSearchTeachers(searchQuery: _searchController.text);
                  },
                ),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: _isLoading
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(), // loading icon
                            SizedBox(height: 10),
                            Text(
                              'ໂລດຂໍ້ມູນ...',
                              style: TextStyle(
                                fontFamily: 'Phetsarath',
                              ),
                            ),
                          ],
                        ),
                      )
                    : teachers.isEmpty
                        ? Center(
                            child: Text(
                              "!ບໍ່ພົບຂໍ້ມູນ ຫຼື ຂາດການເຊື່ອມຕໍ່!",
                              style: TextStyle(
                                fontFamily: 'Phetsarath',
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: filteredTeachers.length,
                            itemBuilder: (context, index) {
                              final teacher = filteredTeachers[index];
                              return Card(
                                margin: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                child: Padding(
                                  padding: const EdgeInsets.all(6),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(10),
                                    splashColor: Colors.blueAccent.withOpacity(
                                        0.3), // สีของ ripple effect
                                    // hoverColor: Colors.transparent,
                                    highlightColor: Colors
                                        .transparent, // ทำให้ไม่มีสีไฮไลต์เมื่อกดค้าง (ถ้าไม่ต้องการ)
                                    onTap: () async {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'ເຂົ້າສູ່ໜ້າການເລືອກວິຊາສອນ',
                                            style: TextStyle(
                                              fontFamily: 'Phetsarath',
                                            ),
                                          ),
                                          backgroundColor: Colors.green,
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                      _showTeacherSelectionDialog(teacher);
                                    },
                                    child: Row(
                                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Spacer(),
                                        Column(
                                          // crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 10,
                                            ),
                                            if (teacher['image_url'] != null)
                                              Center(
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: Image.network(
                                                    teacher['image_url'],
                                                    width: 120,
                                                    height: 120,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context,
                                                            error,
                                                            stackTrace) =>
                                                        Icon(Icons.error),
                                                  ),
                                                ),
                                              ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              '${teacher['staff_id']}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.055,
                                                color: Colors.blueAccent,
                                                fontFamily: 'Phetsarath',
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  '${teacher['staff_Name']}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.048,
                                                    fontFamily: 'Phetsarath',
                                                  ),
                                                ),
                                                Text(
                                                  ' ${teacher['staff_Surname']}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.048,
                                                    fontFamily: 'Phetsarath',
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              '${teacher['Syear']}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.048,
                                                fontFamily: 'Phetsarath',
                                                color: teacher['SyearID'] == 1
                                                    ? Colors
                                                        .blue // ถ้า ID เป็น 1 ให้เป็นสีเขียว
                                                    : teacher['SyearID'] == 2
                                                        ? Colors
                                                            .green // ถ้า ID เป็น 2 ให้เป็นสีเหลือง
                                                        : teacher['SyearID'] ==
                                                                3
                                                            ? Colors
                                                                .purple // ถ้า ID เป็น 3 ให้เป็นสีแดง
                                                            : teacher['SyearID'] ==
                                                                    4
                                                                ? Colors.amber
                                                                : Colors
                                                                    .black, // กรณีอื่น ๆ (เช่นไม่มีค่าตรงกับเงื่อนไข) ให้เป็นสีดำ
                                              ),
                                            ),
                                            Text(
                                              ' ${teacher['sub_Name']}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.048,
                                                fontFamily: 'Phetsarath',
                                              ),
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
