// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// import 'screens/technician_home_screen.dart';

// final technicianRoutes = [
//   GoRoute(
//     path: '/technician/home',
//     name: 'technician-home',
//     builder: (context, state) => const TechnicianHomeScreen(),
//   ),
//   GoRoute(
//     path: '/technician/assigned',
//     name: 'assigned-jobs',
//     builder: (context, state) => const AssignedJobsScreen(),
//   ),
//   GoRoute(
//     path: '/technician/booking/:id',
//     name: 'booking-detail',
//     builder: (context, state) {
//       final bookingId = int.tryParse(state.pathParameters['id'] ?? '');
//       if (bookingId == null) {
//         return const Scaffold(body: Center(child: Text("Invalid booking ID")));
//       }
//       return BookingDetailScreen(bookingId: bookingId);
//     },
//   ),
//   GoRoute(
//     path: '/technician/report/:id',
//     name: 'submit-report',
//     builder: (context, state) {
//       final bookingId = int.tryParse(state.pathParameters['id'] ?? '');
//       if (bookingId == null) {
//         return const Scaffold(body: Center(child: Text("Invalid booking ID")));
//       }
//       return ReportScreen(bookingId: bookingId);
//     },
//   ),
// ];
