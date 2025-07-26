import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DueServiceListScreen extends StatelessWidget {
  const DueServiceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> dueCustomers = [
      {
        'name': 'Rahul Sharma',
        'phone': '9876543210',
        'lastService': DateTime(2025, 4, 20),
        'intervalMonths': 3,
        'serviceType': 'Service',
        'reminderSent': true,
      },
      {
        'name': 'Priya Verma',
        'phone': '9123456789',
        'lastService': DateTime(2025, 2, 15),
        'intervalMonths': 6,
        'serviceType': 'Installation & Service',
        'reminderSent': false,
      },
    ];

    final dateFormat = DateFormat('dd MMM yyyy');

    return Scaffold(
      appBar: AppBar(title: const Text('Due RO Services')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: dueCustomers.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final customer = dueCustomers[index];
          final lastDate = customer['lastService'] as DateTime;
          final nextDue = DateTime(
            lastDate.year,
            lastDate.month + (customer['intervalMonths'] as int),
            lastDate.day,
          );

          final isOverdue = DateTime.now().isAfter(nextDue);

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            child: ListTile(
              leading: CircleAvatar(child: Text(customer['name'][0])),
              title: Text(customer['name']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("📞 ${customer['phone']}"),
                  Text("🧾 Service Type: ${customer['serviceType']}"),
                  Text("📅 Last Service: ${dateFormat.format(lastDate)}"),
                  Text("📅 Next Due: ${dateFormat.format(nextDue)}"),
                  Row(
                    children: [
                      const Text("🔔 Reminder: "),
                      Text(
                        customer['reminderSent'] ? 'Sent ✅' : 'Pending ❌',
                        style: TextStyle(
                          color: customer['reminderSent']
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              trailing: isOverdue
                  ? const Icon(Icons.warning, color: Colors.red)
                  : const Icon(Icons.check_circle, color: Colors.green),
            ),
          );
        },
      ),
    );
  }
}
