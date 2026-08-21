import 'package:flutter/foundation.dart';
import '../../shop/models/product.dart';

class CartItemEntry {
  final Product product;
  int quantity;

  CartItemEntry({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;
}

class CartProvider extends ChangeNotifier {
  final Map<String, CartItemEntry> _items = {};
  String? _appliedPromoCode;
  double _discountAmount = 0.0;

  Map<String, CartItemEntry> get items => Map.unmodifiable(_items);
  List<CartItemEntry> get itemList => _items.values.toList();
  String? get appliedPromoCode => _appliedPromoCode;
  double get discountAmount => _discountAmount;

  int get totalItemCount => _items.values.fold(0, (sum, entry) => sum + entry.quantity);

  int getQuantity(String productId) {
    return _items[productId]?.quantity ?? 0;
  }

  double get subtotal {
    return _items.values.fold(0.0, (sum, entry) => sum + entry.totalPrice);
  }

  double get deliveryFee {
    if (_items.isEmpty) return 0.0;
    if (_appliedPromoCode == 'FREESHIP') return 0.0;
    return subtotal >= 499.0 ? 0.0 : 40.0;
  }

  double get tax => subtotal * 0.05; // 5% estimated GST/tax

  double get total {
    if (_items.isEmpty) return 0.0;
    final val = subtotal + deliveryFee + tax - _discountAmount;
    return val > 0 ? val : 0.0;
  }

  void addItem(Product product, [int quantity = 1]) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity += quantity;
    } else {
      _items[product.id] = CartItemEntry(product: product, quantity: quantity);
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    if (_items.isEmpty) {
      _appliedPromoCode = null;
      _discountAmount = 0.0;
    }
    notifyListeners();
  }

  void increment(String productId) {
    if (_items.containsKey(productId)) {
      _items[productId]!.quantity++;
      notifyListeners();
    }
  }

  void decrement(String productId) {
    if (_items.containsKey(productId)) {
      if (_items[productId]!.quantity > 1) {
        _items[productId]!.quantity--;
      } else {
        _items.remove(productId);
      }
      if (_items.isEmpty) {
        _appliedPromoCode = null;
        _discountAmount = 0.0;
      }
      notifyListeners();
    }
  }

  void setQuantity(String productId, int quantity, {Product? fallbackProduct}) {
    if (quantity <= 0) {
      _items.remove(productId);
    } else if (_items.containsKey(productId)) {
      _items[productId]!.quantity = quantity;
    } else if (fallbackProduct != null) {
      _items[productId] = CartItemEntry(product: fallbackProduct, quantity: quantity);
    }
    notifyListeners();
  }

  bool applyPromoCode(String code) {
    final clean = code.trim().toUpperCase();
    if (clean == 'GROZZBY10' || clean == 'FRESH10') {
      _appliedPromoCode = clean;
      _discountAmount = subtotal * 0.10; // 10% discount
      notifyListeners();
      return true;
    } else if (clean == 'SAVE50' || clean == 'GROZZBY50' || clean == 'SAVE5') {
      _appliedPromoCode = clean;
      _discountAmount = 50.00; // ₹50 off
      notifyListeners();
      return true;
    } else if (clean == 'WELCOME100') {
      _appliedPromoCode = clean;
      _discountAmount = 100.00;
      notifyListeners();
      return true;
    } else if (clean == 'FESTIVE25') {
      _appliedPromoCode = clean;
      _discountAmount = subtotal * 0.25;
      notifyListeners();
      return true;
    } else if (clean == 'FREESHIP') {
      _appliedPromoCode = clean;
      _discountAmount = 40.00;
      notifyListeners();
      return true;
    }
    return false;
  }

  void applyCoupon(String code, double amount) {
    _appliedPromoCode = code.trim().toUpperCase();
    _discountAmount = amount;
    notifyListeners();
  }

  void removePromoCode() {
    _appliedPromoCode = null;
    _discountAmount = 0.0;
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _appliedPromoCode = null;
    _discountAmount = 0.0;
    notifyListeners();
  }

  void clear() => clearCart();
}
