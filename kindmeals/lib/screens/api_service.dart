// api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user_data.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.0.102:3000/api';

  static Future<Map<String, dynamic>> registerUser(dynamic userData, String userType) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/${userType}s'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(userData),
      );

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to register user: ${response.body}');
      }
    } catch (e) {
      throw Exception('Registration error: $e');
    }
  }

  static Future<Map<String, dynamic>> loginUser(String email, String password, String role) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'currentPassword': password,
          'role': role,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Login failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }

  static Future<Map<String, dynamic>> updateUserProfile(String userType, Map<String, dynamic> userData) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$userType'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(userData),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to update profile: ${response.body}');
      }
    } catch (e) {
      throw Exception('Update error: $e');
    }
  }
}