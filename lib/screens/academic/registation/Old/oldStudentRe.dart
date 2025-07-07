import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';
import 'package:registration_evaluation_app/screens/academic/registation/Old/chkstudentR.dart';
import 'package:registration_evaluation_app/screens/academic/registation/Old/editOldStudentRe.dart';
import 'package:registration_evaluation_app/services/StudentService.dart';

class OldStudentRe extends StatefulWidget {
  const OldStudentRe({super.key});

  @override
  State<OldStudentRe> createState() => _OldStudentReState();
}

class _OldStudentReState extends State<OldStudentRe> {
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

  //ລົງທະບຽນ ຫຼື ຫຍັງ??
  List<dynamic> regisData = []; // use from dropdownbutton
  int? _valueRegis; // use from dropdownbutton

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

  static const String baseUrl = "http://10.34.64.243:3000";

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
        http.get(Uri.parse("$baseUrl/regisSt")),
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

      //ລົງທະບຽນ ຫຼື ຫຍັງ??
      if (responses[3].statusCode == 200) {
        regisData = jsonDecode(responses[3].body);
        print('ສົກຮຽນ data loaded: ${regisData.length} items');
      } else {
        throw Exception(
            'Failed to load provinces data: ${responses[3].statusCode}');
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
      // เพิ่มเงื่อนไข SyearID >= 2 เข้าไป
      final matchesSyearIDGreaterThanOrEqualToTwo = student['SyearID'] >= 2;
      final matchesSyear =
          _valueSyear == null || student['SyearID'] == _valueSyear;
      final matchesYear =
          _valueYear == null || student['yearS_id'] == _valueYear;
      final matchesStatusS =
          _valueStatuS == null || student['statusID'] == _valueStatuS;
      final matchesRegis = student['regis_id'] == 2;

      //ສົ່ງຄ່າກັບຄືນເພື່ອເຮັດການຕອງຂໍ້ມູນ
      return matchesSyearIDGreaterThanOrEqualToTwo &&
          matchesSyear &&
          matchesYear &&
          matchesStatusS &&
          matchesRegis;
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
          "ລົງທະບຽນນັກສຶກສາເກົ່າ",
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
                  pageBuilder: (a, b, c) => OldStudentRe(), // โหลดหน้าใหม่ทับ
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
                        borderRadius: BorderRadius.circular(20),
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
                        borderRadius: BorderRadius.circular(20),
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
                        borderRadius: BorderRadius.circular(20),
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
                height: 10,
              ),
              SizedBox(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => ChkStudentRe()));
                    print("ບັນທຶກການຂໍ້ມູນນັກສຶກສາສຳເລັດ");
                  },
                  // onPressed: _submitDistrict,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.playlist_add_check_circle,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'ກວດສອບນັກສຶກສາທີ່ລົງທະບຽນແລ້ວ',
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
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(10),
                                    splashColor: Colors.blueAccent.withOpacity(
                                        0.3), // สีของ ripple effect
                                    // hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      bool? result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditOldStudentRe(
                                            stdID: student['stdID'],
                                            image_url: student['image_url'],
                                            stdName: student['stdName'],
                                            stdSurname: student['stdSurname'],
                                            dob: student['dob'],
                                            currentOpt: student['gender'],
                                            village: student['village'],
                                            dsid: student['dsid'],
                                            villageOfB: student['villageOfB'],
                                            dsBid: student['dsBid'],
                                            phoneNum: student['phoneNum'],
                                            email: student['email'],
                                            mid: student['mid'],
                                            classID: student['classID'],
                                            sem_id: student['sem_id'],
                                            yearS_id: student['yearS_id'],
                                            statusID: student['statusID'],
                                            sYearID: student['SyearID'],
                                          ),
                                        ),
                                      );
                                      if (result == true) {
                                        // If PageB signals a refresh
                                        setState(() {
                                          fetchStudents(); // Refresh PageA
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
                                              '${student['stdID']}',
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
                                                  '${student['stdName']}',
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
                                                  ' ${student['stdSurname']}',
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
                                              '${student['Syear']}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.048,
                                                fontFamily: 'Phetsarath',
                                                color: student['SyearID'] == 1
                                                    ? Colors
                                                        .green // ถ้า ID เป็น 1 ให้เป็นสีเขียว
                                                    : student['SyearID'] == 2
                                                        ? Colors
                                                            .deepPurple // ถ้า ID เป็น 2 ให้เป็นสีเหลือง
                                                        : student['SyearID'] ==
                                                                3
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
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.048,
                                                fontFamily: 'Phetsarath',
                                              ),
                                            ),
                                            Text(
                                              '${student['register']}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.048,
                                                fontFamily: 'Phetsarath',
                                                color: student['regis_id'] == 1
                                                    ? Colors.green
                                                    : student['regis_id'] == 2
                                                        ? Colors.red
                                                        : Colors
                                                            .black, // กรณีอื่น ๆ (เช่นไม่มีค่าตรงกับเงื่อนไข) ให้เป็นสีดำ
                                              ),
                                            ),
                                            Text(
                                              'ສົກຮຽນ ${student['yearOf']}',
                                              style: TextStyle(
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
                                        PopupMenuButton(
                                          itemBuilder: (context) => [
                                            PopupMenuItem(
                                              child: Center(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'ປຸ່ມຄຳສັ່ງ:',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily:
                                                            'Phetsarath',
                                                      ),
                                                    ),
                                                    SizedBox(height: 5),
                                                    ElevatedButton(
                                                      onPressed: () async {
                                                        Navigator.of(context)
                                                            .pop(true);
                                                        bool? result =
                                                            await Navigator
                                                                .push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                EditOldStudentRe(
                                                              stdID: student[
                                                                  'stdID'],
                                                              image_url: student[
                                                                  'image_url'],
                                                              stdName: student[
                                                                  'stdName'],
                                                              stdSurname: student[
                                                                  'stdSurname'],
                                                              dob: student[
                                                                  'dob'],
                                                              currentOpt:
                                                                  student[
                                                                      'gender'],
                                                              village: student[
                                                                  'village'],
                                                              dsid: student[
                                                                  'dsid'],
                                                              villageOfB: student[
                                                                  'villageOfB'],
                                                              dsBid: student[
                                                                  'dsBid'],
                                                              phoneNum: student[
                                                                  'phoneNum'],
                                                              email: student[
                                                                  'email'],
                                                              mid: student[
                                                                  'mid'],
                                                              classID: student[
                                                                  'classID'],
                                                              sem_id: student[
                                                                  'sem_id'],
                                                              yearS_id: student[
                                                                  'yearS_id'],
                                                              statusID: student[
                                                                  'statusID'],
                                                              sYearID: student[
                                                                  'SyearID'],
                                                            ),
                                                          ),
                                                        );
                                                        if (result == true) {
                                                          // If PageB signals a refresh
                                                          setState(() {
                                                            fetchStudents(); // Refresh PageA
                                                          });
                                                        }
                                                      },
                                                      child: Icon(
                                                        Icons.edit,
                                                        color: Colors.white,
                                                      ),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Colors.green,
                                                        minimumSize: Size(
                                                          80,
                                                          50,
                                                        ), // ປັບຂະໜາດ (ກວ້າງ x ສູງ)
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          horizontal: 16,
                                                          vertical: 12,
                                                        ),
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
