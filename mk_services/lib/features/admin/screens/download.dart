// import 'dart:io';
// import 'package:csv/csv.dart';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:open_file/open_file.dart';

// Future<void> exportReportsToCSV(
//   List<Map<String, dynamic>> reportData,
//   String filterLabel,
// ) async {
//   try {
//     // Request storage permissions (for Android)
//     if (Platform.isAndroid) {
//       final status = await Permission.storage.request();
//       if (!status.isGranted) {
//         throw Exception('Storage permission not granted');
//       }
//     }

//     // Convert data to CSV format
//     List<List<dynamic>> rows = [
//       ['Customer Name', 'Date', 'Service Type', 'Amount', 'Remarks'], // Header
//     ];
//     for (var report in reportData) {
//       rows.add([
//         report['customerName'],
//         report['date'],
//         report['serviceType'],
//         report['amount'],
//         report['remarks'],
//       ]);
//     }
//     String csvData = const ListToCsvConverter().convert(rows);

//     // Get external directory
//     final dir = await getExternalStorageDirectory();
//     final path =
//         '${dir!.path}/filtered_report_${filterLabel.toLowerCase()}.csv';

//     // Save file
//     final file = File(path);
//     await file.writeAsString(csvData);

//     // Auto open file
//     await OpenFile.open(file.path);

//     // Optionally share via Email or WhatsApp
//     await Share.shareXFiles([
//       XFile(file.path),
//     ], text: 'Here is the filtered report ($filterLabel)');
//   } catch (e) {
//     debugPrint('CSV export error: $e');
//   }
// }
