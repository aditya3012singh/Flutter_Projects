import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mk_services/core/services/api_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:open_filex/open_filex.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:path/path.dart' as pathLib;

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final ApiService _apiService = ApiService();

  List<Map<String, dynamic>> allReports = [];
  List<Map<String, dynamic>> filteredReports = [];
  bool isLoading = true;
  String selectedMonth = 'All';

  double totalAmount = 0;
  double weeklyAmount = 0;

  @override
  void initState() {
    super.initState();
    fetchReports();
  }

  Future<void> fetchReports() async {
    try {
      final fetchedReports = await _apiService.getAllReports();
      if (fetchedReports is List) {
        allReports = List<Map<String, dynamic>>.from(fetchedReports);
        applyFilter();
        setState(() => isLoading = false);
      } else {
        throw Exception("Unexpected report format");
      }
    } catch (e) {
      showError("Error loading reports: $e");
    }
  }

  void showError(String message) {
    setState(() => isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void applyFilter() {
    if (selectedMonth == 'All') {
      filteredReports = List.from(allReports);
    } else {
      final parts = selectedMonth.split(' ');
      final selectedMonthNumber = DateFormat.MMMM().parse(parts[0]).month;
      final selectedYear = int.parse(parts[1]);

      filteredReports = allReports.where((report) {
        final createdAt = DateTime.tryParse(report['createdAt'] ?? '');
        return createdAt != null &&
            createdAt.month == selectedMonthNumber &&
            createdAt.year == selectedYear;
      }).toList();
    }

    calculateTotals();
    setState(() {});
  }

  void calculateTotals() {
    totalAmount = 0;
    weeklyAmount = 0;
    final now = DateTime.now();
    final oneWeekAgo = now.subtract(const Duration(days: 7));

    for (var report in filteredReports) {
      final createdAt = DateTime.tryParse(report['createdAt'] ?? '');
      final amount = (report['totalMoney'] ?? 0).toDouble();
      totalAmount += amount;

      if (createdAt != null && createdAt.isAfter(oneWeekAgo)) {
        weeklyAmount += amount;
      }
    }
  }

  List<String> getAvailableMonths() {
    final months = <String>{};
    for (var report in allReports) {
      final date = DateTime.tryParse(report['createdAt'] ?? '');
      if (date != null) {
        months.add('${DateFormat.MMMM().format(date)} ${date.year}');
      }
    }
    final list = months.toList()..sort((a, b) => b.compareTo(a));
    return ['All', ...list];
  }

  Future<void> exportToCSV() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        if (androidInfo.version.sdkInt >= 30) {
          if (!await Permission.manageExternalStorage.request().isGranted) {
            showError("Manage External Storage permission denied");
            return;
          }
        } else {
          if (!await Permission.storage.request().isGranted) {
            showError("Storage permission denied");
            return;
          }
        }
      }

      final rows = <List<String>>[
        [
          'Customer',
          'Phone',
          'Address',
          'Date',
          'Parts Used',
          'Amount',
          'Received',
        ],
      ];

      for (var report in filteredReports) {
        final remarks = report['remarks'] ?? '';
        final nameMatch = RegExp(r'Customer: (.*?),').firstMatch(remarks);
        final phoneMatch = RegExp(r'Phone: (\d+),').firstMatch(remarks);
        final addressMatch = RegExp(r'Address: (.*?),').firstMatch(remarks);
        final dateMatch = RegExp(r'DateTime: ([^,]+)').firstMatch(remarks);
        final receivedMatch = RegExp(
          r'AmountReceived ?: ?(\d+)',
        ).firstMatch(remarks);

        final customerName = nameMatch?.group(1) ?? '-';
        final phone = phoneMatch?.group(1) ?? '-';
        final address = addressMatch?.group(1) ?? '-';
        final date = dateMatch?.group(1) ?? '-';
        final parts = report['summary'] ?? '-';
        final amount = report['totalMoney'].toString();
        final received = receivedMatch?.group(1) ?? '0';

        rows.add([
          customerName,
          phone,
          address,
          date!,
          parts,
          amount,
          received,
        ]);
      }

      final csvData = const ListToCsvConverter().convert(rows);

      final downloadsDir = Directory('/storage/emulated/0/Download');
      final fileName =
          'Technician_Report_${DateTime.now().millisecondsSinceEpoch}.csv';
      final filePath = pathLib.join(downloadsDir.path, fileName);

      final file = File(filePath);
      await file.writeAsString(csvData);

      await OpenFilex.open(filePath);
      await Share.shareXFiles([XFile(filePath)], text: "Technician Report CSV");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("CSV downloaded and shared: $filePath"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      showError("CSV export failed: $e");
    }
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
            onPressed: exportToCSV,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: DropdownButtonFormField<String>(
                    value: selectedMonth,
                    decoration: const InputDecoration(
                      labelText: "Filter by Month",
                    ),
                    items: getAvailableMonths()
                        .map(
                          (month) => DropdownMenuItem(
                            value: month,
                            child: Text(month),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      selectedMonth = value!;
                      applyFilter();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Monthly Total: ₹${totalAmount.toStringAsFixed(2)}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Last 7 Days: ₹${weeklyAmount.toStringAsFixed(2)}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Customer')),
                        DataColumn(label: Text('Phone')),
                        DataColumn(label: Text('Address')),
                        DataColumn(label: Text('Date')),
                        DataColumn(label: Text('Parts Used')),
                        DataColumn(label: Text('Amount (₹)')),
                        DataColumn(label: Text('Received (₹)')),
                      ],
                      rows: filteredReports.map((report) {
                        final remarks = report['remarks'] ?? '';
                        final nameMatch = RegExp(
                          r'Customer: (.*?),',
                        ).firstMatch(remarks);
                        final phoneMatch = RegExp(
                          r'Phone: (\d+),',
                        ).firstMatch(remarks);
                        final addressMatch = RegExp(
                          r'Address: (.*?),',
                        ).firstMatch(remarks);
                        final dateMatch = RegExp(
                          r'DateTime: ([^,]+)',
                        ).firstMatch(remarks);
                        final receivedMatch = RegExp(
                          r'AmountReceived ?: ?(\d+)',
                        ).firstMatch(remarks);

                        final customerName = nameMatch?.group(1) ?? '-';
                        final phone = phoneMatch?.group(1) ?? '-';
                        final address = addressMatch?.group(1) ?? '-';
                        final date = dateMatch != null
                            ? DateFormat(
                                'yyyy-MM-dd',
                              ).format(DateTime.parse(dateMatch.group(1)!))
                            : '-';
                        final received = receivedMatch?.group(1) ?? '0';

                        return DataRow(
                          cells: [
                            DataCell(Text(customerName)),
                            DataCell(Text(phone)),
                            DataCell(Text(address)),
                            DataCell(Text(date)),
                            DataCell(Text(report['summary'] ?? '-')),
                            DataCell(Text('₹${report['totalMoney'] ?? 0}')),
                            DataCell(Text('₹$received')),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
