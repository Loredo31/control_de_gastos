import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:control_gastos/const/globals.dart';

class CategoryService {
  static Future<List<Map<String, dynamic>>> getAllCategories() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/catego'));

      if (res.statusCode != 200) return [];

      final responseData = jsonDecode(res.body);
      return List<Map<String, dynamic>>.from(responseData["body"]);
    } catch (e) {
      debugPrint("Error getAllCategories: ${e.toString()}");
      throw Exception('Error al obtener categorías: ${e.toString()}');
    }
  }
}
