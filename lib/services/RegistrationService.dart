import 'dart:convert';
import 'package:http/http.dart' as http;

class Registrationservice {
  static const String baseUrl = "http://192.168.0.104:3000";
  // static const String baseUrl = "http://192.168.61.95:3000";
  // Function get District

  // Function Add District
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
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/std/create"),
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
        "SyearID": SyearID,
        "mid": mid,
        "classID": classID,
        "sem_id": sem_id,
        "yearS_id": yearS_id,
        "paySt_ID": paySt_ID,
        "statusID": statusID,
      }),
    );
    return response.statusCode == 201;
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
