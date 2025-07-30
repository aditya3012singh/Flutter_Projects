import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mk_services/core/services/api_service.dart';
import 'package:shimmer/shimmer.dart';

class DueServiceListScreen extends StatefulWidget {
  const DueServiceListScreen({super.key});

  @override
  State<DueServiceListScreen> createState() => _DueServiceListScreenState();
}

class _DueServiceListScreenState extends State<DueServiceListScreen> {
  List<Map<String, dynamic>> _dueBookings = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchDueServices();
  }

  Future<void> _fetchDueServices() async {
    try {
      final bookings = await ApiService().getDueServices();
      setState(() {
        _dueBookings = bookings;
        _loading = false;
      });
    } catch (e) {
      print("Error fetching due services: $e");
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Due RO Services'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 4,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CircleAvatar(
                              radius: 22,
                              backgroundColor: Colors.white,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 18,
                                    width: 100,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    height: 14,
                                    width: 150,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    height: 14,
                                    width: 200,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    height: 14,
                                    width: 180,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    height: 14,
                                    width: 160,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
          : _dueBookings.isEmpty
          ? const Center(child: Text("No due services found"))
          : RefreshIndicator(
              onRefresh: _fetchDueServices,
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _dueBookings.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final booking = _dueBookings[index];
                  final user = booking['user'] ?? {};

                  final lastServiceDateStr =
                      booking['serviceDate'] ??
                      DateTime.now().toIso8601String();
                  final lastServiceDate =
                      DateTime.tryParse(lastServiceDateStr) ?? DateTime.now();
                  final nextDueDate = lastServiceDate.add(
                    const Duration(days: 90),
                  );

                  final isOverdue = DateTime.now().isAfter(nextDueDate);
                  final status = booking['status'] ?? 'UNKNOWN';

                  Icon statusIcon;
                  String statusLabel;
                  Color statusColor;

                  if (status == 'COMPLETED') {
                    statusIcon = const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    );
                    statusLabel = "Completed";
                    statusColor = Colors.green;
                  } else if (status == 'IN_PROGRESS') {
                    statusIcon = const Icon(
                      Icons.timelapse,
                      color: Colors.orange,
                    );
                    statusLabel = "In Progress";
                    statusColor = Colors.orange;
                  } else {
                    statusIcon = const Icon(
                      Icons.info_outline,
                      color: Colors.grey,
                    );
                    statusLabel = "Pending";
                    statusColor = Colors.grey;
                  }

                  return Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: Colors.blue.shade100,
                            child: Text(
                              (user['name']?.toString().trim().isNotEmpty ??
                                      false)
                                  ? user['name']
                                        .toString()
                                        .trim()[0]
                                        .toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user['name']?.toString().trim() ?? "Unknown",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text("📞 ${user['phone'] ?? 'N/A'}"),
                                Text(
                                  "📍 Address: ${user['location'] ?? 'N/A'}",
                                ),
                                Text(
                                  "🧾 Service Type: ${booking['serviceType'] ?? 'N/A'}",
                                ),
                                Text(
                                  "📅 Last Service: ${dateFormat.format(lastServiceDate)}",
                                ),
                                Text(
                                  "📅 Next Due: ${dateFormat.format(nextDueDate)}",
                                ),
                                if (isOverdue)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Row(
                                      children: const [
                                        Icon(
                                          Icons.warning,
                                          color: Colors.red,
                                          size: 18,
                                        ),
                                        SizedBox(width: 6),
                                        Text(
                                          "Overdue!",
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              statusIcon,
                              const SizedBox(height: 6),
                              Text(
                                statusLabel,
                                style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
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
