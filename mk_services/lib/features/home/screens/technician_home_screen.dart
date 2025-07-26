import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TechnicianHomeScreen extends StatelessWidget {
  const TechnicianHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Technician Dashboard'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Welcome Back!',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('Here is your activity for today.'),
          const SizedBox(height: 24),

          const _BookingCard(
            title: 'Assigned Jobs Today',
            count: 3,
            icon: Icons.assignment_ind,
            route: '/technician/assigned',
          ),
          const _BookingCard(
            title: 'Pending Services',
            count: 5,
            icon: Icons.pending_actions,
            route: '/technician/pending',
          ),
          const _BookingCard(
            title: 'Completed Jobs',
            count: 18,
            icon: Icons.check_circle_outline,
            route: '/technician/completed',
          ),
          const _BookingCard(
            title: 'Submit Service Report',
            count: 0,
            icon: Icons.report,
            route: '/technician/reports',
          ),
        ],
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final String route;

  const _BookingCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 3,
      child: ListTile(
        leading: Icon(icon, size: 32),
        title: Text(title),
        subtitle: Text('$count'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => context.push(route),
      ),
    );
  }
}
