import 'package:flutter/material.dart';

class StockManagementScreen extends StatelessWidget {
  const StockManagementScreen({super.key});

  final List<Map<String, dynamic>> stockItems = const [
    {'name': 'Filter Cartridge', 'quantity': 30, 'threshold': 10},
    {'name': 'RO Membrane', 'quantity': 12, 'threshold': 5},
    {'name': 'Pump Motor', 'quantity': 5, 'threshold': 3},
    {'name': 'Pre-Filter', 'quantity': 40, 'threshold': 15},
  ];

  Color getStockColor(int quantity, int threshold) {
    if (quantity <= threshold) {
      return Colors.red.shade400;
    } else if (quantity <= threshold + 5) {
      return Colors.orange.shade400;
    } else {
      return Colors.green.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'Stock Management',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade900,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: stockItems.length,
        itemBuilder: (context, index) {
          final item = stockItems[index];
          final stockColor = getStockColor(item['quantity'], item['threshold']);
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: Text(
                item['name'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Current Stock: ${item['quantity']}',
                style: TextStyle(color: stockColor, fontSize: 14),
              ),
              trailing: ElevatedButton.icon(
                onPressed: () {
                  // Trigger update/add stock dialog or page
                },
                icon: const Icon(Icons.add),
                label: const Text('Restock'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
