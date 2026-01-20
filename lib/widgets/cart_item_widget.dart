// import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import '../models/cart.dart';
// import '../theme/app_theme.dart';

// class CartItemWidget extends StatelessWidget {
//   final CartItem item;
//   final VoidCallback? onDelete;
//   final ValueChanged<int>? onQuantityChanged;

//   const CartItemWidget({
//     Key? key,
//     required this.item,
//     this.onDelete,
//     this.onQuantityChanged,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: EdgeInsets.all(12),
//         child: Row(
//           children: [
//             Container(
//               width: 80,
//               height: 80,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(15),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 8,
//                     offset: Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(15),
//                 child: CachedNetworkImage(
//                   imageUrl: item.product.image,
//                   fit: BoxFit.cover,
//                   placeholder: (context, url) => Container(
//                     color: AppTheme.primaryColor.withOpacity(0.1),
//                     child: Center(
//                       child: CircularProgressIndicator(
//                         valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
//                       ),
//                     ),
//                   ),
//                   errorWidget: (context, url, error) => Container(
//                     color: AppTheme.errorColor.withOpacity(0.1),
//                     child: Icon(Icons.error_outline, color: AppTheme.errorColor),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     item.product.name,
//                     style: Theme.of(context).textTheme.titleMedium,
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   SizedBox(height: 4),
//                   Text(
//                     '\$${item.subTotal.toStringAsFixed(2)}',
//                     style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                       color: AppTheme.primaryColor,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   Row(
//                     children: [
//                       Container(
//                         decoration: BoxDecoration(
//                           color: AppTheme.backgroundColor,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Row(
//                           children: [
//                             IconButton(
//                               icon: Icon(Icons.remove, size: 18),
//                               onPressed: onQuantityChanged != null
//                                   ? () => onQuantityChanged!(item.quantity - 1)
//                                   : null,
//                               color: AppTheme.primaryColor,
//                               padding: EdgeInsets.all(8),
//                               constraints: BoxConstraints(),
//                             ),
//                             Container(
//                               padding: EdgeInsets.symmetric(horizontal: 12),
//                               child: Text(
//                                 '${item.quantity}',
//                                 style: Theme.of(context).textTheme.titleMedium,
//                               ),
//                             ),
//                             IconButton(
//                               icon: Icon(Icons.add, size: 18),
//                               onPressed: onQuantityChanged != null
//                                   ? () => onQuantityChanged!(item.quantity + 1)
//                                   : null,
//                               color: AppTheme.primaryColor,
//                               padding: EdgeInsets.all(8),
//                               constraints: BoxConstraints(),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             IconButton(
//               icon: Icon(Icons.delete_outline),
//               color: AppTheme.errorColor,
//               onPressed: onDelete,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:supa_electronics/models/cart.dart';
// import '../services/api_service.dart';

// class CartItemWidget extends StatefulWidget {
//   final String token;
//   final CartItem item;
//   final String cartId;
//   final VoidCallback onItemChanged;
//   final VoidCallback? onDelete;

//   CartItemWidget({
//     required this.item,
//     required this.cartId,
//     required this.token,
//     required this.onItemChanged,
//     required this.onDelete,
//   });

//   @override
//   _CartItemWidgetState createState() => _CartItemWidgetState();
// }

// class _CartItemWidgetState extends State<CartItemWidget> {
//   late int quantity;

//   @override
//   void initState() {
//     super.initState();
//     quantity = widget.item.quantity;
//   }

//   Future<void> updateQuantity(int newQuantity) async {
//     try {
//       await ApiService(token: widget.token).updateCartItemQuantity(
//         widget.cartId,
//         widget.item.product.id,
//         newQuantity,
//       );
//       setState(() {
//         quantity = newQuantity;
//       });
//       widget.onItemChanged();
//     } catch (e) {
//       print('Error updating quantity: $e');
//     }
//   }

// // Future<void> deleteItem() async {
// //   print('🧪 Deleting item with values:');
// //   print('Token: ${widget.token}');
// //   print('Cart ID: ${widget.cartId}');
// //   print('Item ID: ${widget.item.id}');

// //   try {
// //     await ApiService(token: widget.token)
// //         .removeItem(widget.cartId, widget.item.id);
// //     widget.onDelete?.call();
// //   } catch (e) {
// //     print('❌ Error deleting item: $e');
// //   }
// // }

// Future<void> deleteItem() async {
//   try {
//     print("Deleting item with values:");
//     print("Token: ${widget.token}");
//     print("Cart ID: ${widget.cartId}");
//     print("Item ID: ${widget.item.id}");

    
//  await ApiService(token: widget.token)
//         .removeItem(widget.cartId, widget.item.id);
//     widget.onDelete?.call();
//     widget.onItemChanged();  // حتى تعيد تحميل السلة أو تحدث الواجهة
//   } catch (e) {
//     print('Error deleting item: $e');
//     widget.onItemChanged();  // حتى لو صار خطأ، خلي الواجهة تحدث (بما إنه انحذف فعلاً)
//   }
// }



//   @override
//   Widget build(BuildContext context) {
//     final product = widget.item.product;

//     return Card(
//       margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//       child: ListTile(
//         leading: Image.network(product.image, width: 50, height: 50, fit: BoxFit.cover),
//         title: Text(product.name),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('${product.price} \$'),
//             Row(
//               children: [
//                 IconButton(
//                   icon: Icon(Icons.remove),
//                   onPressed: quantity > 1 ? () => updateQuantity(quantity - 1) : null,
//                 ),
//                 Text('$quantity'),
//                 IconButton(
//                   icon: Icon(Icons.add),
//                   onPressed: () => updateQuantity(quantity + 1),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         trailing: IconButton(
//           icon: Icon(Icons.delete, color: Colors.red),
//           onPressed: deleteItem,
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:supa_electronics/models/cart.dart';
import '../services/api_service.dart';

class CartItemWidget extends StatefulWidget {
  final String token;
  final CartItem item;
  final String cartId;
  final VoidCallback onItemChanged;
  final VoidCallback? onDelete;

  CartItemWidget({
    required this.item,
    required this.cartId,
    required this.token,
    required this.onItemChanged,
    required this.onDelete,
  });

  @override
  _CartItemWidgetState createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  late int quantity;

  @override
  void initState() {
    super.initState();
    quantity = widget.item.quantity;
  }

  Future<void> updateQuantity(int newQuantity) async {
    try {
      await ApiService(token: widget.token).updateCartItemQuantity(
        widget.cartId,
        widget.item.product.id,
        newQuantity,
      );
      setState(() {
        quantity = newQuantity;
      });
      widget.onItemChanged();
    } catch (e) {
      print('Error updating quantity: $e');
    }
  }

  Future<void> deleteItem() async {
    try {
      await ApiService(token: widget.token).removeItem(widget.cartId, widget.item.id);

      widget.onDelete?.call();
    } catch (e) {
      print('Error deleting item: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.item.product;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: Image.network(product.image, width: 50, height: 50, fit: BoxFit.cover),
        title: Text(product.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${product.price} \$'),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: quantity > 1 ? () => updateQuantity(quantity - 1) : null,
                ),
                Text('$quantity'),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => updateQuantity(quantity + 1),
                ),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: deleteItem,
        ),
      ),
    );
  }
}
