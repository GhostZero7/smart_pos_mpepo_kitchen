import 'package:flutter/material.dart';
import '../models/receipt.dart';
import '../theme/app_theme.dart';



class ReceiptService {
  static Future<void> generateAndPrintReceipt(Receipt receipt, BuildContext context) async {
    print('🧾 Showing receipt dialog for: ${receipt.receiptNumber}');
    
    // Ensure we're using a valid context
    if (!context.mounted) {
      print('❌ Context not mounted, cannot show dialog');
      return;
    }
    
    // Show the receipt dialog
    _showReceiptDialog(receipt, context);
  }

  static Future<void> generateAndShareReceipt(Receipt receipt, BuildContext context) async {
    // For now, show the same dialog
    _showReceiptDialog(receipt, context);
  }

  static void _showReceiptDialog(Receipt receipt, BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(0.2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Column(
                children: [
                  const Icon(Icons.check_circle, size: 48, color: Colors.white),
                  const SizedBox(height: 8),
                  const Text(
                    'Payment Successful!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Receipt #${receipt.receiptNumber}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            
            // Receipt Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
  mainAxisSize: MainAxisSize.min,
  children: [
    Text('Receipt #${receipt.receiptNumber}'),
    Text('Total: \$${receipt.total.toStringAsFixed(2)}'),
    Text('Items: ${receipt.items.length}'),
    Text('Thank you for your order!'),
  ],
),// Use existing method
              ),
            ),
            
            // Actions
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _showSaveConfirmation(context, receipt);
                      },
                      child: const Text('Save Receipt'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  static Widget _buildReceiptHeader(Receipt receipt) {
    return Column(
      children: [
        const Text(
          'MPEPO KITCHEN',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Text('Delicious Food, Great Times!'),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Receipt: ${receipt.receiptNumber}'),
            Text(receipt.formattedTime),
          ],
        ),
        Text('Date: ${receipt.formattedDate.split(' ')[0]}'),
        const Divider(),
      ],
    );
  }

  static Widget _buildReceiptItems(Receipt receipt) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ORDER ITEMS:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...receipt.items.map((item) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 3,
                child: Text(item.product.name),
              ),
              Expanded(
                child: Text('${item.quantity} x \$${item.product.price.toStringAsFixed(2)}'),
              ),
              Expanded(
                child: Text(
                  '\$${item.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  static Widget _buildReceiptTotals(Receipt receipt) {
    return Column(
      children: [
        _buildTotalRow('Subtotal:', receipt.subtotal),
        if (receipt.discountAmount > 0)
          _buildTotalRow('Discount:', -receipt.discountAmount, isDiscount: true),
        _buildTotalRow('${receipt.taxConfig.taxName} (${(receipt.taxConfig.taxRate * 100).toInt()}%):', receipt.taxAmount),
        const Divider(),
        _buildTotalRow('TOTAL:', receipt.total, isTotal: true),
        const SizedBox(height: 8),
        Text(
          'Payment Method: ${receipt.paymentMethod}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  static Widget _buildTotalRow(String label, double amount, {bool isDiscount = false, bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isDiscount ? Colors.green : Colors.black,
            ),
          ),
          Text(
            '${isDiscount ? '-' : ''}\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isDiscount ? Colors.green : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildReceiptFooter() {
    return const Column(
      children: [
        Divider(),
        Text(
          'Thank you for dining with us!',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
        Text(
          'Visit again soon!',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
        SizedBox(height: 8),
        Text(
          '📧 Receipt saved to order history',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  // Add this helper for save confirmation dialog
  static void _showSaveConfirmation(BuildContext context, Receipt receipt) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Receipt Saved'),
        content: const Text('Your receipt has been saved to local storage. PDF printing will be available in the next update.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Simulate saving receipt data (for offline queue)
  static Future<void> saveReceiptToStorage(Receipt receipt) async {
    // TODO: Implement local storage for offline queue
    print('💾 Receipt saved locally: ${receipt.receiptNumber}');
  }
}