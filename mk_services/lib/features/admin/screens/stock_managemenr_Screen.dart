import 'package:flutter/material.dart';
import 'package:mk_services/core/services/api_service.dart';

class StockManagementScreen extends StatefulWidget {
  const StockManagementScreen({super.key});

  @override
  State<StockManagementScreen> createState() => _StockManagementScreenState();
}

class _StockManagementScreenState extends State<StockManagementScreen> {
  final ApiService _apiService = ApiService();

  Future<List<Map<String, dynamic>>> fetchStock() async {
    return await _apiService.getAllParts();
  }

  Color getStockColor(int quantity) {
    if (quantity <= 5) return Colors.red.shade400;
    if (quantity <= 10) return Colors.orange.shade400;
    return Colors.green.shade600;
  }

  /// Bulk Update Dialog (Separate Increase and Decrease buttons)
  void _openBulkDialog(String partId) {
    final TextEditingController quantityController = TextEditingController();
    final TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bulk Update Stock'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Quantity'),
            ),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(labelText: 'Reason'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () async {
                    final qty = int.tryParse(quantityController.text) ?? 0;
                    final reason = reasonController.text.trim();
                    if (qty <= 0 || reason.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Enter valid quantity & reason'),
                        ),
                      );
                      return;
                    }
                    Navigator.pop(context);
                    final success = await _apiService.addStock(
                      partId,
                      qty,
                      reason,
                    );
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Stock increased successfully'),
                        ),
                      );
                      setState(() {});
                    }
                  },
                  child: const Text('Increase'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () async {
                    final qty = int.tryParse(quantityController.text) ?? 0;
                    final reason = reasonController.text.trim();
                    if (qty <= 0 || reason.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Enter valid quantity & reason'),
                        ),
                      );
                      return;
                    }
                    Navigator.pop(context);
                    final success = await _apiService.reduceStock(
                      partId,
                      qty,
                      reason,
                    );
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Stock reduced successfully'),
                        ),
                      );
                      setState(() {});
                    }
                  },
                  child: const Text('Decrease'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Quick Increment/Decrement by 1
  Future<void> _quickUpdate(String partId, int change) async {
    bool success;
    if (change > 0) {
      success = await _apiService.addStock(partId, 1, 'Quick Add (+1)');
    } else {
      success = await _apiService.reduceStock(partId, 1, 'Quick Reduce (-1)');
    }

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(change > 0 ? 'Increased by 1' : 'Reduced by 1')),
      );
      setState(() {}); // Refresh list
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to update stock')));
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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchStock(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            return const Center(child: Text('No stock items found.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final stockColor = getStockColor(item['quantity'] ?? 0);

              return Card(
                color: Colors.white,
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['name'] ?? '',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Stock: ${item['quantity'] ?? 0}',
                        style: TextStyle(
                          fontSize: 15,
                          color: stockColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.remove_circle,
                              color: Colors.red,
                              size: 32,
                            ),
                            onPressed: () => _quickUpdate(item['id'], -1),
                          ),
                          const SizedBox(width: 12),
                          IconButton(
                            icon: const Icon(
                              Icons.add_circle,
                              color: Colors.green,
                              size: 32,
                            ),
                            onPressed: () => _quickUpdate(item['id'], 1),
                          ),
                          const SizedBox(width: 12),
                          OutlinedButton(
                            onPressed: () => _openBulkDialog(item['id']),
                            child: const Text('Bulk Update'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
