import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewServiceEntryScreen extends StatefulWidget {
  const NewServiceEntryScreen({super.key});

  @override
  State<NewServiceEntryScreen> createState() => _NewServiceEntryScreenState();
}

class _NewServiceEntryScreenState extends State<NewServiceEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();

  String? _serviceType;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  List<Map<String, dynamic>> _stockItems = [
    {"name": "Filter", "price": 100},
    {"name": "Membrane", "price": 250},
    {"name": "Pipe", "price": 50},
  ];

  Map<String, int> _selectedParts = {};

  int _calculateTotal() {
    int total = 0;
    _selectedParts.forEach((partName, qty) {
      final item = _stockItems.firstWhere((e) => e['name'] == partName);
      total += (item['price'] as int) * (qty as int);
    });
    return total;
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: _selectedTime,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("New RO Service Entry"),
        elevation: 0,
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField("Customer Name", TextInputType.text),
              _buildTextField(
                "Mobile Number",
                TextInputType.phone,
                validator: (value) {
                  if (value == null || value.length != 10) {
                    return "Enter valid mobile number";
                  }
                  return null;
                },
              ),
              _buildTextField("Address", TextInputType.text),
              GestureDetector(
                onTap: _pickDateTime,
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _dateController,
                    decoration: const InputDecoration(
                      labelText: "Date & Time",
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Service Type",
                  prefixIcon: Icon(Icons.build),
                ),
                items: ["Installation", "Service", "Installation & Service"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) => _serviceType = value,
                validator: (value) =>
                    value == null ? "Please select service type" : null,
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
              ..._stockItems.map((item) {
                int qty = _selectedParts[item['name']] ?? 0;
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade100,
                      child: Text(item['name'][0]),
                    ),
                    title: Text("${item['name']} (₹${item['price']})"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () {
                            setState(() {
                              if (qty > 0)
                                _selectedParts[item['name']] = qty - 1;
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
                              _selectedParts[item['name']] = qty + 1;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
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
                decoration: const InputDecoration(
                  labelText: "Service Remarks",
                  prefixIcon: Icon(Icons.comment),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                icon: const Icon(Icons.send),
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
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // TODO: Send data to backend and reduce stock
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Service Entry Submitted")),
                    );
                  }
                },
                label: const Text(
                  "Submit Entry",
                  style: TextStyle(fontSize: 16),
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
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
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
