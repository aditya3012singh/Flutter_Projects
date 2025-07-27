// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:mk_services/core/services/api_service.dart';
// import 'package:mk_services/core/services/local_storage.dart';
// import 'package:mk_services/providers/auth_provider.dart';
// import 'package:mk_services/routes/app_routes.dart';

// class VerifyOtpScreen extends ConsumerStatefulWidget {
//   final String email;
//   final String name;
//   final String password;
//   final String phone;
//   final String location;

//   const VerifyOtpScreen({
//     super.key,
//     required this.email,
//     required this.name,
//     required this.password,
//     required this.phone,
//     required this.location,
//   });

//   @override
//   ConsumerState<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
// }

// class _VerifyOtpScreenState extends ConsumerState<VerifyOtpScreen> {
//   final TextEditingController _otpController = TextEditingController();
//   bool isLoading = false;
//   String? errorText;

//   Future<void> _verifyOtp() async {
//     setState(() {
//       isLoading = true;
//       errorText = null;
//     });

//     try {
//       final otp = _otpController.text.trim();
//       final verifyResponse = await ApiService.post(
//         '/auth/verify-otp',
//         {'email': widget.email, 'otp': otp},
//       );

//       if (verifyResponse['success'] != true) {
//         setState(() => errorText = 'Invalid OTP');
//         return;
//       }

//       final signupResponse = await ApiService.post('/auth/signup', {
//         'email': widget.email,
//         'name': widget.name,
//         'password': widget.password,
//         'phone': widget.phone,
//         'location': widget.location,
//       });

//       if (signupResponse['token'] != null) {
//         await LocalStorage.saveToken(signupResponse['token']);
//         await ref.read(authProvider.notifier).checkLogin();

//         final role = signupResponse['user']['role'];
//         if (role == 'ADMIN') {
//           context.pushReplacement(AppRoutes.adminHome);
//         } else if (role == 'TECHNICIAN') {
//           context.pushReplacement(AppRoutes.technicianHome);
//         } else {
//           context.pushReplacement(AppRoutes.userHome);
//         }
//       } else {
//         setState(() => errorText = signupResponse['message'] ?? 'Signup failed');
//       }
//     } catch (e) {
//       setState(() => errorText = 'Verification failed');
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Verify OTP')),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Text('Enter the OTP sent to ${widget.email}'),
//             const SizedBox(height: 16),
//             TextField(
//               controller: _otpController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 labelText: 'OTP',
//                 errorText: errorText,
//               ),
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton(
//               onPressed: isLoading ? null : _verifyOtp,
//               child: isLoading
//                   ? const CircularProgressIndicator()
//                   : const Text('Verify & Sign Up'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// // 