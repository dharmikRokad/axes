import '../models/event.dart';
import '../models/recurrence_rule.dart';

class RecurrenceService {
  /// Expand a recurring event into individual instances for a date range
  List<Event> expandRecurringEvent({
    required Event masterEvent,
    required DateTime rangeStart,
    required DateTime rangeEnd,
    List<DateTime> exceptions = const [],
  }) {
    if (masterEvent.recurrenceRule == null ||
        masterEvent.recurrenceRule!.isEmpty) {
      return [masterEvent];
    }

    final instances = <Event>[];
    final rrule = RecurrenceRule.fromRRULE(masterEvent.recurrenceRule!);

    var currentDate = masterEvent.startDateTime;
    var instanceCount = 0;
    final maxInstances = rrule.count ?? 365; // Safety limit

    while (currentDate.isBefore(rangeEnd) && instanceCount < maxInstances) {
      // Check if within range and not an exception
      if (currentDate.isAfter(rangeStart.subtract(const Duration(days: 1))) &&
          !_isException(currentDate, exceptions)) {
        // Calculate instance end time
        final duration =
            masterEvent.endDateTime.difference(masterEvent.startDateTime);
        final instanceEnd = currentDate.add(duration);

        instances.add(
          masterEvent.copyWith(
            id: '${masterEvent.id}_${currentDate.toIso8601String()}',
            startDateTime: currentDate,
            endDateTime: instanceEnd,
            baseEventId: masterEvent.id,
          ),
        );
      }

      instanceCount++;

      // Move to next occurrence
      currentDate = _getNextOccurrence(currentDate, rrule);

      // Check until condition
      if (rrule.until != null && currentDate.isAfter(rrule.until!)) {
        break;
      }

      // Check count condition
      if (rrule.count != null && instanceCount >= rrule.count!) {
        break;
      }
    }

    return instances;
  }

  DateTime _getNextOccurrence(DateTime current, RecurrenceRule rrule) {
    switch (rrule.frequency) {
      case Frequency.daily:
        return current.add(Duration(days: rrule.interval));

      case Frequency.weekly:
        if (rrule.byWeekDay.isNotEmpty) {
          // Find next matching weekday
          var next = current.add(const Duration(days: 1));
          while (!rrule.byWeekDay.contains(next.weekday % 7)) {
            next = next.add(const Duration(days: 1));
          }
          return next;
        }
        return current.add(Duration(days: 7 * rrule.interval));

      case Frequency.monthly:
        if (rrule.byMonthDay.isNotEmpty) {
          final nextMonth = DateTime(
            current.year,
            current.month + rrule.interval,
            rrule.byMonthDay.first,
          );
          return nextMonth;
        }
        return DateTime(
          current.year,
          current.month + rrule.interval,
          current.day,
        );

      case Frequency.yearly:
        return DateTime(
          current.year + rrule.interval,
          current.month,
          current.day,
        );
    }
  }

  bool _isException(DateTime date, List<DateTime> exceptions) {
    return exceptions.any((ex) =>
        ex.year == date.year && ex.month == date.month && ex.day == date.day);
  }
}
