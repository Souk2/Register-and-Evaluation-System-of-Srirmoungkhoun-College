import 'package:flutter/material.dart';
import 'package:registration_evaluation_app/screens/LoginScreen%20.dart';
import 'package:registration_evaluation_app/screens/academic/managements/Management.dart';
import 'package:registration_evaluation_app/screens/academic/payments/payment.dart';
import 'package:registration_evaluation_app/screens/academic/registation/New/newStudent.dart';
import 'package:registration_evaluation_app/screens/academic/registation/Old/oldStudentRe.dart';

// สร้าง enum เพื่อใช้เป็นค่าใน Radio buttons
enum StudentType { newStudent, oldStudent }

class AcademicScreen extends StatefulWidget {
  const AcademicScreen({super.key});

  @override
  State<AcademicScreen> createState() => _AcademicScreenState();
}

class _AcademicScreenState extends State<AcademicScreen> {
  // ตัวแปรสำหรับเก็บค่าที่เลือกใน Radio buttons ของ Pop-up
  // **ไม่จำเป็นต้องตั้งค่าเริ่มต้นตรงนี้ เพราะจะถูกรีเซ็ตใน _showStudentSelectionDialog()**
  StudentType? _selectedStudentType;
  // รายการข้อความสำหรับ Radio buttons
  final List<String> opt = ["ນັກສືກສາໃໝ່", "ນັກສຶກສາເກົ່າ"];

  // ฟังก์ชันสำหรับแสดง Pop-up พร้อม Radio buttons และจัดการการนำทาง
  void _showStudentSelectionDialog() {
    // **รีเซ็ตค่า _selectedStudentType ให้เป็น null ทุกครั้งที่ Pop-up ถูกเรียก**
    setState(() {
      _selectedStudentType = null;
    });
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text(
            "ກວດສອບນັກສຶກສາ",
            style: TextStyle(
              fontFamily: 'Phetsarath',
              fontWeight: FontWeight.bold,
            ),
          ), // ตรวจสอบนักศึกษา
          content: Column(
            mainAxisSize:
                MainAxisSize.min, // ทำให้ Column มีขนาดเล็กที่สุดเท่าที่จำเป็น
            children: <Widget>[
              // Radio button สำหรับ "นนักสືกษาໃໝ່" (นักศึกษาใหม่)
              RadioListTile<StudentType>(
                title: Text(
                  opt[0],
                  style: TextStyle(
                    fontFamily: 'Phetsarath',
                  ),
                ),
                value: StudentType.newStudent,
                groupValue: _selectedStudentType,
                onChanged: (StudentType? value) {
                  setState(() {
                    _selectedStudentType = value;
                  });
                  Navigator.of(dialogContext).pop(); // ปิด dialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NewStudent()),
                  );
                },
              ),
              // Radio button สำหรับ "นนักสຶกสาເກົ່າ" (นักศึกษาเก่า)
              RadioListTile<StudentType>(
                title: Text(
                  opt[1],
                  style: TextStyle(
                    fontFamily: 'Phetsarath',
                  ),
                ),
                value: StudentType.oldStudent,
                groupValue: _selectedStudentType,
                onChanged: (StudentType? value) {
                  setState(() {
                    _selectedStudentType = value;
                  });
                  Navigator.of(dialogContext).pop(); // ปิด dialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OldStudentRe()),
                  );
                },
              ),
            ],
          ),
        );
      },
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
          'ໜ້າຫຼັກ',
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Phetsarath",
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 0, 255, 242),
                    Color.fromARGB(255, 17, 128, 255),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(
                    Icons.school,
                    size: 50,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
            _buildDrawerItem(Icons.person_add, 'ຈັດການຂໍ້ມູນ', () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => Management()));
            }),
            _buildDrawerItem(Icons.edit_document, 'ລົງທະບຽນຮຽນ', () {
              _showStudentSelectionDialog();
            }),
            _buildDrawerItem(Icons.payment, 'ຊຳລະຄ່າຮຽນ', () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => Payment()));
            }),
            _buildDrawerItem(Icons.insert_drive_file, 'ລາຍງານ', () {}),
            _buildDrawerItem(Icons.settings, 'ການຕັ້ງຄ່າ', () {}),
            _buildDrawerItem(Icons.logout, 'ອອກຈາກລະບົບ', () {
              Navigator.of(context).pop();
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => LoginScreen()));
            }),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 0, 255, 242),
              Color.fromARGB(255, 255, 255, 255),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              _buildFeatureCard(
                title: 'ຈັດການຂໍ້ມູນ',
                description: 'ແກ້ໄຂຂໍ້ມູນ ແລະ ຈັດການ\nລາຍລະອຽດຕ່າງໆ',
                icon: Icons.person,
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => Management()));
                },
              ),
              _buildFeatureCard(
                title: 'ລົງທະບຽນຮຽນ',
                description: 'ລົງທະບຽນຮຽນສຳລັບ\nນັກສຶກສາໃໝ່ ແລະ ນັກສຶກສາເກົ່າ',
                icon: Icons.edit_document,
                onTap: () {
                  // เรียกฟังก์ชัน _showStudentSelectionDialog เมื่อกดปุ่ม
                  _showStudentSelectionDialog();
                },
              ),
              _buildFeatureCard(
                title: 'ປະເມີນຜົນການຮຽນ',
                description: 'ເຮັດການຕັດເກຣດໃຫ້ຄະແນນ\nພິມຜົນຄະແນນ',
                icon: Icons.grade_rounded,
                onTap: () {},
              ),
              _buildFeatureCard(
                title: 'ຊຳລະຄ່າຮຽນ',
                description:
                    'ເຮັດການປ່ຽນແປງສະຖານະ\nການຈ່າບຄ່າຮຽນຕ່າງໆສຳລັບນັກສຶກສາ',
                icon: Icons.payment,
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => Payment()));
                },
              ),
              _buildFeatureCard(
                title: 'ລາຍງານ',
                description: 'ເຮັດການລາຍງານຂໍ້ມູນຕ່າງໆ',
                icon: Icons.bar_chart,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        label,
        style: TextStyle(fontFamily: 'Phetsarath'),
      ),
      onTap: onTap,
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      elevation: 4,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16), // เพื่อให้ ripple ไม่เกินขอบ
        splashColor: Colors.grey.withOpacity(0.2), // สี ripple
        highlightColor: Colors.grey.withOpacity(0.1), // สีตอนกดค้าง
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: Color(0xFF345FB4),
              ),
              SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.045,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Phetsarath',
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.025,
                  color: Colors.black54,
                  fontFamily: 'Phetsarath',
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
