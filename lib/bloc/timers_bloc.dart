import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timers_project/bloc/timers_events.dart';
import 'package:timers_project/bloc/timers_states.dart';
import '../repositories/timer_repository.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final TimerRepository repository;
  Timer? _ticker;

  TimerBloc(this.repository) : super(TimerInitial()) {
    on<LoadTimers>(_onLoad);
    on<AddTimer>(_onAdd);
    on<StartTimer>(_onStart);
    on<PauseTimer>(_onPause);
    on<ResetTimer>(_onReset);
    on<CompleteTimer>(_onComplete);
    on<StartCategoryTimers>(_onStartCategory);
    on<PauseCategoryTimers>(_onPauseCategory);
    on<ResetCategoryTimers>(_onResetCategory);
    on<ExportTimers>(_onExport);
    on<ToggleDarkMode>(_onThemeToggle);
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      final runningTimers = repository.getTimers().where((t) => t.isRunning);
      if (runningTimers.isEmpty) {
        _ticker?.cancel();
        return;
      }

      for (var timer in runningTimers) {
        final remaining = timer.remaining.inSeconds;
        if (remaining <= 0) {
          add(CompleteTimer(timer.id));
        }
      }

      add(LoadTimers());
    });
  }

  void _onLoad(LoadTimers event, Emitter<TimerState> emit) {
    final timers = repository.getTimers();
    final isDark = repository.getDarkMode();
    emit(TimerLoaded(timers: timers, isDarkMode: isDark));
  }

  void _onAdd(AddTimer event, Emitter<TimerState> emit) {
    repository.addTimer(event.timer);
    add(LoadTimers());
  }

  void _onStart(StartTimer event, Emitter<TimerState> emit) {
    repository.startTimer(event.timerId);
    _startTicker();
    add(LoadTimers());
  }

  void _onPause(PauseTimer event, Emitter<TimerState> emit) {
    repository.pauseTimer(event.timerId);
    add(LoadTimers());
  }

  void _onReset(ResetTimer event, Emitter<TimerState> emit) {
    repository.resetTimer(event.timerId);
    add(LoadTimers());
  }

  void _onComplete(CompleteTimer event, Emitter<TimerState> emit) {
    repository.completeTimer(event.timerId);
    add(LoadTimers());
  }

  void _onStartCategory(StartCategoryTimers event, Emitter<TimerState> emit) {
    repository
        .getTimers()
        .where((t) => t.category == event.category)
        .forEach((t) => repository.startTimer(t.id));
    _startTicker();
    add(LoadTimers());
  }

  void _onPauseCategory(PauseCategoryTimers event, Emitter<TimerState> emit) {
    repository
        .getTimers()
        .where((t) => t.category == event.category)
        .forEach((t) => repository.pauseTimer(t.id));
    add(LoadTimers());
  }

  void _onResetCategory(ResetCategoryTimers event, Emitter<TimerState> emit) {
    repository
        .getTimers()
        .where((t) => t.category == event.category)
        .forEach((t) => repository.resetTimer(t.id));
    add(LoadTimers());
  }

  void _onExport(ExportTimers event, Emitter<TimerState> emit) async {
    final data = repository.getCompletedTimers();
    final jsonData = jsonEncode(data.map((e) => e.toJson()).toList());

    try {
      final directory = await getApplicationDocumentsDirectory();
      print('Documents directory: ${directory.path}');
      final file = File('${directory.path}/timers_history.json');

      await file.writeAsString(jsonData);

      emit(TimerExported('Exported to: ${file.path}'));
    } catch (e) {
      print('Export failed: $e');
      emit(TimerExportFailed('Failed to export timers: $e'));
    }
  }

  void _onThemeToggle(ToggleDarkMode event, Emitter<TimerState> emit) {
    repository.setDarkMode(event.isDarkMode);
    add(LoadTimers());
  }

  @override
  Future<void> close() {
    _ticker?.cancel();
    return super.close();
  }
}
