import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mk_services/core/services/api_service.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Map<String, dynamic>> _notifications = [];
  bool _loading = true;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();

    // Auto-refresh every 30 seconds
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _fetchNotifications(silent: true);
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchNotifications({bool silent = false}) async {
    if (!silent) {
      setState(() => _loading = true);
    }
    try {
      final data = await ApiService().getNotifications();
      setState(() {
        _notifications = data;
        _loading = false;
      });
    } catch (e) {
      print("Error loading notifications: $e");
      setState(() => _loading = false);
    }
  }

  Future<void> _markAllAsRead() async {
    await ApiService().markAllNotificationsAsRead();
    _fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            tooltip: "Mark all as read",
            onPressed: _markAllAsRead,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
          ? const Center(child: Text("No notifications"))
          : RefreshIndicator(
              onRefresh: _fetchNotifications,
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _notifications.length,
                itemBuilder: (_, index) {
                  final item = _notifications[index];
                  return ListTile(
                    title: Text(
                      item['title'] ?? "No title",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(item['message'] ?? ""),
                    trailing: Text(
                      item['createdAt'] != null
                          ? DateTime.parse(
                              item['createdAt'],
                            ).toLocal().toString()
                          : "",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  );
                },
                separatorBuilder: (_, __) => const Divider(),
              ),
            ),
    );
  }
}
