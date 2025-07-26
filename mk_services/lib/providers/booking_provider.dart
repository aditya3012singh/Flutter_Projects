// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:mk_services/core/models/booking_model.dart';
// import 'package:mk_services/core/services/api_service.dart';

// final bookingProvider =
//     StateNotifierProvider<BookingNotifier, AsyncValue<List<BookingModel>>>(
//       (ref) => BookingNotifier(),
//     );

// class BookingNotifier extends StateNotifier<AsyncValue<List<BookingModel>>> {
//   BookingNotifier() : super(const AsyncValue.loading()) {
//     fetchBookings();
//   }

//   Future<void> fetchBookings() async {
//     try {
//       state = const AsyncValue.loading();
//       final bookings = await ApiService.fetchUserBookings();
//       state = AsyncValue.data(bookings);
//     } catch (e, st) {
//       state = AsyncValue.error(e, st);
//     }
//   }

//   Future<bool> createBooking({
//     required String serviceType,
//     required DateTime serviceDate,
//     String? remarks,
//   }) async {
//     try {
//       final newBooking = await ApiService.createBooking(
//         serviceType: serviceType,
//         serviceDate: serviceDate,
//         remarks: remarks,
//       );

//       // Add newly created booking to state
//       state = state.whenData((bookings) => [newBooking, ...bookings]);
//       return true;
//     } catch (e) {
//       return false;
//     }
//   }

//   Future<void> refresh() async {
//     await fetchBookings();
//   }
// }
