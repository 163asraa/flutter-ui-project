class ProductDetail {
  final int id;
  final String name;
  final double price;
  final String image;
  final String content;
  final String description;
  final String productType;
  final String companyName;
  final double discount;

  ProductDetail({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.content,
    required this.description,
    required this.productType,
    required this.companyName,
    this.discount = 0,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    return ProductDetail(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name']?.toString() ?? 'Unknown',
      price: double.tryParse(json['price']?.toString() ?? '') ?? 0.0,
      image: json['image']?.toString() ?? '', // ✅ يحل مشكلة null
      content: json['content']?.toString() ?? 'No content',
      description: json['description']?.toString() ?? 'No description',
      productType: json['producttype']?.toString() ?? 'Unknown',
      companyName: json['company_name']?.toString() ?? 'Unknown',
      discount: double.tryParse(json['discount']?.toString() ?? '') ?? 0.0,
    );
  }
}
