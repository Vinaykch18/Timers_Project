import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timers_project/features/Timer_operations/bloc/timers_bloc.dart';
import 'package:timers_project/features/Timer_operations/bloc/timers_states.dart';
import 'package:timers_project/features/Timer_operations/bloc/timers_events.dart';
import '../../../Core/repositories/timer_repository.dart';

class HistoryScreen extends StatelessWidget {
  final TimerRepository repository;

  const HistoryScreen({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    final completed = repository.getCompletedTimers();

    return BlocListener<TimerBloc, TimerState>(
      listener: (context, state) {
        if (state is TimerExported) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Timers exported successfully',
                style: TextStyle(color: Colors.green),
              ),
            ),
          );
        } else if (state is TimerExportFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to export timers: ${state.errorMessage}'),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('History')),
        body:
            completed.isEmpty
                ? const Center(child: Text('No completed timers yet.'))
                : ListView.builder(
                  itemCount: completed.length,
                  itemBuilder: (_, index) {
                    final timer = completed[index];
                    return ListTile(
                      title: Text(timer.name),
                      subtitle: Text('Completed: ${timer.completionTime}'),
                    );
                  },
                ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.read<TimerBloc>().add(ExportTimers());
          },
          tooltip: 'Export Timer Data',
          child: Icon(Icons.download),
        ),
      ),
    );
  }
}
