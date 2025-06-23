import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';
import 'package:registration_evaluation_app/screens/academic/academicScreen.dart';
import 'package:registration_evaluation_app/services/RegistrationService.dart';

class NewStudent extends StatefulWidget {
  const NewStudent({super.key});

  @override
  State<NewStudent> createState() => _NewStudentState();
}

List<String> opt = ["", "Male", "Famale"];

class _NewStudentState extends State<NewStudent> {
  final _formKey = GlobalKey<FormState>();
  String currentOpt = opt[0];
  TextEditingController txtdob = TextEditingController();
  String age = "";

  //ສົກຮຽນ
  List<dynamic> yearData = []; // use from dropdownbutton
  int? _valueYear; // use from dropdownbutton

  //ທີ່ຢູ່ເກີດ
  List<dynamic> provincesBData = [];
  List<dynamic> filteredDistrictsBData = [];
  List<dynamic> districtsBData = [];
  int? _valueProB;
  int? _valueDisB;

  //ທີ່ຢູ່ປັດຈຸບັນ
  List<dynamic> provincesNData = [];
  List<dynamic> filteredDistrictsNData = [];
  List<dynamic> districtsNData = [];
  int? _valueProN;
  int? _valueDisN;

  //ສາຂາຮຽນ
  List<dynamic> majorData = [];
  int? _valueMajor;

  //ຫ້ອງຮຽນ
  List<dynamic> classData = [];
  int? _valueClass;

  //ພາກຮຽນ
  List<dynamic> semData = [];
  int? _valueSem;

  //ເລືອກການຈ່າຍ
  List<dynamic> payStatusData = [];
  int? _valuePayS;

  bool _isLoading = false;
  String? _errorMessage;

  // ตัวแปรสำหรับเก็บค่าที่เลือกจาก DropdownButton ໃຊ້ເພື່ອເລືອກຄ່າເທີມ
  String? _selectedTerm;
  // Controller สำหรับ TextFormField
  final TextEditingController _amountController = TextEditingController();
  final Map<String, String> _termAmounts = {
    'ຈ່າຍທັ້ງ 2 ເທີມ': '2,500,000.00 ກີບ', // ตัวอย่างจำนวนเงิน
    'ຈ່າຍເຄິ່ງເທີມ': '1,000,000.00 ກີບ',
  };
  @override
  void initState() {
    super.initState();
    _fetchAllDropdownData(); // Call the data fetching function when the widget is created
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
        http.get(Uri.parse("$baseUrl/yearstd")),
        http.get(Uri.parse("$baseUrl/province")),
        http.get(Uri.parse("$baseUrl/district")),
        http.get(Uri.parse("$baseUrl/major")),
        http.get(Uri.parse("$baseUrl/class")),
        http.get(Uri.parse("$baseUrl/sem")),
        http.get(Uri.parse("$baseUrl/payS")),
        http.get(Uri.parse("$baseUrl/districtofb")),
        // เพิ่ม API ตัวอื่นๆ ได้ตามต้องการ
      ];

      // 2. ใช้ Future.wait เพื่อรอให้ทุก API call เสร็จสิ้นพร้อมกัน
      List<http.Response> responses = await Future.wait(futures);

      // 3. ตรวจสอบและประมวลผลข้อมูลจากแต่ละ API
      if (responses[0].statusCode == 200) {
        yearData = jsonDecode(responses[0].body);
        print('Provinces data loaded: ${yearData.length} items');
      } else {
        throw Exception(
            'Failed to load provinces data: ${responses[0].statusCode}');
      }

      //ທີ່ຢູ່ເກີດ
      if (responses[1].statusCode == 200) {
        provincesBData = jsonDecode(responses[1].body);
        print('Districts data loaded: ${provincesBData.length} items');
      } else {
        throw Exception(
            'Failed to load districts data: ${responses[1].statusCode}');
      }

      if (responses[7].statusCode == 200) {
        districtsBData = jsonDecode(responses[7].body);
        print('Districts data loaded: ${districtsBData.length} items');
      } else {
        throw Exception(
            'Failed to load districts data: ${responses[7].statusCode}');
      }

      //ທີ່ຢູ່ປັດຈຸບັນ
      if (responses[1].statusCode == 200) {
        provincesNData = jsonDecode(responses[1].body);
        print('Districts data loaded: ${provincesNData.length} items');
      } else {
        throw Exception(
            'Failed to load districts data: ${responses[1].statusCode}');
      }

      if (responses[2].statusCode == 200) {
        districtsNData = jsonDecode(responses[2].body);
        print('Districts data loaded: ${districtsNData.length} items');
      } else {
        throw Exception(
            'Failed to load districts data: ${responses[2].statusCode}');
      }

      //ສາຂາຮຽນ
      if (responses[3].statusCode == 200) {
        majorData = jsonDecode(responses[3].body);
        print('Districts data loaded: ${majorData.length} items');
      } else {
        throw Exception(
            'Failed to load districts data: ${responses[3].statusCode}');
      }

      //ຫ້ອງຮຽນ
      if (responses[4].statusCode == 200) {
        classData = jsonDecode(responses[4].body);
        print('Districts data loaded: ${classData.length} items');
      } else {
        throw Exception(
            'Failed to load districts data: ${responses[4].statusCode}');
      }

      //ພາກຮຽນ
      if (responses[5].statusCode == 200) {
        semData = jsonDecode(responses[5].body);
        print('Districts data loaded: ${semData.length} items');
      } else {
        throw Exception(
            'Failed to load districts data: ${responses[5].statusCode}');
      }

      //ເລືອກການຈ່າຍ
      if (responses[6].statusCode == 200) {
        payStatusData = jsonDecode(responses[6].body);
        print('Districts data loaded: ${payStatusData.length} items');
      } else {
        throw Exception(
            'Failed to load districts data: ${responses[6].statusCode}');
      }

      // 4. อัปเดต UI หลังจากข้อมูลทั้งหมดโหลดเสร็จสมบูรณ์
      setState(() {
        _isLoading = false;
        //   if (provincesBData.isNotEmpty) {
        //   _valueProB = provincesBData.first["pid"]; // หรือตั้งค่าเริ่มต้นที่คุณต้องการ
        //   filteredDistrictsBData = districtsBData
        //       .where((district) => district["pid"] == _valueProB)
        //       .toList();
        // }
        // หากต้องการให้มีค่าเริ่มต้นที่เลือกไว้
        // _selectedProvinceValue = provincesBData.isNotEmpty ? provincesBData.first["pid"] : null;
        // _selectedDistrictValue = districtsBData.isNotEmpty ? districtsBData.first["did"] : null;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'An unexpected error occurred: $error';
      });
      print('Error fetching all dropdown data: $error');
    }
  }

  final _phoneController = TextEditingController();

  final TextEditingController _stdID = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _surname = TextEditingController();
  final TextEditingController _villageOB = TextEditingController();
  final TextEditingController _villageNow = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  int _statusID = 1;
  int _yearStudy = 1;

  String formatEmailForDatabase(String input) {
    // Trim spaces and ensure it's in lower case for consistency
    return input.trim().toLowerCase();
  }

  String validateEmail(String email) {
    // Regular expression to validate email
    String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regExp = RegExp(emailPattern);

    if (regExp.hasMatch(email)) {
      return email; // Return valid email
    } else {
      return ''; // Invalid email format
    }
  }

  String formatPhoneForDatabase(String input) {
    // ลบช่องว่างและขีดออกก่อนเก็บในฐานข้อมูล
    return input.replaceAll(RegExp(r'\s|-'), '');
  }

  Future<void> _submitNewStudent() async {
    if (_formKey.currentState!.validate()) {
      if (_valueYear == null ||
          _valueDisN == null ||
          _valueDisB == null ||
          _valueMajor == null ||
          _valueClass == null ||
          _valueSem == null ||
          _valueYear == null ||
          _valuePayS == null) {
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

      bool success = await Registrationservice.addStudent(
        _stdID.text,
        _name.text,
        _surname.text,
        txtdob.text,
        currentOpt,
        _villageNow.text,
        _valueDisN!,
        _villageOB.text,
        _valueDisB!,
        _phoneController.text,
        _emailController.text,
        _yearStudy,
        _valueMajor!,
        _valueClass!,
        _valueSem!,
        _valueYear!,
        _valuePayS!,
        _statusID,
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

        // _tittlecontroller.clear();
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

  void Confirm() async {
    print("Confirm");
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
                if (_valueYear == null ||
                    _valueDisN == null ||
                    _valueDisB == null ||
                    _valueMajor == null ||
                    _valueClass == null ||
                    _valueSem == null ||
                    _valueYear == null ||
                    _valuePayS == null) {
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
                  _submitNewStudent();
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
    _phoneController.dispose();
    _amountController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> selectDataOBirth() async {
    try {
      DateTime? date1 = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1990),
        lastDate: DateTime.now(),
      );

      setState(
        () {
          if (date1 != null) {
            //txtdob.text = date1.toString().split("")[0];
            txtdob.text = DateFormat("yyyy-MM-dd").format(date1);

            int d1 = int.parse(DateFormat("dd").format(date1));

            int m1 = int.parse(DateFormat("dd").format(date1));

            int y1 = int.parse(DateFormat("dd").format(date1));

            int ynow = int.parse(DateFormat("yy").format(DateTime.now()));
            int _age = DateTime.timestamp().year - date1.year;
            age = _age.toString();
            print("Age : $age ປີ");
          } else {
            txtdob.text = DateFormat("dd/MM/yyyy").format(
              DateTime.now(),
            );
          }
        },
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "ລົງທະບຽນນັກສຶກສາໃໝ່",
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
                Row(
                  children: [
                    Spacer(),
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
                Text(
                  "ປ້ອນຂໍ້ມູນນັກສຶກສາ",
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
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            Expanded(
                              // Directly Expanded within the outer Row
                              child: Container(
                                height: 50,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      // Use SizedBox here if you want to limit the width of the Radio button itself, or remove it if you want the Radio to expand.
                                      width:
                                          50, // Example: Give some fixed width to the radio to prevent it from taking too much space. Adjust as needed.
                                      child: Radio(
                                        value: opt[1],
                                        groupValue: currentOpt,
                                        onChanged: (value) {
                                          setState(
                                            () {
                                              currentOpt = value.toString();
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      // This Expanded is within its own inner Row, which is fine.
                                      child: Text(
                                        "ຊາຍ",
                                        style: TextStyle(
                                          fontFamily: 'Phetsarath',
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              // Directly Expanded within the outer Row
                              child: Container(
                                height: 50,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      // Use SizedBox here if you want to limit the width of the Radio button itself.
                                      width:
                                          50, // Example: Give some fixed width to the radio. Adjust as needed.
                                      child: Radio(
                                        value: opt[2],
                                        groupValue: currentOpt,
                                        onChanged: (value) {
                                          setState(
                                            () {
                                              currentOpt = value.toString();
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      // This Expanded is within its own inner Row, which is fine.
                                      child: Text(
                                        "ຍິງ",
                                        style: TextStyle(
                                          fontFamily: 'Phetsarath',
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextField(
                        controller: txtdob,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(
                            Icons.calendar_today,
                            size: 30,
                            color: Colors.green,
                          ),
                          labelText: "ວັນເດືອນປີເກີດ",
                          labelStyle: TextStyle(
                            fontFamily: 'Phetsarath',
                          ),
                        ),
                        readOnly: true,
                        onTap: () {
                          selectDataOBirth();
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
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
                          items: provincesBData.map((e) {
                            return DropdownMenuItem(
                              child: Text(
                                e["pname"],
                                style: TextStyle(
                                  fontFamily: 'Phetsarath',
                                ),
                              ),
                              value: e["pid"],
                            );
                          }).toList(),
                          value: _valueProB,
                          onChanged: (v) {
                            setState(() {
                              _valueProB = v as int;
                              // กรองข้อมูลอำเภอตามแขวงที่เลือก
                              filteredDistrictsBData = districtsBData
                                  .where((districtofb) =>
                                      districtofb["pid"] == _valueProB)
                                  .toList();
                              // รีเซ็ตค่าอำเภอที่เลือกเมื่อเปลี่ยนแขวง
                              _valueDisB =
                                  null; // หรือจะให้เลือกค่าแรกของอำเภอที่กรองได้ก็ได้
                            });
                          },
                          hint: Text(
                            "ແຂວງເກີດ",
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
                          items: filteredDistrictsBData.map((e) {
                            return DropdownMenuItem(
                              child: Text(
                                e["dsBName"],
                                style: TextStyle(
                                  fontFamily: 'Phetsarath',
                                ),
                              ),
                              value: e["dsBid"],
                            );
                          }).toList(),
                          value: _valueDisB,
                          onChanged: (v) {
                            setState(() {
                              _valueDisB = v as int;
                            });
                          },
                          hint: Text(
                            "ເມືອງເກີດ",
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
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: TextFormField(
                          controller: _villageOB,
                          decoration: InputDecoration(
                            labelText: 'ບ້ານເກີດ',
                            labelStyle: TextStyle(
                              fontFamily: 'Phetsarath',
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Spacer()
                  ],
                ),
                SizedBox(
                  height: 10,
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
                          items: provincesNData.map((e) {
                            return DropdownMenuItem(
                              child: Text(
                                e["pname"],
                                style: TextStyle(
                                  fontFamily: 'Phetsarath',
                                ),
                              ),
                              value: e["pid"],
                            );
                          }).toList(),
                          value: _valueProN,
                          onChanged: (v) {
                            setState(() {
                              _valueProN = v as int;
                              // กรองข้อมูลอำเภอตามแขวงที่เลือก
                              filteredDistrictsNData = districtsNData
                                  .where((district) =>
                                      district["pid"] == _valueProN)
                                  .toList();
                              // รีเซ็ตค่าอำเภอที่เลือกเมื่อเปลี่ยนแขวง
                              _valueDisN =
                                  null; // หรือจะให้เลือกค่าแรกของอำเภอที่กรองได้ก็ได้
                            });
                          },
                          hint: Text(
                            "ແຂວງປັດຈຸບັດ",
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
                          items: filteredDistrictsNData.map((e) {
                            return DropdownMenuItem(
                              child: Text(
                                e["dname"],
                                style: TextStyle(
                                  fontFamily: 'Phetsarath',
                                ),
                              ),
                              value: e["dsid"],
                            );
                          }).toList(),
                          value: _valueDisN,
                          onChanged: (v) {
                            setState(() {
                              _valueDisN = v as int;
                            });
                          },
                          hint: Text(
                            "ເມືອງ",
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
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: TextFormField(
                          controller: _villageNow,
                          decoration: InputDecoration(
                            labelText: 'ບ້ານຢູ່ປັດຈຸບັນ',
                            labelStyle: TextStyle(
                              fontFamily: 'Phetsarath',
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Spacer()
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'ອີເມວ',
                          labelStyle: TextStyle(
                            fontFamily: 'Phetsarath',
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onChanged: (value) {
                          // Automatically format email as the user types
                          String formattedEmail = formatEmailForDatabase(value);
                          _emailController.value =
                              _emailController.value.copyWith(
                            text: formattedEmail,
                            selection: TextSelection.collapsed(
                                offset: formattedEmail.length),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.number,
                        maxLength: 13,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          PhoneNumberTextInputFormatter(),
                        ],
                        decoration: InputDecoration(
                          labelText: 'ເບີໂທລະສັບ',
                          labelStyle: TextStyle(
                            fontFamily: 'Phetsarath',
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          counterText: "",
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "ສາຂາຮຽນ",
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
                      "ເລືອກສາຂາຮຽນ",
                      style: TextStyle(
                        fontFamily: 'Phetsarath',
                      ),
                    ),
                  ),
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
                  "ລາຍລະອຽດການຈ່າຍເງິນ",
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
                        child: DropdownButton<String>(
                          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          underline: const SizedBox.shrink(),
                          isExpanded: true,
                          value:
                              _selectedTerm, // กำหนดค่าปัจจุบันของ DropdownButton
                          hint: const Text(
                            "ເລືອກຄ່າເທີມ",
                            style: TextStyle(
                              fontFamily: 'Phetsarath',
                            ),
                          ),
                          items: _termAmounts.keys.map((String key) {
                            return DropdownMenuItem<String>(
                              value: key,
                              child: Text(
                                key,
                                style: TextStyle(
                                  fontFamily: 'Phetsarath',
                                ),
                              ), // แสดงชื่อตัวเลือก
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedTerm = newValue; // อัปเดตค่าที่เลือก
                              if (_selectedTerm != null) {
                                // ดึงจำนวนเงินจาก Map และแสดงใน TextFormField
                                _amountController.text =
                                    _termAmounts[_selectedTerm] ?? '';
                              } else {
                                _amountController.text =
                                    ""; // เคลียร์ค่าถ้าไม่มีการเลือก
                              }
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Container(
                        child: TextFormField(
                          controller:
                              _amountController, // ใช้ controller เพื่อจัดการค่าของ TextFormField
                          // enabled: false,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'ເປັນຈຳນວນເງິນ',
                            labelStyle: TextStyle(
                              fontFamily: 'Phetsarath',
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
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
                          items: payStatusData.map((e) {
                            return DropdownMenuItem(
                              child: Text(
                                e["paySession"],
                                style: TextStyle(
                                  fontFamily: 'Phetsarath',
                                ),
                              ),
                              value: e["paySt_ID"],
                            );
                          }).toList(),
                          value: _valuePayS,
                          onChanged: (v) {
                            setState(() {
                              _valuePayS = v as int;
                            });
                          },
                          hint: Text(
                            "ເລືອກການຈ່າຍ",
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
                  height: 30,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  onPressed: () {
                    Confirm();
                    print("ລົງທະບຽນສຳເລັດ");
                  },
                  // onPressed: _submitDistrict,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.print),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'ບັນທຶກການລົງທະບຽນ',
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
      ),
    );
  }
}

class PhoneNumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove all non-digit characters
    String digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length > 11) {
      digitsOnly = digitsOnly.substring(0, 11);
    }

    String formatted = '';
    for (int i = 0; i < digitsOnly.length; i++) {
      if (i == 3) {
        formatted += ' ';
      } else if (i == 7) {
        formatted += '-';
      }
      formatted += digitsOnly[i];
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
