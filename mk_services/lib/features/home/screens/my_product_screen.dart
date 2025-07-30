// import 'package:flutter/material.dart';

// class MyProductScreen extends StatelessWidget {
//   const MyProductScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Sample product data
//     final List<Map<String, String>> products = [
//       {'name': 'AquaSure RO+UV', 'serial': 'AS-2345-XYZ', 'status': 'Active'},
//       {
//         'name': 'Kent Supreme Extra',
//         'serial': 'KS-9891-ABC',
//         'status': 'Inactive',
//       },
//     ];

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text('My Products', style: TextStyle(color: Colors.white)),
//         backgroundColor: Colors.blue.shade900,
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: products.isEmpty
//             ? const Center(
//                 child: Text(
//                   'No products added.',
//                   style: TextStyle(fontSize: 16, color: Colors.grey),
//                 ),
//               )
//             : ListView.separated(
//                 itemCount: products.length,
//                 separatorBuilder: (_, __) => const SizedBox(height: 12),
//                 itemBuilder: (context, index) {
//                   final product = products[index];
//                   return Card(
//                     color: Colors.white,
//                     elevation: 3,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 12,
//                         horizontal: 16,
//                       ),
//                       child: ListTile(
//                         contentPadding: EdgeInsets.zero,
//                         title: Text(
//                           product['name']!,
//                           style: const TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                         subtitle: Text('Serial: ${product['serial']}'),
//                         trailing: Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 12,
//                             vertical: 6,
//                           ),
//                           decoration: BoxDecoration(
//                             color: product['status'] == 'Active'
//                                 ? Colors.green.shade100
//                                 : Colors.grey.shade300,
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Text(
//                             product['status']!,
//                             style: TextStyle(
//                               color: product['status'] == 'Active'
//                                   ? Colors.green
//                                   : Colors.grey,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//       ),
//     );
//   }
// }
