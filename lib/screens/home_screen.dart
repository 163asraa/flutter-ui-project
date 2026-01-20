// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:supa_electronics/const/color.dart';
// import 'package:supa_electronics/const/const.dart';
// import '../providers/auth_provider.dart';
// import '../screens/product_list_screen.dart';
// import '../screens/cart_screen.dart';
// import '../screens/order_screen.dart';
// import '../screens/chat_screen.dart';
// import '../screens/image_upload_screen.dart';
// import '../screens/company_screen.dart'; // Assuming this screen exists or will be added

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _fadeAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 800),
//     );
//     _fadeAnimation =
//         CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
//     _controller.forward();

//     // Listen to auth state changes if needed (optional)
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     authProvider.addListener(_handleAuthStateChange);
//   }

//   void _handleAuthStateChange() {
//     if (!mounted) return; // Prevent updates if widget is disposed
//     setState(() {}); // Trigger rebuild if auth state changes
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     authProvider.removeListener(_handleAuthStateChange); // Clean up listener
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);
//     final theme = Theme.of(context);

//     // Check if user is authenticated
//     if (authProvider.token == null) {
//       // Optionally navigate to login screen or show a message
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//               content: Text('يرجى تسجيل الدخول للوصول إلى الصفحة الرئيسية')),
//         );
//         Navigator.pushReplacementNamed(
//             context, '/login'); // Adjust route as needed
//       });
//       return Scaffold(body: Center(child: CircularProgressIndicator()));
//     }

//     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(
// //           'Supa Electronics',
// //           style: theme.textTheme.titleLarge?.copyWith(
// //             fontWeight: FontWeight.bold,
// //             color: theme.colorScheme.onPrimary,
// //           ),
// //         ),
// //         backgroundColor: theme.colorScheme.primary,
// //         elevation: 4,
// //         actions: [
// //   IconButton(
// //   icon: Icon(Icons.logout, color: theme.colorScheme.onPrimary),
// //   tooltip: 'Logout',
// //   onPressed: () async {
// //     await authProvider.logout();
// //     if (!mounted) return;
// //    Navigator.of(context).pushNamedAndRemoveUntil('/welcome', (route) => false);

// //   },
// // ),

// //         ],
// //       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             DrawerHeader(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     theme.colorScheme.primary,
//                     theme.colorScheme.primary.withOpacity(0.7),
//                   ],
//                 ),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Text(
//                     'Welcome, ${authProvider.username ?? "User"}',
//                     style: theme.textTheme.titleLarge?.copyWith(
//                       color: theme.colorScheme.onPrimary,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     'Explore Supa Electronics',
//                     style: theme.textTheme.bodyMedium?.copyWith(
//                       color: theme.colorScheme.onPrimary.withOpacity(0.8),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             ListTile(
//               leading: Icon(Icons.store, color: theme.colorScheme.primary),
//               title: Text('Products', style: theme.textTheme.titleMedium),
//               onTap: () {
//                 Navigator.pop(context);
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => ProductListScreen()),
//                 );
//               },
//             ),
//             ListTile(
//               leading:
//                   Icon(Icons.shopping_cart, color: theme.colorScheme.primary),
//               title: Text('Cart', style: theme.textTheme.titleMedium),
//               onTap: () {
//                 Navigator.pop(context);
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => CartScreen()),
//                 );
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.history, color: theme.colorScheme.primary),
//               title: Text('Orders', style: theme.textTheme.titleMedium),
//               onTap: () {
//                 Navigator.pop(context);
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => OrderScreen()),
//                 );
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.chat, color: theme.colorScheme.primary),
//               title: Text('Chat', style: theme.textTheme.titleMedium),
//               onTap: () {
//                 Navigator.pop(context);
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => ChatScreen()),
//                 );
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.camera_alt, color: theme.colorScheme.primary),
//               title:
//                   Text('Search by Image', style: theme.textTheme.titleMedium),
//               onTap: () {
//                 Navigator.pop(context);
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => ImageUploadScreen()),
//                 );
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.business, color: theme.colorScheme.primary),
//               title: Text('الشركات', style: theme.textTheme.titleMedium),
//               onTap: () {
//                 Navigator.pop(context);
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => CompanyScreen()),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
// body: Stack(
//     children: [
//       ClipPath(
//         clipper: TopWaveClipper(),
//         child: Container(
//           height: 150,
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 AppColors.secondary,
//                 theme.colorScheme.primary.withOpacity(0.7),
//               ],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//       ),

//       // **هنا حطيت العنوان وزر Logout فوق الموجة**
//       Positioned(
//         top: 40,
//         left: 16,
//         right: 16,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               'Supa Electronics',
//               style: theme.textTheme.titleLarge?.copyWith(
//                 fontWeight: FontWeight.bold,
//                 color: theme.colorScheme.onPrimary,
//               ),
//             ),
//             IconButton(
//               icon: Icon(Icons.logout, color: theme.colorScheme.onPrimary),
//               tooltip: 'Logout',
//               onPressed: () async {
//                 await authProvider.logout();
//                 if (!mounted) return;
//                 Navigator.of(context).pushNamedAndRemoveUntil('/welcome', (route) => false);
//               },
//             ),
//           ],
//         ),
//       ),

//       Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               theme.colorScheme.primary.withOpacity(0.1),
//               theme.colorScheme.surface,
//             ],
//           ),
//         ),
//         child: Center(
//           child: FadeTransition(
//             opacity: _fadeAnimation,
//             child: Card(
//               elevation: 8,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               margin: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
//               child: Padding(
//                 padding: EdgeInsets.all(24),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(
//                       Icons.storefront,
//                       size: 60,
//                       color: theme.colorScheme.primary,
//                     ),
//                     SizedBox(height: 20),
//                     Text(
//                       'Welcome to Supa Electronics Store!',
//                       style: theme.textTheme.headlineSmall?.copyWith(
//                         fontWeight: FontWeight.bold,
//                         color: theme.colorScheme.onSurface,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     SizedBox(height: 10),
//                     Text(
//                       'Discover the latest electronics and gadgets.',
//                       style: theme.textTheme.bodyLarge?.copyWith(
//                         color: theme.colorScheme.onSurface.withOpacity(0.7),
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     SizedBox(height: 30),
//                     ElevatedButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (_) => ProductListScreen()),
//                         );
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: theme.colorScheme.primary,
//                         foregroundColor: theme.colorScheme.onPrimary,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
//                         elevation: 4,
//                       ),
//                       child: Text(
//                         'Shop Now',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     ],
//   ),


//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supa_electronics/const/color.dart';
import '../providers/auth_provider.dart';
import '../screens/product_list_screen.dart';
import '../screens/order_screen.dart';
import '../screens/chat_screen.dart';
import '../screens/company_screen.dart';
import '../screens/image_upload_screen.dart'; // ✅ استيراد شاشة الذكاء

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final theme = Theme.of(context);

  

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          ProductListScreen(),  // 0: المنتجات
          OrderScreen(),        // 1: الطلبات
          ChatScreen(
          //  roomName: 'admin',
           // token: authProvider.token!,
          ),                   // 2: الدردشة
          CompanyScreen(),      // 3: الشركات
ImageUploadScreen(),

        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
  currentIndex: _selectedIndex,
  onTap: _onItemTapped,
  type: BottomNavigationBarType.fixed,
  selectedItemColor: AppColors.secondary,
  unselectedItemColor: Colors.grey,
  selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
  unselectedLabelStyle: TextStyle(fontSize: 10),
  items: [
    BottomNavigationBarItem(
      icon: Icon(Icons.store),
      label: 'الرئيسية',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.history),
      label: 'الطلبات',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.chat),
      label: 'خدمة العملاء',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.business),
      label: 'الشركات',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.camera_alt),
      label: 'البحث بالذكاء',
    ),
  ],
),

    );
  }
}
