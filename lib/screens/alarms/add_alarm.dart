import 'package:flutter/material.dart';
import 'package:medic/models/medication.dart';
import 'package:medic/services/alarm_service.dart';
import 'package:medic/notification/notification.dart';

class AddAlarmScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddAlarm;
  final List<Medication> medications;

  AddAlarmScreen({required this.onAddAlarm, required this.medications});

  @override
  _AddAlarmScreenState createState() => _AddAlarmScreenState();
}

class _AddAlarmScreenState extends State<AddAlarmScreen> {
  final _formKey = GlobalKey<FormState>();
  final AlarmService _alarmService = AlarmService();
  String? _selectedMedicationId;
  DateTime? _nextTime;
  int _interval = 0;
  int _days = 0;

  void _calculateNextTime() {
    if (_interval > 0 || _days > 0) {
      final now = DateTime.now();
      final calculatedNextTime =
          now.add(Duration(hours: _interval, days: _days));
      setState(() {
        _nextTime = calculatedNextTime;
      });
    } else {
      setState(() {
        _nextTime = null;
      });
    }
  }

  int _calculateRemaining(int intervalHours, int days) {
    if (intervalHours <= 0 || days <= 0) return 0;
    final totalHours = days * 24;
    return (totalHours / intervalHours).floor();
  }

  String _formatNextTime(DateTime? dateTime) {
    if (dateTime == null) return "Não definida";
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return "$day/$month $hour:$minute";
  }

  Future<void> _saveAlarm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final remaining = _calculateRemaining(_interval, _days);

      if (remaining == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('O número de alarmes calculado é inválido.')),
        );
        return;
      }

      final newAlarm = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'medicationId': _selectedMedicationId,
        'nextTime': _nextTime!.toIso8601String(),
        'interval': _interval,
        'days': _days,
        'remaining': remaining,
      };

      widget.onAddAlarm(newAlarm);
      await _alarmService.addAlarm(newAlarm);

      NotificationService.showInstantNotification(
        'Alarme Criado',
        'Você criou um novo alarme para tomar o medicamento ${widget.medications.firstWhere((med) => med.id == _selectedMedicationId).name}.',
      );

      NotificationService.scheduleNotification(
        int.parse(newAlarm['id'].toString()),
        'Alarme para ${widget.medications.firstWhere((med) => med.id == _selectedMedicationId).name}',
        'É hora de tomar o medicamento!',
        _nextTime!,
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adicionar Alarme"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Selecione o Medicamento",
                    border: OutlineInputBorder(),
                  ),
                  items: widget.medications.map((medication) {
                    return DropdownMenuItem<String>(
                      value: medication.id,
                      child: Text(medication.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedMedicationId = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return "Por favor, selecione um medicamento.";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Intervalo (em horas)",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        int.tryParse(value) == null ||
                        int.parse(value) <= 0) {
                      return "Por favor, insira um intervalo válido.";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _interval = int.tryParse(value) ?? 0;
                    });
                    _calculateNextTime();
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Dias",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        int.tryParse(value) == null ||
                        int.parse(value) <= 0) {
                      return "Por favor, insira um número válido de dias.";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _days = int.tryParse(value) ?? 0;
                    });
                    _calculateNextTime();
                  },
                ),
                SizedBox(height: 16),
                Text("Próximo horário: ${_formatNextTime(_nextTime)}"),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _saveAlarm,
                  child: Text("Salvar Alarme"),
                ),
                SizedBox(height: 16),
                //test button
                // ElevatedButton(
                //   onPressed: () async {
                //     if (_selectedMedicationId == null) {
                //       ScaffoldMessenger.of(context).showSnackBar(
                //         SnackBar(content: Text('Selecione um medicamento antes de adicionar o alarme de teste.')),
                //       );
                //       return;
                //     }

                //     await _alarmService.addTestAlarm(_selectedMedicationId!);
                //     ScaffoldMessenger.of(context).showSnackBar(
                //       SnackBar(content: Text('Alarme de teste adicionado para o medicamento selecionado.')),
                //     );
                //   },
                //   child: Text("Adicionar Alarme de Teste"),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
