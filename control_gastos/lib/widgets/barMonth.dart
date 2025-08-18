import 'package:control_gastos/functions/monthFunctions.dart';
import 'package:flutter/material.dart';

class BarMonth extends StatefulWidget {
  final void Function(int month, int year)? onChanged;

  const BarMonth({super.key, this.onChanged});

  @override
  State<BarMonth> createState() => _BarMonthState();
}

class _BarMonthState extends State<BarMonth> {
  late int numberMonth;
  late String nameMonth;
  late int year;

  @override
  void initState() {
    super.initState();
    numberMonth = getNumberMonth(DateTime.now());
    nameMonth = getNameMonth(numberMonth);
    year = getNumberYear(DateTime.now());
  }

  void changeMonth(bool next) {
    setState(() {
      if (next) {
        numberMonth++;
        if (numberMonth > 12) {
          numberMonth = 1;
          year++;
        }
      } else {
        numberMonth--;
        if (numberMonth < 1) {
          numberMonth = 12;
          year--;
        }
      }
      nameMonth = getNameMonth(numberMonth);
      widget.onChanged!(numberMonth, year);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => changeMonth(false),
          icon: const Icon(Icons.arrow_left),
        ),
        Text(
          "$nameMonth $year",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        IconButton(
          onPressed: () => changeMonth(true),
          icon: const Icon(Icons.arrow_right),
        ),
      ],
    );
  }
}
