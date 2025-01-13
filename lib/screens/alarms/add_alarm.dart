import 'package:example_project/models/medication.dart';
import 'package:flutter/material.dart';

class AddAlarmScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddAlarm;
  final List<Medication> medications;

  AddAlarmScreen({required this.onAddAlarm, required this.medications});

  @override
  _AddAlarmScreenState createState() => _AddAlarmScreenState();
}

class _AddAlarmScreenState extends State<AddAlarmScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedMedicationId;
  DateTime? _nextTime;
  int _interval = 0;
  int _days = 0;

  void _calculateNextTime() {
    if (_interval > 0 || _days > 0) {
      final now = DateTime.now();
      final calculatedNextTime = now.add(Duration(hours: _interval, days: _days));
      setState(() {
        _nextTime = calculatedNextTime;
      });
    } else {
      setState(() {
        _nextTime = null;
      });
    }
  }

  String _formatNextTime(DateTime? dateTime) {
    if (dateTime == null) return "Não definida";
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return "$day/$month $hour:$minute";
  }

  void _saveAlarm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newAlarm = {
        'id': DateTime.now().toString(),
        'medicationId': _selectedMedicationId,
        'nextTime': _nextTime?.toIso8601String(),
        'interval': _interval,
        'days': _days,
      };
      widget.onAddAlarm(newAlarm);
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
                    if (value == null || value.isEmpty || int.tryParse(value) == null) {
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
                    if (value == null || value.isEmpty || int.tryParse(value) == null) {
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
                ListTile(
                  title: Text(
                    "Próxima Hora: ${_formatNextTime(_nextTime)}",
                  ),
                  leading: Icon(Icons.access_time),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _saveAlarm,
                  child: Text("Salvar Alarme"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
