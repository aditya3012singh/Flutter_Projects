import 'package:flutter/material.dart';

class CustomerServiceHistoryScreen extends StatefulWidget {
  const CustomerServiceHistoryScreen({super.key});

  @override
  State<CustomerServiceHistoryScreen> createState() =>
      _CustomerServiceHistoryScreenState();
}

class _CustomerServiceHistoryScreenState
    extends State<CustomerServiceHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> allCustomers = [
    {
      'name': 'Rahul Sharma',
      'phone': '9876543210',
      'history': [
        {
          'date': '2025-07-15',
          'type': 'Service',
          'parts': [
            {'name': 'Filter', 'qty': 1},
            {'name': 'Pipe', 'qty': 2},
          ],
          'remarks': 'Filter replaced and pipe leak fixed',
        },
        {
          'date': '2025-04-12',
          'type': 'Installation',
          'parts': [
            {'name': 'Membrane', 'qty': 1},
          ],
          'remarks': 'New RO installed',
        },
      ],
    },
    {
      'name': 'Priya Verma',
      'phone': '9123456789',
      'history': [
        {
          'date': '2025-06-30',
          'type': 'Service',
          'parts': [
            {'name': 'Pump', 'qty': 1},
          ],
          'remarks': 'Pump replacement',
        },
      ],
    },
  ];

  List<Map<String, dynamic>> filteredCustomers = [];

  @override
  void initState() {
    super.initState();
    filteredCustomers = List.from(allCustomers);
  }

  void _filterCustomers(String query) {
    setState(() {
      filteredCustomers = allCustomers.where((customer) {
        final name = customer['name'].toString().toLowerCase();
        final phone = customer['phone'].toString();
        return name.contains(query.toLowerCase()) || phone.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customer Service History')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: _filterCustomers,
              decoration: const InputDecoration(
                labelText: 'Search by name or phone',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: filteredCustomers.isEmpty
                  ? const Center(child: Text('No customers found.'))
                  : ListView.builder(
                      itemCount: filteredCustomers.length,
                      itemBuilder: (context, index) {
                        final customer = filteredCustomers[index];
                        return ExpansionTile(
                          title: Text(
                            customer['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text("📞 ${customer['phone']}"),
                          children: List.generate(customer['history'].length, (
                            i,
                          ) {
                            final history = customer['history'][i];
                            return ListTile(
                              title: Text(
                                "🛠️ ${history['type']} on ${history['date']}",
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("🧰 Parts Used:"),
                                  ...List.generate(history['parts'].length, (
                                    j,
                                  ) {
                                    final part = history['parts'][j];
                                    return Text(
                                      "• ${part['name']} × ${part['qty']}",
                                    );
                                  }),
                                  const SizedBox(height: 4),
                                  Text("📝 Remarks: ${history['remarks']}"),
                                ],
                              ),
                            );
                          }),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
