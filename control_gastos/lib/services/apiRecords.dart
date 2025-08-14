import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:control_gastos/const/globals.dart';

class Apirecords {
  static Future<List<Map<String, dynamic>>> getRecords(int month, int year) async {
    try {
      final res = await http.get(
        Uri.parse('$baseUrl/records/date/$month/$year'),
      );

      final responseData = jsonDecode(res.body);

      if (res.statusCode != 200) {
        throw (responseData["message"]);
      } else {
        return List<Map<String, dynamic>>.from(responseData["body"]);
      }
    } catch (e) {
      debugPrint("Error: ${e.toString()}");
      throw Exception('Error al obtener registros: ${e.toString()}');
    }
  }
}

