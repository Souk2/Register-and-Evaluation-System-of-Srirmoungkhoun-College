import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:registration_evaluation_app/screens/academic/managements/majors/major.dart';
import 'package:registration_evaluation_app/services/MajorService.dart';
import 'package:registration_evaluation_app/services/ProvinceService.dart';

class EditMajor extends StatefulWidget {
  final int mid;
  final String m_name;
  const EditMajor({super.key, required this.mid, required this.m_name});

  @override
  State<EditMajor> createState() => _EditMajorState();
}

class _EditMajorState extends State<EditMajor> {
  /// edit
  final TextEditingController _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Future<void> _updateMajors() async {
    if (_formKey.currentState!.validate()) {
      bool success = await Majorservice.updateMajors(
        widget.mid,
        _titleController.text,
      );
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("ຊື່ສາຂາຮຽນຖືກບັນທຶກສຳເລັດແລ້ວ"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);

        showAlert();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("ຂໍອະໄພ!ເກີດຂໍ້ຜິດພາດ"),
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

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.m_name;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          'ເເກ້ໄຂຊື່ສາຂາຮຽນ',
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
                    labelText: 'ຊື່ສາຂາຮຽນ',
                    labelStyle: TextStyle(
                      fontFamily: 'Phetsarath',
                    ),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'ກະລຸນາປ້ອນຊື່ສາຂາຮຽນ';
                    }
                    return null;
                  },
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
                    onPressed: _updateMajors,
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
