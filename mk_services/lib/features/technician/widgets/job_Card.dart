// import 'package:flutter/material.dart';
// import 'package:mk_services/core/models/booking_model.dart';

// class JobCard extends StatelessWidget {
//   final BookingModel booking;
//   final VoidCallback onTap;

//   const JobCard({super.key, required this.booking, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     final serviceType = booking.serviceType.name.toUpperCase();
//     final status = booking.status.name.replaceAll('_', ' ');

//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         elevation: 3,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         child: Padding(
//           padding: const EdgeInsets.all(14.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 serviceType,
//                 style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                   fontWeight: FontWeight.bold,
//                   color: Theme.of(context).primaryColor,
//                 ),
//               ),
//               const SizedBox(height: 6),
//               Text("Booking ID: ${booking.id}"),
//               const SizedBox(height: 4),
//               Text("Customer: ${booking.userName}"),
//               const SizedBox(height: 4),
//               Text("Location: ${booking.address}"),
//               const SizedBox(height: 4),
//               Text("Status: $status"),
//               const SizedBox(height: 4),
//               Text("Date: ${booking.date}"),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
