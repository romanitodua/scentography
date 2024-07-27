import 'package:cloud_firestore/cloud_firestore.dart';

class Fragrance {
  final int id;  // Document ID
  final String brand;
  final String name;
  final DateTime releaseDate;
  final int gender; // 0 unisex,1-man , 2-woman
  final String description;
  final List<String> notes;
  final Map<String, int> type;
  final Pyramid pyramid;

  Fragrance({
    required this.id,
    required this.brand,
    required this.name,
    required this.releaseDate,
    required this.gender,
    required this.description,
    required this.notes,
    required this.type,
    required this.pyramid,
  });

  factory Fragrance.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Fragrance(
      id: int.parse(doc.id),
      brand: data['brand'],
      name: data['name'],
      releaseDate: (data['release_date'] as Timestamp).toDate(),
      gender: data['gender'],
      description: data['description'],
      notes: List<String>.from(data['notes']),
      type: Map<String, int>.from(data['type']),
      pyramid: Pyramid.fromMap(data['pyramid']),
    );
  }
}

class Pyramid {
  final List<String> top;
  final List<String> middle;
  final List<String> base;

  Pyramid({
    required this.top,
    required this.middle,
    required this.base,
  });

  factory Pyramid.fromMap(Map<String, dynamic> data) {
    return Pyramid(
      top: List<String>.from(data['top']),
      middle: List<String>.from(data['middle']),
      base: List<String>.from(data['base']),
    );
  }
}
