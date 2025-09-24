import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;
  String _lastError = '';

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String get lastError => _lastError;

  Future<void> loadProducts() async {
    _isLoading = true;
    _lastError = '';
    notifyListeners();

    print('🔄 ProductProvider: Starting to load products...');

    try {
      // Try to load from REAL API first
      print('🌐 Attempting to fetch from real database...');
      _products = await ApiService.getProducts();
      
      if (_products.isNotEmpty) {
        print('✅ SUCCESS: Loaded ${_products.length} products from REAL database');
        print('📦 Sample product: ${_products.first.name} - \$${_products.first.price}');
      } else {
        print('⚠️ WARNING: API returned empty product list');
        _fallbackToMockData('API returned empty list');
      }
      
    } catch (error) {
      print('❌ API Error: $error');
      _lastError = error.toString();
      _fallbackToMockData(error.toString());
    } finally {
      _isLoading = false;
      notifyListeners(); // FIXED: Changed from notifyListenifiers to notifyListeners
    }
  }

  void _fallbackToMockData(String errorReason) {
    print('🔄 Falling back to mock data because: $errorReason');
    _products = _getMockProducts();
    print('✅ Using ${_products.length} mock products as fallback');
  }

  List<Product> _getMockProducts() {
    return [
      Product(
        id: 1,
        name: "Chicken Burger",
        description: "Juicy grilled chicken with fresh veggies",
        price: 12.99,
        imageUrl: "",
        category: "Burgers",
        isAvailable: true,
      ),
      Product(
        id: 2, 
        name: "Vegetable Pizza",
        description: "Fresh vegetable pizza with mozzarella",
        price: 15.99,
        imageUrl: "",
        category: "Pizza", 
        isAvailable: true,
      ),
      Product(
        id: 3,
        name: "French Fries", 
        description: "Crispy golden fries with seasoning",
        price: 5.99,
        imageUrl: "",
        category: "Sides",
        isAvailable: true,
      ),
      Product(
        id: 4,
        name: "Caesar Salad",
        description: "Fresh salad with Caesar dressing", 
        price: 8.99,
        imageUrl: "",
        category: "Salads",
        isAvailable: true,
      ),
    ];
  }

  // Force reload from API (bypass cache)
  Future<void> forceReloadFromAPI() async {
    print('🔄 Force reloading from API...');
    await loadProducts();
  }

  // Clear products and errors
  void clearProducts() {
    _products = [];
    _lastError = '';
    notifyListeners();
  }

  Product? getProductById(int id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> refreshProducts() async {
    await loadProducts();
  }
}