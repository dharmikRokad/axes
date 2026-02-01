import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../application/event/event_notifier.dart';
import '../../application/calendar/calendar_notifier.dart';
import '../../domain/entities/event.dart';
import '../../domain/entities/calendar.dart';
import '../widgets/event_editor_dialog.dart';

class AgendaView extends ConsumerStatefulWidget {
  const AgendaView({super.key});

  @override
  ConsumerState<AgendaView> createState() => _AgendaViewState();
}

class _AgendaViewState extends ConsumerState<AgendaView> {
  @override
  void initState() {
    super.initState();
    _loadAgenda();
  }

  void _loadAgenda() {
    // Load events for next 30 days
    final from = DateTime.now();
    final to = from.add(const Duration(days: 30));
    ref.read(eventListProvider.notifier).loadEvents(from: from, to: to);
  }

  @override
  Widget build(BuildContext context) {
    final eventsAsync = ref.watch(eventListProvider);
    final selectedIds = ref.watch(selectedCalendarIdsProvider);
    final calendarsAsync = ref.watch(calendarListProvider);

    ref.listen(selectedCalendarIdsProvider, (previous, next) {
      _loadAgenda();
    });

    return eventsAsync.when(
      data: (events) =>
          _buildAgendaList(events, selectedIds, calendarsAsync.value ?? []),
      loading: () {
        if (eventsAsync.hasValue) {
          return _buildAgendaList(
            eventsAsync.value!,
            selectedIds,
            calendarsAsync.value ?? [],
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }

  Widget _buildAgendaList(
    List<Event> events,
    Set<String> selectedIds,
    List<Calendar> calendars,
  ) {
    if (events.isEmpty) {
      return const Center(child: Text('No upcoming events'));
    }

    // Group events by date and filter by selected calendars
    final groupedEvents = <String, List<dynamic>>{};
    for (final event in events) {
      if (!selectedIds.contains(event.calendarId)) continue;
      final dateKey = DateFormat('yyyy-MM-dd').format(event.startDateTime);
      groupedEvents.putIfAbsent(dateKey, () => []).add(event);
    }

    if (groupedEvents.isEmpty) {
      return const Center(child: Text('No events for selected calendars'));
    }

    final sortedKeys = groupedEvents.keys.toList()..sort();

    return ListView.builder(
      itemCount: sortedKeys.length,
      itemBuilder: (context, index) {
        final dateKey = sortedKeys[index];
        final dayEvents = groupedEvents[dateKey]!;
        final date = DateTime.parse(dateKey);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                DateFormat('EEEE, MMMM d').format(date),
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            ...dayEvents.map((event) {
              return ListTile(
                leading: Container(
                  width: 4,
                  height: 40,
                  color: () {
                    if (calendars.isEmpty) return Colors.blue;
                    final calendar = calendars.firstWhere(
                      (c) => c.id == event.calendarId,
                      orElse: () => calendars.first,
                    );
                    return Color(
                      int.parse(calendar.color.replaceFirst('#', '0xFF')),
                    );
                  }(),
                ),
                title: Text(event.title),
                subtitle: Text(event.description),
                trailing: Text(
                  DateFormat('h:mm a').format(event.startDateTime),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => EventEditorDialog(event: event),
                  );
                },
              );
            }),
            const Divider(),
          ],
        );
      },
    );
  }
}
