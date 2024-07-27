import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '../../../app.dart';
import '../../home_page/screens/home_screen.dart';
import '../providers/navigation_provider.dart';

class SNavigation extends ConsumerWidget {
  const SNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(navigationProvider);
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        height: 80,
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          ref.read(navigationProvider.notifier).setIndex(index);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Iconsax.home), label: "Home"),
          NavigationDestination(
              icon: Icon(Icons.library_books), label: "Library"),
          NavigationDestination(
              icon: Icon(Icons.computer), label: "Consultant"),
          NavigationDestination(icon: Icon(Iconsax.people), label: "Forum"),
        ],
      ),
      body: SScreens.screens[selectedIndex],
    );
  }
}

class SScreens {
  static final screens = [HomeScreen()];
}
