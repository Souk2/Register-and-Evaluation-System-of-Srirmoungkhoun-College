import 'package:flutter/material.dart';
import 'package:registration_evaluation_app/screens/student/Settings.dart';
import 'package:registration_evaluation_app/screens/student/StudentScreen.dart';

class Timetable extends StatefulWidget {
  const Timetable({super.key});

  @override
  State<Timetable> createState() => _TimetableState();
}

List<Widget> itmpage = [StudentScreen(), Timetable(), Settings()];

class _TimetableState extends State<Timetable> {
  int idx = 1;

  void ontabpPed(BuildContext context, int indx) {
    setState(() {
      idx = indx;
    });

    // ນຳທາງໄປໜ້າໃໝ່
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => itmpage[indx]),
    );
  }

  Widget BottomBar() {
    return BottomNavigationBar(
      backgroundColor: Color(0xFF345FB4),
      selectedIconTheme: IconThemeData(color: Colors.white, size: 35),
      selectedLabelStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      selectedFontSize: 15,
      selectedItemColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      currentIndex: idx,
      onTap: (index) {
        ontabpPed(context, index); // ປ່ຽນ index ຂອງໜ້າປະຈຸບັນ
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "ໜ້າຫຼັກ",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.microwave_outlined),
          label: "ຕາຕະລາງຮຽນ",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_rounded),
          label: "ຕັ້ງຄ່າ",
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Expanded(flex: 1, child: SizedBox(height: 10)),
          Expanded(
            flex: 166,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [Text("This is Timetable")],
                    ),
                  ),
                ],
              ),
            ),
          ),
          BottomBar(),
        ],
      ),
    );
  }
}
