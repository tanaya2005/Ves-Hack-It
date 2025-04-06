import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.124.180:3000/api';
  
  // Updated to match server endpoint
  static Future<Map<String, dynamic>> registerUser(
      Map<String, dynamic> userData, String userType) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/${userType}s/register'), // Updated endpoint
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

  // User profile methods
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

  static Future<Map<String, dynamic>> getVolunteerProfile(String email) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/volunteers/profile?email=$email'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to fetch Volunteers profile: ${response.body}');
      }
    } catch (e) {
      throw Exception('Profile fetch error: $e');
    }
  }

  // Updated to match server endpoint
  static Future<Map<String, dynamic>> acceptDonation(
      String donationId, String recipientId, bool needsVolunteer) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/donations/accept'), // Updated endpoint
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'donationId': donationId,
          'recipientId': recipientId,
          'needsVolunteer': needsVolunteer,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData;
      } else if (response.statusCode == 404) {
        throw Exception('Donation not found');
      } else {
        try {
          final errorData = json.decode(response.body);
          throw Exception(errorData['error'] ?? 'Failed to accept donation');
        } catch (_) {
          throw Exception('Failed to accept donation');
        }
      }
    } catch (e) {
      throw Exception('Error accepting donation: $e');
    }
  }

  // Updated to match server parameter names
  static Future<Map<String, dynamic>> loginUser(
      String email, String password, String userType) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'currentPassword': password, // This is correct
          'userType': userType, // Changed from 'role' to 'userType'
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
  
  // Added for creating donations
  static Future<Map<String, dynamic>> createDonation(
      Map<String, dynamic> donationData, http.MultipartFile? imageFile) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/donations'));
      
      // Add all text fields
      donationData.forEach((key, value) {
        request.fields[key] = value.toString();
      });
      
      // Add image file if provided
      if (imageFile != null) {
        request.files.add(imageFile);
      }
      
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to create donation: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating donation: $e');
    }
  }
  
  // Added for getting all donations
  static Future<List<dynamic>> getDonations() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/donations'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to fetch donations: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching donations: $e');
    }
  }
  
  // Added for getting a single donation
  static Future<Map<String, dynamic>> getDonation(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/donations/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to fetch donation: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching donation: $e');
    }
  }
}