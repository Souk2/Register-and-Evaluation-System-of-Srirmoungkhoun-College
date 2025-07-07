import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';
import 'package:registration_evaluation_app/screens/academic/managements/employees/financeInfo.dart/editFinanceInfoPage.dart';
import 'package:registration_evaluation_app/screens/academic/payments/editPaymentPage.dart';
import 'package:registration_evaluation_app/services/EmployeesService.dart';
import 'package:registration_evaluation_app/services/StudentService.dart';

class FinanceInfoPage extends StatefulWidget {
  const FinanceInfoPage({super.key});

  @override
  State<FinanceInfoPage> createState() => _FinanceInfoPageState();
}

class _FinanceInfoPageState extends State<FinanceInfoPage> {
  static const String baseUrl = "http://192.168.0.104:3000";

  List<dynamic> finances = [];

  TextEditingController _searchController = TextEditingController();

  // bool _isLoadings = true; //ເພື່ອເຮັດໜ້າ spinner ໂລດ

  bool _isLoading = false;

  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // _fetchAllDropdownData(); // Call the data fetching function when the widget is created
    fetchFinances();
  }

  void fetchSearchFinances({String? searchQuery}) async {
    try {
      final fetchFinances = searchQuery == null || searchQuery.isEmpty
          ? await Employeesservice.getEmployees()
          : await Employeesservice.searchEmployees(searchQuery);
      print(searchQuery);
      setState(() {
        finances = fetchFinances;
      });
    } catch (e) {
      print("Error:$e");
    }
  }

  void fetchFinances() async {
    try {
      final fetchfinances = await Employeesservice.getEmployees();
      setState(() {
        finances = fetchfinances;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  // Future<void> _fetchAllDropdownData() async {
  //   setState(() {
  //     _isLoading = true;
  //     _errorMessage = null;
  //   });

  //   try {
  //     // 1. สร้าง List ของ Future สำหรับแต่ละ API call
  //     List<Future<http.Response>> futures = [
  //       http.get(Uri.parse("$baseUrl/payS")),
  //       http.get(Uri.parse("$baseUrl/syear")),
  //       http.get(Uri.parse("$baseUrl/yearstd")),
  //       // เพิ่ม API ตัวอื่นๆ ได้ตามต้องการ
  //     ];

  //     // 2. ใช้ Future.wait เพื่อรอให้ทุก API call เสร็จสิ้นพร้อมกัน
  //     List<http.Response> responses = await Future.wait(futures);

  //     // 3. ตรวจสอบและประมวลผลข้อมูลจากแต่ละ API
  //     //ການຈ່າຍ
  //     if (responses[0].statusCode == 200) {
  //       payStatusData = jsonDecode(responses[0].body);
  //       print('ການຈ່າຍ data loaded: ${payStatusData.length} items');
  //     } else {
  //       throw Exception(
  //           'Failed to load provinces data: ${responses[0].statusCode}');
  //     }

  //     //ປີຮຽນ
  //     if (responses[1].statusCode == 200) {
  //       studyyearData = jsonDecode(responses[1].body);
  //       print('ປີຮຽນ data loaded: ${studyyearData.length} items');
  //     } else {
  //       throw Exception(
  //           'Failed to load provinces data: ${responses[1].statusCode}');
  //     }

  //     //ສົກຮຽນ
  //     if (responses[2].statusCode == 200) {
  //       yearData = jsonDecode(responses[2].body);
  //       print('ສົກຮຽນ data loaded: ${yearData.length} items');
  //     } else {
  //       throw Exception(
  //           'Failed to load provinces data: ${responses[2].statusCode}');
  //     }

  //     // 4. อัปเดต UI หลังจากข้อมูลทั้งหมดโหลดเสร็จสมบูรณ์
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   } catch (error) {
  //     setState(() {
  //       _isLoading = false;
  //       _errorMessage = 'An unexpected error occurred: $error';
  //     });
  //     print('Error fetching all dropdown data: $error');
  //   }
  // }

  List<dynamic> get filteredFinances {
    return finances.where((teacher) {
      final matchesTeacher = teacher['roleID'] == 4;
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
          "ຈັດການນັການເງິນ",
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
                  pageBuilder: (a, b, c) =>
                      FinanceInfoPage(), // โหลดหน้าใหม่ทับ
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
                    fetchSearchFinances(searchQuery: _searchController.text);
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
                    : finances.isEmpty
                        ? Center(
                            child: Text(
                              "!ບໍ່ພົບຂໍ້ມູນ ຫຼື ຂາດການເຊື່ອມຕໍ່!",
                              style: TextStyle(
                                fontFamily: 'Phetsarath',
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: filteredFinances.length,
                            itemBuilder: (context, index) {
                              final teacher = filteredFinances[index];
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
                                      bool? result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditFinanceInfoPage(
                                            staff_id: teacher['staff_id'],
                                            image_url: teacher['image_url'],
                                            staff_Name: teacher['staff_Name'],
                                            staff_Surname:
                                                teacher['staff_Surname'],
                                            dob: teacher['dob'],
                                            currentOpt: teacher['gender'],
                                            village: teacher['village'],
                                            dsid: teacher['dsid'],
                                            phoneNum: teacher['phoneNum'],
                                            email: teacher['email'],
                                            roleID: teacher['roleID'],
                                          ),
                                        ),
                                      );
                                      if (result == true) {
                                        // If PageB signals a refresh
                                        setState(() {
                                          fetchFinances(); // Refresh PageA
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
                                              '${teacher['rolename']}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.048,
                                                fontFamily: 'Phetsarath',
                                                color: teacher['roleID'] == 1
                                                    ? Colors
                                                        .blue // ถ้า ID เป็น 1 ให้เป็นสีเขียว
                                                    : teacher['roleID'] == 2
                                                        ? Colors
                                                            .green // ถ้า ID เป็น 2 ให้เป็นสีเหลือง
                                                        : teacher['roleID'] == 3
                                                            ? Colors
                                                                .purple // ถ้า ID เป็น 3 ให้เป็นสีแดง
                                                            : teacher['roleID'] ==
                                                                    4
                                                                ? Colors.amber
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
