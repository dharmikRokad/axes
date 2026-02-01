import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../application/event/event_notifier.dart';
import '../../domain/entities/event.dart';
import '../widgets/event_editor_dialog.dart';
import '../../application/calendar/calendar_notifier.dart';
import '../../domain/entities/calendar.dart';

class MonthView extends ConsumerStatefulWidget {
  const MonthView({super.key});

  @override
  ConsumerState<MonthView> createState() => _MonthViewState();
}

class _MonthViewState extends ConsumerState<MonthView> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _loadEventsForMonth();
  }

  void _loadEventsForMonth() {
    final firstDay = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final lastDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);
    ref
        .read(eventListProvider.notifier)
        .loadEvents(from: firstDay, to: lastDay);
  }

  @override
  Widget build(BuildContext context) {
    final eventsAsync = ref.watch(eventListProvider);
    final selectedIds = ref.watch(selectedCalendarIdsProvider);
    final calendarsAsync = ref.watch(calendarListProvider);

    ref.listen(selectedCalendarIdsProvider, (previous, next) {
      _loadEventsForMonth();
    });

    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
            _loadEventsForMonth();
          },
          eventLoader: (day) {
            return eventsAsync.value
                    ?.where(
                      (e) =>
                          isSameDay(e.startDateTime, day) &&
                          selectedIds.contains(e.calendarId),
                    )
                    .toList() ??
                [];
          },
        ),
        const SizedBox(height: 16),
        Expanded(
          child: eventsAsync.when(
            data: (events) => _buildEventsList(
              events,
              selectedIds,
              calendarsAsync.value ?? [],
            ),
            loading: () {
              if (eventsAsync.hasValue) {
                return _buildEventsList(
                  eventsAsync.value!,
                  selectedIds,
                  calendarsAsync.value ?? [],
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
            error: (err, stack) => Center(child: Text('Error: $err')),
          ),
        ),
      ],
    );
  }

  Widget _buildEventsList(
    List<Event> events,
    Set<String> selectedIds,
    List<Calendar> calendars,
  ) {
    final selectedEvents = _selectedDay != null
        ? events
              .where(
                (e) =>
                    isSameDay(e.startDateTime, _selectedDay!) &&
                    selectedIds.contains(e.calendarId),
              )
              .toList()
        : <Event>[];

    if (selectedEvents.isEmpty) {
      return const Center(child: Text('No events for selected day'));
    }

    return ListView.builder(
      itemCount: selectedEvents.length,
      itemBuilder: (context, index) {
        final event = selectedEvents[index];
        final calendar = calendars.firstWhere(
          (c) => c.id == event.calendarId,
          orElse: () => Calendar(id: '', name: '', color: '#2196F3'),
        );
        final color = Color(
          int.parse(calendar.color.replaceFirst('#', '0xFF')),
        );

        return ListTile(
          leading: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          title: Text(event.title),
          subtitle: Text(
            '${event.startDateTime.hour}:${event.startDateTime.minute.toString().padLeft(2, '0')}',
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => EventEditorDialog(event: event),
            );
          },
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () =>
                ref.read(eventListProvider.notifier).deleteEvent(event.id),
          ),
        );
      },
    );
  }
}
