class ApiConstants {
  // Base URL (adjust based on environment)
  static const String baseUrl =
      "http://10.0.2.2:3000"; // Use 3000 if your backend runs on port 3000

  // Auth
  static const String signup = "$baseUrl/api/auth/signup";
  static const String signin = "$baseUrl/api/auth/signin";
  static const String sendOtp = "$baseUrl/api/auth/generate-otp";
  static const String verifyOtp = "$baseUrl/api/auth/verify-otp";
  static const String updateProfile = "$baseUrl/api/auth/update-profile";
  static const String deleteUser = "$baseUrl/api/auth/user";
  static const String getUsers = "$baseUrl/api/auth/users";
  static const String checkAdmin = "$baseUrl/api/auth/check-admin";
  static const String checkUser = "$baseUrl/api/auth/check-user";
  static const String me = "$baseUrl/api/auth/me";

  // Technicians
  static const String getTechnicians = "$baseUrl/api/technicians";
  static String getTechnician(String id) => "$baseUrl/api/technicians/$id";
  static const String createTechnician = "$baseUrl/api/technicians";
  static String updateTechnician(String id) => "$baseUrl/api/technicians/$id";
  static String deleteTechnician(String id) => "$baseUrl/api/technicians/$id";
  static const String myTechnicianProfile = "$baseUrl/api/technicians/me";
  static const String myBookings = "$baseUrl/api/technicians/me/bookings";
  static const String technicianStats = "$baseUrl/api/technicians/me/stats";

  // Bookings
  static const String createBooking = "$baseUrl/api/bookings";
  static const String getAllBookings = "$baseUrl/api/bookings";
  static const String getMyBookings = "$baseUrl/api/bookings/my";
  static String getBookingById(String id) => "$baseUrl/api/bookings/$id";
  static String assignTechnician(String id) =>
      "$baseUrl/api/bookings/$id/assign";
  static String updateBookingStatus(String id) =>
      "$baseUrl/api/bookings/$id/status";
  static String addReport(String id) => "$baseUrl/api/bookings/$id/report";
  static String addPartsToBooking(String id) =>
      "$baseUrl/api/bookings/$id/parts";

  // Reports
  static const String createReport = "$baseUrl/api/reports";
  static const String getReports = "$baseUrl/api/reports";
  static String getReportByBookingId(String bookingId) =>
      "$baseUrl/api/reports/$bookingId";

  // Stock
  static const String getStock = "$baseUrl/api/stock";
  static String addStock(String partId) => "$baseUrl/api/stock/$partId/add";
  static String reduceStock(String partId) =>
      "$baseUrl/api/stock/$partId/reduce";

  // Purchase
  static const String addPurchase = "$baseUrl/api/purchase";
  // static const String getPurchases = "$baseUrl/api/purchase"; // Uncomment when implemented

  // History
  static const String searchHistory = "$baseUrl/api/history";

  // Due Services
  static const String getDueServices = "$baseUrl/api/due-services";

  // Dashboard (Admin)
  static const String getDashboardSummary = "$baseUrl/api/dashboard";

  static String getProfile = "$baseUrl/api/users/me";
}
