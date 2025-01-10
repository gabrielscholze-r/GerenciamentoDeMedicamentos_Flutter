import 'package:example_project/models/medication.dart';
import 'package:example_project/screens/alarms/add_alarm.dart';
import 'package:flutter/material.dart';
import '../../services/alarm_service.dart';
import '../../services/medication_service.dart'; // Serviço para obter os medicamentos

class AlarmsScreen extends StatefulWidget {
  @override
  _AlarmsScreenState createState() => _AlarmsScreenState();
}

class _AlarmsScreenState extends State<AlarmsScreen> {
  final AlarmService _alarmService = AlarmService();
  final MedicationService _medicationService = MedicationService();
  List<Map<String, dynamic>> _alarms = [];
  List<Map<String, dynamic>> _medications = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _loadAlarms();
    await _loadMedications();
  }

  Future<void> _loadAlarms() async {
    final alarms = await _alarmService.getAllAlarms();
    setState(() {
      _alarms = alarms;
    });
  }

  Future<void> _loadMedications() async {
    final medications = await _medicationService.getAllMedications();
    setState(() {
      _medications = medications;
    });
  }

  Future<void> _deleteAlarm(String id) async {
    await _alarmService.deleteAlarm(id);
    _loadAlarms();
  }

  String _formatAlarmTitle(Map<String, dynamic> alarm) {
    final medication = _medications.firstWhere(
      (med) => med['id'] == alarm['medicationId'],
      orElse: () => {'name': 'Medicamento não encontrado'},
    );

    final medicationName = medication['name'];
    final intervalHours = alarm['interval'] ?? 0;

    return '$medicationName - $intervalHours em $intervalHours horas';
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
                  title: Text(_formatAlarmTitle(alarm)),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteAlarm(alarm['id']),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddAlarmScreen(
                medications: _medications
                    .map((med) => Medication.fromJson(med))
                    .toList(),
                onAddAlarm: (newAlarm) {
                  setState(() {
                    _alarms.add(newAlarm);
                  });
                  _alarmService.addAlarm(newAlarm);
                },
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
