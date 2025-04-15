import 'package:flutter/material.dart';
import '../../features/Timer_operations/models/timer_model.dart';

class TimerCard extends StatelessWidget {
  final TimerModel timer;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onReset;

  const TimerCard({
    super.key,
    required this.timer,
    required this.onStart,
    required this.onPause,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final percent = timer.remaining.inSeconds / timer.duration;
    return Card(
      child: ListTile(
        title: Text(timer.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Remaining: ${timer.remaining.inSeconds}s'),
            LinearProgressIndicator(value: percent.clamp(0.0, 1.0)),
          ],
        ),
        trailing: Wrap(
          spacing: 8,
          children: [
            IconButton(icon: const Icon(Icons.play_arrow), onPressed: onStart),
            IconButton(icon: const Icon(Icons.pause), onPressed: onPause),
            IconButton(icon: const Icon(Icons.refresh), onPressed: onReset),
          ],
        ),
      ),
    );
  }
}
