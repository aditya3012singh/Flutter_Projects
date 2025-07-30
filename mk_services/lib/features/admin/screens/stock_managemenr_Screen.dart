import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mk_services/core/services/api_service.dart';
import 'package:shimmer/shimmer.dart';

class StockManagementScreen extends StatefulWidget {
  const StockManagementScreen({super.key});

  @override
  State<StockManagementScreen> createState() => _StockManagementScreenState();
}

class _StockManagementScreenState extends State<StockManagementScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Map<String, dynamic>>> _stockFuture;

  @override
  void initState() {
    super.initState();
    _stockFuture = fetchStock();
  }

  Future<List<Map<String, dynamic>>> fetchStock() async {
    return await _apiService.getAllParts();
  }

  Future<void> _refreshStock() async {
    setState(() {
      _stockFuture = fetchStock();
    });
  }

  Color getStockColor(int quantity) {
    if (quantity <= 5) return Colors.red.shade400;
    if (quantity <= 10) return Colors.orange.shade400;
    return Colors.green.shade600;
  }

  void _openBulkDialog(String partId) {
    final quantityController = TextEditingController();
    final reasonController = TextEditingController();

    bool isProcessing = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Bulk Update Stock'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: reasonController,
                decoration: const InputDecoration(
                  labelText: 'Reason',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
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
                        Fluttertoast.showToast(
                          msg: 'Enter valid quantity & reason',
                        );
                        return;
                      }

                      setStateDialog(() => isProcessing = true);
                      Navigator.pop(context);

                      final success = await _apiService.addStock(
                        partId,
                        qty,
                        reason,
                      );
                      if (success) {
                        Fluttertoast.showToast(
                          msg: 'Stock increased successfully',
                        );
                        _refreshStock();
                      }
                    },
                    child: isProcessing
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Increase',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () async {
                      final qty = int.tryParse(quantityController.text) ?? 0;
                      final reason = reasonController.text.trim();
                      if (qty <= 0 || reason.isEmpty) {
                        Fluttertoast.showToast(
                          msg: 'Enter valid quantity & reason',
                        );
                        return;
                      }

                      setStateDialog(() => isProcessing = true);
                      Navigator.pop(context);

                      final success = await _apiService.reduceStock(
                        partId,
                        qty,
                        reason,
                      );
                      if (success) {
                        Fluttertoast.showToast(
                          msg: 'Stock reduced successfully',
                        );
                        _refreshStock();
                      }
                    },
                    child: isProcessing
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Decrease',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _quickUpdate(String partId, int change) async {
    bool success;
    if (change > 0) {
      success = await _apiService.addStock(partId, 1, 'Quick Add (+1)');
    } else {
      success = await _apiService.reduceStock(partId, 1, 'Quick Reduce (-1)');
    }

    if (success) {
      Fluttertoast.showToast(
        msg: change > 0 ? 'Increased by 1' : 'Reduced by 1',
      );
      _refreshStock();
    } else {
      Fluttertoast.showToast(msg: 'Failed to update stock');
    }
  }

  Widget _buildLoadingCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(height: 20, width: 150, color: Colors.white),
              const SizedBox(height: 12),
              Container(height: 14, width: 80, color: Colors.white),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: List.generate(3, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Stock Management',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade900,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshStock,
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _stockFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: 6,
                itemBuilder: (context, index) => _buildLoadingCard(),
              );
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
                        Row(
                          children: [
                            const Text(
                              'Stock: ',
                              style: TextStyle(fontSize: 15),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: stockColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${item['quantity'] ?? 0}',
                                style: TextStyle(
                                  color: stockColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
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
      ),
    );
  }
}
