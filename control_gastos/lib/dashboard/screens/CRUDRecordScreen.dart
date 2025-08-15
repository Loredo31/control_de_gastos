import 'package:flutter/material.dart';

class CRUDRecordScreen extends StatefulWidget {
  @override
  _CRUDRecordScreen createState() => _CRUDRecordScreen();
}

class _CRUDRecordScreen extends State<CRUDRecordScreen> {
  // Lista de registros (pueden ser mapas genéricos por ahora)
  List<Map<String, dynamic>> records = [];

  // Controladores para el formulario
  final TextEditingController field1Controller = TextEditingController();
  final TextEditingController field2Controller = TextEditingController();
  final TextEditingController field3Controller = TextEditingController();
  final TextEditingController field4Controller = TextEditingController();
  final TextEditingController field5Controller = TextEditingController();

  // Id del registro que se está editando (null si es nuevo)
  int? editingId;

  @override
  void dispose() {
    field1Controller.dispose();
    field2Controller.dispose();
    field3Controller.dispose();
    field4Controller.dispose();
    field5Controller.dispose();
    super.dispose();
  }

  // Funciones básicas de CRUD (vacías por ahora)
  void createRecord() {
    // Aquí se agregará la lógica para crear
  }

  void updateRecord() {
    // Aquí se agregará la lógica para actualizar
  }

  void deleteRecord(int id) {
    // Aquí se agregará la lógica para eliminar
  }

  void resetForm() {
    field1Controller.clear();
    field2Controller.clear();
    field3Controller.clear();
    field4Controller.clear();
    field5Controller.clear();
    editingId = null;
  }

  void fillFormForEditing(Map<String, dynamic> record) {
    field1Controller.text = record['field1'] ?? '';
    field2Controller.text = record['field2'] ?? '';
    field3Controller.text = record['field3'] ?? '';
    field4Controller.text = record['field4'] ?? '';
    field5Controller.text = record['field5'] ?? '';
    editingId = record['id'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("CRUD Básico")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Formulario
            TextField(controller: field1Controller, decoration: InputDecoration(labelText: "Campo 1")),
            TextField(controller: field2Controller, decoration: InputDecoration(labelText: "Campo 2")),
            TextField(controller: field3Controller, decoration: InputDecoration(labelText: "Campo 3")),
            TextField(controller: field4Controller, decoration: InputDecoration(labelText: "Campo 4")),
            TextField(controller: field5Controller, decoration: InputDecoration(labelText: "Campo 5")),
            SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (editingId == null) {
                      createRecord();
                    } else {
                      updateRecord();
                    }
                    resetForm();
                  },
                  child: Text(editingId == null ? "Crear" : "Actualizar"),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: resetForm,
                  child: Text("Cancelar"),
                ),
              ],
            ),
            Divider(height: 20),
            // Lista de registros
            Expanded(
              child: ListView.builder(
                itemCount: records.length,
                itemBuilder: (context, index) {
                  final record = records[index];
                  return ListTile(
                    title: Text(record['field1'] ?? ''),
                    subtitle: Text(record['field2'] ?? ''),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => fillFormForEditing(record),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => deleteRecord(record['id']),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
