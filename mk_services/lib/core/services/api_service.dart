import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mk_services/core/constants/api_constants.dart';
import 'package:mk_services/core/models/user_model.dart';
import 'package:mk_services/storage/local_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

void showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.black87,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

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
    }

    final errorMessage = data['message']?.toLowerCase() ?? '';

    if (errorMessage.contains('user does not exist')) {
      return null; // No exception
    }

    return null; // For other errors too
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
    final token = await getToken();
    final response = await _client.post(
      Uri.parse(
        '${ApiConstants.baseUrl}/api/bookings/$bookingId/assign',
      ), // ✅ Corrected route
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'technicianId': technicianId}),
    );

    if (response.statusCode == 200) {
      showToast("Technician assigned successfully");
      return true;
    } else {
      print("Failed to assign: ${response.body}");
      showToast("Assignment failed");
      return false;
    }
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
    print(data);
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
      Uri.parse('${ApiConstants.baseUrl}/api/technicians/all/assigned'),
      headers: {'Authorization': 'Bearer $token'},
    );

    final data = jsonDecode(response.body);
    print(data);

    if (response.statusCode == 200 && data['success'] == true) {
      // ✅ Use correct key: 'bookings'
      return List<Map<String, dynamic>>.from(data['bookings'] ?? []);
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

  Future<Map<String, dynamic>> submitReport({
    required String customerName,
    required String mobileNumber,
    required String address,
    required DateTime dateTime,
    required String serviceType,
    required List<Map<String, dynamic>> partsUsed,
    required num receivedAmount, // includes id and quantity
  }) async {
    final token = await getToken();
    if (token == null) throw Exception("Unauthorized");

    final response = await _client.post(
      Uri.parse('${ApiConstants.baseUrl}/api/reports'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'customerName': customerName,
        'mobileNumber': mobileNumber,
        'address': address,
        'dateTime': dateTime.toIso8601String(),
        'serviceType': serviceType,
        'partsUsed': partsUsed,
        "amountreceived": receivedAmount,
      }),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 201 && data['success'] == true) {
      return data;
    } else {
      throw Exception(data['message'] ?? 'Report submission failed');
    }
  }

  Future<Map<String, dynamic>> getReportByBookingId(String bookingId) async {
    final token = await getToken();
    if (token == null) throw Exception("Unauthorized");

    final response = await _client.get(
      Uri.parse('${ApiConstants.baseUrl}/api/report/$bookingId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['success'] == true) {
      return data['report'];
    } else {
      throw Exception(data['message'] ?? 'Failed to fetch report');
    }
  }

  Future<Map<String, dynamic>> getTechnicianStats() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/api/technicians/me/stats'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {'completedJobs': data['totalCompletedJobs'] ?? 0};
    } else {
      throw Exception('Failed to fetch technician stats');
    }
  }

  Future<List<Map<String, dynamic>>> getTechnicians() async {
    final token = await LocalStorage.getToken();
    final res = await _client.get(
      Uri.parse('${ApiConstants.baseUrl}/api/auth/technicians'),
      headers: {'Authorization': 'Bearer $token'},
    );

    final json = jsonDecode(res.body);
    return List<Map<String, dynamic>>.from(json['users']);
  }

  Future<bool> updateBookingStatus(String bookingId, String status) async {
    final token = await getToken();
    final response = await _client.patch(
      Uri.parse('${ApiConstants.baseUrl}/api/bookings/$bookingId/status'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'status': status}),
    );

    return response.statusCode == 200;
  }

  Future<bool> submitBookingReport(String bookingId, String summary) async {
    final token = await getToken();
    final response = await _client.post(
      Uri.parse('${ApiConstants.baseUrl}/api/bookings/$bookingId/report'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'summary': summary}),
    );

    return response.statusCode == 200;
  }

  Future<Map<String, dynamic>> getBookingById(String bookingId) async {
    final token = await getToken();
    final response = await _client.get(
      Uri.parse('${ApiConstants.baseUrl}/api/bookings/$bookingId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return data['booking'];
    } else {
      throw Exception(data['message'] ?? 'Failed to fetch booking');
    }
  }

  Future<bool> addPartsToBooking(
    String bookingId,
    List<Map<String, dynamic>> parts, // [{ partId, quantity }]
  ) async {
    final token = await getToken();
    final response = await _client.post(
      Uri.parse('${ApiConstants.baseUrl}/api/bookings/$bookingId/parts'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'parts': parts}),
    );

    return response.statusCode == 200;
  }

  Future<Map<String, dynamic>> getDashboardSummary() async {
    final token = await getToken();
    if (token == null) throw Exception("Unauthorized");

    final response = await _client.get(
      Uri.parse('${ApiConstants.baseUrl}/api/dashboard'),
      headers: {'Authorization': 'Bearer $token'},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {
        'totalServicesToday': data['totalServicesToday'],
        'pendingServices': data['pendingServices'],
        'dueServices': data['dueServices'],
        'lowStockAlert': List<Map<String, dynamic>>.from(data['lowStockAlert']),
      };
    } else {
      throw Exception(data['message'] ?? 'Failed to fetch dashboard summary');
    }
  }

  Future<List<Map<String, dynamic>>> getServiceHistory({String? query}) async {
    final token = await getToken();
    if (token == null) throw Exception("Unauthorized");

    final uri = Uri.parse('${ApiConstants.baseUrl}/api/history').replace(
      queryParameters: query != null && query.isNotEmpty
          ? {'query': query}
          : null,
    );

    final response = await _client.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(data['users']);
    } else {
      throw Exception(data['message'] ?? 'Failed to fetch service history');
    }
  }

  Future<Map<String, dynamic>> createPurchaseEntry({
    required String vendorName,
    required String billNumber,
    required DateTime purchaseDate,
    required String partId,
    required int quantity,
    required double costPerUnit,
    String? notes,
  }) async {
    final token = await getToken();
    if (token == null) throw Exception("Unauthorized");

    final response = await _client.post(
      Uri.parse('${ApiConstants.baseUrl}/api/purchase'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'vendorName': vendorName,
        'billNumber': billNumber,
        'purchaseDate': purchaseDate.toIso8601String(),
        'partId': partId,
        'quantity': quantity,
        'costPerUnit': costPerUnit,
        'notes': notes ?? '',
      }),
    );

    final data = jsonDecode(response.body);
    return {
      'success': data['success'] ?? false,
      'message': data['message'] ?? 'Unknown response',
    };
  }

  Future<List<Map<String, dynamic>>> getStockParts() async {
    final token = await getToken();
    if (token == null) throw Exception("Unauthorized");

    final response = await _client.get(
      Uri.parse('${ApiConstants.baseUrl}/api/stock'),
      headers: {'Authorization': 'Bearer $token'},
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['success'] == true) {
      return List<Map<String, dynamic>>.from(data['parts']);
    } else {
      throw Exception(data['message'] ?? 'Failed to fetch stock');
    }
  }

  Future<Map<String, dynamic>> addNewPart({
    required String name,
    String? description,
    required double unitCost,
    required int quantity,
  }) async {
    final token = await getToken();
    if (token == null) throw Exception("Unauthorized");

    final response = await _client.post(
      Uri.parse('${ApiConstants.baseUrl}/api/stock'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'description': description,
        'unitCost': unitCost,
        'quantity': quantity,
      }),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 201 && data['success'] == true) {
      return data['part'];
    } else {
      throw Exception(data['message'] ?? 'Failed to add part');
    }
  }

  Future<void> increaseStock({
    required String partId,
    required int quantity,
    required String reason,
  }) async {
    final token = await getToken();
    if (token == null) throw Exception("Unauthorized");

    final response = await _client.patch(
      Uri.parse('${ApiConstants.baseUrl}/api/stock/$partId/add'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'quantity': quantity, 'reason': reason}),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode != 200 || data['success'] != true) {
      throw Exception(data['message'] ?? 'Failed to increase stock');
    }
  }

  Future<List<Map<String, dynamic>>> getAllTechnicians() async {
    final token = await getToken();
    if (token == null) throw Exception("Unauthorized");

    final response = await _client.get(
      Uri.parse('${ApiConstants.baseUrl}/api/technicians'),
      headers: {'Authorization': 'Bearer $token'},
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['success'] == true) {
      return List<Map<String, dynamic>>.from(data['technicians']);
    } else {
      throw Exception(data['message'] ?? 'Failed to fetch technicians');
    }
  }

  Future<void> createTechnician(String name, String phone) async {
    final token = await getToken();
    if (token == null) throw Exception("Unauthorized");

    final response = await _client.post(
      Uri.parse('${ApiConstants.baseUrl}/api/technicians'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'name': name, 'phone': phone}),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode != 201 || data['success'] != true) {
      throw Exception(data['message'] ?? 'Failed to create technician');
    }
  }

  Future<Map<String, dynamic>> getTechnicianProfile() async {
    final token = await getToken();
    if (token == null) throw Exception("Unauthorized");

    final response = await _client.get(
      Uri.parse('${ApiConstants.baseUrl}/api/technicians/me'),
      headers: {'Authorization': 'Bearer $token'},
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['success'] == true) {
      return data['technician'];
    } else {
      throw Exception(data['message'] ?? 'Failed to fetch profile');
    }
  }

  Future<List<Map<String, dynamic>>> getTechnicianBookings() async {
    final token = await getToken();
    if (token == null) throw Exception("Unauthorized");

    final response = await _client.get(
      Uri.parse('${ApiConstants.baseUrl}/api/technicians/me/bookings'),
      headers: {'Authorization': 'Bearer $token'},
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['success'] == true) {
      return List<Map<String, dynamic>>.from(data['bookings']);
    } else {
      throw Exception(data['message'] ?? 'Failed to fetch bookings');
    }
  }

  Future<int> getTechnicianCompletedJobsCount() async {
    final token = await getToken();
    if (token == null) throw Exception("Unauthorized");

    final response = await _client.get(
      Uri.parse('${ApiConstants.baseUrl}/api/technicians/me/stats'),
      headers: {'Authorization': 'Bearer $token'},
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['success'] == true) {
      return data['totalCompletedJobs'] as int;
    } else {
      throw Exception(data['message'] ?? 'Failed to fetch stats');
    }
  }

  Future<void> logout() async {
    await LocalStorage.clearAll();
  }

  Future<String?> getToken() => LocalStorage.getToken();

  Future<List<Map<String, dynamic>>> getAllReports() async {
    final token = await getToken();
    if (token == null) throw Exception("Unauthorized");

    final response = await _client.get(
      Uri.parse('${ApiConstants.baseUrl}/api/reports'),
      headers: {'Authorization': 'Bearer $token'},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['success'] == true) {
      return List<Map<String, dynamic>>.from(data['reports']);
    } else {
      throw Exception(data['message'] ?? 'Failed to fetch reports');
    }
  }
}
