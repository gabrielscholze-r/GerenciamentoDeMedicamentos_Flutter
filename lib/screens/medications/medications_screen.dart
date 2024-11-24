import 'package:flutter/material.dart';
import '../../services/medication_service.dart';

class MedicationsScreen extends StatefulWidget {
  @override
  _MedicationsScreenState createState() => _MedicationsScreenState();
}

class _MedicationsScreenState extends State<MedicationsScreen> {
  final MedicationService _medicationService = MedicationService();
  List<Map<String, dynamic>> _medications = [];

  @override
  void initState() {
    super.initState();
    _loadMedications();
  }

  Future<void> _loadMedications() async {
    final medications = await _medicationService.getAllMedications();
    setState(() {
      _medications = medications;
    });
  }

  Future<void> _addMedication() async {
    await _medicationService.addMedication({
      'id': DateTime.now().toString(),
      'name': 'Ibuprofeno',
      'description': 'Anti-inflamatório usado para tratar dores e febres.',
    });
    _loadMedications();
  }

  Future<void> _deleteMedication(String id) async {
    await _medicationService.deleteMedication(id);
    _loadMedications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medicamentos'),
      ),
      body: _medications.isEmpty
          ? Center(child: Text('Nenhum medicamento adicionado.'))
          : ListView.builder(
              itemCount: _medications.length,
              itemBuilder: (context, index) {
                final medication = _medications[index];
                return ListTile(
                  leading: Icon(Icons.medical_services),
                  title: Text(medication['name'] ?? ''),
                  subtitle: Text(medication['description'] ?? ''),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteMedication(medication['id']),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMedication,
        child: Icon(Icons.add),
      ),
    );
  }
}
