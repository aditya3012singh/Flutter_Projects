// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:mk_services/core/services/local_storage.dart';
// import 'package:mk_services/providers/auth_Provider.dart';
// import 'package:mk_services/providers/auth_provider.dart';
// import 'package:mk_services/routes/app_routes.dart';

// class SplashScreen extends ConsumerStatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   ConsumerState<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends ConsumerState<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _navigate();
//   }

//   Future<void> _navigate() async {
//     final auth = ref.read(authProvider.notifier);
//     await auth.checkLogin();

//     final user = ref.read(authProvider).user;

//     if (user == null) {
//       context.go(AppRoutes.login);
//     } else {
//       switch (user.role) {
//         case 'ADMIN':
//           context.go(AppRoutes.adminHome);
//           break;
//         case 'TECHNICIAN':
//           context.go(AppRoutes.technicianHome);
//           break;
//         case 'USER':
//         default:
//           context.go(AppRoutes.userHome);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(child: CircularProgressIndicator()),
//     );
//   }
// }
