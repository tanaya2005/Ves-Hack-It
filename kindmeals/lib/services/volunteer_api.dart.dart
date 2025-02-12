import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class VolunteerAPI {
  static const String baseUrl =
      "http://localhost:5000/api/volunteer"; // Change this in production

  // 🟢 SIGNUP API CALL
  static Future<String?> signup(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signup'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body)["volunteerId"];
    } else {
      return null;
    }
  }

  // 🟢 LOGIN API CALL
  static Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final volunteerId = jsonDecode(response.body)["volunteerId"];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('volunteerId', volunteerId);
      return true;
    } else {
      return false;
    }
  }

  // 🟢 CHECK SESSION (AUTO LOGIN)
  static Future<bool> checkSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? volunteerId = prefs.getString('volunteerId');

    if (volunteerId != null) {
      final response = await http.get(Uri.parse('$baseUrl/session'));
      return response.statusCode == 200;
    }
    return false;
  }

  // 🟢 LOGOUT API CALL
  static Future<void> logout() async {
    final response = await http.post(Uri.parse('$baseUrl/logout'));

    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('volunteerId');
    }
  }
}
