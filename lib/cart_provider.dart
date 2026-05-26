// lib/cart_provider.dart

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => _items;

  int get itemCount {
    int count = 0;

    _items.forEach((key, item) {
      count += item.quantity;
    });

    return count;
  }

  double get totalPrice {
    double total = 0;

    _items.forEach((key, item) {
      total += item.product.price * item.quantity;
    });

    return total;
  }

  // =========================
  // LOAD DATA
  // =========================
  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString('cart');

    if (data == null) return;

    final decoded = jsonDecode(data) as List;

    _items.clear();

    for (var item in decoded) {
      final cartItem = CartItem.fromMap(item);

      _items[cartItem.product.id] = cartItem;
    }

    notifyListeners();
  }

  // =========================
  // SAVE DATA
  // =========================
  Future<void> saveCart() async {
    final prefs = await SharedPreferences.getInstance();

    final cartList =
        _items.values.map((item) => item.toMap()).toList();

    await prefs.setString(
      'cart',
      jsonEncode(cartList),
    );
  }

  // =========================
  // ADD
  // =========================
  void addToCart(Product product) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity++;
    } else {
      _items[product.id] = CartItem(
        product: product,
        quantity: 1,
      );
    }

    saveCart();
    notifyListeners();
  }

  // =========================
  // REMOVE / DECREMENT
  // =========================
  void decrementQuantity(String productId) {
    if (!_items.containsKey(productId)) return;

    if (_items[productId]!.quantity > 1) {
      _items[productId]!.quantity--;
    } else {
      _items.remove(productId);
    }

    saveCart();
    notifyListeners();
  }

  // =========================
  // CLEAR
  // =========================
  void clearCart() {
    _items.clear();

    saveCart();
    notifyListeners();
  }
}