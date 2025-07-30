import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shimmer/shimmer.dart';
import 'package:mk_services/core/services/api_service.dart';

class AdminProductListScreen extends StatefulWidget {
  const AdminProductListScreen({super.key});

  @override
  State<AdminProductListScreen> createState() => _AdminProductListScreenState();
}

class _AdminProductListScreenState extends State<AdminProductListScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Map<String, dynamic>>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = _apiService.getAllParts();
  }

  void _reloadProducts() {
    setState(() {
      _productsFuture = Future.delayed(
        const Duration(milliseconds: 200),
        () => _apiService.getAllParts(),
      );
    });

    Fluttertoast.showToast(
      msg: "Product list refreshed",
      backgroundColor: Colors.blueAccent,
      textColor: Colors.white,
    );
  }

  void _showAddProductDialog() {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    final priceController = TextEditingController();
    final qtyController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Add New Product',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        contentPadding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        content: SingleChildScrollView(
          child: Column(
            children: [
              _roundedField(nameController, 'Product Name'),
              const SizedBox(height: 12),
              _roundedField(descController, 'Description'),
              const SizedBox(height: 12),
              _roundedField(
                priceController,
                'Unit Cost (₹)',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              _roundedField(
                qtyController,
                'Initial Quantity',
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade800,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 6,
              shadowColor: Colors.black87,
            ),
            onPressed: () async {
              HapticFeedback.mediumImpact();

              final name = nameController.text.trim();
              final desc = descController.text.trim();
              final price = double.tryParse(priceController.text) ?? 0;
              final qty = int.tryParse(qtyController.text) ?? 0;

              if (name.isEmpty || price <= 0 || qty < 0) {
                Fluttertoast.showToast(
                  msg: "Please enter valid product details",
                  backgroundColor: Colors.redAccent,
                  textColor: Colors.white,
                );
                return;
              }

              Navigator.pop(context);

              try {
                final result = await _apiService.createPart(
                  name: name,
                  description: desc,
                  unitCost: price,
                  quantity: qty,
                );

                if (result['success']) {
                  Fluttertoast.showToast(
                    msg: "Product added successfully!",
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                  );
                  _reloadProducts();
                } else {
                  Fluttertoast.showToast(
                    msg: result['message'],
                    backgroundColor: Colors.redAccent,
                    textColor: Colors.white,
                  );
                }
              } catch (e) {
                Fluttertoast.showToast(
                  msg: 'Error: $e',
                  backgroundColor: Colors.redAccent,
                  textColor: Colors.white,
                );
              }
            },
            child: const Text('Add', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(String partId, String partName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Product"),
        content: Text("Are you sure you want to delete \"$partName\"?"),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              try {
                final success = await _apiService.deletePart(partId);
                if (success) {
                  Fluttertoast.showToast(
                    msg: "Product deleted successfully!",
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                  );
                  _reloadProducts();
                } else {
                  Fluttertoast.showToast(
                    msg: "Failed to delete product",
                    backgroundColor: Colors.redAccent,
                    textColor: Colors.white,
                  );
                }
              } catch (e) {
                Fluttertoast.showToast(
                  msg: 'Error: $e',
                  backgroundColor: Colors.redAccent,
                  textColor: Colors.white,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _roundedField(
    TextEditingController controller,
    String hint, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
        ),
      ),
    );
  }

  Widget _buildShimmerLoader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView.builder(
        itemCount: 6,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'Product Inventory',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade900,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _reloadProducts();
          await Future.delayed(const Duration(milliseconds: 300));
        },
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _productsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildShimmerLoader();
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final products = snapshot.data ?? [];
            if (products.isEmpty) {
              return const Center(child: Text('No products available.'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final p = products[index];
                return Card(
                  color: Colors.white,
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      p['name'] ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Stock: ${p['quantity']} pcs\n₹${(p['unitCost'] ?? 0).toStringAsFixed(2)}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => _confirmDelete(p['id'], p['name']),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddProductDialog,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Product', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue.shade700,
        elevation: 6,
      ),
    );
  }
}
