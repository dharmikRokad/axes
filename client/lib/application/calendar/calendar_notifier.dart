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
      return CalendarListNotifier(ref.watch(calendarRepositoryProvider));
    });

class CalendarListNotifier extends StateNotifier<AsyncValue<List<Calendar>>> {
  final CalendarRepository _repository;

  CalendarListNotifier(this._repository) : super(const AsyncValue.loading()) {
    getCalendars();
  }

  Future<void> getCalendars() async {
    state = const AsyncValue.loading();
    final result = await _repository.getCalendars();
    state = result.fold(
      (l) => AsyncValue.error(l, StackTrace.current),
      (r) => AsyncValue.data(r),
    );
  }

  Future<void> createCalendar(String name, String color) async {
    final result = await _repository.createCalendar(name, color);
    result.fold(
      (l) => null, // Handle error side effect elsewhere if needed
      (newCalendar) {
        final currentList = state.value ?? [];
        state = AsyncValue.data([...currentList, newCalendar]);
      },
    );
  }
}
