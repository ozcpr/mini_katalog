import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/product.dart';

/// Ürün verilerini assets/products.json dosyasından okur.
/// Gerçek bir API çağrısını simüle eder.
class ProductService {
  static Future<List<Product>> loadProducts() async {
    final String jsonString = await rootBundle.loadString('assets/products.json');
    final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;

    return jsonList
        .map((item) => Product.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
