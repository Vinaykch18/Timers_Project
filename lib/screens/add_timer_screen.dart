import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timers_project/bloc/timers_bloc.dart';
import 'package:timers_project/bloc/timers_events.dart';
import 'package:timers_project/models/timer_model.dart';

class AddTimerScreen extends StatefulWidget {
  const AddTimerScreen({super.key});

  @override
  State<AddTimerScreen> createState() => _AddTimerScreenState();
}

class _AddTimerScreenState extends State<AddTimerScreen> {
  final _nameController = TextEditingController();
  final _durationController = TextEditingController();
  String _category = "General";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Timer")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Timer Name'),
            ),
            TextField(
              controller: _durationController,
              decoration: const InputDecoration(
                labelText: 'Duration (seconds)',
              ),
              keyboardType: TextInputType.number,
            ),
            DropdownButton<String>(
              value: _category,
              items:
                  ["General", "Workout", "Study", "Break"]
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
              onChanged: (value) => setState(() => _category = value!),
            ),
            ElevatedButton(
              onPressed: () {
                final timer = TimerModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: _nameController.text,
                  duration: int.parse(_durationController.text),
                  category: _category,
                );
                context.read<TimerBloc>().add(AddTimer(timer));
                Navigator.pop(context);
              },
              child: const Text("Add Timer"),
            ),
          ],
        ),
      ),
    );
  }
}
