import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mk_services/core/services/api_service.dart';

class RequestInstallationScreen extends StatefulWidget {
  const RequestInstallationScreen({super.key});

  @override
  State<RequestInstallationScreen> createState() =>
      _RequestInstallationScreenState();
}

class _RequestInstallationScreenState extends State<RequestInstallationScreen> {
  final ApiService _api = ApiService();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  DateTime? selectedDate;

  void submit() async {
    if (selectedDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select a date")));
      return;
    }

    final success = await _api.createBooking(
      serviceType: 'INSTALLATION',
      serviceDate: selectedDate!,
      remarks:
          "Name: ${nameController.text}, Phone: ${phoneController.text}, Address: ${addressController.text}",
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? "Installation request submitted" : "Submission failed",
        ),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Request Installation & Services",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade900,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text(
              "Installation & Service Request Form",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: addressController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Your Address',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today),
              title: Text(
                selectedDate == null
                    ? "Select Installation Date"
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
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade900,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                "Submit Request",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
