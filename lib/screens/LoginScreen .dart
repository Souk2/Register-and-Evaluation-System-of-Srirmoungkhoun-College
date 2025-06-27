import 'package:flutter/material.dart';
import 'package:registration_evaluation_app/screens/academic/managements/districts/DistrictScreen.dart';
// import './HomeScreen.dart';
// import './RegisterScreen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:registration_evaluation_app/screens/academic/managements/provinces/ProvinceScreen.dart';
import 'package:registration_evaluation_app/screens/academic/academicScreen.dart';
import 'package:registration_evaluation_app/screens/academic/registation/New/newStudent.dart';
import 'package:registration_evaluation_app/screens/student/StudentScreen.dart';
import 'package:registration_evaluation_app/screens/teacher/teacherScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool _isPhoneError = false;
  String _phoneErrorMessage = '';
  // Future<void> loginUser() async {
  //   setState(() {
  //     isLoading = true;
  //   });

  //   final String url = "http://192.168.0.104:3000/v1/login";
  //   // final String url = "http://192.168.61.95:3000/v1/login";

  //   try {
  //     final response = await http.post(Uri.parse(url),
  //         headers: {"Content-Type": "application/json"},
  //         body: jsonEncode({
  //           "phone": phoneController.text,
  //           "password": passwordController.text,
  //         }));
  //     if (response.statusCode == 200) {
  //       ScaffoldMessenger.of(context)
  //           .showSnackBar(SnackBar(content: Text("ເຂົ້າສູ່ລະບົບສຳເລັດແລ້ວ")));

  //       /// ໃຊ້ບໍ່ໃຫ້ມີລຸກສອນຍ້ອນກັບ
  //       Navigator.of(context).pop();

  //       Navigator.push(context,
  //           MaterialPageRoute(builder: (context) => const DistrictScreen()));
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text("ເຂົ້າສູ່ລະບົບບໍ່ສຳເລັດ ${response.body}")));
  //     }
  //   } catch (error) {
  //     setState(() {
  //       isLoading = false;
  //     });

  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text("ເຊື່ອມຕໍ່ server ບໍ່ໄດ້")));
  //   }
  // }

  Future<void> loginUser() async {
    setState(() {
      isLoading = true;
    });

    final String url = "http://192.168.0.104:3000/v1/login";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "phone": phoneController.text,
          "password": passwordController.text,
        }),
      );

      // ຫາກບໍ່ມີ setState ນີ້ຈະເຮັດໃຫ້ປຸ່ມໃໍຊ້ໄດ້ແຄ່ຄັ້ງດຽວແລ້ວຈະຢຸດການເຮັດວຽກ
      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final int role = responseData["role"]; // 1 = ວິຊາການ, 2 = ອາຈານ

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("ເຂົ້າສູ່ລະບົບສຳເລັດແລ້ວ"),
            backgroundColor: Colors.green,
          ),
        );

        // ປິດ popup login
        Navigator.of(context).pop();

        // ນຳໃຊ້ role ເພື່ອເຂົ້າໜ້າທີ່ກ່ຽວຂ້ອງ
        if (role == 1) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AcademicScreen()));
        } else if (role == 2) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const StudentScreen()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("ບົດບາດບໍ່ຖືກກຳນົດ"),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          // SnackBar(content: Text("ເຂົ້າສູ່ລະບົບບໍ່ສຳເລັດ ${response.body}")),
          SnackBar(
            content: Text("ເຂົ້າສູ່ລະບົບບໍ່ສຳເລັດ ກະລຸນາລອງໃໝ່ອີກຄັ້ງ"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("ເຊື່ອມຕໍ່ server ບໍ່ໄດ້")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.width * 0.3,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(
                      Icons.school,
                      size: MediaQuery.of(context).size.width * 0.2,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    'ເຂົ້າສູ່ລະບົບ',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      fontFamily: 'Phetsarath',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  TextField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      labelText: 'ເບີໂທ',
                      labelStyle: TextStyle(
                        fontFamily: 'Phetsarath',
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      prefixIcon: Icon(Icons.phone),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                        labelText: 'ລະຫັດຜ່ານ',
                        labelStyle: TextStyle(
                          fontFamily: 'Phetsarath',
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        prefixIcon: Icon(Icons.key_outlined)),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  ElevatedButton(
                      onPressed: isLoading ? null : loginUser,
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: Colors.blue),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.signpost_outlined,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'ເຂົ້າສູ່ລະບົບ',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      )),
                  SizedBox(
                    height: 3,
                  ),
                  /*Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('ລົງທະບຽນແລ້ວ ຫຼື ບໍ?'),
                      SizedBox(
                        width: 3,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) =>
                            //             const RegisterScreen()));
                          },
                          child: Text('ລົງທະບຽນ'))
                    ],
                  )*/
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
