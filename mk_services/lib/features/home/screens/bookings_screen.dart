import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserBookingsScreen extends StatelessWidget {
  const UserBookingsScreen({super.key});

  final List<Map<String, String>> dummyBookings = const [
    {
      'service': 'Water Purifier Maintenance',
      'status': 'Completed',
      'date': '25 July 2025',
      'technician': 'Raj Sharma',
    },
    {
      'service': 'Water Purifier Installation',
      'status': 'Pending',
      'date': '28 July 2025',
      'technician': 'Not Assigned',
    },
    {
      'service': 'Filter Replacement',
      'status': 'In Progress',
      'date': '26 July 2025',
      'technician': 'Ankit Verma',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: dummyBookings.length,
        itemBuilder: (context, index) {
          final booking = dummyBookings[index];
          return Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                booking['service']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text('Status: ${booking['status']}'),
                  Text('Date: ${booking['date']}'),
                  Text('Technician: ${booking['technician']}'),
                ],
              ),
              leading: const Icon(Icons.build_circle, color: Colors.blue),
            ),
          );
        },
      ),
    );
  }
}
