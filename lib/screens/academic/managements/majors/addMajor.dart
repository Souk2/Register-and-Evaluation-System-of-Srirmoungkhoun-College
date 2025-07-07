// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:registration_evaluation_app/services/MajorService.dart';
import 'package:registration_evaluation_app/services/ProvinceService.dart';

class AddMajor extends StatefulWidget {
  const AddMajor({super.key});

  @override
  State<AddMajor> createState() => _AddMajorState();
}

class _AddMajorState extends State<AddMajor> {
  final TextEditingController _tittlecontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _submitMajors() async {
    if (_formKey.currentState!.validate()) {
      bool success = await Majorservice.addMajors(_tittlecontroller.text);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("ຊື່ສາຂາຮຽນຖືກບັນທຶກສຳເລັດແລ້ວ"),
            backgroundColor: Colors.green,
          ),
        );
        _tittlecontroller.clear();
        Navigator.of(context).pop();

        showAlert();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("ຂໍອະໄພ!ເກີດຂໍ້ຜິດພາດ"),
            backgroundColor: Colors.red,
          ),
        );

        _tittlecontroller.clear();
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
  void dispose() {
    _tittlecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          'ເພີ່ມສາຂາຮຽນ',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Phetsarath',
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
                controller: _tittlecontroller,
                style: TextStyle(
                  fontFamily: 'Phetsarath',
                ),
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
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                onPressed: _submitMajors,
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
