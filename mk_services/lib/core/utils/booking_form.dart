// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart'; // ✅ Un-comment this
// import '../../../core/utils/validators.dart';
// import '../../../core/utils/helpers.dart';

// class BookingForm extends StatefulWidget {
//   final void Function(String serviceType, DateTime serviceDate, String remarks)
//   onSubmit;

//   const BookingForm({super.key, required this.onSubmit});

//   @override
//   State<BookingForm> createState() => _BookingFormState();
// }

// class _BookingFormState extends State<BookingForm> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _serviceDateController = TextEditingController();
//   String? _serviceType;
//   DateTime? _selectedDate;
//   String? _remarks;

//   final List<String> _serviceTypes = ['INSTALLATION', 'REPAIR', 'MAINTENANCE'];

//   @override
//   void dispose() {
//     _serviceDateController.dispose();
//     super.dispose();
//   }

//   void _submitForm() {
//     if (_formKey.currentState!.validate() &&
//         _selectedDate != null &&
//         _serviceType != null) {
//       _formKey.currentState!.save();
//       widget.onSubmit(_serviceType!, _selectedDate!, _remarks ?? '');
//     }
//   }

//   Future<void> _pickDate() async {
//     final now = DateTime.now();
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: now,
//       firstDate: now,
//       lastDate: now.add(const Duration(days: 180)),
//     );

//     if (picked != null) {
//       setState(() {
//         _selectedDate = picked;
//         _serviceDateController.text = DateFormat(
//           'yyyy-MM-dd',
//         ).format(picked); // ✅ uses intl
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: Column(
//         children: [
//           DropdownButtonFormField<String>(
//             value: _serviceType,
//             decoration: const InputDecoration(labelText: 'Service Type'),
//             items: _serviceTypes
//                 .map(
//                   (type) => DropdownMenuItem(
//                     value: type,
//                     child: Text(capitalize(type)),
//                   ),
//                 )
//                 .toList(),
//             onChanged: (value) {
//               setState(() => _serviceType = value);
//             },
//             validator: validateRequired,
//           ),
//           TextFormField(
//             controller: _serviceDateController,
//             readOnly: true,
//             decoration: const InputDecoration(labelText: 'Service Date'),
//             onTap: _pickDate,
//             validator: validateRequired,
//           ),
//           TextFormField(
//             decoration: const InputDecoration(labelText: 'Remarks (optional)'),
//             onSaved: (val) => _remarks = val,
//           ),
//           const SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: _submitForm,
//             child: const Text('Submit Booking'),
//           ),
//         ],
//       ),
//     );
//   }
// }
