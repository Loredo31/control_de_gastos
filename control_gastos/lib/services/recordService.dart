import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:control_gastos/const/globals.dart'; // Aquí tienes baseUrl

class Recordservice {
  // // Obtener todos los registros
  // static Future<List<Map<String, dynamic>>> getAllRecords() async {
  //   try {
  //     final res = await http.get(Uri.parse('$baseUrl/records'));

  //     if (res.statusCode != 200) return [];

  //     final responseData = jsonDecode(res.body);
  //     return List<Map<String, dynamic>>.from(responseData["body"]);
  //   } catch (e) {
  //     debugPrint("Error getAllRecords: ${e.toString()}");
  //     throw Exception('Error al obtener registros: ${e.toString()}');
  //   }
  // }

  // Obtener registros por mes y año
  static Future<List<Map<String, dynamic>>> getRecordsByDate(int month, int year) async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/records/$month/$year'));

      if (res.statusCode != 200) return [];

      final responseData = jsonDecode(res.body);
      return List<Map<String, dynamic>>.from(responseData["body"]);
    } catch (e) {
      debugPrint("Error getRecordsByDate: ${e.toString()}");
      throw Exception('Error al obtener registros por fecha: ${e.toString()}');
    }
  }

  // Crear un registro
  static Future<Map<String, dynamic>?> createRecord(Map<String, dynamic> record) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/records'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(record),
      );

      if (res.statusCode != 200) return null;

      final responseData = jsonDecode(res.body);
      return Map<String, dynamic>.from(responseData["body"]);
    } catch (e) {
      debugPrint("Error createRecord: ${e.toString()}");
      throw Exception('Error al crear registro: ${e.toString()}');
    }
  }

  // Actualizar un registro
  static Future<Map<String, dynamic>?> updateRecord(Map<String, dynamic> record) async {
    try {
      final res = await http.put(
        Uri.parse('$baseUrl/records'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(record),
      );

      if (res.statusCode != 200) return null;

      final responseData = jsonDecode(res.body);
      return Map<String, dynamic>.from(responseData["body"]);
    } catch (e) {
      debugPrint("Error updateRecord: ${e.toString()}");
      throw Exception('Error al actualizar registro: ${e.toString()}');
    }
  }

  // Eliminar un registro
  static Future<bool> deleteRecord(int id) async {
    try {
      final res = await http.delete(Uri.parse('$baseUrl/records/$id'));

      return res.statusCode == 200;
    } catch (e) {
      debugPrint("Error deleteRecord: ${e.toString()}");
      throw Exception('Error al eliminar registro: ${e.toString()}');
    }
  }
}
