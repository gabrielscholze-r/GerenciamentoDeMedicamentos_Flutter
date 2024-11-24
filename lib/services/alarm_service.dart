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

  Future<void> deleteAlarm(String id) async {
    final alarms = await getAllAlarms();
    alarms.removeWhere((alarm) => alarm['id'] == id);
    await StorageManager.writeJson(_fileName, alarms);
  }
}
