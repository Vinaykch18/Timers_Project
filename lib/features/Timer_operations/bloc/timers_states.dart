import '../models/timer_model.dart';

abstract class TimerState {}

class TimerInitial extends TimerState {}

class TimerLoaded extends TimerState {
  final List<TimerModel> timers;
  final bool isDarkMode;
  TimerLoaded({required this.timers, required this.isDarkMode});
}

class TimerExported extends TimerState {
  final String exportedJson;
  TimerExported(this.exportedJson);
}

class TimerExportFailed extends TimerState {
  final String errorMessage;
  TimerExportFailed(this.errorMessage);
}
