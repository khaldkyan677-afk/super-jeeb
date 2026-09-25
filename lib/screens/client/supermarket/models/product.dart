class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String category;
  final bool isAvailable;
  final Map<String, dynamic> dynamicFields;
  Product({required this.id, required this.name, required this.price,
    required this.imageUrl, required this.category,
    this.isAvailable = true, this.dynamicFields = const {}});
  factory Product.fromJson(Map<String, dynamic> j) => Product(
    id: j['_id'] ?? '', name: j['name'] ?? '',
    price: (j['price'] ?? 0).toDouble(),
    imageUrl: j['imageUrl'] ?? '', category: j['category'] ?? '',
    isAvailable: j['isAvailable'] ?? true,
    dynamicFields: j['dynamicFields'] ?? {},
  );
}
