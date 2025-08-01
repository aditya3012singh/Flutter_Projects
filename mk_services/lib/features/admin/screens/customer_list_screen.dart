import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mk_services/core/models/user_model.dart';
import 'package:mk_services/core/services/api_service.dart';
import 'package:shimmer/shimmer.dart';

// Provider to fetch all customers (role = USER)
final customersProvider = FutureProvider.autoDispose<List<UserModel>>((
  ref,
) async {
  final apiService = ApiService();
  final users = await apiService.getAllUsers();
  return users.where((user) => user.role == 'USER').toList();
});

class AllCustomersScreen extends ConsumerWidget {
  const AllCustomersScreen({super.key});

  void _showErrorToast(Object error) {
    Fluttertoast.showToast(
      msg: 'Failed to load customers: $error',
      backgroundColor: Colors.redAccent,
      textColor: Colors.white,
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
              margin: const EdgeInsets.only(bottom: 16),
              height: 90,
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
  Widget build(BuildContext context, WidgetRef ref) {
    final customersAsync = ref.watch(customersProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'All Customers',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade900,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: customersAsync.when(
        loading: () => _buildShimmerLoader(),
        error: (error, _) {
          _showErrorToast(error);
          return Center(
            child: Text(
              'Error: $error',
              style: const TextStyle(color: Colors.red),
            ),
          );
        },
        data: (customers) {
          if (customers.isEmpty) {
            return const Center(child: Text('No customers found.'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(customersProvider);
              await Future.delayed(const Duration(milliseconds: 300));
              Fluttertoast.showToast(
                msg: "Customer list refreshed",
                backgroundColor: Colors.blueAccent,
                textColor: Colors.white,
              );
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: customers.length,
              itemBuilder: (context, index) {
                final customer = customers[index];
                return Card(
                  color: Colors.white,
                  elevation: 3,
                  shadowColor: Colors.grey.shade300,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blue.shade700,
                          radius: 28,
                          child: Text(
                            (customer.name?.isNotEmpty == true
                                ? customer.name![0].toUpperCase()
                                : '?'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                customer.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text('📧 ${customer.email}'),
                              Text('📞 ${customer.phone ?? 'N/A'}'),
                              Text('📍 ${customer.location ?? 'N/A'}'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
