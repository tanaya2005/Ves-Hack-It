// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.29.121:5000/api'; // Update with your backend URL

  Future<void> registerVolunteer(Map<String, dynamic> volunteerData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/volunteers/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(volunteerData),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to register volunteer: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  Future<Map<String, dynamic>> getVolunteer(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/volunteers/$id'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to get volunteer data: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }
}