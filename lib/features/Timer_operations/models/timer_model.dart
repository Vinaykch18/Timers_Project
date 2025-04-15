class TimerModel {
  final String id;
  final String name;
  final int duration;
  final String category;
  final DateTime? startTime;
  final bool isRunning;
  final DateTime? completionTime;
  final int elapsedSeconds;

  TimerModel({
    required this.id,
    required this.name,
    required this.duration,
    required this.category,
    this.startTime,
    this.isRunning = false,
    this.completionTime,
    this.elapsedSeconds = 0,
  });

  Duration get remaining {
    int totalElapsed = elapsedSeconds;
    if (startTime != null && isRunning) {
      totalElapsed += DateTime.now().difference(startTime!).inSeconds;
    }
    final remainingSeconds = duration - totalElapsed;
    return Duration(seconds: remainingSeconds > 0 ? remainingSeconds : 0);
  }

  bool get isCompleted {
    return remaining.inSeconds == 0 && completionTime != null && !isRunning;
  }

  TimerModel copyWith({
    String? id,
    String? name,
    int? duration,
    String? category,
    DateTime? startTime,
    bool? isRunning,
    DateTime? completionTime,
    int? elapsedSeconds,
  }) {
    return TimerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      duration: duration ?? this.duration,
      category: category ?? this.category,
      startTime: startTime ?? this.startTime,
      isRunning: isRunning ?? this.isRunning,
      completionTime: completionTime ?? this.completionTime,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
    );
  }

  factory TimerModel.fromJson(Map<String, dynamic> json) {
    return TimerModel(
      id: json['id'],
      name: json['name'],
      duration: json['duration'],
      category: json['category'],
      startTime:
          json['startTime'] != null ? DateTime.parse(json['startTime']) : null,
      isRunning: json['isRunning'],
      completionTime:
          json['completionTime'] != null
              ? DateTime.parse(json['completionTime'])
              : null,
      elapsedSeconds: json['elapsedSeconds'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'duration': duration,
      'category': category,
      'startTime': startTime?.toIso8601String(),
      'isRunning': isRunning,
      'completionTime': completionTime?.toIso8601String(),
      'elapsedSeconds': elapsedSeconds,
    };
  }
}
