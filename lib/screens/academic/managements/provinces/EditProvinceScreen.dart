import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:registration_evaluation_app/services/ProvinceService.dart';

class EditProvinceScreen extends StatefulWidget {
  final int pid;
  final String pname;
  const EditProvinceScreen({super.key, required this.pid, required this.pname});

  @override
  State<EditProvinceScreen> createState() => _EditProvinceScreenState();
}

class _EditProvinceScreenState extends State<EditProvinceScreen> {
  /// editprovince
  final TextEditingController _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Future<void> _updateProvince() async {
    if (_formKey.currentState!.validate()) {
      bool success = await Provinceservice.updateProvince(
          widget.pid, _titleController.text);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("ຊື່ແຂວງຖືກບັນທຶກສຳເລັດແລ້ວ"),
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

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.pname;
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          'ເເກ້ໄຂຊື່ແຂວງ',
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
                    labelText: 'ຊື່ແຂວງ',
                    labelStyle: TextStyle(
                      fontFamily: 'Phetsarath',
                    ),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'ກະລຸນາປ້ອນຊື່ແຂວງ';
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
                    onPressed: _updateProvince,
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
