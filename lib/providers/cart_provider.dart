import 'package:flutter/foundation.dart';

class CartItem {
  final String productId;
  final String name;
  final double price;
  final int qty;
  final String? icon;
  CartItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.qty,
    this.icon,
  });
  double get total => price * qty;
}

class CartProvider extends ChangeNotifier {
  String? _storeId;
  String? _storeName;
  String? _merchantId;
  double _deliveryFee = 0;
  final Map<String, CartItem> _items = {};

  String? get storeId => _storeId;
  String? get storeName => _storeName;
  String? get merchantId => _merchantId;
  double get deliveryFee => _deliveryFee;
  List<CartItem> get items => _items.values.toList();
  int get count => _items.values.fold(0, (s, e) => s + e.qty);
  double get subtotal => _items.values.fold(0.0, (s, e) => s + e.total);
  double get total => subtotal + _deliveryFee;
  bool get isEmpty => _items.isEmpty;

  void setStore({
    required String storeId,
    required String storeName,
    String? merchantId,
    double deliveryFee = 0,
  }) {
    if (_storeId != storeId) _items.clear();
    _storeId = storeId;
    _storeName = storeName;
    _merchantId = merchantId;
    _deliveryFee = deliveryFee;
    notifyListeners();
  }

  void add(CartItem item) {
    final e = _items[item.productId];
    if (e == null) {
      _items[item.productId] = item;
    } else {
      _items[item.productId] = CartItem(
        productId: e.productId,
        name: e.name,
        price: e.price,
        qty: e.qty + 1,
        icon: e.icon,
      );
    }
    notifyListeners();
  }

  void remove(String productId) {
    final e = _items[productId];
    if (e == null) return;
    if (e.qty <= 1) {
      _items.remove(productId);
    } else {
      _items[productId] = CartItem(
        productId: e.productId,
        name: e.name,
        price: e.price,
        qty: e.qty - 1,
        icon: e.icon,
      );
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    _storeId = null;
    _storeName = null;
    _merchantId = null;
    _deliveryFee = 0;
    notifyListeners();
  }
}
