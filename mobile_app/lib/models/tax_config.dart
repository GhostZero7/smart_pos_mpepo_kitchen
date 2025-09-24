class TaxConfig {
  final double taxRate; // e.g., 0.15 for 15%
  final String taxName; // e.g., "VAT", "GST"

  const TaxConfig({
    this.taxRate = 0.15, // Default 15% tax
    this.taxName = 'VAT',
  });
}

class Discount {
  final String type; // 'percentage' or 'fixed'
  final double value;
  final String name; // e.g., "Student Discount", "Happy Hour"

  const Discount({
    required this.type,
    required this.value,
    this.name = 'Discount',
  });

  double calculateDiscount(double subtotal) {
    if (type == 'percentage') {
      return subtotal * (value / 100);
    } else {
      return value;
    }
  }
}