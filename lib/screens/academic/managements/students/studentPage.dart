import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';
import 'package:registration_evaluation_app/screens/academic/managements/students/editStudentPage.dart';
import 'package:registration_evaluation_app/services/StudentService.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  List<dynamic> students = [];

  TextEditingController _searchController = TextEditingController();
  //ສົກຮຽນ
  List<dynamic> yearData = []; // use from dropdownbutton
  int? _valueYear; // use from dropdownbutton

  //ສະຖານະການຮຽນ
  List<dynamic> statuSData = []; // use from dropdownbutton
  int? _valueStatuS; // use from dropdownbutton

  //ປີຮຽນ
  List<dynamic> studyyearData = []; // use from dropdownbutton
  int? _valueSyear; // use from dropdownbutton

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchAllDropdownData(); // Call the data fetching function when the widget is created
    fetchStudents();
  }

  void fetchSearchStudents({String? searchQuery}) async {
    try {
      final fetchStudents = searchQuery == null || searchQuery.isEmpty
          ? await Studentservice.getStudents()
          : await Studentservice.searchStudents(searchQuery);
      print(searchQuery);
      setState(() {
        students = fetchStudents;
      });
    } catch (e) {
      print("Error:$e");
    }
  }

  void fetchStudents() async {
    try {
      final fetchStudents = await Studentservice.getStudentsAll();
      setState(() {
        students = fetchStudents;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  static const String baseUrl = "http://192.168.0.104:3000";

  Future<void> _fetchAllDropdownData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 1. สร้าง List ของ Future สำหรับแต่ละ API call
      List<Future<http.Response>> futures = [
        http.get(Uri.parse("$baseUrl/staS")),
        http.get(Uri.parse("$baseUrl/syear")),
        http.get(Uri.parse("$baseUrl/yearstd")),
        // เพิ่ม API ตัวอื่นๆ ได้ตามต้องการ
      ];

      // 2. ใช้ Future.wait เพื่อรอให้ทุก API call เสร็จสิ้นพร้อมกัน
      List<http.Response> responses = await Future.wait(futures);

      // 3. ตรวจสอบและประมวลผลข้อมูลจากแต่ละ API

      //ສະຖານະການຮຽນ
      if (responses[0].statusCode == 200) {
        statuSData = jsonDecode(responses[0].body);
        print('ປີຮຽນ data loaded: ${statuSData.length} items');
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

      //ສົກຮຽນ
      if (responses[2].statusCode == 200) {
        yearData = jsonDecode(responses[2].body);
        print('ສົກຮຽນ data loaded: ${yearData.length} items');
      } else {
        throw Exception(
            'Failed to load provinces data: ${responses[2].statusCode}');
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

  List<dynamic> get filteredStudents {
    return students.where((student) {
      final matchesSyear =
          _valueSyear == null || student['SyearID'] == _valueSyear;
      final matchesYear =
          _valueYear == null || student['yearS_id'] == _valueYear;
      final matchesStatusS =
          _valueStatuS == null || student['statusID'] == _valueStatuS;
      return matchesSyear && matchesYear && matchesStatusS;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          "ຈັດການຂໍ້ມູນນັກສຶກສາ",
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
              padding: EdgeInsets.all(16),
            ),
            onPressed: () {
              // TODO: Refresh action
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (a, b, c) => StudentPage(), // โหลดหน้าใหม่ทับ
                  transitionDuration: Duration.zero,
                ),
              );
            },
            child: Icon(
              Icons.refresh,
              color: Colors.white,
              size: 30,
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
                    fetchSearchStudents(searchQuery: _searchController.text);
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
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border:
                            Border.all(color: Colors.black, width: 1), // Border
                      ),
                      child: DropdownButton(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        underline: SizedBox.shrink(),
                        isExpanded: true,
                        items: studyyearData.map((e) {
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
                        value: _valueSyear,
                        onChanged: (v) {
                          setState(() {
                            _valueSyear = v as int;
                          });
                        },
                        hint: Text(
                          "ປີຮຽນ",
                          style: TextStyle(
                            fontFamily: 'Phetsarath',
                          ),
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
                        border:
                            Border.all(color: Colors.black, width: 1), // Border
                      ),
                      child: DropdownButton(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        underline: SizedBox.shrink(),
                        isExpanded: true,
                        items: statuSData.map((e) {
                          return DropdownMenuItem(
                            child: Text(
                              e["status"],
                              style: TextStyle(
                                fontFamily: 'Phetsarath',
                              ),
                            ),
                            value: e["statusID"],
                          );
                        }).toList(),
                        value: _valueStatuS,
                        onChanged: (v) {
                          setState(() {
                            _valueStatuS = v as int;
                          });
                        },
                        hint: Text(
                          "ສະຖານະ",
                          style: TextStyle(
                            fontFamily: 'Phetsarath',
                          ),
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
                        border:
                            Border.all(color: Colors.black, width: 1), // Border
                      ),
                      child: DropdownButton(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        underline: SizedBox.shrink(),
                        isExpanded: true,
                        items: yearData.map((e) {
                          return DropdownMenuItem(
                            child: Text(
                              e["yearOf"],
                              style: TextStyle(
                                fontFamily: 'Phetsarath',
                              ),
                            ),
                            value: e["yearS_id"],
                          );
                        }).toList(),
                        value: _valueYear,
                        onChanged: (v) {
                          setState(() {
                            _valueYear = v as int;
                          });
                        },
                        hint: Text(
                          "ສົກຮຽນ",
                          style: TextStyle(
                            fontFamily: 'Phetsarath',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredStudents.length,
                  itemBuilder: (context, index) {
                    final student = filteredStudents[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Spacer(),
                            Column(
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '${student['stdID']}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.blueAccent,
                                    fontFamily: 'Phetsarath',
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '${student['stdName']}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        fontFamily: 'Phetsarath',
                                      ),
                                    ),
                                    Text(
                                      ' ${student['stdSurname']}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        fontFamily: 'Phetsarath',
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '${student['Syear']}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    fontFamily: 'Phetsarath',
                                    color: student['SyearID'] == 1
                                        ? Colors
                                            .green // ถ้า ID เป็น 1 ให้เป็นสีเขียว
                                        : student['SyearID'] == 2
                                            ? Colors
                                                .deepPurple // ถ้า ID เป็น 2 ให้เป็นสีเหลือง
                                            : student['SyearID'] == 3
                                                ? Colors
                                                    .orange // ถ้า ID เป็น 3 ให้เป็นสีแดง
                                                : Colors
                                                    .black, // กรณีอื่น ๆ (เช่นไม่มีค่าตรงกับเงื่อนไข) ให้เป็นสีดำ
                                  ),
                                ),
                                Text(
                                  '${student['status']}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    fontFamily: 'Phetsarath',
                                    color: student['statusID'] == 1
                                        ? Colors.orange
                                        : student['statusID'] == 2
                                            ? Colors.green
                                            : student['statusID'] == 3
                                                ? Colors.brown
                                                : student['statusID'] == 4
                                                    ? Colors.red
                                                    : Colors
                                                        .black, // กรณีอื่น ๆ (เช่นไม่มีค่าตรงกับเงื่อนไข) ให้เป็นสีดำ
                                  ),
                                ),
                                Text(
                                  'ສົກຮຽນ ${student['yearOf']}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Phetsarath',
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            PopupMenuButton(
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'ປຸ່ມຄຳສັ່ງ:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Phetsarath',
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      ElevatedButton(
                                        onPressed: () async {
                                          bool? result = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EditStudentPage(
                                                stdID: student['stdID'],
                                                stdName: student['stdName'],
                                                stdSurname:
                                                    student['stdSurname'],
                                                dob: student['dob'],
                                                currentOpt: student['gender'],
                                                village: student['village'],
                                                dsid: student['dsid'],
                                                villageOfB:
                                                    student['villageOfB'],
                                                dsBid: student['dsBid'],
                                                phoneNum: student['phoneNum'],
                                                email: student['email'],
                                                mid: student['mid'],
                                                classID: student['classID'],
                                                sem_id: student['sem_id'],
                                                yearS_id: student['yearS_id'],
                                                statusID: student['statusID'],
                                              ),
                                            ),
                                          );
                                          if (result == true) {
                                            fetchStudents();
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            Icon(Icons.edit,
                                                color: Color(0xFF345FB4)),
                                            Text(
                                              'ແກ້ໄຂ',
                                              style: TextStyle(
                                                color: Color(0xFF345FB4),
                                                fontFamily: 'Phetsarath',
                                              ),
                                            ),
                                          ],
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          minimumSize: Size(
                                            80,
                                            50,
                                          ), // ປັບຂະໜາດ (ກວ້າງ x ສູງ)
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 12,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
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
