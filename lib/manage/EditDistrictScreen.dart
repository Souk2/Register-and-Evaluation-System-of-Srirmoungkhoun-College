import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:registration_evaluation_app/services/DistrictService.dart';
import 'package:http/http.dart' as http;

class EditDistrictScreen extends StatefulWidget {
  final int dsid;
  final String dname;
  final int pid;
  const EditDistrictScreen(
      {super.key, required this.dsid, required this.dname, required this.pid});

  @override
  State<EditDistrictScreen> createState() => _EditDistrictScreenState();
}

class _EditDistrictScreenState extends State<EditDistrictScreen> {
  /// editprovince
  final TextEditingController _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List data = []; // use from dropdownbutton
  int? _value; // use from dropdownbutton
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchData(); // Call the data fetching function when the widget is created

    _titleController.text = widget.dname;
  }

  // Future<void> _fetchData() async {
  //   setState(() {
  //     _isLoading = true;
  //     _errorMessage = null; // Reset error message
  //   });
  //   try {
  //     final response =
  //         await http.get(Uri.parse("http://192.168.0.108:3000/province"));

  //     if (response.statusCode == 200) {
  //       setState(() {
  //         data = jsonDecode(response.body);
  //         _isLoading = false;
  //       });
  //     } else {
  //       setState(() {
  //         _isLoading = false;
  //         _errorMessage =
  //             'Failed to load data. Status code: ${response.statusCode}';
  //       });
  //       print('Error fetching data: ${response.statusCode}, ${response.body}');
  //     }
  //   } catch (error) {
  //     setState(() {
  //       _isLoading = false;
  //       _errorMessage = 'An unexpected error occurred: $error';
  //     });
  //     print('Error fetching data: $error');
  //   }
  // }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null; // Reset error message
    });
    try {
      final response =
          await http.get(Uri.parse("http://192.168.0.104:3000/province"));
      // await http.get(Uri.parse("http://192.168.61.95:3000/province"));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as List;
        setState(() {
          data = jsonData;
          _isLoading = false;
          // Set initial value for dropdown
          for (var item in data) {
            if (item['pid'] == widget.pid) {
              _value = widget.pid;
              break;
            }
          }
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage =
              'Failed to load data. Status code: ${response.statusCode}';
        });
        print('Error fetching data: ${response.statusCode}, ${response.body}');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'An unexpected error occurred: $error';
      });
      print('Error fetching data: $error');
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
  Future<void> _updateDistrict() async {
    if (_formKey.currentState!.validate()) {
      if (_value == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "ກະລຸນາເລືອກແຂວງ",
              style: TextStyle(
                fontFamily: 'Phetsarath',
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      bool success = await Districtservice.updateDistrict(
          widget.dsid, _titleController.text, _value);
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

  // @override
  // void initState() {
  //   super.initState();
  //   _titleController.text = widget.dname;
  // }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ເເກ້ໄຂຊື່ເມືອງ',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Phetsarath',
          ),
        ),
        backgroundColor: Colors.blue,
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
                  decoration: InputDecoration(
                    labelText: 'ຊື່ເມືອງ',
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
                    items: data.map((e) {
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
                    hint: Text(
                      'ເລືອກແຂວງ',
                      style: TextStyle(
                        fontFamily: 'Phetsarath',
                      ),
                    ),
                    value: _value,
                    onChanged: (v) {
                      setState(() {
                        _value = v as int;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    onPressed: _updateDistrict,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.print),
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
                    ))
              ],
            )),
      ),
    );
  }
}
