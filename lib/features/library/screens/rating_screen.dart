
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scentography/data/providers.dart';

class RatingScreen extends ConsumerStatefulWidget {
  const RatingScreen(this.fragranceId, this.franceName, {super.key});

  final String fragranceId;
  final String franceName;

  @override
  ConsumerState createState() => _RatingScreenState();
}

class _RatingScreenState extends ConsumerState<RatingScreen> {
  Map<String, double> ratings = {
    'SCENT': 1,
    'SILLAGE': 1,
    'DURABILITY': 1,
    'BOTTLE': 1,
  };

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(fireStoreRepoProvider);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.upload),
        onPressed: () {
          repo.incrementRating(widget.fragranceId,
              ratings.values.map((e) => e.toInt().toString()).toList());
          Navigator.pop(context,true);
        },
      ),
      appBar: AppBar(
        title: Text('Rate'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var category in ratings.keys)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Slider(
                          value: ratings[category]!,
                          min: 1,
                          max: 10,
                          divisions: 9,
                          label: ratings[category]!.round().toString(),
                          onChanged: (double value) {
                            setState(() {
                              ratings[category] = value;
                            });
                          },
                        ),
                      ),
                      Text(
                        ratings[category]!.round().toString(),
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
