import 'package:cloud_firestore/cloud_firestore.dart';

class CollegeSeeder {
  static final List<Map<String, String>> colleges = [
    { "name": "Starlight University", "location": "Mumbai" },
    { "name": "Riverside Institute of Technology", "location": "Delhi" },
    { "name": "Evergreen College", "location": "Bengaluru" },
    { "name": "Hilltop Engineering College", "location": "Pune" },
    { "name": "Sunrise University", "location": "Chennai" },
    { "name": "Lakeside College of Arts", "location": "Kolkata" },
    { "name": "Greenfield Institute of Science", "location": "Hyderabad" },
    { "name": "Silver Oak University", "location": "Ahmedabad" },
    { "name": "Blue Horizon College", "location": "Jaipur" },
    { "name": "Bright Future Institute", "location": "Lucknow" },
    { "name": "Redwood College", "location": "Bhopal" },
    { "name": "Mountain View Polytechnic", "location": "Shimla" },
    { "name": "Golden Gate University", "location": "Goa" },
    { "name": "Central City College", "location": "Nagpur" },
    { "name": "Pioneer Institute of Management", "location": "Indore" },
    { "name": "Galaxy Engineering University", "location": "Surat" },
    { "name": "Pearl Coast College", "location": "Visakhapatnam" },
    { "name": "Royal Heritage University", "location": "Udaipur" },
    { "name": "Meadow Valley Institute", "location": "Guwahati" },
    { "name": "Northgate College", "location": "Dehradun" },
    { "name": "Silverline Institute of Business", "location": "Patna" },
    { "name": "Ocean View University", "location": "Mangalore" },
    { "name": "Crescent Moon College", "location": "Thrissur" },
    { "name": "Maple Leaf Institute", "location": "Ranchi" },
    { "name": "Aurora Institute of Technology", "location": "Kanpur" },
  ];

  static Future<void> seedColleges() async {
    final collection = FirebaseFirestore.instance.collection('colleges');

    for (var college in colleges) {
      await collection.add(college);
    }
    print("✅ Seeded ${colleges.length} colleges into Firestore.");
  }
}
