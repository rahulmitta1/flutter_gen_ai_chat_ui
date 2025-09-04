import 'package:flutter/foundation.dart';

/// Shopping cart item model
class CartItem {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final String? imageUrl;
  final String? description;

  const CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    this.imageUrl,
    this.description,
  });

  CartItem copyWith({
    String? id,
    String? name,
    double? price,
    int? quantity,
    String? imageUrl,
    String? description,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
    );
  }

  double get total => price * quantity;

  // Alias for total for compatibility
  double get totalPrice => total;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
      'description': description,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] as int,
      imageUrl: json['imageUrl'] as String?,
      description: json['description'] as String?,
    );
  }

  @override
  String toString() {
    return 'CartItem(id: $id, name: $name, price: $price, quantity: $quantity)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Shopping cart model with state management
class ShoppingCart extends ChangeNotifier {
  final List<CartItem> _items;

  ShoppingCart({List<CartItem>? items}) : _items = items ?? [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice => _items.fold(0, (sum, item) => sum + item.total);

  // Alias for totalPrice for compatibility
  double get total => totalPrice;

  bool get isEmpty => _items.isEmpty;

  bool get isNotEmpty => _items.isNotEmpty;

  /// Add item to cart or increase quantity if item already exists
  void addItem(CartItem item) {
    final existingIndex =
        _items.indexWhere((cartItem) => cartItem.id == item.id);

    if (existingIndex >= 0) {
      _items[existingIndex] = _items[existingIndex].copyWith(
        quantity: _items[existingIndex].quantity + item.quantity,
      );
    } else {
      _items.add(item);
    }

    notifyListeners();
  }

  /// Remove item from cart completely
  void removeItem(String itemId) {
    _items.removeWhere((item) => item.id == itemId);
    notifyListeners();
  }

  /// Update item quantity
  void updateQuantity(String itemId, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(itemId);
      return;
    }

    final index = _items.indexWhere((item) => item.id == itemId);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(quantity: newQuantity);
      notifyListeners();
    }
  }

  /// Clear all items from cart
  void clear() {
    _items.clear();
    notifyListeners();
  }

  /// Get item by ID
  CartItem? getItem(String itemId) {
    try {
      return _items.firstWhere((item) => item.id == itemId);
    } catch (e) {
      return null;
    }
  }

  /// Check if cart contains item
  bool containsItem(String itemId) {
    return _items.any((item) => item.id == itemId);
  }

  /// Get cart summary as string
  String getSummary() {
    if (isEmpty) return 'Cart is empty';

    final summary = StringBuffer();
    summary.writeln('Shopping Cart Summary:');
    summary.writeln('Total Items: $itemCount');
    summary.writeln('Total Price: \$${totalPrice.toStringAsFixed(2)}');
    summary.writeln('\nItems:');

    for (final item in _items) {
      summary.writeln(
          '- ${item.name} (${item.quantity}x) - \$${item.total.toStringAsFixed(2)}');
    }

    return summary.toString();
  }
}
