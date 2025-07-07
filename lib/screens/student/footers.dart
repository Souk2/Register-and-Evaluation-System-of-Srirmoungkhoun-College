import 'package:flutter/material.dart';
import 'package:registration_evaluation_app/screens/student/SettingsPage.dart';
import 'package:registration_evaluation_app/screens/student/StudentScreen.dart';
import 'package:registration_evaluation_app/screens/student/TimetablePage.dart';

// สร้าง Stateless Widget สำหรับแต่ละหน้า (แทนที่จะใช้ Text เฉยๆ)

class Footers extends StatefulWidget {
  const Footers({super.key});

  @override
  State<Footers> createState() => _FootersState();
}

class _FootersState extends State<Footers> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    StudentScreen(),
    TimetablePage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions
          .elementAt(_selectedIndex), // แสดง Widget ตาม Tab ที่เลือก
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_max_rounded),
            label: 'ໜ້າຫຼັກ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule_rounded),
            label: 'ຕາຕະລາງ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_applications_sharp),
            label: 'ການຕັ້ງຄ່າ',
          ),
        ],
        currentIndex: _selectedIndex,

        selectedItemColor: Color.fromARGB(255, 0, 136, 255),

        backgroundColor: Color.fromARGB(255, 233, 246, 254),

        // สีของไอคอนและ Label เมื่อไม่ถูกเลือก
        unselectedItemColor: Colors.grey,

        onTap: _onItemTapped,

        showSelectedLabels: true, // แสดง Label เมื่อ Tab ถูกเลือก (ถ้ามี Label)

        // ไม่แสดง Label เมื่อ Tab ไม่ได้ถูกเลือก (ถ้ามี Label)
        showUnselectedLabels: false,

        //
        selectedLabelStyle: const TextStyle(
          // สไตล์สำหรับ Label ที่ถูกเลือก
          fontFamily: 'Phetsarath', // เปลี่ยนเป็น Font ที่คุณต้องการ
          fontSize: 12.0,
          fontWeight: FontWeight.bold,
        ),

        //
        type: BottomNavigationBarType.fixed, // ทำให้ Label แสดงตลอดเวลา
      ),
    );
  }
}
