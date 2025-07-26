import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard'), centerTitle: true),
      body: ListView(
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
              _StatCard(title: "Technicians", count: 12, icon: Icons.build),
              _StatCard(title: "Bookings", count: 56, icon: Icons.assignment),
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
            onTap: () {
              context.push('/admin/users');
            },
          ),
          ListTile(
            leading: const Icon(Icons.engineering),
            title: const Text('Manage Technicians'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              context.push('/admin/technicians');
            },
          ),
          ListTile(
            leading: const Icon(Icons.inventory),
            title: const Text('Stock & Parts'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              context.push('/admin/stock');
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('View All Bookings'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              context.push('/admin/bookings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Service History'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              context.push('/admin/history');
            },
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
