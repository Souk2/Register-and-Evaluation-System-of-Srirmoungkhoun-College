import 'package:flutter/material.dart';
import 'package:registration_evaluation_app/screens/academic/evaluation/evaluations.dart';
import 'package:registration_evaluation_app/screens/academic/managements/districts/DistrictScreen.dart';
import 'package:registration_evaluation_app/screens/LoginScreen%20.dart';
import 'package:registration_evaluation_app/screens/academic/managements/provinces/ProvinceScreen.dart';
import 'package:registration_evaluation_app/screens/academic/academicScreen.dart';
import 'package:registration_evaluation_app/screens/academic/managements/classroom/classrooms.dart';
import 'package:registration_evaluation_app/screens/academic/upClasses/upClass.dart';
import 'package:registration_evaluation_app/screens/academic/managements/majors/major.dart';
import 'package:registration_evaluation_app/screens/academic/managements/students/editStudentPage.dart';
import 'package:registration_evaluation_app/screens/academic/managements/students/studentPage.dart';
import 'package:registration_evaluation_app/screens/academic/payments/payment.dart';
import 'package:registration_evaluation_app/screens/academic/registation/New/newStdPay.dart';
import 'package:registration_evaluation_app/screens/academic/registation/Old/oldStudentRe.dart';
import 'package:registration_evaluation_app/screens/student/StudentScreen.dart';
import 'package:registration_evaluation_app/screens/academic/managements/districts/AddDistrictScreen.dart';
import 'package:registration_evaluation_app/screens/academic/registation/New/newStudent.dart';
import 'package:registration_evaluation_app/screens/student/footers.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AcademicScreen(),
      // NewStdPay(
      //   stdID: "p",
      //   stdName: "o",
      //   stdSurname: "o",
      // ),
    );
  }
}
