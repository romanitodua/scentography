import 'package:cloud_firestore/cloud_firestore.dart';

class Fragrance {
  final String id; // Document ID
  final String brand;
  final String name;
  final DateTime releaseDate;
  final int gender; // 0 unisex,1-man , 2-woman
  final String description;
  final List<String> top;
  final List<String> middle;
  final List<String> base;
  final String image;

  Fragrance({
    required this.id,
    required this.brand,
    required this.name,
    required this.releaseDate,
    required this.gender,
    required this.description,
    required this.top,
    required this.base,
    required this.middle,
    required this.image,
  });

  factory Fragrance.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Fragrance(
        id: doc.id,
        brand: data['Brand'],
        name: data['Name'],
        releaseDate: (data['Date'] as Timestamp).toDate(),
        gender: data['Gender'],
        description: data['Description'],
        top: List<String>.from(data['Top']),
        middle: List<String>.from(data['Middle']),
        base: List<String>.from(data['Base']),
        image: data['Image']);
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
