import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AddMedicationScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddMedication;

  const AddMedicationScreen({required this.onAddMedication, Key? key})
      : super(key: key);

  @override
  _AddMedicationScreenState createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final Uuid _uuid = Uuid();

  void _saveMedication() {
    if (_formKey.currentState!.validate()) {
      final newMedication = {
        'id': _uuid.v4(),
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim(),
      };
      widget.onAddMedication(newMedication);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Medicamento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nome do Medicamento',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o nome do medicamento.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe uma descrição.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveMedication,
                child: Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
