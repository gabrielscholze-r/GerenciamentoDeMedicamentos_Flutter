import 'package:flutter/material.dart';
import '../../services/alarm_service.dart';

class AlarmsScreen extends StatefulWidget {
  @override
  _AlarmsScreenState createState() => _AlarmsScreenState();
}

class _AlarmsScreenState extends State<AlarmsScreen> {
  final AlarmService _alarmService = AlarmService();
  List<Map<String, dynamic>> _alarms = [];

  @override
  void initState() {
    super.initState();
    _loadAlarms();
  }

  Future<void> _loadAlarms() async {
    final alarms = await _alarmService.getAllAlarms();
    setState(() {
      _alarms = alarms;
    });
  }

  Future<void> _addAlarm() async {
    await _alarmService.addAlarm({
      'id': DateTime.now().toString(),
      'title': 'Ibuprofeno - A cada 6 horas',
    });
    _loadAlarms();
  }

  Future<void> _deleteAlarm(String id) async {
    await _alarmService.deleteAlarm(id);
    _loadAlarms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alarmes'),
      ),
      body: _alarms.isEmpty
          ? Center(child: Text('Nenhum alarme adicionado.'))
          : ListView.builder(
              itemCount: _alarms.length,
              itemBuilder: (context, index) {
                final alarm = _alarms[index];
                return ListTile(
                  leading: Icon(Icons.alarm),
                  title: Text(alarm['title'] ?? ''),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteAlarm(alarm['id']),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addAlarm,
        child: Icon(Icons.add),
      ),
    );
  }
}
