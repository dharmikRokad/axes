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
                  final isSelected = ref
                      .watch(selectedCalendarIdsProvider)
                      .contains(calendar.id);

                  return ListTile(
                    leading: Checkbox(
                      value: isSelected,
                      activeColor: Color(
                        int.parse(calendar.color.replaceAll('#', '0xFF')),
                      ),
                      side: BorderSide(
                        color: Color(
                          int.parse(calendar.color.replaceAll('#', '0xFF')),
                        ),
                        width: 2,
                      ),
                      onChanged: (value) {
                        final currentSelected = ref.read(
                          selectedCalendarIdsProvider,
                        );
                        final newSelected = Set<String>.from(currentSelected);
                        if (value == true) {
                          newSelected.add(calendar.id);
                        } else {
                          newSelected.remove(calendar.id);
                        }
                        ref.read(selectedCalendarIdsProvider.notifier).state =
                            newSelected;
                      },
                    ),
                    title: Text(calendar.name),
                    dense: true,
                    onTap: () {
                      final currentSelected = ref.read(
                        selectedCalendarIdsProvider,
                      );
                      final newSelected = Set<String>.from(currentSelected);
                      if (isSelected) {
                        newSelected.remove(calendar.id);
                      } else {
                        newSelected.add(calendar.id);
                      }
                      ref.read(selectedCalendarIdsProvider.notifier).state =
                          newSelected;
                    },
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

  static const List<String> _colors = [
    '#D50000', // Tomato
    '#E67C73', // Flamingo
    '#F4511E', // Tangerine
    '#F6BF26', // Banana
    '#33B864', // Sage
    '#0B8043', // Basil
    '#039BE5', // Peacock
    '#3F51B5', // Blueberry
    '#7986CB', // Lavender
    '#8E24AA', // Grape
    '#616161', // Graphite
  ];

  void _showCreateCalendarDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    String selectedColor = _colors[0];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Create Calendar'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Calendar Name'),
                ),
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Select Color:'),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _colors.map((color) {
                    final isSelected = selectedColor == color;
                    return GestureDetector(
                      onTap: () => setState(() => selectedColor = color),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Color(
                            int.parse(color.replaceAll('#', '0xFF')),
                          ),
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(color: Colors.black, width: 2)
                              : null,
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                size: 20,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty) {
                    ref
                        .read(calendarListProvider.notifier)
                        .createCalendar(nameController.text, selectedColor);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Create'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showEditCalendarDialog(
    BuildContext context,
    WidgetRef ref,
    Calendar calendar,
  ) {
    final nameController = TextEditingController(text: calendar.name);
    String selectedColor = calendar.color;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Edit Calendar'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Calendar Name'),
                ),
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Select Color:'),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _colors.map((color) {
                    final isSelected = selectedColor == color;
                    return GestureDetector(
                      onTap: () => setState(() => selectedColor = color),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Color(
                            int.parse(color.replaceAll('#', '0xFF')),
                          ),
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(color: Colors.black, width: 2)
                              : null,
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                size: 20,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    );
                  }).toList(),
                ),
              ],
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
                        selectedColor,
                      );
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
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
