import 'package:cloud_firestore/cloud_firestore.dart';

class CollegeSeeder {
  static final List<Map<String, dynamic>> colleges = [
    {
      "name": "Starlight University",
      "campuses": [
        {
          "name": "Main Campus",
          "location": {"latitude": 19.0760, "longitude": 72.8777},
          "outlets": [
            {
              "name": "Campus Café",
              "category": "Food & Beverages",
              "menu": [
                {"name": "Coffee", "price": 50},
                {"name": "Sandwich", "price": 70}
              ]
            },
            {
              "name": "Bookstore",
              "category": "Stationery",
              "menu": [
                {"name": "Notebook", "price": 20},
                {"name": "Pen", "price": 10}
              ]
            }
          ]
        },
        {
          "name": "City Campus",
          "location": {"latitude": 19.2100, "longitude": 72.8500},
          "outlets": []
        }
      ]
    },
    {
      "name": "Riverside Institute of Technology",
      "campuses": [
        {
          "name": "Riverfront Campus",
          "location": {"latitude": 28.6139, "longitude": 77.2090},
          "outlets": [
            {
              "name": "Tech Café",
              "category": "Food & Beverages",
              "menu": [
                {"name": "Burger", "price": 80},
                {"name": "Tea", "price": 30}
              ]
            }
          ]
        }
      ]
    }
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
