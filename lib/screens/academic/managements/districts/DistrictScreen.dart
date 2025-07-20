//import 'package:appbasic/screens/AddUnitScreen.dart';

// import 'package:flutter/foundation.dart';
// import 'dart:convert';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:registration_evaluation_app/screens/academic/managements/districts/EditDistrictScreen.dart';
import 'package:registration_evaluation_app/screens/academic/managements/districts/AddDistrictScreen.dart';
import 'package:registration_evaluation_app/screens/academic/managements/provinces/AddProvinceScreen.dart';
import 'package:registration_evaluation_app/services/DistrictService.dart';
import '../../../../services/ProvinceService.dart';
import 'package:http/http.dart' as http;

// import 'package:http/http.dart' as http;

class DistrictScreen extends StatefulWidget {
  const DistrictScreen({super.key});

  @override
  State<DistrictScreen> createState() => _DistrictScreenState();
}

class _DistrictScreenState extends State<DistrictScreen> {
  List<dynamic> districts = [];

  TextEditingController _searchController = TextEditingController();

  List<dynamic> provinceData = []; // use from dropdownbutton
  int? _valueProvince; // use from dropdownbutton

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    fetchDistricts();
    _fetchAllDropdownData();
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

  // static const String baseUrl = "http://192.168.0.104:3000";

  static const String baseUrl = "http://10.34.90.133:3000";

  Future<void> _fetchAllDropdownData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 1. สร้าง List ของ Future สำหรับแต่ละ API call
      List<Future<http.Response>> futures = [
        http.get(Uri.parse("$baseUrl/province")),
        // เพิ่ม API ตัวอื่นๆ ได้ตามต้องการ
      ];

      // 2. ใช้ Future.wait เพื่อรอให้ทุก API call เสร็จสิ้นพร้อมกัน
      List<http.Response> responses = await Future.wait(futures);

      // 3. ตรวจสอบและประมวลผลข้อมูลจากแต่ละ API

      if (responses[0].statusCode == 200) {
        provinceData = jsonDecode(responses[0].body);
        print('ປີຮຽນ data loaded: ${provinceData.length} items');
      } else {
        throw Exception(
            'Failed to load provinces data: ${responses[0].statusCode}');
      }

      // 4. อัปเดต UI หลังจากข้อมูลทั้งหมดโหลดเสร็จสมบูรณ์
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'An unexpected error occurred: $error';
      });
      print('Error fetching all dropdown data: $error');
    }
  }

  List<dynamic> get filteredDistrict {
    return districts.where((district) {
      final matchesProvince =
          _valueProvince == null || district['pid'] == _valueProvince;
      return matchesProvince;
    }).toList();
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
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
              style: TextStyle(
                fontFamily: 'Phetsarath',
              ),
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
              SizedBox(
                width: 100,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black, width: 1), // Border
                  ),
                  child: DropdownButton(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    underline: SizedBox.shrink(),
                    borderRadius: BorderRadius.circular(20),
                    isExpanded: true,
                    items: provinceData.map((e) {
                      return DropdownMenuItem(
                        child: Text(
                          e["pname"],
                          style: TextStyle(
                            fontFamily: 'Phetsarath',
                          ),
                        ),
                        value: e["pid"],
                      );
                    }).toList(),
                    value: _valueProvince,
                    onChanged: (v) {
                      setState(() {
                        _valueProvince = v as int;
                      });
                    },
                    hint: Text(
                      "ແຂວງ",
                      style: TextStyle(
                        fontFamily: 'Phetsarath',
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 100,
              ),
            ],
          ),
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
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                    backgroundColor: Color(0xFFfb5b54),
                  ),
                ),
              ),
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
                : filteredDistrict.isEmpty
                    ? Center(
                        child: Text(
                          "!ບໍ່ພົບຂໍ້ມູນ ຫຼື ຂາດການເຊື່ອມຕໍ່!",
                          style: TextStyle(
                            fontFamily: 'Phetsarath',
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredDistrict.length,
                        itemBuilder: (context, index) {
                          final district = filteredDistrict[index];
                          return Card(
                            margin: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(10),
                                splashColor: Colors.blueAccent
                                    .withOpacity(0.3), // สีของ ripple effect
                                // hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  bool? result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditDistrictScreen(
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
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Spacer(),
                                    Column(
                                      // crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
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
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                  ],
                                ),
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
