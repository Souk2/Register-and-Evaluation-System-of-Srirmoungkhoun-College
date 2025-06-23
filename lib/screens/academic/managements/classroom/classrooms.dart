import 'package:flutter/material.dart';
import 'package:registration_evaluation_app/screens/academic/managements/classroom/addClassroom.dart';
import 'package:registration_evaluation_app/screens/academic/managements/classroom/editClassroom.dart';
import 'package:registration_evaluation_app/screens/academic/managements/majors/addMajor.dart';
import 'package:registration_evaluation_app/screens/academic/managements/majors/editMajor.dart';
import 'package:registration_evaluation_app/services/ClassroomService.dart';
import 'package:registration_evaluation_app/services/MajorService.dart';
import 'package:quickalert/quickalert.dart';

class Classrooms extends StatefulWidget {
  const Classrooms({super.key});

  @override
  State<Classrooms> createState() => _ClassroomsState();
}

class _ClassroomsState extends State<Classrooms> {
  List<dynamic> classrooms = [];
  TextEditingController txtsearch = TextEditingController();
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchClassrooms();
  }

  void fetchSearchClassrooms({String? searchQuery}) async {
    try {
      final fetchedClassrooms = searchQuery == null || searchQuery.isEmpty
          ? await Classroomservice.getClassrooms()
          : await Classroomservice.searchClassrooms(searchQuery);
      setState(() {
        classrooms = fetchedClassrooms;
      });
    } catch (e) {
      print("Error:$e");
    }
  }

  void fetchClassrooms() async {
    try {
      final fetchedMajors = await Classroomservice.getClassrooms();
      setState(() {
        classrooms = fetchedMajors;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  void deleteClassrooms(int classID) async {
    bool success = await Classroomservice.deleteClassrooms(classID);

    if (success) {
      fetchClassrooms();
    }
  }

  void showAlert() {
    QuickAlert.show(
      context: context,
      title: "ບັນທຶກສຳເລັດ",
      type: QuickAlertType.success,
      confirmBtnTextStyle: TextStyle(
        fontFamily: 'Phetsarath',
        color: Colors.white, // Replace with your desired font
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      confirmBtnColor: Colors.green,
      confirmBtnText: "ຕົກລົງ",
    );
  }

  void ConfirmDelete(int classID) async {
    print("confirmDelete call for ID: $classID");
    if (!mounted) {
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            'ຢືນຍັນການລຶບ',
            style: TextStyle(
              fontFamily: 'Phetsarath',
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'ທ່ານແນ່ໃຈວ່າຈະລຶບຫຼືບໍ່?',
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'Phetsarath',
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: Size(
                  80,
                  50,
                ), // ປັບຂະໜາດ (ກວ້າງ x ສູງ)
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                'ຍົກເລີກ',
                style: TextStyle(
                  fontFamily: 'Phetsarath',
                  color: Colors.white,
                ),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: Size(
                  80,
                  50,
                ), // ປັບຂະໜາດ (ກວ້າງ x ສູງ)
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                //showAlert();
                deleteClassrooms(classID);

                showAlert();
              },
              child: Text(
                'ລຶບ',
                style: TextStyle(
                  fontFamily: 'Phetsarath',
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ຈັດການຫ້ອງຮຽນ",
          style: TextStyle(
            fontFamily: 'Phetsarath',
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orangeAccent,
              shape: CircleBorder(),
              padding: EdgeInsets.all(16),
            ),
            onPressed: () {
              // TODO: Refresh action
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (a, b, c) => Classrooms(), // โหลดหน้าใหม่ทับ
                  transitionDuration: Duration.zero,
                ),
              );
            },
            child: Icon(
              Icons.refresh,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Container(
            height: 40,
            margin: EdgeInsets.all(10),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'ຄົ້ນຫາຫ້ອງຮຽນ...',
                hintStyle: TextStyle(
                  fontFamily: 'Phetsarath',
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    fetchSearchClassrooms(searchQuery: _searchController.text);
                  },
                ),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          SizedBox(height: 15),
          Row(
            children: [
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddClassroom(),
                      ),
                    ),
                  }, // Opens the book entry dialog
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: Colors.white),
                      Text(
                        'ເພີ່ມຫ້ອງຮຽນໃຫມ່',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Phetsarath',
                        ),
                      ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    backgroundColor: Color(0xFFfb5b54),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: classrooms.length,
              itemBuilder: (context, index) {
                final classroom = classrooms[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Spacer(),
                        Column(
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'ຫ້ອງ ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    fontFamily: 'Phetsarath',
                                  ),
                                ),
                                Text(
                                  '${classroom['classroom']}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    fontFamily: 'Phetsarath',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Spacer(),
                        PopupMenuButton(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'ປຸ່ມຄຳສັ່ງ:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Phetsarath',
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  ElevatedButton(
                                    onPressed: () async {
                                      bool? result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditClassroom(
                                            classID: classroom['classID'],
                                            classroom: classroom['classroom'],
                                          ),
                                        ),
                                      );
                                      if (result == true) {
                                        fetchClassrooms();
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit,
                                            color: Color(0xFF345FB4)),
                                        Text(
                                          'ແກ້ໄຂ',
                                          style: TextStyle(
                                            color: Color(0xFF345FB4),
                                            fontFamily: 'Phetsarath',
                                          ),
                                        ),
                                      ],
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      minimumSize: Size(
                                        80,
                                        50,
                                      ), // ປັບຂະໜາດ (ກວ້າງ x ສູງ)
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: () => {
                                      ConfirmDelete(classroom['classID']),
                                    },
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete, color: Colors.white),
                                        Text(
                                          'ລົບ',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Phetsarath',
                                          ),
                                        ),
                                      ],
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                      minimumSize: Size(
                                        80,
                                        50,
                                      ), // ປັບຂະໜາດ (ກວ້າງ x ສູງ)
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
