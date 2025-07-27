import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mk_services/core/constants/api_constants.dart';
import 'package:mk_services/core/models/user_model.dart';
import 'package:mk_services/storage/local_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class ApiService {
  final http.Client _client;
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  // ----------------- AUTH ------------------
  Future<UserModel?> login(String email, String password) async {
    final response = await _client.post(
      Uri.parse(ApiConstants.signin),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final token = data['token'];
      if (token != null) await LocalStorage.saveToken(token);
      return UserModel.fromJson(data['user']);
    } else {
      throw Exception(data['message'] ?? 'Login failed');
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
        'role': user.role ?? "USER",
      }),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 201) {
      final token = data['token'];
      if (token != null) await LocalStorage.saveToken(token);
      return UserModel.fromJson(data['user']);
    } else {
      throw Exception(data['message'] ?? 'Signup failed');
    }
  }

  Future<bool> sendOtp(String email) async {
    final response = await _client.post(
      Uri.parse(ApiConstants.genreateOtp),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
    return response.statusCode == 200;
  }

  Future<bool> verifyOtp(String email, String code) async {
    final response = await _client.post(
      Uri.parse(ApiConstants.verifyOtp),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'code': code}),
    );
    return response.statusCode == 200;
  }

  Future<UserModel?> getProfile() async {
    final token = await LocalStorage.getToken();
    if (token == null) return null;

    final response = await _client.get(
      Uri.parse(ApiConstants.getProfile),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserModel.fromJson(data['user']);
    } else if (response.statusCode == 401) {
      await LocalStorage.clearAll();
      return null;
    } else {
      throw Exception('Failed to fetch profile: ${response.body}');
    }
  }

  Future<UserModel?> updateProfile({
    String? name,
    String? phone,
    String? location,
    String? password,
  }) async {
    final token = await LocalStorage.getToken();
    if (token == null) throw Exception('Unauthorized');

    final Map<String, dynamic> body = {};
    if (name?.isNotEmpty == true) body['name'] = name;
    if (phone?.isNotEmpty == true) body['phone'] = phone;
    if (location?.isNotEmpty == true) body['location'] = location;
    if (password?.isNotEmpty == true) body['password'] = password;

    final response = await _client.put(
      Uri.parse(ApiConstants.updateProfile),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return UserModel.fromJson(data['user']);
    } else {
      throw Exception(data['message'] ?? 'Failed to update profile');
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    final token = await LocalStorage.getToken();
    if (token == null) throw Exception('Unauthorized');

    final response = await _client.get(
      Uri.parse('${ApiConstants.baseUrl}/api/auth/users'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final List users = data['users'] ?? [];
      return users.map((u) => UserModel.fromJson(u)).toList();
    } else {
      throw Exception(data['message'] ?? 'Failed to fetch users');
    }
  }

  // ----------------- STOCK ------------------
  Future<List<Map<String, dynamic>>> getAllParts() async {
    final token = await LocalStorage.getToken();
    if (token == null) throw Exception('Unauthorized');

    final response = await _client.get(
      Uri.parse('${ApiConstants.baseUrl}/api/stock'),
      headers: {"Authorization": "Bearer $token"},
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(data['parts'] ?? []);
    } else {
      throw Exception(data['message'] ?? 'Failed to fetch stock');
    }
  }

  /// Create new part with backend message response
  /// Add new part (fixed to return success & message)
  Future<Map<String, dynamic>> createPart({
    required String name,
    String? description,
    required double unitCost,
    required int quantity,
  }) async {
    final token = await LocalStorage.getToken();
    if (token == null) throw Exception('Unauthorized');

    final response = await _client.post(
      Uri.parse('${ApiConstants.baseUrl}/api/stock'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'description': description,
        'unitCost': unitCost,
        'quantity': quantity,
      }),
    );

    final data = jsonDecode(response.body);
    return {
      'success': response.statusCode == 201,
      'message':
          data['message'] ??
          (response.statusCode == 201
              ? 'Product added successfully'
              : 'Failed to add product'),
    };
  }

  Future<bool> addStock(String partId, int quantity, String reason) async {
    final token = await LocalStorage.getToken();
    if (token == null) throw Exception('Unauthorized');

    final response = await _client.patch(
      Uri.parse('${ApiConstants.baseUrl}/api/stock/$partId/add'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'quantity': quantity, 'reason': reason}),
    );

    return response.statusCode == 200;
  }

  Future<bool> reduceStock(String partId, int quantity, String reason) async {
    final token = await LocalStorage.getToken();
    if (token == null) throw Exception('Unauthorized');

    final response = await _client.patch(
      Uri.parse('${ApiConstants.baseUrl}/api/stock/$partId/reduce'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'quantity': quantity, 'reason': reason}),
    );

    return response.statusCode == 200;
  }

  Future<bool> deletePart(String partId) async {
    final token = await LocalStorage.getToken();
    if (token == null) throw Exception('Unauthorized');

    final response = await _client.delete(
      Uri.parse('${ApiConstants.baseUrl}/api/stock/$partId'),
      headers: {"Authorization": "Bearer $token"},
    );

    return response.statusCode == 200;
  }

  Future<List<Map<String, dynamic>>> getAllBookings() async {
    final token = await LocalStorage.getToken();
    if (token == null) throw Exception('Unauthorized');

    final response = await _client.get(
      Uri.parse('${ApiConstants.baseUrl}/api/bookings'),
      headers: {'Authorization': 'Bearer $token'},
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(data['bookings'] ?? []);
    } else {
      throw Exception(data['message'] ?? 'Failed to fetch bookings');
    }
  }

  Future<bool> assignTechnician(String bookingId, String technicianId) async {
    final token = await LocalStorage.getToken();
    if (token == null) throw Exception('Unauthorized');

    final response = await _client.post(
      Uri.parse('${ApiConstants.baseUrl}/api/bookings/$bookingId/assign'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'technicianId': technicianId}),
    );

    return response.statusCode == 200;
  }

  Future<void> exportBookingsCSV() async {
    final token = await LocalStorage.getToken();
    if (token == null) throw Exception('Unauthorized');

    // Assuming backend has an export route
    final url = '${ApiConstants.baseUrl}/api/bookings/export?token=$token';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw Exception("Could not launch CSV download");
    }
  }

  Future<bool> createBooking({
    required String serviceType,
    required DateTime serviceDate,
    String? remarks,
  }) async {
    final token = await LocalStorage.getToken();
    if (token == null) throw Exception('Unauthorized');

    final response = await _client.post(
      Uri.parse('${ApiConstants.baseUrl}/api/bookings'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'serviceType': serviceType,
        'serviceDate': serviceDate.toIso8601String(),
        'remarks': remarks ?? '',
      }),
    );

    final data = jsonDecode(response.body);
    return response.statusCode == 201;
  }

  Future<List<Map<String, dynamic>>> getMyBookings() async {
    final token = await LocalStorage.getToken();
    if (token == null) throw Exception('Unauthorized');

    final response = await _client.get(
      Uri.parse('${ApiConstants.baseUrl}/api/bookings/my'),
      headers: {'Authorization': 'Bearer $token'},
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(data['bookings'] ?? []);
    } else {
      throw Exception(data['message'] ?? 'Failed to fetch bookings');
    }
  }

  // ----------------- NOTIFICATIONS ------------------
  /// Fetch all notifications for the logged-in user
  Future<List<Map<String, dynamic>>> getNotifications() async {
    final token = await LocalStorage.getToken();
    if (token == null) throw Exception('Unauthorized');

    final response = await _client.get(
      Uri.parse('${ApiConstants.baseUrl}/api/notifications'),
      headers: {'Authorization': 'Bearer $token'},
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(data['notifications'] ?? []);
    } else {
      throw Exception(data['message'] ?? 'Failed to fetch notifications');
    }
  }

  /// Mark a specific notification as read
  Future<bool> markNotificationAsRead(String id) async {
    final token = await LocalStorage.getToken();
    if (token == null) throw Exception('Unauthorized');

    final response = await _client.patch(
      Uri.parse('${ApiConstants.baseUrl}/api/notifications/$id/read'),
      headers: {'Authorization': 'Bearer $token'},
    );

    return response.statusCode == 200;
  }

  /// Mark all notifications as read
  Future<bool> markAllNotificationsAsRead() async {
    final token = await LocalStorage.getToken();
    if (token == null) throw Exception('Unauthorized');

    final response = await _client.patch(
      Uri.parse('${ApiConstants.baseUrl}/api/notifications/mark-all-read'),
      headers: {'Authorization': 'Bearer $token'},
    );

    return response.statusCode == 200;
  }

  Future<List<Map<String, dynamic>>> getDueServices() async {
    final token = await LocalStorage.getToken();
    if (token == null) throw Exception('Unauthorized');

    final response = await _client.get(
      Uri.parse('${ApiConstants.baseUrl}/api/due-services'),
      headers: {'Authorization': 'Bearer $token'},
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(data['dueServices'] ?? []);
    } else {
      throw Exception(data['message'] ?? 'Failed to fetch due services');
    }
  }

  /// Create a new service entry and store parts used
  Future<Map<String, dynamic>> createServiceEntry({
    required String customerName,
    required String phone,
    required String address,
    required DateTime date,
    required TimeOfDay time,
    required String serviceType,
    required List<Map<String, dynamic>> partsUsed,
    String? remarks,
  }) async {
    final token = await LocalStorage.getToken();
    if (token == null) throw Exception('Unauthorized');

    // Combine date and time into full DateTime
    final serviceDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    final response = await _client.post(
      Uri.parse('${ApiConstants.baseUrl}/api/services'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'customerName': customerName,
        'phone': phone,
        'address': address,
        'serviceDate': serviceDateTime.toIso8601String(),
        'serviceType': serviceType,
        'partsUsed': partsUsed, // [{id, name, qty}]
        'remarks': remarks ?? '',
      }),
    );

    final data = jsonDecode(response.body);
    return {
      'success': response.statusCode == 201,
      'message':
          data['message'] ??
          (response.statusCode == 201
              ? 'Service entry created'
              : 'Failed to create entry'),
      'service': data['service'],
    };
  }

  Future<void> logout() async {
    await LocalStorage.clearAll();
  }

  Future<String?> getToken() => LocalStorage.getToken();
}
