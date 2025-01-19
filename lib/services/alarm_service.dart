import 'package:medic/notification/notification.dart';
import '../storage/storage_manager.dart';

class AlarmService {
  static const String _fileName = 'alarms.json';

  Future<List<Map<String, dynamic>>> getAllAlarms() async {
    return await StorageManager.readJson(_fileName);
  }

  Future<void> addAlarm(Map<String, dynamic> alarm) async {
    final alarms = await getAllAlarms();
    alarms.add(alarm);
    await StorageManager.writeJson(_fileName, alarms);
  }

  Future<void> updateAlarm(Map<String, dynamic> updatedAlarm) async {
    final alarms = await getAllAlarms();
    final index =
        alarms.indexWhere((alarm) => alarm['id'] == updatedAlarm['id']);
    if (index != -1) {
      alarms[index] = updatedAlarm;
      await StorageManager.writeJson(_fileName, alarms);
    }
  }

  Future<void> deleteAlarm(String id) async {
    final alarms = await getAllAlarms();
    alarms.removeWhere((alarm) => alarm['id'] == id);
    await StorageManager.writeJson(_fileName, alarms);
  }

  Future<void> processAlarm(String alarmId) async {
    final alarms = await getAllAlarms();
    final index = alarms.indexWhere((alarm) => alarm['id'] == alarmId);
    if (index != -1) {
      final alarm = alarms[index];
      final remaining = alarm['remaining'];
      if (remaining > 1) {
        alarm['remaining'] = remaining - 1;
        alarm['nextTime'] = DateTime.parse(alarm['nextTime'])
            .add(Duration(minutes: alarm['interval']))
            .toIso8601String();
        alarms[index] = alarm;
        await StorageManager.writeJson(_fileName, alarms);
      } else {
        await deleteAlarm(alarmId);
      }
    }
  }

  Future<void> addTestAlarm(String medicationId) async {
    if (medicationId.isEmpty) return;

    final alarmId = DateTime.now().millisecondsSinceEpoch.toString();
    final nextTime = DateTime.now().add(Duration(seconds: 10));

    final alarm = {
      'id': alarmId,
      'medicationId': medicationId,
      'nextTime': nextTime.toIso8601String(),
      'interval': 0,
      'days': 0,
      'remaining': 1,
    };

    final alarms = await getAllAlarms();
    alarms.add(alarm);
    await StorageManager.writeJson(_fileName, alarms);

    await NotificationService.scheduleNotification(
      int.parse(alarmId),
      'Alarme de Teste',
      'É hora de tomar o medicamento do teste!',
      nextTime,
    );
  }
}
