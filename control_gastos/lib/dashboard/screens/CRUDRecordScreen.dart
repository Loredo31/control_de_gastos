import 'package:control_gastos/services/recordService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:control_gastos/model/recurrenceType_model.dart';
import 'package:control_gastos/services/recurrenceType.dart';
import 'package:intl/intl.dart';

class CRUDRecordScreen extends StatefulWidget {
  @override
  _CRUDRecordScreenState createState() => _CRUDRecordScreenState();
}

class _CRUDRecordScreenState extends State<CRUDRecordScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController amountController = TextEditingController();
  TextEditingController conceptController = TextEditingController();
  bool isEntry = true;
  int? categoryId;
  bool isRecurrent = false;
  bool recurrenceActive = true;
  RecurrenceType? selectedRecurrenceType;
  List<RecurrenceType> recurrenceTypes = [];
  List<int> selectedDaysOfWeek = [];
  int? dayOfMonth;
  bool workingDays = false;

  final RecurrenceTypeService recurrenceService = RecurrenceTypeService();

  @override
  void initState() {
    super.initState();
    _loadRecurrenceTypes();
  }

  Future<void> _loadRecurrenceTypes() async {
    try {
      final types = await recurrenceService.getAll();
      setState(() {
        recurrenceTypes = types;
      });
    } catch (e) {
      debugPrint('Error cargando tipos de recurrencia: $e');
    }
  }

  void _resetRecurrenceFields() {
    selectedRecurrenceType = null;
    selectedDaysOfWeek = [];
    dayOfMonth = null;
    workingDays = false;
    recurrenceActive = true;
  }

  void _handleRecurrenceTypeChange(RecurrenceType? type) {
    setState(() {
      selectedRecurrenceType = type;

      if (type == null) return;

      switch (type.id) {
        case 1:
          dayOfMonth = null;
          selectedDaysOfWeek = [];
          workingDays = true;
          break;
        case 2:
          dayOfMonth = null;
          selectedDaysOfWeek = [];
          workingDays = false;
          break;
        case 3:
          dayOfMonth = DateTime.now().day;
          selectedDaysOfWeek = [];
          workingDays = false;
          break;
        default:
          dayOfMonth = null;
          selectedDaysOfWeek = [];
          workingDays = false;
      }
    });
  }

  void _toggleDayOfWeek(int day) {
    setState(() {
      if (selectedDaysOfWeek.contains(day)) {
        selectedDaysOfWeek.remove(day);
      } else {
        if (selectedDaysOfWeek.length < 6) {
          selectedDaysOfWeek.add(day);
        } else {
          _handleRecurrenceTypeChange(
            recurrenceTypes.firstWhere((t) => t.id == 1),
          );
        }
      }
    });
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (isRecurrent) {
      if (selectedRecurrenceType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Debes seleccionar un tipo de recurrencia")),
        );
        return;
      }
      if (selectedRecurrenceType!.id == 2 && selectedDaysOfWeek.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Debes seleccionar al menos un día de la semana"),
          ),
        );
        return;
      }
      if (selectedRecurrenceType!.id == 3 && dayOfMonth == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Debes seleccionar un día del mes")),
        );
        return;
      }
    }

    final recordData = {
      "isentry": isEntry,
      "amount": double.tryParse(amountController.text),
      "category_id": categoryId,
      "concept": conceptController.text,
      "is_concurrent": isRecurrent,
      "id_type": selectedRecurrenceType?.id,
      "days_month": dayOfMonth,
      "days_week": selectedDaysOfWeek.isNotEmpty ? selectedDaysOfWeek : null,
      "working_days": workingDays,
      "active": recurrenceActive,
    };

    try {
      final response = await Recordservice.createRecord(recordData);

      if (response != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Registro guardado con éxito")));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No se pudo guardar el registro")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("CRUD Record")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<bool>(
                value: isEntry,
                decoration: InputDecoration(labelText: "Tipo de registro"),
                items: [
                  DropdownMenuItem(
                    child: Text("Entrada de dinero"),
                    value: true,
                  ),
                  DropdownMenuItem(child: Text("Gasto"), value: false),
                ],
                onChanged: (val) => setState(() => isEntry = val!),
              ),

              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                decoration: InputDecoration(labelText: "Monto"),
                validator: (val) {
                  if (val == null || val.isEmpty) return "Ingresa un monto";
                  if (double.tryParse(val) == null)
                    return "Solo se permiten números";
                  return null;
                },
              ),

              DropdownButtonFormField<int>(
                value: categoryId,
                decoration: InputDecoration(labelText: "Categoría"),
                items: [],
                onChanged: (val) => setState(() => categoryId = val),
                validator: (val) =>
                    val == null ? "Selecciona una categoría" : null,
              ),

              TextFormField(
                controller: conceptController,
                decoration: InputDecoration(labelText: "Concepto"),
                validator: (val) =>
                    val == null || val.isEmpty ? "Ingresa un concepto" : null,
              ),

              CheckboxListTile(
                title: Text("Es recurrente?"),
                value: isRecurrent,
                onChanged: (val) {
                  setState(() {
                    isRecurrent = val!;
                    if (!isRecurrent) _resetRecurrenceFields();
                  });
                },
              ),

              if (isRecurrent) ...[
                CheckboxListTile(
                  title: Text("Activo"),
                  value: recurrenceActive,
                  onChanged: (val) => setState(() => recurrenceActive = val!),
                ),

                DropdownButtonFormField<RecurrenceType>(
                  value: selectedRecurrenceType,
                  decoration: InputDecoration(labelText: "Tipo de recurrencia"),
                  items: recurrenceTypes
                      .map(
                        (t) => DropdownMenuItem(value: t, child: Text(t.type)),
                      )
                      .toList(),
                  onChanged: _handleRecurrenceTypeChange,
                  validator: (val) =>
                      val == null ? "Selecciona un tipo de recurrencia" : null,
                ),

                if (selectedRecurrenceType?.id == 2)
                  Wrap(
                    spacing: 8,
                    children: List.generate(7, (i) {
                      final days = [
                        "Lun",
                        "Mar",
                        "Mié",
                        "Jue",
                        "Vie",
                        "Sáb",
                        "Dom",
                      ];
                      final dayNumber = i + 1;
                      final selected = selectedDaysOfWeek.contains(dayNumber);
                      return FilterChip(
                        label: Text(days[i]),
                        selected: selected,
                        onSelected: (_) => _toggleDayOfWeek(dayNumber),
                      );
                    }),
                  ),

                if (selectedRecurrenceType?.id == 3)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Selecciona el día del mes",
                      ),
                      controller: TextEditingController(text: "$dayOfMonth"),
                      onTap: () async {
                        final now = DateTime.now();
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: now,
                          firstDate: DateTime(now.year, now.month, 1),
                          lastDate: DateTime(
                            now.year,
                            now.month,
                            DateTime(now.year, now.month + 1, 0).day,
                          ),
                        );
                        if (picked != null) {
                          setState(() {
                            dayOfMonth = picked.day;
                            selectedDaysOfWeek = [];
                            workingDays = false;
                          });
                        }
                      },
                      validator: (val) => val == null || val.isEmpty
                          ? "Debes seleccionar un día del mes"
                          : null,
                    ),
                  ),
              ],

              SizedBox(height: 20),
              ElevatedButton(onPressed: _submitForm, child: Text("Agregar")),
            ],
          ),
        ),
      ),
    );
  }
}