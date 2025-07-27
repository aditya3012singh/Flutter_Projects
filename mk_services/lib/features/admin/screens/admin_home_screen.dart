// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mk_services/core/services/api_service.dart'; // Assuming your API service is here

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    try {
      await ApiService().logout(); // Calls your API service to clear storage
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Logged out successfully")));

      // Redirect to login
      context.go('/login');
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Logout failed: $e")));
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
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Wrap(
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
        ),
      ),
    );
  }
}
