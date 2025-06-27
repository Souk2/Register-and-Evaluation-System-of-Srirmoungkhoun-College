// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:registration_evaluation_app/services/ClassroomService.dart';

class AddClassroom extends StatefulWidget {
  const AddClassroom({super.key});

  @override
  State<AddClassroom> createState() => _AddClassroomState();
}

class _AddClassroomState extends State<AddClassroom> {
  final TextEditingController _tittlecontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _submitClassrooms() async {
    if (_formKey.currentState!.validate()) {
      try {
        bool success =
            await Classroomservice.addClassrooms(_tittlecontroller.text);
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
      } catch (e) {
        print(e);
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          'ເພີ່ມຫ້ອງຮຽນ',
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
                controller: _tittlecontroller,
                decoration: InputDecoration(
                  labelText: 'ຊື່ຫ້ອງຮຽນ',
                  labelStyle: TextStyle(
                    fontFamily: 'Phetsarath',
                  ),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'ກະລຸນາປ້ອນຊື່ຫ້ອງຮຽນ';
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
                onPressed: _submitClassrooms,
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
