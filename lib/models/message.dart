class Message {
  final int id;
  final String content;
  final String sender;
  final String timestamp;
  final bool read;

  Message({
    required this.id,
    required this.content,
    required this.sender,
    required this.timestamp,
    this.read = false,
  });

  /// 🔹 إنشاء كائن Message من JSON (كما يعاد من Django REST API)
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] ?? 0,
      content: json['content'] ?? '',
      sender: json['sender_name'] ?? 'Unknown',
      timestamp: json['timestamp'] ?? '',
      read: json['is_read'] ?? false,
    );
  }

  /// 🔹 تحويل الكائن إلى JSON (عند الإرسال إذا لزم لاحقًا)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'sender_name': sender,
      'timestamp': timestamp,
      'is_read': read,
    };
  }
}

