import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:scentography/firebase_options.dart';
import 'app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
