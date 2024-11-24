import 'package:flutter/material.dart';

class AlarmsScreen extends StatefulWidget {
  @override
  _AlarmsScreenState createState() => _AlarmsScreenState();
}

class _AlarmsScreenState extends State<AlarmsScreen> {
  final List<String> _alarms = [];

  void _addAlarm() {
    setState(() {
      _alarms.add("Ibuprofeno - A cada 6 horas");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Alarmes"),
      ),
      body: _alarms.isEmpty
          ? Center(
              child: Text(
                "Nenhum alarme adicionado.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: _alarms.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.alarm, color: Colors.blue),
                  title: Text(_alarms[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        _alarms.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addAlarm,
        child: Icon(Icons.add),
        tooltip: "Adicionar Alarme",
      ),
    );
  }
}
