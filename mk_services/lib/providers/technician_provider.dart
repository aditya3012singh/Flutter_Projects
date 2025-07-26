// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:mk_services/core/models/booking_model.dart';
// import 'package:mk_services/core/models/technician_model.dart';
// import 'package:mk_services/core/services/api_service.dart';

// final technicianProfileProvider =
//     StateNotifierProvider<
//       TechnicianProfileNotifier,
//       AsyncValue<TechnicianModel>
//     >((ref) => TechnicianProfileNotifier());

// class TechnicianProfileNotifier
//     extends StateNotifier<AsyncValue<TechnicianModel>> {
//   TechnicianProfileNotifier() : super(const AsyncValue.loading()) {
//     fetchProfile();
//   }

//   Future<void> fetchProfile() async {
//     try {
//       final profile = await ApiService.getTechnicianProfile();
//       state = AsyncValue.data(profile);
//     } catch (e, st) {
//       state = AsyncValue.error(e, st);
//     }
//   }

//   Future<void> refresh() async => fetchProfile();
// }

// final technicianBookingsProvider =
//     StateNotifierProvider<
//       TechnicianBookingsNotifier,
//       AsyncValue<List<BookingModel>>
//     >((ref) => TechnicianBookingsNotifier());

// class TechnicianBookingsNotifier
//     extends StateNotifier<AsyncValue<List<BookingModel>>> {
//   TechnicianBookingsNotifier() : super(const AsyncValue.loading()) {
//     fetchAssignedBookings();
//   }

//   Future<void> fetchAssignedBookings() async {
//     try {
//       final bookings = await ApiService.getTechnicianBookings();
//       state = AsyncValue.data(bookings);
//     } catch (e, st) {
//       state = AsyncValue.error(e, st);
//     }
//   }

//   Future<void> refresh() async => fetchAssignedBookings();
// }
