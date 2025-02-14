import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.7.180:3000/api';
  static Future<Map<String, dynamic>> registerUser(
      Map<String, dynamic> userData, String userType) async {
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

  //New method to get recipient profile by email
  static Future<Map<String, dynamic>> getRecipientProfile(String email) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/recipients/profile?email=$email'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to fetch recipient profile: ${response.body}');
      }
    } catch (e) {
      throw Exception('Profile fetch error: $e');
    }
  }

  // In api_service.dart
  static Future<Map<String, dynamic>> acceptDonation(
      String donationId, bool needsVolunteer) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/donations/accept'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'donationId': donationId,
          'needsVolunteer': needsVolunteer,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData;
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['error'] ?? 'Failed to accept donation');
      }
    } catch (e) {
      throw Exception('Error accepting donation: $e');
    }
  }

  // New method to login user
  static Future<Map<String, dynamic>> loginUser(
      String email, String password, String role) async {
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
