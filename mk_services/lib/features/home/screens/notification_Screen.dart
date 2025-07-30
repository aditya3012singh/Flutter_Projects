import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mk_services/core/services/api_service.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;

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
    if (!silent) setState(() => _loading = true);
    try {
      final data = await ApiService().getNotifications();
      setState(() {
        _notifications = data;
        _loading = false;
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to load notifications");
      setState(() => _loading = false);
    }
  }

  Future<void> _markAllAsRead() async {
    try {
      await ApiService().markAllNotificationsAsRead();
      Fluttertoast.showToast(msg: "All marked as read");
      _fetchNotifications();
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to mark all as read");
    }
  }

  Future<void> _markOneAsRead(String id) async {
    try {
      await ApiService().markNotificationAsRead(id);
      _fetchNotifications(silent: true);
    } catch (_) {}
  }

  Widget _buildShimmer() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: ListTile(
          title: Container(height: 12, width: 100, color: Colors.white),
          subtitle: Container(height: 10, width: 150, color: Colors.white),
        ),
      ),
      separatorBuilder: (_, __) => const Divider(),
    );
  }

  Widget _buildList() {
    if (_notifications.isEmpty) {
      return const Center(child: Text("No notifications"));
    }

    return RefreshIndicator(
      onRefresh: _fetchNotifications,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _notifications.length,
        itemBuilder: (_, index) {
          final item = _notifications[index];
          final createdAt = item['createdAt'] != null
              ? DateTime.tryParse(item['createdAt'])?.toLocal()
              : null;

          return ListTile(
            tileColor: (item['isRead'] == false) ? Colors.grey[100] : null,
            onTap: () => _markOneAsRead(item['_id']),
            title: Text(
              item['title'] ?? "No title",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(item['message'] ?? ""),
            trailing: createdAt != null
                ? Text(
                    timeago.format(createdAt),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  )
                : null,
          );
        },
        separatorBuilder: (_, __) => const Divider(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            tooltip: "Mark all as read",
            onPressed: _markAllAsRead,
          ),
        ],
      ),
      body: _loading ? _buildShimmer() : _buildList(),
    );
  }
}
