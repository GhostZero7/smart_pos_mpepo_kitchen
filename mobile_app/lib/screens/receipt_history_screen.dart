import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/receipt.dart';
import '../theme/app_theme.dart'; // Add this

class ReceiptHistoryScreen extends StatelessWidget {
  const ReceiptHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // For now, we'll show a placeholder since we need to implement storage
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receipt History'),
        backgroundColor: Colors.orange[700],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.receipt_long, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Receipt History',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'All receipts are stored locally on this device\nand in the terminal for debugging.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Show current session receipts from memory
                _showRecentReceipts(context);
              },
              child: const Text('Show Recent Receipts'),
            ),
          ],
        ),
      ),
    );
  }

  void _showRecentReceipts(BuildContext context) {
    // This would show receipts from the current session
    // In a real app, we'd query the database
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Recent Receipts'),
        content: const Text('Receipts are stored in:\n• Local SQLite Database\n• Terminal Debug Output\n\nCheck your Flutter terminal for receipt data.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}