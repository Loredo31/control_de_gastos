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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            ...processedData.map((registro) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: MoneyCard(
                  title: registro["concept"],
                  amount: double.parse(registro["amount"]),
                  isEntry: registro["isentry"], 
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}
