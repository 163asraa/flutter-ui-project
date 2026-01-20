

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supa_electronics/const/color.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../services/api_service.dart';
import '../providers/auth_provider.dart';
import '../models/message.dart';
import '../widgets/message_bubble.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late ApiService _apiService;
  List<Map<String, dynamic>> _rooms = [];
  Map<String, dynamic>? _selectedRoom;
  List<Message> _messages = [];
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _roomNameController = TextEditingController();

  WebSocketChannel? _channel;
  StreamSubscription? _channelSubscription;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _apiService = ApiService(token: authProvider.token ?? '');
    if (authProvider.token != null) {
      _fetchRooms();
    } else {
      _loadTokenAndFetchRooms();
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _roomNameController.dispose();
    _channelSubscription?.cancel();
    _channel?.sink.close();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadTokenAndFetchRooms() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.loadToken();
    if (authProvider.token != null) {
      _apiService = ApiService(token: authProvider.token!);
      _fetchRooms();
    }
  }

  Future<void> _fetchRooms() async {
    try {
      final rooms = await _apiService.fetchRooms();
      final firstRoom = rooms.isNotEmpty ? rooms[0] : null;
      final messages = firstRoom != null
          ? await _apiService.fetchMessages(firstRoom['name'])
          : [];

      setState(() {
        _rooms = rooms;
        _selectedRoom = firstRoom;
        _messages = messages
            .map((msg) => Message.fromJson(msg as Map<String, dynamic>))
            .toList();
      });

      if (firstRoom != null) {
        _connectWebSocket(firstRoom['name']);
      }

      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    } catch (e) {
      print('Error fetching rooms: $e');
    }
  }

  void _connectWebSocket(String roomName) {
    final uri = Uri.parse('ws://localhost:8002/ws/chat/$roomName/');
    _channel = WebSocketChannel.connect(uri);
    _channelSubscription = _channel!.stream.listen((data) {
      try {
        final decoded = jsonDecode(data);
        if (decoded['message'] != null) {
          print("mmmmmmmmmmmmmmnnnnnnnnnnnnnnnnnnnnssssssssssssssss");
          print(decoded['sender_name']);
          final newMessage = Message(
            id: decoded['id'] ?? 0,
            content: decoded['message'],
            sender: decoded['sender_name'] ?? 'Unknown',
            timestamp: decoded['timestamp'] ?? DateTime.now().toIso8601String(),
            read: true,
          );
          setState(() => _messages.add(newMessage));
          _scrollToBottom();
        }
      } catch (e) {
        print('WebSocket parsing error: $e');
      }
    });
  }

  Future<bool> sendMessage(int roomId, String content) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$baseUrl/api/message/');
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    final iduser = prefs.getString('id') ?? '';

    final String username = prefs.getString('username') ?? '';
    print("fffffffffffffffff");
    print(iduser);
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'room': roomId,
        'content': content,
        'sender': iduser,
      }),
    );
    print(response.statusCode);

    if (response.statusCode == 201) {
      return true;
    } else {
      print('Failed to send message: ${response.body}');
      return false;
    }
  }

  Future<void> _handleSendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _selectedRoom == null) return;

    final roomId = _selectedRoom!['id'];
    final success = await sendMessage(roomId, text);

    if (success) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final newMessage = Message(
        id: 0,
        content: text,
        sender: authProvider.userData?['username'] ?? 'أنا',
        timestamp: DateTime.now().toIso8601String(),
        read: true,
      );

      setState(() {
        _messages.add(newMessage);
      });

      _messageController.clear();
      _scrollToBottom();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل في إرسال الرسالة')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildHeader(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:120.0),
            child: Column(
              
              children: [
                if (_rooms.isNotEmpty)
                  DropdownButton<Map<String, dynamic>>(
                    value: _selectedRoom,
                    onChanged: (value) async {
                      if (value != null) {
                        setState(() {
                          _selectedRoom = value;
                          _messages.clear();
                        });
                        final msgs =
                            await _apiService.fetchMessages(value['name']);
                        setState(() => _messages = msgs
                            .map((msg) =>
                                Message.fromJson(msg as Map<String, dynamic>))
                            .toList());
                        _connectWebSocket(value['name']);
                        _scrollToBottom();
                      }
                    },
                    items: _rooms.map((room) {
                      return DropdownMenuItem(
                        value: room,
                        child: Text(room['name'] ?? ''),
                      );
                    }).toList(),
                  ),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return MessageBubble(message: _messages[index]);
                    },
                  ),
                ),
        Padding(
  padding: const EdgeInsets.all(8.0),
  child: Row(
    children: [
      Expanded(
        child: TextField(
          controller: _messageController,
          decoration: InputDecoration(
            hintText: 'اكتب رسالتك...',
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary), // لون الحقل الأساسي
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary, width: 2.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          onSubmitted: (_) => _handleSendMessage(),
        ),
      ),
      IconButton(
        icon: Icon(Icons.send, color: AppColors.primary),
        onPressed: _handleSendMessage,
      ),
    ],
  ),
),
      ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildHeader() {
  return Container(
    width: double.infinity,
    height: 100,
    decoration: BoxDecoration(
      color: AppColors.secondary,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(32),
        bottomRight: Radius.circular(32),
      ),
    ),
    child: Stack(
      children: [
        Container(
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(34),
              bottomRight: Radius.circular(34),
            ),
            child: Image.asset(
              "assets/image2.jpg",
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 300,
          decoration: BoxDecoration(
            color: const Color.fromARGB(137, 18, 62, 68),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
          ),
        ),
          Padding(
          padding: const EdgeInsets.only(top: 60.0, right: 30, left: 30),
          child: Container(
            width: double.infinity,
            height: 20,
            decoration: BoxDecoration(
              color: const Color.fromARGB(90, 255, 255, 255),
              borderRadius: BorderRadius.all(
                Radius.circular(32),
              ),
            ),
          ),
        ),
         Padding(
          padding: const EdgeInsets.only(top: 34.0, right: 30, left: 30),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: const Color.fromARGB(0, 255, 255, 255),
              borderRadius: BorderRadius.all(
                Radius.circular(32),
              ),
            ),
            child: Center(child: Text("خدمة العملاء",style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,color: const Color.fromARGB(255, 255, 255, 255)),)),
          ),
        ),
      
      ],
    ),
  );
}
