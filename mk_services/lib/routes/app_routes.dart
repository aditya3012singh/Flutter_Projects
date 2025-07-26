import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Auth Screens
import 'package:mk_services/features/auth/screens/login_screen.dart';
import 'package:mk_services/features/auth/screens/signup_Screen.dart';
import 'package:mk_services/features/auth/screens/splash_screen.dart';

// Technician Screens
import 'package:mk_services/features/home/screens/technician_home_screen.dart';

// User Screens
import 'package:mk_services/features/home/screens/welcome_page.dart';
import 'package:mk_services/features/home/screens/user_main_screen.dart';
import 'package:mk_services/features/home/screens/my_product_screen.dart';
import 'package:mk_services/features/home/screens/request_installation_screen.dart';
import 'package:mk_services/features/home/screens/service_request_screen.dart';
import 'package:mk_services/features/home/screens/service_history_screen.dart';
import 'package:mk_services/features/home/screens/contact_us_screen.dart';
import 'package:mk_services/features/home/screens/managed_address_screen.dart';
import 'package:mk_services/features/home/screens/spare_parts_Screen.dart';
import 'package:mk_services/features/home/screens/update_profile_screen.dart';

// Admin Screens
import 'package:mk_services/features/admin/screens/admin_home_screen.dart';
import 'package:mk_services/features/admin/screens/customer_list_screen.dart';
import 'package:mk_services/features/admin/screens/dashboard_screen.dart';
import 'package:mk_services/features/admin/screens/product_list_screen.dart';
import 'package:mk_services/features/admin/screens/reports_screen.dart';
import 'package:mk_services/features/admin/screens/service_request_screen.dart';
import 'package:mk_services/features/admin/screens/stock_managemenr_Screen.dart';
import 'package:mk_services/features/admin/screens/technician_list_screen.dart';
import 'package:mk_services/features/technician/screens/cutomer_Service_history.dart';
import 'package:mk_services/features/technician/screens/due_service_list_screen.dart';
import 'package:mk_services/features/technician/screens/export_reports_screen.dart';
import 'package:mk_services/features/technician/screens/new_service_entry_screen.dart';
import 'package:mk_services/features/technician/screens/provider_dashboard_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/provider/dashboard',
    routes: [
      // 🔐 Auth Routes
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(path: '/home', builder: (context, state) => const WelcomePage()),

      // 👤 User Routes
      GoRoute(
        path: '/user/main',
        builder: (context, state) => const UserMainScreen(),
      ),
      GoRoute(
        path: '/booking/domestic',
        builder: (context, state) => const RequestInstallationScreen(),
      ),
      GoRoute(
        path: '/booking/industrial',
        builder: (context, state) => const ServiceRequestScreen(),
      ),
      GoRoute(
        path: '/user/my-product',
        builder: (context, state) => const MyProductScreen(),
      ),
      GoRoute(
        path: '/user/service-history',
        builder: (context, state) => const ServiceHistoryScreen(),
      ),
      GoRoute(
        path: '/user/update-profile',
        builder: (context, state) => const UpdateProfileScreen(),
      ),
      GoRoute(
        path: '/user/manage-address',
        builder: (context, state) => const ManageAddressScreen(),
      ),
      GoRoute(
        path: '/user/contact',
        builder: (context, state) => const ContactUsScreen(),
      ),
      GoRoute(
        path: '/user/spare-parts',
        builder: (context, state) => const SparePartsScreen(),
      ),

      // 🛠️ Technician Routes
      GoRoute(
        path: '/technician/home',
        builder: (context, state) => const TechnicianHomeScreen(),
      ),

      // 🧑‍💼 Admin Routes
      GoRoute(
        path: '/admin/home',
        builder: (context, state) => const AdminHomeScreen(),
      ),
      GoRoute(
        path: '/admin/dashboard',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: '/admin/customers',
        builder: (context, state) => const AllCustomersScreen(),
      ),
      GoRoute(
        path: '/admin/technicians',
        builder: (context, state) => const AllProvidersScreen(),
      ),
      GoRoute(
        path: '/admin/products',
        builder: (context, state) => const AdminProductListScreen(),
      ),
      GoRoute(
        path: '/admin/stock',
        builder: (context, state) => const StockManagementScreen(),
      ),
      GoRoute(
        path: '/admin/reports',
        builder: (context, state) => const ReportsScreen(),
      ),
      GoRoute(
        path: '/admin/requests',
        builder: (context, state) => const ServiceRequestScreentwo(),
      ),
      // 👨‍🔧 Provider Routes
      GoRoute(
        path: '/provider/new-entry',
        builder: (context, state) => const NewServiceEntryScreen(),
      ),
      GoRoute(
        path: '/provider/stock',
        builder: (context, state) => const StockManagementScreen(),
      ),
      GoRoute(
        path: '/provider/history',
        builder: (context, state) => const CustomerServiceHistoryScreen(),
      ),
      GoRoute(
        path: '/provider/due-services',
        builder: (context, state) => const DueServiceListScreen(),
      ),
      GoRoute(
        path: '/provider/reports',
        builder: (context, state) => const ExportReportsScreen(),
      ),
      GoRoute(
        path: '/provider/dashboard',
        builder: (context, state) => const ProviderDashboardScreen(),
      ),
    ],
    errorBuilder: (context, state) => const NotFoundPage(),
  );
});

// 🔴 404 Page
class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('404')),
      body: const Center(child: Text('Page Not Found')),
    );
  }
}
