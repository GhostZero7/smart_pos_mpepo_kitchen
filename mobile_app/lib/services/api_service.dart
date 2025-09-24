import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String baseUrl = 'http://10.200.192.81:8000';
  static const int timeoutSeconds = 10;

  static Future<List<Product>> getProducts() async {
    try {
      print('🌐 API CALL: Connecting to $baseUrl/products');
      print('🕐 Timeout set to: ${timeoutSeconds} seconds');
      
      final response = await http.get(
        Uri.parse('$baseUrl/products'),
      ).timeout(const Duration(seconds: timeoutSeconds));
      
      print('📡 RESPONSE: Status Code = ${response.statusCode}');
      print('📡 RESPONSE: Headers = ${response.headers}');
      print('📡 RESPONSE: Body length = ${response.body.length} characters');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('✅ API SUCCESS: Received ${data.length} products from server');
        
        if (data.isNotEmpty) {
          print('📊 First product data: ${data.first}');
        }
        
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        print('❌ API ERROR: HTTP ${response.statusCode} - ${response.body}');
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('💥 NETWORK ERROR: $e');
      rethrow;
    }
  }

  static Future<Product> getProduct(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/products/$id'));
    
    if (response.statusCode == 200) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load product');
    }
  }
}