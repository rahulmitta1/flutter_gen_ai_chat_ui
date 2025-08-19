/// Shopping cart item model
class CartItem {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final String category;
  final String? imageUrl;
  final String? description;
  final Map<String, dynamic>? attributes; // size, color, etc.

  const CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.category,
    this.imageUrl,
    this.description,
    this.attributes,
  });

  /// Total price for this item (price * quantity)
  double get totalPrice => price * quantity;

  /// Copy with new values
  CartItem copyWith({
    String? id,
    String? name,
    double? price,
    int? quantity,
    String? category,
    String? imageUrl,
    String? description,
    Map<String, dynamic>? attributes,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      attributes: attributes ?? this.attributes,
    );
  }

  /// Convert to map for context serialization
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'quantity': quantity,
      'totalPrice': totalPrice,
      'category': category,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (description != null) 'description': description,
      if (attributes != null) 'attributes': attributes,
    };
  }

  @override
  String toString() {
    return 'CartItem(id: $id, name: $name, price: $price, quantity: $quantity)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItem &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Shopping cart model
class ShoppingCart {
  final List<CartItem> items;
  final double? discountApplied;
  final double? discountPercentage;
  final double? shippingCost;
  final double? taxAmount;
  final String? couponCode;
  final DateTime? lastUpdated;

  const ShoppingCart({
    required this.items,
    this.discountApplied,
    this.discountPercentage,
    this.shippingCost,
    this.taxAmount,
    this.couponCode,
    this.lastUpdated,
  });

  /// Empty cart
  static const ShoppingCart empty = ShoppingCart(items: []);

  /// Subtotal (sum of all item prices)
  double get subtotal {
    return items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  /// Total after discounts and fees
  double get total {
    double total = subtotal;
    
    if (discountApplied != null) {
      total -= discountApplied!;
    }
    
    if (shippingCost != null) {
      total += shippingCost!;
    }
    
    if (taxAmount != null) {
      total += taxAmount!;
    }
    
    return total > 0 ? total : 0.0;
  }

  /// Total number of items in cart
  int get itemCount {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  /// Check if cart is empty
  bool get isEmpty => items.isEmpty;

  /// Check if cart has items
  bool get isNotEmpty => items.isNotEmpty;

  /// Get all unique categories in cart
  List<String> get categories {
    return items.map((item) => item.category).toSet().toList();
  }

  /// Get items summary for AI context
  String get itemsSummary {
    if (items.isEmpty) return 'Empty cart';
    
    return items.map((item) {
      return '• ${item.name} (${item.quantity}x) - \$${item.totalPrice.toStringAsFixed(2)}';
    }).join('\n');
  }

  /// Add item to cart
  ShoppingCart addItem(CartItem item) {
    final updatedItems = List<CartItem>.from(items);
    
    // Check if item already exists
    final existingIndex = updatedItems.indexWhere((i) => i.id == item.id);
    
    if (existingIndex >= 0) {
      // Update quantity
      final existingItem = updatedItems[existingIndex];
      updatedItems[existingIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + item.quantity,
      );
    } else {
      // Add new item
      updatedItems.add(item);
    }
    
    return copyWith(
      items: updatedItems,
      lastUpdated: DateTime.now(),
    );
  }

  /// Remove item from cart
  ShoppingCart removeItem(String itemId) {
    final updatedItems = items.where((item) => item.id != itemId).toList();
    
    return copyWith(
      items: updatedItems,
      lastUpdated: DateTime.now(),
    );
  }

  /// Update item quantity
  ShoppingCart updateItemQuantity(String itemId, int newQuantity) {
    if (newQuantity <= 0) {
      return removeItem(itemId);
    }
    
    final updatedItems = items.map((item) {
      if (item.id == itemId) {
        return item.copyWith(quantity: newQuantity);
      }
      return item;
    }).toList();
    
    return copyWith(
      items: updatedItems,
      lastUpdated: DateTime.now(),
    );
  }

  /// Clear all items from cart
  ShoppingCart clear() {
    return const ShoppingCart(items: []);
  }

  /// Apply discount
  ShoppingCart applyDiscount(double discountPercentage, {String? couponCode}) {
    final discountAmount = subtotal * (discountPercentage / 100);
    
    return copyWith(
      discountApplied: discountAmount,
      discountPercentage: discountPercentage,
      couponCode: couponCode,
      lastUpdated: DateTime.now(),
    );
  }

  /// Copy with new values
  ShoppingCart copyWith({
    List<CartItem>? items,
    double? discountApplied,
    double? discountPercentage,
    double? shippingCost,
    double? taxAmount,
    String? couponCode,
    DateTime? lastUpdated,
  }) {
    return ShoppingCart(
      items: items ?? this.items,
      discountApplied: discountApplied ?? this.discountApplied,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      shippingCost: shippingCost ?? this.shippingCost,
      taxAmount: taxAmount ?? this.taxAmount,
      couponCode: couponCode ?? this.couponCode,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  /// Convert to map for context serialization
  Map<String, dynamic> toMap() {
    return {
      'items': items.map((item) => item.toMap()).toList(),
      'itemCount': itemCount,
      'subtotal': subtotal,
      'total': total,
      'categories': categories,
      'isEmpty': isEmpty,
      'itemsSummary': itemsSummary,
      if (discountApplied != null) 'discountApplied': discountApplied,
      if (discountPercentage != null) 'discountPercentage': discountPercentage,
      if (shippingCost != null) 'shippingCost': shippingCost,
      if (taxAmount != null) 'taxAmount': taxAmount,
      if (couponCode != null) 'couponCode': couponCode,
      if (lastUpdated != null) 'lastUpdated': lastUpdated!.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'ShoppingCart(items: ${items.length}, total: \$${total.toStringAsFixed(2)})';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShoppingCart &&
          runtimeType == other.runtimeType &&
          items == other.items &&
          discountApplied == other.discountApplied &&
          shippingCost == other.shippingCost;

  @override
  int get hashCode => Object.hash(items, discountApplied, shippingCost);
}