import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class StorageManager {
  static Future<String> _getFilePath(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$fileName';
  }

  static Future<List<Map<String, dynamic>>> readJson(String fileName) async {
    try {
      final path = await _getFilePath(fileName);
      final file = File(path);

      if (!await file.exists()) {
        // Cria o arquivo se não existir
        await file.writeAsString(jsonEncode([]));
      }

      final contents = await file.readAsString();
      return List<Map<String, dynamic>>.from(jsonDecode(contents));
    } catch (e) {
      throw Exception("Erro ao ler $fileName: $e");
    }
  }

  static Future<void> writeJson(String fileName, List<Map<String, dynamic>> data) async {
    try {
      final path = await _getFilePath(fileName);
      final file = File(path);

      await file.writeAsString(jsonEncode(data));
    } catch (e) {
      throw Exception("Erro ao salvar em $fileName: $e");
    }
  }
}
