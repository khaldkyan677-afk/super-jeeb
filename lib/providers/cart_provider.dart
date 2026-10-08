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
  // Multiple carts: storeId -> list of items
  final Map<String, List<CartItem>> _itemsByStore = {};
  final Map<String, String> _storeNames = {};
  final Map<String, String?> _merchantIds = {};
  final Map<String, double> _deliveryFees = {};

  // Which store is "active" right now (for display in store page)
  String? _currentStoreId;

  // ====== For backward compat (current store) ======
  String? get storeId => _currentStoreId;
  String? get storeName =>
      _currentStoreId == null ? null : _storeNames[_currentStoreId];
  String? get merchantId =>
      _currentStoreId == null ? null : _merchantIds[_currentStoreId];
  double get deliveryFee =>
      _currentStoreId == null ? 0 : (_deliveryFees[_currentStoreId] ?? 0);
  List<CartItem> get items =>
      _currentStoreId == null ? [] : (_itemsByStore[_currentStoreId] ?? []);
  int get count => items.fold(0, (s, e) => s + e.qty);
  double get subtotal => items.fold(0.0, (s, e) => s + e.total);
  double get total => subtotal + deliveryFee;
  bool get isEmpty => items.isEmpty;

  // ====== For multiple stores ======
  List<String> get storeIds => _itemsByStore.keys.toList();
  List<CartItem> itemsFor(String sid) => _itemsByStore[sid] ?? [];
  String storeNameFor(String sid) => _storeNames[sid] ?? '';
  String? merchantIdFor(String sid) => _merchantIds[sid];
  double deliveryFeeFor(String sid) => _deliveryFees[sid] ?? 0;
  double subtotalFor(String sid) =>
      itemsFor(sid).fold(0.0, (s, e) => s + e.total);
  double totalFor(String sid) => subtotalFor(sid) + deliveryFeeFor(sid);
  bool isStoreEmpty(String sid) => (_itemsByStore[sid] ?? []).isEmpty;

  // All items across all stores
  int get totalCount =>
      _itemsByStore.values.expand((l) => l).fold(0, (s, e) => s + e.qty);
  double get totalAcrossStores {
    double t = 0;
    for (final sid in _itemsByStore.keys) {
      t += totalFor(sid);
    }
    return t;
  }

  // ====== Mutations ======
  void setStore({
    required String storeId,
    required String storeName,
    String? merchantId,
    double deliveryFee = 0,
  }) {
    _storeNames[storeId] = storeName;
    _merchantIds[storeId] = merchantId;
    _deliveryFees[storeId] = deliveryFee;
    _currentStoreId = storeId;
    notifyListeners();
  }

  void setCurrentStore(String storeId) {
    if (_currentStoreId != storeId) {
      _currentStoreId = storeId;
      notifyListeners();
    }
  }

  void add(CartItem item, {String? storeId}) {
    final sid = storeId ?? _currentStoreId;
    if (sid == null) return;
    final list = List<CartItem>.from(_itemsByStore[sid] ?? []);
    final idx = list.indexWhere((e) => e.productId == item.productId);
    if (idx < 0) {
      list.add(item);
    } else {
      final e = list[idx];
      list[idx] = CartItem(
        productId: e.productId,
        name: e.name,
        price: e.price,
        qty: e.qty + 1,
        icon: e.icon,
      );
    }
    _itemsByStore[sid] = list;
    notifyListeners();
  }

  void remove(String productId, {String? storeId}) {
    final sid = storeId ?? _currentStoreId;
    if (sid == null) return;
    final list = List<CartItem>.from(_itemsByStore[sid] ?? []);
    final idx = list.indexWhere((e) => e.productId == productId);
    if (idx < 0) return;
    if (list[idx].qty <= 1) {
      list.removeAt(idx);
    } else {
      final e = list[idx];
      list[idx] = CartItem(
        productId: e.productId,
        name: e.name,
        price: e.price,
        qty: e.qty - 1,
        icon: e.icon,
      );
    }
    if (list.isEmpty) {
      _itemsByStore.remove(sid);
    } else {
      _itemsByStore[sid] = list;
    }
    notifyListeners();
  }

  void clearStore(String sid) {
    _itemsByStore.remove(sid);
    _storeNames.remove(sid);
    _merchantIds.remove(sid);
    _deliveryFees.remove(sid);
    if (_currentStoreId == sid) _currentStoreId = null;
    notifyListeners();
  }

  void clear() {
    _itemsByStore.clear();
    _storeNames.clear();
    _merchantIds.clear();
    _deliveryFees.clear();
    _currentStoreId = null;
    notifyListeners();
  }
}
