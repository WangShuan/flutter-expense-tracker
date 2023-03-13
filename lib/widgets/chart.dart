import 'package:flutter/material.dart';
import 'package:flutter_expense_tracker/widgets/chart_bar.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTx;

  const Chart(this.recentTx);
  List<Map<String, Object>> get groupedTxVal {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      var totalSum = 0;

      for (var i = 0; i < recentTx.length; i++) {
        if (recentTx[i].date.day == weekDay.day &&
            recentTx[i].date.month == weekDay.month &&
            recentTx[i].date.year == weekDay.year) {
          totalSum += recentTx[i].amount;
        }
      }
      return {
        'day': DateFormat('E', 'zh_TW').format(weekDay),
        'amount': totalSum,
      };
    }).reversed.toList();
  }

  int get totalSpending {
    return groupedTxVal.fold(0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: Theme.of(context).primaryColorLight,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: groupedTxVal.map((e) {
              return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(
                    e['day'],
                    e['amount'],
                    totalSpending == 0
                        ? 0
                        : (e['amount'] as int) / totalSpending),
              );
            }).toList()),
      ),
    );
  }
}
