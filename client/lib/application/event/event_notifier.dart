import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../domain/entities/event.dart';
import '../../domain/repositories/event_repository.dart';
import '../../data/repositories/event_repository_impl.dart';
import '../../presentation/core/providers.dart';

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  return EventRepositoryImpl(ref.watch(dioProvider));
});

final eventListProvider =
    StateNotifierProvider<EventListNotifier, AsyncValue<List<Event>>>((ref) {
      return EventListNotifier(ref.watch(eventRepositoryProvider));
    });

class EventListNotifier extends StateNotifier<AsyncValue<List<Event>>> {
  final EventRepository _repository;

  EventListNotifier(this._repository) : super(const AsyncValue.loading());

  Future<void> loadEvents({
    List<String>? calendarIds,
    DateTime? from,
    DateTime? to,
  }) async {
    state = const AsyncValue.loading();
    final result = await _repository.getEvents(
      calendarIds: calendarIds,
      from: from,
      to: to,
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

  Future<void> deleteEvent(String id) async {
    await _repository.deleteEvent(id);
    final currentList = state.value ?? [];
    state = AsyncValue.data(currentList.where((e) => e.id != id).toList());
  }
}
