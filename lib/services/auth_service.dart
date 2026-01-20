// دالة موجودة عندك
import 'package:shared_preferences/shared_preferences.dart';

Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}

// الدالة الجديدة، ضيفها بعد getToken
Future<String> getTokenOrThrow() async {
  final token = await getToken();
  if (token == null || token.isEmpty) {
    throw Exception('لا يوجد Token للمستخدم');
  }
  return token.trim();
}
