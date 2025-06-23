import 'dart:convert';
import 'package:http/http.dart' as http;

class Districtservice {
  static const String baseUrl = "http://192.168.0.104:3000";
  // static const String baseUrl = "http://192.168.61.95:3000";
  // Function get District
  static Future<List<dynamic>> getDistricts() async {
    final response = await http.get(Uri.parse("$baseUrl/district/select"));
    print("API response: ${response.body}");
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load unit: ${response.statusCode}");
    }
  }

  static Future<List<dynamic>> searchDistricts(String dname) async {
    final response = await http.get(
      Uri.parse("$baseUrl/district/search?dname=$dname"),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to search District: ${response.statusCode}");
    }
  }

  // Function Add District
  static Future<bool> addDistrict(String dname, int pid) async {
    final response = await http.post(
      Uri.parse("$baseUrl/district/create"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"dname": dname, "pid": pid}),
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
