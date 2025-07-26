import 'package:flutter/material.dart';

class AllCustomersScreen extends StatelessWidget {
  const AllCustomersScreen({super.key});

  final List<Map<String, String>> customers = const [
    {
      'name': 'Amit Sharma',
      'email': 'amit@example.com',
      'phone': '+91 9876543210',
      'location': 'Lucknow',
    },
    {
      'name': 'Neha Verma',
      'email': 'neha@example.com',
      'phone': '+91 9988776655',
      'location': 'Kanpur',
    },
    {
      'name': 'Rohit Singh',
      'email': 'rohit@example.com',
      'phone': '+91 9123456780',
      'location': 'Noida',
    },
    {
      'name': 'Priya Gupta',
      'email': 'priya@example.com',
      'phone': '+91 9345678910',
      'location': 'Delhi',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'All Customers',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade900,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: customers.length,
        itemBuilder: (context, index) {
          final customer = customers[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade700,
                child: Text(
                  customer['name']![0],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(
                customer['name']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('📧 ${customer['email']}'),
                  Text('📞 ${customer['phone']}'),
                  Text('📍 ${customer['location']}'),
                ],
              ),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}
