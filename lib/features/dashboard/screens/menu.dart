import 'package:flutter/material.dart' hide MenuController;
import '../../../data/cartmodel/cart_model.dart';
import '../../../data/menudata/menumodel.dart';
import '../controller/menu_controller.dart';
import '../controller/cart_controller.dart';
import 'cart.dart';

class MenuScreen extends StatefulWidget {
  final String collegeId;
  final String campusId;
  final String outletId;
  final String outletName;

  const MenuScreen({
    super.key,
    required this.collegeId,
    required this.campusId,
    required this.outletId,
    required this.outletName,
  });

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final MenuController controller = MenuController();
  final CartController cartController = CartController();

  @override
  void dispose() {
    // Keep cart persistent until checkout
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Menu - ${widget.outletName}")),
      body: Stack(
        children: [
          StreamBuilder<List<MenuItem>>(
            stream: controller.getMenu(
              widget.collegeId,
              widget.campusId,
              widget.outletId,
            ),
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (item.description.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4, bottom: 8),
                                child: Text(
                                  item.description,
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "₹${item.price.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                                item.isAvailable
                                    ? ElevatedButton.icon(
                                  onPressed: () {
                                    cartController.addItem(
                                      CartItem(
                                        id: item.name,
                                        name: item.name,
                                        price: item.price,
                                        quantity: 1,
                                      ),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            '${item.name} added to cart'),
                                        duration:
                                        const Duration(seconds: 1),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.add_shopping_cart),
                                  label: const Text("Add to Cart"),
                                )
                                    : Text(
                                  'Not Available',
                                  style: TextStyle(
                                    color: Colors.red[700],
                                    fontWeight: FontWeight.bold,
                                  ),
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

          /// CART BAR AT BOTTOM
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ValueListenableBuilder<List<CartItem>>(
              valueListenable: cartController.cartItemsNotifier,
              builder: (context, cartItems, _) {
                if (cartItems.isEmpty) return const SizedBox.shrink();
                double totalPrice = cartController.totalPrice;

                return Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${cartItems.length} items | ₹${totalPrice.toStringAsFixed(2)}",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CartScreen(
                                collegeId: widget.collegeId,
                                campusId: widget.campusId, // FIXED: Passing campusId
                                outletId: widget.outletId,
                              ),
                            ),
                          );
                        },
                        child: const Text("View Cart"),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
