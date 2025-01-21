import 'package:flutter/material.dart';
import '../../services/medication_service.dart';
import 'add_medication.dart';
import 'medication_details.dart';

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

  Future<void> _deleteMedication(String id) async {
    await _medicationService.deleteMedication(id);
    _loadMedications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Medicamentos',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
        ),
        backgroundColor: Color.fromARGB(151, 159, 159, 237),
      ),
      body: _medications.isEmpty
          ? Center(child: Text('Nenhum medicamento adicionado.'))
          : ListView.builder(
              itemCount: _medications.length,
              itemBuilder: (context, index) {
                final medication = _medications[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(151, 159, 159, 237),
                          offset: Offset(0, 4),
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.medical_services, color: Colors.black,),
                      title: Text(medication['name'] ?? '',
                      style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            fontSize: 22
          )),
                      subtitle: Text(medication['description'] ?? '',
                      style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          )),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.grey),
                        onPressed: () => _deleteMedication(medication['id']),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MedicationDetailsScreen(
                              medication: medication,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddMedicationScreen(
                onAddMedication: (newMedication) async {
                  await _medicationService.addMedication(newMedication);
                  _loadMedications();
                },
              ),
            ),
          );
        },
        backgroundColor: Color.fromARGB(151, 159, 159, 237),
        child: Icon(Icons.add),
      ),
    );
  }
}
