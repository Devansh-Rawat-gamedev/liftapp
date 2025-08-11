// lib/data/cart/cart_controller.dart
import 'package:flutter/material.dart';
import '../../../data/cartmodel/cart_model.dart';


class CartController {
  // Singleton pattern so the same instance is used everywhere
  static final CartController _instance = CartController._internal();
  factory CartController() => _instance;
  CartController._internal();

  // Notifier for cart updates
  final ValueNotifier<List<CartItem>> cartItemsNotifier = ValueNotifier([]);

  List<CartItem> get cartItems => cartItemsNotifier.value;

  double get totalPrice => cartItems.fold(
      0.0, (sum, item) => sum + (item.price * item.quantity));

  void addItem(CartItem item) {
    final index = cartItems.indexWhere((e) => e.id == item.id);
    if (index != -1) {
      cartItems[index].quantity++;
    } else {
      cartItems.add(item);
    }
    cartItemsNotifier.value = List.from(cartItems); // Notify listeners
  }

  void removeItem(String id) {
    cartItems.removeWhere((item) => item.id == id);
    cartItemsNotifier.value = List.from(cartItems);
  }

  void increaseQuantity(String id) {
    final index = cartItems.indexWhere((item) => item.id == id);
    if (index != -1) {
      cartItems[index].quantity++;
      cartItemsNotifier.value = List.from(cartItems);
    }
  }

  void decreaseQuantity(String id) {
    final index = cartItems.indexWhere((item) => item.id == id);
    if (index != -1 && cartItems[index].quantity > 1) {
      cartItems[index].quantity--;
    } else {
      removeItem(id);
      return;
    }
    cartItemsNotifier.value = List.from(cartItems);
  }

  void clearCart() {
    cartItems.clear();
    cartItemsNotifier.value = [];
  }
}
