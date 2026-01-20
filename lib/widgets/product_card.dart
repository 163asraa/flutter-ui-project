import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:supa_electronics/const/color.dart';
import '../models/product_detail.dart';
import '../screens/product_detail_screen.dart';
import '../theme/app_theme.dart';
class ProductCard extends StatelessWidget {
  final ProductDetail product;
  final bool isListView;
  final VoidCallback? onAddToCart;
  final bool isGridView;

  const ProductCard({
    required this.product,
    this.isListView = false,
    this.onAddToCart,
    Key? key, required this.isGridView,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isListView) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(product.name),
      );
    }

    return Container(
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(

        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
       
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product, token: '',)),
          ),
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: isGridView?140: 180,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      child: CachedNetworkImage(
                        imageUrl: product.image,
                        fit:isGridView? BoxFit.fill:BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: AppTheme.errorColor.withOpacity(0.1),
                          child: Icon(Icons.error_outline, color: AppTheme.errorColor),
                        ),
                      ),
                    ),
                    Positioned(
                      top:isGridView?100: 140,
                      left: 8,
                      right: 8,
                      child: Container(
                        
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          product.name,
                          style: TextStyle(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    if (product.discount > 0)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '-${product.discount}%',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            product.companyName,
                            style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                 //   SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (product.discount > 0)
                                Text(
                                  '\$${(product.price / (1 - product.discount / 100)).toStringAsFixed(2)}',
                                  style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey,
                                    fontSize: 10,
                                  ),
                                ),
                              Text(
                                '\$${product.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
  width: 36,
  height: 36,
  decoration: BoxDecoration(
    gradient: AppTheme.gradientPrimary,
    shape: BoxShape.circle,
    boxShadow: [
      BoxShadow(
        color: AppTheme.primaryColor.withOpacity(0.4),
        blurRadius: 10,
        offset: Offset(0, 4),
      ),
    ],
  ),
  child: IconButton(
    icon: Icon(Icons.add_shopping_cart, size: 18,color: Colors.white,), // حجم الأيقونة أصغر
    onPressed: onAddToCart,
    padding: EdgeInsets.zero, // يمنع المساحة الزائدة داخل الزر
    constraints: BoxConstraints(), // يمنع القياسات الافتراضية الكبيرة
  ),
),

                   
                       ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
