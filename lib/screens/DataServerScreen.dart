// import 'package:flutter/material.dart';
// import 'package:registration_evaluation_app/screens/DistrictScreen.dart';
// import 'package:registration_evaluation_app/screens/ProvinceScreen.dart';
// // import 'package:registration_evaluation_app/screens/district_screen.dart';
// // import 'package:registration_evaluation_app/screens/home_screen.dart';
// // import 'package:registration_evaluation_app/screens/province_screen.dart';
// // import 'package:registration_evaluation_app/screens/test_screen.dart';
// // import 'package:registration_evaluation_app/widgets/buildUserInfoCard.dart';
// // import 'package:registration_evaluation_app/widgets/custom_scaffold.dart';
// // import '../theme/theme.dart';

// // List<Widget> itmpage = [HomeScreen(), DataserviceScreen()];
// List<Widget> itmpage = [DataserviceScreen()];

// class DataserviceScreen extends StatefulWidget {
//   const DataserviceScreen({super.key});

//   @override
//   State<DataserviceScreen> createState() => _DataserviceScreenState();
// }

// class _DataserviceScreenState extends State<DataserviceScreen> {
//   final _formSignInKey = GlobalKey<FormState>();
//   bool rememberPassword = true;
//   int idx = 1;

//   void ontabpPed(BuildContext context, int indx) {
//     setState(() {
//       idx = indx;
//     });

//     // ນຳທາງໄປໜ້າໃໝ່
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => itmpage[indx]),
//     );
//   }

//   Widget BottomBar() {
//     return BottomNavigationBar(
//       backgroundColor: Color(0xFF345FB4),
//       selectedIconTheme: IconThemeData(color: Colors.white, size: 35),
//       selectedLabelStyle: TextStyle(
//         color: Colors.white,
//         fontWeight: FontWeight.bold,
//       ),
//       selectedFontSize: 15,
//       selectedItemColor: Colors.white,
//       type: BottomNavigationBarType.fixed,
//       currentIndex: idx,
//       onTap: (index) {
//         ontabpPed(context, index); // ປ່ຽນ index ຂອງໜ້າປະຈຸບັນ
//       },
//       items: [
//         BottomNavigationBarItem(
//           icon: Icon(Icons.home),
//           label: "ໜ້າຫຼັກ",
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.archive_outlined),
//           label: "ຈັດການຂໍ້ມູນ",
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.microwave_outlined),
//           label: "ຕາຕະລາງຮຽນ",
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.settings_rounded),
//           label: "ຕັ້ງຄ່າ",
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CustomScaffold(
//       child: Column(
//         children: [
//           buildUserInfoCard(),
//           const Expanded(flex: 1, child: SizedBox(height: 10)),
//           Expanded(
//             flex: 166,
//             child: Container(
//               padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(40.0),
//                   topRight: Radius.circular(40.0),
//                 ),
//               ),
//               child: SingleChildScrollView(
//                 child: Form(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Container(
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(3),
//                         ),
//                         padding: EdgeInsets.all(6),
//                         margin: EdgeInsets.all(5),
//                         child: Column(
//                           children: [
//                             Text(
//                               'ປ້ອນຂໍ້ມູນ',
//                               style: TextStyle(
//                                 color: Color(0xFF345FB4),
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 20,
//                               ),
//                             ),
//                             SizedBox(height: 10),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: [
//                                 Column(
//                                   children: [
//                                     ElevatedButton(
//                                       onPressed: () {
//                                         // Navigator.push(
//                                         //   context,
//                                         //   MaterialPageRoute(
//                                         //     builder: (context) =>
//                                         //         const ProductShoppingScreen(),
//                                         //   ),
//                                         // );
//                                       },
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: Colors.white,
//                                         minimumSize: Size(80, 80),
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(
//                                             10,
//                                           ),
//                                         ),
//                                       ),
//                                       child: Icon(
//                                         Icons.badge_outlined,
//                                         size: 30,
//                                         color: Color(0xFF345FB4),
//                                         shadows: [
//                                           Shadow(
//                                             offset: Offset(2, 2),
//                                             blurRadius: 4,
//                                             color: Colors.grey,
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     SizedBox(height: 5),
//                                     Text(
//                                       'ນັກສຶກສາ',
//                                       style: TextStyle(
//                                         color: Color(0xFF345FB4),
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 Column(
//                                   children: [
//                                     ElevatedButton(
//                                       onPressed: () => {
//                                         // Navigator.push(
//                                         //   context,
//                                         //   MaterialPageRoute(
//                                         //     builder: (context) => const ProductScreen(),
//                                         //   ),
//                                         // )
//                                       },
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: Colors.white,
//                                         minimumSize: Size(80, 80),
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(
//                                             10,
//                                           ),
//                                         ),
//                                       ),
//                                       child: Icon(
//                                         Icons.wallet_giftcard_outlined,
//                                         color: Color(0xFF345FB4),
//                                         shadows: [
//                                           Shadow(
//                                             offset: Offset(2, 2),
//                                             blurRadius: 4,
//                                             color: Colors.grey,
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     SizedBox(height: 5),
//                                     Text(
//                                       'ຫ້ອງຮຽນ',
//                                       style: TextStyle(
//                                         color: Color(0xFF345FB4),
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 Column(
//                                   children: [
//                                     ElevatedButton(
//                                       onPressed: () => {
//                                         // Navigator.push(
//                                         //   context,
//                                         //   MaterialPageRoute(
//                                         //     builder: (context) => const CategoryScreen(),
//                                         //   ),
//                                         // )
//                                       },
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: Colors.white,
//                                         minimumSize: Size(80, 80),
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(
//                                             10,
//                                           ),
//                                         ),
//                                       ),
//                                       child: Icon(
//                                         Icons.auto_stories_outlined,
//                                         size: 30,
//                                         color: Color(0xFF345FB4),
//                                         shadows: [
//                                           Shadow(
//                                             offset: Offset(2, 2),
//                                             blurRadius: 4,
//                                             color: Colors.grey,
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     SizedBox(height: 5),
//                                     Text(
//                                       'ວິຊາຮຽນ',
//                                       style: TextStyle(
//                                         color: Color(0xFF345FB4),
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 Column(
//                                   children: [
//                                     ElevatedButton(
//                                       onPressed: () => {
//                                         // Navigator.push(
//                                         //   context,
//                                         //   MaterialPageRoute(
//                                         //     builder: (context) => const UnitScreen(),
//                                         //   ),
//                                         // )
//                                       },
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: Colors.white,
//                                         minimumSize: Size(80, 80),
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(
//                                             10,
//                                           ),
//                                         ),
//                                       ),
//                                       child: Icon(
//                                         Icons.add_box,
//                                         size: 30,
//                                         color: Color(0xFF345FB4),
//                                         shadows: [
//                                           Shadow(
//                                             offset: Offset(2, 2),
//                                             blurRadius: 4,
//                                             color: Colors.grey,
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     SizedBox(height: 5),
//                                     Text(
//                                       'ສາຂາຮຽນ',
//                                       style: TextStyle(
//                                         color: Color(0xFF345FB4),
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: 5),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: [
//                                 Column(
//                                   children: [
//                                     ElevatedButton(
//                                       onPressed: () {},
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: Colors.white,
//                                         minimumSize: Size(80, 80),
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(
//                                             10,
//                                           ),
//                                         ),
//                                       ),
//                                       child: Icon(
//                                         Icons.assignment_ind_outlined,
//                                         size: 30,
//                                         color: Color(0xFF345FB4),
//                                         shadows: [
//                                           Shadow(
//                                             offset: Offset(2, 2),
//                                             blurRadius: 4,
//                                             color: Colors.grey,
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     SizedBox(height: 5),
//                                     Text(
//                                       'ພະນັກງານ',
//                                       style: TextStyle(
//                                         color: Color(0xFF345FB4),
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 Column(
//                                   children: [
//                                     ElevatedButton(
//                                       onPressed: () {
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (e) => MyComboBoxWithApi(),
//                                           ),
//                                         );
//                                       },
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: Colors.white,
//                                         minimumSize: Size(80, 80),
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(
//                                             10,
//                                           ),
//                                         ),
//                                       ),
//                                       child: Icon(
//                                         Icons.wallet_giftcard_outlined,
//                                         color: Color(0xFF345FB4),
//                                         shadows: [
//                                           Shadow(
//                                             offset: Offset(2, 2),
//                                             blurRadius: 4,
//                                             color: Colors.grey,
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     SizedBox(height: 5),
//                                     Text(
//                                       'ຄະແນນ',
//                                       style: TextStyle(
//                                         color: Color(0xFF345FB4),
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 Column(
//                                   children: [
//                                     ElevatedButton(
//                                       onPressed: () {
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (e) =>
//                                                 const DistrictScreen(),
//                                           ),
//                                         );
//                                       },
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: Colors.white,
//                                         minimumSize: Size(80, 80),
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(
//                                             10,
//                                           ),
//                                         ),
//                                       ),
//                                       child: Icon(
//                                         Icons.location_city,
//                                         size: 30,
//                                         color: Color(0xFF345FB4),
//                                         shadows: [
//                                           Shadow(
//                                             offset: Offset(2, 2),
//                                             blurRadius: 4,
//                                             color: Colors.grey,
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     SizedBox(height: 5),
//                                     Text(
//                                       'ເມືອງ',
//                                       style: TextStyle(
//                                         color: Color(0xFF345FB4),
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 Column(
//                                   children: [
//                                     ElevatedButton(
//                                       onPressed: () {
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (e) =>
//                                                 const ProvinceScreen(),
//                                           ),
//                                         );
//                                       },
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: Colors.white,
//                                         minimumSize: Size(80, 80),
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(
//                                             10,
//                                           ),
//                                         ),
//                                       ),
//                                       child: Icon(
//                                         Icons.map,
//                                         size: 30,
//                                         color: Color(0xFF345FB4),
//                                         shadows: [
//                                           Shadow(
//                                             offset: Offset(2, 2),
//                                             blurRadius: 4,
//                                             color: Colors.grey,
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     SizedBox(height: 5),
//                                     Text(
//                                       'ແຂວງ',
//                                       style: TextStyle(
//                                         color: Color(0xFF345FB4),
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: 25),
//                             Text(
//                               'ລາຍງານ',
//                               style: TextStyle(
//                                 color: Color(0xFF345FB4),
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 20,
//                               ),
//                             ),
//                             SizedBox(height: 5),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: [
//                                 Column(
//                                   children: [
//                                     ElevatedButton(
//                                       onPressed: () {},
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: Colors.white,
//                                         minimumSize: Size(80, 80),
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(
//                                             10,
//                                           ),
//                                         ),
//                                       ),
//                                       child: Icon(
//                                         Icons.article_outlined,
//                                         size: 30,
//                                         color: Color(0xFF345FB4),
//                                         shadows: [
//                                           Shadow(
//                                             offset: Offset(2, 2),
//                                             blurRadius: 4,
//                                             color: Colors.grey,
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     SizedBox(height: 5),
//                                     Text(
//                                       'ການລົງທະບຽນ',
//                                       style: TextStyle(
//                                         color: Color(0xFF345FB4),
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 Column(
//                                   children: [
//                                     ElevatedButton(
//                                       onPressed: () {},
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: Colors.white,
//                                         minimumSize: Size(80, 80),
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(
//                                             10,
//                                           ),
//                                         ),
//                                       ),
//                                       child: Icon(
//                                         Icons.assessment_outlined,
//                                         size: 30,
//                                         color: Color(0xFF345FB4),
//                                         shadows: [
//                                           Shadow(
//                                             offset: Offset(2, 2),
//                                             blurRadius: 4,
//                                             color: Colors.grey,
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     SizedBox(height: 5),
//                                     Text(
//                                       'ປະເມີນນັກສຶກສາ',
//                                       style: TextStyle(
//                                         color: Color(0xFF345FB4),
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 Column(
//                                   children: [
//                                     ElevatedButton(
//                                       onPressed: () {},
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: Colors.white,
//                                         minimumSize: Size(80, 80),
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(
//                                             10,
//                                           ),
//                                         ),
//                                       ),
//                                       child: Icon(
//                                         Icons.chrome_reader_mode_outlined,
//                                         size: 30,
//                                         color: Color(0xFF345FB4),
//                                         shadows: [
//                                           Shadow(
//                                             offset: Offset(2, 2),
//                                             blurRadius: 4,
//                                             color: Colors.grey,
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     SizedBox(height: 5),
//                                     Text(
//                                       'ຮັບໃບຄຳຮ້ອງ',
//                                       style: TextStyle(
//                                         color: Color(0xFF345FB4),
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           BottomBar(),
//         ],
//       ),
//     );
//   }
// }
