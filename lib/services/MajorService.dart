import 'dart:convert';
import 'package:http/http.dart' as http;

class Majorservice {
  static const String baseUrl = "http://192.168.0.104:3000";
  // static const String baseUrl = "http://192.168.61.95:3000";

  // Function get Majors
  static Future<List<dynamic>> getMajors() async {
    final response = await http.get(Uri.parse("$baseUrl/major"));
    print("API response: ${response.body}");
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load unit: ${response.statusCode}");
    }
  }

  static Future<List<dynamic>> searchMajors(String m_name) async {
    final response = await http.get(
      Uri.parse("$baseUrl/major/search?m_name=$m_name"),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to search Majors: ${response.statusCode}");
    }
  }

  // Function Add Majors
  static Future<bool> addMajors(String m_name) async {
    final response = await http.post(
      Uri.parse("$baseUrl/major/create"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"m_name": m_name}),
    );
    return response.statusCode == 201;
  }

  // Function Delete Majors
  static Future<bool> deleteMajors(int mid) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/major/delete/$mid"),
    );
    return response.statusCode == 200;
  }

  // Function Update Majors
  static Future<bool> updateMajors(int mid, String m_name) async {
    final response = await http.put(
      Uri.parse("$baseUrl/major/update/$mid"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"m_name": m_name}),
    );
    return response.statusCode == 200;
  }
}
