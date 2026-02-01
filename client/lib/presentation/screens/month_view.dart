import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
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

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate row height to fill the available space
        // Subtract header height (approx 100) and dow height (approx 40)
        final availableHeight = constraints.maxHeight - 140;
        final rowHeight = (availableHeight / 6).clamp(100.0, 250.0);

        return TableCalendar<Event>(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          rowHeight: rowHeight,
          daysOfWeekHeight: 40  ,
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          calendarStyle: CalendarStyle(
            outsideDaysVisible: true,
            tableBorder: TableBorder.all(
              color: Colors.grey.shade200,
              width: 0.5,
            ),
          ),
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
          calendarBuilders: CalendarBuilders(
            dowBuilder: (context, day) {
              final text = DateFormat.EEEE().format(day);
              return Center(
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              );
            },
            defaultBuilder: (context, day, focusedDay) {
              return _buildCell(
                day,
                eventsAsync.value ?? [],
                selectedIds,
                calendarsAsync.value ?? [],
              );
            },
            todayBuilder: (context, day, focusedDay) {
              return _buildCell(
                day,
                eventsAsync.value ?? [],
                selectedIds,
                calendarsAsync.value ?? [],
                isToday: true,
              );
            },
            outsideBuilder: (context, day, focusedDay) {
              return _buildCell(
                day,
                eventsAsync.value ?? [],
                selectedIds,
                calendarsAsync.value ?? [],
                isOutside: true,
              );
            },
            selectedBuilder: (context, day, focusedDay) {
              return _buildCell(
                day,
                eventsAsync.value ?? [],
                selectedIds,
                calendarsAsync.value ?? [],
                isSelected: true,
              );
            },
            markerBuilder: (context, day, events) => const SizedBox.shrink(),
          ),
        );
      },
    );
  }

  Widget _buildCell(
    DateTime day,
    List<Event> allEvents,
    Set<String> selectedIds,
    List<Calendar> calendars, {
    bool isToday = false,
    bool isOutside = false,
    bool isSelected = false,
  }) {
    final dayEvents = allEvents
        .where(
          (e) =>
              isSameDay(e.startDateTime, day) &&
              selectedIds.contains(e.calendarId),
        )
        .toList();

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200, width: 0.25),
        color: isSelected ? Colors.blue.withValues(alpha: 0.05) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                width: 24,
                height: 24,
                decoration: isToday
                    ? const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      )
                    : null,
                child: Center(
                  child: Text(
                    '${day.day}',
                    style: TextStyle(
                      color: isToday
                          ? Colors.white
                          : (isOutside ? Colors.grey : Colors.black87),
                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: dayEvents.length,
              itemBuilder: (context, index) {
                if (index >= 3) {
                  if (index == 3) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(
                        '+ ${dayEvents.length - 3} more',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.blueGrey,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }

                final event = dayEvents[index];
                final calendar = calendars.firstWhere(
                  (c) => c.id == event.calendarId,
                  orElse: () => Calendar(id: '', name: '', color: '#2196F3'),
                );
                final color = Color(
                  int.parse(calendar.color.replaceFirst('#', '0xFF')),
                );

                return _buildEventBar(event, color);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventBar(Event event, Color color) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => EventEditorDialog(event: event),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(4),
          border: Border(left: BorderSide(color: color, width: 3)),
        ),
        child: Text(
          event.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 10,
            color: color.withValues(alpha: 0.9),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
