import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mk_services/core/services/api_service.dart';

class NewServiceEntryScreen extends StatefulWidget {
  const NewServiceEntryScreen({super.key});

  @override
  State<NewServiceEntryScreen> createState() => _NewServiceEntryScreenState();
}

class _NewServiceEntryScreenState extends State<NewServiceEntryScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  final TextEditingController _receivedAmountController =
      TextEditingController();

  String? _serviceType;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  List<Map<String, dynamic>> _stockItems = [];
  bool _loadingStock = true;
  bool _submitting = false;

  Map<String, int> _selectedParts = {};

  @override
  void initState() {
    super.initState();
    _fetchStockItems();
  }

  Future<void> _fetchStockItems() async {
    try {
      final parts = await ApiService().getAllParts();
      setState(() {
        _stockItems = parts;
        _loadingStock = false;
      });
    } catch (e) {
      print("Error fetching stock: $e");
      setState(() => _loadingStock = false);
    }
  }

  int _calculateTotal() {
    int total = 0;
    _selectedParts.forEach((partName, qty) {
      final item = _stockItems.firstWhere(
        (e) => e['name'] == partName,
        orElse: () => {},
      );
      final unitCost = (item['unitCost'] ?? 0);
      total += (unitCost is num ? unitCost.toInt() : 0) * qty;
    });
    return total;
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: Colors.white, // ⬅️ Sets white background
            colorScheme: ColorScheme.light(
              primary: Colors.blue, // Header color
              onPrimary: Colors.white, // Text color on header
              onSurface: Colors.black, // Body text color
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: _selectedTime,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              dialogBackgroundColor: Colors.white, // ⬅️ Sets white background
              timePickerTheme: const TimePickerThemeData(
                backgroundColor: Colors.white,
              ),
              colorScheme: const ColorScheme.light(
                primary: Colors.blue,
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
            ),
            child: child!,
          );
        },
      );

      if (time != null) {
        setState(() {
          _selectedDate = date;
          _selectedTime = time;
          _dateController.text =
              "${DateFormat('yyyy-MM-dd').format(date)} ${time.format(context)}";
        });
      }
    }
  }

  Future<void> _submitEntry() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);

    try {
      final usedParts = _selectedParts.entries
          .where((e) => (e.value ?? 0) > 0)
          .map((e) {
            final part = _stockItems.firstWhere((p) => p['name'] == e.key);
            return {'id': part['id'], 'quantity': e.value};
          })
          .toList();

      final combinedDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      await ApiService().submitReport(
        customerName: _customerNameController.text.trim(),
        mobileNumber: _mobileController.text.trim(),
        address: _addressController.text.trim(),
        dateTime: combinedDateTime,
        serviceType: _serviceType ?? '',
        partsUsed: usedParts,
        receivedAmount:
            num.tryParse(_receivedAmountController.text.trim()) ??
            0, // 👈 Add this
      );

      for (var part in usedParts) {
        await ApiService().reduceStock(
          part['id'],
          part['quantity'],
          "Used in service",
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Service entry submitted successfully")),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to submit: $e")));
    } finally {
      setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("New RO Service Entry"),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                "Customer Name",
                TextInputType.text,
                controller: _customerNameController,
              ),
              _buildTextField(
                "Mobile Number",
                TextInputType.phone,
                controller: _mobileController,
                validator: (value) {
                  if (value == null || value.length != 10) {
                    return "Enter a valid 10-digit number";
                  }
                  return null;
                },
              ),
              _buildTextField(
                "Address",
                TextInputType.text,
                controller: _addressController,
              ),
              GestureDetector(
                onTap: _pickDateTime,
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _dateController,
                    decoration: const InputDecoration(
                      labelText: "Date & Time",
                      prefixIcon: Icon(Icons.calendar_today),
                      filled: true,
                      fillColor: Colors.white, // 👈 Set background to white
                      border:
                          OutlineInputBorder(), // Optional: add border for better visibility
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                dropdownColor: Colors.white,
                decoration: const InputDecoration(
                  labelText: "Service Type",
                  prefixIcon: Icon(Icons.build),
                ),
                items: ["Installation", "Service", "Installation & Service"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) => _serviceType = value,
                validator: (value) =>
                    value == null ? "Select a service type" : null,
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Parts Used",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _loadingStock
                  ? const Center(child: CircularProgressIndicator())
                  : _stockItems.isEmpty
                  ? const Text("No stock available")
                  : Column(
                      children: _stockItems.map((item) {
                        final name = item['name'] ?? 'Unknown';
                        final unitPrice = (item['unitCost'] ?? 0) as num;
                        final availableQty = (item['quantity'] ?? 0).toInt();
                        final qty = _selectedParts[name] ?? 0;

                        return Card(
                          color: Colors.white,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue.shade100,
                              child: Text(name[0]),
                            ),
                            title: Text(
                              "$name (₹${unitPrice.toInt()})",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              "Available: $availableQty units",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[700],
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: () {
                                    setState(() {
                                      if (qty > 0) {
                                        _selectedParts[name] = qty - 1;
                                      }
                                    });
                                  },
                                ),
                                Text(
                                  qty.toString(),
                                  style: const TextStyle(fontSize: 16),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  onPressed: () {
                                    setState(() {
                                      if (qty < availableQty) {
                                        _selectedParts[name] = qty + 1;
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "Not enough stock available",
                                            ),
                                          ),
                                        );
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total Amount",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "₹${_calculateTotal()}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _receivedAmountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Received Amount",
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter received amount";
                  }
                  final num? parsed = num.tryParse(value);
                  if (parsed == null || parsed < 0) {
                    return "Enter a valid amount";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),
              TextFormField(
                controller: _remarksController,
                decoration: const InputDecoration(
                  labelText: "Service Remarks (optional)",
                  prefixIcon: Icon(Icons.comment),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _submitting ? null : _submitEntry,
                child: _submitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.send, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            "Submit Entry",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextInputType type, {
    FormFieldValidator<String>? validator,
    TextEditingController? controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: type == TextInputType.phone
              ? const Icon(Icons.phone)
              : const Icon(Icons.person),
        ),
        keyboardType: type,
        validator:
            validator ??
            (value) => value!.isEmpty ? "Please enter $label" : null,
      ),
    );
  }
}
