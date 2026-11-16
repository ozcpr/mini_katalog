import 'package:flutter/foundation.dart';

import '../models/product.dart';

/// Basit sepet durumu (simülasyon).
/// ChangeNotifier sayesinde sepet değiştiğinde dinleyen ekranlar güncellenir.
class Cart extends ChangeNotifier {
  final Map<int, int> _quantities = {};
  final Map<int, Product> _products = {};

  List<Product> get products => _products.values.toList();

  int quantityOf(Product product) => _quantities[product.id] ?? 0;

  int get totalCount {
    int count = 0;
    for (final int quantity in _quantities.values) {
      count += quantity;
    }
    return count;
  }

  double get totalPrice {
    double total = 0;
    for (final Product product in _products.values) {
      total += product.price * quantityOf(product);
    }
    return total;
  }

  void add(Product product) {
    _products[product.id] = product;
    _quantities[product.id] = quantityOf(product) + 1;
    notifyListeners();
  }

  void decrease(Product product) {
    final int current = quantityOf(product);
    if (current <= 1) {
      remove(product);
      return;
    }
    _quantities[product.id] = current - 1;
    notifyListeners();
  }

  void remove(Product product) {
    _products.remove(product.id);
    _quantities.remove(product.id);
    notifyListeners();
  }

  void clear() {
    _products.clear();
    _quantities.clear();
    notifyListeners();
  }
}

/// Uygulama genelinde kullanılan tek sepet nesnesi.
final Cart cart = Cart();
