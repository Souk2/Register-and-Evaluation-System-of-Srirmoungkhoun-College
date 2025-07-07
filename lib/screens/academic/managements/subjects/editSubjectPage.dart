import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:registration_evaluation_app/services/SubjectsService.dart';
import 'package:http/http.dart' as http;

class EditSubjectPage extends StatefulWidget {
  final int sub_id;
  final String sub_Name;
  final int sYearID;
  final int mid;
  const EditSubjectPage({
    super.key,
    required this.sub_id,
    required this.sub_Name,
    required this.sYearID,
    required this.mid,
  });

  @override
  State<EditSubjectPage> createState() => _EditSubjectPageState();
}

class _EditSubjectPageState extends State<EditSubjectPage> {
  /// editprovince
  final TextEditingController _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List<dynamic> sYearData = []; // use from dropdownbutton
  int? _valueSyear; // use from dropdownbutton

  List<dynamic> majorData = []; // use from dropdownbutton
  int? _valueMajor; // use from dropdownbutton

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchDataAll(); // Call the data fetching function when the widget is created

    _titleController.text = widget.sub_Name;
  }

  static const String baseUrl = "http://192.168.0.104:3000";
  // ພາກສ່ວນໃນການດຶງຂໍ້ມູນ DropDown ຕ່າງໆ ຂຶິນມາສະແດງ
  Future<void> _fetchDataAll() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final resMajors = await http.get(Uri.parse("$baseUrl/major"));
      final resStudyYear = await http.get(Uri.parse("$baseUrl/syear"));

      if (resMajors.statusCode == 200 && resStudyYear.statusCode == 200) {
        final majors = jsonDecode(resMajors.body);
        final staudyYear = jsonDecode(resStudyYear.body);

        setState(() {
          _isLoading = false;

          // ✅ Assign data lists
          majorData = majors;
          sYearData = staudyYear;

          // ✅ Set initial values from widget
          _valueMajor = widget.mid;

          _valueSyear = widget.sYearID;
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
  Future<void> _updateSubjects() async {
    if (_formKey.currentState!.validate()) {
      if (_valueSyear == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "ກະລຸນາເລືອກປີຮຽນ!",
              style: TextStyle(
                fontFamily: 'Phetsarath',
              ),
            ), // Please select a province
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 1),
          ),
        );
        return; // Stop submission if no province is selected
      }
      if (_valueMajor == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "ກະລຸນາເລືອກສາຮຽນ!",
              style: TextStyle(
                fontFamily: 'Phetsarath',
              ),
            ), // Please select a province
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 1),
          ),
        );
        return; // Stop submission if no province is selected
      }

      bool success = await Subjectsservice.updateSubjects(
        widget.sub_id,
        _titleController.text,
        _valueSyear,
        _valueMajor,
      );
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "ຊື່ແຂວງຖືກບັນທຶກສຳເລັດແລ້ວ",
              style: TextStyle(
                fontFamily: 'Phetsarath',
              ),
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
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

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _submitDeleteStubjects() async {
    if (_formKey.currentState!.validate()) {
      if (_titleController == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "ກະລຸນາປ້ອນຂໍ້ມູນ!",
              style: TextStyle(
                fontFamily: 'Phetsarath',
              ),
            ), // Please select a province
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 1),
          ),
        );
        return; // Stop submission if no province is selected
      }

      bool success = await Subjectsservice.deleteSubjects(
        widget.sub_id,
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
                if (_valueMajor == null || _valueSyear == null) {
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
                  _submitDeleteStubjects();
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          'ເເກ້ໄຂວິຊາຮຽນ',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Phetsarath',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titleController,
                  style: TextStyle(
                    fontFamily: 'Phetsarath',
                  ),
                  decoration: InputDecoration(
                    labelText: 'ຊື່ວິຊາຮຽນ',
                    labelStyle: TextStyle(
                      fontFamily: 'Phetsarath',
                    ),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'ກະລຸນາປ້ອນຊື່ເມືອງ';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black, width: 1), // Border
                  ),
                  child: DropdownButton(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    isExpanded: true,
                    underline: SizedBox.shrink(),
                    borderRadius: BorderRadius.circular(20),
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
                    hint: Text(
                      'ເລືອກປີຮຽນ',
                      style: TextStyle(
                        fontFamily: 'Phetsarath',
                      ),
                    ),
                    value: _valueSyear,
                    onChanged: (v) {
                      setState(() {
                        _valueSyear = v as int;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black, width: 1), // Border
                  ),
                  child: DropdownButton(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    isExpanded: true,
                    underline: SizedBox.shrink(),
                    borderRadius: BorderRadius.circular(20),
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
                    hint: Text(
                      'ເລືອກສາຮຽນ',
                      style: TextStyle(
                        fontFamily: 'Phetsarath',
                      ),
                    ),
                    value: _valueMajor,
                    onChanged: (v) {
                      setState(() {
                        _valueMajor = v as int;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
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
                          onPressed: _updateSubjects,
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
                          )),
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }
}
