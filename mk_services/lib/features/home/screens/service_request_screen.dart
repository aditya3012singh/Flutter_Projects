import 'package:flutter/material.dart';
import 'package:mk_services/core/services/api_service.dart';
import 'package:intl/intl.dart';

class ServiceRequestScreen extends StatefulWidget {
  const ServiceRequestScreen({super.key});

  @override
  State<ServiceRequestScreen> createState() => _ServiceRequestScreenState();
}

class _ServiceRequestScreenState extends State<ServiceRequestScreen> {
  final ApiService _api = ApiService();

  void _showServiceDialog(BuildContext context, String type) {
    final descController = TextEditingController();
    DateTime? selectedDate;

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            return AlertDialog(
              title: Text('$type Request'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: descController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Describe your issue',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.calendar_today),
                    title: Text(
                      selectedDate == null
                          ? "Select Service Date"
                          : DateFormat('dd/MM/yyyy').format(selectedDate!),
                    ),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 30)),
                        initialDate: DateTime.now(),
                      );
                      if (picked != null) setState(() => selectedDate = picked);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (selectedDate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Select a date")),
                      );
                      return;
                    }
                    Navigator.pop(context);

                    final success = await _api.createBooking(
                      serviceType: type,
                      serviceDate: selectedDate!,
                      remarks: descController.text,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          success
                              ? "$type request submitted"
                              : "Submission failed",
                        ),
                        backgroundColor: success ? Colors.green : Colors.red,
                      ),
                    );
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
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Service Request",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Choose a Service Type",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildServiceCard(
              icon: Icons.build,
              label: 'Repair Service',
              onTap: () => _showServiceDialog(context, 'REPAIR'),
            ),
            const SizedBox(height: 16),
            _buildServiceCard(
              icon: Icons.cleaning_services,
              label: 'Maintenance Service',
              onTap: () => _showServiceDialog(context, 'MAINTENANCE'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue.shade900, size: 28),
        title: Text(label, style: const TextStyle(fontSize: 16)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
