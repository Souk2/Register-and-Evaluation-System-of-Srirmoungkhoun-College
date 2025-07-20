//import 'package:appbasic/screens/AddUnitScreen.dart';

// import 'package:flutter/foundation.dart';
// import 'dart:convert';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:registration_evaluation_app/screens/academic/managements/subjects/addSubjectPage.dart';
import 'package:registration_evaluation_app/screens/academic/managements/subjects/editSubjectPage.dart';
import 'package:registration_evaluation_app/services/SubjectsService.dart';
import 'package:http/http.dart' as http;

// import 'package:http/http.dart' as http;

class SubjectPage extends StatefulWidget {
  const SubjectPage({super.key});

  @override
  State<SubjectPage> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  List<dynamic> subjects = [];

  TextEditingController _searchController = TextEditingController();

  List<dynamic> sYearData = []; // use from dropdownbutton
  int? _valueSyear; // use from dropdownbutton

  List<dynamic> majorData = []; // use from dropdownbutton
  int? _valueMajor; // use from dropdownbutton

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    fetchSubjects();
    _fetchAllDropdownData();
  }

  void fetchSearchSubjects({String? searchQuery}) async {
    try {
      final fetchedSubjects = searchQuery == null || searchQuery.isEmpty
          ? await Subjectsservice.getSubjects()
          : await Subjectsservice.searchSubjects(searchQuery);
      setState(() {
        subjects = fetchedSubjects;
      });
    } catch (e) {
      print("Error:$e");
    }
  }

  void fetchSubjects() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final fetchedSubjects = await Subjectsservice.getSubjects();
      setState(() {
        subjects = fetchedSubjects;
      });
    } catch (e) {
      print("Error: $e");
    }

    setState(() {
      _isLoading = false;
    });
  }

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

  List<dynamic> get filteredSubject {
    return subjects.where((subject) {
      final matchesSyear =
          _valueSyear == null || subject['SyearID'] == _valueSyear;
      final matchesMajor = _valueMajor == null || subject['mid'] == _valueMajor;
      return matchesMajor && matchesSyear;
    }).toList();
  }

  void showAlert() {
    QuickAlert.show(
      context: context,
      title: "ການປ່ຽນແປງສຳເລັດ",
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
          'ຈັດການວິຊາຮຽນ',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Phetsarath',
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Container(
            height: 40,
            margin: EdgeInsets.all(10),
            child: TextField(
              controller: _searchController,
              style: TextStyle(
                fontFamily: 'Phetsarath',
              ),
              decoration: InputDecoration(
                hintText: 'ຄົ້ນຫາວິຊາ...',
                hintStyle: TextStyle(
                  fontFamily: 'Phetsarath',
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    fetchSearchSubjects(searchQuery: _searchController.text);
                  },
                ),
              ),
            ),
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
                  pageBuilder: (a, b, c) => SubjectPage(), // โหลดหน้าใหม่ทับ
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
      ),
      body: Column(
        children: [
          SizedBox(height: 15),
          Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black, width: 1), // Border
                  ),
                  child: DropdownButton(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    underline: SizedBox.shrink(),
                    borderRadius: BorderRadius.circular(20),
                    isExpanded: true,
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
                    border: Border.all(color: Colors.black, width: 1), // Border
                  ),
                  child: DropdownButton(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    underline: SizedBox.shrink(),
                    borderRadius: BorderRadius.circular(20),
                    isExpanded: true,
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
                    value: _valueMajor,
                    onChanged: (v) {
                      setState(() {
                        _valueMajor = v as int;
                      });
                    },
                    hint: Text(
                      "ສາຂາ",
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
            ],
          ),
          SizedBox(height: 15),
          Row(
            children: [
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddSubjectPage(),
                      ),
                    ).then((value) {
                      // This code will execute when PageB is popped.
                      // You can call setState() here to refresh PageA.
                      setState(() {
                        // For example, refetch data
                        fetchSubjects();
                      });
                    }),
                  }, // Opens the book entry dialog
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: Colors.white),
                      Text(
                        'ເພີ່ມວິຊາຮຽນ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Phetsarath',
                        ),
                      ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                    backgroundColor: Color(0xFFfb5b54),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
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
                : filteredSubject.isEmpty
                    ? Center(
                        child: Text(
                          "!ບໍ່ພົບຂໍ້ມູນ ຫຼື ຂາດການເຊື່ອມຕໍ່!",
                          style: TextStyle(
                            fontFamily: 'Phetsarath',
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredSubject.length,
                        itemBuilder: (context, index) {
                          final Subject = filteredSubject[index];
                          return Card(
                            margin: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(10),
                                splashColor: Colors.blueAccent
                                    .withOpacity(0.3), // สีของ ripple effect
                                // hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  bool? result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditSubjectPage(
                                        sub_id: Subject['sub_id'],
                                        sub_Name: Subject['sub_Name'],
                                        sYearID: Subject['SyearID'],
                                        mid: Subject['mid'],
                                      ),
                                    ),
                                  );
                                  if (result == true) {
                                    // It would be refresh the informations in this Page
                                    setState(() {
                                      fetchSubjects();
                                    });
                                  }
                                },
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Spacer(),
                                    Column(
                                      // crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${Subject['sub_Name']}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            fontFamily: 'Phetsarath',
                                          ),
                                        ),
                                        Text(
                                          '${Subject['Syear']}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            fontFamily: 'Phetsarath',
                                            color: Subject['SyearID'] == 1
                                                ? Colors
                                                    .green // ถ้า ID เป็น 1 ให้เป็นสีเขียว
                                                : Subject['SyearID'] == 2
                                                    ? Colors
                                                        .deepPurple // ถ้า ID เป็น 2 ให้เป็นสีเหลือง
                                                    : Subject['SyearID'] == 3
                                                        ? Colors
                                                            .orange // ถ้า ID เป็น 3 ให้เป็นสีแดง
                                                        : Colors
                                                            .black, // กรณีอื่น ๆ (เช่นไม่มีค่าตรงกับเงื่อนไข) ให้เป็นสีดำ
                                          ),
                                        ),
                                        Text(
                                          '${Subject['m_name']}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
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
    );
  }
}
