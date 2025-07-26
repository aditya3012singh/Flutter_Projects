import 'package:flutter/material.dart';

class AllProvidersScreen extends StatelessWidget {
  const AllProvidersScreen({super.key});

  final List<Map<String, String>> providers = const [
    {
      'name': 'Ravi Kumar',
      'email': 'ravi@mkservices.com',
      'phone': '+91 9812345678',
      'specialization': 'RO Repair',
      'zone': 'Lucknow Central',
    },
    {
      'name': 'Suman Yadav',
      'email': 'suman@mkservices.com',
      'phone': '+91 9876543210',
      'specialization': 'Installation',
      'zone': 'Lucknow East',
    },
    {
      'name': 'Manish Verma',
      'email': 'manish@mkservices.com',
      'phone': '+91 9988776655',
      'specialization': 'Maintenance',
      'zone': 'Kanpur North',
    },
    {
      'name': 'Anita Singh',
      'email': 'anita@mkservices.com',
      'phone': '+91 9123456780',
      'specialization': 'RO Repair',
      'zone': 'Noida Sector 62',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'All Providers',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade900,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: providers.length,
        itemBuilder: (context, index) {
          final provider = providers[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.green.shade700,
                child: Text(
                  provider['name']![0],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(
                provider['name']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('📧 ${provider['email']}'),
                  Text('📞 ${provider['phone']}'),
                  Text('🛠️ ${provider['specialization']}'),
                  Text('📍 Zone: ${provider['zone']}'),
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
