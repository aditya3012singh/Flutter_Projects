import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mk_services/core/services/api_service.dart';
import 'package:mk_services/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AdminHomeScreen extends ConsumerStatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  ConsumerState<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends ConsumerState<AdminHomeScreen> {
  final ApiService _apiService = ApiService();
  Map<String, dynamic>? summary;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSummary();
  }

  Future<void> _fetchSummary() async {
    try {
      final data = await _apiService.getDashboardSummary();
      setState(() {
        summary = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load summary: $e')));
    }
  }

  Future<void> _logout() async {
    try {
      await _apiService.logout();
      ref
          .read(authNotifierProvider.notifier)
          .logout(); // triggers GoRouter redirect
      showToast("Logged out successfully");
    } catch (e) {
      showToast("Logout failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      {'title': 'Customers', 'icon': Icons.people, 'route': '/admin/customers'},
      {
        'title': 'Technicians',
        'icon': Icons.engineering,
        'route': '/admin/technicians',
      },
      {
        'title': 'Products',
        'icon': Icons.inventory_2,
        'route': '/admin/products',
      },
      {'title': 'Stock', 'icon': Icons.warehouse, 'route': '/admin/stock'},
      {
        'title': 'Requests',
        'icon': Icons.assignment,
        'route': '/admin/requests',
      },
      {
        'title': 'Reports',
        'icon': Icons.insert_drive_file,
        'route': '/admin/reports',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Row(
          children: [
            Image.asset('assets/images/mk.png', height: 40),
            const SizedBox(width: 12),
            const Text(
              'MK Admin',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      _buildSummaryCard(
                        "Today's Services",
                        summary?['totalServicesToday'],
                        Icons.today,
                      ),
                      _buildSummaryCard(
                        "Pending Services",
                        summary?['pendingServices'],
                        Icons.assignment_late,
                      ),
                      _buildSummaryCard(
                        "Due Services",
                        summary?['dueServices'],
                        Icons.history,
                      ),
                      _buildSummaryCard(
                        "Low Stock Items",
                        (summary?['lowStockAlert'] as List?)?.length ?? 0,
                        Icons.warning_amber,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: items.map((item) {
                      return GestureDetector(
                        onTap: () => context.push(item['route'] as String),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2 - 24,
                          height: 140,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: const Offset(2, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                item['icon'] as IconData,
                                size: 40,
                                color: Colors.blueAccent,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                item['title'] as String,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSummaryCard(String title, dynamic count, IconData icon) {
    return Container(
      width: MediaQuery.of(context).size.width / 2 - 24,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: Colors.blue.shade900),
          const SizedBox(height: 10),
          Text(
            '$count',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

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
