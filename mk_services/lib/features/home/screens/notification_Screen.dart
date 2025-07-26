import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  final List<Map<String, String>> notifications = const [
    {
      'title': 'Service Completed',
      'message': 'Your recent maintenance request has been completed.',
      'date': '25 July 2025',
    },
    {
      'title': 'Technician Assigned',
      'message': 'A technician has been assigned to your request.',
      'date': '23 July 2025',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (_, index) {
          final item = notifications[index];
          return ListTile(
            title: Text(
              item['title']!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(item['message']!),
            trailing: Text(
              item['date']!,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          );
        },
        separatorBuilder: (_, __) => const Divider(),
      ),
    );
  }
}
