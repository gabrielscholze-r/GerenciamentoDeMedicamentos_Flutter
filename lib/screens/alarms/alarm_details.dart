import 'package:flutter/material.dart';

class AlarmDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> alarm;
  final List<Map<String, dynamic>> medications;

  AlarmDetailsScreen({required this.alarm, required this.medications});

  String _formatTime(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return "$day/$month $hour:$minute";
  }

  @override
  Widget build(BuildContext context) {
    final medication = medications.firstWhere(
      (med) => med['id'] == alarm['medicationId'],
      orElse: () => {'name': 'Medicamento não encontrado'},
    );

    final medicationName = medication['name'];
    final interval = alarm['interval'];
    final days = alarm['days'];
    final nextTime = DateTime.parse(alarm['nextTime']);
    final endDate = nextTime.add(Duration(hours: interval * days));

    return Scaffold(
      appBar: AppBar(
        title: Text("Detalhes do Alarme"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Nome do Medicamento: $medicationName",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              "Intervalo: A cada $interval horas",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              "Próxima Hora: ${_formatTime(nextTime)}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              "Previsão de Término: ${_formatTime(endDate)}",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
