import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class FoodApiService {
  static const String baseUrl = 'https://world.openfoodfacts.org/api/v0';

  Future<Product?> getProduct(String barcode) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/product/$barcode.json'),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['status'] == 1) {
          return Product.fromJson(json);
        }
      }
      return null;
    } catch (e) {
      print('Error fetching product: $e');
      return null;
    }
  }
} 