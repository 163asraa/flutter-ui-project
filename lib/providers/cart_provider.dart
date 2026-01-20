import 'package:flutter/material.dart';
import '../models/cart.dart';
import '../services/api_service.dart';

class CartProvider with ChangeNotifier {
  final ApiService apiService;
  List<CartItem> _items = [];

  CartProvider(this.apiService);

  List<CartItem> get items => _items;

  Future<void> loadCartItems() async {
    try {
      _items = await apiService.fetchCartItems();
      notifyListeners();
    } catch (e) {
      print("❌ فشل في تحميل السلة: $e");
    }
  }

  Future<void> addToCart(String cartId, int productId, int quantity) async {
    try {
      await apiService.addToCart(cartId, productId, quantity);
      await loadCartItems();
    } catch (e) {
      print("❌ فشل في الإضافة إلى السلة: $e");
    }
  }

  Future<void> removeFromCart(String cartId, int itemId) async {
    try {
      await apiService.removeItem(cartId, itemId);
      await loadCartItems();
    } catch (e) {
      print("❌ فشل في الحذف من السلة: $e");
    }
  }

  Future<void> updateQuantity(String cartId, int productId, int quantity) async {
    try {
      await apiService.updateCartItemQuantity(cartId, productId, quantity);
      await loadCartItems();
    } catch (e) {
      print("❌ فشل في تحديث الكمية: $e");
    }
  }

  double get totalAmount {
    return _items.fold(0.0, (sum, item) {
      final price = item.product?.price ?? 0;
      return sum + price * item.quantity;
    });
  }
}
