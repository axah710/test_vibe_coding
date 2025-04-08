import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final double amount;
  final Color? amountColor;

  const SummaryCard({
    super.key,
    required this.title,
    required this.amount,
    this.amountColor,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              currencyFormat.format(amount),
              style: TextStyle(fontSize: 20, color: amountColor),
            ),
          ],
        ),
      ),
    );
  }
}
