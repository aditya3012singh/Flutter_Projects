// import 'package:flutter/material.dart';

// class StockManagementScreen extends StatefulWidget {
//   const StockManagementScreen({super.key});

//   @override
//   State<StockManagementScreen> createState() => _StockManagementScreenState();
// }

// class _StockManagementScreenState extends State<StockManagementScreen> {
//   List<Map<String, dynamic>> stockItems = [
//     {'name': 'Filter', 'price': 100, 'quantity': 5},
//     {'name': 'Membrane', 'price': 250, 'quantity': 20},
//     {'name': 'Pipe', 'price': 50, 'quantity': 2},
//     {'name': 'Pump', 'price': 1200, 'quantity': 8},
//   ];

//   void _updateStock(int index) async {
//     final TextEditingController controller = TextEditingController();
//     final result = await showDialog<int>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Update Quantity for ${stockItems[index]['name']}'),
//         content: TextField(
//           controller: controller,
//           keyboardType: TextInputType.number,
//           decoration: const InputDecoration(hintText: 'Enter quantity to add'),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               final qty = int.tryParse(controller.text);
//               if (qty != null && qty > 0) {
//                 Navigator.pop(context, qty);
//               }
//             },
//             child: const Text('Update'),
//           ),
//         ],
//       ),
//     );

//     if (result != null) {
//       setState(() {
//         stockItems[index]['quantity'] += result;
//       });
//       // TODO: Call backend API to update stock quantity
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Stock Management"),
//         backgroundColor: Colors.blue.shade700,
//         foregroundColor: Colors.white,
//       ),
//       body: ListView.separated(
//         padding: const EdgeInsets.all(16),
//         itemCount: stockItems.length,
//         separatorBuilder: (_, __) => const Divider(),
//         itemBuilder: (context, index) {
//           final item = stockItems[index];
//           final isLow = item['quantity'] <= 5;

//           return ListTile(
//             leading: CircleAvatar(
//               backgroundColor: Colors.white,
//               child: Text(item['name'][0]),
//             ),
//             title: Text(
//               item['name'],
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//             subtitle: Text(
//               "Price: ₹${item['price']}  |  Qty: ${item['quantity']}",
//               style: TextStyle(
//                 color: isLow ? Colors.red : Colors.grey[700],
//                 fontWeight: isLow ? FontWeight.bold : FontWeight.normal,
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
