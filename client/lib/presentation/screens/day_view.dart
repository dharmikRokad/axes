import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../application/event/event_notifier.dart';
import '../../domain/entities/event.dart';
import '../widgets/event_editor_dialog.dart';
import '../../application/calendar/calendar_notifier.dart';
import '../../domain/entities/calendar.dart';

class DayView extends ConsumerStatefulWidget {
  const DayView({super.key});

  @override
  ConsumerState<DayView> createState() => _DayViewState();
}

class _DayViewState extends ConsumerState<DayView> {
  final ScrollController _scrollController = ScrollController();
  DateTime _selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadEventsForDay();

    // Scroll to 8 AM on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(8 * 80.0); // 80px per hour for better spacing
    });
  }

  void _loadEventsForDay() {
    final dayStart = DateTime(
      _selectedDay.year,
      _selectedDay.month,
      _selectedDay.day,
    );
    final dayEnd = dayStart.add(const Duration(days: 1));

    ref.read(eventListProvider.notifier).loadEvents(from: dayStart, to: dayEnd);
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
      _loadEventsForDay();
    });

    return Column(
      children: [
        _buildDayHeader(),
        Expanded(
          child: eventsAsync.when(
            data: (events) {
              final todayEvents = events.where((e) {
                return e.startDateTime.year == _selectedDay.year &&
                    e.startDateTime.month == _selectedDay.month &&
                    e.startDateTime.day == _selectedDay.day &&
                    selectedIds.contains(e.calendarId);
              }).toList();
              return _buildTimeGrid(todayEvents, calendarsAsync.value ?? []);
            },
            loading: () {
              if (eventsAsync.hasValue) {
                final todayEvents = eventsAsync.value!.where((e) {
                  return e.startDateTime.year == _selectedDay.year &&
                      e.startDateTime.month == _selectedDay.month &&
                      e.startDateTime.day == _selectedDay.day &&
                      selectedIds.contains(e.calendarId);
                }).toList();
                return _buildTimeGrid(todayEvents, calendarsAsync.value ?? []);
              }
              return const Center(child: CircularProgressIndicator());
            },
            error: (err, stack) => Center(child: Text('Error: $err')),
          ),
        ),
      ],
    );
  }

  Widget _buildDayHeader() {
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
                _selectedDay = _selectedDay.subtract(const Duration(days: 1));
                _loadEventsForDay();
              });
            },
          ),
          Expanded(
            child: Text(
              DateFormat('EEEE, MMMM d, yyyy').format(_selectedDay),
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              setState(() {
                _selectedDay = _selectedDay.add(const Duration(days: 1));
                _loadEventsForDay();
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.today),
            onPressed: () {
              setState(() {
                _selectedDay = DateTime.now();
                _loadEventsForDay();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTimeGrid(List<Event> events, List<Calendar> calendars) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time labels
            SizedBox(
              width: 80,
              child: Column(
                children: List.generate(24, (hour) {
                  return SizedBox(
                    height: 80,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          DateFormat('h a').format(DateTime(2020, 1, 1, hour)),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            // Events column
            Expanded(
              child: Stack(
                children: [
                  // Hour grid lines
                  Column(
                    children: List.generate(24, (hour) {
                      return Container(
                        height: 80,
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Colors.grey.shade300,
                              width: hour == 0 ? 2 : 1,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  // Current time indicator
                  if (_isToday()) _buildCurrentTimeIndicator(),
                  // Events
                  ...events.map((event) => _buildEventBlock(event, calendars)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isToday() {
    final now = DateTime.now();
    return _selectedDay.year == now.year &&
        _selectedDay.month == now.month &&
        _selectedDay.day == now.day;
  }

  Widget _buildCurrentTimeIndicator() {
    final now = DateTime.now();
    final minutesSinceMidnight = now.hour * 60 + now.minute;
    final topOffset = (minutesSinceMidnight / 60) * 80; // 80px per hour

    return Positioned(
      top: topOffset,
      left: 0,
      right: 0,
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(child: Container(height: 2, color: Colors.red)),
        ],
      ),
    );
  }

  Widget _buildEventBlock(Event event, List<Calendar> calendars) {
    final startMinutes =
        event.startDateTime.hour * 60 + event.startDateTime.minute;
    final endMinutes = event.endDateTime.hour * 60 + event.endDateTime.minute;
    final durationMinutes = endMinutes - startMinutes;

    final topOffset = (startMinutes / 60) * 80;
    final height = (durationMinutes / 60) * 85;

    final calendar = calendars.firstWhere(
      (c) => c.id == event.calendarId,
      orElse: () => Calendar(id: '', name: '', color: '#2196F3'),
    );
    final color = Color(int.parse(calendar.color.replaceFirst('#', '0xFF')));

    return Positioned(
      top: topOffset,
      left: 8,
      right: 8,
      height: height,
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => EventEditorDialog(event: event),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.8),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                '${DateFormat('h:mm a').format(event.startDateTime)} - ${DateFormat('h:mm a').format(event.endDateTime)}',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              if (event.location.isNotEmpty && height > 60) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 12,
                      color: Colors.white70,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        event.location,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
