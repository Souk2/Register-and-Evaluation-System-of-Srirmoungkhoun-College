// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:registration_evaluation_app/services/ProvinceService.dart';

class AddProvinceScreen extends StatefulWidget {
  const AddProvinceScreen({super.key});

  @override
  State<AddProvinceScreen> createState() => _AddProvinceScreenState();
}

class _AddProvinceScreenState extends State<AddProvinceScreen> {
  final TextEditingController _tittlecontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _submitProvince() async {
    if (_formKey.currentState!.validate()) {
      bool success = await Provinceservice.addProvince(_tittlecontroller.text);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("ຊື່ແຂວງຖືກບັນທຶກສຳເລັດແລ້ວ"),
            backgroundColor: Colors.green,
          ),
        );
        _tittlecontroller.clear();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ເພີ່ມແຂວງ',
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
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                onPressed: _submitProvince,
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
