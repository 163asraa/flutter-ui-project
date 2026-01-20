import 'package:supa_electronics/models/product_detail.dart';

class Order {
  final int id;
  final String sendAt;
  final String? completeAt;
  final String pendingStatus;
  final String ownerName;
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.sendAt,
    this.completeAt,
    required this.pendingStatus,
    required this.ownerName,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      sendAt: json['send_at'],
      completeAt: json['complete_at'],
      pendingStatus: json['pending_status'],
      ownerName: json['ownername'],
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
    );
  }
}

class OrderItem {
  final int id;
  final ProductDetail product;
  final int quantity;

  OrderItem({
    required this.id,
    required this.product,
    required this.quantity,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      product: ProductDetail.fromJson(json['product']),
      quantity: json['quantity'],
    );
  }
}

// class Order {
//   final int id;
//   String status; // ✅ أصبح قابل للتعديل
//   final String sendAt;
//   final double total;
//   final List<OrderItem> items;

//   Order({
//     required this.id,
//     required this.status,
//     required this.sendAt,
//     required this.total,
//     required this.items,
//   });

//   factory Order.fromJson(Map<String, dynamic> json) {
//     return Order(
//       id: json['id'],
//       status: json['status'],
//       sendAt: json['send_at'] ?? '', // تأكد من التسمية حسب الباكند
//       total: (json['total'] as num).toDouble(),
//       items: (json['items'] as List)
//           .map((item) => OrderItem.fromJson(item))
//           .toList(),
//     );
//   }
// }

// class OrderItem {
//   final int id;
//   final String name;
//   final int quantity;
//   final double price;

//   OrderItem({
//     required this.id,
//     required this.name,
//     required this.quantity,
//     required this.price,
//   });

//   factory OrderItem.fromJson(Map<String, dynamic> json) {
//     return OrderItem(
//       id: json['id'],
//       name: json['name'],
//       quantity: json['quantity'],
//       price: (json['price'] as num).toDouble(),
//     );
//   }
// }
