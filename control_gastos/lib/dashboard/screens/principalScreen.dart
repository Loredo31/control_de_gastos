  import 'package:control_gastos/functions/graphicsData.dart';
  import 'package:control_gastos/functions/monthFunctions.dart';
  import 'package:control_gastos/model/chartDataColumnTwo_model.dart';
  import 'package:control_gastos/services/apiRecords.dart';
  import 'package:control_gastos/widgets/barMonth.dart';
  import 'package:control_gastos/widgets/graphics_widget.dart';
  import 'package:control_gastos/widgets/money_card_widget.dart';
  import 'package:flutter/material.dart';
  import 'package:intl/intl.dart';

  class Principalscreen extends StatefulWidget {
    const Principalscreen({super.key});

    @override
    State<Principalscreen> createState() => _PrincipalscreenState();
  }

  class _PrincipalscreenState extends State<Principalscreen> {
    int numberMonth = 0;
    String nameMonth = "";
    List<ChartDataLine> chartData = [];
    List<Map<String, dynamic>> processedData = [];
    bool showAll = false;

    @override
    void initState() {
      super.initState();
      getDataRecords(DateTime.now());
    }

    void getDataRecords(DateTime date) async {
      numberMonth = getNumberMonth(date);
      nameMonth = getNameMonth(numberMonth);

      var response = await Apirecords.getRecords(
        numberMonth,
        getNumberYear(date),
      );

      setState(() {
        processedData = response;
        chartData = generateChartDataForDate(processedData);
      });
    }

    void chanceDate(int month, int year) {
      final String fechaString = "$year-$month-01 00:00:00";
      final formato = "yyyy-MM-dd HH:mm:ss";
      final finalDate = DateFormat(formato).parse(fechaString);

      getDataRecords(finalDate);
    }

    Map<String, List<Map<String, dynamic>>> groupByDate(List<Map<String, dynamic>> data) {
      Map<String, List<Map<String, dynamic>>> grouped = {};
      final now = DateTime.now();

      for (var item in data) {
        DateTime fecha = DateTime.parse(item["date"]);
        String key;

        Duration diff = now.difference(fecha);
        if (diff.inDays == 0) {
          key = "Hoy";
        } else if (diff.inDays == 1) {
          key = "Ayer";
        } else if (diff.inDays < 7) {
          key = DateFormat("EEEE", "es_ES").format(fecha);
        } else {
          key = DateFormat("dd/MM/yyyy").format(fecha);
        }

        if (!grouped.containsKey(key)) {
          grouped[key] = [];
        }
        grouped[key]!.add(item);
      }

      return grouped;
    }

    @override
    Widget build(BuildContext context) {

      final groupedData = groupByDate(processedData);


      final limitedData = showAll
          ? processedData
          : (processedData.length > 5 ? processedData.sublist(0, 5) : processedData);


      final groupedLimitedData = groupByDate(limitedData);

      return Scaffold(
        backgroundColor: Color(0xFFE6F7E7),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BarMonth(
                onChanged: (month, year) {
                  chanceDate(month, year);
                },
              ),
              const SizedBox(height: 20),
              GraphicsLine(
                data: chartData,
                typeColumn: ["Salidas", "Entradas"],
                labelX: "Fecha",
                labelY: "Monto",
              ),
              const SizedBox(height: 20),

              ...groupedLimitedData.entries.map((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        entry.key,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    ...entry.value.map((registro) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: MoneyCard(
                          title: registro["concept"],
                          amount: double.parse(registro["amount"]),
                          isEntry: registro["isentry"],
                        ),
                      );
                    }).toList(),
                  ],
                );
              }).toList(),

              const SizedBox(height: 10),

              if (processedData.length > 5)
                TextButton(
                  onPressed: () {
                    setState(() {
                      showAll = !showAll;
                    });
                  },
                  child: Text(showAll ? "Ver menos" : "Ver más"),
                ),
            ],
          ),
        ),
      );
    }
  }
