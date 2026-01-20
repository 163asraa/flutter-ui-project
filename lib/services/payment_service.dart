import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentService {
  static Future<String?> startCheckout(String cartId, String token) async {
    final url = Uri.parse("http://127.0.0.1:8000/api/orders/$cartId/pay/");

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['session_url'];
    } else {
      print("⚠️ Error: ${response.statusCode} - ${response.body}");
      return null;
    }
  }
}
