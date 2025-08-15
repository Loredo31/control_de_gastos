import 'package:control_gastos/model/chartDataColumnTwo_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';



class GraphicsLine extends StatelessWidget {
  final List<ChartDataLine> data;
  final List<String> typeColumn;
  final String? labelY;
  final String? labelX;

  const GraphicsLine({
    super.key,
    required this.data,
    required this.typeColumn,
    this.labelX,
    this.labelY,
  });

  @override
  Widget build(BuildContext context) {
    final int maxColumns = typeColumn.length;

    final List<SplineSeries<ChartDataLine, String>> seriesList =
        List.generate(maxColumns, (index) {
          return SplineSeries<ChartDataLine, String>(
            dataSource: data,
            xValueMapper: (ChartDataLine d, _) => d.x,
            yValueMapper: (ChartDataLine d, _) =>
                index < d.y.length ? d.y[index] : 0.0,
            name: typeColumn[index],
          );
        });

    return SfCartesianChart(
      primaryXAxis: CategoryAxis(
        title: AxisTitle(
          text: labelX ?? 'Vendedores',
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
      primaryYAxis: NumericAxis(
        minimum: 0,
        title: AxisTitle(
          text: labelY ?? 'Ventas (Cantidad)',
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
      legend: const Legend(isVisible: true),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: seriesList,
    );
  }
}
