class Product {
  final String barcode;
  final String name;
  final String brand;
  final String imageUrl;
  final String ingredients;
  final String nutriScore;
  final Map<String, dynamic> nutrients;

  Product({
    required this.barcode,
    required this.name,
    required this.brand,
    required this.imageUrl,
    required this.ingredients,
    required this.nutriScore,
    required this.nutrients,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final product = json['product'];
    return Product(
      barcode: product['code'] ?? '',
      name: product['product_name'] ?? 'Unknown Product',
      brand: product['brands'] ?? 'Unknown Brand',
      imageUrl: product['image_url'] ?? '',
      ingredients: product['ingredients_text'] ?? 'No ingredients information',
      nutriScore: product['nutriscore_grade']?.toUpperCase() ?? 'Unknown',
      nutrients: product['nutriments'] ?? {},
    );
  }
} 