import 'package:mongo_dart/mongo_dart.dart';
import 'package:dotenv/dotenv.dart';

class MongoDataSource {
  static Db? _db;

  static Future<void> init({DotEnv? env}) async {
    if (_db != null && _db!.isConnected) return;

    final connectionString = env?['MONGODB_URI'];
    if (connectionString == null) {
      throw Exception('MONGODB_URI not found in .env file');
    }

    _db = await Db.create(connectionString);
    await _db!.open();
    print('✅ MongoDB connected successfully');
  }

  static Db get db {
    if (_db == null || !_db!.isConnected) {
      throw Exception('Database not initialized. Call init() first.');
    }
    return _db!;
  }
}
