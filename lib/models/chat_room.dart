class ChatRoom {
  final int id;
  final String name;
  final String userName;
  final int unreadCount;

  ChatRoom({
    required this.id,
    required this.name,
    required this.userName,
    required this.unreadCount,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id'],
      name: json['name'],
      userName: json['user_name'],
      unreadCount: json['unread_count'] ?? 0,
    );
  }
}
