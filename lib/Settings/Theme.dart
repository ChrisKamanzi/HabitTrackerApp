import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/them_provider.dart';

class ThemePage extends ConsumerWidget {
  const ThemePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Theme Switcher")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Choose Theme",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {

                ref.read(themeProvider.notifier).toggleTheme(false);
              },
              child: const Text("Bright Mode"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                print("Toggling Dark Mode");
                ref.read(themeProvider.notifier).toggleTheme(true);
              },
              child: const Text("Dark Mode"),
            ),
          ],
        ),
      ),
    );
  }
}
