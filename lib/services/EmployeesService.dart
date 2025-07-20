import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class Employeesservice {
  // static const String baseUrl = "http://192.168.0.104:3000";
  static const String baseUrl = "http://10.34.90.133:3000";
  // Function get

  static Future<List<dynamic>> getEmployees() async {
    final response = await http.get(Uri.parse("$baseUrl/emp"));
    print("API response: ${response.body}");
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load unit: ${response.statusCode}");
    }
  }

  static Future<List<dynamic>> searchEmployees(String stdName) async {
    final response = await http.get(
      Uri.parse("$baseUrl/emp/search?stdName=$stdName"),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to search std: ${response.statusCode}");
    }
  }

  static Future<bool> addEmployees(
    String staff_id,
    String staff_Name,
    String staff_Surname,
    String dob,
    String gender,
    String village,
    int dsid,
    String phoneNum,
    String email,
    int roleID, // เพิ่มภาพเข้ามาด้วย

    File? imageFile,
  ) async {
    try {
      var uri = Uri.parse("$baseUrl/emp/create");
      var request = http.MultipartRequest('POST', uri);

      // ส่งค่าต่างๆ เป็น fields
      request.fields['staff_id'] = staff_id;
      request.fields['staff_Name'] = staff_Name;
      request.fields['staff_Surname'] = staff_Surname;
      request.fields['dob'] = dob;
      request.fields['gender'] = gender;
      request.fields['village'] = village;
      request.fields['dsid'] = dsid.toString();
      request.fields['phoneNum'] = phoneNum;
      request.fields['email'] = email;
      request.fields['roleID'] = roleID.toString();

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

  // Function Delete
  static Future<bool> deleteEmployees(String stdID) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/emp/delete/$stdID"),
    );
    return response.statusCode == 200;
  }

  // Function Update std
  static Future<bool> updateEmployees(
    String staff_id,
    String staff_Name,
    String staff_Surname,
    String dob,
    String gender,
    String village,
    int dsid,
    String phoneNum,
    String email,
    int roleID,
  ) async {
    final response = await http.put(
      Uri.parse("$baseUrl/emp/update/$staff_id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "staff_Name": staff_Name,
        "staff_Surname": staff_Surname,
        "dob": dob,
        "gender": gender,
        "village": village,
        "dsid": dsid,
        "phoneNum": phoneNum,
        "email": email,
        "roleID": roleID,
      }),
    );
    return response.statusCode == 200;
  }

  // Update PaymentStatus
  static Future<bool> updatePaymentStatus(String stdID, int payStID) async {
    final response = await http.put(
      Uri.parse("$baseUrl/emp/updatePayment/$stdID"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "paySt_id": payStID, // ✅ ต้องตรงกับ backend
      }),
    );

    return response.statusCode == 200;
  }

  static Future<List<dynamic>> getChoTesch() async {
    final response = await http.get(Uri.parse("$baseUrl/emp/teachCho"));
    print("API response: ${response.body}");
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load unit: ${response.statusCode}");
    }
  }

  // Function Add Teacher Subject
  static Future<bool> addTeachSub(
    String staff_id,
    int? classID,
    int? sub_id,
    int? SyearID,
    int? mid,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/emp/teach/create"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "staff_id": staff_id,
        "classID": classID,
        "sub_id": sub_id,
        "SyearID": SyearID,
        "mid": mid,
      }),
    );
    return response.statusCode == 201;
  }

  static Future<bool> updateTeachSub(
    int teachSub_id,
    String staff_id,
    int? classID,
    int? sub_id,
    int? SyearID,
    int? mid,
  ) async {
    final response = await http.put(
      Uri.parse("$baseUrl/emp/teach/update/$teachSub_id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "staff_id": staff_id,
        "classID": classID,
        "sub_id": sub_id,
        "SyearID": SyearID,
        "mid": mid,
      }),
    );
    return response.statusCode == 200;
  }

  // Function Delete Teacher Subject
  static Future<bool> deleteTeachSub(int teachSub_id) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/emp/teach/delete/$teachSub_id"),
    );
    return response.statusCode == 200;
  }
}
