import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/them_provider.dart';

class ThemePage extends StatelessWidget {
  const ThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

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
                themeProvider.toggleTheme(false);
              },
              child: const Text("Bright Mode"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                themeProvider.toggleTheme(true); // Switch to Dark Mode
              },
              child: const Text("Dark Mode"),
            ),
          ],
        ),
      ),
    );
  }
}
