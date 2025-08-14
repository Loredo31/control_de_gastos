import 'package:control_gastos/functions/graphicsData.dart';
import 'package:control_gastos/functions/monthFunctions.dart';
import 'package:control_gastos/model/chartDataColumnTwo_model.dart';
import 'package:control_gastos/services/apiRecords.dart';
import 'package:control_gastos/widgets/graphics_widget.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GraphicsLine(
          data: chartData,
          typeColumn: ["Salidas", "Entradas"],
          labelX: "Fecha",
          labelY: "Monto",
        ),
      ],
    );
  }
}
