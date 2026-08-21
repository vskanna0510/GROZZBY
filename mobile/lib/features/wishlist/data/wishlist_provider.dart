import 'package:flutter/foundation.dart';
import '../../shop/models/product.dart';
import '../../shop/data/shop_data.dart';

class WishlistProvider extends ChangeNotifier {
  final Set<String> _favoriteIds = {'prod_1', 'prod_4'}; // Pre-populated favorites

  Set<String> get favoriteIds => Set.unmodifiable(_favoriteIds);

  bool isFavorite(String productId) => _favoriteIds.contains(productId);

  int get count => _favoriteIds.length;

  List<Product> get favoriteProducts {
    return ShopData.products.where((p) => _favoriteIds.contains(p.id)).toList();
  }

  void toggleFavorite(String productId) {
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
    } else {
      _favoriteIds.add(productId);
    }
    notifyListeners();
  }

  void removeFavorite(String productId) {
    if (_favoriteIds.remove(productId)) {
      notifyListeners();
    }
  }
}
