class CartItem {
  final String productId;
  final String name;
  final double price;
  final int quantity;
  final String imageUrl;
  CartItem({required this.productId, required this.name,
    required this.price, required this.quantity, required this.imageUrl});
  double get total => price * quantity;
  CartItem copyWith({int? quantity}) => CartItem(
    productId: productId, name: name, price: price,
    quantity: quantity ?? this.quantity, imageUrl: imageUrl);
}
