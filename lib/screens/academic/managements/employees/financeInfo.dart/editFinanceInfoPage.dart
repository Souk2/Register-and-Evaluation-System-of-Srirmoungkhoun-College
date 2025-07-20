import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';
import 'package:registration_evaluation_app/services/EmployeesService.dart';
import 'package:registration_evaluation_app/services/StudentService.dart';

class EditFinanceInfoPage extends StatefulWidget {
  final String staff_id;
  final String image_url;
  final String staff_Name;
  final String staff_Surname;
  final String dob;
  final String currentOpt;
  final String village;
  final int dsid;
  final String phoneNum;
  final String email;
  final int roleID;
  const EditFinanceInfoPage({
    super.key,
    required this.staff_id,
    required this.image_url,
    required this.staff_Name,
    required this.staff_Surname,
    required this.dob,
    required this.currentOpt,
    required this.village,
    required this.dsid,
    required this.phoneNum,
    required this.email,
    required this.roleID,
  });

  @override
  State<EditFinanceInfoPage> createState() => _EditFinanceInfoPageState();
}

List<String> opt = ["", "Male", "Famale"];

class _EditFinanceInfoPageState extends State<EditFinanceInfoPage> {
  final _formKey = GlobalKey<FormState>();
  String currentOptEdit = opt[0];
  TextEditingController txtdob = TextEditingController();

  File? _selectedImage; //Upload Images
  final picker = ImagePicker();
  String? _imageUrl; // สำหรับ URL ที่รับมาจาก backend

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
    // _fetchAllDropdownData(); // Call the data fetching function when the widget is created
    _fetchDataAll();
    _empID.text = widget.staff_id;
    _empName.text = widget.staff_Name;
    _empSurname.text = widget.staff_Surname;
    txtdob.text = widget.dob;
    currentOptEdit = widget.currentOpt;
    _villageNow.text = widget.village;
    _phoneController.text = widget.phoneNum;
    _emailController.text = widget.email;

    _imageUrl = widget.image_url;
  }

  // static const String baseUrl = "http://192.168.0.104:3000";

  static const String baseUrl = "http://10.34.90.133:3000";

  // ພາກສ່ວນໃນການດຶງຂໍ້ມູນ DropDown ຕ່າງໆ ຂຶິນມາສະແດງ
  Future<void> _fetchDataAll() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final resDistricts = await http.get(Uri.parse("$baseUrl/district"));
      final resProvinces = await http.get(Uri.parse("$baseUrl/province"));
      final resRole = await http.get(Uri.parse("$baseUrl/role"));

      if (resDistricts.statusCode == 200 &&
          resProvinces.statusCode == 200 &&
          resRole.statusCode == 200) {
        final districts = jsonDecode(resDistricts.body);
        final provinces = jsonDecode(resProvinces.body);
        final roles = jsonDecode(resRole.body);

        setState(() {
          _isLoading = false;

          // ✅ Assign data lists
          districtsNData = districts;
          provincesNData = provinces;
          roleData = roles;

          _valueDisN = widget.dsid;
          _valueRole = widget.roleID;

          // สมมุติคุณได้ค่าวันเกิดจาก database เป็นแบบนี้:
          String dbDob = txtdob.text;

          // แปลงเป็น DateTime แล้ว format ใหม่
          DateTime parsedDob = DateTime.parse(dbDob);
          txtdob.text = DateFormat("yyyy-MM-dd").format(parsedDob);

          //Use for select Province in DropDown
          final districtN = districts
              .firstWhere((d) => d["dsid"] == widget.dsid, orElse: () => null);

          _valueProN = districtN?["pid"];

          filteredDistrictsNData =
              districts.where((d) => d["pid"] == _valueProN).toList();
        });
      } else {
        throw Exception("One or more API failed");
      }
    } catch (error) {
      // setState(() {
      //   _isLoading = false;
      //   _errorMessage = 'Error fetching data: $error';
      // });
      print("Error: $error");
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

  Future<void> _submitUpdateStudent() async {
    if (_formKey.currentState!.validate()) {
      if (_valueRole == null || _valueDisN == null) {
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

      bool success = await Employeesservice.updateEmployees(
        _empID.text,
        _empName.text,
        _empSurname.text,
        txtdob.text,
        currentOptEdit,
        _villageNow.text,
        _valueDisN!,
        _phoneController.text,
        _emailController.text,
        _valueRole!,
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

        _uploadImage(); // update Image

        ////อยากให้มันย้อนกลับไปวิดเจ็ตก่อนหน้านี้
        Navigator.of(context).pop(true); // ปิด dialog
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

  //ฟังก์ชันเลือกภาพ:
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  //Update Images
  Future<void> _uploadImage() async {
    // ถ้าเลือกรูปใหม่แล้ว อัปโหลดรูปใหม่
    if (_selectedImage != null) {
      final uri = Uri.parse(
          // 'http://192.168.0.104:3000/uploadImg/update/staff/${widget.staff_id}');
          'http://10.34.90.133:3000/uploadImg/update/staff/${widget.staff_id}');
      final request = http.MultipartRequest('PUT', uri);

      request.files.add(
        await http.MultipartFile.fromPath('image', _selectedImage!.path),
      );

      final response = await request.send();

      if (response.statusCode == 200) {
        final resBody = await response.stream.bytesToString();
        final jsonRes = json.decode(resBody);
        final newUrl = jsonRes['imageUrl'];

        if (mounted) {
          setState(() {
            _imageUrl = newUrl;
            _selectedImage = null; // clear selected
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Failed to upload image.")),
        );
      }
    } else {
      // ✅ กรณีไม่ได้เลือกรูปใหม่ → ใช้ URL เดิมไป
      // คุณสามารถส่งค่ากลับหน้าเดิม หรือแสดงผลตามต้องการได้ที่นี่
      // Navigator.pop(context, true);
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
                if (_valueRole == null || _valueDisN == null) {
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

  Future<void> _submitDeleteStudent() async {
    if (_formKey.currentState!.validate()) {
      if (_valueRole == null || _valueDisN == null) {
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

      bool success = await Studentservice.deleteStudents(
        _empID.text,
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
        Navigator.of(context).pop(); // ย้อนกลับไปหน้าก่อนหน้านี้

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

  void ConfirmDelete() async {
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
            'ທ່ານແນ່ໃຈວ່າຈະລຶມຫຼືບໍ່?',
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
                backgroundColor: Colors.red,
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
                if (_valueRole == null || _valueDisN == null) {
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
                  _submitDeleteStudent();
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
    _villageNow.dispose();
    _emailController.dispose();
    _phoneController.dispose();
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
            txtdob.text = DateFormat("yyyy-MM-dd").format(date1);
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
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.blueAccent,
        title: Text(
          "ແກ້ໄຂຂໍ້ມູນນັກສຶກສາ",
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
                Text(
                  "ແກ້ໄຂຂໍ້ມູນຄູ-ອາຈານ",
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
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: 'ລະຫັດນຄູ-ອາຈານ',
                    labelStyle: TextStyle(
                      fontFamily: 'Phetsarath',
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'ກະລຸນາປ້ອນຂໍ້ມູນ';
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
                            return 'ກະລຸນາປ້ອນຂໍ້ມູນ';
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
                            return 'ກະລຸນາປ້ອນຊື່ເມືອງ';
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
                                        groupValue: currentOptEdit,
                                        onChanged: (value) {
                                          setState(
                                            () {
                                              currentOptEdit = value.toString();
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
                                        groupValue: currentOptEdit,
                                        onChanged: (value) {
                                          setState(
                                            () {
                                              currentOptEdit = value.toString();
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
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                        ),
                        onPressed: () {
                          ConfirmDelete();
                          print("ບັນທຶກການຂໍ້ມູນນັກສຶກສາສຳເລັດ");
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'ລຶບ',
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
                      width: 30,
                    ),
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
