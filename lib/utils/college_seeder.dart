import 'package:cloud_firestore/cloud_firestore.dart';

class CollegeSeeder {
  static final List<Map<String, dynamic>> colleges = [
    {
      "name": "University of Petroleum and Energy Studies (UPES)",
      "campuses": [
        {
          "name": "Bhidoli Campus",
          "location": { "latitude": 30.4021, "longitude": 78.0826 },
          "outlets": [
            {
              "name": "Rollshop",
              "category": "Food & Beverages",
              "menu": [
                {"name": "Paneer Tikka Roll", "price": 80},
                {"name": "Chicken Tikka Roll", "price": 90},
                {"name": "Egg Roll", "price": 50},
                {"name": "Veg Roll", "price": 60},
                {"name": "Cheese Roll", "price": 70},
                {"name": "Double Egg Roll", "price": 60},
                {"name": "Paneer Cheese Roll", "price": 90},
                {"name": "Chicken Cheese Roll", "price": 100},
                {"name": "Mushroom Roll", "price": 70},
                {"name": "Aloo Roll", "price": 50},
                {"name": "Paneer Butter Roll", "price": 90},
                {"name": "Tandoori Chicken Roll", "price": 110},
                {"name": "Veg Mayo Roll", "price": 65},
                {"name": "Chicken Mayo Roll", "price": 95},
                {"name": "Paneer Masala Roll", "price": 85},
                {"name": "Egg Chicken Roll", "price": 100},
                {"name": "Soya Roll", "price": 60},
                {"name": "Chilli Paneer Roll", "price": 95},
                {"name": "Spicy Chicken Roll", "price": 105},
                {"name": "Mix Veg Roll", "price": 65}
              ]
            },
            {
              "name": "Frisco",
              "category": "Food & Beverages",
              "menu": [
                {"name": "Veg Burger", "price": 60},
                {"name": "Chicken Burger", "price": 90},
                {"name": "French Fries", "price": 50},
                {"name": "Cheese Fries", "price": 70},
                {"name": "Veg Pizza", "price": 120},
                {"name": "Chicken Pizza", "price": 150},
                {"name": "Garlic Bread", "price": 80},
                {"name": "Cheese Garlic Bread", "price": 100},
                {"name": "Veg Sandwich", "price": 60},
                {"name": "Grilled Chicken Sandwich", "price": 90},
                {"name": "Cold Coffee", "price": 60},
                {"name": "Hot Coffee", "price": 40},
                {"name": "Mojito", "price": 70},
                {"name": "Ice Tea", "price": 50},
                {"name": "Veg Pasta", "price": 80},
                {"name": "Chicken Pasta", "price": 100},
                {"name": "Paneer Pizza", "price": 140},
                {"name": "Cheese Burger", "price": 80},
                {"name": "Veg Wrap", "price": 70},
                {"name": "Chicken Wrap", "price": 90}
              ]
            },
            {
              "name": "Tulips",
              "category": "Food & Beverages",
              "menu": [
                {"name": "Paneer Butter Masala", "price": 150},
                {"name": "Chicken Curry", "price": 180},
                {"name": "Dal Makhani", "price": 120},
                {"name": "Mix Veg", "price": 110},
                {"name": "Butter Naan", "price": 30},
                {"name": "Tandoori Roti", "price": 20},
                {"name": "Plain Rice", "price": 60},
                {"name": "Jeera Rice", "price": 80},
                {"name": "Veg Biryani", "price": 120},
                {"name": "Chicken Biryani", "price": 150},
                {"name": "Paneer Tikka", "price": 140},
                {"name": "Veg Kofta", "price": 130},
                {"name": "Chana Masala", "price": 110},
                {"name": "Aloo Gobi", "price": 100},
                {"name": "Rajma Chawal", "price": 120},
                {"name": "Kadhai Paneer", "price": 150},
                {"name": "Fish Curry", "price": 200},
                {"name": "Chicken Tikka", "price": 180},
                {"name": "Egg Curry", "price": 140},
                {"name": "Shahi Paneer", "price": 160}
              ]
            },
            {
              "name": "Foodcourt",
              "category": "Multi-Cuisine",
              "menu": [
                {"name": "Veg Thali", "price": 100},
                {"name": "Non-Veg Thali", "price": 140},
                {"name": "Idli", "price": 50},
                {"name": "Dosa", "price": 70},
                {"name": "Masala Dosa", "price": 80},
                {"name": "Uttapam", "price": 80},
                {"name": "Samosa", "price": 20},
                {"name": "Kachori", "price": 25},
                {"name": "Chole Bhature", "price": 90},
                {"name": "Pav Bhaji", "price": 80},
                {"name": "Veg Chowmein", "price": 70},
                {"name": "Chicken Chowmein", "price": 90},
                {"name": "Veg Fried Rice", "price": 80},
                {"name": "Chicken Fried Rice", "price": 100},
                {"name": "Momos Veg", "price": 60},
                {"name": "Momos Chicken", "price": 80},
                {"name": "Spring Roll", "price": 50},
                {"name": "Veg Cutlet", "price": 40},
                {"name": "Cold Drink", "price": 30},
                {"name": "Mineral Water", "price": 20}
              ]
            },
            {
              "name": "Barrens",
              "category": "Bakery & Café",
              "menu": [
                {"name": "Chocolate Cake", "price": 80},
                {"name": "Black Forest Cake", "price": 90},
                {"name": "Vanilla Pastry", "price": 50},
                {"name": "Chocolate Pastry", "price": 60},
                {"name": "Brownie", "price": 70},
                {"name": "Cheese Croissant", "price": 80},
                {"name": "Butter Croissant", "price": 70},
                {"name": "Veg Puff", "price": 30},
                {"name": "Paneer Puff", "price": 40},
                {"name": "Chicken Puff", "price": 50},
                {"name": "Muffin", "price": 40},
                {"name": "Donut", "price": 50},
                {"name": "Cupcake", "price": 50},
                {"name": "Hot Chocolate", "price": 60},
                {"name": "Cappuccino", "price": 70},
                {"name": "Latte", "price": 70},
                {"name": "Espresso", "price": 50},
                {"name": "Tea", "price": 20},
                {"name": "Cold Coffee", "price": 60},
                {"name": "Iced Latte", "price": 70}
              ]
            }
          ]
        },
        {
          "name": "Kandoli Campus",
          "location": { "latitude": 30.3831, "longitude": 78.0602 },
          "outlets": [
            {
              "name": "Frico",
              "category": "Food & Beverages",
              "menu": [
                {"name": "Veg Burger", "price": 60},
                {"name": "Chicken Burger", "price": 90},
                {"name": "French Fries", "price": 50},
                {"name": "Cheese Fries", "price": 70},
                {"name": "Veg Pizza", "price": 120},
                {"name": "Chicken Pizza", "price": 150},
                {"name": "Garlic Bread", "price": 80},
                {"name": "Cheese Garlic Bread", "price": 100},
                {"name": "Veg Sandwich", "price": 60},
                {"name": "Grilled Chicken Sandwich", "price": 90},
                {"name": "Cold Coffee", "price": 60},
                {"name": "Hot Coffee", "price": 40},
                {"name": "Mojito", "price": 70},
                {"name": "Ice Tea", "price": 50},
                {"name": "Veg Pasta", "price": 80},
                {"name": "Chicken Pasta", "price": 100},
                {"name": "Paneer Pizza", "price": 140},
                {"name": "Cheese Burger", "price": 80},
                {"name": "Veg Wrap", "price": 70},
                {"name": "Chicken Wrap", "price": 90}
              ]
            },
            {
              "name": "Foodcourt",
              "category": "Multi-Cuisine",
              "menu": [
                {"name": "Veg Thali", "price": 100},
                {"name": "Non-Veg Thali", "price": 140},
                {"name": "Idli", "price": 50},
                {"name": "Dosa", "price": 70},
                {"name": "Masala Dosa", "price": 80},
                {"name": "Uttapam", "price": 80},
                {"name": "Samosa", "price": 20},
                {"name": "Kachori", "price": 25},
                {"name": "Chole Bhature", "price": 90},
                {"name": "Pav Bhaji", "price": 80},
                {"name": "Veg Chowmein", "price": 70},
                {"name": "Chicken Chowmein", "price": 90},
                {"name": "Veg Fried Rice", "price": 80},
                {"name": "Chicken Fried Rice", "price": 100},
                {"name": "Momos Veg", "price": 60},
                {"name": "Momos Chicken", "price": 80},
                {"name": "Spring Roll", "price": 50},
                {"name": "Veg Cutlet", "price": 40},
                {"name": "Cold Drink", "price": 30},
                {"name": "Mineral Water", "price": 20}
              ]
            }
          ]
        }
      ]
    }
  ];

  static Future<void> seedColleges() async {
    final collection = FirebaseFirestore.instance.collection('colleges');

    for (var college in colleges) {
      await collection.add(college);
    }

    print("✅ Seeded ${colleges.length} colleges into Firestore.");
  }
}
