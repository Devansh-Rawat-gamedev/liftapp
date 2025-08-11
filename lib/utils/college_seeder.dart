import 'package:cloud_firestore/cloud_firestore.dart';

class CollegeSeeder {
  static final List<Map<String, dynamic>> colleges = [

    // 🔹 Add more colleges here in the same structure if needed
  ];

  static Future<void> seedColleges() async {
    final collection = FirebaseFirestore.instance.collection('colleges');

    for (var college in colleges) {
      await collection.add(college);
    }

    print("✅ Seeded ${colleges.length} colleges into Firestore.");
  }
}
