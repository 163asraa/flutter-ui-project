
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supa_electronics/const/color.dart';
import 'package:supa_electronics/const/const.dart';
import '../services/api_service.dart';
import '../models/cart.dart';
import '../providers/auth_provider.dart';
import '../widgets/cart_item_widget.dart';
import 'payment_screen.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen>
    with SingleTickerProviderStateMixin {
 Future<Cart?>? _cartFuture;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  bool _isLoadingCheckout = false;

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

    _initCart();
  }

  Future<void> _initCart() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.loadToken();

    print("🔥 Token من AuthProvider: '${authProvider.token}'");

    if (authProvider.token != null && authProvider.token!.isNotEmpty) {
      setState(() {
        _cartFuture = ApiService(token: authProvider.token!.trim()).fetchCart();
      });
    } else {
      print("⚠️ التوكن فارغ، الرجاء تسجيل الدخول أولاً");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(130),
        child: Stack(
          children: [
            ClipPath(
              clipper: TopWaveClipper(),
              child: Container(
                height: 140,
                color: AppColors.secondary,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40, right: 16, left: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    "سلتي",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 48),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, theme.colorScheme.surface],
          ),
        ),
        child: FutureBuilder<Cart?>(
          future: _cartFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                snapshot.connectionState == ConnectionState.none) {
              // Loader أثناء التحميل
              return Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                ),
              );
            } else if (snapshot.hasError) {
              return _errorCard(theme, 'حدث خطأ أثناء تحميل السلة');
            }

            final cart = snapshot.data;

            if (cart == null || cart.items.isEmpty) {
              return _errorCard(theme, 'سلتك فارغة');
            }

            final token = Provider.of<AuthProvider>(context, listen: false).token!;

            return FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  Expanded(
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      margin: EdgeInsets.all(16),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemCount: cart.items.length,
                          itemBuilder: (context, index) {
                            final cartItem = cart.items[index];
                            return CartItemWidget(
                              item: cartItem,
                              cartId: cart.cartcode,
                              token: token,
                              onItemChanged: () {
                                setState(() {
                                  _cartFuture =
                                      ApiService(token: token).fetchCart();
                                });
                              },
                              onDelete: () {
                                setState(() {
                                  _cartFuture =
                                      ApiService(token: token).fetchCart();
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'الإجمالي: \$${cart.grandTotal.toStringAsFixed(2)}',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          _isLoadingCheckout
                              ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      theme.colorScheme.primary),
                                )
                              : ElevatedButton(
                                  onPressed: () async {
                                    setState(() => _isLoadingCheckout = true);
                                    try {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PaymentScreen(cartId: cart.cartcode),
                                        ),
                                      );
                                      setState(() {
                                        _cartFuture =
                                            ApiService(token: token).fetchCart();
                                      });
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(content: Text('خطأ: $e')),
                                      );
                                    } finally {
                                      setState(() => _isLoadingCheckout = false);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.secondary,
                                    foregroundColor: theme.colorScheme.onPrimary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 24),
                                    elevation: 4,
                                  ),
                                  child: Text(
                                    'تأكيد الطلب',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _errorCard(ThemeData theme, String message) {
    return Center(
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            message,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
