import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timers_project/bloc/timers_states.dart';
import '../models/timer_model.dart';
import '../bloc/timers_bloc.dart';
import '../bloc/timers_events.dart';
import 'timer_card.dart';

class CategorySection extends StatefulWidget {
  final String category;
  final List<TimerModel> timers;

  const CategorySection({
    super.key,
    required this.category,
    required this.timers,
  });

  @override
  State<CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  bool expanded = true;
  Set<String> completedTimers = {};

  @override
  Widget build(BuildContext context) {
    return BlocListener<TimerBloc, TimerState>(
      listener: (context, state) {
        if (state is TimerLoaded) {
          for (var timer in state.timers) {
            if (timer.isCompleted && !completedTimers.contains(timer.id)) {
              completedTimers.add(timer.id);
              _showCompletionDialog(context, timer.name);
            }
          }
        }
      },
      child: ExpansionTile(
        title: Text(widget.category),
        initiallyExpanded: expanded,
        onExpansionChanged: (val) => setState(() => expanded = val),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<TimerBloc>().add(
                        StartCategoryTimers(widget.category),
                      );
                    },
                    icon: Icon(Icons.play_arrow),
                    label: Text('Start All'),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<TimerBloc>().add(
                        PauseCategoryTimers(widget.category),
                      );
                    },
                    icon: Icon(Icons.pause),
                    label: Text('Pause All'),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<TimerBloc>().add(
                        ResetCategoryTimers(widget.category),
                      );
                    },
                    icon: Icon(Icons.refresh),
                    label: Text('Reset All'),
                  ),
                ],
              ),
            ),
          ),
          ...widget.timers.map((timer) {
            return TimerCard(
              timer: timer,
              onStart: () {
                if (!timer.isRunning) {
                  context.read<TimerBloc>().add(StartTimer(timer.id));
                }
              },
              onPause: () {
                context.read<TimerBloc>().add(PauseTimer(timer.id));
              },
              onReset: () {
                if (!timer.isRunning) {
                  context.read<TimerBloc>().add(ResetTimer(timer.id));
                }
              },
            );
          }).toList(),
        ],
      ),
    );
  }

  void _showCompletionDialog(BuildContext context, String timerName) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Congratulations!'),
          content: Text('Timer "$timerName" has completed!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    ).then((_) {
      Future.delayed(Duration(seconds: 3), () {
        Navigator.of(context).pop();
      });
    });
  }
}
