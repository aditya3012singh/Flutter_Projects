import 'package:flutter/material.dart';
import 'package:mk_services/core/services/api_service.dart';
import 'package:shimmer/shimmer.dart';

class UserBookingsScreen extends StatefulWidget {
  const UserBookingsScreen({super.key});

  @override
  State<UserBookingsScreen> createState() => _UserBookingsScreenState();
}

class _UserBookingsScreenState extends State<UserBookingsScreen> {
  List<Map<String, dynamic>> _bookings = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    setState(() => _loading = true);
    try {
      final data = await ApiService().getMyBookings();
      setState(() {
        _bookings = data;
        _loading = false;
      });
    } catch (e) {
      print("Error fetching bookings: $e");
      setState(() => _loading = false);
    }
  }

  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.white,
      highlightColor: Colors.grey.shade200,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.only(bottom: 16),
        child: const SizedBox(height: 100, width: double.infinity),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _loading
          ? ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 6,
              itemBuilder: (_, __) => _buildShimmerCard(),
            )
          : RefreshIndicator(
              onRefresh: _loadBookings,
              child: _bookings.isEmpty
                  ? const Center(child: Text('No bookings found'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _bookings.length,
                      itemBuilder: (context, index) {
                        final booking = _bookings[index];

                        final service = booking['serviceType'] ?? 'Unknown';
                        final status = booking['status'] ?? 'PENDING';
                        final date = booking['serviceDate'] ?? '';
                        final technician =
                            booking['technician']?['name'] ?? 'Not Assigned';

                        Color statusColor;
                        switch (status.toUpperCase()) {
                          case 'COMPLETED':
                            statusColor = Colors.green;
                            break;
                          case 'IN_PROGRESS':
                            statusColor = Colors.orange;
                            break;
                          default:
                            statusColor = Colors.grey;
                        }

                        return Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                          margin: const EdgeInsets.only(bottom: 16),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            title: Text(
                              service,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Text(
                                      'Status: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: statusColor.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(6),
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
                                Text('Date: $date'),
                                Text('Technician: $technician'),
                              ],
                            ),
                            leading: const Icon(
                              Icons.build_circle,
                              color: Colors.blue,
                            ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
