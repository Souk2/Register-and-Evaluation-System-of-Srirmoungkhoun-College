//import 'package:appbasic/screens/AddUnitScreen.dart';

// import 'package:flutter/foundation.dart';
// import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:registration_evaluation_app/screens/academic/managements/districts/EditDistrictScreen.dart';
import 'package:registration_evaluation_app/screens/academic/managements/districts/AddDistrictScreen.dart';
import 'package:registration_evaluation_app/screens/academic/managements/provinces/AddProvinceScreen.dart';
import 'package:registration_evaluation_app/services/DistrictService.dart';
import '../../../../services/ProvinceService.dart';

// import 'package:http/http.dart' as http;

class DistrictScreen extends StatefulWidget {
  const DistrictScreen({super.key});

  @override
  State<DistrictScreen> createState() => _DistrictScreenState();
}

class _DistrictScreenState extends State<DistrictScreen> {
  List<dynamic> districts = [];

  TextEditingController txtsearch = TextEditingController();
  TextEditingController _searchController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    fetchDistricts();
    // fetchSearchDistricts();
  }

  void fetchSearchDistricts({String? searchQuery}) async {
    try {
      final fetchedDistricts = searchQuery == null || searchQuery.isEmpty
          ? await Districtservice.getDistricts()
          : await Districtservice.searchDistricts(searchQuery);
      setState(() {
        districts = fetchedDistricts;
      });
    } catch (e) {
      print("Error:$e");
    }
  }

  void fetchDistricts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final fetchedDistricts = await Districtservice.getDistricts();
      setState(() {
        districts = fetchedDistricts;
      });
    } catch (e) {
      print("Error: $e");
    }

    setState(() {
      _isLoading = false;
    });
  }

  void deleteDistricts(int dsid) async {
    bool success = await Districtservice.deleteDistrict(dsid);

    if (success) {
      fetchDistricts();
    }
  }

  void ConfirmDelete(int dsid) async {
    print("confirmDelete call for ID: $dsid");
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
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                'ຍົກເລີກ',
                style: TextStyle(
                  fontFamily: 'Phetsarath',
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                //showAlert();
                deleteDistricts(dsid);
                showAlert();
              },
              child: Text(
                'ລຶບ',
                style: TextStyle(
                  fontFamily: 'Phetsarath',
                ),
              ),
            ),
          ],
        );
      },
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.blueAccent,
        title: Text(
          'ເມືອງ',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Phetsarath',
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Container(
            height: 40,
            margin: EdgeInsets.all(10),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'ຄົ້ນຫາເມືອງ...',
                hintStyle: TextStyle(
                  fontFamily: 'Phetsarath',
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    fetchSearchDistricts(searchQuery: _searchController.text);
                  },
                ),
              ),
            ),
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
                  pageBuilder: (a, b, c) => DistrictScreen(), // โหลดหน้าใหม่ทับ
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
                        builder: (context) => AddDistrictScreen(),
                      ),
                    ).then((value) {
                      // This code will execute when PageB is popped.
                      // You can call setState() here to refresh PageA.
                      setState(() {
                        // For example, refetch data
                        fetchDistricts();
                      });
                    }),
                  }, // Opens the book entry dialog
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: Colors.white),
                      Text(
                        'ເພີ່ມເມືອງໃຫມ່',
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
                : districts.isEmpty
                    ? Center(
                        child: Text(
                          "!ບໍ່ພົບຊໍ້ມູນ ຫຼື ຂາດການເຊື່ອມຕໍ່!",
                          style: TextStyle(
                            fontFamily: 'Phetsarath',
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: districts.length,
                        itemBuilder: (context, index) {
                          final district = districts[index];
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
                                      // Text(
                                      //   'ລະຫັດ: ${province['pid']}',
                                      //   style: TextStyle(fontWeight: FontWeight.bold),
                                      // ),
                                      // Text(
                                      //   'ແຂວງ: ${province['pname']}',
                                      //   style: TextStyle(fontWeight: FontWeight.bold),
                                      // ),
                                      Text(
                                        '${district['dname']}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          fontFamily: 'Phetsarath',
                                        ),
                                      ),
                                      Text(
                                        'ແຂວງ: ${district['pname']}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
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
                                                        EditDistrictScreen(
                                                      dsid: district['dsid'],
                                                      dname: district['dname'],
                                                      pid: district['pid'],
                                                    ),
                                                  ),
                                                );
                                                if (result == true) {
                                                  // It would be refresh the informations in this Page
                                                  setState(() {
                                                    fetchDistricts();
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
                                                ConfirmDelete(district['dsid']),
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
