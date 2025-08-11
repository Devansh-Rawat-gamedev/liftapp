import 'package:flutter/material.dart';
import '../controller/cart_controller.dart';
import '../../../data/cartmodel/cart_model.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = CartController();

    return Scaffold(
      appBar: AppBar(title: const Text("Your Cart")),
      body: ValueListenableBuilder<List<CartItem>>(
        valueListenable: cartController.cartItemsNotifier,
        builder: (context, cartItems, _) {
          if (cartItems.isEmpty) {
            return const Center(child: Text("Your cart is empty"));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return Card(
                      margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ListTile(
                        title: Text(item.name),
                        subtitle: Text("₹${item.price.toStringAsFixed(2)}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle),
                              onPressed: () =>
                                  cartController.decreaseQuantity(item.id),
                            ),
                            Text(item.quantity.toString(),
                                style: const TextStyle(fontSize: 16)),
                            IconButton(
                              icon: const Icon(Icons.add_circle),
                              onPressed: () =>
                                  cartController.increaseQuantity(item.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 5)
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total: ₹${cartController.totalPrice.toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Place order logic
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Order placed successfully!")),
                        );
                        cartController.clearCart();
                        Navigator.pop(context);
                      },
                      child: const Text("Checkout"),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
