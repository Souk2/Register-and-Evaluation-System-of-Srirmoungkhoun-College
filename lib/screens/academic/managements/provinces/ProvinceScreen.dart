//import 'package:appbasic/screens/AddUnitScreen.dart';

// import 'package:flutter/foundation.dart';
// import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:registration_evaluation_app/screens/academic/managements/provinces/AddProvinceScreen.dart';
import 'package:registration_evaluation_app/screens/academic/managements/provinces/EditProvinceScreen.dart';
import '../../../../services/ProvinceService.dart';

// import 'package:http/http.dart' as http;

class ProvinceScreen extends StatefulWidget {
  const ProvinceScreen({super.key});

  @override
  State<ProvinceScreen> createState() => _ProvinceScreenState();
}

class _ProvinceScreenState extends State<ProvinceScreen> {
  List<dynamic> provinces = [];

  TextEditingController txtsearch = TextEditingController();
  TextEditingController _searchController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    fetchProvinces();
    // fetchSearchProvinces();
  }

  void fetchSearchProvinces({String? searchQuery}) async {
    try {
      final fetchedProvinces = searchQuery == null || searchQuery.isEmpty
          ? await Provinceservice.getProvinces()
          : await Provinceservice.searchProvinces(searchQuery);
      setState(() {
        provinces = fetchedProvinces;
      });
    } catch (e) {
      print("Error:$e");
    }
  }

  void fetchProvinces() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final fetchedProvinces = await Provinceservice.getProvinces();
      setState(() {
        provinces = fetchedProvinces;
      });
    } catch (e) {
      print("Error: $e");
    }

    setState(() {
      _isLoading = false;
    });
  }

  void deleteProvince(int pid) async {
    bool success = await Provinceservice.deleteProvince(pid);

    if (success) {
      fetchProvinces();
    }
  }

  void showAlert() {
    QuickAlert.show(
      context: context,
      title: "ການປ່ຽນແປງສຳເລັດ",
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

  void ConfirmDelete(int pid) async {
    print("confirmDelete call for ID: $pid");
    if (!mounted) {
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('ຢືນຍັນການລຶບ'),
          content: Text(
            'ທ່ານແນ່ໃຈວ່າຈະລຶບຫຼືບໍ່?',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text('ຍົກເລີກ'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                //showAlert();
                deleteProvince(pid);
                showAlert();
              },
              child: Text('ລຶບ'),
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
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.blueAccent,
        title: Text(
          'ແຂວງ',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Phetsarath',
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orangeAccent,
              shape: CircleBorder(),
              padding: EdgeInsets.all(10),
            ),
            onPressed: () {
              // TODO: Refresh action
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (a, b, c) => ProvinceScreen(), // โหลดหน้าใหม่ทับ
                  transitionDuration: Duration.zero,
                ),
              );
            },
            child: Icon(
              Icons.refresh,
              color: Colors.white,
              size: 25,
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
                hintText: 'ຄົ້ນຫາແຂວງ...',
                hintStyle: TextStyle(
                  fontFamily: 'Phetsarath',
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    fetchSearchProvinces(searchQuery: _searchController.text);
                  },
                ),
              ),
            ),
          ),
        ),
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
                        builder: (context) => AddProvinceScreen(),
                      ),
                    ).then((value) {
                      // This code will execute when PageB is popped.
                      // You can call setState() here to refresh PageA.
                      setState(() {
                        // For example, refetch data
                        fetchProvinces();
                      });
                    }),
                  }, // Opens the book entry dialog
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: Colors.white),
                      Text(
                        'ເພີ່ມແຂວງໃຫມ່',
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
              // PopupMenuButton(
              //   itemBuilder: (context) => [
              //     PopupMenuItem(
              //       child: Column(
              //         children: [],
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
          SizedBox(height: 10),
          Expanded(
            child: _isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(), // loading icon
                        SizedBox(height: 10),
                        Text(
                          'ໂລດຂໍ້ມູນ...',
                          style: TextStyle(
                            fontFamily: 'Phetsarath',
                          ),
                        ),
                      ],
                    ),
                  )
                : provinces.isEmpty
                    ? Center(
                        child: Text(
                          "!ບໍ່ພົບຊໍ້ມູນ ຫຼື ຂາດການເຊື່ອມຕໍ່!",
                          style: TextStyle(
                            fontFamily: 'Phetsarath',
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: provinces.length,
                        itemBuilder: (context, index) {
                          final province = provinces[index];
                          return Card(
                            margin: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: Row(
                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Spacer(),
                                  Column(
                                    // crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // ),
                                      Text(
                                        '${province['pname']}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          fontFamily: 'Phetsarath',
                                        ),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  PopupMenuButton(
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
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
                                                // To close PopUpMenuB
                                                Navigator.of(context).pop();
                                                bool? result =
                                                    await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditProvinceScreen(
                                                      pid: province['pid'],
                                                      pname: province['pname'],
                                                    ),
                                                  ),
                                                );
                                                if (result == true) {
                                                  // It would be refresh the informations in this Page
                                                  setState(() {
                                                    fetchProvinces();
                                                  });
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
                                                Navigator.of(context).pop(),
                                                ConfirmDelete(province['pid']),
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(Icons.delete,
                                                      color: Colors.white),
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
                                                backgroundColor:
                                                    Colors.redAccent,
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
