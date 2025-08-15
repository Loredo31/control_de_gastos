import 'package:control_gastos/model/chartDataColumnTwo_model.dart';

List<ChartDataLine> generateChartDataForDate(List<Map<String, dynamic>> data) {
  final Map<String, List<double>> grouped = {};
  for (var item in data) {
    var nameEntrys = !item['isentry'] ? "entrada" : "salida";

    String key = item['date'] + nameEntrys;
    grouped[key] ??= [0.0, 0.0];
    grouped[key]![0] += double.parse(item['amount'].toString());
  }
  final sortedKeys = grouped.keys.toList()..sort();
  return sortedKeys.map((k) => ChartDataLine(k, grouped[k]!)).toList();
}
