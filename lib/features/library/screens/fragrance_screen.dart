import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scentography/data/providers.dart';
import 'package:scentography/features/library/screens/rating_screen.dart';
import 'package:scentography/features/library/screens/widgets/chart.dart';
import 'package:scentography/features/library/screens/widgets/info_card.dart';
import 'package:scentography/features/library/screens/widgets/notes.dart';

import '../../../domain/fragrance.dart';

final fragranceProvider = StateProvider<Fragrance?>((ref) => null);

class FragranceScreen extends ConsumerWidget {
  final Fragrance fragrance;

  const FragranceScreen({super.key, required this.fragrance});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(fireStoreRepoProvider);
    final fragranceProvider = StateProvider<Fragrance>((ref) => fragrance);
    final f = ref.watch(fragranceProvider);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      RatingScreen(f.id, fragrance.name)));
          if (result != null) {
            final updatedFragrance = await repo.getFragranceById("fragrances", f.id);
            ref.read(fragranceProvider.notifier).state = updatedFragrance;
          }
        },
        tooltip: "rate",
        child: const Icon(Icons.rate_review),
      ),
      appBar: AppBar(
        actions: [getGenderIcon(f.gender)],
        title: Text("${f.brand} ${f.name}"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            InfoCard(
              fragrance: f,
            ),
            PyramidCard(
              fragrance: f,
            ),
            SizedBox(
              child: ScentBarChart(f.id),
              height: 400,
            )
            // FragrancePyramidCard(),
            // ClassificationCard(),
          ],
        ),
      ),
    );
  }

  Widget getGenderIcon(int gender) {
    switch (gender) {
      case 0:
        return Icon(Icons.transgender);
      case 1:
        return Icon(Icons.male);
      case 2:
        return Icon(Icons.female);
      default:
        return Icon(Icons.help);
    }
  }
}
