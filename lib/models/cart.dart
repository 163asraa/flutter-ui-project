import 'package:supa_electronics/models/product_detail.dart';

class Cart {
  final String cartcode;
  final String user;
  final double grandTotal;
  final List<CartItem> items;

  Cart({
    required this.cartcode,
    required this.user,
    required this.grandTotal,
    required this.items,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      cartcode: json['cartcode'] ?? '',
      user: json['user'] ?? '',
      grandTotal: (json['grand_total'] as num?)?.toDouble() ?? 0.0,
      items: (json['items'] as List?)
              ?.map((item) => CartItem.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class CartItem {
  final int id;
  final ProductDetail product;
  final int quantity;
  final double subTotal;

  CartItem({
    required this.id,
    required this.product,
    required this.quantity,
    required this.subTotal,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] ?? 0,
      product: ProductDetail.fromJson(json['product']),
      quantity: json['quantity'] ?? 0,
      subTotal: (json['Sub_total'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
