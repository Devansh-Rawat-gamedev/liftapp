import 'package:cloud_firestore/cloud_firestore.dart';
import 'campusmodel/campus_model.dart';

class College {
  final String id;
  final String name;
  final List<Campus> campuses;

  College({
    required this.id,
    required this.name,
    this.campuses = const [],
  });

  factory College.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return College(
      id: doc.id,
      name: data['name'] ?? '',
    );
  }
}
