import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class Registrationservice {
  // static const String baseUrl = "http://192.168.0.104:3000";
  static const String baseUrl = "http:/10.34.90.133:3000";
  // Function get District

  // Function Add District
  // static Future<bool> addStudent(
  //   String stdID,
  //   File? imageFile, // เพิ่มภาพเข้ามาด้วย
  //   String stdName,
  //   String stdSurname,
  //   String dob,
  //   String gender,
  //   String village,
  //   int dsid,
  //   String villageOfB,
  //   int dsBid,
  //   String phoneNum,
  //   String email,
  //   int SyearID,
  //   int mid,
  //   int classID,
  //   int sem_id,
  //   int yearS_id,
  //   int paySt_ID,
  //   int statusID,
  //   int? regis_id,
  // ) async {
  //   final response = await http.post(
  //     Uri.parse("$baseUrl/std/create"),
  //     headers: {"Content-Type": "application/json"},
  //     body: jsonEncode({
  //       "stdID": stdID,
  //       "stdName": stdName,
  //       "stdSurname": stdSurname,
  //       "dob": dob,
  //       "gender": gender,
  //       "village": village,
  //       "dsid": dsid,
  //       "villageOfB": villageOfB,
  //       "dsBid": dsBid,
  //       "phoneNum": phoneNum,
  //       "email": email,
  //       "SyearID": SyearID,
  //       "mid": mid,
  //       "classID": classID,
  //       "sem_id": sem_id,
  //       "yearS_id": yearS_id,
  //       "paySt_ID": paySt_ID,
  //       "statusID": statusID,
  //       "regis_id": regis_id,
  //     }),
  //   );
  //   return response.statusCode == 201;
  // }

  static Future<bool> addStudent(
    String stdID,
    String stdName,
    String stdSurname,
    String dob,
    String gender,
    String village,
    int dsid,
    String villageOfB,
    int dsBid,
    String phoneNum,
    String email,
    int SyearID,
    int mid,
    int classID,
    int sem_id,
    int yearS_id,
    int paySt_ID,
    int statusID,
    int? regis_id,
    File? imageFile, // เพิ่มภาพเข้ามาด้วย
  ) async {
    try {
      var uri = Uri.parse("$baseUrl/std/create");
      var request = http.MultipartRequest('POST', uri);

      // ส่งค่าต่างๆ เป็น fields
      request.fields['stdID'] = stdID;
      request.fields['stdName'] = stdName;
      request.fields['stdSurname'] = stdSurname;
      request.fields['dob'] = dob;
      request.fields['gender'] = gender;
      request.fields['village'] = village;
      request.fields['dsid'] = dsid.toString();
      request.fields['villageOfB'] = villageOfB;
      request.fields['dsBid'] = dsBid.toString();
      request.fields['phoneNum'] = phoneNum;
      request.fields['email'] = email;
      request.fields['SyearID'] = SyearID.toString();
      request.fields['mid'] = mid.toString();
      request.fields['classID'] = classID.toString();
      request.fields['sem_id'] = sem_id.toString();
      request.fields['yearS_id'] = yearS_id.toString();
      request.fields['paySt_ID'] = paySt_ID.toString();
      request.fields['statusID'] = statusID.toString();
      request.fields['regis_id'] = regis_id.toString();

      // ส่งรูปภาพ (ถ้ามี)
      if (imageFile != null) {
        request.files
            .add(await http.MultipartFile.fromPath('image', imageFile.path));
      }

      var response = await request.send();
      return response.statusCode == 201;
    } catch (e) {
      print("Upload error: $e");
      return false;
    }
  }

  static Future<bool> reNewStudentsPay(
    String stdID,
    String stdName,
    String stdSurname,
    int? classID,
  ) async {
    final response = await http.put(
      Uri.parse("$baseUrl/std/update/regis/$stdID"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "stdName": stdName,
        "stdSurname": stdSurname,
        "classID": classID,
      }),
    );
    return response.statusCode == 200;
  }

  // Function Update std
  static Future<bool> reOldStudents(
    String stdID,
    String stdName,
    String stdSurname,
    int? classID,
    int? sem_id,
    int? regis_id,
  ) async {
    final response = await http.put(
      Uri.parse("$baseUrl/std/update/regis/$stdID"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "stdName": stdName,
        "stdSurname": stdSurname,
        "classID": classID,
        "sem_id": sem_id,
        "regis_id": regis_id,
      }),
    );
    return response.statusCode == 200;
  }

  // Function Delete District
  static Future<bool> deleteDistrict(int dsid) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/district/delete/$dsid"),
    );
    return response.statusCode == 200;
  }

  // Function Update District
  static Future<bool> updateDistrict(int dsid, String dname, int? value) async {
    final response = await http.put(
      Uri.parse("$baseUrl/district/update/$dsid"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"dname": dname, "pid": value}),
    );
    return response.statusCode == 200;
  }
}
