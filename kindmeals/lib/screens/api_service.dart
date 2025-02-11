import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.0.100:3000/api'; // For Android Emulator
  // Use 'http://localhost:3000/api' for iOS simulator
  
  static Future<Map<String, dynamic>> registerUser(Map<String, dynamic> userData, String userType) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/${userType}s'), // 'donors' or 'recipients'
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
}