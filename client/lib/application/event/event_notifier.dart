import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../domain/entities/event.dart';
import '../../domain/repositories/event_repository.dart';
import '../../data/repositories/event_repository_impl.dart';
import '../../presentation/core/providers.dart';
import '../calendar/calendar_notifier.dart';

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  return EventRepositoryImpl(ref.watch(dioProvider));
});

final eventListProvider =
    StateNotifierProvider<EventListNotifier, AsyncValue<List<Event>>>((ref) {
      return EventListNotifier(ref);
    });

class EventListNotifier extends StateNotifier<AsyncValue<List<Event>>> {
  final EventRepository _repository;
  final Ref ref;
  DateTime? _lastFrom;
  DateTime? _lastTo;

  EventListNotifier(this.ref)
    : _repository = ref.read(eventRepositoryProvider),
      super(const AsyncValue.loading());

  Future<void> loadEvents({
    List<String>? calendarIds,
    DateTime? from,
    DateTime? to,
  }) async {
    final ids = calendarIds ?? ref.read(selectedCalendarIdsProvider).toList();
    final currentFrom = from ?? _lastFrom;
    final currentTo = to ?? _lastTo;

    // Basic caching: if parameters haven't changed and we have data, skip loading
    if (state.hasValue &&
        _lastFrom == from &&
        _lastTo == to &&
        ids.length ==
            (calendarIds?.length ??
                ref.read(selectedCalendarIdsProvider).length)) {
      // This is a very simple check, could be more robust by comparing ID sets
      bool sameIds = true;
      final currentIds = ref.read(selectedCalendarIdsProvider);
      if (calendarIds != null) {
        if (calendarIds.length != currentIds.length) {
          sameIds = false;
        } else {
          for (final id in calendarIds) {
            if (!currentIds.contains(id)) {
              sameIds = false;
              break;
            }
          }
        }
      }

      if (sameIds && from == _lastFrom && to == _lastTo) {
        return;
      }
    }

    if (from != null) _lastFrom = from;
    if (to != null) _lastTo = to;

    state = AsyncLoading<List<Event>>().copyWithPrevious(state);

    if (ids.isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }

    final result = await _repository.getEvents(
      calendarIds: ids,
      from: currentFrom,
      to: currentTo,
    );
    state = result.fold(
      (l) => AsyncValue.error(l, StackTrace.current),
      (r) => AsyncValue.data(r),
    );
  }

  Future<void> createEvent(Event event) async {
    final result = await _repository.createEvent(event);
    result.fold((l) => null, (newEvent) {
      final currentList = state.value ?? [];
      state = AsyncValue.data([...currentList, newEvent]);
    });
  }

  Future<void> updateEvent(String id, Map<String, dynamic> updates) async {
    final result = await _repository.updateEvent(id, updates);
    result.fold((l) => null, (updatedEvent) {
      final currentList = state.value ?? [];
      state = AsyncValue.data(
        currentList.map((e) {
          if (e.id == id) {
            // Merge the updates into the existing event
            // Ideally the repository returns the full updated event
            return updatedEvent;
          }
          return e;
        }).toList(),
      );
    });
  }

  Future<void> deleteEvent(String id) async {
    await _repository.deleteEvent(id);
    final currentList = state.value ?? [];
    state = AsyncValue.data(currentList.where((e) => e.id != id).toList());
  }
}
