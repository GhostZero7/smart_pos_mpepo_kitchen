import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import './database_helper.dart';

class OfflineQueueService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Check internet connectivity
  Future<bool> get isConnected async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  // Save transaction to local database when offline
  Future<void> queueTransaction(Map<String, dynamic> receiptData) async {
    if (await isConnected) {
      // If online, try to submit immediately
      await _submitToBackend(receiptData);
    } else {
      // If offline, save to local database
      await _dbHelper.insertPendingTransaction(receiptData);
      print('📱 Transaction queued offline: ${receiptData['receipt_number']}');
    }
  }

  // Process all pending transactions when back online
  Future<void> processPendingTransactions() async {
    if (!await isConnected) return;

    final pendingTransactions = await _dbHelper.getPendingTransactions();
    print('🔄 Processing ${pendingTransactions.length} pending transactions...');

    for (final transaction in pendingTransactions) {
      try {
        final receiptData = json.decode(transaction['receipt_data']);
        await _submitToBackend(receiptData);
        
        // Mark as completed
        await _dbHelper.updateTransactionStatus(transaction['id'], 'completed');
        print('✅ Processed queued transaction: ${receiptData['receipt_number']}');
      } catch (e) {
        // Increment retry count
        await _dbHelper.incrementRetryCount(transaction['id']);
        print('❌ Failed to process transaction: $e');
      }
    }

    // Clean up completed transactions
    await _dbHelper.deleteCompletedTransactions();
  }

  // Submit receipt to backend (simulate tax authority submission)
  Future<void> _submitToBackend(Map<String, dynamic> receiptData) async {
    // Simulate API call to backend/tax authority
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    
    // TODO: Replace with actual API call to your backend
    print('🌐 Submitting to backend: ${receiptData['receipt_number']}');
    
    // Simulate successful submission
    if (receiptData['total'] > 100) { // Simulate potential failure
      throw Exception('Simulated backend error for large amount');
    }
  }
}