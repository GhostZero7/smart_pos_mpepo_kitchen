import 'package:intl/intl.dart';
import 'cart_item.dart';
import 'tax_config.dart';

class Receipt {
  final String receiptNumber;
  final DateTime timestamp;
  final List<CartItem> items;
  final double subtotal;
  final double taxAmount;
  final double discountAmount;
  final double total;
  final TaxConfig taxConfig;
  final Discount? discount;
  final String paymentMethod;

  Receipt({
    required this.items,
    required this.subtotal,
    required this.taxAmount,
    required this.discountAmount,
    required this.total,
    required this.taxConfig,
    this.discount,
    this.paymentMethod = 'Cash',
    String? receiptNumber,
    DateTime? timestamp,
  })  : receiptNumber = receiptNumber ?? _generateReceiptNumber(),
        timestamp = timestamp ?? DateTime.now();

  static String _generateReceiptNumber() {
    final now = DateTime.now();
    return 'MP${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}';
  }

  String get formattedDate {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(timestamp);
  }

  String get formattedTime {
    return DateFormat('HH:mm:ss').format(timestamp);
  }

  Map<String, dynamic> toJson() {
    return {
      'receipt_number': receiptNumber,
      'timestamp': timestamp.toIso8601String(),
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'tax_amount': taxAmount,
      'discount_amount': discountAmount,
      'total': total,
      'tax_config': {
        'rate': taxConfig.taxRate,
        'name': taxConfig.taxName,
      },
      'discount': discount != null
          ? {
              'type': discount!.type,
              'value': discount!.value,
              'name': discount!.name,
            }
          : null,
      'payment_method': paymentMethod,
    };
  }
}