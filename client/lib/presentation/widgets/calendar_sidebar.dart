import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/calendar.dart';
import '../../application/calendar/calendar_notifier.dart';

class CalendarSidebar extends ConsumerWidget {
  const CalendarSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendarsAsync = ref.watch(calendarListProvider);

    return Container(
      width: 250,
      color: Colors.grey[100],
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'My Calendars',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _showCreateCalendarDialog(context, ref),
                ),
              ],
            ),
          ),
          Expanded(
            child: calendarsAsync.when(
              data: (calendars) => ListView.builder(
                itemCount: calendars.length,
                itemBuilder: (context, index) {
                  final calendar = calendars[index];
                  return ListTile(
                    leading: Icon(
                      Icons.circle,
                      color: Color(
                        int.parse(calendar.color.replaceAll('#', '0xFF')),
                      ),
                    ),
                    title: Text(calendar.name),
                    dense: true,
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          _showEditCalendarDialog(context, ref, calendar);
                        } else if (value == 'delete') {
                          _showDeleteConfirmation(context, ref, calendar);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'edit', child: Text('Edit')),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                      ],
                    ),
                    onTap: () {
                      // Toggle visibility in future
                    },
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateCalendarDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Calendar'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Calendar Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(calendarListProvider.notifier)
                  .createCalendar(nameController.text, '#FF5722');
              Navigator.pop(context);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showEditCalendarDialog(
    BuildContext context,
    WidgetRef ref,
    Calendar calendar,
  ) {
    final nameController = TextEditingController(text: calendar.name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Calendar'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Calendar Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(calendarListProvider.notifier)
                  .updateCalendar(
                    calendar.id,
                    nameController.text,
                    calendar.color,
                  );
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    WidgetRef ref,
    Calendar calendar,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Calendar'),
        content: Text(
          'Are you sure you want to delete "${calendar.name}"? This will also delete all events in this calendar.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () {
              ref
                  .read(calendarListProvider.notifier)
                  .deleteCalendar(calendar.id);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
