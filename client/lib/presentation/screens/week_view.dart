import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../application/event/event_notifier.dart';
import '../../domain/entities/event.dart';
import '../widgets/event_editor_dialog.dart';
import '../../application/calendar/calendar_notifier.dart';
import '../../domain/entities/calendar.dart';

class WeekView extends ConsumerStatefulWidget {
  const WeekView({super.key});

  @override
  ConsumerState<WeekView> createState() => _WeekViewState();
}

class _WeekViewState extends ConsumerState<WeekView> {
  final ScrollController _scrollController = ScrollController();
  DateTime _selectedWeek = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadEventsForWeek();

    // Scroll to 8 AM on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(8 * 60.0); // 60px per hour
    });
  }

  DateTime get _weekStart {
    final now = _selectedWeek;
    return now.subtract(Duration(days: now.weekday - 1));
  }

  DateTime get _weekEnd => _weekStart.add(const Duration(days: 7));

  void _loadEventsForWeek() {
    ref
        .read(eventListProvider.notifier)
        .loadEvents(from: _weekStart, to: _weekEnd);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eventsAsync = ref.watch(eventListProvider);
    final selectedIds = ref.watch(selectedCalendarIdsProvider);
    final calendarsAsync = ref.watch(calendarListProvider);

    ref.listen(selectedCalendarIdsProvider, (previous, next) {
      _loadEventsForWeek();
    });

    return Column(
      children: [
        _buildWeekHeader(),
        Expanded(
          child: eventsAsync.when(
            data: (events) =>
                _buildTimeGrid(events, selectedIds, calendarsAsync.value ?? []),
            loading: () {
              if (eventsAsync.hasValue) {
                return _buildTimeGrid(
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

  Widget _buildWeekHeader() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              setState(() {
                _selectedWeek = _selectedWeek.subtract(const Duration(days: 7));
                _loadEventsForWeek();
              });
            },
          ),
          Expanded(
            child: Text(
              '${DateFormat('MMM d').format(_weekStart)} - ${DateFormat('MMM d, yyyy').format(_weekEnd.subtract(const Duration(days: 1)))}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              setState(() {
                _selectedWeek = _selectedWeek.add(const Duration(days: 7));
                _loadEventsForWeek();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTimeGrid(
    List<Event> events,
    Set<String> selectedIds,
    List<Calendar> calendars,
  ) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time labels column
          _buildTimeLabels(),
          // Days columns
          Expanded(
            child: Row(
              children: List.generate(7, (index) {
                final day = _weekStart.add(Duration(days: index));
                final dayEvents = events.where((e) {
                  return e.startDateTime.year == day.year &&
                      e.startDateTime.month == day.month &&
                      e.startDateTime.day == day.day &&
                      selectedIds.contains(e.calendarId);
                }).toList();
                return Expanded(
                  child: _buildDayColumn(day, dayEvents, calendars),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeLabels() {
    return SizedBox(
      width: 60,
      child: Column(
        children: List.generate(24, (hour) {
          return SizedBox(
            height: 60,
            child: Text(
              DateFormat('HH:00').format(DateTime(2020, 1, 1, hour)),
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildDayColumn(
    DateTime day,
    List<Event> events,
    List<Calendar> calendars,
  ) {
    final isToday =
        DateTime.now().year == day.year &&
        DateTime.now().month == day.month &&
        DateTime.now().day == day.day;

    return Container(
      decoration: BoxDecoration(
        color: isToday ? Colors.blue.shade50 : null,
        border: Border(
          right: BorderSide(color: Colors.grey.shade300, width: 0.5),
        ),
      ),
      child: Stack(
        children: [
          // Hour grid lines
          Column(
            children: List.generate(24, (hour) {
              return Container(
                height: 60,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey.shade200, width: 0.5),
                  ),
                ),
              );
            }),
          ),
          // Day header
          Container(
            height: 40,
            color: isToday ? Colors.blue : Colors.grey.shade100,
            child: Center(
              child: Text(
                DateFormat('EEE d').format(day),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isToday ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
          // Events
          ...events.map((event) => _buildEventBlock(event, calendars)),
        ],
      ),
    );
  }

  Widget _buildEventBlock(Event event, List<Calendar> calendars) {
    final startHour =
        event.startDateTime.hour + event.startDateTime.minute / 60;
    final endHour = event.endDateTime.hour + event.endDateTime.minute / 60;
    final duration = endHour - startHour;

    final calendar = calendars.firstWhere(
      (c) => c.id == event.calendarId,
      orElse: () => Calendar(id: '', name: '', color: '#2196F3'),
    );
    final color = Color(int.parse(calendar.color.replaceFirst('#', '0xFF')));

    return Positioned(
      top: 40 + (startHour * 60), // 40 for header + hour offset
      left: 4,
      right: 4,
      height: duration * 60,
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => EventEditorDialog(event: event),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.8),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: color),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (duration > 0.5)
                Text(
                  '${DateFormat('h:mm a').format(event.startDateTime)} - ${DateFormat('h:mm a').format(event.endDateTime)}',
                  style: const TextStyle(color: Colors.white70, fontSize: 10),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
