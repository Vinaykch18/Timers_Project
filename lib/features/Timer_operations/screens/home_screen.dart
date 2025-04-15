import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timers_project/features/Timer_operations/bloc/timers_bloc.dart';
import 'package:timers_project/features/Timer_operations/bloc/timers_events.dart';
import 'package:timers_project/features/Timer_operations/bloc/timers_states.dart';
import 'package:timers_project/features/Timer_operations/models/timer_model.dart';
import 'package:timers_project/features/Timer_operations/screens/add_timer_screen.dart';
import 'package:timers_project/features/Timer_operations/screens/history_screen.dart';
import 'package:timers_project/Comman/widgets/category_section.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDarkMode;

  const HomeScreen({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TimerBloc>().add(LoadTimers());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timers'),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.onToggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              final repository = context.read<TimerBloc>().repository;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HistoryScreen(repository: repository),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<TimerBloc, TimerState>(
        builder: (context, state) {
          if (state is TimerLoaded) {
            final groupedTimers = _groupByCategory(state.timers);
            return ListView(
              children:
                  groupedTimers.entries.map((entry) {
                    return CategorySection(
                      category: entry.key,
                      timers: entry.value,
                    );
                  }).toList(),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTimerScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Map<String, List<TimerModel>> _groupByCategory(List<TimerModel> timers) {
    final Map<String, List<TimerModel>> grouped = {};
    for (var t in timers) {
      grouped.putIfAbsent(t.category, () => []).add(t);
    }
    return grouped;
  }
}
