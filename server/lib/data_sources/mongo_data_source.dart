import 'dart:io';
import 'package:mongo_dart/mongo_dart.dart';

class MongoDataSource {
  static Db? _db;

  static Future<void> init() async {
    if (_db != null && _db!.isConnected) return;

    final connectionString = Platform.environment['MONGODB_URI'];
    if (connectionString == null) {
      throw Exception('MONGODB_URI not found in environment');
    }

    _db = await Db.create(connectionString);
    await _db!.open();
  }

  static Db get db {
    if (_db == null || !_db!.isConnected) {
      throw Exception('Database not initialized. Call init() first.');
    }
    return _db!;
  }
}
