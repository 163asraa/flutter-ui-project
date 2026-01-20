class Company {
  final int id;
  final String name;
  final String category;

  Company({
    required this.id,
    required this.name,
    required this.category,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    // استخراج التصنيف من أول عنصر داخل product_types
    String category = 'أخرى';
    if (json.containsKey('product_types') && json['product_types'] is List && json['product_types'].isNotEmpty) {
      category = json['product_types'][0]['name'] ?? 'أخرى';
    }

    return Company(
      id: json['id'],
      name: json['name'],
      category: category,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
      };
}
