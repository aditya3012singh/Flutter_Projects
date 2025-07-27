import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mk_services/providers/auth_provider.dart';

// Screens
import 'package:mk_services/features/auth/screens/login_screen.dart';
import 'package:mk_services/features/auth/screens/signup_Screen.dart';
import 'package:mk_services/features/auth/screens/splash_screen.dart';
import 'package:mk_services/features/home/screens/welcome_page.dart';
import 'package:mk_services/features/home/screens/user_main_screen.dart';
import 'package:mk_services/features/home/screens/request_installation_screen.dart';
import 'package:mk_services/features/home/screens/service_request_screen.dart';
import 'package:mk_services/features/home/screens/service_history_screen.dart';
import 'package:mk_services/features/home/screens/contact_us_screen.dart';
import 'package:mk_services/features/home/screens/managed_address_screen.dart';
import 'package:mk_services/features/home/screens/spare_parts_Screen.dart';
import 'package:mk_services/features/home/screens/update_profile_screen.dart';
import 'package:mk_services/features/admin/screens/admin_home_screen.dart';
import 'package:mk_services/features/admin/screens/customer_list_screen.dart';
import 'package:mk_services/features/admin/screens/product_list_screen.dart';
import 'package:mk_services/features/admin/screens/reports_screen.dart';
import 'package:mk_services/features/admin/screens/service_request_screen.dart';
import 'package:mk_services/features/admin/screens/stock_managemenr_Screen.dart';
import 'package:mk_services/features/admin/screens/technician_list_screen.dart';
import 'package:mk_services/features/technician/screens/due_service_list_screen.dart';
import 'package:mk_services/features/technician/screens/new_service_entry_screen.dart';
import 'package:mk_services/features/technician/screens/provider_dashboard_screen.dart';
import 'package:mk_services/features/home/screens/technician_home_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/', // Start at splash
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final isLoading = authState.isLoading;
      final user = authState.value;

      final location = state.uri.toString();
      final isAuthPage = location == '/login' || location == '/signup';

      // Stay on splash while loading
      if (isLoading) return null;

      // Handle backend/auth errors
      if (authState.hasError) {
        return '/login';
      }

      // Not logged in → send to login (unless already on login/signup/splash)
      if (user == null && !isAuthPage && location != '/') {
        return '/login';
      }

      // Logged in but trying to access login/signup → send to dashboard based on role
      if (user != null && isAuthPage) {
        final role = user.role?.toLowerCase() ?? '';
        if (role == 'admin') return '/admin/home';
        if (role == 'technician') return '/provider/dashboard';
        return '/user/main';
      }

      // Logged in and on splash/root → send to correct dashboard
      if (user != null && (location == '/' || location == '/home')) {
        final role = user.role?.toLowerCase() ?? '';
        if (role == 'admin') return '/admin/home';
        if (role == 'provider') return '/provider/dashboard';
        return '/user/main';
      }

      return null; // No redirect
    },

    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),

      // Auth
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),

      // User
      GoRoute(path: '/home', builder: (context, state) => const WelcomePage()),
      GoRoute(
        path: '/user/main',
        builder: (context, state) => const UserMainScreen(),
      ),
      // GoRoute(
      //   path: '/user/my-product',
      //   builder: (context, state) => const MyProductScreen(),
      // ),
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

      // Bookings
      GoRoute(
        path: '/booking/domestic',
        builder: (context, state) => const RequestInstallationScreen(),
      ),
      GoRoute(
        path: '/booking/industrial',
        builder: (context, state) => const ServiceRequestScreen(),
      ),

      // Provider
      GoRoute(
        path: '/technician/home',
        builder: (context, state) => const TechnicianHomeScreen(),
      ),
      GoRoute(
        path: '/provider/dashboard',
        builder: (context, state) => const ProviderDashboardScreen(),
      ),
      GoRoute(
        path: '/provider/new-entry',
        builder: (context, state) => const NewServiceEntryScreen(),
      ),
      GoRoute(
        path: '/provider/stock',
        builder: (context, state) => const StockManagementScreen(),
      ),
      GoRoute(
        path: '/provider/due-services',
        builder: (context, state) => const DueServiceListScreen(),
      ),
      // Admin
      GoRoute(
        path: '/admin/home',
        builder: (context, state) => const AdminHomeScreen(),
      ),
      // GoRoute(
      //   path: '/admin/dashboard',
      //   builder: (context, state) => const AdminDashboardScreen(),
      // ),
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
    ],

    errorBuilder: (context, state) =>
        const Scaffold(body: Center(child: Text('404 - Page Not Found'))),
  );
});
