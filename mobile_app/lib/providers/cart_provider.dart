import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../models/tax_config.dart';
import '../models/receipt.dart';
import '../services/receipt_service.dart';
import '../services/offline_queue_service.dart';
import '../main.dart'; // Make sure navigatorKey is defined here

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];
  TaxConfig _taxConfig = const TaxConfig(taxRate: 0.15, taxName: 'VAT');
  Discount? _discount;
  final OfflineQueueService _offlineQueue = OfflineQueueService();

  List<CartItem> get items => _items;
  int get itemCount => _items.length;
  Discount? get discount => _discount;
  TaxConfig get taxConfig => _taxConfig;

  double get subtotal => _items.fold(0, (total, item) => total + item.totalPrice);
  double get taxAmount => subtotal * _taxConfig.taxRate;
  double get discountAmount => _discount?.calculateDiscount(subtotal) ?? 0;
  double get total => subtotal + taxAmount - discountAmount;

  void applyDiscount(Discount discount) {
    _discount = discount;
    notifyListeners();
  }

  void removeDiscount() {
    _discount = null;
    notifyListeners();
  }

  void updateTaxRate(double newRate) {
    _taxConfig = TaxConfig(taxRate: newRate, taxName: _taxConfig.taxName);
    notifyListeners();
  }

  void addItem(Product product) {
    final existingIndex = _items.indexWhere((item) => item.product.id == product.id);
    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }
    notifyListeners();
  }

  void removeItem(int productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void updateQuantity(int productId, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(productId);
      return;
    }
    final existingIndex = _items.indexWhere((item) => item.product.id == productId);
    if (existingIndex >= 0) {
      _items[existingIndex].quantity = newQuantity;
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    _discount = null;
    notifyListeners();
  }

  bool isInCart(Product product) => _items.any((item) => item.product.id == product.id);

  int getQuantity(Product product) {
    final existingIndex = _items.indexWhere((item) => item.product.id == product.id);
    return existingIndex >= 0 ? _items[existingIndex].quantity : 0;
  }

  Receipt generateReceipt({String paymentMethod = 'Cash'}) {
    return Receipt(
      items: List.from(_items),
      subtotal: subtotal,
      taxAmount: taxAmount,
      discountAmount: discountAmount,
      total: total,
      taxConfig: _taxConfig,
      discount: _discount,
      paymentMethod: paymentMethod,
    );
  }

  /// Complete sale and show receipt globally
  Future<void> completeSale({String paymentMethod = 'Cash'}) async {
    final receipt = generateReceipt(paymentMethod: paymentMethod);

    // Save receipt locally
    await ReceiptService.saveReceiptToStorage(receipt);

    // Clear the cart
    clearCart();

    // Show receipt using global navigator key
    _showReceiptDialog(receipt);
  }

  void _showReceiptDialog(Receipt receipt) {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (navigatorKey.currentContext != null && navigatorKey.currentState != null) {
        showDialog(
          context: navigatorKey.currentContext!,
          barrierDismissible: false,
          builder: (context) => _buildReceiptDialog(receipt, context),
        );
      } else {
        print('❌ Navigator not ready to show receipt dialog');
      }
    });
  }

  Widget _buildReceiptDialog(Receipt receipt, BuildContext context) {
    return AlertDialog(
      title: const Text('🎉 Order Complete!'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Receipt #: ${receipt.receiptNumber}', style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('Date: ${receipt.formattedDate}'),
            const SizedBox(height: 10),
            const Text('Items:', style: TextStyle(fontWeight: FontWeight.bold)),
            ...receipt.items.map((item) => Text('${item.product.name} x${item.quantity} - \$${item.totalPrice.toStringAsFixed(2)}')),
            const SizedBox(height: 10),
            Text('Subtotal: \$${receipt.subtotal.toStringAsFixed(2)}'),
            if (receipt.discountAmount > 0) Text('Discount: -\$${receipt.discountAmount.toStringAsFixed(2)}'),
            Text('Tax: \$${receipt.taxAmount.toStringAsFixed(2)}'),
            Text('TOTAL: \$${receipt.total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            Text('Payment: ${receipt.paymentMethod}'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            navigatorKey.currentState?.popUntil((route) => route.isFirst);
          },
          child: const Text('Back to Menu'),
        ),
      ],
    );
  }
}
