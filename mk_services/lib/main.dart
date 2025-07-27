import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mk_services/providers/auth_provider.dart';
import 'package:mk_services/routes/app_routes.dart';
import 'package:mk_services/storage/local_storage.dart';
import 'package:mk_services/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.init();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final router = ref.watch(goRouterProvider);
    final authState = ref.watch(authProvider);

    if (authState.isLoading) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      );
    }

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'MK Services',
      themeMode: themeMode,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      routerConfig: router,
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
