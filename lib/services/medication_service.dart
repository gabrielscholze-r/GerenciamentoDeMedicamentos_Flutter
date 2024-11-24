import '../storage/storage_manager.dart';

class MedicationService {
  static const String _fileName = 'medications.json';

  Future<List<Map<String, dynamic>>> getAllMedications() async {
    return await StorageManager.readJson(_fileName);
  }

  Future<void> addMedication(Map<String, dynamic> medication) async {
    final medications = await getAllMedications();
    medications.add(medication);
    await StorageManager.writeJson(_fileName, medications);
  }

  Future<void> deleteMedication(String id) async {
    final medications = await getAllMedications();
    medications.removeWhere((medication) => medication['id'] == id);
    await StorageManager.writeJson(_fileName, medications);
  }
}
