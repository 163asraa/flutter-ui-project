// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:supa_electronics/const/color.dart';
// import '../models/product_detail.dart';
// import '../services/api_service.dart';
// import '../providers/auth_provider.dart';
// import 'package:cached_network_image/cached_network_image.dart';

// class ProductDetailScreen extends StatefulWidget {
//   final ProductDetail product;

//   const ProductDetailScreen({Key? key, required this.product})
//       : super(key: key);

//   @override
//   _ProductDetailScreenState createState() => _ProductDetailScreenState();
// }

// class _ProductDetailScreenState extends State<ProductDetailScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _fadeAnimation;
//   bool _isLoading = false;
//   bool showCartIcon = false;


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
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);
//     final theme = Theme.of(context);

//     return Scaffold(
//       // appBar: AppBar(
//       //   title: Text(
//       //     widget.product.name,
//       //     style: theme.textTheme.titleLarge?.copyWith(
//       //       fontWeight: FontWeight.bold,
//       //       color: const Color.fromARGB(255, 2, 2, 2),
//       //     ),
//       //   ),
//       //   backgroundColor:AppColors.secondary,
//       //   elevation: 4,
//       // ),
//       appBar: AppBar(
//   title: Text(
//     widget.product.name,
//     style: theme.textTheme.titleLarge?.copyWith(
//       fontWeight: FontWeight.bold,
//       color: const Color.fromARGB(255, 241, 237, 237),
//     ),
//   ),
//   backgroundColor: AppColors.secondary,
//   elevation: 4,
// // actions: [
// //   IconButton(
// //     icon: Icon(Icons.shopping_cart,color: Colors.white,),
// //     onPressed: () async {
// //       try {
// //         final apiService = ApiService(token: authProvider.token!);
// //         final cart = await apiService.fetchCart(); // جلب السلة من الباك

// //         if (cart != null) {
// //           Navigator.pushNamed(
// //             context,
// //             '/cart',
// //             arguments: cart, // تمرير السلة لواجهة السلة
// //           );
// //         } else {
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             SnackBar(content: Text('لا توجد سلة لهذا المستخدم')),
// //           );
// //         }
// //       } catch (e) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(content: Text('حدث خطأ: $e')),
// //         );
// //       }
// //     },
// //   ),
// // ],

// ),

//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               const Color.fromARGB(255, 187, 192, 191),
//               const Color.fromARGB(255, 175, 191, 192),
//             ],
//           ),
//         ),
//         child: SingleChildScrollView(
//           child: FadeTransition(
//             opacity: _fadeAnimation,
//             child: Card(
//               elevation: 8,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16)),
//               margin: EdgeInsets.all(16),
//               child: Padding(
//                 padding: EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(12),
//                       child: CachedNetworkImage(
//                         imageUrl: widget.product.image,
//                         height: 300,
//                         width: double.infinity,
//                         fit: BoxFit.cover,
//                         placeholder: (context, url) => Center(
//                           child: CircularProgressIndicator(
//                             valueColor: AlwaysStoppedAnimation<Color>(
//                                 theme.colorScheme.primary),
//                           ),
//                         ),
//                         errorWidget: (context, url, error) => Icon(
//                           Icons.error,
//                           color: theme.colorScheme.error,
//                           size: 60,
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 16),
//                     Text(
//                       widget.product.name,
//                       style: theme.textTheme.headlineSmall?.copyWith(
//                         fontWeight: FontWeight.bold,
//                         color: theme.colorScheme.onSurface,
//                       ),
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       '\$${widget.product.price.toStringAsFixed(2)}',
//                       style: theme.textTheme.titleLarge?.copyWith(
//                         color: theme.colorScheme.primary,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     SizedBox(height: 12),
//                     _buildInfoRow(
//                       context,
//                       icon: Icons.business,
//                       label: 'Company',
//                       value: widget.product.companyName,
//                     ),
//                     _buildInfoRow(
//                       context,
//                       icon: Icons.category,
//                       label: 'Type',
//                       value: widget.product.productType,
//                     ),
//                     SizedBox(height: 16),
//                     Text(
//                       'Description',
//                       style: theme.textTheme.titleMedium?.copyWith(
//                         fontWeight: FontWeight.bold,
//                         color: theme.colorScheme.onSurface,
//                       ),
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       widget.product.description,
//                       style: theme.textTheme.bodyLarge?.copyWith(
//                         color: theme.colorScheme.onSurface.withOpacity(0.8),
//                       ),
//                     ),
//                     SizedBox(height: 16),
//                     Text(
//                       'Content',
//                       style: theme.textTheme.titleMedium?.copyWith(
//                         fontWeight: FontWeight.bold,
//                         color: theme.colorScheme.onSurface,
//                       ),
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       widget.product.content,
//                       style: theme.textTheme.bodyLarge?.copyWith(
//                         color: theme.colorScheme.onSurface.withOpacity(0.8),
//                       ),
//                     ),
//                     SizedBox(height: 24),
//                     _isLoading
//                         ? Center(
//                             child: CircularProgressIndicator(
//                               valueColor: AlwaysStoppedAnimation<Color>(
//                                   theme.colorScheme.primary),
//                             ),
//                           )
//                         : ElevatedButton(
//                            /* onPressed: () async {
//                               setState(() => _isLoading = true);
//                               try {
//                                 final apiService =
//                                     ApiService(token: authProvider.token!);
//                                 final cart = await apiService.fetchCart();

//                                 if (cart != null) {
//                                   await apiService.addToCart(
//                                       cart.cartcode, widget.product.id, 1);
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(content: Text('Added to cart')),
//                                   );
//                                 } else {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(
//                                         content:
//                                             Text('No cart found for user')),
//                                   );
//                                 }
//                               } catch (e) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(content: Text('Error: $e')),
//                                 );
//                               } finally {
//                                 setState(() => _isLoading = false);
//                               }
//                             },*/
// onPressed: () async {
//   setState(() => _isLoading = true);
//   try {
//     final apiService = ApiService(token: authProvider.token!);
//     final cart = await apiService.fetchCart();

//     if (cart != null) {
//   await apiService.addToCart(cart.cartcode, widget.product.id, 1);

// setState(() {
//   showCartIcon = true; // ✅ هذا اللي بيفعّل ظهور الأيقونة
// });

// ScaffoldMessenger.of(context).showSnackBar(
//   SnackBar(content: Text('Added to cart')),
// );

      
//       // الانتقال لواجهة السلة بعد الإضافة
//       Navigator.pushNamed(context, '/cart');
      
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('No cart found for user')),
//       );
//     }
//   } catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Error: $e')),
//     );
//   } finally {
//     setState(() => _isLoading = false);
//   }
// },

//                             style: ElevatedButton.styleFrom(
//                               backgroundColor:AppColors.secondary,
//                               foregroundColor: theme.colorScheme.onPrimary,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               padding: EdgeInsets.symmetric(
//                                   vertical: 12, horizontal: 24),
//                               elevation: 4,
//                             ),
//                             child: Text(
//                               'أضف إلى السلة',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoRow(BuildContext context,
//       {required IconData icon, required String label, required String value}) {
//     final theme = Theme.of(context);
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         children: [
//           Icon(icon, color: theme.colorScheme.primary, size: 20),
//           SizedBox(width: 8),
//           Text(
//             '$label: ',
//             style: theme.textTheme.bodyMedium?.copyWith(
//               fontWeight: FontWeight.w600,
//               color: theme.colorScheme.onSurface,
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: theme.textTheme.bodyMedium?.copyWith(
//                 color: theme.colorScheme.onSurface.withOpacity(0.8),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:supa_electronics/const/color.dart';
import 'package:supa_electronics/const/const.dart';
import '../models/product_detail.dart';
import '../services/api_service.dart';
import '../providers/auth_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductDetail product;
    final String token;
    

  const ProductDetailScreen({Key? key, required this.product, required this.token}) : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  bool _isLoading = false;
  bool showCartIcon = false;

  @override
  void initState() {
    super.initState();
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
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Stack(
          children: [
       Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Stack(
                children: [
                  ClipPath(
                    clipper: TopWaveClipper(),
                    child: Container(
                      height: 130,
                      color: AppColors.secondary,
                    ),
                  ),
                  Positioned(
                    top: 40,
                    left: 16,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Positioned.fill(
                    child: SafeArea(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            widget.product.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),


            Padding(
              padding: const EdgeInsets.only(top: 140),
              child: SingleChildScrollView(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    margin: EdgeInsets.all(16),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: widget.product.image,
                              height: 300,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      theme.colorScheme.primary),
                                ),
                              ),
                              errorWidget: (context, url, error) => Icon(
                                Icons.error,
                                color: theme.colorScheme.error,
                                size: 60,
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            widget.product.name,
                            textAlign: TextAlign.right,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'سعر: \$${widget.product.price.toStringAsFixed(2)}',
                            textAlign: TextAlign.right,
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 12),
                          _buildInfoRow(
                            context,
                            icon: Icons.business,
                            label: 'الشركة',
                            value: widget.product.companyName,
                          ),
                          _buildInfoRow(
                            context,
                            icon: Icons.category,
                            label: 'النوع',
                            value: widget.product.productType,
                          ),
                          Divider(height: 32),
                          _buildSectionTitle(context, 'الوصف'),
                          Text(
                            widget.product.description,
                            textAlign: TextAlign.right,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              height: 1.5,
                              color: theme.colorScheme.onSurface.withOpacity(0.8),
                            ),
                          ),
                          SizedBox(height: 16),
                          _buildSectionTitle(context, 'المحتوى'),
                          Text(
                            widget.product.content,
                            textAlign: TextAlign.right,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              height: 1.5,
                              color: theme.colorScheme.onSurface.withOpacity(0.8),
                            ),
                          ),
                          SizedBox(height: 16),
                        
                         
                          SizedBox(height: 24),
                          _isLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        theme.colorScheme.primary),
                                  ),
                                )
                              : ElevatedButton.icon(
                                  onPressed: () async {
                                    setState(() => _isLoading = true);
                                    try {
                                     
final authProvider = Provider.of<AuthProvider>(context, listen: false);
final token = authProvider.token;

if (token == null || token.isEmpty) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('الرجاء تسجيل الدخول أولاً')),
  );
  return;
}

final apiService = ApiService(token: token);


                                      final cart =
                                          await apiService.fetchCart();

                                      if (cart != null) {
                                        await apiService.addToCart(
                                            cart.cartcode,
                                            widget.product.id,
                                            1);

                                        setState(() {
                                          showCartIcon = true;
                                        });

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  'تمت الإضافة إلى السلة')),
                                        );

                                        Navigator.pushNamed(
                                            context, '/cart');
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  'لا توجد سلة لهذا المستخدم')),
                                        );
                                      }
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content:
                                                Text('حدث خطأ: $e')),
                                      );
                                    } finally {
                                      setState(() => _isLoading = false);
                                    }
                                  },
                                  icon: Icon(Icons.shopping_cart),
                                  label: Text('أضف إلى السلة'),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(double.infinity, 50),
                                    backgroundColor: AppColors.secondary,
                                    foregroundColor:
                                        theme.colorScheme.onPrimary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context,
      {required IconData icon,
      required String label,
      required String value}) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 20),
          SizedBox(width: 8),
          Text(
            '$label: ',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.8),
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Text(
      title,
      textAlign: TextAlign.right,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.onSurface,
      ),
    );
  }
}


