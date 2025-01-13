import 'package:flutter/material.dart';

class MedicationDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> medication;

  const MedicationDetailsScreen({Key? key, required this.medication}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Medicamento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              medication['name'] ?? 'Sem nome',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              medication['description'] ?? 'Sem descrição',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
