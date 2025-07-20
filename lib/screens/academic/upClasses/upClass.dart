import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:registration_evaluation_app/services/StudentService.dart';

class UpClass extends StatefulWidget {
  const UpClass({super.key});

  @override
  State<UpClass> createState() => _UpClassState();
}

class _UpClassState extends State<UpClass> {
  List<dynamic> students = [];

  //ປີຮຽນ
  List<dynamic> studyyearData = []; // use from dropdownbutton
  int? _valueSyear; // use from dropdownbutton

  //ສະຖານະການຮຽນ
  List<dynamic> statuSData = []; // use from dropdownbutton
  int? _valueStatuS; // use from dropdownbutton

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
          ? await Studentservice.getStudentsAll()
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
        http.get(Uri.parse("$baseUrl/staS")),
        // เพิ่ม API ตัวอื่นๆ ได้ตามต้องการ
      ];

      // 2. ใช้ Future.wait เพื่อรอให้ทุก API call เสร็จสิ้นพร้อมกัน
      List<http.Response> responses = await Future.wait(futures);

      // 3. ตรวจสอบและประมวลผลข้อมูลจากแต่ละ API

      //ປີຮຽນ
      if (responses[0].statusCode == 200) {
        studyyearData = jsonDecode(responses[0].body);
        print('ປີຮຽນ data loaded: ${studyyearData.length} items');
      } else {
        throw Exception(
            'Failed to load provinces data: ${responses[0].statusCode}');
      }

      //ສະຖານະການຮຽນ
      if (responses[1].statusCode == 200) {
        statuSData = jsonDecode(responses[1].body);
        print('ສະຖານະການຮຽນ data loaded: ${statuSData.length} items');
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
        //   _errorMessage = 'An unexpected error occurred: $error';
      });
      print('Error fetching all dropdown data: $error');
    }
  }

  List<dynamic> get filteredStudents {
    return students.where((student) {
      final matchesStatus =
          _valueStatuS == null || student['statusID'] == _valueStatuS;
      final matchesSyear =
          _valueSyear == null || student['SyearID'] == _valueSyear;
      return matchesSyear && matchesStatus;
    }).toList();
  }

  Future<void> updateStudentsToNextYear() async {
    for (var student in filteredStudents) {
      final currentSyearID = student['SyearID'] as int;
      final currentyearSID = student['yearS_id'] as int;
      int? newSyearID;
      int newStatus = 1;
      int? newYearSID;
      int? newPayID;
      int? newRegisID;

      // เช็คสถานะ ถ้าเป็น "ดรอปเรียน" ให้ข้ามไป
      if (student['statusID'] == 3 || student['statusID'] == 4) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'ນັກສຶກສາຄົນນີ້ໄດ້ໂຈະ ຫຼື ອອກຮຽນແລ້ວ!',
              style: TextStyle(fontFamily: 'Phetsarath'),
            ),
            backgroundColor: Colors.red,
          ),
        );
        print('ข้ามนักเรียน ${student['stdID']} เพราะสถานะคือ ดรอปเรียน');
        continue;
      } else if (student['statusID'] == 2) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'ນັກສຶກສາຄົນນີ້ໄດ້ຈົບການສຶກສາແລ້ວ!',
              style: TextStyle(fontFamily: 'Phetsarath'),
            ),
            backgroundColor: Colors.orange,
          ),
        );
        continue;
      } else {
        // ถ้าเรียนถึงชั้น 3 แล้ว ให้เปลี่ยนเป็น "เรียนจบแล้ว"
        if (currentSyearID >= 3) {
          newSyearID = currentSyearID; // ไม่ต้องเปลี่ยนชั้น
          newYearSID = currentyearSID;
          newPayID = 1;
          newStatus = 2;
        } else {
          // บวกชั้นเรียนขึ้น 1
          newSyearID = currentSyearID + 1;
          newYearSID = currentyearSID + 1;
          newPayID = 3;
          newRegisID = 2;
        }

        try {
          final response = await http.put(
            Uri.parse('$baseUrl/std/updateSyear/${student['stdID']}'),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "SyearID": newSyearID,
              "status": newStatus,
              "yearS_id": newYearSID,
              "paySt_ID": newPayID,
              "regis_id": newRegisID,
            }),
          );

          if (response.statusCode != 200) {
            print('Update failed for ${student['stdID']}: ${response.body}');
          }
        } catch (e) {
          print('Error updating student ${student['stdID']}: $e');
        }

        fetchStudents(); // โหลดข้อมูลใหม่หลังจากอัปเดต
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'ເລື່ອນຊັ້ນຮຽນສຳເລັດ!',
              style: TextStyle(fontFamily: 'Phetsarath'),
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  void _showUpdateEvaDialog() async {
    if (_valueStatuS == null) {
      // ตรวจสอบว่าทั้งสอง Dropdown ถูกเลือกแล้วหรือยัง
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'ກະລຸນາເລືອກສະຖານະກ່ອນ!',
            style: TextStyle(fontFamily: 'Phetsarath'),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'ເລື່ອນຊັ້ນຮຽນ',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Phetsarath',
              fontWeight: FontWeight.bold,
            ),
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                child: Text(
                  "ທ່ານແນ່ໃຈແລ້ວບໍທີ່ຈະເລື່ອນຊັ້ນຮຽນ?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Phetsarath',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
          actions: [
            Container(
              width: 75,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'ຍົກເລີກ',
                  style: TextStyle(
                    fontFamily: 'Phetsarath',
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
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
              onPressed: () async {
                Navigator.of(context).pop(); // ปิด dialog
                await updateStudentsToNextYear(); // เรียกฟังก์ชันใหม่
              },
              child: Text(
                'ບັນທຶກ',
                style: TextStyle(
                  fontFamily: 'Phetsarath',
                  color: Colors.white,
                ),
              ),
            )
          ],
        );
      },
    );
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
          "ເລື່ອນຊັ້ນຮຽນ",
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
                  pageBuilder: (a, b, c) => UpClass(), // โหลดหน้าใหม่ทับ
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
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: Size(
                          80,
                          65,
                        ), // ປັບຂະໜາດ (ກວ້າງ x ສູງ)
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () {
                        _showUpdateEvaDialog();
                      },
                      child: Text(
                        "ເລື່ອນຊັ້ນ",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: 'Phetsarath',
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
                        borderRadius: BorderRadius.circular(20),
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
                        borderRadius: BorderRadius.circular(20),
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
                ],
              ),
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
                    : filteredStudents.isEmpty
                        ? Center(
                            child: Text(
                              "!ບໍ່ພົບຂໍ້ມູນ ຫຼື ຂາດການເຊື່ອມຕໍ່!",
                              style: TextStyle(
                                fontFamily: 'Phetsarath',
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: filteredStudents.length,
                            itemBuilder: (context, index) {
                              final student = filteredStudents[index];
                              return Card(
                                margin: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                child: Padding(
                                  padding: const EdgeInsets.all(6),
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
                                          if (student['image_url'] != null)
                                            Center(
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.network(
                                                  student['image_url'],
                                                  width: 120,
                                                  height: 120,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error,
                                                          stackTrace) =>
                                                      Icon(Icons.error),
                                                ),
                                              ),
                                            ),
                                          SizedBox(
                                            height: 10,
                                          ),
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
                                              fontSize: 20,
                                              fontFamily: 'Phetsarath',
                                            ),
                                          ),
                                          Text(
                                            'ສົກຮຽນ ${student['yearOf']}',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontFamily: 'Phetsarath',
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
                                                          : student['statusID'] ==
                                                                  4
                                                              ? Colors.red
                                                              : Colors
                                                                  .black, // กรณีอื่น ๆ (เช่นไม่มีค่าตรงกับเงื่อนไข) ให้เป็นสีดำ
                                            ),
                                          ),
                                        ],
                                      ),
                                      Spacer(),
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
