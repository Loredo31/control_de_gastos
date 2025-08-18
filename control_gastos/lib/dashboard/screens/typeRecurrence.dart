import 'package:control_gastos/model/recurrenceType_model.dart';
import 'package:control_gastos/services/recurrenceType.dart';
import 'package:flutter/material.dart';

class RecurrenceTypeScreen extends StatefulWidget {
  const RecurrenceTypeScreen({super.key});

  @override
  State<RecurrenceTypeScreen> createState() => _RecurrenceTypeScreenState();
}

class _RecurrenceTypeScreenState extends State<RecurrenceTypeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _typeController = TextEditingController();
  final RecurrenceTypeService _service = RecurrenceTypeService();

  List<RecurrenceType> _recurrenceTypes = [];
  int? _editingId;

  @override
  void initState() {
    super.initState();
    _fetchRecurrenceTypes();
  }

  void _fetchRecurrenceTypes() async {
    try {
      final types = await _service.getAll();
      setState(() {
        _recurrenceTypes = types;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al obtener tipos: $e')),
      );
    }
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      try {
        if (_editingId == null) {
          await _service.create(_typeController.text);
        } else {
          await _service.update(_editingId!, _typeController.text);
        }
        _typeController.clear();
        _editingId = null;
        _fetchRecurrenceTypes();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar: $e')),
        );
      }
    }
  }

  void _edit(RecurrenceType type) {
    _typeController.text = type.type;
    _editingId = type.id;
  }

  void _delete(int id) async {
    try {
      await _service.delete(id);
      _fetchRecurrenceTypes();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CRUD Tipos de Recurrencia')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _typeController,
                      decoration: const InputDecoration(
                        labelText: 'Tipo de recurrencia',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingresa un tipo';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _save,
                    child: Text(_editingId == null ? 'Agregar' : 'Actualizar'),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Tipos existentes:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _recurrenceTypes.isEmpty
                  ? const Center(child: Text('No hay tipos registrados'))
                  : ListView.builder(
                      itemCount: _recurrenceTypes.length,
                      itemBuilder: (context, index) {
                        final type = _recurrenceTypes[index];
                        return Card(
                          child: ListTile(
                            title: Text(type.type),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _edit(type),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _delete(type.id),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}
