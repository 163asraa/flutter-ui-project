// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:supa_electronics/const/color.dart';
// import '../services/api_service.dart';
// import '../models/order.dart';
// import '../providers/auth_provider.dart';
// import 'package:cached_network_image/cached_network_image.dart';

// class OrderScreen extends StatefulWidget {
//   @override
//   _OrderScreenState createState() => _OrderScreenState();
// }

// class _OrderScreenState extends State<OrderScreen>
//     with SingleTickerProviderStateMixin {
//   late Future<List<Order>> _ordersFuture;
//   late AnimationController _controller;
//   late Animation<double> _fadeAnimation;

//   @override
//   void initState() {
//     super.initState();
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     _ordersFuture = ApiService(token: authProvider.token!).fetchOrders();

//     _controller = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 800),
//     );
//     _fadeAnimation =
//         CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
//     _controller.forward();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'طلباتي',
//           style: theme.textTheme.titleLarge?.copyWith(
//             fontWeight: FontWeight.bold,
//             color: theme.colorScheme.onPrimary,
//           ),
//         ),
//         backgroundColor: AppColors.secondary,
//         elevation: 4,
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//                 Colors.white,
//               theme.colorScheme.surface,
//             ],
//           ),
//         ),
//         child: FutureBuilder<List<Order>>(
//           future: _ordersFuture,
// builder: (context, snapshot) {
//   if (snapshot.connectionState == ConnectionState.waiting) {
//     return Center(child: CircularProgressIndicator());
//   }
//   if (snapshot.hasError) {
//     return Center(child: Text('Error: ${snapshot.error}'));
//   }
//   final orders = snapshot.data ?? [];
//   if (orders.isEmpty) {
//     return Center(child: Text('No orders found.'));
//   }
//   return FadeTransition(
//     opacity: _fadeAnimation,
//     child: Padding(
//       padding: EdgeInsets.all(16.0),
//       child: ListView.builder(
//         itemCount: orders.length,
//         itemBuilder: (context, index) {
//           final order = orders[index];
//           final items = order.items ?? [];

//           return Card(
//             elevation: 8,
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16)),
//             margin: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
//             child: ExpansionTile(
//               leading: Icon(
//                 Icons.receipt,
//                 color: AppColors.secondary,
//                 size: 30,
//               ),
//               title: Text(
//                 'Order #${order.id ?? ''}',
//                 style: theme.textTheme.titleMedium?.copyWith(
//                   fontWeight: FontWeight.bold,
//                   color: theme.colorScheme.onSurface,
//                 ),
//               ),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Status: ${order.pendingStatus ?? ''}',
//                     style: theme.textTheme.bodyMedium?.copyWith(
//                       color: theme.colorScheme.onSurface.withOpacity(0.8),
//                     ),
//                   ),
//                   Text(
//                     'Placed: ${order.sendAt ?? ''}',
//                     style: theme.textTheme.bodyMedium?.copyWith(
//                       color: theme.colorScheme.onSurface.withOpacity(0.8),
//                     ),
//                   ),
//                 ],
//               ),
//               children: items.map<Widget>((item) {
//                 final product = item.product;
//                 final imageUrl = product?.image ?? '';
//                 final productName = product?.name ?? 'Unknown';

//                 return ListTile(
//                   leading: ClipRRect(
//                     borderRadius: BorderRadius.circular(8),
//                     child: imageUrl.isNotEmpty
//                         ? CachedNetworkImage(
//                             imageUrl: imageUrl,
//                             width: 50,
//                             height: 50,
//                             fit: BoxFit.cover,
//                             placeholder: (context, url) => Center(
//                               child: CircularProgressIndicator(
//                                 valueColor: AlwaysStoppedAnimation<Color>(
//                                     theme.colorScheme.primary),
//                               ),
//                             ),
//                             errorWidget: (context, url, error) => Icon(
//                               Icons.error,
//                               color: theme.colorScheme.error,
//                               size: 30,
//                             ),
//                           )
//                         : Icon(Icons.image_not_supported, color: theme.colorScheme.error),
//                   ),
//                   title: Text(
//                     productName,
//                     style: theme.textTheme.titleMedium?.copyWith(
//                       color: theme.colorScheme.onSurface,
//                     ),
//                   ),
//                   subtitle: Text(
//                     'Quantity: ${item.quantity ?? ''}',
//                     style: theme.textTheme.bodyMedium?.copyWith(
//                       color: theme.colorScheme.onSurface.withOpacity(0.8),
//                     ),
//                   ),
//                 );
//               }).toList(),
//             ),
//           );
//         },
//       ),
//     ),
//   );
// }
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:supa_electronics/const/const.dart';
// import '../models/order.dart';
// import '../services/api_service.dart';


// class OrderScreen extends StatefulWidget {
//   const OrderScreen({super.key});

//   @override
//   State<OrderScreen> createState() => _OrderScreenState();
// }

// class _OrderScreenState extends State<OrderScreen> {
//   List<Order> _orders = [];
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadOrders();
//   }

//   Future<void> _loadOrders() async {
//     try {
//       final apiService = Provider.of<ApiService>(context, listen: false);
//       final orders = await apiService.getOrders();
//       setState(() {
//         _orders = orders;
//         _isLoading = false;
//       });
//     } catch (e) {
//       print('Error loading orders: $e');
//       setState(() => _isLoading = false);
//     }
//   }

//   Widget _buildStatusChip(String status, String currentStatus) {
//     final bool isActive = currentStatus == status;
//     return Chip(
//       label: Text(
//         status,
//         style: TextStyle(
//           color: isActive ? Colors.white : Colors.black,
//         ),
//       ),
//       backgroundColor: isActive ? Colors.deepPurple : Colors.grey.shade200,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Stack(
//               children: [
//                 ClipPath(
//                   clipper: TopWaveClipper(),
//                   child: Container(
//                     height: 180,
//                     color: Colors.deepPurple,
//                   ),
//                 ),
//                 SafeArea(
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 30, left: 16, right: 16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         const Center(
//                           child: Text(
//                             'طلباتي',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 22,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         Expanded(
//                           child: _orders.isEmpty
//                               ? const Center(child: Text('لا يوجد طلبات'))
//                               : ListView.builder(
//                                   itemCount: _orders.length,
//                                   itemBuilder: (ctx, i) {
//                                     final order = _orders[i];
//                                     return Card(
//                                       elevation: 4,
//                                       margin: const EdgeInsets.symmetric(vertical: 8),
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(16),
//                                         child: Column(
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               'طلب رقم: ${order.id}',
//                                               style: const TextStyle(
//                                                 fontSize: 16,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                             const SizedBox(height: 10),
//                                             ...order.items.map(
//                                               (item) => Text(
//                                                 '- ${item.name} × ${item.quantity}',
//                                               ),
//                                             ),
//                                             const SizedBox(height: 10),
//                                             Text(
//                                               'المجموع: \$${order.total.toStringAsFixed(2)}',
//                                               style: const TextStyle(fontWeight: FontWeight.bold),
//                                             ),
//                                             const SizedBox(height: 10),
//                                             Text(
//                                               'التاريخ: ${order.sendAt}',
//                                               style: const TextStyle(color: Colors.grey),
//                                             ),
//                                             const SizedBox(height: 10),
//                                             Wrap(
//                                               spacing: 6,
//                                               children: [
//                                                 _buildStatusChip('جديد', order.status),
//                                                 _buildStatusChip('قيد المعالجة', order.status),
//                                                 _buildStatusChip('تم الشحن', order.status),
//                                                 _buildStatusChip('تم التوصيل', order.status),
//                                                 _buildStatusChip('ملغى', order.status),
//                                               ],
//                                             ),
//                                             const SizedBox(height: 10),
//                                             if (order.status != 'ملغى' &&
//                                                 order.status != 'تم التوصيل')
//                                               ElevatedButton(
//                                                 onPressed: () {
//                                                   setState(() {
//                                                     order.status = 'ملغى';
//                                                   });
//                                                   ScaffoldMessenger.of(context).showSnackBar(
//                                                     const SnackBar(
//                                                       content: Text('تم إلغاء الطلب بنجاح'),
//                                                     ),
//                                                   );
//                                                 },
//                                                 style: ElevatedButton.styleFrom(
//                                                   backgroundColor: Colors.red,
//                                                 ),
//                                                 child: const Text('إلغاء الطلب'),
//                                               ),
//                                           ],
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:supa_electronics/const/color.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:url_launcher/url_launcher.dart';

// import '../services/api_service.dart';
// import '../models/order.dart';
// import '../providers/auth_provider.dart';
// import '../const/const.dart';

// class OrderScreen extends StatefulWidget {
//   @override
//   _OrderScreenState createState() => _OrderScreenState();
// }

// class _OrderScreenState extends State<OrderScreen>
//     with SingleTickerProviderStateMixin, WidgetsBindingObserver {
//   late Future<List<Order>> _ordersFuture;
//   late AnimationController _controller;
//   late Animation<double> _fadeAnimation;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     _ordersFuture = ApiService(token: authProvider.token!).fetchOrders();

//     _controller = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 800),
//     );
//     _fadeAnimation =
//         CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
//     _controller.forward();
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     _controller.dispose();
//     super.dispose();
//   }

//   // ✅ تحديث الطلبات عند العودة للتطبيق
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed) {
//       final authProvider = Provider.of<AuthProvider>(context, listen: false);
//       setState(() {
//         _ordersFuture = ApiService(token: authProvider.token!).fetchOrders();
//       });
//     }
//   }

//   Future<void> _startPayment(String orderId) async {
//     final token = Provider.of<AuthProvider>(context, listen: false).token;
//     final api = ApiService(token: token!);
//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: Text('تأكيد الدفع'),
//         content: Text('هل أنت متأكد أنك تريد إتمام عملية الدفع؟'),
//         actions: [
//           TextButton(
//               onPressed: () => Navigator.pop(ctx, false), child: Text('إلغاء')),
//           ElevatedButton(
//               onPressed: () => Navigator.pop(ctx, true), child: Text('تأكيد')),
//         ],
//       ),
//     );

//     if (confirmed != true) return;

//     final sessionUrl = await api.initiatePayment(orderId);

//     if (sessionUrl != null) {
//       final uri = Uri.parse(sessionUrl);
//       if (await canLaunchUrl(uri)) {
//         await launchUrl(uri, mode: LaunchMode.externalApplication);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("تم بدء عملية الدفع بنجاح")),
//         );
//       } else {
//         ScaffoldMessenger.of(context)
//             .showSnackBar(SnackBar(content: Text("لا يمكن فتح رابط الدفع")));
//       }
//     } else {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text("فشل بدء عملية الدفع")));
//     }
//   }


// Widget _buildHeader() {
//   return Container(
//     width: double.infinity,
//     height: 100,
//     decoration: BoxDecoration(
//       color: AppColors.secondary,
//       borderRadius: BorderRadius.only(
//         bottomLeft: Radius.circular(32),
//         bottomRight: Radius.circular(32),
//       ),
//     ),
//     child: Stack(
//       children: [
//         ClipRRect(
//           borderRadius: BorderRadius.only(
//             bottomLeft: Radius.circular(34),
//             bottomRight: Radius.circular(34),
//           ),
//           child: Image.asset(
//             "assets/image2.jpg",
//             fit: BoxFit.fitWidth,
//             width: double.infinity,
//           ),
//         ),
//         Container(
//           height: 300,
//           decoration: BoxDecoration(
//             color: const Color.fromARGB(137, 18, 62, 68),
//             borderRadius: BorderRadius.only(
//               bottomLeft: Radius.circular(32),
//               bottomRight: Radius.circular(32),
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(top: 60.0, right: 30, left: 30),
//           child: Container(
//             width: double.infinity,
//             height: 20,
//             decoration: BoxDecoration(
//               color: const Color.fromARGB(136, 255, 255, 255),
//               borderRadius: BorderRadius.all(Radius.circular(32)),
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(top: 34.0, right: 30, left: 30),
//           child: Container(
//             height: 40,
//             decoration: BoxDecoration(
//               color: const Color.fromARGB(0, 255, 255, 255),
//               borderRadius: BorderRadius.all(Radius.circular(32)),
//             ),
//             child: Center(
//               child: Text(
//                 "استعرض الطلبات",
//                 style: TextStyle(
//                   fontSize: 30,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Scaffold(
//       body: Column(
//         children: [
//         _buildHeader(),

//           Expanded(
//             child: Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [Colors.white, theme.colorScheme.surface],
//                 ),
//               ),
//               child: FutureBuilder<List<Order>>(
//                 future: _ordersFuture,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Center(child: CircularProgressIndicator());
//                   }
//                   if (snapshot.hasError) {
//                     return Center(child: Text('حدث خطأ: ${snapshot.error}'));
//                   }
//                   final orders = snapshot.data ?? [];
//                   if (orders.isEmpty) {
//                     return Center(child: Text('لا توجد طلبات.'));
//                   }

//                   return FadeTransition(
//                     opacity: _fadeAnimation,
//                     child: Padding(
//                       padding: EdgeInsets.all(16.0),
//                       child: ListView.builder(
//                         itemCount: orders.length,
//                         itemBuilder: (context, index) {
//                           final order = orders[index];
//                           final items = order.items ?? [];

//                           double total = items.fold(
//                               0,
//                               (sum, item) =>
//                                   sum +
//                                   (double.tryParse(
//                                           item.product?.price?.toString() ??
//                                               '0') ??
//                                       0) *
//                                       item.quantity);

//                           final isPaid =
//                               order.pendingStatus?.toLowerCase() == 'p';

//                           return Card(
//                             elevation: 8,
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(16)),
//                             margin: EdgeInsets.symmetric(vertical: 8),
//                             child: ExpansionTile(
//                               leading: Icon(Icons.receipt_long_rounded,
//                                   color: AppColors.secondary),
//                               title: Text(
//                                 'طلب رقم #${order.id ?? ''}',
//                                 style: theme.textTheme.titleMedium?.copyWith(
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               subtitle: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   SizedBox(height: 8),
//                                   Text('حالة الدفع:',
//                                       style: theme.textTheme.bodyMedium),
//                                   Wrap(
//                                     spacing: 8.0,
//                                     children: ['مدفوع', 'غير مدفوع']
//                                         .map((status) {
//                                       final isActive = isPaid
//                                           ? status == 'مدفوع'
//                                           : status == 'غير مدفوع';
//                                       return Chip(
//                                         label: Text(status,
//                                             style: TextStyle(
//                                                 color: isActive
//                                                     ? Colors.white
//                                                     : Colors.black87,
//                                                 fontWeight: FontWeight.bold)),
//                                         backgroundColor: isActive
//                                             ? (status == 'مدفوع'
//                                                 ? Colors.green
//                                                 : Colors.red)
//                                             : Colors.grey[300],
//                                       );
//                                     }).toList(),
//                                   ),
//                                   SizedBox(height: 6),
//                                   Text(
//                                     'تاريخ الطلب: ${order.sendAt ?? ''}',
//                                     style: theme.textTheme.bodySmall,
//                                   ),
//                                   Text(
//                                     'السعر الإجمالي: ${total.toStringAsFixed(0)} ل.س',
//                                     style: theme.textTheme.bodyMedium?.copyWith(
//                                       fontWeight: FontWeight.bold,
//                                       color: AppColors.secondary,
//                                     ),
//                                   ),
//                                   if (!isPaid)
//                                     Align(
//                                       alignment: Alignment.centerRight,
//                                       child: TextButton.icon(
//                                         style: TextButton.styleFrom(
//                                           backgroundColor: Colors.green,
//                                           foregroundColor: Colors.white,
//                                         ),
//                                         onPressed: () =>
//                                             _startPayment(order.id.toString()),
//                                         icon: Icon(Icons.payment),
//                                         label: Text("ادفع الآن"),
//                                       ),
//                                     )
//                                 ],
//                               ),
//                               children: items.map<Widget>((item) {
//                                 final product = item.product;
//                                 final imageUrl = product?.image ?? '';
//                                 final productName = product?.name ?? 'بدون اسم';

//                                 return ListTile(
//                                   leading: ClipRRect(
//                                     borderRadius: BorderRadius.circular(8),
//                                     child: imageUrl.isNotEmpty
//                                         ? CachedNetworkImage(
//                                             imageUrl: imageUrl,
//                                             width: 50,
//                                             height: 50,
//                                             fit: BoxFit.cover,
//                                             placeholder: (context, url) =>
//                                                 CircularProgressIndicator(),
//                                             errorWidget: (context, url, error) =>
//                                                 Icon(Icons.image),
//                                           )
//                                         : Icon(Icons.image,
//                                             color: theme.colorScheme.onSurface),
//                                   ),
//                                   title: Text(
//                                     productName,
//                                     style: theme.textTheme.titleMedium,
//                                   ),
//                                   subtitle: Text(
//                                     'الكمية: ${item.quantity ?? '0'}',
//                                     style: theme.textTheme.bodySmall,
//                                   ),
//                                 );
//                               }).toList(),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }





import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supa_electronics/const/color.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/api_service.dart';
import '../models/order.dart';
import '../providers/auth_provider.dart';
import '../const/const.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late Future<List<Order>> _ordersFuture;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _ordersFuture = ApiService(token: authProvider.token!).fetchOrders();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      setState(() {
        _ordersFuture = ApiService(token: authProvider.token!).fetchOrders();
      });
    }
  }

  Future<void> _startPayment(String orderId) async {
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    final api = ApiService(token: token!);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('تأكيد الدفع'),
        content: Text('هل أنت متأكد أنك تريد إتمام عملية الدفع؟'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false), child: Text('إلغاء')),
          ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true), child: Text('تأكيد')),
        ],
      ),
    );

    if (confirmed != true) return;

    final sessionUrl = await api.initiatePayment(orderId);

    if (sessionUrl != null) {
      final uri = Uri.parse(sessionUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("تم بدء عملية الدفع بنجاح")),
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("لا يمكن فتح رابط الدفع")));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("فشل بدء عملية الدفع")));
    }
  }

  String paymentStatus(String? status) {
    switch (status?.toUpperCase()) {
      case 'P':
        return 'مدفوع';
      case 'C':
        return 'مكتمل';
      default:
        return 'غير مدفوع';
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
          ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(34),
              bottomRight: Radius.circular(34),
            ),
            child: Image.asset(
              "assets/image2.jpg",
              fit: BoxFit.fitWidth,
              width: double.infinity,
            ),
          ),
          Container(
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
                color: const Color.fromARGB(136, 255, 255, 255),
                borderRadius: BorderRadius.all(Radius.circular(32)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 34.0, right: 30, left: 30),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: const Color.fromARGB(0, 255, 255, 255),
                borderRadius: BorderRadius.all(Radius.circular(32)),
              ),
              child: Center(
                child: Text(
                  "استعرض الطلبات",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, theme.colorScheme.surface],
                ),
              ),
              child: FutureBuilder<List<Order>>(
                future: _ordersFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('حدث خطأ: ${snapshot.error}'));
                  }
                  final orders = snapshot.data ?? [];
                  if (orders.isEmpty) {
                    return Center(child: Text('لا توجد طلبات.'));
                  }

                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: ListView.builder(
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          final order = orders[index];
                          final items = order.items ?? [];

                          double total = items.fold(
                              0,
                              (sum, item) =>
                                  sum +
                                  (double.tryParse(
                                          item.product?.price?.toString() ?? '0') ??
                                      0) *
                                      item.quantity);

                          final statusText = paymentStatus(order.pendingStatus);

                          return Card(
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: ExpansionTile(
                              leading: Icon(Icons.receipt_long_rounded,
                                  color: AppColors.secondary),
                              title: Text(
                                'طلب رقم #${order.id ?? ''}',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 8),
                                  Text('حالة الدفع:',
                                      style: theme.textTheme.bodyMedium),
                                  Wrap(
                                    spacing: 8.0,
                                    children: ['مدفوع', 'مكتمل', 'غير مدفوع']
                                        .map((status) {
                                      final isActive = statusText == status;
                                      return Chip(
                                        label: Text(status,
                                            style: TextStyle(
                                                color: isActive
                                                    ? Colors.white
                                                    : Colors.black87,
                                                fontWeight: FontWeight.bold)),
                                        backgroundColor: isActive
                                            ? (status == 'مدفوع'
                                                ? Colors.green
                                                : (status == 'مكتمل'
                                                    ? Colors.blue
                                                    : Colors.red))
                                            : Colors.grey[300],
                                      );
                                    }).toList(),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    'تاريخ الطلب: ${order.sendAt ?? ''}',
                                    style: theme.textTheme.bodySmall,
                                  ),
                                  Text(
                                    'السعر الإجمالي: ${total.toStringAsFixed(0)} ل.س',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.secondary,
                                    ),
                                  ),
                                  if (statusText == 'غير مدفوع')
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton.icon(
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          foregroundColor: Colors.white,
                                        ),
                                        onPressed: () =>
                                            _startPayment(order.id.toString()),
                                        icon: Icon(Icons.payment),
                                        label: Text("ادفع الآن"),
                                      ),
                                    )
                                ],
                              ),
                              children: items.map<Widget>((item) {
                                final product = item.product;
                                final imageUrl = product?.image ?? '';
                                final productName = product?.name ?? 'بدون اسم';

                                return ListTile(
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: imageUrl.isNotEmpty
                                        ? CachedNetworkImage(
                                            imageUrl: imageUrl,
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                CircularProgressIndicator(),
                                            errorWidget: (context, url, error) =>
                                                Icon(Icons.image),
                                          )
                                        : Icon(Icons.image,
                                            color: theme.colorScheme.onSurface),
                                  ),
                                  title: Text(
                                    productName,
                                    style: theme.textTheme.titleMedium,
                                  ),
                                  subtitle: Text(
                                    'الكمية: ${item.quantity ?? '0'}',
                                    style: theme.textTheme.bodySmall,
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
