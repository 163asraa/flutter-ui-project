import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supa_electronics/const/color.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';
import '../providers/auth_provider.dart';
class PaymentScreen extends StatefulWidget {
  final String cartId;
  const PaymentScreen({super.key, required this.cartId});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? orderId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _createOrder(); // 🟢 ينشئ الطلب مباشرة عند فتح الشاشة
  }

  Future<void> _createOrder() async {
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    if (token == null) return;

    try {
      final api = ApiService(token: token);
      final createdOrderId = await api.createOrder(widget.cartId);
      setState(() {
        orderId = createdOrderId;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل إنشاء الطلب: $e')),
      );
    }
  }

  Future<void> _handlePayment() async {
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    if (token == null || orderId == null) return;

    final api = ApiService(token: token);
    final sessionUrl = await api.initiatePayment(orderId!);

    if (sessionUrl != null) {
      final uri = Uri.parse(sessionUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("لا يمكن فتح رابط الدفع")));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("فشل بدء عملية الدفع")));
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white, // ✅ لون خلفية الشاشة أبيض
    appBar: AppBar(
      backgroundColor: AppColors.secondary, // ✅ خلفية الشريط العلوي
      iconTheme: IconThemeData(color: Colors.white), // ✅ سهم الرجوع أبيض
      title: Text(
        'الدفع',
        style: TextStyle(color: Colors.white), // ✅ نص العنوان أبيض
      ),
    ),
    body: Center(
      child: isLoading
          ? CircularProgressIndicator()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ✅ الصورة في الأعلى
                Image.asset(
                  'assets/image4.png',
                  width: 400,
                  height: 400,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 24),
                Text(
                  "اضغط لإتمام عملية الدفع بأمان",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _handlePayment,
                  child: Text(
                    "أكمل عملية الدفع",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
    ),
  );
}

}
