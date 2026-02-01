import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/calendar.dart';
import '../../application/calendar/calendar_notifier.dart';
import '../../application/theme/theme_notifier.dart';

class CalendarSidebar extends ConsumerWidget {
  const CalendarSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendarsAsync = ref.watch(calendarListProvider);
    final themeAsync = ref.watch(themeModeNotifierProvider);
    final themeMode = themeAsync.valueOrNull ?? ThemeMode.system;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          right: BorderSide(color: colorScheme.outline.withOpacity(0.5)),
        ),
      ),
      child: Column(
        children: [
          _buildBranding(context),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My Calendars'.toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 1.2,
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, size: 20),
                  onPressed: () => _showCreateCalendarDialog(context, ref),
                  tooltip: 'Create new calendar',
                ),
              ],
            ),
          ),
          Expanded(
            child: calendarsAsync.when(
              data: (calendars) => ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: calendars.length,
                itemBuilder: (context, index) {
                  final calendar = calendars[index];
                  final isSelected = ref
                      .watch(selectedCalendarIdsProvider)
                      .contains(calendar.id);
                  final calendarColor = Color(
                    int.parse(calendar.color.replaceAll('#', '0xFF')),
                  );

                  return ListTile(
                    leading: SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: isSelected,
                        activeColor: calendarColor,
                        side: BorderSide(color: calendarColor, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        onChanged: (value) =>
                            _toggleCalendar(ref, calendar.id, value),
                      ),
                    ),
                    title: Text(
                      calendar.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    dense: true,
                    onTap: () => _toggleCalendar(ref, calendar.id, !isSelected),
                    trailing: IconButton(
                      icon: const Icon(Icons.more_vert, size: 18),
                      onPressed: () =>
                          _showEditCalendarDialog(context, ref, calendar),
                    ),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
          const Divider(height: 1),
          _buildThemeToggle(context, ref, themeMode),
        ],
      ),
    );
  }

  Widget _buildBranding(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.calendar_month,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'Axes',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeToggle(
    BuildContext context,
    WidgetRef ref,
    ThemeMode currentMode,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: colorScheme.onSurface.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            _ThemeToggleButton(
              icon: Icons.light_mode_outlined,
              isSelected: currentMode == ThemeMode.light,
              onTap: () => ref
                  .read(themeModeNotifierProvider.notifier)
                  .setThemeMode(ThemeMode.light),
            ),
            _ThemeToggleButton(
              icon: Icons.dark_mode_outlined,
              isSelected: currentMode == ThemeMode.dark,
              onTap: () => ref
                  .read(themeModeNotifierProvider.notifier)
                  .setThemeMode(ThemeMode.dark),
            ),
            _ThemeToggleButton(
              icon: Icons.settings_brightness_outlined,
              isSelected: currentMode == ThemeMode.system,
              onTap: () => ref
                  .read(themeModeNotifierProvider.notifier)
                  .setThemeMode(ThemeMode.system),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleCalendar(WidgetRef ref, String id, bool? value) {
    final currentSelected = ref.read(selectedCalendarIdsProvider);
    final newSelected = Set<String>.from(currentSelected);
    if (value == true) {
      newSelected.add(id);
    } else {
      newSelected.remove(id);
    }
    ref.read(selectedCalendarIdsProvider.notifier).state = newSelected;
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
}
