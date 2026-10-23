import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/product.dart';

class AssetService {
  static const String productsAssetPath = 'assets/data/products.json';

  // Loads and decodes products from the embedded asset JSON file
  Future<List<Product>> loadProducts() async {
    try {
      // Step 3: Load JSON file using rootBundle.loadString
      final String jsonString = await rootBundle.loadString(productsAssetPath);

      // Step 4: Decode JSON into Dart List using jsonDecode
      final dynamic decoded = jsonDecode(jsonString);

      if (decoded is List) {
        return decoded
            .map((item) => Product.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Expected JSON array but received ${decoded.runtimeType}');
      }
    } catch (e) {
      throw Exception('Failed to load products from assets: $e');
    }
  }
}
