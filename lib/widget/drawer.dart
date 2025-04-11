import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/weather_provider.dart';

class AppDrawer extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(weatherProvider);

    return Drawer(
      child: Column(
        children: [
          const SizedBox(height: 50),

          weatherAsync.when(
            data: (weather) {
              final temp = weather['current']['temp_c'];
              final condition = weather['current']['condition']['text'];
              final iconUrl = 'https:${weather['current']['condition']['icon']}';

              return Column(
                children: [
                  Image.network(iconUrl, width: 50),
                  Text('Rwanda: $temp°C', style: TextStyle(fontSize: 18)),
                  Text(condition, style: TextStyle(fontSize: 16)),
                ],
              );
            },
            loading: () => CircularProgressIndicator(),
            error: (err, _) => Text('Failed to load weather'),
          ),

          const SizedBox(height: 20),

          TextButton(
            onPressed: () async {
              final FirebaseAuth _auth = FirebaseAuth.instance;
              await _auth.signOut();
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isLoggedIn', false);
              await prefs.remove('email');
              context.go('/login');
            },
            child: Text('Logout'),
          ),

        ],
      ),
    );
  }
}
