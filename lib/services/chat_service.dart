// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../models/message.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

// class ChatService {
//   final String token;

//   ChatService({required this.token});

//   /// 🔹 جلب رسائل غرفة معينة
// // fetchMessages in ChatService
//   Future<List<Message>> fetchMessages(String roomName) async {
//     final baseUrl = dotenv.env['BASE_URL']!;
//     final url = Uri.parse('$baseUrl/api/message/$roomName/');

//     final response = await http.get(url, headers: {
//       'Authorization': 'Bearer $token',
//     });

//     if (response.statusCode == 200) {
//       final jsonData = jsonDecode(response.body);
//       return (jsonData as List).map((msg) => Message.fromJson(msg)).toList();
//     } else {
//       throw Exception('Failed to load messages');
//     }
//   }

//   /// 🔹 إرسال رسالة لغرفة معينة
//   Future<void> sendMessage({
//     required String roomName,
//     required String content,
//   }) async {
//     final baseUrl = dotenv.env['BASE_URL'] ?? 'http://127.0.0.1:8000';
//     final url = Uri.parse('$baseUrl/api/message/');

//     try {
//       final response = await http.post(
//         url,
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({
//           'room': roomName,
//           'message': content,
//         }),
//       );

//       if (response.statusCode != 201) {
//         print('❌ Failed to send message: ${response.body}');
//         throw Exception('Message sending failed');
//       }
//     } catch (e) {
//       print('❌ Exception in sendMessage: $e');
//       rethrow;
//     }
//   }
// }
