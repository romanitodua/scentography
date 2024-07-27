import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scentography/features/navigation/screens/navigation.dart';
import 'package:scentography/utils/theme/theme.dart';

import 'common/models/fragrance.dart';
import 'data/providers.dart';
import 'data/repositories/firestore.dart';

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

