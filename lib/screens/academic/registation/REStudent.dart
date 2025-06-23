import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddRestudent extends StatefulWidget {
  const AddRestudent({super.key});

  @override
  State<AddRestudent> createState() => _AddRestudentState();
}

class _AddRestudentState extends State<AddRestudent> {
  TextEditingController txtdate = TextEditingController();
  String age = "";
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
            //txtdate.text = date1.toString().split("")[0];
            txtdate.text = DateFormat("dd/MM/yyyy").format(date1);

            int d1 = int.parse(DateFormat("dd").format(date1));

            int m1 = int.parse(DateFormat("dd").format(date1));

            int y1 = int.parse(DateFormat("dd").format(date1));

            int ynow = int.parse(DateFormat("yy").format(DateTime.now()));
            int _age = DateTime.timestamp().year - date1.year;
            age = _age.toString();
            print("Age : $age ປີ");
          } else {
            txtdate.text = DateFormat("dd/MM/yyyy").format(
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
          "ລົງທະບຽນນັກສຶກສາ",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "1. ກ່ຽວກັບຕົນເອງ",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'ຊື່',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'ຊື່ ເປັນພາສາອັງກິດ',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'ນາມສະກຸນ',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'ນາມສະກຸນ ເປັນພາສາອັງກິດ',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: txtdate,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(
                      Icons.calendar_today,
                      size: 30,
                      color: Colors.green,
                    ),
                    labelText: "ວັນເດືອນປີເກີດ",
                  ),
                  readOnly: true,
                  onTap: () {
                    selectDataOBirth();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
