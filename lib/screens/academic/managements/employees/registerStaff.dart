import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';
import 'package:registration_evaluation_app/screens/academic/academicScreen.dart';
import 'package:registration_evaluation_app/screens/academic/payments/editPaymentPage.dart';
import 'package:registration_evaluation_app/screens/academic/registation/New/newStdPay.dart';
import 'package:registration_evaluation_app/services/EmployeesService.dart';
import 'package:registration_evaluation_app/services/RegistrationService.dart';

class RegisterStaff extends StatefulWidget {
  const RegisterStaff({super.key});

  @override
  State<RegisterStaff> createState() => _RegisterStaffState();
}

List<String> opt = ["", "Male", "Famale"];

class _RegisterStaffState extends State<RegisterStaff> {
  final _formKey = GlobalKey<FormState>();
  String currentOpt = opt[0];
  TextEditingController txtdob = TextEditingController();

  File? _selectedImage; //Upload Images
  final picker = ImagePicker();

  //ທີ່ຢູ່ປັດຈຸບັນ
  List<dynamic> provincesNData = [];
  List<dynamic> filteredDistrictsNData = [];
  List<dynamic> districtsNData = [];
  int? _valueProN;
  int? _valueDisN;

  //ເລືອກຕຳແໜ່ງພະນັກງານ
  List<dynamic> roleData = [];
  int? _valueRole;

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchAllDropdownData(); // Call the data fetching function when the widget is created
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
        http.get(Uri.parse("$baseUrl/province")),
        http.get(Uri.parse("$baseUrl/district")),
        http.get(Uri.parse("$baseUrl/role")),
        // เพิ่ม API ตัวอื่นๆ ได้ตามต้องการ
      ];

      // 2. ใช้ Future.wait เพื่อรอให้ทุก API call เสร็จสิ้นพร้อมกัน
      List<http.Response> responses = await Future.wait(futures);

      //ທີ່ຢູ່ປັດຈຸບັນ
      if (responses[0].statusCode == 200) {
        provincesNData = jsonDecode(responses[0].body);
        print('Districts data loaded: ${provincesNData.length} items');
      } else {
        throw Exception(
            'Failed to load districts data: ${responses[0].statusCode}');
      }

      if (responses[1].statusCode == 200) {
        districtsNData = jsonDecode(responses[1].body);
        print('Districts data loaded: ${districtsNData.length} items');
      } else {
        throw Exception(
            'Failed to load districts data: ${responses[1].statusCode}');
      }

      if (responses[2].statusCode == 200) {
        roleData = jsonDecode(responses[2].body);
        print('Districts data loaded: ${roleData.length} items');
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

  final TextEditingController _empID = TextEditingController();
  final TextEditingController _empName = TextEditingController();
  final TextEditingController _empSurname = TextEditingController();
  final TextEditingController _villageNow = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final _phoneController = TextEditingController();

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

  Future<void> _submitNewStaff() async {
    if (_formKey.currentState!.validate()) {
      if (_valueDisN == null || _valueRole == null) {
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

      bool success = await Employeesservice.addEmployees(
        _empID.text,
        _empName.text,
        _empSurname.text,
        txtdob.text,
        currentOpt,
        _villageNow.text,
        _valueDisN!,
        _phoneController.text,
        _emailController.text,
        _valueRole!,
        _selectedImage, // 👈 รูปภาพที่ผู้ใช้เลือก
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
                if (_valueDisN == null || _valueRole == null) {
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
                  _submitNewStaff();
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

  //ฟังก์ชันเลือกภาพ:
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    _empID.dispose();
    _empName.dispose();
    _empSurname.dispose();
    _villageNow.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    txtdob.dispose();
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
          "ລົງທະບຽນພະນັກງານໃໝ່",
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
                  height: 20,
                ),
                Text(
                  "ປ້ອນຂໍ້ມູນພະນັກງານ",
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
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 90,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!)
                        : null,
                    child: _selectedImage == null
                        ? Icon(Icons.camera_alt, size: 40, color: Colors.grey)
                        : null,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _empID,
                  style: TextStyle(
                    fontFamily: 'Phetsarath',
                  ),
                  decoration: InputDecoration(
                    labelText: 'ລະຫັດພະນັກງານ',
                    labelStyle: TextStyle(
                      fontFamily: 'Phetsarath',
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'ກະລຸນາປ້ອນລະຫັດນັກພະນັກງານ';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _empName,
                        style: TextStyle(
                          fontFamily: 'Phetsarath',
                        ),
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
                            return 'ກະລຸນາປ້ອນຊື່ພະນັກງານ';
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
                        style: TextStyle(
                          fontFamily: 'Phetsarath',
                        ),
                        decoration: InputDecoration(
                          labelText: 'ນາມສະກຸນ',
                          labelStyle: TextStyle(
                            fontFamily: 'Phetsarath',
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'ກະລຸນາປ້ອນນາມສະກຸນ';
                          }
                          return null;
                        },
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
                SizedBox(
                  height: 10,
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
                          borderRadius: BorderRadius.circular(20),
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
                          borderRadius: BorderRadius.circular(20),
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
                          style: TextStyle(
                            fontFamily: 'Phetsarath',
                          ),
                          decoration: InputDecoration(
                            labelText: 'ບ້ານຢູ່ປັດຈຸບັນ',
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
                        style: TextStyle(
                          fontFamily: 'Phetsarath',
                        ),
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
                        controller: _phoneController,
                        style: TextStyle(
                          fontFamily: 'Phetsarath',
                        ),
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'ກະລຸນາປ້ອນຊື່ເມືອງ';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "ເລືອກຕຳແໜ່ງພະນັກງານ",
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
                    borderRadius: BorderRadius.circular(20),
                    items: roleData.map((e) {
                      return DropdownMenuItem(
                        child: Text(
                          e["rolename"],
                          style: TextStyle(
                            fontFamily: 'Phetsarath',
                          ),
                        ),
                        value: e["roleID"],
                      );
                    }).toList(),
                    value: _valueRole,
                    onChanged: (v) {
                      setState(() {
                        _valueRole = v as int;
                      });
                    },
                    hint: Text(
                      "ເລືອກຕຳແໜ່ງ",
                      style: TextStyle(
                        fontFamily: 'Phetsarath',
                      ),
                    ),
                  ),
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
                      Icon(
                        Icons.print,
                        color: Colors.white,
                      ),
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
