import 'package:cloud_firestore/cloud_firestore.dart';

class Ratings {
  final String id;
  int count;
  double scentAverage;
  double durabilityAverage;
  double sillageAverage;
  double bottleAverage;
  final Map<String, Map<String, int>> ratings;

  Ratings({
    required this.id,
    required this.ratings,
    this.count = 0,
    this.scentAverage = 0.0,
    this.durabilityAverage = 0.0,
    this.sillageAverage = 0.0,
    this.bottleAverage = 0.0,
  }) {
    _calculateAverages();
  }

  factory Ratings.FromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    Map<String, Map<String, int>> ratings = {};

    data["ratings"]?.forEach((category, ratingMap) {
      ratings[category] =
      Map<String, int>.from(ratingMap as Map<String, dynamic>);
    });

    return Ratings(id: doc.id, ratings: ratings);
  }

  void _calculateAverages() {
    count = 0;
    double scentTotal = 0.0;
    double durabilityTotal = 0.0;
    double sillageTotal = 0.0;
    double bottleTotal = 0.0;

    if (ratings.isNotEmpty) {
      ratings.forEach((category, ratingMap) {
        ratingMap.forEach((ratingKey, ratingCount) {
          double ratingValue = double.tryParse(ratingKey) ?? 0.0;
          count += ratingCount;

          if (category == 'SCENT') {
            scentTotal += ratingValue * ratingCount;
          } else if (category == 'DURABILITY') {
            durabilityTotal += ratingValue * ratingCount;
          } else if (category == 'SILLAGE') {
            sillageTotal += ratingValue * ratingCount;
          } else if (category == 'BOTTLE') {
            bottleTotal += ratingValue * ratingCount;
          }
        });
      });
      count = count ~/ 4;
      if (count > 0) {
        scentAverage = double.parse((scentTotal / count).toStringAsFixed(2));
        durabilityAverage = double.parse((durabilityTotal / count).toStringAsFixed(2));
        sillageAverage = double.parse((sillageTotal / count).toStringAsFixed(2));
        bottleAverage = double.parse((bottleTotal / count).toStringAsFixed(2));
      }
    }
  }

  static Map<String, Map<String, int>> GenerateGenericRatingsMap() {
    Map<String, Map<String, int>> ratings = {};
    List<String> categories = ["BOTTLE", "SCENT", "SILLAGE", "DURABILITY"];
    for (String category in categories) {
      Map<String, int> ratingMap = {
        for (int i = 1; i <= 10; i++) i.toString(): 0,
      };
      ratings[category] = ratingMap;
    }
    return ratings;
  }
}
