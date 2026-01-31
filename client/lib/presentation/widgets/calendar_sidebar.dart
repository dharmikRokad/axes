import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
                  .createCalendar(
                    nameController.text,
                    '#FF5722', // Default color for now
                  );
              Navigator.pop(context);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
