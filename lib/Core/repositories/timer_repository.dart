import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:timers_project/features/Timer_operations/models/timer_model.dart';

class TimerRepository {
  final SharedPreferences prefs;
  final List<TimerModel> _timers = [];

  TimerRepository(this.prefs) {
    _loadTimers();
  }

  void _loadTimers() {
    final timersJson = prefs.getStringList('timers') ?? [];
    print("Loaded timers: $timersJson");
    _timers.clear();
    _timers.addAll(
      timersJson.map((json) => TimerModel.fromJson(jsonDecode(json))),
    );
  }

  void _saveTimers() {
    final timersJson =
        _timers.map((timer) => jsonEncode(timer.toJson())).toList();
    prefs.setStringList('timers', timersJson);
  }

  List<TimerModel> getTimers() => List.unmodifiable(_timers);

  void addTimer(TimerModel timer) {
    _timers.add(timer);
    _saveTimers();
  }

  void startTimer(String timerId) {
    final index = _timers.indexWhere((timer) => timer.id == timerId);
    if (index != -1) {
      final currentTimer = _timers[index];
      _timers[index] = currentTimer.copyWith(
        startTime: DateTime.now(),
        isRunning: true,
      );
      _saveTimers();
    }
  }

  void pauseTimer(String timerId) {
    final index = _timers.indexWhere((timer) => timer.id == timerId);
    if (index != -1) {
      final currentTimer = _timers[index];
      final elapsed =
          currentTimer.startTime != null
              ? DateTime.now().difference(currentTimer.startTime!).inSeconds
              : 0;

      _timers[index] = currentTimer.copyWith(
        isRunning: false,
        startTime: null,
        elapsedSeconds: currentTimer.elapsedSeconds + elapsed,
      );
      _saveTimers();
    }
  }

  void resetTimer(String timerId) {
    final index = _timers.indexWhere((timer) => timer.id == timerId);
    if (index != -1) {
      _timers[index] = _timers[index].copyWith(
        startTime: null,
        isRunning: false,
        completionTime: null,
        elapsedSeconds: 0,
      );
      _saveTimers();
    }
  }

  void completeTimer(String timerId) {
    final index = _timers.indexWhere((t) => t.id == timerId);
    if (index != -1) {
      final currentTimer = _timers[index];
      final elapsed =
          currentTimer.startTime != null
              ? DateTime.now().difference(currentTimer.startTime!).inSeconds
              : 0;
      _timers[index] = currentTimer.copyWith(
        isRunning: false,
        completionTime: DateTime.now(),
        startTime: null,
        elapsedSeconds: currentTimer.elapsedSeconds + elapsed,
      );
      _saveTimers();
    }
  }

  List<TimerModel> getCompletedTimers() {
    return _timers.where((timer) => timer.completionTime != null).toList();
  }

  void startTimersByCategory(String category) {
    for (int i = 0; i < _timers.length; i++) {
      if (_timers[i].category == category && !_timers[i].isRunning) {
        _timers[i] = _timers[i].copyWith(
          isRunning: true,
          startTime: DateTime.now(),
        );
      }
    }
    _saveTimers();
  }

  void pauseTimersByCategory(String category) {
    for (int i = 0; i < _timers.length; i++) {
      if (_timers[i].category == category && _timers[i].isRunning) {
        final elapsed =
            _timers[i].startTime != null
                ? DateTime.now().difference(_timers[i].startTime!).inSeconds
                : 0;

        _timers[i] = _timers[i].copyWith(
          isRunning: false,
          startTime: null,
          elapsedSeconds: _timers[i].elapsedSeconds + elapsed,
        );
      }
    }
    _saveTimers();
  }

  void resetTimersByCategory(String category) {
    for (int i = 0; i < _timers.length; i++) {
      if (_timers[i].category == category) {
        _timers[i] = _timers[i].copyWith(
          isRunning: false,
          startTime: null,
          elapsedSeconds: 0,
          completionTime: null,
        );
      }
    }
    _saveTimers();
  }

  void setDarkMode(bool isDarkMode) {
    prefs.setBool('isDarkMode', isDarkMode);
  }

  bool getDarkMode() {
    return prefs.getBool('isDarkMode') ?? false;
  }
}
