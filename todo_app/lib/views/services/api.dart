import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/views/services/auth_helper.dart';

class ApiService {
  static const String baseUrl =
      'https://autonomous-kiet-hub.onrender.com/api/v1';
  static String? _token;

  // Load token from SharedPreferences
  static Future<void> loadTokenFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
  }

  // Set token and save to SharedPreferences
  static Future<void> setToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static void logout() {
    _token = null;
  }

  static String? get token => _token;

  static Map<String, String> _headers({bool auth = false}) {
    return {
      'Content-Type': 'application/json',
      if (auth && _token != null) 'Authorization': 'Bearer $_token',
    };
  }

  static dynamic _handleResponse(http.Response res) {
    final data = jsonDecode(res.body);
    if (res.statusCode >= 200 && res.statusCode < 300) return data;
    throw Exception(data['message'] ?? 'Something went wrong');
  }

  // ------------------ Auth ------------------
  static Future<Map<String, dynamic>> generateOtp(String email) async {
    final res = await http.post(
      Uri.parse('$baseUrl/users/generate-otp'),
      body: jsonEncode({'email': email}),
      headers: _headers(),
    );
    return _handleResponse(res);
  }

  static Future<Map<String, dynamic>> verifyOtp(
    String email,
    String code,
  ) async {
    final res = await http.post(
      Uri.parse('$baseUrl/users/verify-otp'),
      body: jsonEncode({'email': email, 'code': code}),
      headers: _headers(),
    );
    return _handleResponse(res);
  }

  static Future<Map<String, dynamic>> signup(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('$baseUrl/users/signup'),
      body: jsonEncode(data),
      headers: _headers(),
    );
    return _handleResponse(res);
  }

  static Future<Map<String, dynamic>> signin(
    String email,
    String password,
  ) async {
    final res = await http.post(
      Uri.parse('$baseUrl/users/signin'),
      body: jsonEncode({'email': email, 'password': password}),
      headers: _headers(),
    );
    final result = _handleResponse(res);
    await setToken(result['jwt']);
    return result;
  }

  static Future<Map<String, dynamic>> checkAdminExists() async {
    final res = await http.get(
      Uri.parse('$baseUrl/users/check-admin'),
      headers: _headers(),
    );
    return _handleResponse(res);
  }

  static Future<Map<String, dynamic>> updateProfile(
    Map<String, dynamic> data,
  ) async {
    final res = await http.put(
      Uri.parse('$baseUrl/users/update-profile'),
      body: jsonEncode(data),
      headers: _headers(),
    );
    return _handleResponse(res);
  }

  static Future<Map<String, dynamic>> checkUserExists(String email) async {
    final res = await http.get(
      Uri.parse('$baseUrl/users/check-user?email=$email'),
      headers: _headers(),
    );
    return _handleResponse(res);
  }

  // ------------------ Notes ------------------
  static Future<List<dynamic>> getAllNotes() async {
    final res = await http.get(
      Uri.parse('$baseUrl/notes/note/all'),
      headers: {'Content-Type': 'application/json'},
    );

    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);
      return decoded['notes']; // ✅ Return only the data list
    } else {
      throw Exception('Failed to load notes');
    }
  }

  static Future<Map<String, dynamic>> getNote(String id) async {
    final res = await http.get(
      Uri.parse('$baseUrl/notes/note/$id'),
      headers: _headers(auth: true),
    );
    return _handleResponse(res);
  }

  static Future<Map<String, dynamic>> approveNote(String id) async {
    final res = await http.put(
      Uri.parse('$baseUrl/notes/note/approve/$id'),
      headers: _headers(auth: true),
    );
    return _handleResponse(res);
  }

  // ------------------ Tips ------------------
  static Future<List<dynamic>> getAllTips() async {
    final res = await http.get(
      Uri.parse('$baseUrl/tips/tip/all/pending'),
      headers: {
        'Content-Type': 'application/json', // ✅ Add token here
      },
    );

    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);
      return decoded['tips']; // ✅ Return only the tips list
    } else {
      throw Exception('Failed to load tips');
    }
  }

  static Future<Map<String, dynamic>> createTip(
    Map<String, dynamic> data,
  ) async {
    final res = await http.post(
      Uri.parse('$baseUrl/tips/tip'),
      body: jsonEncode(data),
      headers: _headers(auth: true),
    );
    return _handleResponse(res);
  }

  static Future<Map<String, dynamic>> getTipById(String id) async {
    final res = await http.get(
      Uri.parse('$baseUrl/tips/tip/$id'),
      headers: _headers(auth: true),
    );
    return _handleResponse(res);
  }

  static Future<List<dynamic>> getPendingTips({
    int page = 1,
    int limit = 10,
  }) async {
    final res = await http.get(
      Uri.parse('$baseUrl/tips/tip/pending?page=$page&limit=$limit'),
      headers: _headers(auth: true),
    );
    return _handleResponse(res);
  }

  static Future<Map<String, dynamic>> approveTip(
    String id,
    String status,
  ) async {
    final res = await http.put(
      Uri.parse('$baseUrl/tips/tip/approve/$id'),
      body: jsonEncode({'status': status}),
      headers: _headers(auth: true),
    );
    return _handleResponse(res);
  }

  static Future<Map<String, dynamic>> deleteTip(String id) async {
    final res = await http.delete(
      Uri.parse('$baseUrl/tips/tip/$id'),
      headers: _headers(auth: true),
    );
    return _handleResponse(res);
  }

  // ------------------ Subjects ------------------
  static Future<List<dynamic>> getAllSubjects() async {
    final res = await http.get(
      Uri.parse('$baseUrl/subjects/subject'),
      headers: _headers(auth: true),
    );
    return _handleResponse(res);
  }

  // ------------------ Announcements ------------------
  static Future<List<dynamic>> getAllAnnouncements() async {
    final res = await http.get(
      Uri.parse('$baseUrl/announcements/announcement'),
      headers: _headers(auth: true),
    );
    return _handleResponse(res);
  }

  // ------------------ Events ------------------
  static Future<List<dynamic>> getAllEvents() async {
    final res = await http.get(
      Uri.parse('$baseUrl/events/event'),
      headers: _headers(auth: true),
    );
    return _handleResponse(res);
  }

  // ------------------ Feedback ------------------
  static Future<Map<String, dynamic>> submitFeedback(
    Map<String, dynamic> data,
  ) async {
    final res = await http.post(
      Uri.parse('$baseUrl/feedback/feedback'),
      body: jsonEncode(data),
      headers: _headers(auth: true),
    );
    return _handleResponse(res);
  }

  static Future<List<dynamic>> getFeedbacks(String id) async {
    final res = await http.get(
      Uri.parse('$baseUrl/feedback/feedback/$id'),
      headers: _headers(auth: true),
    );
    return _handleResponse(res);
  }

  static Future<Map<String, dynamic>> deleteFeedback(String id) async {
    final res = await http.delete(
      Uri.parse('$baseUrl/feedback/feedback/$id'),
      headers: _headers(auth: true),
    );
    return _handleResponse(res);
  }

  // ------------------ Files ------------------
  static Future<List<dynamic>> getAllFiles() async {
    final res = await http.get(
      Uri.parse('$baseUrl/files/files'),
      headers: _headers(auth: true),
    );
    return _handleResponse(res);
  }

  static Future<Map<String, dynamic>> getFile(String id) async {
    final res = await http.get(
      Uri.parse('$baseUrl/files/file/$id'),
      headers: _headers(auth: true),
    );
    return _handleResponse(res);
  }

  static Future<Map<String, dynamic>> deleteFile(String id) async {
    final res = await http.delete(
      Uri.parse('$baseUrl/files/file/$id'),
      headers: _headers(auth: true),
    );
    return _handleResponse(res);
  }

  // ------------------ Activity ------------------
  static Future<List<dynamic>> getActivityLogs() async {
    final res = await http.get(
      Uri.parse('$baseUrl/activity/recent'),
      headers: _headers(auth: true),
    );
    return _handleResponse(res);
  }
}

// Placeholder FormData class
class FormData {
  final String path;
  FormData(this.path);
}
