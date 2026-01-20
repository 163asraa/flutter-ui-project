import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  final _controller = StreamController<Map<String, dynamic>>.broadcast();
  String? _currentRoom;

  Stream<Map<String, dynamic>> get messages => _controller.stream;

  void connect(String roomName, String token) {
    disconnect(); // اغلق أي اتصال سابق
    _currentRoom = roomName;

    // ✅ تأكد أن WS_URL موجود في .env أو استخدم IP بدل 127.0.0.1
   final baseUrl = dotenv.env['WS_URL'] ?? 'ws://10.154.97.109:8002';

    final wsUrl = '$baseUrl/ws/chat/$roomName/';
    print('🔗 Connecting to WebSocket: $wsUrl');

    try {
      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
      _channel!.stream.listen(
        (data) {
          try {
            final message = jsonDecode(data);
            print('📩 Received WebSocket message: $message');

            if (message['error'] != null) {
              _controller.addError(message['error']);
            } else {
              _controller.add({
                'id': message['id'] ?? 0,
                'message': message['message'],
                'sender': message['sender'],
                'sender_name': message['sender_name'],
                'timestamp':
                    message['timestamp'] ?? DateTime.now().toIso8601String(),
                'room_name': message['room_name'],
              });
            }
          } catch (e) {
            print('❌ Error parsing message: $e');
            _controller.addError('خطأ في قراءة الرسالة');
          }
        },
        onError: (error) {
          print('❌ WebSocket error: $error');
          _controller.addError('فشل في الاتصال');
        },
        onDone: () {
          print('🔌 WebSocket connection closed');
          _channel = null;
        },
      );
    } catch (e) {
      print('❌ Failed to connect: $e');
      _controller.addError('فشل الاتصال بالسيرفر');
    }
  }

  void sendMessage(String message, String token) {
    if (_channel == null) {
      throw Exception('🚫 لا يوجد اتصال نشط');
    }

    final payload = {
      'message': message,
      'user': token, // ✅ كما يتوقع الباكند
    };

    print('📤 Sending message: $payload');
    _channel!.sink.add(jsonEncode(payload));
  }

  void disconnect() {
    if (_channel != null) {
      _channel!.sink.close();
      print('🔌 Disconnected from WebSocket');
      _channel = null;
    }
    _currentRoom = null;
  }
}
