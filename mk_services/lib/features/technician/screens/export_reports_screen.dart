import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExportReportsScreen extends StatefulWidget {
  const ExportReportsScreen({super.key});

  @override
  State<ExportReportsScreen> createState() => _ExportReportsScreenState();
}

class _ExportReportsScreenState extends State<ExportReportsScreen> {
  DateTimeRange? selectedRange;
  String selectedReport = 'Service History';

  final List<String> reportOptions = [
    'Service History',
    'Daily Summary',
    'Weekly Summary',
    'Monthly Summary',
    'Parts Used Summary',
  ];

  void _pickDateRange() async {
    final now = DateTime.now();
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 1),
      initialDateRange:
          selectedRange ??
          DateTimeRange(start: now.subtract(const Duration(days: 7)), end: now),
    );

    if (range != null) {
      setState(() {
        selectedRange = range;
      });
    }
  }

  void _exportReport() {
    if (selectedRange == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date range')),
      );
      return;
    }

    // TODO: Connect to backend/export logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Exporting "$selectedReport" report...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateText = selectedRange == null
        ? 'Select Date Range'
        : '${DateFormat('dd MMM yyyy').format(selectedRange!.start)} - ${DateFormat('dd MMM yyyy').format(selectedRange!.end)}';

    return Scaffold(
      appBar: AppBar(title: const Text('Export / Reports')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Report Type Dropdown
            DropdownButtonFormField<String>(
              value: selectedReport,
              decoration: const InputDecoration(
                labelText: 'Report Type',
                border: OutlineInputBorder(),
              ),
              items: reportOptions
                  .map(
                    (report) =>
                        DropdownMenuItem(value: report, child: Text(report)),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedReport = value;
                  });
                }
              },
            ),
            const SizedBox(height: 20),

            // Date Range Picker
            ListTile(
              onTap: _pickDateRange,
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              title: Text(dateText),
              trailing: const Icon(Icons.calendar_today),
            ),
            const SizedBox(height: 20),

            // Export Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _exportReport,
                icon: const Icon(Icons.download),
                label: const Text('Export Report'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
