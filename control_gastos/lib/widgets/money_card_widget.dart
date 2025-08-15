import 'package:flutter/material.dart';

class MoneyCard extends StatelessWidget {
  final String title;
  final double amount;
  final bool isEntry;

  const MoneyCard({
    super.key,
    required this.title,
    required this.amount,
    this.isEntry = false,
  });

  @override
  Widget build(BuildContext context) {
    // Color según isEntry
    final Color bgColor = isEntry ? Color(0xFFA2DFA3) : Color.fromARGB(255, 196, 43, 29);

    // Tamaño fijo para todos
    final double height = 60;
    final double fontSizeTitle = 18;
    final double fontSizeAmount = 20;

    return Card(
      color: bgColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Container(
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Título a la izquierda
            Text(
              title,
              style: TextStyle(
                fontSize: fontSizeTitle,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            // Monto a la derecha
            Text(
              "\$${amount.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: fontSizeAmount,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
