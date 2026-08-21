class Product {
  final String id;
  final String name;
  final String categoryId;
  final String categoryName;
  final String imageUrl;
  final double price;
  final double? originalPrice;
  final String unit;
  final double rating;
  final int reviewCount;
  final String description;
  final Map<String, String> nutrition;
  final bool inStock;
  final String? tag;
  final bool isFeatured;
  final bool isFlashSale;

  const Product({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.categoryName,
    required this.imageUrl,
    required this.price,
    this.originalPrice,
    required this.unit,
    this.rating = 4.8,
    this.reviewCount = 120,
    required this.description,
    this.nutrition = const {},
    this.inStock = true,
    this.tag,
    this.isFeatured = false,
    this.isFlashSale = false,
  });

  String get brand => tag ?? (name.split(' ').isNotEmpty ? name.split(' ').first : 'Grozzby');
  String get category => categoryName;

  int get discountPercent {
    if (originalPrice == null || originalPrice! <= price) return 0;
    return (((originalPrice! - price) / originalPrice!) * 100).round();
  }

  Product copyWith({
    String? id,
    String? name,
    String? categoryId,
    String? categoryName,
    String? imageUrl,
    double? price,
    double? originalPrice,
    String? unit,
    double? rating,
    int? reviewCount,
    String? description,
    Map<String, String>? nutrition,
    bool? inStock,
    String? tag,
    bool? isFeatured,
    bool? isFlashSale,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      unit: unit ?? this.unit,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      description: description ?? this.description,
      nutrition: nutrition ?? this.nutrition,
      inStock: inStock ?? this.inStock,
      tag: tag ?? this.tag,
      isFeatured: isFeatured ?? this.isFeatured,
      isFlashSale: isFlashSale ?? this.isFlashSale,
    );
  }
}
