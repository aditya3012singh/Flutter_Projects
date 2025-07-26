import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  final List<Map<String, dynamic>> reports = const [
    {
      'reportId': 'REP001',
      'bookingId': 'BK101',
      'technician': 'Ravi Kumar',
      'customer': 'Aditya Sharma',
      'summary': 'Replaced RO membrane and cleaned filters.',
      'partsUsed': ['RO Membrane', 'Pre-Filter'],
      'date': '2025-07-25',
    },
    {
      'reportId': 'REP002',
      'bookingId': 'BK102',
      'technician': 'Suman Yadav',
      'customer': 'Priya Verma',
      'summary': 'General maintenance, no part replacement.',
      'partsUsed': [],
      'date': '2025-07-22',
    },
  ];

  void downloadCSV(BuildContext context) {
    // Placeholder logic for download
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("CSV Downloaded (placeholder)"),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'Technician Reports',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade900,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Download CSV',
            onPressed: () => downloadCSV(context),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: reports.length,
        itemBuilder: (context, index) {
          final report = reports[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Report ID: ${report['reportId']}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("Booking ID: ${report['bookingId']}"),
                  Text("Technician: ${report['technician']}"),
                  Text("Customer: ${report['customer']}"),
                  Text("Date: ${report['date']}"),
                  const SizedBox(height: 8),
                  const Text(
                    "Summary:",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(report['summary']),
                  if (report['partsUsed'].isNotEmpty) ...[
                    const SizedBox(height: 8),
                    const Text(
                      "Parts Used:",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Wrap(
                      spacing: 8,
                      children: List.generate(
                        report['partsUsed'].length,
                        (i) => Chip(
                          label: Text(report['partsUsed'][i]),
                          backgroundColor: Colors.blue.shade100,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
