import 'dart:convert';
import 'package:http/http.dart' as http;

class Subjectsservice {
  // static const String baseUrl = "http://192.168.0.104:3000";
  static const String baseUrl = "http://10.34.90.133:3000";
  // Function get Subjects
  static Future<List<dynamic>> getSubjects() async {
    final response = await http.get(Uri.parse("$baseUrl/subjects"));
    print("API response: ${response.body}");
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load unit: ${response.statusCode}");
    }
  }

  static Future<List<dynamic>> searchSubjects(String sub_Name) async {
    final response = await http.get(
      Uri.parse("$baseUrl/subjects/search?sub_Name=$sub_Name"),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to search Subjects: ${response.statusCode}");
    }
  }

  // Function Add Subjects
  static Future<bool> addSubjects(String sub_Name, int SyearID, int mid) async {
    final response = await http.post(
      Uri.parse("$baseUrl/subjects/create"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"sub_Name": sub_Name, "SyearID": SyearID, "mid": mid}),
    );
    return response.statusCode == 201;
  }

  // Function Update Subjects
  static Future<bool> updateSubjects(
    int sub_id,
    String sub_Name,
    int? SyearID,
    int? mid,
  ) async {
    final response = await http.put(
      Uri.parse("$baseUrl/subjects/update/$sub_id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "sub_Name": sub_Name,
        "SyearID": SyearID,
        "mid": mid,
      }),
    );
    return response.statusCode == 200;
  }

  // Function Delete Subjects
  static Future<bool> deleteSubjects(int sub_id) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/subjects/delete/$sub_id"),
    );
    return response.statusCode == 200;
  }
}
