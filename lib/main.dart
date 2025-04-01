import 'package:flutter/material.dart';
import 'package:new_application/Progress/progress_page.dart';
import 'package:new_application/Settings/Settings_page.dart';
import 'package:new_application/authentication/login.dart';
import 'package:new_application/Home/home.dart';
import 'package:new_application/authentication/sign_up.dart';
import 'package:new_application/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:new_application/providers/them_provider.dart';
import 'package:new_application/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ProviderScope(
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final themeMode = ref.watch(themeProvider);
    return MaterialApp.router(
      routerConfig: _router,
      themeMode: themeMode,
      theme: ref.watch(themeProvider.notifier).lightTheme,
      darkTheme: ref.watch(themeProvider.notifier).darkTheme,
      debugShowCheckedModeBanner: false,
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (BuildContext context, GoRouterState state) {
        return SplashScreen();
      },
    ),
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return login();
      },
    ),
    GoRoute(
      path: '/homepage',
      builder: (BuildContext context, GoRouterState state) {
        return homepage();
      },
    ),
    GoRoute(
      path: '/progress',
      builder: (BuildContext context, GoRouterState state) {
        return progresss();
      },
    ),
    GoRoute(
      path: '/settings',
      builder: (BuildContext context, GoRouterState state) {
        return settings();
      },
    ),
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return login();
      },
    ),
    GoRoute(
      path: '/signUp',
      builder: (BuildContext context, GoRouterState state) {
        return sign_up();
      },
    ),
  ],
);

