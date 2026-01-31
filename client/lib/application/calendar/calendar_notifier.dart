import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../domain/entities/calendar.dart';
import '../../domain/repositories/calendar_repository.dart';
import '../../data/repositories/calendar_repository_impl.dart';
import '../../presentation/core/providers.dart';

final calendarRepositoryProvider = Provider<CalendarRepository>((ref) {
  return CalendarRepositoryImpl(ref.watch(dioProvider));
});

final calendarListProvider =
    StateNotifierProvider<CalendarListNotifier, AsyncValue<List<Calendar>>>((
      ref,
    ) {
      return CalendarListNotifier(ref);
    });

final selectedCalendarIdsProvider = StateProvider<Set<String>>(
  (ref) => <String>{},
);

class CalendarListNotifier extends StateNotifier<AsyncValue<List<Calendar>>> {
  final CalendarRepository _repository;

  final Ref _ref;

  CalendarListNotifier(this._ref)
    : _repository = _ref.read(calendarRepositoryProvider),
      super(const AsyncValue.loading()) {
    getCalendars();
  }

  Future<void> getCalendars() async {
    state = const AsyncValue.loading();
    final result = await _repository.getCalendars();
    state = result.fold((l) => AsyncValue.error(l, StackTrace.current), (r) {
      // Use microtask to avoid modifying providers during build if getCalendars is called synchronously
      Future.microtask(() {
        final currentSelected = _ref.read(selectedCalendarIdsProvider);
        if (currentSelected.isEmpty) {
          _ref.read(selectedCalendarIdsProvider.notifier).state = r
              .map((c) => c.id)
              .toSet();
        }
      });
      return AsyncValue.data(r);
    });
  }

  Future<void> createCalendar(String name, String color) async {
    final result = await _repository.createCalendar(name, color);
    result.fold(
      (l) => null, // Handle error side effect elsewhere if needed
      (newCalendar) {
        final currentList = state.value ?? [];
        state = AsyncValue.data([...currentList, newCalendar]);

        // Automatically select the newly created calendar
        final currentSelected = _ref.read(selectedCalendarIdsProvider);
        _ref.read(selectedCalendarIdsProvider.notifier).state = {
          ...currentSelected,
          newCalendar.id,
        };
      },
    );
  }

  Future<void> updateCalendar(String id, String name, String color) async {
    final result = await _repository.updateCalendar(id, name, color);
    result.fold((l) => null, (_) {
      final currentList = state.value ?? [];
      state = AsyncValue.data(
        currentList.map((c) {
          if (c.id == id) {
            return c.copyWith(name: name, color: color);
          }
          return c;
        }).toList(),
      );
    });
  }

  Future<void> deleteCalendar(String id) async {
    final result = await _repository.deleteCalendar(id);
    result.fold((l) => null, (_) {
      final currentList = state.value ?? [];
      state = AsyncValue.data(currentList.where((c) => c.id != id).toList());
    });
  }
}
