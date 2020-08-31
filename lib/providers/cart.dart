import 'package:flutter/Material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantinty;
  final double price;

  CartItem(
      {@required this.id,
      @required this.title,
      @required this.quantinty,
      @required this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, value) {
      total += value.price * value.quantinty;
    });

    return total;
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }

    if (_items[productId].quantinty > 1) {
      _items.update(
          productId,
          (existingItem) => CartItem(
              id: existingItem.id,
              title: existingItem.title,
              price: existingItem.price,
              quantinty: existingItem.quantinty - 1));
    } else {
      removeItem(productId);
    }

    notifyListeners(); 
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingItem) => CartItem(
              id: existingItem.id,
              title: existingItem.title,
              price: existingItem.price,
              quantinty: existingItem.quantinty + 1));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              price: price,
              quantinty: 1));
    }

    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
