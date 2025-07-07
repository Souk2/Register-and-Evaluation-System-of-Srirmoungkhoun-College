import 'package:flutter/material.dart';
import 'package:registration_evaluation_app/screens/academic/managements/classroom/classrooms.dart';
import 'package:registration_evaluation_app/screens/academic/managements/subjects/subjectPage.dart';
import 'package:registration_evaluation_app/screens/academic/managements/students/studentPage.dart';

class Evaluations extends StatefulWidget {
  const Evaluations({super.key});

  @override
  State<Evaluations> createState() => _EvaluationsState();
}

class _EvaluationsState extends State<Evaluations> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.blueAccent,
        title: Text(
          "ຈັດການປະເມີນຜົນ",
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
                                        color: Colors.green,
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
                                      'ນັກສຶກສາປີ 1',
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
                                        Icons.badge_outlined,
                                        size:
                                            MediaQuery.of(context).size.width *
                                                0.14,
                                        color: Colors.purple,
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
                                      'ນັກສຶກສາປີ 2',
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
                                            builder: (context) =>
                                                const SubjectPage(),
                                          ),
                                        )
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
                                        color: Colors.orange,
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
                                      'ນັກສຶກສາປີ 3',
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
