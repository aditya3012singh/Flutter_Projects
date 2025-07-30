import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mk_services/providers/auth_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AdminHomeScreen extends ConsumerWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard'), centerTitle: true),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                const Text(
                  'Overview',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Summary cards
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    _StatCard(title: "Users", count: 120, icon: Icons.person),
                    _StatCard(
                      title: "Technicians",
                      count: 12,
                      icon: Icons.build,
                    ),
                    _StatCard(
                      title: "Bookings",
                      count: 56,
                      icon: Icons.assignment,
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                const Text(
                  'Quick Actions',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                ListTile(
                  leading: const Icon(Icons.people),
                  title: const Text('Manage Users'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => context.push('/admin/users'),
                ),
                ListTile(
                  leading: const Icon(Icons.engineering),
                  title: const Text('Manage Technicians'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => context.push('/admin/technicians'),
                ),
                ListTile(
                  leading: const Icon(Icons.inventory),
                  title: const Text('Stock & Parts'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => context.push('/admin/stock'),
                ),
                ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text('View All Bookings'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => context.push('/admin/bookings'),
                ),
                ListTile(
                  leading: const Icon(Icons.history),
                  title: const Text('Service History'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => context.push('/admin/history'),
                ),
              ],
            ),
          ),

          // 🔒 Logout Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text("Logout"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  // ✅ Correct Riverpod logout (triggers GoRouter redirect)
                  await ref.read(authNotifierProvider.notifier).logout();

                  if (!context.mounted) return;

                  showToast("Logged out successfully");
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.count,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, size: 32),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('$count'),
          ],
        ),
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
