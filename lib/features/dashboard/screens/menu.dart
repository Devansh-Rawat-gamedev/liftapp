import 'package:flutter/material.dart' hide MenuController;
import '../../../data/menudata/menumodel.dart';
import '../controller/menu_controller.dart';

class MenuScreen extends StatelessWidget {
  final String collegeId;
  final String campusId;
  final String outletId;
  final String outletName;

  final controller = MenuController();

  MenuScreen({
    super.key,
    required this.collegeId,
    required this.campusId,
    required this.outletId,
    required this.outletName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Menu - $outletName")),
      body: StreamBuilder<List<MenuItem>>(
        stream: controller.getMenu(collegeId, campusId, outletId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No menu items available"));
          }

          final menuItems = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: menuItems.length,
            itemBuilder: (context, index) {
              final item = menuItems[index];
              return Opacity(
                opacity: item.isAvailable ? 1.0 : 0.5,
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        if (item.description.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4, bottom: 8),
                            child: Text(item.description, style: TextStyle(color: Colors.grey[700])),
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "₹${item.price.toStringAsFixed(2)}",
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                            ),
                            item.isAvailable
                                ? ElevatedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('${item.name} added to cart')),
                                );
                              },
                              icon: const Icon(Icons.add_shopping_cart),
                              label: const Text("Add to Cart"),
                            )
                                : Text(
                              'Not Available',
                              style: TextStyle(color: Colors.red[700], fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
