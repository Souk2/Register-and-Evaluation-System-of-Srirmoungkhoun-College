import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';
import 'package:registration_evaluation_app/screens/academic/academicScreen.dart';
import 'package:registration_evaluation_app/screens/academic/managements/students/studentPage.dart';
import 'package:registration_evaluation_app/services/RegistrationService.dart';
import 'package:registration_evaluation_app/services/StudentService.dart';

class EditOldStudentRe extends StatefulWidget {
  final String stdID;
  final String stdName;
  final String stdSurname;
  final String dob;
  final String currentOpt;
  final String village;
  final int dsid;
  final String villageOfB;
  final int dsBid;
  final String phoneNum;
  final String email;
  final int mid;
  final int classID;
  final int sem_id;
  final int yearS_id;
  final int statusID;
  final int sYearID;
  const EditOldStudentRe({
    super.key,
    required this.stdID,
    required this.stdName,
    required this.stdSurname,
    required this.dob,
    required this.currentOpt,
    required this.village,
    required this.dsid,
    required this.villageOfB,
    required this.dsBid,
    required this.phoneNum,
    required this.email,
    required this.mid,
    required this.classID,
    required this.sem_id,
    required this.yearS_id,
    required this.statusID,
    required this.sYearID,
  });

  @override
  State<EditOldStudentRe> createState() => _EditOldStudentReState();
}

class _EditOldStudentReState extends State<EditOldStudentRe> {
  final _formKey = GlobalKey<FormState>();

  //ໃຊ້ເພື່່ອບອກສະຖານະການລົງທະບຽນວ່າຮຽນແລ້ວ
  int regisID = 1;

  //ຫ້ອງຮຽນ
  List<dynamic> classData = [];
  int? _valueClass;

  //ພາກຮຽນ
  List<dynamic> semData = [];
  int? _valueSem;

  bool _isLoading = false;
  String? _errorMessage;

  // ดึงข้อมูล term ที่จ่ายแล้ว
  List<String> paidTerms = [];
  List<String> availableTerms = ['1', '2'];

  // ตัวแปรสำหรับเก็บค่าที่เลือกจาก DropdownButton ໃຊ້ເພື່ອເລືອກຄ່າເທີມ
  Map<String, dynamic>? selectedStudent;
  String? selectedTerm;
  // เพิ่มไว้ด้านบนใน State class
  bool payFullYear = false;
  final amountPaidController = TextEditingController(); //ເກັບຈຳນວນເງິນ
  // MoneyFieldPage(controller: amountPaidController),
  Map<String, dynamic>? paymentInfo; // จากตาราง payment
  int? studentSyearID; // ดึงจาก DB หรือตัวแปรที่มีอยู่แล้ว

  // Controller สำหรับ TextFormField
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchData();
    _stdID.text = widget.stdID;
    _name.text = widget.stdName;
    _surname.text = widget.stdSurname;

    // ✅ ดึงข้อมูลนักเรียนทันทีเมื่อเปิดหน้า
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchStudentInfo();
    });
  }

  static const String baseUrl = "http://192.168.0.104:3000";

  // ພາກສ່ວນໃນການດຶງຂໍ້ມູນ DropDown ຕ່າງໆ ຂຶິນມາສະແດງ
  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final resClasses = await http.get(Uri.parse("$baseUrl/class"));
      final resSemesters = await http.get(Uri.parse("$baseUrl/sem"));
      final resYears = await http.get(Uri.parse("$baseUrl/yearstd"));
      final resStatusSt = await http.get(Uri.parse("$baseUrl/staS"));
      final resStudyYear = await http.get(Uri.parse("$baseUrl/syear"));

      if (resClasses.statusCode == 200 &&
          resSemesters.statusCode == 200 &&
          resYears.statusCode == 200 &&
          resStudyYear.statusCode == 200 &&
          resStatusSt.statusCode == 200) {
        final classes = jsonDecode(resClasses.body);
        final semesters = jsonDecode(resSemesters.body);

        setState(() {
          _isLoading = false;

          // ✅ Assign data lists
          classData = classes;
          semData = semesters;

          // ✅ Set initial values from widget
          _valueClass = widget.classID;
          _valueSem = widget.sem_id;
        });
      } else {
        throw Exception("One or more API failed");
      }
    } catch (error) {
      // setState(() {
      //   // _isLoading = false;
      //   _errorMessage = 'Error fetching data: $error';
      // });
      print("Error: $error");
    }
  }

  final TextEditingController _stdID = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _surname = TextEditingController();

// 🔍 ดึงข้อมูลนักเรียนจาก API
  Future<void> _fetchStudentInfo() async {
    final stdID = _stdID.text.trim();
    print(stdID);
    if (stdID.isEmpty) return;

    final response = await http.get(Uri.parse("$baseUrl/std/by-id/$stdID"));
    if (response.statusCode == 200) {
      selectedStudent = jsonDecode(response.body);
      int syearID = selectedStudent!['SyearID'];

      // ดึงข้อมูล payment ตามปี
      await _fetchPaymentInfo(syearID);

      // ดึงข้อมูล term ที่จ่ายแล้ว
      await _fetchPaidTerms();

      _updateAmountPaid();
      // setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("ไม่พบนักเรียน")),
      );
    }
  }

  // 📥 ดึงข้อมูลการชำระเงินตามปี
  Future<void> _fetchPaymentInfo(int syearID) async {
    final yearMap = {
      1: 'ປີ1',
      2: 'ປີ2',
      3: 'ປີ3',
    };
    final yearStr = yearMap[syearID];

    final response =
        await http.get(Uri.parse("$baseUrl/payment-by-year/$yearStr"));
    if (response.statusCode == 200) {
      paymentInfo = jsonDecode(response.body);
    } else {
      throw Exception("ไม่พบข้อมูลค่าเทอม");
    }
  }

  // 💰 ตั้งค่าราคาอัตโนมัติ
  void _updateAmountPaid() {
    if (paymentInfo == null) return;

    int price = 0;
    if (payFullYear) {
      price = paymentInfo!['fullPrice'];
    } else if (selectedTerm == '1') {
      price = paymentInfo!['priceTerm1'];
    } else if (selectedTerm == '2') {
      price = paymentInfo!['priceTerm2'];
    }
    print("priceTerm2: ${paymentInfo!['priceTerm2']}");

    amountPaidController.text = price.toString();
  }

  Future<void> _fetchPaidTerms() async {
    final stdID = _stdID.text.trim();
    final payID = paymentInfo!['payID'];

    final res = await http
        .get(Uri.parse("$baseUrl/student-payment/check-paid/$stdID/$payID"));
    if (res.statusCode == 200) {
      final List<dynamic> terms = jsonDecode(res.body);
      paidTerms = terms.map((t) => t.toString()).toList();

      // กรองเฉพาะ term ที่ยังไม่จ่าย
      availableTerms =
          ['1', '2'].where((term) => !paidTerms.contains(term)).toList();
      if (!availableTerms.contains(selectedTerm)) selectedTerm = null;
      // setState(() {});
    }
  }

  // 📤 ส่งข้อมูลการชำระเงินไป backend
  Future<void> _submitPayment() async {
    if (!_formKey.currentState!.validate()) return;

    if (paymentInfo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("ยังไม่ได้โหลดข้อมูลค่าเทอม")),
      );
      return;
    }

    if (!payFullYear && selectedTerm == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("กรุณาเลือกเทอม")),
      );
      return;
    }

    final stdID = _stdID.text.trim();
    final payID = paymentInfo!['payID'];

    // เตรียมรายการ payments
    final payments = [
      {
        "term": payFullYear ? '1' : selectedTerm,
        "amount_paid": int.tryParse(amountPaidController.text) ?? 0,
      },
    ];

    if (payFullYear) {
      payments.add({
        "term": "2",
        "amount_paid": paymentInfo!['priceTerm2'],
      });
    }

    final body = {
      "stdID": stdID,
      "payID": payID,
      "payments": payments,
    };

    print("ส่งข้อมูลไปยัง backend: $body");

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/student-payment"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text("สำเร็จ"),
            content: Text(
                "เลขใบเสร็จ: ${result['receipt_number']}\nรวมเงิน: ${result['total_paid']}"),
          ),
        );
      } else {
        final err = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("ผิดพลาด: ${err['message']}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("เกิดข้อผิดพลาด: $e")),
      );
    }
  }

  Future<void> _submitUpdateStudent() async {
    if (_formKey.currentState!.validate()) {
      if (_valueClass == null || _valueSem == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "ກະລຸນາເລືອກຕົວເລືອກກ່ອນ",
              style: TextStyle(
                fontFamily: 'Phetsarath',
              ),
            ), // Please select a province
            backgroundColor: Colors.orange,
          ),
        );
        return; // Stop submission if no province is selected
      }

      bool success = await Registrationservice.reOldStudents(
        _stdID.text,
        _name.text,
        _surname.text,
        _valueClass,
        _valueSem,
        regisID,
      );
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "ແກ້ໄຂຂໍ້ມູນນັກຮຽນຖືກບັນທຶກສຳເລັດແລ້ວ",
              style: TextStyle(
                fontFamily: 'Phetsarath',
              ),
            ),
            backgroundColor: Colors.green,
          ),
        );
        ////อยากให้มันย้อนกลับไปวิดเจ็ตก่อนหน้านี้
        Navigator.of(context).pop(); // ปิด dialog
        Navigator.of(context).pop(true); // ย้อนกลับไปหน้าก่อนหน้านี้

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
                if (_valueClass == null || _valueSem == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "ກະລຸນາເລືອກຕົວເລືອກກ່ອນ",
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
                  _submitUpdateStudent();

                  _submitPayment();
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
    _amountController.dispose();
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
                  "ຂໍ້ມູນນັກສຶກສາ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'Phetsarath',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _stdID,
                  readOnly: true,
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: 'ລະຫັດນັກສືກສາ',
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
                        controller: _name,
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
                        controller: _surname,
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
                  "ຫ້ອງຮຽນ ແລະ ພາກຮຽນ",
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
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: Colors.black, width: 1), // Border
                        ),
                        child: DropdownButton(
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          underline: SizedBox.shrink(),
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
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: Colors.black, width: 1), // Border
                        ),
                        child: DropdownButton(
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          underline: SizedBox.shrink(),
                          isExpanded: true,
                          items: semData.map((e) {
                            return DropdownMenuItem(
                              child: Text(
                                e["semName"],
                                style: TextStyle(
                                  fontFamily: 'Phetsarath',
                                ),
                              ),
                              value: e["semID"],
                            );
                          }).toList(),
                          value: _valueSem,
                          onChanged: (v) {
                            setState(() {
                              _valueSem = v as int;
                            });
                          },
                          hint: Text(
                            "ເລືອກພາກຮຽນ",
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
                Text(
                  "ລາຍລະອຽດການຊຳລະເງິນ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'Phetsarath',
                  ),
                ),
                // ElevatedButton(
                //   onPressed: _fetchStudentInfo,
                //   child: Text("ตรวจสอบรหัสนักเรียน"),
                // ),
                // if (selectedStudent != null)
                SizedBox(
                  height: 20,
                ), // 🔽 เลือกเทอม
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black, width: 1), // Border
                  ),
                  child: DropdownButton<String>(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    underline: SizedBox.shrink(),
                    isExpanded: true,
                    value: selectedTerm,
                    hint: Text(
                      "ເລືອກເທີມ",
                      style: TextStyle(fontFamily: 'Phetsarath'),
                    ),
                    items: availableTerms.map((term) {
                      return DropdownMenuItem(
                        value: term,
                        child: Text("ເທີມ $term",
                            style: TextStyle(fontFamily: 'Phetsarath')),
                      );
                    }).toList(),
                    onChanged: (val) {
                      selectedTerm = val;
                      payFullYear = false;
                      _updateAmountPaid();
                      setState(() {});
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),

                // ☑️ จ่ายทั้งปี
                CheckboxListTile(
                  value: payFullYear,
                  onChanged: (val) {
                    payFullYear = val!;
                    selectedTerm = null;
                    _updateAmountPaid();
                    setState(() {});
                  },
                  title: Text(
                    "ຈ່າຍທັ້ງປີການສຶກສາ (2 ເທີມ)",
                    style: TextStyle(
                      fontFamily: 'Phetsarath',
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),

                // 💰 แสดงจำนวนเงินที่ต้องจ่าย
                TextFormField(
                  controller: amountPaidController,
                  keyboardType: TextInputType.number,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'ຈຳນວນເງິນທີ່ຕ້ອງຊຳລະ',
                    labelStyle: TextStyle(
                      fontFamily: 'Phetsarath',
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (val) => val == null || val.trim().isEmpty
                      ? 'ກະລຸນາລະບຸຈຳນວນເງິນ'
                      : null,
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
