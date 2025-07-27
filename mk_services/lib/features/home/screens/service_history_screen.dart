import 'package:flutter/material.dart';
import 'package:mk_services/core/services/api_service.dart';

class ServiceHistoryScreen extends StatefulWidget {
  const ServiceHistoryScreen({super.key});

  @override
  State<ServiceHistoryScreen> createState() => _ServiceHistoryScreenState();
}

class _ServiceHistoryScreenState extends State<ServiceHistoryScreen> {
  bool _loading = true;
  List<Map<String, dynamic>> _history = [];

  @override
  void initState() {
    super.initState();
    _fetchServiceHistory();
  }

  Future<void> _fetchServiceHistory() async {
    try {
      final data = await ApiService().getMyBookings();
      setState(() {
        _history = data;
        _loading = false;
      });
    } catch (e) {
      print("Error loading service history: $e");
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Service History',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade900,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _history.isEmpty
          ? const Center(
              child: Text(
                'No service history available.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : RefreshIndicator(
              onRefresh: _fetchServiceHistory,
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _history.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final record = _history[index];

                  // Map API fields to UI
                  final serviceType = record['serviceType'] ?? 'Service';
                  final serviceDate = record['serviceDate'] ?? '';
                  final technicianName =
                      record['technician']?['name'] ?? 'Not Assigned';
                  final status = record['status'] ?? 'Pending';

                  final icon = serviceType == 'Installation'
                      ? Icons.plumbing
                      : Icons.build;

                  final statusColor = status == 'COMPLETED'
                      ? Colors.green
                      : Colors.orange;

                  return Card(
                    color: Colors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(icon, color: Colors.blue, size: 30),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  serviceType,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Date: ${serviceDate.isNotEmpty ? DateTime.parse(serviceDate).toLocal().toString().split(" ").first : "-"}',
                                ),
                                Text('Technician: $technicianName'),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                color: statusColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
