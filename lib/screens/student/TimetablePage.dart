import 'package:flutter/material.dart';
import 'package:registration_evaluation_app/screens/student/footers.dart';

class TimetablePage extends StatefulWidget {
  const TimetablePage({super.key});

  @override
  State<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  Future<void> _refreshData() async {
    // จำลองการโหลดข้อมูลใหม่ เช่นจาก API
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (a, b, c) => Footers(), // โหลดหน้าใหม่ทับ
          transitionDuration: Duration.zero,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        color: Colors.green,
        onRefresh: _refreshData,
        child: Column(
          children: [
            // const Expanded(flex: 1, child: SizedBox(height: 10)),
            Expanded(
              // flex: 166,
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 16),
                        Center(
                          child: Column(
                            children: [
                              Text("This is Timetable"),
                              Text("This is Timetable"),
                              Text("This is Timetable"),
                              Text("This is Timetable"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
