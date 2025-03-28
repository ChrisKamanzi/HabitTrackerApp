import 'package:flutter/material.dart';
import 'package:new_application/Progress/progress_page.dart';
import 'package:new_application/Settings/Settings_page.dart';
import 'package:new_application/authentication/login.dart';
import 'package:new_application/providers/them_provider.dart';
import 'Home/home.dart';
import 'authentication/sign_up.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'providers/everyday_provider.dart';
import 'providers/username_provider.dart';
import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => EverydayProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter _router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) {
            return login();
          },
        ),
        GoRoute(
          path: '/homepage',
          builder: (BuildContext context, GoRouterState state) {
            return homepage(); // Your homepage screen
          },
        ),
        GoRoute(
          path: '/progress',
          builder: (BuildContext context, GoRouterState state) {
            return progresss(); // Your homepage screen
          },
        ),
        GoRoute(
          path: '/settings',
          builder: (BuildContext context, GoRouterState state) {
            return settings(); // Your homepage screen
          },
        ),
        GoRoute(
          path: '/signUp',
          builder: (BuildContext context, GoRouterState state) {
            return sign_up(); // Your sign-up screen
          },
        ),
      ],
    );

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp.router(
          routerConfig: _router,
          themeMode: themeProvider.themeMode,
          theme: themeProvider.lightTheme,
          darkTheme: themeProvider.darkTheme,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
