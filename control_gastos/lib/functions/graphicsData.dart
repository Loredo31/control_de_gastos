import 'package:control_gastos/model/chartDataColumnTwo_model.dart';

List<ChartDataLine> generateChartDataForDate(List<Map<String, dynamic>> data) {
  final Map<String, List<double>> grouped = {};
  for (var item in data) {
    String key = item['date'];
    print(key);
    grouped[key] ??= [0.0, 0.0];

    if (!item['isentry']) {
      grouped[key]![0] += double.parse(item['amount'].toString());
    } else {
      grouped[key]![1] += double.parse(item['amount'].toString());
    }
  }
  final sortedKeys = grouped.keys.toList()..sort();
  return sortedKeys.map((k) => ChartDataLine(k, grouped[k]!)).toList();
}
