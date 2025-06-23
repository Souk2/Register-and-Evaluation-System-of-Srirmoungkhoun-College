import 'package:flutter/material.dart';

class OldStudent extends StatefulWidget {
  const OldStudent({super.key});

  @override
  State<OldStudent> createState() => _OldStudentState();
}

class _OldStudentState extends State<OldStudent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          "ລົງທະບຽນນັກສຶກສາເກົ່າ",
          style: TextStyle(
            fontFamily: 'Phetsarath',
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        child: Text("This is Register for Old Student"),
      ),
    );
  }
}
