import 'package:flutter/material.dart';

class AdminProductListScreen extends StatelessWidget {
  const AdminProductListScreen({super.key});

  final List<Map<String, dynamic>> products = const [
    {
      'name': 'Filter Cartridge',
      'price': '₹500',
      'stock': 120,
      'image': 'assets/images/image1.png',
    },
    {
      'name': 'RO Membrane',
      'price': '₹1200',
      'stock': 65,
      'image': 'assets/images/image1.png',
    },
    {
      'name': 'Pump Motor',
      'price': '₹2000',
      'stock': 42,
      'image': 'assets/images/image1.png',
    },
    {
      'name': 'Pre-Filter',
      'price': '₹300',
      'stock': 97,
      'image': 'assets/images/image1.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'All Products',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade900,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: products.length,
        itemBuilder: (_, index) {
          final product = products[index];
          return Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  product['image'] ?? '',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                product['name'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Stock: ${product['stock']} pcs'),
              trailing: Text(
                product['price'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  fontSize: 16,
                ),
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(height: 12),
      ),
    );
  }
}
