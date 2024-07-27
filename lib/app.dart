import 'package:flutter/material.dart';
import 'package:scentography/features/navigation/screens/navigation.dart';
import 'package:scentography/utils/theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const SNavigation(),
      themeMode: ThemeMode.system,
      theme: SAppTheme.lightTheme,
      darkTheme: SAppTheme.darkTheme,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'This is the light theme',
              style: TextStyle(),
            ),
            const SizedBox(height: 20),
            const Text('This is the dark theme'),
          ],
        ),
      ),
    );
  }
}
