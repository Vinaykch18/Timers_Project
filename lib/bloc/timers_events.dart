import '../models/timer_model.dart';

abstract class TimerEvent {}

class LoadTimers extends TimerEvent {}

class AddTimer extends TimerEvent {
  final TimerModel timer;
  AddTimer(this.timer);
}

class StartTimer extends TimerEvent {
  final String timerId;
  StartTimer(this.timerId);
}

class PauseTimer extends TimerEvent {
  final String timerId;
  PauseTimer(this.timerId);
}

class ResetTimer extends TimerEvent {
  final String timerId;
  ResetTimer(this.timerId);
}

class CompleteTimer extends TimerEvent {
  final String timerId;
  CompleteTimer(this.timerId);
}

class StartCategoryTimers extends TimerEvent {
  final String category;
  StartCategoryTimers(this.category);
}

class PauseCategoryTimers extends TimerEvent {
  final String category;
  PauseCategoryTimers(this.category);
}

class ResetCategoryTimers extends TimerEvent {
  final String category;
  ResetCategoryTimers(this.category);
}

class ExportTimers extends TimerEvent {}

class ToggleDarkMode extends TimerEvent {
  final bool isDarkMode;
  ToggleDarkMode(this.isDarkMode);
}
