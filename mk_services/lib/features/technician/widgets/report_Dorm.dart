// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:mk_services/core/services/api_service.dart';
// import 'package:mk_services/core/widgets/primary_button.dart';
// import 'package:mk_services/core/utils/helpers.dart';

// class ReportScreen extends ConsumerStatefulWidget {
//   final int bookingId;

//   const ReportScreen({super.key, required this.bookingId});

//   @override
//   ConsumerState<ReportScreen> createState() => _ReportScreenState();
// }

// class _ReportScreenState extends ConsumerState<ReportScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _reportController = TextEditingController();
//   final TextEditingController _partsUsedController = TextEditingController();

//   bool _isSubmitting = false;

//   Future<void> _submitReport() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => _isSubmitting = true);

//     final response = await ref.read(apiServiceProvider).post(
//       '/report',
//       body: {
//         'bookingId': widget.bookingId,
//         'report': _reportController.text.trim(),
//         'partsUsed': _partsUsedController.text.trim(),
//       },
//     );

//     setState(() => _isSubmittsing_
