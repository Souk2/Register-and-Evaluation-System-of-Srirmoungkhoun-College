import 'package:flutter/material.dart';
import 'package:registration_evaluation_app/screens/academic/managements/districts/DistrictScreen.dart';
import 'package:registration_evaluation_app/screens/academic/managements/provinces/ProvinceScreen.dart';
import 'package:registration_evaluation_app/screens/academic/managements/classroom/classrooms.dart';
import 'package:registration_evaluation_app/screens/academic/managements/upClasses/upClass.dart';
import 'package:registration_evaluation_app/screens/academic/managements/majors/major.dart';
import 'package:registration_evaluation_app/screens/academic/managements/students/studentPage.dart';

class Management extends StatefulWidget {
  const Management({super.key});

  @override
  State<Management> createState() => _ManagementState();
}

class _ManagementState extends State<Management> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.blueAccent,
        title: Text(
          "ຈັດການຂໍ້ມູນ",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Phetsarath',
          ),
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
        child: Column(
          children: [
            const Expanded(flex: 1, child: SizedBox(height: 10)),
            Expanded(
              flex: 166,
              child: Container(
                padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 0, 255, 242),
                      Color.fromARGB(255, 255, 255, 255),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => StudentPage()));
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        minimumSize: Size(
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                            MediaQuery.of(context).size.width *
                                                0.3),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.badge_outlined,
                                        size:
                                            MediaQuery.of(context).size.width *
                                                0.14,
                                        color: Color(0xFF345FB4),
                                        shadows: [
                                          Shadow(
                                            offset: Offset(2, 2),
                                            blurRadius: 4,
                                            color: Colors.grey,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'ນັກສຶກສາ',
                                      style: TextStyle(
                                        color: Color(0xFF345FB4),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        fontFamily: 'Phetsarath',
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () => {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => Classrooms())),
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        minimumSize: Size(
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                            MediaQuery.of(context).size.width *
                                                0.3),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.wallet_giftcard_outlined,
                                        size:
                                            MediaQuery.of(context).size.width *
                                                0.14,
                                        color: Color(0xFF345FB4),
                                        shadows: [
                                          Shadow(
                                            offset: Offset(2, 2),
                                            blurRadius: 4,
                                            color: Colors.grey,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'ຫ້ອງຮຽນ',
                                      style: TextStyle(
                                        color: Color(0xFF345FB4),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        fontFamily: 'Phetsarath',
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () => {
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (context) => const CategoryScreen(),
                                        //   ),
                                        // )
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        minimumSize: Size(
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                            MediaQuery.of(context).size.width *
                                                0.3),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.auto_stories_outlined,
                                        size:
                                            MediaQuery.of(context).size.width *
                                                0.14,
                                        color: Color(0xFF345FB4),
                                        shadows: [
                                          Shadow(
                                            offset: Offset(2, 2),
                                            blurRadius: 4,
                                            color: Colors.grey,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'ວິຊາຮຽນ',
                                      style: TextStyle(
                                        color: Color(0xFF345FB4),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        fontFamily: 'Phetsarath',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () => {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => Major())),
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        minimumSize: Size(
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                            MediaQuery.of(context).size.width *
                                                0.3),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.add_box,
                                        size:
                                            MediaQuery.of(context).size.width *
                                                0.14,
                                        color: Color(0xFF345FB4),
                                        shadows: [
                                          Shadow(
                                            offset: Offset(2, 2),
                                            blurRadius: 4,
                                            color: Colors.grey,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'ສາຂາຮຽນ',
                                      style: TextStyle(
                                        color: Color(0xFF345FB4),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        fontFamily: 'Phetsarath',
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        minimumSize: Size(
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                            MediaQuery.of(context).size.width *
                                                0.3),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.assignment_ind_outlined,
                                        size:
                                            MediaQuery.of(context).size.width *
                                                0.14,
                                        color: Color(0xFF345FB4),
                                        shadows: [
                                          Shadow(
                                            offset: Offset(2, 2),
                                            blurRadius: 4,
                                            color: Colors.grey,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'ພະນັກງານ',
                                      style: TextStyle(
                                        color: Color(0xFF345FB4),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        fontFamily: 'Phetsarath',
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        minimumSize: Size(
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                            MediaQuery.of(context).size.width *
                                                0.3),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.wallet_giftcard_outlined,
                                        size:
                                            MediaQuery.of(context).size.width *
                                                0.14,
                                        color: Color(0xFF345FB4),
                                        shadows: [
                                          Shadow(
                                            offset: Offset(2, 2),
                                            blurRadius: 4,
                                            color: Colors.grey,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'ຄະແນນ',
                                      style: TextStyle(
                                        color: Color(0xFF345FB4),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        fontFamily: 'Phetsarath',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => UpClass()));
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        minimumSize: Size(
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                            MediaQuery.of(context).size.width *
                                                0.3),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.arrow_circle_up,
                                        size:
                                            MediaQuery.of(context).size.width *
                                                0.14,
                                        color: Color(0xFF345FB4),
                                        shadows: [
                                          Shadow(
                                            offset: Offset(2, 2),
                                            blurRadius: 4,
                                            color: Colors.grey,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'ເລືອນຊັ້ນຮຽນ',
                                      style: TextStyle(
                                        color: Color(0xFF345FB4),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        fontFamily: 'Phetsarath',
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const DistrictScreen(),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        minimumSize: Size(
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                            MediaQuery.of(context).size.width *
                                                0.3),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.location_city,
                                        size:
                                            MediaQuery.of(context).size.width *
                                                0.14,
                                        color: Color(0xFF345FB4),
                                        shadows: [
                                          Shadow(
                                            offset: Offset(2, 2),
                                            blurRadius: 4,
                                            color: Colors.grey,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'ເມືອງ',
                                      style: TextStyle(
                                        color: Color(0xFF345FB4),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        fontFamily: 'Phetsarath',
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const ProvinceScreen(),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        minimumSize: Size(
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                            MediaQuery.of(context).size.width *
                                                0.3),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.map,
                                        size:
                                            MediaQuery.of(context).size.width *
                                                0.14,
                                        color: Color(0xFF345FB4),
                                        shadows: [
                                          Shadow(
                                            offset: Offset(2, 2),
                                            blurRadius: 4,
                                            color: Colors.grey,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'ແຂວງ',
                                      style: TextStyle(
                                        color: Color(0xFF345FB4),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        fontFamily: 'Phetsarath',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
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
