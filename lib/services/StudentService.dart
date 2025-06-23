import 'dart:convert';
import 'package:http/http.dart' as http;

class Studentservice {
  static const String baseUrl = "http://192.168.0.104:3000";
  // static const String baseUrl = "http://192.168.61.95:3000";
  // Function get

  static Future<List<dynamic>> getStudentsAll() async {
    final response = await http.get(Uri.parse("$baseUrl/std"));
    print("API response: ${response.body}");
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load unit: ${response.statusCode}");
    }
  }

  static Future<List<dynamic>> getStudents() async {
    final response = await http.get(Uri.parse("$baseUrl/std/select"));
    print("API response: ${response.body}");
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load unit: ${response.statusCode}");
    }
  }

  static Future<List<dynamic>> searchStudents(String stdName) async {
    final response = await http.get(
      Uri.parse("$baseUrl/std/search/payment?stdName=$stdName"),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to search std: ${response.statusCode}");
    }
  }

  // Function Delete
  static Future<bool> deleteStudents(String stdID) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/std/delete/$stdID"),
    );
    return response.statusCode == 200;
  }

  // Function Update std
  static Future<bool> updateStudents(
    String stdID,
    String stdName,
    String stdSurname,
    String dob,
    String gender,
    String village,
    int? dsid,
    String villageOfB,
    int? dsBid,
    String phoneNum,
    String email,
    int? mid,
    int? classID,
    int? sem_id,
    int? yearS_id,
    int? statusID,
  ) async {
    final response = await http.put(
      Uri.parse("$baseUrl/std/update/$stdID"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "stdID": stdID,
        "stdName": stdName,
        "stdSurname": stdSurname,
        "dob": dob,
        "gender": gender,
        "village": village,
        "dsid": dsid,
        "villageOfB": villageOfB,
        "dsBid": dsBid,
        "phoneNum": phoneNum,
        "email": email,
        "mid": mid,
        "classID": classID,
        "sem_id": sem_id,
        "yearS_id": yearS_id,
        "statusID": statusID,
      }),
    );
    return response.statusCode == 200;
  }

  // Update PaymentStatus
  static Future<bool> updatePaymentStatus(String stdID, int payStID) async {
    final response = await http.put(
      Uri.parse("$baseUrl/std/updatePayment/$stdID"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "paySt_id": payStID, // ✅ ต้องตรงกับ backend
      }),
    );

    return response.statusCode == 200;
  }
}
