import 'dart:convert';
import 'package:http/http.dart' as http;

class Classroomservice {
  // static const String baseUrl = "http://192.168.0.104:3000";
  // static const String baseUrl = "http://192.168.61.95:3000";
  static const String baseUrl = "http://10.34.90.133:3000";

  // Function get Majors
  static Future<List<dynamic>> getClassrooms() async {
    final response = await http.get(Uri.parse("$baseUrl/class"));
    print("API response: ${response.body}");
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load unit: ${response.statusCode}");
    }
  }

  static Future<List<dynamic>> searchClassrooms(String classroom) async {
    final response = await http.get(
      Uri.parse("$baseUrl/class/search?classroom=$classroom"),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to search Classrooms: ${response.statusCode}");
    }
  }

  // Function Add Classrooms
  static Future<bool> addClassrooms(String classroom) async {
    final response = await http.post(
      Uri.parse("$baseUrl/class/create"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"classroom": classroom}),
    );
    return response.statusCode == 201;
  }

  // Function Delete Classrooms
  static Future<bool> deleteClassrooms(int classID) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/class/delete/$classID"),
    );
    return response.statusCode == 200;
  }

  // Function Update Classrooms
  static Future<bool> updateClassrooms(int classID, String classroom) async {
    final response = await http.put(
      Uri.parse("$baseUrl/class/update/$classID"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"classroom": classroom}),
    );
    return response.statusCode == 200;
  }
}
