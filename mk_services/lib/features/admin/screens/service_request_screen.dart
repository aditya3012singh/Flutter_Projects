import 'package:flutter/material.dart';

class ServiceRequestScreentwo extends StatefulWidget {
  const ServiceRequestScreentwo({super.key});

  @override
  State<ServiceRequestScreentwo> createState() => _ServiceRequestScreenState();
}

class _ServiceRequestScreenState extends State<ServiceRequestScreentwo> {
  String selectedStatus = 'All';
  String sortBy = 'Date';
  String searchQuery = '';
  String selectedTechnician = 'All';

  final List<Map<String, String>> technicians = [
    {'id': 'tech1', 'name': 'Ravi Kumar'},
    {'id': 'tech2', 'name': 'Suman Yadav'},
    {'id': 'tech3', 'name': 'Nikita Jain'},
  ];

  final List<Map<String, dynamic>> allRequests = [
    {
      'id': 'BK101',
      'customer': 'Aditya Sharma',
      'date': '2025-07-26',
      'status': 'Pending',
      'technician': null,
    },
    {
      'id': 'BK102',
      'customer': 'Priya Verma',
      'date': '2025-07-25',
      'status': 'In Progress',
      'technician': 'Ravi Kumar',
    },
    {
      'id': 'BK103',
      'customer': 'Vikas Gupta',
      'date': '2025-07-24',
      'status': 'Completed',
      'technician': 'Suman Yadav',
    },
  ];

  List<Map<String, dynamic>> get filteredRequests {
    List<Map<String, dynamic>> filtered = allRequests;

    if (selectedStatus != 'All') {
      filtered = filtered.where((r) => r['status'] == selectedStatus).toList();
    }

    if (selectedTechnician != 'All') {
      filtered = filtered
          .where((r) => r['technician'] == selectedTechnician)
          .toList();
    }

    if (searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (r) =>
                r['id'].toLowerCase().contains(searchQuery.toLowerCase()) ||
                r['customer'].toLowerCase().contains(searchQuery.toLowerCase()),
          )
          .toList();
    }

    filtered.sort((a, b) {
      if (sortBy == 'Date') {
        return b['date'].compareTo(a['date']);
      } else {
        return a['customer'].compareTo(b['customer']);
      }
    });

    return filtered;
  }

  void showTechnicianPicker(String bookingId) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Assign Technician"),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: technicians.length,
              itemBuilder: (context, index) {
                final tech = technicians[index];
                return ListTile(
                  title: Text(tech['name']!),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      final request = allRequests.firstWhere(
                        (r) => r['id'] == bookingId,
                      );
                      request['technician'] = tech['name'];
                    });
                    // TODO: Call API here to assign technician & notify
                    // await ApiService.assignTechnician(bookingId, tech['id']);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void downloadCSV() {
    // TODO: Implement CSV download logic from backend or locally
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('CSV download coming soon...')),
    );
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange.shade100;
      case 'In Progress':
        return Colors.blue.shade100;
      case 'Completed':
        return Colors.green.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Service Requests',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade900,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: "Download CSV",
            onPressed: downloadCSV,
            color: Colors.white,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            color: Colors.white,
            onSelected: (value) {
              setState(() {
                selectedStatus = value;
              });
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'All', child: Text('All')),
              PopupMenuItem(value: 'Pending', child: Text('Pending')),
              PopupMenuItem(value: 'In Progress', child: Text('In Progress')),
              PopupMenuItem(value: 'Completed', child: Text('Completed')),
            ],
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort, color: Colors.white),
            color: Colors.white,
            onSelected: (value) {
              setState(() {
                sortBy = value;
              });
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'Date', child: Text('Sort by Date')),
              PopupMenuItem(value: 'Customer', child: Text('Sort by Customer')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: (value) => setState(() => searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Search by Booking ID or Customer',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButtonFormField<String>(
              value: selectedTechnician,
              items: [
                const DropdownMenuItem(
                  value: 'All',
                  child: Text('All Technicians'),
                ),
                ...technicians.map(
                  (t) => DropdownMenuItem(
                    value: t['name'],
                    child: Text(t['name']!),
                  ),
                ),
              ],
              onChanged: (val) => setState(() => selectedTechnician = val!),
              decoration: const InputDecoration(
                labelText: "Filter by Technician",
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: filteredRequests.isEmpty
                ? const Center(child: Text("No matching requests"))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredRequests.length,
                    itemBuilder: (context, index) {
                      final request = filteredRequests[index];
                      return Card(
                        color: getStatusColor(request['status']),
                        margin: const EdgeInsets.only(bottom: 16),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text("Booking ID: ${request['id']}"),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Customer: ${request['customer']}"),
                              Text("Date: ${request['date']}"),
                              Text("Status: ${request['status']}"),
                              Text(
                                "Technician: ${request['technician'] ?? "Not Assigned"}",
                              ),
                            ],
                          ),
                          trailing: ElevatedButton(
                            onPressed: () =>
                                showTechnicianPicker(request['id']),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade800,
                            ),
                            child: const Text(
                              "Assign",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    BookingDetailScreen(request: request),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class BookingDetailScreen extends StatelessWidget {
  final Map<String, dynamic> request;
  const BookingDetailScreen({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Booking Details: ${request['id']}"),
        backgroundColor: Colors.blue.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Customer Name: ${request['customer']}",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text("Date: ${request['date']}"),
                const SizedBox(height: 8),
                Text("Status: ${request['status']}"),
                const SizedBox(height: 8),
                Text("Technician: ${request['technician'] ?? "Not Assigned"}"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
