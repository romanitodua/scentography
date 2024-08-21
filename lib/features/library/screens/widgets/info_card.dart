import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../domain/fragrance.dart';

class InfoCard extends StatelessWidget {
  final Fragrance fragrance;

  const InfoCard({super.key, required this.fragrance});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: SizedBox(
            height: 350,
            width: double.infinity,
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8)),
              child: Image.network(
                fragrance.image,
                fit: BoxFit.fill,
                width: double.infinity,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Card(
          elevation: 2,
          child: Text(
            fragrance.description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}
