// lib/core/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mk_services/core/constants/api_constants.dart';
import 'package:mk_services/core/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final http.Client _client;
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<UserModel?> login(String email, String password) async {
    final response = await _client.post(
      Uri.parse(ApiConstants.signin),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      return UserModel.fromJson(data['user']);
    } else {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Login failed');
    }
  }

  Future<UserModel?> signup(UserModel user, String password) async {
    final response = await _client.post(
      Uri.parse(ApiConstants.signup),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': user.name,
        'email': user.email,
        'password': password,
        'phone': user.phone,
        'location': user.location,
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      return UserModel.fromJson(data['user']);
    } else {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Signup failed');
    }
  }

  Future<bool> verifyOtp(String email, String otp) async {
    final response = await _client.post(
      Uri.parse(ApiConstants.verifyOtp),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'otp': otp}),
    );

    if (response.statusCode != 200) {
      throw Exception(
        jsonDecode(response.body)['message'] ?? 'OTP verification failed',
      );
    }

    return true;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<UserModel> getProfile() async {
    final token = await getToken();
    final response = await _client.get(
      Uri.parse(ApiConstants.getProfile),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserModel.fromJson(data['user']);
    } else {
      throw Exception('Failed to load profile');
    }
  }
}
