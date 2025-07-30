import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mk_services/core/services/api_service.dart';

class ProviderNotificationsScreen extends StatefulWidget {
  const ProviderNotificationsScreen({super.key});

  @override
  State<ProviderNotificationsScreen> createState() =>
      _ProviderNotificationsScreenState();
}

class _ProviderNotificationsScreenState
    extends State<ProviderNotificationsScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Map<String, dynamic>>> _allNotificationsFuture;

  @override
  void initState() {
    super.initState();
    _allNotificationsFuture = _loadNotificationsAndDueSoon();
  }

  Future<List<Map<String, dynamic>>> _loadNotificationsAndDueSoon() async {
    final notifications = await _apiService.getNotifications();
    final dueBookings = await _apiService.getDueServices();

    final now = DateTime.now();
    final oneWeekLater = now.add(const Duration(days: 7));

    // Extract "Due Soon" entries
    final dueSoonBookings = dueBookings
        .where((booking) {
          final lastServiceDate =
              DateTime.tryParse(booking['serviceDate'] ?? '') ?? now;
          final nextDue = lastServiceDate.add(const Duration(days: 90));
          return nextDue.isAfter(now) && nextDue.isBefore(oneWeekLater);
        })
        .map((booking) {
          final user = booking['user'] ?? {};
          final serviceType = booking['serviceType'] ?? 'N/A';
          final lastServiceDate =
              DateTime.tryParse(booking['serviceDate'] ?? '') ?? now;
          final nextDue = lastServiceDate.add(const Duration(days: 90));

          return {
            '_id': booking['_id'],
            'title': 'Upcoming Service for ${user['name'] ?? 'Unknown'}',
            'message':
                'Next service due on ${DateFormat('dd MMM yyyy').format(nextDue)} for $serviceType',
            'read': false,
            'type': 'DUE_SOON',
          };
        })
        .toList();

    // Combine system notifications with due soon alerts
    return [...dueSoonBookings, ...notifications];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Notifications')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _allNotificationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final notifications = snapshot.data ?? [];
          if (notifications.isEmpty) {
            return const Center(child: Text('No notifications'));
          }

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notif = notifications[index];
              final isRead = notif['read'] == true;
              final isDueSoon = notif['type'] == 'DUE_SOON';

              return ListTile(
                leading: Icon(
                  isDueSoon
                      ? Icons.schedule
                      : (isRead
                            ? Icons.mark_email_read
                            : Icons.mark_email_unread),
                  color: isDueSoon
                      ? Colors.orange
                      : (isRead ? Colors.green : Colors.blue),
                ),
                title: Text(notif['title'] ?? 'No title'),
                subtitle: Text(notif['message'] ?? ''),
                trailing: !isDueSoon && !isRead
                    ? IconButton(
                        icon: const Icon(Icons.done),
                        onPressed: () async {
                          final success = await _apiService
                              .markNotificationAsRead(notif['_id']);
                          if (success) {
                            setState(() {
                              _allNotificationsFuture =
                                  _loadNotificationsAndDueSoon();
                            });
                          }
                        },
                      )
                    : null,
              );
            },
          );
        },
      ),
    );
  }
}
