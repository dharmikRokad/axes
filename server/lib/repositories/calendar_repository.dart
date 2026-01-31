import 'package:axes_server/data_sources/mongo_data_source.dart';
import 'package:mongo_dart/mongo_dart.dart';

class CalendarRepository {
  DbCollection get _calendars => MongoDataSource.db.collection('calendars');

  Future<List<Map<String, dynamic>>> getCalendars(String ownerId) async {
    return await _calendars.find(where.eq('ownerId', ownerId)).toList();
  }

  Future<Map<String, dynamic>?> getCalendar(String id) async {
    return await _calendars.findOne(where.id(ObjectId.fromHexString(id)));
  }

  Future<Map<String, dynamic>> createCalendar(
      Map<String, dynamic> calendar) async {
    await _calendars.insert(calendar);
    return calendar;
  }

  Future<void> updateCalendar(String id, Map<String, dynamic> updates) async {
    await _calendars.update(
      where.id(ObjectId.fromHexString(id)),
      {'\$set': updates},
    );
  }

  Future<void> deleteCalendar(String id) async {
    await _calendars.remove(where.id(ObjectId.fromHexString(id)));
    // Also delete associated events (optional but recommended)
    await MongoDataSource.db
        .collection('events')
        .remove(where.eq('calendarId', id));
  }
}
