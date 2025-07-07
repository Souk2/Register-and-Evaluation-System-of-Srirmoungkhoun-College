import 'dart:convert';
import 'package:http/http.dart' as http;

class Rolesrvice {
  // static const String baseUrl = "http://192.168.0.104:3000";
  static const String baseUrl = "http://10.34.90.133:3000";

  // Function get Role
  static Future<List<dynamic>> getRole() async {
    final response = await http.get(Uri.parse("$baseUrl/role"));
    print("API response: ${response.body}");
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load unit: ${response.statusCode}");
    }
  }

  static Future<List<dynamic>> searchRole(String m_name) async {
    final response = await http.get(
      Uri.parse("$baseUrl/role/search?m_name=$m_name"),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to search Role: ${response.statusCode}");
    }
  }

  // Function Add Role
  static Future<bool> addRole(String m_name) async {
    final response = await http.post(
      Uri.parse("$baseUrl/role/create"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"m_name": m_name}),
    );
    return response.statusCode == 201;
  }

  // Function Delete Role
  static Future<bool> deleteRole(int mid) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/role/delete/$mid"),
    );
    return response.statusCode == 200;
  }

  // Function Update Role
  static Future<bool> updateRole(int mid, String m_name) async {
    final response = await http.put(
      Uri.parse("$baseUrl/role/update/$mid"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"m_name": m_name}),
    );
    return response.statusCode == 200;
  }
}
