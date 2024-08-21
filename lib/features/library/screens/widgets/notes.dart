import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../domain/fragrance.dart';

class PyramidCard extends StatelessWidget {
  final Fragrance fragrance;

  const PyramidCard({super.key, required this.fragrance});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fragrance Pyramid',style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            FragranceNoteRow(
              icon: Icons.ice_skating,
              label: 'Top',
              notes: fragrance.top,
            ),
            SizedBox(height: 16),
            FragranceNoteRow(
              icon: Icons.play_arrow_outlined,
              label: 'Middle',
              notes: fragrance.middle,
            ),
            SizedBox(height: 16),
            FragranceNoteRow(
              icon: Icons.arrow_circle_down,
              label: 'Base',
              notes: fragrance.base,
            ),
          ],
        ),
      ),
    );
  }
}

class FragranceNoteRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final List<String> notes;

  const FragranceNoteRow({
    Key? key,
    required this.icon,
    required this.label,
    required this.notes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 40,
          child: Column(
            children: [
              Text(
                label,
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: notes
                .map((note) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.grey,
                            child: Icon(Icons.spa, size: 16),
                          ),
                          SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              note,
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
