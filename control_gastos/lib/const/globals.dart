import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

String? ipMac = '127.0.0.1';
String baseUrl = "http://192.168.0.120:3000/api";

Future<bool> obtenerSistema() async {
  if (kIsWeb) {
    ipMac = '127.0.0.1'; 
    return true;
  }

  if (Platform.isMacOS) {
    ipMac = '127.0.0.1';
    return true;
  }
  bool exists = true;
  final Directory directory = await getApplicationDocumentsDirectory();
  final File file = File('${directory.path}/my_ip.txt');

  exists = await file.exists();
  if (!exists) {
    exists = false;
    return exists;
  }

  try {
    ipMac = await file.readAsString();
    baseUrl = "http://$ipMac:3000me/api";
    exists = true;
    return exists;
  } catch (e) {
    print("No se puede leer el archivo");
    exists = false;
    return exists;
  }
}
