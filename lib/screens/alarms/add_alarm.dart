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
  DateTime _nextTime = DateTime.now();
  int _interval = 0;
  int _days = 0;

  Future<void> _pickDateTime() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      final selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (selectedTime != null) {
        setState(() {
          _nextTime = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
        });
      }
    }
  }
  void _saveAlarm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newAlarm = {
        'id': DateTime.now().toString(),
        'medicationId': _selectedMedicationId,
        'nextTime': _nextTime.toIso8601String(),
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
                ListTile(
                  title: Text("Próxima Hora: ${_nextTime.toLocal()}"),
                  trailing: Icon(Icons.calendar_today),
                  onTap: _pickDateTime,
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
                  onSaved: (value) {
                    _interval = int.parse(value!);
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
                  onSaved: (value) {
                    _days = int.parse(value!);
                  },
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