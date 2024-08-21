import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:scentography/app.dart';
import 'package:scentography/domain/fragrance.dart';
import 'package:scentography/data/providers.dart';
import 'package:scentography/features/library/screens/fragrance_screen.dart';

import '../providers/search_provider.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(fireStoreRepoProvider);
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(
                'Trending Fragrances',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              IconButton(
                icon: Icon(
                  Icons.search,
                  size: 28,
                ),
                onPressed: () {
                  Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      return SearchWidget();
                    },
                  ));
                },
              )
            ]),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Fragrance>>(
                future: repo.getFragrances(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No trending fragrances'));
                  } else {
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.9,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final item = snapshot.data![index];
                        return GestureDetector(
                          child: buildFragranceCard(item, context),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        FragranceScreen(fragrance: item)));
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget buildFragranceCard(Fragrance item, context) {
    return Card(
      elevation: 4,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8)),
              child: Image.network(
                item.image,
                fit: BoxFit.contain,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        item.brand,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        item.releaseDate.year.toString(),
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 24,
                  height: 24,
                  child: getGenderIcon(item.gender),
                ),
              ],
            ),
          ),
        ],
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

class SearchWidget extends ConsumerStatefulWidget {
  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends ConsumerState<SearchWidget> {
  final TextEditingController _searchController = TextEditingController();

  @override
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.8),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(color: Colors.white70),
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                onChanged: (value) {
                  ref.invalidate(searchProvider);
                },
              ),
            ),
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  final searchResult =
                      ref.watch(searchProvider(_searchController.text));
                  return searchResult.when(
                    data: (fragrances) {
                      print(fragrances);
                      return GridView.builder(
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.9,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: fragrances.length,
                        itemBuilder: (context, index) {
                          final item = fragrances[index];
                          return buildFragranceCard(item, context);
                        },
                      );
                    },
                    loading: () => Center(child: CircularProgressIndicator()),
                    error: (error, stack) =>
                        Center(child: Text('Error: $error')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFragranceCard(Fragrance item, context) {
    return Card(
      elevation: 4,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8)),
              child: Image.network(
                item.image,
                fit: BoxFit.contain,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        item.brand,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        item.releaseDate.year.toString(),
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 24,
                  height: 24,
                  child: getGenderIcon(item.gender),
                ),
              ],
            ),
          ),
        ],
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
