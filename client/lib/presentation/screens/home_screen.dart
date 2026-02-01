import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../application/auth/auth_notifier.dart';
import '../widgets/calendar_sidebar.dart';
import 'month_view.dart';
import 'agenda_view.dart';
import 'week_view.dart';
import 'day_view.dart';
import '../widgets/event_editor_dialog.dart';

enum CalendarView { month, week, day, agenda }

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  CalendarView _currentView = CalendarView.month;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Axes', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton<CalendarView>(
              value: _currentView,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.black54),
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              onChanged: (CalendarView? newValue) {
                if (newValue != null) {
                  setState(() {
                    _currentView = newValue;
                  });
                }
              },
              items: CalendarView.values.map((CalendarView view) {
                return DropdownMenuItem<CalendarView>(
                  value: view,
                  child: Text(
                    view.name[0].toUpperCase() + view.name.substring(1),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(width: 24),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authNotifierProvider.notifier).logout();
              context.go('/login');
            },
          ),
        ],
      ),
      body: Row(
        children: [
          const CalendarSidebar(),
          Expanded(child: _buildCurrentView()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const EventEditorDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCurrentView() {
    switch (_currentView) {
      case CalendarView.month:
        return const MonthView();
      case CalendarView.week:
        return const WeekView();
      case CalendarView.day:
        return const DayView();
      case CalendarView.agenda:
        return const AgendaView();
    }
  }
}
