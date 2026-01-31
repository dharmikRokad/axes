import 'package:axes_server/data_sources/mongo_data_source.dart';
import 'package:axes_server/models/event.dart';
import 'package:axes_server/services/recurrence_service.dart';
import 'package:mongo_dart/mongo_dart.dart';

class EventRepository {
  DbCollection get _events => MongoDataSource.db.collection('events');
  final _recurrenceService = RecurrenceService();

  Future<List<Event>> getEvents({
    List<String>? calendarIds,
    DateTime? from,
    DateTime? to,
  }) async {
    final selector = where.eq('deletedAt', null).sortBy('startDateTime');

    if (calendarIds != null && calendarIds.isNotEmpty) {
      selector.oneFrom(
        'calendarId',
        calendarIds.map((id) => ObjectId.parse(id)).toList(),
      );
    }

    if (from != null || to != null) {
      final dateQuery = <String, dynamic>{};
      if (from != null) dateQuery[r'$gte'] = from;
      if (to != null) dateQuery[r'$lte'] = to;
      selector.and(where.raw({'startDateTime': dateQuery}));
    }

    final results = await _events.find(selector).toList();
    final events = results.map(_sanitizeEventMap).toList();

    // Expand recurring events if date range is provided
    if (from != null && to != null) {
      final expandedEvents = <Event>[];
      for (final event in events) {
        if (event.recurrenceRule != null && event.recurrenceRule!.isNotEmpty) {
          expandedEvents.addAll(
            _recurrenceService.expandRecurringEvent(
              masterEvent: event,
              rangeStart: from,
              rangeEnd: to,
            ),
          );
        } else {
          expandedEvents.add(event);
        }
      }
      return expandedEvents;
    }

    return events;
  }

  Event _sanitizeEventMap(Map<String, dynamic> data) {
    data['_id'] = (data['_id'] as ObjectId).toHexString();
    if (data['calendarId'] is ObjectId) {
      data['calendarId'] = (data['calendarId'] as ObjectId).toHexString();
    }

    // Convert DateTime to ISO8601 strings for JSON serialization
    final dateFields = [
      'startDateTime',
      'endDateTime',
      'recurrenceExceptionDate',
      'createdAt',
      'updatedAt',
      'deletedAt',
    ];

    for (final field in dateFields) {
      if (data[field] is DateTime) {
        data[field] = (data[field] as DateTime).toIso8601String();
      }
    }

    return Event.fromJson(data);
  }

  Future<Event?> getEventById(String id) async {
    final data = await _events.findOne(where.id(ObjectId.parse(id)));
    if (data == null) return null;

    return _sanitizeEventMap(data);
  }

  Future<Event> createEvent(Event event) async {
    final id = ObjectId();
    final now = DateTime.now();

    final json = event.toJson();
    json['_id'] = id;
    json['calendarId'] = ObjectId.parse(event.calendarId);
    json['createdAt'] = now;
    json['updatedAt'] = now;

    // Ensure dates are stored as DateTime objects for MongoDB ISODate
    json['startDateTime'] = event.startDateTime;
    json['endDateTime'] = event.endDateTime;
    if (event.recurrenceExceptionDate != null) {
      json['recurrenceExceptionDate'] = event.recurrenceExceptionDate;
    }

    await _events.insert(json);

    return event.copyWith(
      id: id.toHexString(),
      createdAt: now,
      updatedAt: now,
    );
  }

  Future<Event?> updateEvent(String id, Map<String, dynamic> updates) async {
    final modifier = modify.set('updatedAt', DateTime.now());

    final fields = [
      'calendarId',
      'title',
      'description',
      'location',
      'startDateTime',
      'endDateTime',
      'allDay',
      'timezone',
      'recurrenceRule',
      'recurrenceExceptionDate',
    ];

    for (final field in fields) {
      if (updates.containsKey(field)) {
        var value = updates[field];
        if (field == 'calendarId' && value is String) {
          value = ObjectId.parse(value);
        } else if ((field == 'startDateTime' ||
                field == 'endDateTime' ||
                field == 'recurrenceExceptionDate') &&
            value is String) {
          value = DateTime.parse(value);
        }
        modifier.set(field, value);
      }
    }

    await _events.updateOne(where.id(ObjectId.parse(id)), modifier);
    return getEventById(id);
  }

  Future<void> deleteEvent(String id) async {
    await _events.updateOne(
      where.id(ObjectId.parse(id)),
      modify.set('deletedAt', DateTime.now()),
    );
  }
}
