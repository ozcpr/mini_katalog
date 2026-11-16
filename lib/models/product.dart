/// Ürün veri modeli. JSON verisi bu sınıfa dönüştürülür.
class Product {
  final int id;
  final String name;
  final String category;
  final double price;
  final double rating;
  final String image;
  final String description;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    required this.image,
    required this.description,
  });

  /// JSON (Map) verisinden Product nesnesi üretir.
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      image: json['image'] as String,
      description: json['description'] as String,
    );
  }

  /// Product nesnesini JSON (Map) yapısına çevirir.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'rating': rating,
      'image': image,
      'description': description,
    };
  }
}
