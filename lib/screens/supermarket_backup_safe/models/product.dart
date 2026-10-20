class Product {
  final String id;
  final String name;
  final double price;
  final double oldPrice;
  final int stock;
  final String imageUrl;
  final String category;
  final bool isAvailable;
  final Map<String, dynamic> dynamicFields;
  Product({required this.id, required this.name, required this.price,
    this.oldPrice = 0,
    this.stock = 0,
    required this.imageUrl, required this.category,
    this.isAvailable = true, this.dynamicFields = const {}});
  factory Product.fromJson(Map<String, dynamic> j) => Product(
    id: j['_id'] ?? '', name: j['name'] ?? '',
    price: (j['price'] ?? 0).toDouble(),
      oldPrice: (j['oldPrice'] ?? 0).toDouble(),
      stock: (j['stock'] ?? 0) is num ? (j['stock'] ?? 0).toInt() : 0,
    imageUrl: j['imageUrl'] ?? '', category: j['category'] ?? '',
    isAvailable: j['isAvailable'] ?? true,
    dynamicFields: j['dynamicFields'] ?? {},
  );
}
