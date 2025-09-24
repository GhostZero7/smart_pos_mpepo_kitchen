import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/tax_config.dart';
import '../widgets/cart_item_card.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[700],
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png', // Your logo path
              height: 40,
            ),
            const SizedBox(width: 10),
            const Text(
              'Mpepo Kitchen POS',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.percent),
            onPressed: () => _showDiscountDialog(context),
            tooltip: 'Apply Discount',
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.items.isEmpty) {
            return _buildEmptyCart(context);
          }

          return Column(
            children: [
              Expanded(child: _buildCartItemsList(context, cart)),
              _buildOrderSummary(context, cart),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('Your cart is empty', style: TextStyle(fontSize: 18, color: Colors.grey)),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Browse Products')),
        ],
      ),
    );
  }

  Widget _buildCartItemsList(BuildContext context, CartProvider cart) {
    return ListView.builder(
      itemCount: cart.items.length,
      itemBuilder: (context, index) {
        final item = cart.items[index];
        return Dismissible(
          key: Key(item.product.id.toString()),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (direction) {
            cart.removeItem(item.product.id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Removed ${item.product.name} from cart'),
                action: SnackBarAction(label: 'Undo', onPressed: () => cart.addItem(item.product)),
              ),
            );
          },
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              leading: item.product.imageUrl.isNotEmpty
                  ? Image.network(item.product.imageUrl, width: 50, height: 50)
                  : const Icon(Icons.fastfood, size: 50),
              title: Text(item.product.name),
              subtitle: Text('\$${item.product.price.toStringAsFixed(2)} each'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      if (item.quantity > 1) {
                        cart.updateQuantity(item.product.id, item.quantity - 1);
                      } else {
                        cart.removeItem(item.product.id);
                      }
                    },
                  ),
                  Text('${item.quantity}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => cart.updateQuantity(item.product.id, item.quantity + 1),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOrderSummary(BuildContext context, CartProvider cart) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Column(
        children: [
          _buildPricingRow('Subtotal', cart.subtotal),
          if (cart.discount != null)
            _buildPricingRow('${cart.discount!.name} (${cart.discount!.type == 'percentage' ? '${cart.discount!.value}%' : '\$${cart.discount!.value}'})', -cart.discountAmount, isDiscount: true),
          _buildPricingRow('${cart.taxConfig.taxName} (${(cart.taxConfig.taxRate * 100).toInt()}%)', cart.taxAmount),
          const Divider(),
          _buildPricingRow('TOTAL', cart.total, isTotal: true),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange[700], padding: const EdgeInsets.symmetric(vertical: 16)),
              onPressed: () => _showCheckoutDialog(context, cart),
              child: const Text('Proceed to Checkout', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingRow(String label, double amount, {bool isDiscount = false, bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: isTotal ? 18 : 14, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal, color: isDiscount ? Colors.green : Colors.black)),
          Text('${isDiscount ? '-' : ''}\$${amount.toStringAsFixed(2)}', style: TextStyle(fontSize: isTotal ? 18 : 14, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal, color: isDiscount ? Colors.green : Colors.black)),
        ],
      ),
    );
  }

  void _showDiscountDialog(BuildContext context) {
    final cart = context.read<CartProvider>();
    String discountType = 'percentage';
    double discountValue = 10;
    String discountName = 'Special Offer';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Apply Discount'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField(
                  value: discountType,
                  items: const [
                    DropdownMenuItem(value: 'percentage', child: Text('Percentage (%)')),
                    DropdownMenuItem(value: 'fixed', child: Text('Fixed Amount')),
                  ],
                  onChanged: (value) => setState(() => discountType = value!),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: discountValue.toString(),
                  decoration: InputDecoration(labelText: discountType == 'percentage' ? 'Discount Percentage' : 'Discount Amount'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => discountValue = double.tryParse(value) ?? 0,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: discountName,
                  decoration: const InputDecoration(labelText: 'Discount Name'),
                  onChanged: (value) => discountName = value,
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () { cart.removeDiscount(); Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Discount removed'))); }, child: const Text('Remove Discount')),
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () {
                  final discount = Discount(type: discountType, value: discountValue, name: discountName);
                  cart.applyDiscount(discount);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$discountName applied!')));
                },
                child: const Text('Apply'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showCheckoutDialog(BuildContext context, CartProvider cart) {
    String paymentMethod = 'Cash';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Complete Order'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Items: ${cart.itemCount}'),
                Text('Subtotal: \$${cart.subtotal.toStringAsFixed(2)}'),
                if (cart.discount != null) Text('Discount: -\$${cart.discountAmount.toStringAsFixed(2)}'),
                Text('${cart.taxConfig.taxName}: \$${cart.taxAmount.toStringAsFixed(2)}'),
                const SizedBox(height: 8),
                Text('Total: \$${cart.total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                DropdownButtonFormField(
                  value: paymentMethod,
                  items: const [
                    DropdownMenuItem(value: 'Cash', child: Text('Cash')),
                    DropdownMenuItem(value: 'Card', child: Text('Card')),
                    DropdownMenuItem(value: 'Mobile Money', child: Text('Mobile Money')),
                  ],
                  onChanged: (value) => setState(() => paymentMethod = value!),
                  decoration: const InputDecoration(labelText: 'Payment Method'),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Processing payment...')));
                  await Future.delayed(const Duration(milliseconds: 300));

                  try {
                    await cart.completeSale(paymentMethod: paymentMethod);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                  }
                },
                child: const Text('Complete Sale'),
              ),
            ],
          );
        },
      ),
    );
  }
}
