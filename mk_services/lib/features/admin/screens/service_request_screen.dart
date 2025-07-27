import 'package:flutter/material.dart';
import 'package:mk_services/core/services/api_service.dart';

class ServiceRequestScreentwo extends StatefulWidget {
  const ServiceRequestScreentwo({super.key});

  @override
  State<ServiceRequestScreentwo> createState() => _ServiceRequestScreenState();
}

class _ServiceRequestScreenState extends State<ServiceRequestScreentwo> {
  final ApiService _api = ApiService();

  List<Map<String, dynamic>> bookings = [];
  List<Map<String, dynamic>> technicians = [];
  bool loading = true;
  String selectedStatus = 'All';
  String selectedTechnician = 'All';
  String sortBy = 'Date';
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() => loading = true);
    try {
      final allBookings = await _api.getAllBookings();
      // You could fetch technicians dynamically if API exists
      technicians = [
        {'id': 'tech1', 'name': 'Ravi Kumar'},
        {'id': 'tech2', 'name': 'Suman Yadav'},
      ];
      setState(() => bookings = allBookings);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> assignTechnician(String bookingId, String techId) async {
    final success = await _api.assignTechnician(bookingId, techId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? "Technician assigned" : "Assignment failed"),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
    if (success) await fetchData(); // Refresh list
  }

  void downloadCSV() async {
    try {
      await _api.exportBookingsCSV();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Download failed: $e')));
    }
  }

  List<Map<String, dynamic>> get filtered {
    var filtered = bookings;
    if (selectedStatus != 'All') {
      filtered = filtered.where((b) => b['status'] == selectedStatus).toList();
    }
    if (selectedTechnician != 'All') {
      filtered = filtered
          .where((b) => (b['technician']?['name'] ?? '') == selectedTechnician)
          .toList();
    }
    if (searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (b) =>
                (b['id'] ?? '').toLowerCase().contains(
                  searchQuery.toLowerCase(),
                ) ||
                (b['user']?['name'] ?? '').toLowerCase().contains(
                  searchQuery.toLowerCase(),
                ),
          )
          .toList();
    }
    filtered.sort(
      (a, b) => sortBy == 'Date'
          ? (b['createdAt'] ?? '').compareTo(a['createdAt'] ?? '')
          : (a['user']?['name'] ?? '').compareTo(b['user']?['name'] ?? ''),
    );
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Service Requests",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade900,
        actions: [
          IconButton(
            icon: const Icon(Icons.download, color: Colors.white),
            onPressed: downloadCSV,
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    onChanged: (v) => setState(() => searchQuery = v),
                    decoration: InputDecoration(
                      hintText: "Search by ID or Customer",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: filtered.isEmpty
                      ? const Center(child: Text("No requests found"))
                      : ListView.builder(
                          itemCount: filtered.length,
                          padding: const EdgeInsets.all(16),
                          itemBuilder: (ctx, i) {
                            final b = filtered[i];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                title: Text("Booking: ${b['id']}"),
                                subtitle: Text(
                                  "Customer: ${b['user']?['name'] ?? ''}\n"
                                  "Status: ${b['status']}\n"
                                  "Technician: ${b['technician']?['name'] ?? 'Not Assigned'}",
                                ),
                                trailing: ElevatedButton(
                                  onPressed: () =>
                                      showTechnicianPicker(b['id']),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue.shade700,
                                  ),
                                  child: const Text(
                                    "Assign",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }

  void showTechnicianPicker(String bookingId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Assign Technician"),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: technicians.length,
            itemBuilder: (_, i) {
              final tech = technicians[i];
              return ListTile(
                title: Text(tech['name']!),
                onTap: () {
                  Navigator.pop(context);
                  assignTechnician(bookingId, tech['id']!);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
