import 'package:flutter/foundation.dart';
import '../../shop/models/address.dart';
import '../../shop/data/shop_data.dart';

class AddressesProvider extends ChangeNotifier {
  final List<DeliveryAddress> _addresses = List.from(ShopData.sampleAddresses);

  List<DeliveryAddress> get addresses => List.unmodifiable(_addresses);

  DeliveryAddress get defaultAddress {
    return _addresses.firstWhere(
      (a) => a.isDefault,
      orElse: () => _addresses.first,
    );
  }

  void addAddress(DeliveryAddress address) {
    if (address.isDefault) {
      for (var i = 0; i < _addresses.length; i++) {
        _addresses[i] = _addresses[i].copyWith(isDefault: false);
      }
    }
    _addresses.add(address);
    notifyListeners();
  }

  void updateAddress(DeliveryAddress updated) {
    final index = _addresses.indexWhere((a) => a.id == updated.id);
    if (index != -1) {
      if (updated.isDefault) {
        for (var i = 0; i < _addresses.length; i++) {
          _addresses[i] = _addresses[i].copyWith(isDefault: false);
        }
      }
      _addresses[index] = updated;
      notifyListeners();
    }
  }

  void setDefault(String id) {
    for (var i = 0; i < _addresses.length; i++) {
      _addresses[i] = _addresses[i].copyWith(isDefault: _addresses[i].id == id);
    }
    notifyListeners();
  }

  void deleteAddress(String id) {
    _addresses.removeWhere((a) => a.id == id);
    if (_addresses.isNotEmpty && !_addresses.any((a) => a.isDefault)) {
      _addresses[0] = _addresses[0].copyWith(isDefault: true);
    }
    notifyListeners();
  }
}
