import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl =
      'https://autonomous-kiet-hub.onrender.com/api/v1';

  Future<Map<String, String>> _getAuthHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<dynamic> _handleResponse(http.Response response) async {
    if (response.statusCode == 403) {
      // Trigger force logout manually in UI
      throw Exception("Unauthorized");
    }

    try {
      final data = json.decode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return data;
      } else {
        throw Exception(data['message'] ?? 'Unexpected error');
      }
    } catch (e) {
      throw Exception('Invalid response format');
    }
  }

  // Auth
  Future<dynamic> generateOtp(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/generate-otp'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email}),
    );
    return _handleResponse(response);
  }

  Future<dynamic> verifyOtp(String email, String code) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/verify-otp'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'code': code}),
    );
    return _handleResponse(response);
  }

  Future<dynamic> signIn(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/signin'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );
    return _handleResponse(response);
  }

  // Notes
  Future<dynamic> getAllNotes() async {
    final headers = await _getAuthHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/notes/note/all'),
      headers: headers,
    );
    return _handleResponse(response);
  }

  Future<dynamic> getNote(String id) async {
    final headers = await _getAuthHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/notes/note/$id'),
      headers: headers,
    );
    return _handleResponse(response);
  }

  // Tips
  Future<dynamic> getAllTips() async {
    final headers = await _getAuthHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/tips/tip/all'),
      headers: headers,
    );
    print(response);
    return _handleResponse(response);
  }

  // Add more methods (uploadFile, approveNote, filterNotes, etc.) as needed
}
