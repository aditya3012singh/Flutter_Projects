import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TechnicianHomeScreen extends StatelessWidget {
  const TechnicianHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Technician Dashboard'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Welcome Back!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            'Here is your activity for today.',
            style: TextStyle(color: Colors.grey.shade700),
          ),
          const SizedBox(height: 24),

          const _BookingCard(
            title: 'Assigned Jobs Today',
            count: 3,
            icon: Icons.assignment_ind,
            iconBgColor: Colors.blue,
            route: '/technician/assigned',
          ),
          const _BookingCard(
            title: 'Pending Services',
            count: 5,
            icon: Icons.pending_actions,
            iconBgColor: Colors.orange,
            route: '/technician/pending',
          ),
          const _BookingCard(
            title: 'Completed Jobs',
            count: 18,
            icon: Icons.check_circle_outline,
            iconBgColor: Colors.green,
            route: '/technician/completed',
          ),
          const _BookingCard(
            title: 'Submit Service Report',
            count: 0,
            icon: Icons.report,
            iconBgColor: Colors.white,
            route: '/technician/reports',
          ),

          const SizedBox(height: 20), // Space before logout
          ElevatedButton(
            onPressed: () {
              // TODO: Add your logout logic here
              context.go('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              iconColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Logout',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color iconBgColor;
  final String route;

  const _BookingCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.iconBgColor,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(route),
      borderRadius: BorderRadius.circular(16),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconBgColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 30, color: iconBgColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$count',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
