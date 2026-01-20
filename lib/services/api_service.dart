// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import '../models/product_detail.dart';
// import '../models/cart.dart';
// import '../models/order.dart';
// import '../models/chat_room.dart';
// import '../models/message.dart';

// class ApiService {
//   final String baseUrl = dotenv.env['BASE_URL']!;
//   final String token;

//   ApiService({required this.token});
//   Future<Map<String, dynamic>> fetchUserProfile() async {
//   final response = await http.get(
//     Uri.parse('$baseUrl/api/users/me/'),
//     headers: {
//       'Authorization': 'Bearer $token',
//       'Content-Type': 'application/json',
//     },
//   );

//   if (response.statusCode == 200) {
//     return jsonDecode(response.body);
//   } else {
//     throw Exception("فشل في تحميل الملف الشخصي: ${response.body}");
//   }
// }
//   Future<List<ProductDetail>> fetchProducts() async {
//     final response = await http.get(
//       Uri.parse('$baseUrl/api/products/'),
//       headers: {'Authorization': 'Bearer $token'},
//     );

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> jsonMap = jsonDecode(response.body);
//       final List<dynamic> jsonResponse = jsonMap['results']; // ✅ هذا الصح

//       return jsonResponse.map((data) => ProductDetail.fromJson(data)).toList();
//     } else {
//       throw Exception('Failed to load products');
//     }
//   }

//   Future<List<dynamic>> fetchMessages(String roomName) async {
//     final response = await http.get(
//       Uri.parse('${dotenv.env['BASE_URL']}/api/message/$roomName/'),
//       headers: {'Authorization': 'Bearer $token'},
//     );

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
//       // Check if response has results key
//       if (jsonResponse.containsKey('results')) {
//         final List<dynamic> messages = jsonResponse['results'] ?? [];
//         return messages;
//       }
//       // If no results key, treat the response as a direct list
//       return jsonResponse as List<dynamic>;
//     } else {
//       throw Exception('فشل في تحميل الرسائل');
//     }
//   }

//   Future<List<Map<String, dynamic>>> fetchRooms() async {
//     final url = Uri.parse('$baseUrl/api/room/');
//     print('📬 Fetching rooms with token: $token');

//     final response = await http.get(
//       url,
//       headers: {
//         'Authorization': 'Bearer $token',
//         'Content-Type': 'application/json',
//       },
//     );

//     if (response.statusCode == 200) {
//       final decoded = jsonDecode(response.body); // هذا Map
//       final List<dynamic> results = decoded['results'] ?? []; // 🟢 هذا الصح
//       print('✅ Successfully fetched ${results.length} rooms');
//       return results.cast<Map<String, dynamic>>();
//     } else {
//       print(
//           '❌ Error fetching rooms: ${response.statusCode} - ${response.body}');
//       throw Exception('فشل في تحميل الغرف: ${response.statusCode}');
//     }
//   }

//   Future<void> sendMessage(String roomName, String content) async {
//     final baseUrl = dotenv.env['BASE_URL']!;
//     final url = Uri.parse('$baseUrl/api/send-message/');
//     final response = await http.post(
//       url,
//       headers: {
//         'Authorization': 'Bearer $token',
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({'roomname': roomName, 'content': content}),
//     );

//     if (response.statusCode != 201) {
//       throw Exception('فشل في إرسال الرسالة');
//     }
//   }

//   Future<void> createRoom(String roomName) async {
//     if (token == null) {
//       print('❌ No token provided');
//       throw Exception('لم يتم توفير رمز المصادقة');
//     }
//     if (roomName.isEmpty) {
//       print('❌ Room name is empty');
//       throw Exception('اسم الغرفة لا يمكن أن يكون فارغًا');
//     }

//     final url = Uri.parse('$baseUrl/api/room/');
//     final payload = {'name': roomName.trim()};

//     print('📤 Creating room: $payload');
//     final response = await http.post(
//       url,
//       headers: {
//         'Authorization': 'Bearer $token',
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode(payload),
//     );

//     if (response.statusCode != 201) {
//       print('❌ Error creating room: ${response.statusCode} - ${response.body}');
//       throw Exception('فشل في إنشاء الغرفة: ${response.body}');
//     }

//     print('✅ Room created successfully: $roomName');
//   }

//   Future<Cart?> fetchCart() async {
//     final response = await http.get(
//       Uri.parse('$baseUrl/api/cart/'),
//       headers: {'Authorization': 'Bearer $token'},
//     );

//     if (response.statusCode == 200) {
//       final decoded = jsonDecode(response.body);
//       final results = decoded['results'] as List<dynamic>?;

//       if (results != null && results.isNotEmpty) {
//         return Cart.fromJson(results[0]);
//       } else {
//         // 🆕 إنشاء cart جديدة
//         final createResponse = await http.post(
//           Uri.parse('$baseUrl/api/cart/'),
//           headers: {
//             'Authorization': 'Bearer $token',
//             'Content-Type': 'application/json',
//           },
//         );

//         if (createResponse.statusCode == 201) {
//           final created = jsonDecode(createResponse.body);
//           return Cart.fromJson(created);
//         } else {
//           return null;
//         }
//       }
//     } else {
//       throw Exception('Failed to load cart');
//     }
//   }

//   Future<void> addToCart(String cartId, int productId, int quantity) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/api/cart/$cartId/additems/'),
//       headers: {
//         'Authorization': 'Bearer $token',
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({
//         'product_id': productId,
//         'quantity': quantity,
//       }),
//     );
//     print(response.statusCode);
//     if (response.statusCode != 201) {
//       throw Exception('Failed to add item to cart');
//     }
//   }

// // ✅ في حال الباك يرجع فقط cart_id، نحتاج أن نعمل GET بعد POST لنجيب order.id الحقيقي

//   Future<String?> createOrder(String cartId) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/api/orders/'),
//       headers: {
//         'Authorization': 'Bearer $token',
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({'cart_id': cartId}),
//     );

//     if (response.statusCode == 201) {
//       final json = jsonDecode(response.body);
//       print('✅ Order created response: $json');

//       // 🟡 إذا لم يرجع الباكند ID، نبحث في قائمة الطلبات
//       if (json.containsKey('id')) {
//         return json['id'].toString();
//       }

//       // fallback: fetch latest order and return its id
//       final ordersResponse = await http.get(
//         Uri.parse('$baseUrl/api/orders/'),
//         headers: {'Authorization': 'Bearer $token'},
//       );

//       if (ordersResponse.statusCode == 200) {
//         final decoded = jsonDecode(ordersResponse.body);
//         final results = decoded['results'] ?? [];

//         if (results.isNotEmpty) {
//           final latestOrder = results.last;
//           return latestOrder['id'].toString();
//         }
//       }

//       throw Exception('⚠️ Order ID not found in response or order list.');
//     } else {
//       print('❌ Failed to create order: ${response.body}');
//       throw Exception('Failed to create order: ${response.body}');
//     }
//   }

//   Future<String> initiatePayment(String orderId) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/api/orders/$orderId/pay/'),
//       headers: {'Authorization': 'Bearer $token'},
//     );
//     if (response.statusCode == 200) {
//       return jsonDecode(response.body)['session_url'];
//     } else {
//       throw Exception('Failed to initiate payment');
//     }
//   }
// Future<List<Order>> fetchOrders() async {
//   final url = Uri.parse('$baseUrl/api/orders/');
//   final response = await http.get(
//     url,
//     headers: {'Authorization': 'Bearer $token'},
//   );

//   print(response.body); // نطبع النتيجة

//   if (response.statusCode == 200) {
//     final data = json.decode(response.body);
//     final List<dynamic> results = data['results']; // ✅ هذا هو التعديل المهم

//     return results.map((json) => Order.fromJson(json)).toList();
//   } else {
//     throw Exception('فشل في تحميل الطلبات');
//   }
// }

//   Future<List<ChatRoom>> fetchChatRooms() async {
//     final response = await http.get(
//       Uri.parse('$baseUrl/api/room/'),
//       headers: {'Authorization': 'Bearer $token'},
//     );

//     if (response.statusCode == 200) {
//       final decoded = jsonDecode(response.body);
//       final List<dynamic> results = decoded['results'] ?? [];

//       return results.map((json) => ChatRoom.fromJson(json)).toList();
//     } else {
//       throw Exception('Failed to load chat rooms');
//     }
//   }

// Future<Map<String, dynamic>> getUserProfile() async {
//   final response = await http.get(
//     Uri.parse('$baseUrl/api/users/me/'),
//     headers: {'Authorization': 'Bearer $token'},
//   );

//   if (response.statusCode == 200) {
//     return jsonDecode(response.body);
//   } else {
//     throw Exception('Failed to fetch user profile');
//   }
// }

// //   Future<void> removeItem(String cartId, int itemId) async {
// //     final response = await http.delete(
// //       Uri.parse('$baseUrl/api/cart/$cartId/removeitem/$itemId/'),
// //       headers: {'Authorization': 'Bearer $token'},
// //     );
// //     if (response.statusCode != 200) {
// //       throw Exception('Failed to remove item from cart');
// //     }
// //   }
// // }
// Future<void> updateCartItemQuantity(String cartId, int productId, int quantity) async {
//   final response = await http.post(
//     Uri.parse('$baseUrl/api/cart/$cartId/updateitem/$productId/'),
//     headers: {
//       'Authorization': 'Bearer $token',
//       'Content-Type': 'application/json',
//     },
//     body: jsonEncode({'quantity': quantity}),
//   );

//   if (response.statusCode != 200) {
//     throw Exception('Failed to update item quantity');
//   }
// }

// Future<void> removeItem(String cartId, int itemId) async {
//   final response = await http.delete(
//     Uri.parse('$baseUrl/api/cart/$cartId/removeitem/$itemId/'),
//     headers: {'Authorization': 'Bearer $token'},
//   );

//   if (response.statusCode != 204) { // أو 200 حسب الباك
//     throw Exception('Failed to remove item from cart');
//   }
// }

// // Future<void> deleteCartItem(String cartId, int itemId) async {
// //   final url = Uri.parse('$baseUrl/api/cart/$cartId/removeitem/$itemId/');
// //   final response = await http.delete(
// //     url,
// //     headers: {
// //       'Authorization': 'Bearer $token',
// //       'Content-Type': 'application/json',
// //     },
// //   );

// //   if (response.statusCode != 204) {
// //     throw Exception('فشل في حذف المنتج من السلة');
// //   }
// // }


// }


// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import '../models/product_detail.dart';
// import '../models/cart.dart';
// import '../models/order.dart';
// import '../models/chat_room.dart';
// import '../models/message.dart';
//   final String baseUrl = dotenv.env['BASE_URL']!;

// class ApiService {
//   final String token;

//   ApiService({required this.token});
//   Future<Map<String, dynamic>> fetchUserProfile() async {
//   final response = await http.get(
//     Uri.parse('$baseUrl/api/users/me/'),
//     headers: {
//       'Authorization': 'Bearer $token',
//       'Content-Type': 'application/json',
//     },
//   );

//   if (response.statusCode == 200) {
//     return jsonDecode(response.body);
//   } else {
//     throw Exception("فشل في تحميل الملف الشخصي: ${response.body}");
//   }
// }
//   Future<List<ProductDetail>> fetchProducts() async {
//     final response = await http.get(
//       Uri.parse('$baseUrl/api/products/'),
//       headers: {'Authorization': 'Bearer $token'},
//     );

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> jsonMap = jsonDecode(response.body);
//       final List<dynamic> jsonResponse = jsonMap['results']; // ✅ هذا الصح

//       return jsonResponse.map((data) => ProductDetail.fromJson(data)).toList();
//     } else {
//       throw Exception('Failed to load products');
//     }
//   }

//   Future<List<dynamic>> fetchMessages(String roomName) async {
//     final response = await http.get(
//       Uri.parse('${dotenv.env['BASE_URL']}/api/message/$roomName/'),
//       headers: {'Authorization': 'Bearer $token'},
//     );

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
//       // Check if response has results key
//       if (jsonResponse.containsKey('results')) {
//         final List<dynamic> messages = jsonResponse['results'] ?? [];
//         return messages;
//       }
//       // If no results key, treat the response as a direct list
//       return jsonResponse as List<dynamic>;
//     } else {
//       throw Exception('فشل في تحميل الرسائل');
//     }
//   }

//   Future<List<Map<String, dynamic>>> fetchRooms() async {
//     final url = Uri.parse('$baseUrl/api/room/');
//     print('📬 Fetching rooms with token: $token');

//     final response = await http.get(
//       url,
//       headers: {
//         'Authorization': 'Bearer $token',
//         'Content-Type': 'application/json',
//       },
//     );

//     if (response.statusCode == 200) {
//       final decoded = jsonDecode(response.body); // هذا Map
//       final List<dynamic> results = decoded['results'] ?? []; // 🟢 هذا الصح
//       print('✅ Successfully fetched ${results.length} rooms');
//       return results.cast<Map<String, dynamic>>();
//     } else {
//       print(
//           '❌ Error fetching rooms: ${response.statusCode} - ${response.body}');
//       throw Exception('فشل في تحميل الغرف: ${response.statusCode}');
//     }
//   }

//   Future<void> sendMessage(String roomName, String content) async {
//     final baseUrl = dotenv.env['BASE_URL']!;
//     final url = Uri.parse('$baseUrl/api/send-message/');
//     final response = await http.post(
//       url,
//       headers: {
//         'Authorization': 'Bearer $token',
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({'roomname': roomName, 'content': content}),
//     );

//     if (response.statusCode != 201) {
//       throw Exception('فشل في إرسال الرسالة');
//     }
//   }

//   Future<void> createRoom(String roomName) async {
//     if (token == null) {
//       print('❌ No token provided');
//       throw Exception('لم يتم توفير رمز المصادقة');
//     }
//     if (roomName.isEmpty) {
//       print('❌ Room name is empty');
//       throw Exception('اسم الغرفة لا يمكن أن يكون فارغًا');
//     }

//     final url = Uri.parse('$baseUrl/api/room/');
//     final payload = {'name': roomName.trim()};

//     print('📤 Creating room: $payload');
//     final response = await http.post(
//       url,
//       headers: {
//         'Authorization': 'Bearer $token',
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode(payload),
//     );

//     if (response.statusCode != 201) {
//       print('❌ Error creating room: ${response.statusCode} - ${response.body}');
//       throw Exception('فشل في إنشاء الغرفة: ${response.body}');
//     }

//     print('✅ Room created successfully: $roomName');
//   }

// Future<Cart?> fetchCart() async {
//   print("🔐 Token المستخدم: $token");

//   final response = await http.get(
//     Uri.parse('$baseUrl/api/cart/'),
//     headers: {'Authorization': 'Bearer $token'},
//   );

//   print("📦 استجابة السلة: ${response.statusCode} - ${response.body}");

//   if (response.statusCode == 200) {
//     final decoded = jsonDecode(response.body);
//     final results = decoded['results'] as List<dynamic>?;

//     if (results != null && results.isNotEmpty) {
//       return Cart.fromJson(results[0]);
//     } else {
//       print("🆕 لا توجد سلة، سيتم إنشاء واحدة جديدة...");

//       final createResponse = await http.post(
//         Uri.parse('$baseUrl/api/cart/'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//       );

//       print("📥 استجابة إنشاء السلة: ${createResponse.statusCode} - ${createResponse.body}");

//       if (createResponse.statusCode == 201) {
//         final created = jsonDecode(createResponse.body);
//         return Cart.fromJson(created);
//       } else {
//         return null;
//       }
//     }
//   } else {
//     throw Exception('فشل في تحميل السلة');
//   }
// }


//   Future<void> addToCart(String cartId, int productId, int quantity) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/api/cart/$cartId/additems/'),
//       headers: {
//         'Authorization': 'Bearer $token',
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({
//         'product_id': productId,
//         'quantity': quantity,
//       }),
//     );
//     print(response.statusCode);
//     if (response.statusCode != 201) {
//       throw Exception('Failed to add item to cart');
//     }
//   }

// Future<String?> createOrder(String cartId) async {
//   print('🚀 Sending order creation request for cartId: $cartId');

//   final response = await http.post(
//     Uri.parse('$baseUrl/api/orders/'),
//     headers: {
//       'Authorization': 'Bearer $token',
//       'Content-Type': 'application/json',
//     },
//     body: jsonEncode({'cart_id': cartId}),
//   );

//   print('📥 Response status: ${response.statusCode}');
//   print('📥 Response body: ${response.body}');

//   if (response.statusCode == 201) {
//     final json = jsonDecode(response.body);
//     print('✅ Order created: $json');

//     if (json.containsKey('id')) {
//       return json['id'].toString();
//     }

//     // fallback
//     final ordersResponse = await http.get(
//       Uri.parse('$baseUrl/api/orders/'),
//       headers: {'Authorization': 'Bearer $token'},
//     );

//     if (ordersResponse.statusCode == 200) {
//       final decoded = jsonDecode(ordersResponse.body);
//       final results = decoded['results'] ?? [];

//       if (results.isNotEmpty) {
//         final latestOrder = results.last;
//         print('✅ Latest order fetched: $latestOrder');
//         return latestOrder['id'].toString();
//       }
//     }

//     throw Exception('⚠️ Order ID not found in response or order list.');
//   } else {
//     print('❌ Failed to create order: ${response.body}');
//     throw Exception('Failed to create order: ${response.body}');
//   }
// }


//   Future<String> initiatePayment(String orderId) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/api/orders/$orderId/pay/'),
//       headers: {'Authorization': 'Bearer $token'},
//     );
//     if (response.statusCode == 200) {
//       return jsonDecode(response.body)['session_url'];
//     } else {
//       throw Exception('Failed to initiate payment');
//     }
//   }
// Future<List<Order>> fetchOrders() async {
//   final response = await http.get(
//     Uri.parse('$baseUrl/api/orders/'),
//     headers: {'Authorization': 'Bearer $token'},
//   );

//   if (response.statusCode == 200) {
//     final data = json.decode(response.body);
//     print(response.body); // للتأكد من البيانات
//     final List<dynamic> results = data['results']; // تأكد من استخدام 'results'
//     return results.map((item) => Order.fromJson(item)).toList();
//   } else {
//     throw Exception('فشل تحميل الطلبات');
//   }
// }


//   Future<List<ChatRoom>> fetchChatRooms() async {
//     final response = await http.get(
//       Uri.parse('$baseUrl/api/room/'),
//       headers: {'Authorization': 'Bearer $token'},
//     );

//     if (response.statusCode == 200) {
//       final decoded = jsonDecode(response.body);
//       final List<dynamic> results = decoded['results'] ?? [];

//       return results.map((json) => ChatRoom.fromJson(json)).toList();
//     } else {
//       throw Exception('Failed to load chat rooms');
//     }
//   }

// Future<Map<String, dynamic>> getUserProfile() async {
//   final url = Uri.parse('$baseUrl/api/users/me/');
//   final response = await http.get(url, headers: {
//     'Content-Type': 'application/json',
//     'Authorization': 'Bearer $token',
//   });

//   if (response.statusCode == 200) {
//     return json.decode(response.body);
//   } else {
//     throw Exception('فشل تحميل بيانات المستخدم');
//   }
// }


// //   Future<void> removeItem(String cartId, int itemId) async {
// //     final response = await http.delete(
// //       Uri.parse('$baseUrl/api/cart/$cartId/removeitem/$itemId/'),
// //       headers: {'Authorization': 'Bearer $token'},
// //     );
// //     if (response.statusCode != 200) {
// //       throw Exception('Failed to remove item from cart');
// //     }
// //   }
// // }
// Future<void> updateCartItemQuantity(String cartId, int productId, int quantity) async {
//   final response = await http.post(
//     Uri.parse('$baseUrl/api/cart/$cartId/updateitem/$productId/'),
//     headers: {
//       'Authorization': 'Bearer $token',
//       'Content-Type': 'application/json',
//     },
//     body: jsonEncode({'quantity': quantity}),
//   );

//   if (response.statusCode != 200) {
//     throw Exception('Failed to update item quantity');
//   }
// }
// Future<void> removeItem(String cartId, int itemId) async {
//   final url = Uri.parse('$baseUrl/api/cart/$cartId/removeitem/$itemId/');
//   final response = await http.delete(
//     url,
//     headers: {
//       'Authorization': 'Bearer $token',
//     },
//   );

//   if (response.statusCode != 204 && response.statusCode != 200) {
//     print('Error deleting item: ${response.body}');
//     throw Exception('Failed to remove item from cart');
//   }
// }



// // Future<void> deleteCartItem(String cartId, int itemId) async {
// //   final url = Uri.parse('$baseUrl/api/cart/$cartId/removeitem/$itemId/');
// //   final response = await http.delete(
// //     url,
// //     headers: {
// //       'Authorization': 'Bearer $token',
// //       'Content-Type': 'application/json',
// //     },
// //   );

// //   if (response.statusCode != 204) {
// //     throw Exception('فشل في حذف المنتج من السلة');
// //   }
// // }

// Future<List<CartItem>> fetchCartItems() async {
//   final cart = await fetchCart();
//   return cart?.items ?? [];
// }
// Future<bool> updateUserProfile(Map<String, dynamic> data) async {
//   final url = Uri.parse('$baseUrl/api/users/me/');
//   final response = await http.put(
//     url,
//     headers: {
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer $token', // تأكد أن التوكن صحيح
//     },
//     body: json.encode(data),
//   );
  
//   print(response.statusCode);
//   print(response.body);
//   return response.statusCode == 200;
// }


// Future<Map<String, dynamic>?> getCurrentUser() async {
//   final url = Uri.parse('$baseUrl/api/users/me/');
//   final response = await http.get(url, headers: {
//     'Authorization': 'Bearer $token',
//     'Content-Type': 'application/json',
//   });

//   if (response.statusCode == 200) {
//     return json.decode(response.body);
//   } else {
//     return null;
//   }
// }


// }

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supa_electronics/services/auth_service.dart';

import '../models/product_detail.dart';
import '../models/cart.dart';
import '../models/order.dart';
import '../models/chat_room.dart';
import '../models/message.dart';

// ⚙️ عنوان السيرفر من .env
final String baseUrl = dotenv.env['BASE_URL']!;

class ApiService {
  final String token;

  ApiService({required this.token});

  /// ✅ رفع صورة للبحث: يرسل Multipart بالحقل "image" إلى /upload-image/
  /// ويعيد JSON يحتوي status, predicted_class, products[]
  Future<Map<String, dynamic>> uploadSearchImage(String imagePath) async {
    final uri = Uri.parse('$baseUrl/upload-image/');
    final req = http.MultipartRequest('POST', uri);

    // الهيدر (لو الباك لاحقاً طالب توثيق)
    if (token.isNotEmpty) {
      req.headers['Authorization'] = 'Bearer $token';
    }
    req.headers['Accept'] = 'application/json';

    // ملف الصورة
    req.files.add(await http.MultipartFile.fromPath('image', imagePath));

    final streamed = await req.send();
    final resp = await http.Response.fromStream(streamed);

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      return json.decode(resp.body) as Map<String, dynamic>;
    } else {
      throw Exception('فشل رفع الصورة: ${resp.statusCode} ${resp.body}');
    }
  }

  Future<Map<String, dynamic>> fetchUserProfile() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/users/me/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("فشل في تحميل الملف الشخصي: ${response.body}");
    }
  }

  Future<List<ProductDetail>> fetchProducts() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/products/'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = jsonDecode(response.body);
      final List<dynamic> jsonResponse = jsonMap['results']; // ✅ هذا الصح
      return jsonResponse.map((data) => ProductDetail.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<List<dynamic>> fetchMessages(String roomName) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['BASE_URL']}/api/message/$roomName/'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse.containsKey('results')) {
        final List<dynamic> messages = jsonResponse['results'] ?? [];
        return messages;
      }
      return jsonResponse as List<dynamic>;
    } else {
      throw Exception('فشل في تحميل الرسائل');
    }
  }

  Future<List<Map<String, dynamic>>> fetchRooms() async {
    final url = Uri.parse('$baseUrl/api/room/');
    print('📬 Fetching rooms with token: $token');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body); // هذا Map
      final List<dynamic> results = decoded['results'] ?? []; // 🟢 هذا الصح
      print('✅ Successfully fetched ${results.length} rooms');
      return results.cast<Map<String, dynamic>>();
    } else {
      print('❌ Error fetching rooms: ${response.statusCode} - ${response.body}');
      throw Exception('فشل في تحميل الغرف: ${response.statusCode}');
    }
  }

  Future<void> sendMessage(String roomName, String content) async {
    final baseUrl = dotenv.env['BASE_URL']!;
    final url = Uri.parse('$baseUrl/api/send-message/');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'roomname': roomName, 'content': content}),
    );

    if (response.statusCode != 201) {
      throw Exception('فشل في إرسال الرسالة');
    }
  }

  Future<void> createRoom(String roomName) async {
    if (roomName.isEmpty) {
      print('❌ Room name is empty');
      throw Exception('اسم الغرفة لا يمكن أن يكون فارغًا');
    }

    final url = Uri.parse('$baseUrl/api/room/');
    final payload = {'name': roomName.trim()};

    print('📤 Creating room: $payload');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode != 201) {
      print('❌ Error creating room: ${response.statusCode} - ${response.body}');
      throw Exception('فشل في إنشاء الغرفة: ${response.body}');
    }

    print('✅ Room created successfully: $roomName');
  }

  // Future<Cart?> fetchCart() async {
  //   print("🔐 Token المستخدم: $token");

  //   final response = await http.get(
  //     Uri.parse('$baseUrl/api/cart/'),
  //     headers: {'Authorization': 'Bearer $token'},
  //   );

  //   print("📦 استجابة السلة: ${response.statusCode} - ${response.body}");

  //   if (response.statusCode == 200) {
  //     final decoded = jsonDecode(response.body);
  //     final results = decoded['results'] as List<dynamic>?;

  //     if (results != null && results.isNotEmpty) {
  //       return Cart.fromJson(results[0]);
  //     } else {
  //       print("🆕 لا توجد سلة، سيتم إنشاء واحدة جديدة...");

  //       final createResponse = await http.post(
  //         Uri.parse('$baseUrl/api/cart/'),
  //         headers: {
  //            'Authorization': 'Bearer ${token.trim()}',
  //           'Content-Type': 'application/json',
  //         },
  //       );

  //       print(
  //           "📥 استجابة إنشاء السلة: ${createResponse.statusCode} - ${createResponse.body}");

  //       if (createResponse.statusCode == 201) {
  //         final created = jsonDecode(createResponse.body);
  //         return Cart.fromJson(created);
  //       } else {
  //         return null;
  //       }
  //     }
  //   } else {
  //     throw Exception('فشل في تحميل السلة');
  //   }
  // }

// Future<Cart?> fetchCart() async {
//   // احصل على الـ token من SharedPreferences
//   final token = await getTokenOrThrow();  
//   if (token == null) {
//     throw Exception('لا يوجد Token للمستخدم');
//   }

//   print("🔐 Token المستخدم: $token");

//   final response = await http.get(
//     Uri.parse('$baseUrl/api/cart/'),
//     headers: {'Authorization': 'Bearer ${token.trim()}'},
//   );

//   print("📦 استجابة السلة: ${response.statusCode} - ${response.body}");

//   if (response.statusCode == 200) {
//     final decoded = jsonDecode(response.body);
//     final results = decoded['results'] as List<dynamic>?;

//     if (results != null && results.isNotEmpty) {
//       return Cart.fromJson(results[0]);
//     } else {
//       print("🆕 لا توجد سلة، سيتم إنشاء واحدة جديدة...");

//       final createResponse = await http.post(
//         Uri.parse('$baseUrl/api/cart/'),
//         headers: {
//           'Authorization': 'Bearer ${token.trim()}',
//           'Content-Type': 'application/json',
//         },
//       );

//       print(
//           "📥 استجابة إنشاء السلة: ${createResponse.statusCode} - ${createResponse.body}");

//       if (createResponse.statusCode == 201) {
//         final created = jsonDecode(createResponse.body);
//         return Cart.fromJson(created);
//       } else {
//         return null;
//       }
//     }
//   } else {
//     throw Exception('فشل في تحميل السلة');
//   }
// }

Future<Cart?> fetchCart() async {
  try {
    final token = await getToken();
    if (token == null) {
      print('⚠️ لا يوجد Token للمستخدم');
      return null; // أو ترجع Cart فارغة حسب تصميمك
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/cart/'),
      headers: {'Authorization': 'Bearer ${token.trim()}'},
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final results = decoded['results'] as List<dynamic>?;

      if (results != null && results.isNotEmpty) {
        return Cart.fromJson(results[0]);
      } else {
        // إنشاء سلة جديدة إذا لم توجد
        final createResponse = await http.post(
          Uri.parse('$baseUrl/api/cart/'),
          headers: {
            'Authorization': 'Bearer ${token.trim()}',
            'Content-Type': 'application/json',
          },
        );
        if (createResponse.statusCode == 201) {
          final created = jsonDecode(createResponse.body);
          return Cart.fromJson(created);
        }
        return null;
      }
    } else {
      print('❌ فشل في تحميل السلة: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('❌ خطأ في fetchCart: $e');
    return null;
  }
}



// Future<void> addToCart(String cartId, int productId, int quantity) async {
//   final response = await http.post(
//     Uri.parse('$baseUrl/api/cart/$cartId/additems/'),
//     headers: {
//       'Authorization': 'Bearer $token',
//       'Content-Type': 'application/json',
//     },
//     body: jsonEncode({
//       'product_id': productId,
//       'quantity': quantity,
//     }),
//   );

//   print("🛒 addToCart status: ${response.statusCode}");
//   print("🛒 addToCart body: ${response.body}");

//   if (response.statusCode != 201 && response.statusCode != 200) {
//     throw Exception('Failed to add item to cart: ${response.body}');
//   }
// }

Future<void> addToCart(String cartId, int productId, int quantity) async {
  // احصل على الـ token من SharedPreferences
  final token = await getTokenOrThrow();
  if (token == null) {
    throw Exception('لا يوجد Token للمستخدم');
  }

  final response = await http.post(
    Uri.parse('$baseUrl/api/cart/$cartId/additems/'),
    headers: {
      'Authorization': 'Bearer ${token.trim()}',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'product_id': productId,
      'quantity': quantity,
    }),
  );

  print("🛒 addToCart status: ${response.statusCode}");
  print("🛒 addToCart body: ${response.body}");

  if (response.statusCode != 201 && response.statusCode != 200) {
    throw Exception('Failed to add item to cart: ${response.body}');
  }
}



  Future<String?> createOrder(String cartId) async {
    print('🚀 Sending order creation request for cartId: $cartId');

    final response = await http.post(
      Uri.parse('$baseUrl/api/orders/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'cart_id': cartId}),
    );

    print('📥 Response status: ${response.statusCode}');
    print('📥 Response body: ${response.body}');

    if (response.statusCode == 201) {
      final json = jsonDecode(response.body);
      print('✅ Order created: $json');

      if (json.containsKey('id')) {
        return json['id'].toString();
      }

      // fallback
      final ordersResponse = await http.get(
        Uri.parse('$baseUrl/api/orders/'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (ordersResponse.statusCode == 200) {
        final decoded = jsonDecode(ordersResponse.body);
        final results = decoded['results'] ?? [];

        if (results.isNotEmpty) {
          final latestOrder = results.last;
          print('✅ Latest order fetched: $latestOrder');
          return latestOrder['id'].toString();
        }
      }

      throw Exception('⚠️ Order ID not found in response or order list.');
    } else {
      print('❌ Failed to create order: ${response.body}');
      throw Exception('Failed to create order: ${response.body}');
    }
  }

  Future<String> initiatePayment(String orderId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/orders/$orderId/pay/'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['session_url'];
    } else {
      throw Exception('Failed to initiate payment');
    }
  }

  Future<List<Order>> fetchOrders() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/orders/'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(response.body); // للتأكد من البيانات
      final List<dynamic> results = data['results']; // تأكد من استخدام 'results'
      return results.map((item) => Order.fromJson(item)).toList();
    } else {
      throw Exception('فشل تحميل الطلبات');
    }
  }

  Future<List<ChatRoom>> fetchChatRooms() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/room/'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List<dynamic> results = decoded['results'] ?? [];

      return results.map((json) => ChatRoom.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load chat rooms');
    }
  }

  Future<Map<String, dynamic>> getUserProfile() async {
    final url = Uri.parse('$baseUrl/api/users/me/');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('فشل تحميل بيانات المستخدم');
    }
  }

  Future<void> updateCartItemQuantity(
      String cartId, int productId, int quantity) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/cart/$cartId/updateitem/$productId/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'quantity': quantity}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update item quantity');
    }
  }

  Future<void> removeItem(String cartId, int itemId) async {
    final url = Uri.parse('$baseUrl/api/cart/$cartId/removeitem/$itemId/');
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 204 && response.statusCode != 200) {
      print('Error deleting item: ${response.body}');
      throw Exception('Failed to remove item from cart');
    }
  }

  Future<List<CartItem>> fetchCartItems() async {
    final cart = await fetchCart();
    return cart?.items ?? [];
  }

  Future<bool> updateUserProfile(Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/api/users/me/');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // تأكد أن التوكن صحيح
      },
      body: json.encode(data),
    );

    print(response.statusCode);
    print(response.body);
    return response.statusCode == 200;
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    final url = Uri.parse('$baseUrl/api/users/me/');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return null;
    }
  }
}
