import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../application/event/event_notifier.dart';
import '../../application/calendar/calendar_notifier.dart';
import '../../domain/entities/event.dart';

class EventEditorDialog extends ConsumerStatefulWidget {
  final Event? event;

  const EventEditorDialog({super.key, this.event});

  @override
  ConsumerState<EventEditorDialog> createState() => _EventEditorDialogState();
}

class _EventEditorDialogState extends ConsumerState<EventEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;

  DateTime _startDateTime = DateTime.now();
  DateTime _endDateTime = DateTime.now().add(const Duration(hours: 1));
  bool _allDay = false;
  String? _selectedCalendarId;

  // Recurrence fields
  bool _isRecurring = false;
  String _frequency = 'DAILY';
  int _interval = 1;
  DateTime? _recurrenceEndDate;
  int? _recurrenceCount;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event?.title ?? '');
    _descriptionController = TextEditingController(
      text: widget.event?.description ?? '',
    );
    _locationController = TextEditingController(
      text: widget.event?.location ?? '',
    );

    if (widget.event != null) {
      _startDateTime = widget.event!.startDateTime;
      _endDateTime = widget.event!.endDateTime;
      _allDay = widget.event!.allDay;
      _selectedCalendarId = widget.event!.calendarId;
      _isRecurring =
          widget.event!.recurrenceRule != null &&
          widget.event!.recurrenceRule!.isNotEmpty;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  String _buildRecurrenceRule() {
    if (!_isRecurring) return '';

    final parts = <String>[];
    parts.add('FREQ=$_frequency');

    if (_interval > 1) {
      parts.add('INTERVAL=$_interval');
    }

    if (_recurrenceCount != null && _recurrenceCount! > 0) {
      parts.add('COUNT=$_recurrenceCount');
    } else if (_recurrenceEndDate != null) {
      parts.add('UNTIL=${_recurrenceEndDate!.toIso8601String()}');
    }

    return parts.join(';');
  }

  @override
  Widget build(BuildContext context) {
    final calendarsAsync = ref.watch(calendarListProvider);

    return Dialog(
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.event == null ? 'Create Event' : 'Edit Event',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 24),

                // Title
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 16),

                // Calendar selector
                calendarsAsync.when(
                  data: (calendars) {
                    if (_selectedCalendarId == null && calendars.isNotEmpty) {
                      _selectedCalendarId = calendars.first.id;
                    }
                    return DropdownButtonFormField<String>(
                      initialValue: _selectedCalendarId,
                      decoration: const InputDecoration(
                        labelText: 'Calendar',
                        border: OutlineInputBorder(),
                      ),
                      items: calendars
                          .map(
                            (cal) => DropdownMenuItem(
                              value: cal.id,
                              child: Text(cal.name),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _selectedCalendarId = value),
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (_, __) => const Text('Error loading calendars'),
                ),
                const SizedBox(height: 16),

                // Start/End DateTime
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: const Text('Start'),
                        subtitle: Text(
                          DateFormat(
                            'MMM d, yyyy h:mm a',
                          ).format(_startDateTime),
                        ),
                        onTap: () => _pickDateTime(true),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: const Text('End'),
                        subtitle: Text(
                          DateFormat('MMM d, yyyy h:mm a').format(_endDateTime),
                        ),
                        onTap: () => _pickDateTime(false),
                      ),
                    ),
                  ],
                ),

                CheckboxListTile(
                  title: const Text('All day'),
                  value: _allDay,
                  onChanged: (value) =>
                      setState(() => _allDay = value ?? false),
                ),

                const Divider(),

                // Recurrence section
                SwitchListTile(
                  title: const Text('Repeat'),
                  value: _isRecurring,
                  onChanged: (value) => setState(() => _isRecurring = value),
                ),

                if (_isRecurring) ...[
                  DropdownButtonFormField<String>(
                    initialValue: _frequency,
                    decoration: const InputDecoration(
                      labelText: 'Frequency',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'DAILY', child: Text('Daily')),
                      DropdownMenuItem(value: 'WEEKLY', child: Text('Weekly')),
                      DropdownMenuItem(
                        value: 'MONTHLY',
                        child: Text('Monthly'),
                      ),
                      DropdownMenuItem(value: 'YEARLY', child: Text('Yearly')),
                    ],
                    onChanged: (value) => setState(() => _frequency = value!),
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    initialValue: _interval.toString(),
                    decoration: const InputDecoration(
                      labelText: 'Repeat every',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => _interval = int.tryParse(value) ?? 1,
                  ),
                  const SizedBox(height: 16),

                  ListTile(
                    title: const Text('End date (optional)'),
                    subtitle: Text(
                      _recurrenceEndDate != null
                          ? DateFormat(
                              'MMM d, yyyy',
                            ).format(_recurrenceEndDate!)
                          : 'Never',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate:
                              _recurrenceEndDate ??
                              DateTime.now().add(const Duration(days: 30)),
                          firstDate: _startDateTime,
                          lastDate: DateTime.now().add(
                            const Duration(days: 365 * 2),
                          ),
                        );
                        if (date != null) {
                          setState(() => _recurrenceEndDate = date);
                        }
                      },
                    ),
                  ),
                ],

                const SizedBox(height: 16),

                // Description
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),

                // Location
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 24),

                // Actions
                Row(
                  children: [
                    if (widget.event != null)
                      TextButton(
                        onPressed: () {
                          ref
                              .read(eventListProvider.notifier)
                              .deleteEvent(widget.event!.id);
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        child: const Text('Delete'),
                      ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _saveEvent,
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickDateTime(bool isStart) async {
    final date = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDateTime : _endDateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
          isStart ? _startDateTime : _endDateTime,
        ),
      );

      if (time != null) {
        final dateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
        setState(() {
          if (isStart) {
            _startDateTime = dateTime;
            if (_endDateTime.isBefore(_startDateTime)) {
              _endDateTime = _startDateTime.add(const Duration(hours: 1));
            }
          } else {
            _endDateTime = dateTime;
          }
        });
      }
    }
  }

  Future<void> _saveEvent() async {
    if (!_formKey.currentState!.validate() || _selectedCalendarId == null) {
      return;
    }

    final event = Event(
      id: widget.event?.id ?? '',
      calendarId: _selectedCalendarId!,
      title: _titleController.text,
      description: _descriptionController.text,
      location: _locationController.text,
      startDateTime: _startDateTime,
      endDateTime: _endDateTime,
      allDay: _allDay,
      recurrenceRule: _buildRecurrenceRule(),
    );

    if (widget.event == null) {
      await ref.read(eventListProvider.notifier).createEvent(event);
    } else {
      await ref.read(eventListProvider.notifier).updateEvent(event.id, {
        'title': _titleController.text,
        'description': _descriptionController.text,
        'location': _locationController.text,
        'startDateTime': _startDateTime.toIso8601String(),
        'endDateTime': _endDateTime.toIso8601String(),
        'allDay': _allDay,
        'recurrenceRule': _buildRecurrenceRule(),
        'calendarId': _selectedCalendarId,
      });
    }

    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
}
