import 'dart:convert';
import 'package:http/http.dart' as http;

class Provinceservice {
  static const String baseUrl = "http://192.168.0.104:3000";
  // static const String baseUrl = "http://192.168.61.95:3000";

  // Function get Province
  static Future<List<dynamic>> getProvinces() async {
    final response = await http.get(Uri.parse("$baseUrl/province"));
    print("API response: ${response.body}");
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load unit: ${response.statusCode}");
    }
  }

  static Future<List<dynamic>> searchProvinces(String pname) async {
    final response = await http.get(
      Uri.parse("$baseUrl/province/search?pname=$pname"),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to search province: ${response.statusCode}");
    }
  }

  // Function Add Province
  static Future<bool> addProvince(String pname) async {
    final response = await http.post(
      Uri.parse("$baseUrl/province/create"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"pname": pname}),
    );
    return response.statusCode == 201;
  }

  // Function Delete Province
  static Future<bool> deleteProvince(int pid) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/province/delete/$pid"),
    );
    return response.statusCode == 200;
  }

  // Function Update Province
  static Future<bool> updateProvince(int pid, String pname) async {
    final response = await http.put(
      Uri.parse("$baseUrl/province/update/$pid"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"pname": pname}),
    );
    return response.statusCode == 200;
  }

  // static Future<List<dynamic>> getLogs() async {
  //   final response = await http.get(Uri.parse("$baseUrl/logs"));
  //   if (response.statusCode == 200) {
  //     return jsonDecode(response.body);
  //   } else {
  //     throw Exception("Failed to fetch logs");
  //   }
  // }
}
