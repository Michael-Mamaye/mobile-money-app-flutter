import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/transfer.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  Future<List<Transfer>> getTransfers() async {
    final db = await _getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('transfers', orderBy: 'timestamp DESC');
    return List.generate(maps.length, (i) => Transfer.fromJson(maps[i]));
  }

  Future<void> addTransfer(Transfer transfer) async {
    final db = await _getDatabase();
    await db.insert(
      'transfers',
      transfer.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Database> _getDatabase() async {
    if (_database != null) return _database!;
    final path = join(await getDatabasesPath(), 'transfers.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE transfers(
            id TEXT PRIMARY KEY,
            recipientName TEXT NOT NULL,
            amount REAL NOT NULL,
            timestamp TEXT NOT NULL,
            status TEXT NOT NULL
          )
        ''');
        // Insert sample data
        await _insertSampleData(db);
      },
    );
    return _database!;
  }

  Future<void> _insertSampleData(Database db) async {
    final sampleTransfers = [
      Transfer(
        id: '1',
        recipientName: 'John Doe',
        amount: 100.0,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        status: TransferStatus.success,
      ),
      Transfer(
        id: '2',
        recipientName: 'Jane Smith',
        amount: 250.0,
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        status: TransferStatus.pending,
      ),
      Transfer(
        id: '3',
        recipientName: 'Mike Johnson',
        amount: 75.0,
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        status: TransferStatus.failed,
      ),
      Transfer(
        id: '4',
        recipientName: 'Sarah Wilson',
        amount: 150.0,
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        status: TransferStatus.success,
      ),
      Transfer(
        id: '5',
        recipientName: 'David Brown',
        amount: 300.0,
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        status: TransferStatus.pending,
      ),
    ];

    for (var transfer in sampleTransfers) {
      await db.insert(
        'transfers',
        transfer.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<void> updateTransfer(Transfer transfer) async {
    try {
      final db = await _getDatabase();
      await db.update(
        'transfers',
        transfer.toJson(),
        where: 'id = ?',
        whereArgs: [transfer.id],
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTransfer(String id) async {
    try {
      final db = await _getDatabase();
      await db.delete(
        'transfers',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      rethrow;
    }
  }
} 