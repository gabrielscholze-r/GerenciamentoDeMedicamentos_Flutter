class Alarm {
  final String id;
  final String medicationId;
  final DateTime nextTime;
  final Duration interval;
  final int remaining;
  final int days;

  Alarm({
    required this.id,
    required this.medicationId,
    required this.nextTime,
    required this.remaining,
    required this.interval,
    required this.days,
  });

  factory Alarm.fromJson(Map<String, dynamic> json) {
    return Alarm(
      id: json['id'],
      medicationId: json['medicationId'],
      nextTime: DateTime.parse(json['nextTime']),
      remaining: int.parse(json['remaining']),
      interval: Duration(hours: json['interval']),
      days: json['days'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'medicationId': medicationId,
        'nextTime': nextTime.toIso8601String(),
        'remaining': remaining,
        'interval': interval.inHours,
        'days': days,
      };
}
