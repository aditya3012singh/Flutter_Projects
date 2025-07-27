import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mk_services/core/services/api_service.dart';

class DueServiceListScreen extends StatefulWidget {
  const DueServiceListScreen({super.key});

  @override
  State<DueServiceListScreen> createState() => _DueServiceListScreenState();
}

class _DueServiceListScreenState extends State<DueServiceListScreen> {
  List<Map<String, dynamic>> _dueCustomers = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchDueServices();
  }

  Future<void> _fetchDueServices() async {
    try {
      final data = await ApiService().getDueServices();
      setState(() {
        _dueCustomers = data;
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
          ? const Center(child: CircularProgressIndicator())
          : _dueCustomers.isEmpty
          ? const Center(child: Text("No due services found"))
          : RefreshIndicator(
              onRefresh: _fetchDueServices,
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _dueCustomers.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final customer = _dueCustomers[index];

                  final lastDate = DateTime.parse(
                    customer['serviceDate'] ?? DateTime.now().toString(),
                  );
                  final nextDue = lastDate.add(const Duration(days: 90));

                  final isOverdue = DateTime.now().isAfter(nextDue);

                  return Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(customer['user']?['name']?[0] ?? "?"),
                      ),
                      title: Text(customer['user']?['name'] ?? "Unknown"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("📞 ${customer['user']?['phone'] ?? 'N/A'}"),
                          Text(
                            "🧾 Service Type: ${customer['serviceType'] ?? 'N/A'}",
                          ),
                          Text(
                            "📅 Last Service: ${dateFormat.format(lastDate)}",
                          ),
                          Text("📅 Next Due: ${dateFormat.format(nextDue)}"),
                        ],
                      ),
                      trailing: isOverdue
                          ? const Icon(Icons.warning, color: Colors.red)
                          : const Icon(Icons.check_circle, color: Colors.green),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
