import 'package:flutter/material.dart';
import 'package:registration_evaluation_app/screens/DistrictScreen.dart';
import 'package:registration_evaluation_app/screens/LoginScreen%20.dart';
import 'package:registration_evaluation_app/screens/ProvinceScreen.dart';
import 'package:registration_evaluation_app/screens/academic/academicScreen.dart';
import 'package:registration_evaluation_app/screens/academic/managements/classroom/classrooms.dart';
import 'package:registration_evaluation_app/screens/academic/managements/evaluations/evaluation.dart';
import 'package:registration_evaluation_app/screens/academic/managements/majors/major.dart';
import 'package:registration_evaluation_app/screens/academic/managements/students/editStudentPage.dart';
import 'package:registration_evaluation_app/screens/academic/managements/students/studentPage.dart';
import 'package:registration_evaluation_app/screens/academic/payments/payment.dart';
import 'package:registration_evaluation_app/screens/student/StudentScreen.dart';
import 'package:registration_evaluation_app/screens/add/AddDistrictScreen.dart';
import 'package:registration_evaluation_app/screens/academic/registation/newStudent.dart';
import 'package:registration_evaluation_app/screens/academic/registation/REStudent.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AcademicScreen(),
    );
  }
}
