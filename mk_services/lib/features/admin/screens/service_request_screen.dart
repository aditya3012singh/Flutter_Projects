import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
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
      final techs = await _api.getTechnicians();

      setState(() {
        bookings = allBookings;
        technicians = techs;
      });
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error loading data: $e',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> assignTechnician(String bookingId, String techId) async {
    final success = await _api.assignTechnician(bookingId, techId);
    Fluttertoast.showToast(
      msg: success ? "Technician assigned successfully" : "Assignment failed",
      backgroundColor: success ? Colors.green : Colors.red,
      textColor: Colors.white,
    );
    if (success) await fetchData();
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
      filtered = filtered.where((b) {
        final id = (b['id'] ?? '').toLowerCase();
        final customer = (b['user']?['name'] ?? '').toLowerCase();
        return id.contains(searchQuery.toLowerCase()) ||
            customer.contains(searchQuery.toLowerCase());
      }).toList();
    }
    filtered.sort((a, b) {
      return sortBy == 'Date'
          ? (b['createdAt'] ?? '').compareTo(a['createdAt'] ?? '')
          : (a['user']?['name'] ?? '').compareTo(b['user']?['name'] ?? '');
    });
    return filtered;
  }

  Widget _buildShimmerLoader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView.builder(
        itemCount: 6,
        itemBuilder: (_, index) => Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Service Requests",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade900,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.download, color: Colors.white),
            onPressed: () => _api.exportBookingsCSV(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showRequestFormDialog(context),
        backgroundColor: Colors.blue.shade900,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("New Request", style: TextStyle(color: Colors.white)),
      ),
      body: RefreshIndicator(
        onRefresh: fetchData,
        child: loading
            ? _buildShimmerLoader()
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
                              final remarks = b['remarks'] ?? '';

                              final addressMatch = RegExp(
                                r'Address:\s*([^,]+)',
                              ).firstMatch(remarks);
                              final phoneMatch = RegExp(
                                r'Phone:\s*([^,]+)',
                              ).firstMatch(remarks);

                              final address = addressMatch != null
                                  ? addressMatch.group(1)
                                  : 'Unknown';
                              final phone = phoneMatch != null
                                  ? phoneMatch.group(1)
                                  : 'N/A';
                              final technicianName =
                                  b['technician']?['name'] ?? 'Not Assigned';

                              return Card(
                                color: Colors.white,
                                elevation: 4,
                                margin: const EdgeInsets.only(bottom: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        b['user']?['name'] ?? 'Customer',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text("📍 Address: $address"),
                                      Text("📞 Phone: $phone"),
                                      Text("🆔 Booking ID: ${b['id']}"),
                                      Text("⚙️ Status: ${b['status']}"),
                                      Text("👨‍🔧 Technician: $technicianName"),
                                      const SizedBox(height: 12),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: b['status'] == 'IN_PROGRESS'
                                            ? Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      final success = await _api
                                                          .updateBookingStatus(
                                                            b['id'],
                                                            'COMPLETED',
                                                          );
                                                      Fluttertoast.showToast(
                                                        msg: success
                                                            ? "Marked as COMPLETED"
                                                            : "Failed to update status",
                                                        backgroundColor: success
                                                            ? Colors.green
                                                            : Colors.red,
                                                        textColor: Colors.white,
                                                      );
                                                      if (success)
                                                        await fetchData();
                                                    },
                                                    style:
                                                        ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors
                                                                  .green
                                                                  .shade700,
                                                        ),
                                                    child: const Text(
                                                      "Mark Completed",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 14,
                                                          vertical: 8,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: Colors
                                                          .orange
                                                          .shade700,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                    ),
                                                    child: const Text(
                                                      'In Progress',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : b['status'] == 'COMPLETED'
                                            ? const SizedBox()
                                            : ElevatedButton(
                                                onPressed: () =>
                                                    showTechnicianPicker(
                                                      b['id'],
                                                    ),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.blue.shade700,
                                                ),
                                                child: const Text(
                                                  "Assign Technician",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
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
                ],
              ),
      ),
    );
  }

  void showTechnicianPicker(String bookingId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text("Assign Technician"),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: technicians.length,
            itemBuilder: (_, i) {
              final tech = technicians[i];
              return ListTile(
                title: Text(tech['name']),
                onTap: () {
                  Navigator.pop(context);
                  assignTechnician(bookingId, tech['id']);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showRequestFormDialog(BuildContext context) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final addressController = TextEditingController();
    final problemController = TextEditingController();
    String selectedServiceType = 'INSTALLATION';
    DateTime? selectedDate;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            backgroundColor: Colors.white,
            title: const Text("New Service Request"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Full Name'),
                  ),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                    ),
                  ),
                  TextField(
                    controller: addressController,
                    maxLines: 2,
                    decoration: const InputDecoration(labelText: 'Address'),
                  ),
                  DropdownButtonFormField<String>(
                    dropdownColor: Colors.white,
                    value: selectedServiceType,
                    decoration: const InputDecoration(
                      labelText: 'Service Type',
                    ),
                    items: ['INSTALLATION', 'REPAIR', 'MAINTENANCE']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null)
                        setState(() => selectedServiceType = val);
                    },
                  ),
                  TextField(
                    controller: problemController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Problem Description',
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: Text(
                      selectedDate == null
                          ? "Select Service Date"
                          : DateFormat('dd/MM/yyyy').format(selectedDate!),
                    ),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 30)),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              dialogBackgroundColor: Colors.white,
                              colorScheme: ColorScheme.light(
                                primary: Colors
                                    .blue
                                    .shade900, // Header & selected date
                                onPrimary:
                                    Colors.white, // Text on selected date
                                onSurface: Colors.black, // Default text color
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  foregroundColor:
                                      Colors.blue.shade900, // Button text color
                                ),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        setState(() => selectedDate = picked);
                      }
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (selectedDate == null) {
                    Fluttertoast.showToast(
                      msg: "Select a date",
                      backgroundColor: Colors.orange,
                    );
                    return;
                  }

                  final success = await _api.createBooking(
                    serviceType: selectedServiceType,
                    serviceDate: selectedDate!,
                    remarks:
                        "Name: ${nameController.text}, Phone: ${phoneController.text}, Address: ${addressController.text}, Problem: ${problemController.text}",
                  );

                  Fluttertoast.showToast(
                    msg: success ? "Request submitted" : "Submission failed",
                    backgroundColor: success ? Colors.green : Colors.red,
                  );

                  if (success) {
                    Navigator.pop(context);
                    await fetchData();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade900,
                ),
                child: const Text(
                  "Submit",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
