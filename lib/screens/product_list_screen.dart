
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supa_electronics/const/color.dart';
import 'package:supa_electronics/const/const.dart';
import '../services/api_service.dart';
import '../models/product_detail.dart';
import '../widgets/product_card.dart';
import '../providers/auth_provider.dart';
import '../screens/profile_screen.dart'; // استيراد شاشة البروفايل لو عندك

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen>
    with SingleTickerProviderStateMixin {
  late Future<List<ProductDetail>> _productsFuture;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isGridView = true;
  final TextEditingController _searchController = TextEditingController();
  List<ProductDetail>? _filteredProducts;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _productsFuture = ApiService(token: authProvider.token!).fetchProducts();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutQuart,
    ));

    _controller.forward();
  }

  void _filterProducts(String query, List<ProductDetail> allProducts) {
    if (query.isEmpty) {
      setState(() {
        _filteredProducts = null;
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _filteredProducts = allProducts.where((product) {
        return product.name.toLowerCase().contains(query.toLowerCase()) ||
            product.description.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildEmptyState(ThemeData theme, String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 64,
              color: theme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 24),
          Text(
            message,
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Try again later or refresh the page',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _productsFuture = ApiService(
                  token: Provider.of<AuthProvider>(context, listen: false).token!,
                ).fetchProducts();
              });
            },
            icon: Icon(Icons.refresh),
            label: Text('Refresh'),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
Widget _buildHeader() {
  return Container(
    width: double.infinity,
    height: 100, // رفع الطول قليلاً ليظهر المستطيل
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
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(34),
            bottomRight: Radius.circular(34),
          ),
          child: Container(
            height: 300,
            color: const Color.fromARGB(137, 18, 62, 68),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'الرئيسية',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      _isGridView ? Icons.view_list : Icons.grid_view,
                      color: Colors.white,
                    ),
                    onPressed: () => setState(() => _isGridView = !_isGridView),
                    tooltip: _isGridView ? 'عرض قائمة' : 'عرض شبكة',
                  ),
                  IconButton(
                    icon: Icon(Icons.refresh, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _productsFuture = ApiService(
                          token: Provider.of<AuthProvider>(context, listen: false).token!,
                        ).fetchProducts();
                      });
                    },
                    tooltip: 'تحديث',
                  ),
                  IconButton(
                    icon: Icon(Icons.shopping_cart, color: Colors.white),
                    onPressed: () {
                      Navigator.pushNamed(context, '/cart');
                    },
                    tooltip: 'السلة',
                  ),
                  IconButton(
                    icon: Icon(Icons.account_circle, color: Colors.white, size: 28),
                    tooltip: 'الملف الشخصي',
                    onPressed: () {
                      final token = Provider.of<AuthProvider>(context, listen: false).token;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            final authProvider = Provider.of<AuthProvider>(context, listen: false);
                            return ProfileScreen(
                              token: authProvider.token!,
                              onLogout: () async {
                                await authProvider.logout();
                                Navigator.pushReplacementNamed(context, '/login');
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        // ✅ المستطيل الأبيض الشفاف
        Positioned(
          bottom: 27,
          left: 20,
          right: 20,
          child: Container(
            height: 20,
            decoration: BoxDecoration(
              color: const Color.fromARGB(90, 255, 255, 255),
              borderRadius: BorderRadius.circular(32),
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
    backgroundColor: Colors.white,
    body: Column(
      children: [
        _buildHeader(), // ✅ هذا الهيدر الجديد
        // ✅ Search Bar
        Container(
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'ابحث عن منتج...',
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _filterProducts('', _filteredProducts ?? []);
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) async {
                    final snapshot = await _productsFuture;
                    _filterProducts(value, snapshot);
                  },
                ),
              ),
            ],
          ),
        ),

        // ✅ Product List
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  theme.colorScheme.surface.withOpacity(0.5),
                ],
              ),
            ),
            child: FutureBuilder<List<ProductDetail>>(
              future: _productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              theme.colorScheme.primary),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'جاري تحميل المنتجات...',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return _buildEmptyState(
                    theme,
                    'حدث خطأ أثناء تحميل المنتجات',
                    Icons.error_outline,
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return _buildEmptyState(
                    theme,
                    'لا توجد منتجات متاحة',
                    Icons.inventory_2_outlined,
                  );
                }

                final allProducts = snapshot.data!;
                final displayedProducts =
                    _isSearching ? _filteredProducts ?? [] : allProducts;

                return GridView.builder(
                  padding: EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _isGridView ? 2 : 1,
                    childAspectRatio: _isGridView ? 0.7 : 1.2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: displayedProducts.length,
                  itemBuilder: (context, index) {
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: ProductCard(
                          isGridView: _isGridView,
                          product: displayedProducts[index],
                        ),
                      ),
                    );
                  },
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
