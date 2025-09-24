import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'mpepo_pos.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE pending_transactions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        receipt_data TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        retry_count INTEGER DEFAULT 0,
        last_attempt INTEGER DEFAULT 0,
        status TEXT DEFAULT 'pending'
      )
    ''');
  }

  // Save pending transaction
  Future<int> insertPendingTransaction(Map<String, dynamic> receiptData) async {
    final db = await database;
    return await db.insert('pending_transactions', {
      'receipt_data': receiptData.toString(),
      'created_at': DateTime.now().millisecondsSinceEpoch,
      'retry_count': 0,
      'last_attempt': 0,
      'status': 'pending'
    });
  }

  // Get all pending transactions
  Future<List<Map<String, dynamic>>> getPendingTransactions() async {
    final db = await database;
    return await db.query('pending_transactions', 
      where: 'status = ?', 
      whereArgs: ['pending'],
      orderBy: 'created_at ASC'
    );
  }

  // Update transaction status
  Future<void> updateTransactionStatus(int id, String status) async {
    final db = await database;
    await db.update(
      'pending_transactions',
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Increment retry count
  Future<void> incrementRetryCount(int id) async {
    final db = await database;
    // Get current retry count
    final result = await db.query(
      'pending_transactions',
      columns: ['retry_count'],
      where: 'id = ?',
      whereArgs: [id],
    );
    int currentRetryCount = 0;
    if (result.isNotEmpty && result.first['retry_count'] != null) {
      currentRetryCount = result.first['retry_count'] as int;
    }
    await db.update(
      'pending_transactions',
      {
        'retry_count': currentRetryCount + 1,
        'last_attempt': DateTime.now().millisecondsSinceEpoch
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete successful transactions
  Future<void> deleteCompletedTransactions() async {
    final db = await database;
    await db.delete('pending_transactions', 
      where: 'status = ?', 
      whereArgs: ['completed']
    );
  }
}