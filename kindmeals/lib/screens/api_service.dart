// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class ApiService {
//   static const String baseUrl = 'http://192.168.0.102:3000/api'; // For Android Emulator
//   // Use 'http://localhost:3000/api' for iOS simulator
  
//   static Future<Map<String, dynamic>> registerUser(Map<String, dynamic> userData, String userType) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$baseUrl/${userType}s'), // 'donors' or 'recipients'
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode(userData),
//       );

//       if (response.statusCode == 201) {
//         return json.decode(response.body);
//       } else {
//         throw Exception('Failed to register user: ${response.body}');
//       }
//     } catch (e) {
//       throw Exception('Registration error: $e');
//     }
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.0.102:3000/api'; // For Android Emulator
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

  // New method to get donor profile by email
  static Future<Map<String, dynamic>> getDonorProfile(String email) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/donors/profile?email=$email'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to fetch donor profile: ${response.body}');
      }
    } catch (e) {
      throw Exception('Profile fetch error: $e');
    }
  }

  // New method to login user
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
}