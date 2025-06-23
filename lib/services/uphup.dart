// import 'dart:convert';
// import 'dart:io';

// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';

// class Studentservice {
//   final String server_url =
//       "https://api.cloudinary.com/v1_1/dn2zd5mfm/image/upload";
//   Future<String> upLoadImageToCloud(File image, BuildContext context) async {
//     final uri = Uri.parse(server_url);
//     final preset = "student";
//     try {
//       final request = http.MultipartRequest('POST', uri)
//         ..fields['upload_preset'] = preset
//         ..files.add(await http.MultipartFile.fromPath('file', image.path));

//       final response = await request.send();
//       if (response.statusCode == 200) {
//         final resData = await response.stream.bytesToString();
//         final jsonResponse = jsonDecode(resData);
//         return jsonResponse["secure_url"];
//       } else {
//         final resData = await response.stream.bytesToString();
//         // showAlert(context, "ຂໍ້ຄວາມ", "${resData}", "ຕົກລົງ");
//       }
//     } catch (e) {
//       // showAlert(context, "ຂໍ້ຄວາມ", "${e}", "ຕົກລົງ");
//     }
//     return "";
//   }
// }
