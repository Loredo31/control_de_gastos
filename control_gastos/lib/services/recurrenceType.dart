import 'dart:convert';
import 'package:control_gastos/model/recurrenceType_model.dart';
import 'package:http/http.dart' as http;


class RecurrenceTypeService {
  final String baseUrl = 'http://localhost:3000/api/type'; 

  Future<List<RecurrenceType>> getAll() async {
    final response = await http.get(Uri.parse('$baseUrl'));
    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body)['body'];
      return body.map((e) => RecurrenceType.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener tipos de recurrencia');
    }
  }

  Future<RecurrenceType> create(String type) async {
    final response = await http.post(
      Uri.parse('$baseUrl'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'type': type}),
    );

    if (response.statusCode == 201) {
      return RecurrenceType.fromJson(jsonDecode(response.body)['body']);
    } else {
      throw Exception('Error al crear tipo de recurrencia');
    }
  }

  Future<RecurrenceType> update(int id, String type) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'type': type}),
    );

    if (response.statusCode == 200) {
      return RecurrenceType.fromJson(jsonDecode(response.body)['body']);
    } else {
      throw Exception('Error al actualizar tipo de recurrencia');
    }
  }

  Future<void> delete(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar tipo de recurrencia');
    }
  }
}
