import 'package:flutter/material.dart';
import 'package:mk_services/core/services/api_service.dart';

class UserBookingsScreen extends StatelessWidget {
  const UserBookingsScreen({super.key});

  Future<List<Map<String, dynamic>>> _fetchBookings() async {
    final api = ApiService();
    return await api.getMyBookings(); // Use user-specific bookings
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchBookings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final bookings = snapshot.data ?? [];
          if (bookings.isEmpty) {
            return const Center(child: Text('No bookings found'));
          }

          return RefreshIndicator(
            onRefresh: () async => await _fetchBookings(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];

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
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              'Status: ',
                              style: const TextStyle(
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
                    leading: const Icon(Icons.build_circle, color: Colors.blue),
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
