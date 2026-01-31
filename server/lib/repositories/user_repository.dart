import 'package:mongo_dart/mongo_dart.dart';
import '../data_sources/mongo_data_source.dart';
import '../models/user.dart';

class UserRepository {
  DbCollection get _users => MongoDataSource.db.collection('users');

  Future<User?> findByEmail(String email) async {
    final data = await _users.findOne(where.eq('email', email));
    if (data == null) return null;
    
    // Convert ObjectId to String for the model
    data['_id'] = (data['_id'] as ObjectId).toHexString();
    return User.fromJson(data);
  }

  Future<User?> findById(String id) async {
    final data = await _users.findOne(where.id(ObjectId.parse(id)));
    if (data == null) return null;

    data['_id'] = (data['_id'] as ObjectId).toHexString();
    return User.fromJson(data);
  }

  Future<User> createUser({
    required String email,
    required String passwordHash,
    String timezone = 'UTC',
  }) async {
    final id = ObjectId();
    final now = DateTime.now();

    final user = User(
      id: id.toHexString(),
      email: email,
      passwordHash: passwordHash,
      timezone: timezone,
      createdAt: now,
    );

    final json = user.toJson();
    json['_id'] = id; // Store as ObjectId

    await _users.insert(json);
    return user;
  }
}
